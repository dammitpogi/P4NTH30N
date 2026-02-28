using System.Text.Json;
using System.Security.Cryptography;
using Figgle;
using Figgle.Fonts;
using Microsoft.Extensions.Configuration;
using P4NTHE0N;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.C0MMON.Infrastructure.EventBus;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;
using P4NTHE0N.C0MMON.Versioning;
using P4NTHE0N.H4ND;
using P4NTHE0N.H4ND.Composition;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H4ND.Navigation;
using P4NTHE0N.H4ND.Navigation.Retry;
using P4NTHE0N.H4ND.EntryPoint;
using P4NTHE0N.H4ND.Parallel;
using P4NTHE0N.H4ND.Vision;
using P4NTHE0N.Services;
using CommonErrorSeverity = P4NTHE0N.C0MMON.ErrorSeverity;

// TECH-H4ND-001: CDP replaces Selenium for browser UI interaction.
// TECH-FE-015: Event bus + command pipeline for FourEyes integration.
// TECH-JP-001: CDP connectivity validation at startup.
// TECH-JP-002: Jackpot signal-to-spin pipeline via event bus.
// OPS-JP-001: Jackpot operational monitoring.

namespace P4NTHE0N
{
	internal static class LegacyHeader
	{
		public static string Version => FiggleFonts.Colossal.Render($"v {AppVersion.GetDisplayVersion()}");
	}
}

namespace P4NTHE0N.H4ND.Services
{

public sealed class LegacyRuntimeHost : IRuntimeHost
{
	private static readonly MongoUnitOfWork s_uow = new();

	public Task<int> RunAsync(string[] args, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		RunLegacy(args);
		return Task.FromResult(0);
	}

