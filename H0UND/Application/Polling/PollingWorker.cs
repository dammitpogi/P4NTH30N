using System;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H0UND.Infrastructure.Polling;
using P4NTHE0N.Services;

namespace P4NTHE0N.H0UND.Application.Polling;

public sealed class PollingWorker
{
	private readonly BalanceProviderFactory _providerFactory;
	private readonly IErrorEvidence _errors;

	public PollingWorker(BalanceProviderFactory providerFactory, IErrorEvidence? errors = null)
	{
		_providerFactory = providerFactory;
		_errors = errors ?? NoopErrorEvidence.Instance;
	}

	public (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(Credential credential, IUnitOfWork uow)
	{
		using ErrorScope pollingScope = _errors.BeginScope(
			"H0UND.PollingWorker",
			"GetBalancesWithRetry",
			new Dictionary<string, object>
			{
				["house"] = credential.House,
				["game"] = credential.Game,
				["credentialId"] = credential._id.ToString(),
			});

		(double Balance, double Grand, double Major, double Minor, double Mini) ExecuteQuery()
		{
			int networkAttempts = 0;
			while (true)
			{
				try
				{
					return QueryBalances(credential, uow);
				}
				catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
				{
					throw;
				}
				catch (Exception ex)
				{
					networkAttempts++;
					if (ShouldSample($"H0UND-POLL-RETRY-{credential._id}-{networkAttempts}", 4))
					{
						_errors.CaptureWarning(
							"H0UND-POLL-RETRY-001",
							"Balance query failed, retrying",
							context: new Dictionary<string, object>
							{
								["attempt"] = networkAttempts,
								["house"] = credential.House,
								["game"] = credential.Game,
							},
							evidence: new { ex.Message, exceptionType = ex.GetType().FullName });
					}

					if (networkAttempts >= 3)
					{
						_errors.Capture(
							ex,
							"H0UND-POLL-RETRY-ERR-001",
							"Balance query retries exhausted",
							context: new Dictionary<string, object>
							{
								["attempts"] = networkAttempts,
								["house"] = credential.House,
								["game"] = credential.Game,
							});
						throw;
					}
					Dashboard.AddLog($"QueryBalances failed (Attempt {networkAttempts}): {ex.Message}. Retrying...", "yellow");
					Dashboard.Render();
					const int baseDelayMs = 2000;
					const int maxDelayMs = 30000;
					int exponentialDelay = (int)Math.Min(maxDelayMs, baseDelayMs * Math.Pow(2, networkAttempts - 1));
					int jitter = Random.Shared.Next(0, 1000);
					int delayMs = Math.Min(maxDelayMs, exponentialDelay + jitter);
					Thread.Sleep(delayMs);
				}
			}
		}

		int grandChecked = 0;
		(double Balance, double Grand, double Major, double Minor, double Mini) balances = ExecuteQuery();
		double currentGrand = balances.Grand;
		while (currentGrand.Equals(0))
		{
			grandChecked++;
			if (ShouldSample($"H0UND-POLL-GRANDZERO-{credential._id}-{grandChecked}", 4))
			{
				_errors.CaptureWarning(
					"H0UND-POLL-GRANDZERO-001",
					"Grand jackpot returned zero during retry guard window",
					context: new Dictionary<string, object>
					{
						["attempt"] = grandChecked,
						["game"] = credential.Game,
						["house"] = credential.House,
					});
			}

			Dashboard.AddLog($"Grand jackpot is 0 for {credential.Game}, retrying attempt {grandChecked}/8", "yellow");
			Dashboard.Render();
			Thread.Sleep(250);
			if (grandChecked > 8)
			{
				_errors.CaptureWarning(
					"H0UND-POLL-GRANDZERO-GUARD-001",
					"Grand-zero retry guard exceeded; treating as valid zero",
					context: new Dictionary<string, object>
					{
						["attempts"] = grandChecked,
						["game"] = credential.Game,
						["house"] = credential.House,
					});

				ProcessEvent alert = ProcessEvent.Log("H0UND", $"Grand check signalled an Extension Failure for {credential.Game}");
				Dashboard.AddLog($"Checking Grand on {credential.Game} failed at {grandChecked} attempts - treating as valid zero value.", "red");
				Dashboard.Render();
				uow.ProcessEvents.Insert(alert.Record(credential));
				break;
			}
			Dashboard.AddLog($"Retrying balance query for {credential.Game} (attempt {grandChecked})", "yellow");
			Dashboard.Render();
			balances = ExecuteQuery();
			currentGrand = balances.Grand;
		}

		return balances;
	}

	private (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalances(Credential credential, IUnitOfWork uow)
	{
		Random random = new();
		int delayMs = random.Next(3000, 5001);
		Thread.Sleep(delayMs);

		try
		{
			IBalanceProvider provider = _providerFactory.GetProvider(credential.Game);
			(double Balance, double Grand, double Major, double Minor, double Mini) balances = provider.GetBalances(credential.Username, credential.Password);

			Dashboard.AddLog(
				$"{credential.Game} - {credential.House} - {credential.Username} - ${balances.Balance:F2} - [{balances.Grand:F2}, {balances.Major:F2}, {balances.Minor:F2}, {balances.Mini:F2}]",
				"green"
			);
			return balances;
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
		{
			_errors.CaptureWarning(
				"H0UND-POLL-SUSPENDED-001",
				"Provider reported suspended account",
				context: new Dictionary<string, object>
				{
					["house"] = credential.House,
					["game"] = credential.Game,
					["credentialId"] = credential._id.ToString(),
				},
				evidence: new { ex.Message, exceptionType = ex.GetType().FullName });

			Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}. Marking as banned.", "red");
			credential.Banned = true;
			uow.Credentials.Upsert(credential);
			throw;
		}
	}

	private static bool ShouldSample(string key, int modulus)
	{
		if (modulus <= 1)
		{
			return true;
		}

		unchecked
		{
			int hash = 17;
			foreach (char c in key)
			{
				hash = hash * 31 + c;
			}

			int bucket = Math.Abs(hash % modulus);
			return bucket == 0;
		}
	}

	public static void RecordRetryGuardrailExceeded(IErrorEvidence errors, Credential credential, int attempts)
	{
		errors.Capture(
			new TimeoutException("Polling retry guardrail exceeded"),
			"H0UND-POLL-RETRY-ERR-001",
			"Balance query retries exhausted",
			context: new Dictionary<string, object>
			{
				["attempts"] = attempts,
				["house"] = credential.House,
				["game"] = credential.Game,
			});
	}
}
