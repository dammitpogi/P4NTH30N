using System.Diagnostics;
using System.Threading.Channels;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// ARCH-047/055: Consumer — reads SignalWorkItems from the channel and executes
/// the full signal lifecycle: lock credential → login → query balances → spin → update → logout → unlock.
/// Each worker maintains its own CDP session.
/// ARCH-055: Self-healing via SessionRenewalService on 403/401, config-driven selectors via GameSelectorConfig.
/// </summary>
public sealed class ParallelSpinWorker
{
	private readonly string _workerId;
	private readonly ChannelReader<SignalWorkItem> _reader;
	private readonly IUnitOfWork _uow;
	private readonly SpinExecution _spinExecution;
	private readonly CdpConfig _cdpConfig;
	private readonly ParallelMetrics _metrics;
	private readonly SessionRenewalService? _sessionRenewal;
	private readonly GameSelectorConfig? _selectorConfig;
	private readonly int _maxSignalsBeforeRestart;
	private int _signalsProcessed;

	public string WorkerId => _workerId;
	public int SignalsProcessed => _signalsProcessed;

	public ParallelSpinWorker(
		string workerId,
		ChannelReader<SignalWorkItem> reader,
		IUnitOfWork uow,
		SpinExecution spinExecution,
		CdpConfig cdpConfig,
		ParallelMetrics metrics,
		SessionRenewalService? sessionRenewal = null,
		GameSelectorConfig? selectorConfig = null,
		int maxSignalsBeforeRestart = 100)
	{
		_workerId = workerId;
		_reader = reader;
		_uow = uow;
		_spinExecution = spinExecution;
		_cdpConfig = cdpConfig;
		_metrics = metrics;
		_sessionRenewal = sessionRenewal;
		_selectorConfig = selectorConfig;
		_maxSignalsBeforeRestart = maxSignalsBeforeRestart;
	}

	/// <summary>
	/// Continuously reads work items from the channel and processes them.
	/// Restarts after maxSignalsBeforeRestart to prevent memory leaks.
	/// </summary>
	public async Task RunAsync(CancellationToken ct)
	{
		Console.WriteLine($"[Worker-{_workerId}] Started");

		CdpClient? cdp = null;
		try
		{
			cdp = await CreateCdpSessionAsync(ct);
			if (cdp == null)
			{
				Console.WriteLine($"[Worker-{_workerId}] CDP connection failed — exiting");
				_metrics.RecordWorkerError(_workerId, "cdp_connect_failed");
				return;
			}

			await foreach (var workItem in _reader.ReadAllAsync(ct))
			{
				if (_signalsProcessed >= _maxSignalsBeforeRestart)
				{
					Console.WriteLine($"[Worker-{_workerId}] Restart threshold reached ({_signalsProcessed} signals) — cycling CDP");
					cdp.Dispose();
					cdp = await CreateCdpSessionAsync(ct);
					if (cdp == null)
					{
						Console.WriteLine($"[Worker-{_workerId}] CDP reconnect failed — exiting");
						break;
					}
					_signalsProcessed = 0;
				}

				await ProcessWorkItemAsync(workItem, cdp, ct);
			}
		}
		catch (OperationCanceledException)
		{
			// Normal shutdown
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[Worker-{_workerId}] Fatal error: {ex.Message}");
			_metrics.RecordWorkerError(_workerId, ex.Message);
		}
		finally
		{
			cdp?.Dispose();
			Console.WriteLine($"[Worker-{_workerId}] Stopped (processed {_signalsProcessed} signals)");
		}
	}

	private async Task ProcessWorkItemAsync(SignalWorkItem workItem, CdpClient cdp, CancellationToken ct)
	{
		var signal = workItem.Signal;
		var credential = workItem.Credential;
		var sw = Stopwatch.StartNew();

		Console.WriteLine($"[Worker-{_workerId}] Processing {workItem}");

		// ARCH-055: Resolve selectors via GameSelectorConfig if available
		GameSelectors? selectors = null;
		if (_selectorConfig != null)
		{
			selectors = _selectorConfig.GetSelectors(credential.Game);
			Console.WriteLine($"[Worker-{_workerId}] Using config-driven selectors for {credential.Game} " +
				$"(PageReadyChecks={selectors.PageReadyChecks.Count}, JackpotExprs={selectors.JackpotTierExpressions.Count})");
		}

		try
		{
			// Lock credential
			_uow.Credentials.Lock(credential);

			// Login via CDP
			bool loginOk = credential.Game switch
			{
				"FireKirin" => await CdpGameActions.LoginFireKirinAsync(cdp, credential.Username, credential.Password),
				"OrionStars" => await CdpGameActions.LoginOrionStarsAsync(cdp, credential.Username, credential.Password),
				_ => throw new Exception($"Unrecognized game: '{credential.Game}'"),
			};

			if (!loginOk)
			{
				Console.WriteLine($"[Worker-{_workerId}] Login failed for {credential.Username}@{credential.Game}");
				_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, "login_failed");

				// ARCH-055: Attempt self-healing on login failure
				if (_sessionRenewal != null && SessionRenewalService.IsSessionFailure(new Exception("login failed")))
				{
					await AttemptSelfHealingAsync(credential.Game, ct);
				}
				return;
			}

			// Acknowledge signal
			_uow.Signals.Acknowledge(signal);

			// Execute spin
			VisionCommand spinCommand = new()
			{
				CommandType = VisionCommandType.Spin,
				TargetUsername = credential.Username,
				TargetGame = credential.Game,
				TargetHouse = credential.House,
				Confidence = 1.0,
				Reason = $"Parallel P{(int)signal.Priority} for {credential.House}/{credential.Game}",
			};

			bool spinOk = await _spinExecution.ExecuteSpinAsync(spinCommand, cdp, signal, credential, ct);

			sw.Stop();
			_metrics.RecordSpinResult(_workerId, spinOk, sw.Elapsed, spinOk ? null : "spin_failed");
			_signalsProcessed++;

			Console.WriteLine($"[Worker-{_workerId}] Completed {credential.Username}@{credential.Game} in {sw.ElapsedMilliseconds}ms (spin={spinOk})");

			// Logout
			switch (credential.Game)
			{
				case "FireKirin":
					await CdpGameActions.LogoutFireKirinAsync(cdp);
					break;
				case "OrionStars":
					await CdpGameActions.LogoutOrionStarsAsync(cdp);
					break;
			}
		}
		catch (Exception ex) when (_sessionRenewal != null && SessionRenewalService.IsSessionFailure(ex))
		{
			// ARCH-055: Self-healing on 403/401 — auto-renew session
			sw.Stop();
			Console.WriteLine($"[Worker-{_workerId}] AUTH FAILURE for {credential.Username}@{credential.Game}: {ex.Message}");
			_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, $"auth_failure:{ex.Message}");