	private static void RunLegacy(string[] args)
	{
		MongoUnitOfWork uow = s_uow;
		IErrorEvidence errors = ServiceCollectionExtensions.CurrentErrorEvidence;
		RunMode mode = UnifiedEntryPoint.ParseMode(args);

		// --- ARCH-055: generate-signals does NOT require CDP ---
		if (mode == RunMode.GenerateSignals)
		{
			Console.WriteLine(LegacyHeader.Version);
			UnifiedEntryPoint.RunGenerateSignals(uow, args);
			return;
		}

		// --- ARCH-055: Validate mode ---
		if (mode == RunMode.Unknown)
		{
			string runModeArg = args.Length > 0 ? args[0] : "(none)";
			string errorMessage = $"RunMode Argument was invalid. ({runModeArg})\n" +
				"Valid modes: H4ND, SPIN, H0UND, FIRSTSPIN, PARALLEL, GENERATE-SIGNALS, GEN, HEALTH, BURN-IN, BURNIN, MONITOR";
			Console.WriteLine(errorMessage);
			Console.ReadKey(true).KeyChar.ToString();
			throw new Exception(errorMessage);
		}

		// --- MON-057: Monitor mode does not require CDP ---
		if (mode == RunMode.Monitor)
		{
			Console.WriteLine(LegacyHeader.Version);
			IConfigurationRoot monConfig = new ConfigurationBuilder()
				.SetBasePath(AppContext.BaseDirectory)
				.AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
				.Build();
			UnifiedEntryPoint.RunMonitor(uow, monConfig);
			return;
		}

		bool listenForSignals = mode != RunMode.Hound;

		// --- Load CDP config from appsettings.json ---
		IConfigurationRoot config = new ConfigurationBuilder()
			.SetBasePath(AppContext.BaseDirectory)
			.AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
			.Build();

		CdpConfig cdpConfig = new();
		config.GetSection("P4NTHE0N:H4ND:Cdp").Bind(cdpConfig);

		// --- ARCH-055: Health mode skips CDP pre-flight (reports status instead) ---
		if (mode == RunMode.Health)
		{
			Console.WriteLine(LegacyHeader.Version);
			UnifiedEntryPoint.RunHealth(uow, cdpConfig, config);
			return;
		}

		// --- AUTO-056: CDP lifecycle management (auto-start Chrome if needed) ---
		CdpLifecycleConfig lifecycleConfig = new();
		config.GetSection("P4NTHE0N:H4ND:CdpLifecycle").Bind(lifecycleConfig);
		CdpLifecycleManager cdpLifecycle = new(lifecycleConfig);

		bool cdpEnsured = cdpLifecycle.EnsureAvailableAsync().GetAwaiter().GetResult();
		if (!cdpEnsured)
		{
			Console.WriteLine("[H4ND] CDP auto-start failed — falling back to manual check");
		}

		// AUTO-056-007: Graceful Chrome shutdown on process exit
		AppDomain.CurrentDomain.ProcessExit += (_, _) =>
		{
			Console.WriteLine("[H4ND] Process exit — stopping Chrome CDP...");
			cdpLifecycle.Dispose();
		};

		// --- TECH-JP-001: CDP connectivity pre-flight check ---
		CdpHealthCheck cdpHealthCheck = new(cdpConfig);
		CdpHealthStatus healthStatus = cdpHealthCheck.CheckHealthAsync().GetAwaiter().GetResult();

		if (!healthStatus.IsHealthy)
		{
			Console.WriteLine($"[H4ND] CDP pre-flight FAILED: {healthStatus.Summary}");
			foreach (string error in healthStatus.Errors)
			{
				Console.WriteLine($"[H4ND]   - {error}");
			}
			uow.Errors.Insert(
				ErrorLog.Create(ErrorType.SystemError, "H4ND:CdpHealthCheck", $"CDP pre-flight failed: {string.Join("; ", healthStatus.Errors)}", CommonErrorSeverity.Critical)
			);
			Console.WriteLine("[H4ND] Halting — CDP connectivity is required. Fix Chrome/CDP and restart.");
			cdpLifecycle.Dispose();
			return;
		}
		Console.WriteLine($"[H4ND] CDP pre-flight OK: {healthStatus.Summary}");

		// --- SPIN-044: First Spin run mode ---
		if (mode == RunMode.FirstSpin)
		{
			FirstSpinConfig firstSpinConfig = new();
			config.GetSection("P4NTHE0N:H4ND:FirstSpin").Bind(firstSpinConfig);

			SpinMetrics fsMetrics = new();
			FirstSpinController firstSpinController = new(uow, firstSpinConfig, fsMetrics);

			CdpClient fsCdp = new(cdpConfig);
			if (!fsCdp.ConnectAsync().GetAwaiter().GetResult())
			{
				Console.WriteLine("[FIRSTSPIN] CDP connection failed — cannot proceed.");
				return;
			}

			try
			{
				FirstSpinResult result = firstSpinController.ExecuteAsync(fsCdp).GetAwaiter().GetResult();
				Console.WriteLine(result.ToString());
			}
			finally
			{
				fsCdp.Dispose();
			}

			return;
		}

		// --- ARCH-055: Burn-in execution run mode ---
		if (mode == RunMode.BurnIn)
		{
			UnifiedEntryPoint.RunBurnIn(uow, cdpConfig, config);
			return;
		}

		// --- ARCH-047/055: Parallel execution run mode ---
		if (mode == RunMode.Parallel)
		{
			UnifiedEntryPoint.RunParallel(uow, cdpConfig, config);
			return;
		}

		// --- OPS-JP-001: Initialize spin metrics + health endpoint ---
		SpinMetrics spinMetrics = new();
		SpinExecution spinExecution = new(uow, spinMetrics, errors);
		SpinHealthEndpoint spinHealthEndpoint = new(spinMetrics);
		spinHealthEndpoint.Start();
		DateTime lastMetricsLog = DateTime.MinValue;

		// --- TECH-FE-015: Event bus + command pipeline ---
		InMemoryEventBus eventBus = new();
		OperationTracker operationTracker = new();
		CircuitBreaker cdpCircuitBreaker = new(failureThreshold: 5, recoveryTimeout: TimeSpan.FromMinutes(2), logger: msg => Console.WriteLine(msg));

		CommandPipeline commandPipeline = new CommandPipeline()
			.AddMiddleware(new LoggingMiddleware())
			.AddMiddleware(new ValidationMiddleware())
			.AddMiddleware(new IdempotencyMiddleware(operationTracker))
			.AddMiddleware(new CircuitBreakerMiddleware(cdpCircuitBreaker));

		// --- TECH-FE-015: VisionCommandListener subscribes to event bus ---
		VisionCommandListener visionListener = new();
		eventBus
			.SubscribeAsync<VisionCommand>(
				async (VisionCommand cmd) =>
				{
					CommandResult pipelineResult = await commandPipeline.ExecuteAsync(cmd);
					if (pipelineResult.IsSuccess)
					{
						visionListener.EnqueueCommand(cmd);
					}
					else
					{
						Console.WriteLine($"[H4ND] Vision command rejected by pipeline: {pipelineResult.ErrorMessage}");
					}
				}
			)
			.GetAwaiter()
			.GetResult();

		visionListener.StartAsync().GetAwaiter().GetResult();
		Console.WriteLine("[H4ND] FourEyes event bus + command pipeline initialized");

		NavigationMapLoader navigationMapLoader = new();
		IStepExecutor navigationStepExecutor = StepExecutor.CreateDefault();

		// FEAT-036: Track whether VisionCommandHandler has been wired to avoid re-wiring
		bool visionHandlerWired = false;

		while (true)
		{
			Console.WriteLine(LegacyHeader.Version);
			CdpClient? cdp = null;

			// Health monitoring for H4ND
			List<(string tier, double value, double threshold)> recentJackpots = new();
			DateTime lastHealthCheck = DateTime.MinValue;

			try
			{
				using ErrorScope runtimeScope = errors.BeginScope(
					"LegacyRuntimeHost",
					"RunLegacyLoop",
					new Dictionary<string, object>
					{
						["mode"] = mode.ToString(),
						["listenForSignals"] = listenForSignals,
					});

				double lastRetrievedGrand = 0;
				Signal? overrideSignal = null;
				Credential? lastCredential = null;

				while (true)
				{
					Signal? signal = listenForSignals ? (overrideSignal ?? uow.Signals.GetNext()) : null;
					Credential? credential = (signal == null) ? uow.Credentials.GetNext(false) : uow.Credentials.GetBy(signal.House, signal.Game, signal.Username);
					overrideSignal = null;

					if (credential == null)
					{
						continue;
					}
					else
					{
						using ErrorScope processScope = errors.BeginScope(
							"LegacyRuntimeHost",
							"ProcessCredential",
							new Dictionary<string, object>
							{
								["credentialId"] = credential._id.ToString(),
								["house"] = credential.House,
								["game"] = credential.Game,
								["hasSignal"] = signal != null,
								["signalId"] = signal?._id.ToString() ?? string.Empty,
							});

						uow.Credentials.Lock(credential);
						RecordPreProcessAckObservation(errors, signal, credential);

						if (signal != null)
						{
							if (cdp == null)
							{
								cdp = new CdpClient(cdpConfig);
								if (!cdp.ConnectAsync().GetAwaiter().GetResult())
								{
									Console.WriteLine("[H4ND] CDP connection failed — retrying in 5s");
									cdp.Dispose();
									cdp = null;
									Thread.Sleep(5000);
									continue;
								}
							}

								switch (credential.Game)
								{
									case "FireKirin":
									case "OrionStars":
										if (credential.Game == "OrionStars" && lastCredential != null && lastCredential.Game == credential.Game)
										{
											break;
										}

										if (!ExecuteLoginWithRecorderAsync(cdp, credential, navigationMapLoader, navigationStepExecutor).GetAwaiter().GetResult())
										{
											Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
											uow.Credentials.Lock(credential);
											continue;
										}
										break;
									default:
										throw new Exception($"Uncrecognized Game Found. ('{credential.Game}')");
								}
						}

						// OPS_009: Verify game page is loaded via CDP (extension-free).
						// Jackpot values come from WebSocket API (QueryBalances), NOT the browser DOM.
						if (cdp == null)
						{
							cdp = new CdpClient(cdpConfig);
							if (!cdp.ConnectAsync().GetAwaiter().GetResult())
							{
								Console.WriteLine("[H4ND] CDP connection failed — retrying in 5s");
								cdp.Dispose();
								cdp = null;
								Thread.Sleep(5000);
								continue;
							}
						}

						// FEAT-036: Wire VisionCommandHandler on first successful CDP connection
						if (!visionHandlerWired && cdp != null)
						{
							VisionCommandHandler visionHandler = new(cdp);
							visionListener.SetCommandHandler(visionHandler);
							visionHandlerWired = true;
							Console.WriteLine("[H4ND] FEAT-036: VisionCommandHandler wired to CDP — FourEyes commands active");

							// DECISION_026: Enable NetworkInterceptor for API-based jackpot extraction
							try
							{
								NetworkInterceptor interceptor = new(cdp);
								interceptor.EnableAsync().GetAwaiter().GetResult();
								Console.WriteLine("[H4ND] DECISION_026: NetworkInterceptor enabled — monitoring jackpot API traffic");
							}
							catch (Exception nex)
							{
								Console.WriteLine($"[H4ND] DECISION_026: NetworkInterceptor init failed (non-fatal): {nex.Message}");
							}
						}

						// Page readiness gate: verify game page loaded (Canvas/DOM check)
						int pageCheckAttempts = 0;
						bool pageReady = false;
						while (!pageReady)
						{
							pageReady = CdpGameActions.VerifyGamePageLoadedAsync(cdp!, credential.Game).GetAwaiter().GetResult();
							if (!pageReady)
							{
								Thread.Sleep(500);
								if (pageCheckAttempts++ > 20)
								{
									Console.WriteLine(
										$"[H4ND] Page readiness check timed out for {credential.Game} after {pageCheckAttempts} attempts — proceeding with API query"
									);
									break;
								}
							}
						}

						// Primary jackpot source: WebSocket API (works without extension)
						var balances = GetBalancesWithRetry(credential);

						// Validate raw values before processing
						bool rawValuesValid =
							!double.IsNaN(balances.Grand)
							&& !double.IsInfinity(balances.Grand)
							&& balances.Grand >= 0
							&& !double.IsNaN(balances.Major)
							&& !double.IsInfinity(balances.Major)
							&& balances.Major >= 0
							&& !double.IsNaN(balances.Minor)
							&& !double.IsInfinity(balances.Minor)
							&& balances.Minor >= 0
							&& !double.IsNaN(balances.Mini)
							&& !double.IsInfinity(balances.Mini)
							&& balances.Mini >= 0
							&& !double.IsNaN(balances.Balance)
							&& !double.IsInfinity(balances.Balance)
							&& balances.Balance >= 0;

						if (!rawValuesValid)
						{
							Dashboard.AddLog($"🔴 Critical validation failure for {credential.Game} - {credential.Username}: invalid raw values", "red");
							Dashboard.Render();
							uow.Errors.Insert(
								ErrorLog.Create(
									ErrorType.ValidationError,
									"H4ND",
									$"Invalid raw values for {credential.Username}@{credential.Game}: Grand={balances.Grand}, Major={balances.Major}, Minor={balances.Minor}, Mini={balances.Mini}, Balance={balances.Balance}",
									CommonErrorSeverity.Critical
								)
							);
							uow.Credentials.Unlock(credential);
							continue;
						}

						// Use values for processing
						double currentGrand = balances.Grand;
						double currentMajor = balances.Major;
						double currentMinor = balances.Minor;
						double currentMini = balances.Mini;
						double validatedBalance = balances.Balance;

						// Track for health monitoring
						recentJackpots.Add(("Grand", currentGrand, credential.Thresholds.Grand));
						recentJackpots.Add(("Major", currentMajor, credential.Thresholds.Major));
						recentJackpots.Add(("Minor", currentMinor, credential.Thresholds.Minor));
						recentJackpots.Add(("Mini", currentMini, credential.Thresholds.Mini));

						// Limit to last 40 entries
						if (recentJackpots.Count > 40)
						{
							recentJackpots.RemoveRange(0, 4);
						}

						if (signal != null)
						{
							if (signal.Acknowledged)
							{
								errors.CaptureWarning(
									"H4ND-ACK-OBS-002",
									"Signal already acknowledged before receive side-effects",
									context: BuildSignalContext(signal, credential),
									evidence: SnapshotSignal(signal));
							}

							File.WriteAllText(Path.Combine(Path.GetTempPath(), "S1GNAL.json"), JsonSerializer.Serialize(true));
							switch (signal.Priority)
							{
								case 1:
									signal.Receive(currentMini, uow.Received);
									break;
								case 2:
									signal.Receive(currentMinor, uow.Received);
									break;
								case 3:
									signal.Receive(currentMajor, uow.Received);
									break;
								case 4:
									signal.Receive(currentGrand, uow.Received);
									break;
							}

							// TECH-JP-002: Map Signal → VisionCommand → EventBus → SpinExecution
							VisionCommand spinCommand = new()
							{
								CommandType = VisionCommandType.Spin,
								TargetUsername = credential.Username,
								TargetGame = credential.Game,
								TargetHouse = credential.House,
								Confidence = 1.0,
								Reason = $"Signal P{(int)signal.Priority} for {credential.House}/{credential.Game}",
							};
							eventBus.PublishAsync(spinCommand).GetAwaiter().GetResult();

							// Execute spin via SpinExecution (CDP + metrics)
							bool spinOk = spinExecution.ExecuteSpinAsync(spinCommand, cdp!, signal, credential).GetAwaiter().GetResult();
							if (!spinOk)
							{
								errors.CaptureWarning(
									"H4ND-SPIN-FAIL-001",
									"SpinExecution returned false",
									context: BuildSignalContext(signal, credential),
									evidence: new
									{
										signal = SnapshotSignal(signal),
										credential = SnapshotCredential(credential),
									});

								Console.WriteLine($"[H4ND] Spin failed for {credential.Username}@{credential.Game} — continuing");
							}

							lastCredential = null;
							balances = GetBalancesWithRetry(credential);
							validatedBalance = balances.Balance;
						}
						else if (signal == null)
						{
							uow.Credentials.Lock(credential);
						}

						// Use validated values from earlier in the processing loop
						// currentMajor, currentMinor, currentMini already set from validation above

						if (
							(
								lastRetrievedGrand.Equals(currentGrand)
								&& (lastCredential == null || credential.Game != lastCredential.Game && credential.House != lastCredential.House)
							) == false
						)
						{
							Signal? gameSignal = uow.Signals.GetOne(credential.House, credential.Game);
							if (currentGrand < credential.Jackpots.Grand && credential.Jackpots.Grand - currentGrand > 0.1)
							{
								var grandJackpot = uow.Jackpots.Get("Grand", credential.House, credential.Game);
								if (grandJackpot != null && grandJackpot.DPD != null && grandJackpot.DPD.Toggles.GrandPopped == true)
								{
									if (currentGrand >= 0 && currentGrand <= 10000)
									{
										credential.Jackpots.Grand = currentGrand;
									}
									grandJackpot.DPD.Toggles.GrandPopped = false;
									credential.Thresholds.NewGrand(credential.Jackpots.Grand);
									if (gameSignal != null && gameSignal.Priority.Equals(4))
									{
										RecordDeleteAllBranchMarker(errors, gameSignal, credential, 4);
										uow.Signals.DeleteAll(credential.House, credential.Game);
									}
								}
								else if (grandJackpot?.DPD != null)
									grandJackpot.DPD.Toggles.GrandPopped = true;
							}
							else
							{
								if (currentGrand >= 0 && currentGrand <= 10000)
								{
									credential.Jackpots.Grand = currentGrand;
								}
							}

							if (currentMajor < credential.Jackpots.Major && credential.Jackpots.Major - currentMajor > 0.1)
							{
								var majorJackpot = uow.Jackpots.Get("Major", credential.House, credential.Game);
								if (majorJackpot != null && majorJackpot.DPD != null && majorJackpot.DPD.Toggles.MajorPopped == true)
								{
									if (currentMajor >= 0 && currentMajor <= 10000)
									{
										credential.Jackpots.Major = currentMajor;
									}
									majorJackpot.DPD.Toggles.MajorPopped = false;
									credential.Thresholds.NewMajor(credential.Jackpots.Major);
									if (gameSignal != null && gameSignal.Priority.Equals(3))
									{
										RecordDeleteAllBranchMarker(errors, gameSignal, credential, 3);
										uow.Signals.DeleteAll(credential.House, credential.Game);
									}
								}
								else if (majorJackpot?.DPD != null)
									majorJackpot.DPD.Toggles.MajorPopped = true;
							}
							else
							{
								if (currentMajor >= 0 && currentMajor <= 10000)
								{
									credential.Jackpots.Major = currentMajor;
								}
							}

							if (currentMinor < credential.Jackpots.Minor && credential.Jackpots.Minor - currentMinor > 0.1)
							{
								var minorJackpot = uow.Jackpots.Get("Minor", credential.House, credential.Game);
								if (minorJackpot != null && minorJackpot.DPD != null && minorJackpot.DPD.Toggles.MinorPopped == true)
								{
									if (currentMinor >= 0 && currentMinor <= 10000)
									{
										credential.Jackpots.Minor = currentMinor;
									}
									minorJackpot.DPD.Toggles.MinorPopped = false;
									credential.Thresholds.NewMinor(credential.Jackpots.Minor);
									if (gameSignal != null && gameSignal.Priority.Equals(2))
									{
										RecordDeleteAllBranchMarker(errors, gameSignal, credential, 2);
										uow.Signals.DeleteAll(credential.House, credential.Game);
									}
								}
								else if (minorJackpot?.DPD != null)
									minorJackpot.DPD.Toggles.MinorPopped = true;
							}
							else
							{
								if (currentMinor >= 0 && currentMinor <= 10000)
								{
									credential.Jackpots.Minor = currentMinor;
								}
							}

							if (currentMini < credential.Jackpots.Mini && credential.Jackpots.Mini - currentMini > 0.1)
							{
								var miniJackpot = uow.Jackpots.Get("Mini", credential.House, credential.Game);
								if (miniJackpot != null && miniJackpot.DPD != null && miniJackpot.DPD.Toggles.MiniPopped == true)
								{
									if (currentMini >= 0 && currentMini <= 10000)
									{
										credential.Jackpots.Mini = currentMini;
									}
									miniJackpot.DPD.Toggles.MiniPopped = false;
									credential.Thresholds.NewMini(credential.Jackpots.Mini);
									if (gameSignal != null && gameSignal.Priority.Equals(1))
									{
										RecordDeleteAllBranchMarker(errors, gameSignal, credential, 1);
										uow.Signals.DeleteAll(credential.House, credential.Game);
									}
								}
								else if (miniJackpot?.DPD != null)
									miniJackpot.DPD.Toggles.MiniPopped = true;
							}
							else
							{
								if (currentMini >= 0 && currentMini <= 10000)
								{
									credential.Jackpots.Mini = currentMini;
								}
							}
						}
						else
						{
							throw new Exception("Invalid grand retrieved.");
						}

						if (credential.Settings.Gold777 == null)
							credential.Settings.Gold777 = new Gold777_Settings();
						credential.Updated = true;
						Dictionary<string, object> beforeUnlock = SnapshotCredential(credential);
						uow.Credentials.Unlock(credential);
						RecordUnlockBeforePersistInvariant(errors, signal, credential);

						credential.LastUpdated = DateTime.UtcNow;
						credential.Balance = validatedBalance; // Use validated balance
						lastRetrievedGrand = currentGrand;

						// Validate credential before saving
						if (!credential.IsValid(uow.Errors))
						{
							Dashboard.AddLog($"🔴 Credential validation failed for {credential.Username} - not saving", "red");
							Dashboard.Render();
							uow.Errors.Insert(
								ErrorLog.Create(
									ErrorType.ValidationError,
									"H4ND",
									$"Credential validation failed before upsert: {credential.Username}@{credential.Game}",
									CommonErrorSeverity.High
								)
							);
						}
						else
						{
							uow.Credentials.Upsert(credential);
						}

						if (signal != null)
						{
							Dictionary<string, object> afterUpsert = SnapshotCredential(credential);
							errors.CaptureWarning(
								"H4ND-MUT-UNLOCK-UPSERT-001",
								"Credential unlock-before-upsert mutation checkpoint",
								context: BuildSignalContext(signal, credential),
								evidence: new
								{
									before = beforeUnlock,
									after = afterUpsert,
									diff = ComputeDiff(beforeUnlock, afterUpsert),
								});
						}

						lastCredential = credential;

						// Periodic health monitoring - simple error count from ERR0R
						if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5)
						{
							var recentErrors = uow.Errors.GetBySource("H4ND").Take(10).ToList();
							string status = recentErrors.Any(e => e.Severity == CommonErrorSeverity.Critical) ? "CRITICAL" : "HEALTHY";
							Console.WriteLine($"💊 H4ND Health: {status} | Recent Errors: {recentErrors.Count}");
							lastHealthCheck = DateTime.Now;
						}

						// OPS-JP-001: Periodic spin metrics summary to console
						if ((DateTime.Now - lastMetricsLog).TotalMinutes >= 10)
						{
							spinHealthEndpoint.LogSummaryToConsole();
							lastMetricsLog = DateTime.Now;
						}

						if (overrideSignal == null)
						{
							File.WriteAllText(Path.Combine(Path.GetTempPath(), "S1GNAL.json"), JsonSerializer.Serialize(false));
						}

						// Only run logout after a signal-driven interactive session.
						if (signal != null)
						{
							ExecuteLogoutWithRecorderAsync(cdp!, credential, navigationMapLoader, navigationStepExecutor).GetAwaiter().GetResult();
						}
					}
				}
			}
			catch (Exception ex)
			{
				errors.Capture(
					ex,
					"H4ND-LEGACY-LOOP-001",
					"Unhandled exception in LegacyRuntimeHost run loop",
					context: new Dictionary<string, object>
					{
						["listenForSignals"] = listenForSignals,
						["mode"] = mode.ToString(),
					});

				Console.WriteLine(ex.Message);
				Console.WriteLine(ex);
				Thread.Sleep(5000);
			}
			finally
			{
				if (cdp != null)
				{
					try
					{
						cdp.Dispose();
					}
					catch (Exception disposeEx)
					{
						errors.CaptureWarning(
							"H4ND-CDP-DISPOSE-001",
							"CDP dispose failed during runtime loop cleanup",
							context: new Dictionary<string, object>
							{
								["mode"] = mode.ToString(),
							},
							evidence: new
							{
								exceptionType = disposeEx.GetType().FullName,
								disposeEx.Message,
							});
					}

					cdp = null;
					// FEAT-036: Reset so VisionCommandHandler re-wires on next CDP connection
					visionHandlerWired = false;
				}
			}
		}
	}

