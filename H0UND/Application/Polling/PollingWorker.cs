using System;
using P4NTH30N.C0MMON;
using P4NTH30N.H0UND.Infrastructure.Polling;
using P4NTH30N.Services;

namespace P4NTH30N.H0UND.Application.Polling;

public sealed class PollingWorker
{
	private readonly BalanceProviderFactory _providerFactory;

	public PollingWorker(BalanceProviderFactory providerFactory)
	{
		_providerFactory = providerFactory;
	}

	public (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(Credential credential, IUnitOfWork uow)
	{
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
					if (networkAttempts >= 3)
						throw;
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
			Dashboard.AddLog($"Grand jackpot is 0 for {credential.Game}, retrying attempt {grandChecked}/8", "yellow");
			Dashboard.Render();
			Thread.Sleep(250);
			if (grandChecked > 8)
			{
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
			Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}. Marking as banned.", "red");
			credential.Banned = true;
			uow.Credentials.Upsert(credential);
			throw;
		}
	}
}
