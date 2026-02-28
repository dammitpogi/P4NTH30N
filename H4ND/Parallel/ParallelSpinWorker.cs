using System.Diagnostics;
using System.Security.Cryptography;
using System.Threading.Channels;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H4ND.Navigation;
using P4NTHE0N.H4ND.Navigation.Retry;
using P4NTHE0N.H4ND.Services;
using CommonErrorSeverity = P4NTHE0N.C0MMON.ErrorSeverity;

namespace P4NTHE0N.H4ND.Parallel;

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
	private readonly IErrorEvidence _errors;
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
		IErrorEvidence? errors = null,
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
		_errors = errors ?? NoopErrorEvidence.Instance;
		_maxSignalsBeforeRestart = maxSignalsBeforeRestart;
	}

	/// <summary>
	/// Continuously reads work items from the channel and processes them.
	/// Restarts after maxSignalsBeforeRestart to prevent memory leaks.
	/// </summary>
	public async Task RunAsync(CancellationToken ct)
	{
		using ErrorScope workerScope = _errors.BeginScope(
			"ParallelSpinWorker",
			"RunAsync",
			new Dictionary<string, object>
			{
				["workerId"] = _workerId,
				["workerIndex"] = _workerIndex,
			});

		Console.WriteLine($"[Worker-{_workerId}] Started");

		CdpClient? cdp = null;
		try
		{
			// ARCH-081: Initialize Chrome with isolated profile if manager available
			cdp = await InitializeCdpWithProfileAsync(ct);
			if (cdp == null)
			{
				_errors.CaptureWarning(
					"H4ND-PAR-CDP-INIT-001",
					"CDP connection failed during worker startup",
					context: new Dictionary<string, object>
					{
						["workerId"] = _workerId,
					});

				Console.WriteLine($"[Worker-{_workerId}] CDP connection failed — exiting");
				_metrics.RecordWorkerError(_workerId, "cdp_connect_failed");
				return;
			}

			await foreach (var workItem in _reader.ReadAllAsync(ct))
			{
				if (_signalsProcessed >= _maxSignalsBeforeRestart)
				{
					Console.WriteLine($"[Worker-{_workerId}] Restart threshold reached ({_signalsProcessed} signals) — cycling CDP");
					try
					{
						cdp.Dispose();
					}
					catch (Exception ex)
					{
						_errors.CaptureWarning(
							"H4ND-PAR-CDP-DISPOSE-001",
							"CDP dispose failed during worker recycle",
							context: new Dictionary<string, object>
							{
								["workerId"] = _workerId,
							},
							evidence: new { ex.Message, exceptionType = ex.GetType().FullName });
					}

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
					try
					{
						cdp.Dispose();
					}
					catch (Exception ex)
					{
						_errors.CaptureWarning(
							"H4ND-PAR-CDP-DISPOSE-002",
							"CDP dispose failed after health check failure",
							context: new Dictionary<string, object>
							{
								["workerId"] = _workerId,
							},
							evidence: new { ex.Message, exceptionType = ex.GetType().FullName });
					}

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
			_errors.Capture(
				ex,
				"H4ND-PAR-WORKER-001",
				"Fatal worker error",
				context: new Dictionary<string, object>
				{
					["workerId"] = _workerId,
					["signalsProcessed"] = _signalsProcessed,
				});

			Console.WriteLine($"[Worker-{_workerId}] Fatal error: {ex.Message}");
			_metrics.RecordWorkerError(_workerId, ex.Message);
		}
		finally
		{
			if (cdp != null)
			{
				try
				{
					cdp.Dispose();
				}
				catch (Exception ex)
				{
					_errors.CaptureWarning(
						"H4ND-PAR-CDP-DISPOSE-003",
						"CDP dispose failed during worker finalization",
						context: new Dictionary<string, object>
						{
							["workerId"] = _workerId,
						},
						evidence: new { ex.Message, exceptionType = ex.GetType().FullName });
				}
			}

			Console.WriteLine($"[Worker-{_workerId}] Stopped (processed {_signalsProcessed} signals)");
		}
	}

	private async Task ProcessWorkItemAsync(SignalWorkItem workItem, CdpClient cdp, CancellationToken ct)
	{
		var signal = workItem.Signal;
		var credential = workItem.Credential;
		var sw = Stopwatch.StartNew();

		using ErrorScope itemScope = _errors.BeginScope(
			"ParallelSpinWorker",
			"ProcessWorkItem",
			new Dictionary<string, object>
			{
				["workerId"] = _workerId,
				["signalId"] = signal._id.ToString(),
				["credentialId"] = credential._id.ToString(),
				["game"] = credential.Game,
				["house"] = credential.House,
				["retryCount"] = workItem.RetryCount,
			});

		Console.WriteLine($"[Worker-{_workerId}] Processing {workItem}");

		if (signal.Acknowledged)
		{
			_errors.CaptureWarning(
				"H4ND-PAR-ACK-OBS-001",
				"Signal already acknowledged before parallel worker processing",
				context: BuildWorkItemContext(workItem),
				evidence: SnapshotSignal(signal));
		}

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
						_errors.CaptureWarning(
							"H4ND-PAR-LOGIN-FAIL-001",
							"Worker login failed",
							context: BuildWorkItemContext(workItem),
							evidence: new
							{
								signal = SnapshotSignal(signal),
								credential = SnapshotCredential(credential),
							});

						Console.WriteLine($"[Worker-{_workerId}] Login failed for {credential.Username}@{credential.Game}");
						_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, "login_failed");

						if (_sessionRenewal != null && SessionRenewalService.IsSessionFailure(new Exception("login failed")))
						{
							await AttemptSelfHealingAsync(credential.Game, innerCt);
						}
						return true;
					}

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
					if (spinOk && !signal.Acknowledged)
					{
						_errors.CaptureInvariantFailure(
							"H4ND-PAR-ACK-INV-001",
							"Signal should be acknowledged by SpinExecution on successful spin",
							expected: true,
							actual: signal.Acknowledged,
							context: BuildWorkItemContext(workItem));
					}

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
			_errors.Capture(
				ex,
				"H4ND-PAR-AUTH-FAIL-001",
				"Parallel worker authentication/session failure",
				context: BuildWorkItemContext(workItem),
				evidence: new
				{
					signal = SnapshotSignal(signal),
					credential = SnapshotCredential(credential),
				},
				severity: P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence.ErrorSeverity.Warning);

			// ARCH-055: Self-healing on 403/401 — auto-renew session
			sw.Stop();
			Console.WriteLine($"[Worker-{_workerId}] AUTH FAILURE for {credential.Username}@{credential.Game}: {ex.Message}");
			_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, $"auth_failure:{ex.Message}");

			bool healed = await AttemptSelfHealingAsync(credential.Game, ct);
			if (healed && workItem.CanRetry)
			{
				workItem.RetryCount++;
				ReleaseClaimWithEvidence(
					_uow,
					_errors,
					workItem,
					"H4ND-PAR-CLAIM-REL-001",
					"Failed to release signal claim after successful self-healing");

				Console.WriteLine($"[Worker-{_workerId}] Session renewed — released signal for retry ({workItem.RetryCount}/{SignalWorkItem.MaxRetries})");
			}
		}
		catch (Exception ex)
		{
			_errors.Capture(
				ex,
				"H4ND-PAR-PROC-001",
				"Parallel worker failed processing work item",
				context: BuildWorkItemContext(workItem),
				evidence: new
				{
					signal = SnapshotSignal(signal),
					credential = SnapshotCredential(credential),
					workerId = _workerId,
					retryCount = workItem.RetryCount,
				});

			sw.Stop();
			Console.WriteLine($"[Worker-{_workerId}] Error processing {credential.Username}@{credential.Game}: {ex.Message}");
			_uow.Errors.Insert(
				ErrorLog.Create(ErrorType.SystemError, $"ParallelWorker-{_workerId}", ex.Message, CommonErrorSeverity.High)
			);
			_metrics.RecordSpinResult(_workerId, false, sw.Elapsed, ex.Message);

			// Release claim so another worker can pick it up
			if (workItem.CanRetry)
			{
				workItem.RetryCount++;
				ReleaseClaimWithEvidence(
					_uow,
					_errors,
					workItem,
					"H4ND-PAR-CLAIM-REL-002",
					"Failed to release signal claim after processing error");

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
				_errors.CaptureWarning(
					"H4ND-PAR-CRED-UNLOCK-001",
					"Failed to unlock credential in worker finally block",
					context: BuildWorkItemContext(workItem),
					evidence: new
					{
						unlockEx.Message,
						exceptionType = unlockEx.GetType().FullName,
						credential = SnapshotCredential(credential),
					});

				Console.WriteLine($"[Worker-{_workerId}] CRITICAL: Failed to unlock credential {credential.Username}: {unlockEx.Message}");
			}
		}
	}

	private static Dictionary<string, object> BuildWorkItemContext(SignalWorkItem workItem)
	{
		Signal signal = workItem.Signal;
		Credential credential = workItem.Credential;

		return new Dictionary<string, object>
		{
			["signalId"] = signal._id.ToString(),
			["credentialId"] = credential._id.ToString(),
			["house"] = credential.House,
			["game"] = credential.Game,
			["priority"] = signal.Priority,
			["acknowledged"] = signal.Acknowledged,
			["retryCount"] = workItem.RetryCount,
		};
	}

	private static Dictionary<string, object> SnapshotSignal(Signal signal)
	{
		return new Dictionary<string, object>
		{
			["signalId"] = signal._id.ToString(),
			["house"] = signal.House,
			["game"] = signal.Game,
			["usernameHash"] = HashForEvidence(signal.Username),
			["priority"] = signal.Priority,
			["acknowledged"] = signal.Acknowledged,
			["claimedBy"] = signal.ClaimedBy ?? string.Empty,
			["claimedAtUtc"] = signal.ClaimedAt?.ToString("O") ?? string.Empty,
		};
	}

	private static Dictionary<string, object> SnapshotCredential(Credential credential)
	{
		return new Dictionary<string, object>
		{
			["credentialId"] = credential._id.ToString(),
			["usernameHash"] = HashForEvidence(credential.Username),
			["house"] = credential.House,
			["game"] = credential.Game,
			["unlocked"] = credential.Unlocked,
			["updated"] = credential.Updated,
			["banned"] = credential.Banned,
			["balance"] = credential.Balance,
			["grand"] = credential.Jackpots.Grand,
			["major"] = credential.Jackpots.Major,
			["minor"] = credential.Jackpots.Minor,
			["mini"] = credential.Jackpots.Mini,
		};
	}

	private static string HashForEvidence(string input)
	{
		if (string.IsNullOrWhiteSpace(input))
		{
			return string.Empty;
		}

		byte[] bytes = SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes).Substring(0, 16);
	}

	public static bool ReleaseClaimWithEvidence(
		IUnitOfWork uow,
		IErrorEvidence errors,
		SignalWorkItem workItem,
		string errorCode,
		string message)
	{
		try
		{
			uow.Signals.ReleaseClaim(workItem.Signal);
			return true;
		}
		catch (Exception releaseEx)
		{
			errors.CaptureWarning(
				errorCode,
				message,
				context: BuildWorkItemContext(workItem),
				evidence: new
				{
					releaseEx.Message,
					exceptionType = releaseEx.GetType().FullName,
					signalId = workItem.Signal._id.ToString(),
				});
			return false;
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
