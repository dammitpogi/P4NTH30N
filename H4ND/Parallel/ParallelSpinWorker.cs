using System.Diagnostics;
using System.Threading.Channels;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Navigation;
using P4NTH30N.H4ND.Navigation.Retry;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// ARCH-047/055/081/098: Consumer — reads SignalWorkItems from the channel and executes
/// the full signal lifecycle: lock credential → login → query balances → spin → update → logout → unlock.
/// Each worker maintains its own CDP session.
/// ARCH-055: Self-healing via SessionRenewalService on 403/401, config-driven selectors via GameSelectorConfig.
/// ARCH-081: Chrome profile isolation via ChromeProfileManager, login verification via balance > 0.
/// ARCH-098: Navigation map integration — loads recorder step-config for login/logout/spin automation.
/// </summary>
public sealed class ParallelSpinWorker
{
	private readonly string _workerId;
	private readonly int _workerIndex;
	private readonly ChannelReader<SignalWorkItem> _reader;
	private readonly IUnitOfWork _uow;
	private readonly SpinExecution _spinExecution;
	private CdpConfig _cdpConfig;
	private readonly ParallelMetrics _metrics;
	private readonly SessionRenewalService? _sessionRenewal;
	private readonly GameSelectorConfig? _selectorConfig;
	private readonly CdpResourceCoordinator _resourceCoordinator;
	private readonly ChromeProfileManager? _profileManager;
	private readonly NavigationMapLoader? _mapLoader;
	private readonly IStepExecutor? _stepExecutor;
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
		CdpResourceCoordinator? resourceCoordinator = null,
		ChromeProfileManager? profileManager = null,
		NavigationMapLoader? mapLoader = null,
		IStepExecutor? stepExecutor = null,
		int maxSignalsBeforeRestart = 100)
	{
		_workerId = workerId ?? throw new ArgumentException("Worker ID cannot be null or empty", nameof(workerId));
		_workerIndex = ParseWorkerIndex(workerId);
		_reader = reader;
		_uow = uow;
		_spinExecution = spinExecution;
		_cdpConfig = cdpConfig;
		_metrics = metrics;
		_sessionRenewal = sessionRenewal;
		_selectorConfig = selectorConfig;
		_resourceCoordinator = resourceCoordinator ?? new CdpResourceCoordinator(1);
		_profileManager = profileManager;
		_mapLoader = mapLoader;
		_stepExecutor = stepExecutor;
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
			// ARCH-081: Initialize Chrome with isolated profile if manager available
			cdp = await InitializeCdpWithProfileAsync(ct);
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

					// ARCH-081: Restart Chrome with profile if manager available
					if (_profileManager != null)
					{
						_cdpConfig = await _profileManager.RestartWorkerAsync(_workerIndex, ct);
					}

					cdp = await CreateCdpSessionAsync(ct);
					if (cdp == null)
					{
						Console.WriteLine($"[Worker-{_workerId}] CDP reconnect failed — exiting");
						break;
					}
					_signalsProcessed = 0;
				}

				// ARCH-081: Health check before processing
				if (!await EnsureChromeHealthyAsync(cdp, ct))
				{
					Console.WriteLine($"[Worker-{_workerId}] Chrome unhealthy — restarting");
					cdp.Dispose();
					cdp = await InitializeCdpWithProfileAsync(ct);
					if (cdp == null) break;
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
			var credentialKey = $"{credential.House}/{credential.Game}/{credential.Username}";
			await _resourceCoordinator.ExecuteForCredentialAsync(
				credentialKey,
				async innerCt =>
				{
					_uow.Credentials.Lock(credential);

					bool loginOk = await _resourceCoordinator.ExecuteCdpAsync(loginCt => ExecuteLoginAsync(cdp, credential, loginCt), innerCt);

					if (!loginOk)
					{
						Console.WriteLine($"[Worker-{_workerId}] Login failed for {credential.Username}@{credential.Game}");
						_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, "login_failed");

						if (_sessionRenewal != null && SessionRenewalService.IsSessionFailure(new Exception("login failed")))
						{
							await AttemptSelfHealingAsync(credential.Game, innerCt);
						}
						return true;
					}

					_uow.Signals.Acknowledge(signal);

					VisionCommand spinCommand = new()
					{
						CommandType = VisionCommandType.Spin,
						TargetUsername = credential.Username,
						TargetGame = credential.Game,
						TargetHouse = credential.House,
						Confidence = 1.0,
						Reason = $"Parallel P{(int)signal.Priority} for {credential.House}/{credential.Game}",
					};

					bool spinOk = await _resourceCoordinator.ExecuteCdpAsync(spinCt => _spinExecution.ExecuteSpinAsync(spinCommand, cdp, signal, credential, spinCt), innerCt);

					sw.Stop();
					_metrics.RecordSpinResult(_workerId, spinOk, sw.Elapsed, spinOk ? null : "spin_failed");
					_signalsProcessed++;

					Console.WriteLine($"[Worker-{_workerId}] Completed {credential.Username}@{credential.Game} in {sw.ElapsedMilliseconds}ms (spin={spinOk})");

					await _resourceCoordinator.ExecuteCdpAsync(logoutCt => ExecuteLogoutAsync(cdp, credential, logoutCt), innerCt);
					return true;
				},
				ct);
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

	/// <summary>
	/// ARCH-081: Initialize CDP with Chrome profile isolation if manager is available.
	/// Falls back to direct CDP connection if no profile manager.
	/// </summary>
	private async Task<CdpClient?> InitializeCdpWithProfileAsync(CancellationToken ct)
	{
		if (_profileManager != null)
		{
			try
			{
				Console.WriteLine($"[Worker-{_workerId}] Launching isolated Chrome profile...");
				_cdpConfig = await _profileManager.LaunchWithProfileAsync(_workerIndex, ct);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[Worker-{_workerId}] Chrome profile launch failed: {ex.Message}");
				_metrics.RecordWorkerError(_workerId, $"profile_launch_failed:{ex.Message}");
				return null;
			}
		}

		return await CreateCdpSessionAsync(ct);
	}

	/// <summary>
	/// ARCH-081: Health check — verify Chrome is responsive and page is loaded.
	/// </summary>
	private async Task<bool> EnsureChromeHealthyAsync(CdpClient cdp, CancellationToken ct)
	{
		try
		{
			// Check if profile manager reports healthy
			if (_profileManager != null && !await _profileManager.IsHealthyAsync(_workerIndex, ct))
				return false;

			// Check if CDP can evaluate a simple expression
			string? readyState = await cdp.EvaluateAsync<string>("document.readyState", ct);
			return readyState != null;
		}
		catch
		{
			_metrics.RecordWorkerError(_workerId, "chrome_health_check_failed");
			Console.WriteLine($"[Worker-{_workerId}] Chrome health check failed");
			return false;
		}
	}

	/// <summary>
	/// ARCH-098: Execute login using NavigationMap if available, with fallback to hardcoded CdpGameActions.
	/// Navigation map is loaded from step-config-{platform}.json via NavigationMapLoader.
	/// </summary>
	private async Task<bool> ExecuteLoginAsync(CdpClient cdp, Credential credential, CancellationToken ct)
	{
		// Try navigation map first
		if (_mapLoader != null && _stepExecutor != null)
		{
			try
			{
				var map = await _mapLoader.LoadAsync(credential.Game, ct);
				if (map != null && map.GetStepsForPhase("Login").Any())
				{
					var context = new StepExecutionContext
					{
						CdpClient = cdp,
						Platform = credential.Game,
						Username = credential.Username,
						Password = credential.Password,
						WorkerId = _workerId,
						Variables = new() { ["username"] = credential.Username, ["password"] = credential.Password },
					};

					var loginResult = await _stepExecutor.ExecutePhaseAsync(map, "Login", context, ct);
					if (loginResult.Success)
					{
						Console.WriteLine($"[Worker-{_workerId}] ARCH-098 NavigationMap login completed for {credential.Username}@{credential.Game}");
						return await CdpGameActions.VerifyLoginSuccessAsync(cdp, credential.Username, credential.Game, ct);
					}

					Console.WriteLine($"[Worker-{_workerId}] NavigationMap login failed: {loginResult.ErrorMessage} — not falling back to hardcoded to avoid duplicate click paths");
					return false;
				}

				if (map != null)
				{
					Console.WriteLine($"[Worker-{_workerId}] NavigationMap loaded but no Login phase; using hardcoded fallback");
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[Worker-{_workerId}] NavigationMap login error, falling back: {ex.Message}");
			}
		}

		// Fallback to hardcoded CdpGameActions
		return credential.Game switch
		{
			"FireKirin" => await CdpGameActions.LoginFireKirinAsync(cdp, credential.Username, credential.Password),
			"OrionStars" => await CdpGameActions.LoginOrionStarsAsync(cdp, credential.Username, credential.Password),
			_ => throw new Exception($"Unrecognized game: '{credential.Game}'"),
		};
	}

	/// <summary>
	/// ARCH-098: Execute logout using NavigationMap if available, with fallback to hardcoded CdpGameActions.
	/// </summary>
	private async Task ExecuteLogoutAsync(CdpClient cdp, Credential credential, CancellationToken ct)
	{
		// Try navigation map first
		if (_mapLoader != null && _stepExecutor != null)
		{
			try
			{
				var map = await _mapLoader.LoadAsync(credential.Game, ct);
				if (map != null && map.GetStepsForPhase("Logout").Any())
				{
					var context = new StepExecutionContext
					{
						CdpClient = cdp,
						Platform = credential.Game,
						Username = credential.Username,
						WorkerId = _workerId,
					};

					var result = await _stepExecutor.ExecutePhaseAsync(map, "Logout", context, ct);
					if (result.Success)
					{
						Console.WriteLine($"[Worker-{_workerId}] ARCH-098 NavigationMap logout completed");
						return;
					}

					Console.WriteLine($"[Worker-{_workerId}] NavigationMap logout failed, falling back: {result.ErrorMessage}");
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[Worker-{_workerId}] NavigationMap logout error, falling back: {ex.Message}");
			}
		}

		// Fallback to hardcoded CdpGameActions
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

	/// <summary>
	/// Parses worker ID format "W00", "W01", etc. into numeric index.
	/// Throws ArgumentException on invalid format — fail fast, no silent defaults.
	/// </summary>
	private static int ParseWorkerIndex(string workerId)
	{
		if (string.IsNullOrEmpty(workerId))
			throw new ArgumentException("Worker ID cannot be null or empty", nameof(workerId));

		if (workerId.Length >= 2 &&
			workerId[0] == 'W' &&
			int.TryParse(workerId.Substring(1), out int index))
		{
			return index;
		}

		throw new ArgumentException($"Invalid worker ID format: '{workerId}'. Expected format: 'W00', 'W01', etc.", nameof(workerId));
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