	private static Dictionary<string, object> BuildSignalContext(Signal signal, Credential credential)
	{
		return new Dictionary<string, object>
		{
			["signalId"] = signal._id.ToString(),
			["credentialId"] = credential._id.ToString(),
			["house"] = credential.House,
			["game"] = credential.Game,
			["priority"] = signal.Priority,
			["acknowledged"] = signal.Acknowledged,
		};
	}

	public static void RecordPreProcessAckObservation(IErrorEvidence errors, Signal? signal, Credential credential)
	{
		if (signal?.Acknowledged != true)
		{
			return;
		}

		errors.CaptureWarning(
			"H4ND-ACK-OBS-001",
			"Signal observed as already acknowledged before processing",
			context: BuildSignalContext(signal, credential),
			evidence: SnapshotSignal(signal));
	}

	public static void RecordUnlockBeforePersistInvariant(IErrorEvidence errors, Signal? signal, Credential credential)
	{
		if (credential.Unlocked)
		{
			return;
		}

		errors.CaptureInvariantFailure(
			"H4ND-CRED-INV-001",
			"Credential remained locked after unlock call",
			expected: true,
			actual: credential.Unlocked,
			context: signal == null ? null : BuildSignalContext(signal, credential));
	}

	public static void RecordDeleteAllBranchMarker(IErrorEvidence errors, Signal signal, Credential credential, int priority)
	{
		errors.CaptureWarning(
			"H4ND-DELALL-BRANCH-001",
			"DeleteAll branch executed for matched signal priority",
			context: BuildSignalContext(signal, credential),
			evidence: new
			{
				priority,
				house = credential.House,
				game = credential.Game,
				signalId = signal._id.ToString(),
			});
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

	private static IReadOnlyList<string> ComputeDiff(Dictionary<string, object> before, Dictionary<string, object> after)
	{
		List<string> diff = [];
		foreach (KeyValuePair<string, object> pair in before)
		{
			after.TryGetValue(pair.Key, out object? afterValue);
			if (!Equals(pair.Value, afterValue))
			{
				diff.Add(pair.Key);
			}
		}

		return diff;
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

	private static async Task<bool> ExecuteLoginWithRecorderAsync(
		ICdpClient cdp,
		Credential credential,
		NavigationMapLoader mapLoader,
		IStepExecutor stepExecutor,
		CancellationToken ct = default)
	{
		try
		{
			NavigationMap? map = await mapLoader.LoadAsync(credential.Game, ct);
			if (map != null && map.GetStepsForPhase("Login").Any())
			{
				StepExecutionContext context = new()
				{
					CdpClient = cdp,
					Platform = credential.Game,
					Username = credential.Username,
					Password = credential.Password,
					WorkerId = "MAIN",
					Variables = new()
					{
						["username"] = credential.Username,
						["password"] = credential.Password,
					},
				};

				PhaseExecutionResult loginResult = await stepExecutor.ExecutePhaseAsync(map, "Login", context, ct);
				if (loginResult.Success)
				{
					Console.WriteLine($"[H4ND] Recorder login completed for {credential.Username}@{credential.Game}");
					return await CdpGameActions.VerifyLoginSuccessAsync(cdp, credential.Username, credential.Game, ct);
				}

				Console.WriteLine($"[H4ND] Recorder login failed: {loginResult.ErrorMessage} — NOT falling through to hardcoded (caller will handle)");
				return false;
			}
			else
			{
				Console.WriteLine($"[H4ND] No Login phase steps found in recorder map, using hardcoded flow");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[H4ND] Recorder login error, falling back to hardcoded flow: {ex.Message}");
		}

		return credential.Game switch
		{
			"FireKirin" => await CdpGameActions.LoginFireKirinAsync(cdp, credential.Username, credential.Password),
			"OrionStars" => await CdpGameActions.LoginOrionStarsAsync(cdp, credential.Username, credential.Password),
			_ => throw new Exception($"Unrecognized game: '{credential.Game}'"),
		};
	}

	private static async Task ExecuteLogoutWithRecorderAsync(
		ICdpClient cdp,
		Credential credential,
		NavigationMapLoader mapLoader,
		IStepExecutor stepExecutor,
		CancellationToken ct = default)
	{
		try
		{
			NavigationMap? map = await mapLoader.LoadAsync(credential.Game, ct);
			if (map != null && map.GetStepsForPhase("Logout").Any())
			{
				StepExecutionContext context = new()
				{
					CdpClient = cdp,
					Platform = credential.Game,
					Username = credential.Username,
					WorkerId = "MAIN",
				};

				PhaseExecutionResult logoutResult = await stepExecutor.ExecutePhaseAsync(map, "Logout", context, ct);
				if (logoutResult.Success)
				{
					Console.WriteLine($"[H4ND] Recorder logout completed for {credential.Username}@{credential.Game}");
					return;
				}

				Console.WriteLine($"[H4ND] Recorder logout failed: {logoutResult.ErrorMessage} — NOT falling through to hardcoded");
				return;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[H4ND] Recorder logout error, falling back to hardcoded flow: {ex.Message}");
		}

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

	private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalances(Credential credential)
	{
		Random random = new();
		int delayMs = random.Next(3000, 5001);
		Thread.Sleep(delayMs);

		try
		{
			switch (credential.Game)
			{
				case "FireKirin":
				{
					var balances = FireKirin.QueryBalances(credential.Username, credential.Password);

					// Simple validation - reject invalid values
					double validatedBalance = (double)balances.Balance;
					double validatedGrand = (double)balances.Grand;
					double validatedMajor = (double)balances.Major;
					double validatedMinor = (double)balances.Minor;
					double validatedMini = (double)balances.Mini;

					// Check for invalid values and clamp to 0 if invalid
					if (double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0)
					{
						validatedBalance = 0;
					}
					if (double.IsNaN(validatedGrand) || double.IsInfinity(validatedGrand) || validatedGrand < 0)
					{
						validatedGrand = 0;
					}
					if (double.IsNaN(validatedMajor) || double.IsInfinity(validatedMajor) || validatedMajor < 0)
					{
						validatedMajor = 0;
					}
					if (double.IsNaN(validatedMinor) || double.IsInfinity(validatedMinor) || validatedMinor < 0)
					{
						validatedMinor = 0;
					}
					if (double.IsNaN(validatedMini) || double.IsInfinity(validatedMini) || validatedMini < 0)
					{
						validatedMini = 0;
					}

					Dashboard.AddLog(
						$"{credential.Game} - {credential.House} - {credential.Username} - ${validatedBalance:F2} - [{validatedGrand:F2}, {validatedMajor:F2}, {validatedMinor:F2}, {validatedMini:F2}]",
						"green"
					);

					return (validatedBalance, validatedGrand, validatedMajor, validatedMinor, validatedMini);
				}
				case "OrionStars":
				{
					var balances = OrionStars.QueryBalances(credential.Username, credential.Password);

					// Simple validation - reject invalid values
					double validatedBalance = (double)balances.Balance;
					double validatedGrand = (double)balances.Grand;
					double validatedMajor = (double)balances.Major;
					double validatedMinor = (double)balances.Minor;
					double validatedMini = (double)balances.Mini;

					// Check for invalid values and clamp to 0 if invalid
					if (double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0)
					{
						validatedBalance = 0;
					}
					if (double.IsNaN(validatedGrand) || double.IsInfinity(validatedGrand) || validatedGrand < 0)
					{
						validatedGrand = 0;
					}
					if (double.IsNaN(validatedMajor) || double.IsInfinity(validatedMajor) || validatedMajor < 0)
					{
						validatedMajor = 0;
					}
					if (double.IsNaN(validatedMinor) || double.IsInfinity(validatedMinor) || validatedMinor < 0)
					{
						validatedMinor = 0;
					}
					if (double.IsNaN(validatedMini) || double.IsInfinity(validatedMini) || validatedMini < 0)
					{
						validatedMini = 0;
					}

					Dashboard.AddLog(
						$"{credential.Game} - {credential.House} - {credential.Username} - ${validatedBalance:F2} - [{validatedGrand:F2}, {validatedMajor:F2}, {validatedMinor:F2}, {validatedMini:F2}]",
						"green"
					);

					return (validatedBalance, validatedGrand, validatedMajor, validatedMinor, validatedMini);
				}
				default:
					throw new Exception($"Uncrecognized Game Found. ('{credential.Game}')");
			}
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
		{
			Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}. Marking as banned.", "red");
			credential.Banned = true;
			s_uow.Credentials.Upsert(credential);
			throw;
		}
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(Credential credential)
	{
		(double Balance, double Grand, double Major, double Minor, double Mini) ExecuteQuery()
		{
			int networkAttempts = 0;
			while (true)
			{
				try
				{
					return QueryBalances(credential);
				}
				catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
				{
					throw;
				}
				catch (Exception ex)
				{
					networkAttempts++;
					if (networkAttempts >= 3)
						throw; // Give up

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

		// OPS_009: Grand=0 from WebSocket API is a transient state — retry briefly.
		// The API is the authoritative source; no extension dependency.
		int grandChecked = 0;
		var balances = ExecuteQuery();
		double currentGrand = balances.Grand;
		while (currentGrand.Equals(0))
		{
			grandChecked++;
			Dashboard.AddLog($"Grand jackpot is 0 for {credential.Game}, retrying attempt {grandChecked}/10", "yellow");
			Dashboard.Render();
			Thread.Sleep(1000);
			if (grandChecked > 10)
			{
				ProcessEvent alert = ProcessEvent.Log("H4ND", $"Grand jackpot returned 0 from API for {credential.Game} after {grandChecked} attempts");
				Dashboard.AddLog($"Grand jackpot API returned 0 for {credential.Game} after {grandChecked} attempts — proceeding with available data.", "yellow");
				Dashboard.Render();
				s_uow.ProcessEvents.Insert(alert.Record(credential));
				break;
			}
			Dashboard.AddLog($"Retrying balance query for {credential.Game} (attempt {grandChecked})", "yellow");
			Dashboard.Render();
			balances = ExecuteQuery();
			currentGrand = balances.Grand;
		}

		return balances;
	}
}

}
