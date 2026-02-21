using System.Text.Json;
using Figgle;
using Figgle.Fonts;
using Microsoft.Extensions.Configuration;
using P4NTH30N;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.C0MMON.Infrastructure.EventBus;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.C0MMON.Infrastructure.Resilience;
using P4NTH30N.C0MMON.Versioning;
using P4NTH30N.H4ND;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Services;
using P4NTH30N.H4ND.EntryPoint;
using P4NTH30N.H4ND.Parallel;
using P4NTH30N.H4ND.Vision;
using P4NTH30N.Services;

// TECH-H4ND-001: CDP replaces Selenium for browser UI interaction.
// TECH-FE-015: Event bus + command pipeline for FourEyes integration.
// TECH-JP-001: CDP connectivity validation at startup.
// TECH-JP-002: Jackpot signal-to-spin pipeline via event bus.
// OPS-JP-001: Jackpot operational monitoring.

namespace P4NTH30N
{
	internal static class Header
	{
		public static string Version => FiggleFonts.Colossal.Render($"v {AppVersion.GetDisplayVersion()}");
	}
}

internal class Program
{
	private static readonly MongoUnitOfWork s_uow = new();

	private static void Main(string[] args)
	{
		MongoUnitOfWork uow = s_uow;
		RunMode mode = UnifiedEntryPoint.ParseMode(args);

		// --- ARCH-055: generate-signals does NOT require CDP ---
		if (mode == RunMode.GenerateSignals)
		{
			Console.WriteLine(Header.Version);
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
			Console.WriteLine(Header.Version);
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
		config.GetSection("P4NTH30N:H4ND:Cdp").Bind(cdpConfig);

		// --- ARCH-055: Health mode skips CDP pre-flight (reports status instead) ---
		if (mode == RunMode.Health)
		{
			Console.WriteLine(Header.Version);
			UnifiedEntryPoint.RunHealth(uow, cdpConfig, config);
			return;
		}

		// --- AUTO-056: CDP lifecycle management (auto-start Chrome if needed) ---
		CdpLifecycleConfig lifecycleConfig = new();
		config.GetSection("P4NTH30N:H4ND:CdpLifecycle").Bind(lifecycleConfig);
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
				ErrorLog.Create(ErrorType.SystemError, "H4ND:CdpHealthCheck", $"CDP pre-flight failed: {string.Join("; ", healthStatus.Errors)}", ErrorSeverity.Critical)
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
			config.GetSection("P4NTH30N:H4ND:FirstSpin").Bind(firstSpinConfig);

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
		SpinExecution spinExecution = new(uow, spinMetrics);
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

		// FEAT-036: Track whether VisionCommandHandler has been wired to avoid re-wiring
		bool visionHandlerWired = false;

		while (true)
		{
			Console.WriteLine(Header.Version);
			CdpClient? cdp = null;

			// Health monitoring for H4ND
			List<(string tier, double value, double threshold)> recentJackpots = new();
			DateTime lastHealthCheck = DateTime.MinValue;

			try
			{
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
						uow.Credentials.Lock(credential);
						if (signal != null)
							uow.Signals.Acknowledge(signal);

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
									if (!CdpGameActions.LoginFireKirinAsync(cdp, credential.Username, credential.Password).GetAwaiter().GetResult())
									{
										Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
										uow.Credentials.Lock(credential);
										continue;
									}
									break;
								case "OrionStars":
									if (lastCredential == null || lastCredential.Game != credential.Game)
									{
										if (!CdpGameActions.LoginOrionStarsAsync(cdp, credential.Username, credential.Password).GetAwaiter().GetResult())
										{
											Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
											Console.WriteLine($"{DateTime.Now} - {credential.Username} : {credential.Password}");
											uow.Credentials.Lock(credential);
											continue;
										}
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
									ErrorSeverity.Critical
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
							uow.Signals.Acknowledge(signal);
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
										uow.Signals.DeleteAll(credential.House, credential.Game);
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
										uow.Signals.DeleteAll(credential.House, credential.Game);
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
										uow.Signals.DeleteAll(credential.House, credential.Game);
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
										uow.Signals.DeleteAll(credential.House, credential.Game);
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
						uow.Credentials.Unlock(credential);

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
									ErrorSeverity.High
								)
							);
						}
						else
						{
							uow.Credentials.Upsert(credential);
						}
						lastCredential = credential;

						// Periodic health monitoring - simple error count from ERR0R
						if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5)
						{
							var recentErrors = uow.Errors.GetBySource("H4ND").Take(10).ToList();
							string status = recentErrors.Any(e => e.Severity == ErrorSeverity.Critical) ? "CRITICAL" : "HEALTHY";
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

						// Logout via CDP — no Mouse.Click, no Screen.WaitForColor
						switch (credential.Game)
						{
							case "FireKirin":
								CdpGameActions.LogoutFireKirinAsync(cdp!).GetAwaiter().GetResult();
								break;
							case "OrionStars":
								CdpGameActions.LogoutOrionStarsAsync(cdp!).GetAwaiter().GetResult();
								break;
						}
					}
				}
			}
			catch (Exception ex)
			{
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
					catch { }
					cdp = null;
					// FEAT-036: Reset so VisionCommandHandler re-wires on next CDP connection
					visionHandlerWired = false;
				}
			}
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