			bool healed = await AttemptSelfHealingAsync(credential.Game, ct);
			if (healed && workItem.CanRetry)
			{
				workItem.RetryCount++;
				_uow.Signals.ReleaseClaim(signal);
				Console.WriteLine($"[Worker-{_workerId}] Session renewed — released signal for retry ({workItem.RetryCount}/{SignalWorkItem.MaxRetries})");
			}
		}
		catch (Exception ex)
		{
			sw.Stop();
			Console.WriteLine($"[Worker-{_workerId}] Error processing {credential.Username}@{credential.Game}: {ex.Message}");
			_uow.Errors.Insert(
				ErrorLog.Create(ErrorType.SystemError, $"ParallelWorker-{_workerId}", ex.Message, ErrorSeverity.High)
			);
			_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, ex.Message);

			// Release claim so another worker can pick it up
			if (workItem.CanRetry)
			{
				workItem.RetryCount++;
				_uow.Signals.ReleaseClaim(signal);
				Console.WriteLine($"[Worker-{_workerId}] Released claim on signal {signal._id} for retry ({workItem.RetryCount}/{SignalWorkItem.MaxRetries})");
			}
		}
		finally
		{
			// Always unlock credential
			try
			{
				_uow.Credentials.Unlock(credential);
			}
			catch (Exception unlockEx)
			{
				Console.WriteLine($"[Worker-{_workerId}] CRITICAL: Failed to unlock credential {credential.Username}: {unlockEx.Message}");
			}
		}
	}

	/// <summary>
	/// ARCH-055: Attempts session renewal and platform fallback on auth failures.
	/// Returns true if healing succeeded.
	/// </summary>
	private async Task<bool> AttemptSelfHealingAsync(string platform, CancellationToken ct)
	{
		if (_sessionRenewal == null) return false;

		_metrics.IncrementRenewalAttempts();
		Console.WriteLine($"[Worker-{_workerId}] Attempting session renewal for {platform}...");

		var renewResult = await _sessionRenewal.RenewSessionAsync(platform, ct);
		if (renewResult.Success)
		{
			_metrics.IncrementRenewalSuccesses();
			Console.WriteLine($"[Worker-{_workerId}] Session renewed for {platform} (balance: ${renewResult.Balance:F2})");
			return true;
		}

		// Try platform fallback
		Console.WriteLine($"[Worker-{_workerId}] Renewal failed — trying platform fallback...");
		var fallback = await _sessionRenewal.FindWorkingPlatformAsync(ct);
		if (fallback.Success)
		{
			_metrics.IncrementRenewalSuccesses();
			Console.WriteLine($"[Worker-{_workerId}] Platform fallback succeeded: {fallback.Platform}");
			return true;
		}

		_metrics.IncrementRenewalFailures();
		_metrics.IncrementCriticalFailures();
		Console.WriteLine($"[Worker-{_workerId}] ALL PLATFORMS FAILED — worker entering backoff");
		return false;
	}

	private async Task<CdpClient?> CreateCdpSessionAsync(CancellationToken ct)
	{
		for (int attempt = 1; attempt <= 3; attempt++)
		{
			try
			{
				var cdp = new CdpClient(_cdpConfig);
				if (await cdp.ConnectAsync())
				{
					Console.WriteLine($"[Worker-{_workerId}] CDP connected (attempt {attempt})");
					return cdp;
				}
				cdp.Dispose();
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[Worker-{_workerId}] CDP connect attempt {attempt} failed: {ex.Message}");
			}

			if (attempt < 3)
				await Task.Delay(TimeSpan.FromSeconds(attempt * 2), ct);
		}
		return null;
	}

}
