using System.Diagnostics;
using System.Drawing;
using System.Security.Cryptography;
using System.Text.Json;
using Figgle;
using P4NTHE0N;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;
using P4NTHE0N.C0MMON.Monitoring;
using P4NTHE0N.C0MMON.Versioning;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.H0UND.Application.Analytics;
using P4NTHE0N.H0UND.Application.Polling;
using P4NTHE0N.H0UND.Domain.Signals;
using H0UND.Infrastructure.Tray;
using H0UND.Infrastructure.BootTime;
using H0UND.Services.Orchestration;
using P4NTHE0N.H0UND.Infrastructure.Polling;
using P4NTHE0N.C0MMON.Services.Display;
using P4NTHE0N.H0UND.Services;
using P4NTHE0N.Services;
using System.Windows.Forms;
using CommonErrorSeverity = P4NTHE0N.C0MMON.ErrorSeverity;

namespace P4NTHE0N;

[GenerateFiggleText(sourceText: "v    0 . 8 . 6 . 3", memberName: "Version", fontName: "colossal")]
internal static partial class Header { }

public class Program
{
	private static readonly MongoUnitOfWork s_uow = new();
	private static readonly IErrorEvidence s_errors = CreateErrorEvidence();
    private static int s_credentialLockDepth;

	// Control flag: true = use priority calculation, false = full sweep (oldest first)
	private static readonly bool UsePriorityCalculation = false;

	// Feature flag: true = use idempotent signal generation (race condition fix)
	private static readonly bool UseIdempotentSignals = true;

	// Analytics phase timing
	private static DateTime s_lastAnalyticsRunUtc = DateTime.MinValue;
	private const int AnalyticsIntervalSeconds = 10;

	// DECISION_085: Schedule refresh timing
	private static DateTime s_lastScheduleRefreshUtc = DateTime.MinValue;
	private const int ScheduleRefreshIntervalSeconds = 30;
	private static DateTime s_lastNoCredentialsNoticeUtc = DateTime.MinValue;
	private const int NoCredentialsNoticeIntervalSeconds = 60;

	// Resilience infrastructure
	private static readonly CircuitBreaker s_apiCircuit = new(
		failureThreshold: 5,
		recoveryTimeout: TimeSpan.FromSeconds(60),
		logger: msg => Dashboard.AddLog(msg, "yellow")
	);
	private static readonly CircuitBreaker s_mongoCircuit = new(
		failureThreshold: 3,
		recoveryTimeout: TimeSpan.FromSeconds(30),
		logger: msg => Dashboard.AddLog(msg, "yellow")
	);
	private static readonly SystemDegradationManager s_degradation = new(logger: msg => Dashboard.AddLog(msg, "yellow"));
	private static readonly OperationTracker s_opTracker = new(TimeSpan.FromMinutes(5));
	private static C0MMON.Monitoring.HealthCheckService? s_healthService;
	private static ConsoleWindowManager? s_consoleWindowManager;
	private static ServiceOrchestrator? s_serviceOrchestrator;
	private static TrayHost? s_trayHost;
	private static volatile bool s_exitRequested;
	private static volatile bool s_noUiMode;

	// DECISION_025: Anomaly detection for jackpot patterns
	private static readonly AnomalyDetector s_anomalyDetector = new(
		windowSize: 50,
		compressionThreshold: 1.3,
		zScoreThreshold: 3.0,
		onAnomaly: anomaly =>
		{
			using ErrorScope anomalyScope = s_errors.BeginScope(
				"H0UND.Program",
				"AnomalyCallback",
				new Dictionary<string, object>
				{
					["house"] = anomaly.House,
					["game"] = anomaly.Game,
					["tier"] = anomaly.Tier,
				});

			Dashboard.AddLog(
				$"ANOMALY: {anomaly.House}/{anomaly.Game}/{anomaly.Tier} = {anomaly.AnomalousValue:F2} " +
				$"(ratio={anomaly.AtypicalityRatio:F2}, z={anomaly.ZScore:F2}, method={anomaly.DetectionMethod})",
				"red"
			);
			try
			{
					s_uow.Errors.Insert(ErrorLog.Create(
						ErrorType.DataCorruption,
						"AnomalyDetector",
						$"Anomalous jackpot: {anomaly.House}/{anomaly.Game}/{anomaly.Tier} = {anomaly.AnomalousValue:F2} " +
						$"(ratio={anomaly.AtypicalityRatio:F2}, z={anomaly.ZScore:F2}, method={anomaly.DetectionMethod}, " +
						$"mean={anomaly.WindowMean:F2}, stddev={anomaly.WindowStdDev:F2}, window={anomaly.WindowSize})",
						CommonErrorSeverity.High
					));
			}
			catch (Exception ex) when (ex.Message.Contains("No enabled, non-banned credentials found", StringComparison.OrdinalIgnoreCase))
			{
				Dashboard.CurrentTask = "Idle - No Enabled Credentials";

				if ((DateTime.UtcNow - s_lastNoCredentialsNoticeUtc).TotalSeconds >= NoCredentialsNoticeIntervalSeconds)
				{
					s_lastNoCredentialsNoticeUtc = DateTime.UtcNow;
					Dashboard.AddLog("No enabled credentials available. Waiting for credentials to be enabled.", "yellow");
					RenderDashboard();
				}

				Thread.Sleep(10000);
			}
			catch (Exception ex)
			{
				s_errors.Capture(
					ex,
					"H0UND-ANOM-LOG-ERR-001",
					"Anomaly callback persistence failed",
					context: new Dictionary<string, object>
					{
						["house"] = anomaly.House,
						["game"] = anomaly.Game,
						["tier"] = anomaly.Tier,
					},
					evidence: new
					{
						anomaly.AnomalousValue,
						anomaly.AtypicalityRatio,
						anomaly.ZScore,
						anomaly.DetectionMethod,
					});
			}
		}
	);

	static void Main(string[] args)
	{
		bool backgroundMode = args.Any(a => a.Equals("--background", StringComparison.OrdinalIgnoreCase));
		s_noUiMode = args.Any(a => a.Equals("--no-ui", StringComparison.OrdinalIgnoreCase));

		if (!s_noUiMode)
		{
			s_consoleWindowManager = new ConsoleWindowManager();
			StartTrayHost();
		}

		InitializeServiceOrchestrator();

		if (backgroundMode && s_consoleWindowManager != null)
		{
			s_consoleWindowManager.Hide();
		}

		MongoUnitOfWork uow = s_uow;

		DisplayEventBus? displayBus = null;
		if (!s_noUiMode)
		{
			// Show splash screen with version and random Strategist excerpt
			Dashboard.ShowSplash(Header.Version);

			// DECISION_085: Initialize display pipeline after splash
			displayBus = Dashboard.InitializeDisplayPipeline();
		}

		// Initialize idempotent signal generation infrastructure
		AnalyticsWorker analyticsWorker;
		if (UseIdempotentSignals)
		{
			// DECISION_085: Route infrastructure loggers through display bus with proper levels
			Action<string> lockLogger = displayBus?.CreateLogger("DistributedLock", DisplayLogLevel.Silent) ?? (_ => { });
			Action<string> signalLogger = displayBus?.CreateSmartLogger("IdempotentSignal", DisplayLogLevel.Debug) ?? (_ => { });
			Action<string> metricsLogger = displayBus?.CreateLogger("SignalMetrics", DisplayLogLevel.Detail, "cyan") ?? (_ => { });

			DistributedLockService lockService = new(uow.DatabaseProvider, lockLogger);
			SignalDeduplicationCache dedupCache = new();
			InMemoryDeadLetterQueue deadLetterQueue = new();
			RetryPolicy retryPolicy = new(maxRetries: 3, baseDelay: TimeSpan.FromMilliseconds(100),
				logger: displayBus?.CreateSmartLogger("RetryPolicy", DisplayLogLevel.Debug) ?? (_ => { }));
			P4NTHE0N.C0MMON.Infrastructure.Monitoring.SignalMetrics signalMetrics = new(
				logger: metricsLogger,
				reportInterval: TimeSpan.FromSeconds(60)
			);

			IdempotentSignalGenerator idempotentGenerator = new(lockService, dedupCache, deadLetterQueue, retryPolicy, s_mongoCircuit, signalMetrics, signalLogger);

			analyticsWorker = new AnalyticsWorker(idempotentGenerator);
			Dashboard.AddLog("Idempotent signal generation ENABLED", "green");
		}
		else
		{
			analyticsWorker = new AnalyticsWorker();
			Dashboard.AddLog("Idempotent signal generation DISABLED (legacy mode)", "yellow");
		}

		BalanceProviderFactory balanceProviderFactory = new BalanceProviderFactory(s_errors);
		PollingWorker pollingWorker = new PollingWorker(balanceProviderFactory, s_errors);
		s_healthService = new C0MMON.Monitoring.HealthCheckService(uow.DatabaseProvider, s_apiCircuit, s_mongoCircuit, uow);

		// Show loading status on splash
		if (!s_noUiMode)
			Dashboard.ShowSplashStatus("Initializing signal generation...");

		// Load credentials and show status on splash
		if (!s_noUiMode)
			Dashboard.ShowSplashStatus("Loading credentials...");
		try
		{
			var allCreds = uow.Credentials.GetAll();
			Dashboard.TotalCredentials = allCreds.Count();
			Dashboard.TotalEnabledBalance = allCreds.Where(c => c.Enabled && !c.Banned).Sum(c => c.Balance);
			if (!s_noUiMode)
				Dashboard.ShowSplashStatus($"Loaded {Dashboard.TotalCredentials} credentials");
		}
		catch (Exception ex)
		{
			if (!s_noUiMode)
				Dashboard.ShowSplashStatus($"Warning: Could not load credentials: {ex.Message}");
		}

		// Load schedule, withdraw accounts, and deposit data before showing UI
		if (!s_noUiMode)
			Dashboard.ShowSplashStatus("Loading jackpot schedule...");
		RefreshDashboardSchedule(uow);
		if (!s_noUiMode)
			Dashboard.ShowSplashStatus("Schedule loaded");

		// Initialize dashboard with startup info
		Dashboard.AddLog("H0UND Started", "blue");
		Dashboard.AddLog($"Priority: {(UsePriorityCalculation ? "ON" : "OFF (Full Sweep)")}", "blue");
		Dashboard.AddAnalyticsLog("Analytics engine initialized", "cyan");
		Dashboard.AddAnalyticsLog("Awaiting telemetry...", "grey");
		Dashboard.AddLog($"Loaded {Dashboard.TotalCredentials} credentials", "green");

		// Wait a moment for user to read splash, then clear for UI
		if (!s_noUiMode)
			Thread.Sleep(1500);

		while (!s_exitRequested)
		{
			DateTime lastHealthCheck = DateTime.MinValue;

			try
			{
				using ErrorScope runtimeScope = s_errors.BeginScope("H0UND.Program", "MainLoop");
				double lastRetrievedGrand = 0;
				Credential? lastCredential = null;

				while (!s_exitRequested)
				{
					// Handle pause state
					if (Dashboard.IsPaused)
					{
						RenderDashboard();
						Thread.Sleep(100);
						continue;
					}

					// Time-gated analytics phase
					if ((DateTime.UtcNow - s_lastAnalyticsRunUtc).TotalSeconds >= AnalyticsIntervalSeconds)
					{
						Dashboard.CurrentTask = "Running Analytics";
						RenderDashboard();
						try
						{
							analyticsWorker.RunAnalytics(uow);
						}
						catch (Exception ex)
						{
							s_errors.Capture(
								ex,
								"H0UND-ANALYTICS-ERR-001",
								"Analytics phase failed",
								context: new Dictionary<string, object>
								{
									["intervalSeconds"] = AnalyticsIntervalSeconds,
								});
						}
						s_lastAnalyticsRunUtc = DateTime.UtcNow;
					}

					// DECISION_085: Periodic schedule/account data refresh
					if ((DateTime.UtcNow - s_lastScheduleRefreshUtc).TotalSeconds >= ScheduleRefreshIntervalSeconds)
					{
						RefreshDashboardSchedule(uow);
						s_lastScheduleRefreshUtc = DateTime.UtcNow;
					}

					Dashboard.CurrentTask = "Polling Queue";
					RenderDashboard();

					Credential credential = uow.Credentials.GetNext(UsePriorityCalculation);

					Dashboard.CurrentGame = credential.Game;
					Dashboard.CurrentUser = credential.Username ?? "None";
					Dashboard.CurrentHouse = credential.House ?? "Unknown";
					Dashboard.CurrentTask = "Retrieving Balances";
					RenderDashboard();

					AcquireCredentialLock(uow, credential, "MainLoopPolling");

					try
					{
						// Circuit breaker around API polling
						(double Balance, double Grand, double Major, double Minor, double Mini) balances = s_apiCircuit
							.ExecuteAsync(async () =>
							{
								return pollingWorker.GetBalancesWithRetry(credential, uow);
							})
							.GetAwaiter()
							.GetResult();

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
							Dashboard.AddLog($"Critical validation failure for {credential.Game} - {credential.Username}: invalid raw values", "red");
							Dashboard.TrackError("ValidationFailure");
							Dashboard.IncrementPoll(false);
							uow.Errors.Insert(
								ErrorLog.Create(
									ErrorType.ValidationError,
									"H0UND",
									$"Invalid raw values for {credential.Username}@{credential.Game}: Grand={balances.Grand}, Major={balances.Major}, Minor={balances.Minor}, Mini={balances.Mini}, Balance={balances.Balance}",
									CommonErrorSeverity.Critical
								)
							);
							P4NTHE0N.C0MMON.ProcessEvent alert = P4NTHE0N.C0MMON.ProcessEvent.Log(
								"H0UND",
								$"Validation failure for {credential.Game}: invalid raw values"
							);
							s_uow.ProcessEvents.Insert(alert.Record(credential));
							ReleaseCredentialLock(uow, credential, "RawValueValidationFailure");
							credential.LastUpdated = DateTime.UtcNow;
							uow.Credentials.Upsert(credential);
							continue;
						}

						// Use values
						double currentGrand = balances.Grand;
						double currentMajor = balances.Major;
						double currentMinor = balances.Minor;
						double currentMini = balances.Mini;
						double currentBalance = balances.Balance;

						// Update dashboard with current values
						Dashboard.CurrentGrand = currentGrand;
						Dashboard.CurrentMajor = currentMajor;
						Dashboard.CurrentMinor = currentMinor;
						Dashboard.CurrentMini = currentMini;
						Dashboard.CurrentBalance = currentBalance;
						Dashboard.ThresholdGrand = credential.Thresholds.Grand;
						Dashboard.ThresholdMajor = credential.Thresholds.Major;
						Dashboard.ThresholdMinor = credential.Thresholds.Minor;
						Dashboard.ThresholdMini = credential.Thresholds.Mini;

						// DECISION_025: Run anomaly detection on all 4 jackpot tiers
						string house = credential.House ?? "Unknown";
						string game = credential.Game;
						s_anomalyDetector.Process(house, game, "Grand", currentGrand);
						s_anomalyDetector.Process(house, game, "Major", currentMajor);
						s_anomalyDetector.Process(house, game, "Minor", currentMinor);
						s_anomalyDetector.Process(house, game, "Mini", currentMini);

						if (
							(
								lastRetrievedGrand.Equals(currentGrand)
								&& (lastCredential == null || credential.Game != lastCredential.Game && credential.House != lastCredential.House)
							) == false
						)
						{
							Signal? gameSignal = uow.Signals.GetOne(credential.House ?? "Unknown", credential.Game);
							if (currentGrand < credential.Jackpots.Grand && credential.Jackpots.Grand - currentGrand > 0.1)
							{
								var grandJackpot = uow.Jackpots.Get("Grand", credential.House!, credential.Game!);
								if (grandJackpot != null && grandJackpot.DPD!.Toggles.GrandPopped == true)
								{
									if (currentGrand >= 0 && currentGrand <= 10000)
									{
										credential.Jackpots.Grand = currentGrand;
									}
									grandJackpot.DPD!.Toggles.GrandPopped = false;
									credential.Thresholds.NewGrand(credential.Jackpots.Grand);
									if (gameSignal != null && gameSignal.Priority.Equals(4))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
									// DECISION_085: Track won jackpot
									Dashboard.AddWin(new WonEntry(
										credential.House ?? "Unknown", credential.Game, "Grand",
										grandJackpot.Threshold, DateTime.UtcNow));
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
								var majorJackpot = uow.Jackpots.Get("Major", credential.House!, credential.Game!);
								if (majorJackpot != null && majorJackpot.DPD!.Toggles.MajorPopped == true)
								{
									if (currentMajor >= 0 && currentMajor <= 10000)
									{
										credential.Jackpots.Major = currentMajor;
									}
									majorJackpot.DPD!.Toggles.MajorPopped = false;
									credential.Thresholds.NewMajor(credential.Jackpots.Major);
									if (gameSignal != null && gameSignal.Priority.Equals(3))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
									Dashboard.AddWin(new WonEntry(
										credential.House ?? "Unknown", credential.Game, "Major",
										majorJackpot.Threshold, DateTime.UtcNow));
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
								var minorJackpot = uow.Jackpots.Get("Minor", credential.House!, credential.Game!);
								if (minorJackpot != null && minorJackpot.DPD!.Toggles.MinorPopped == true)
								{
									if (currentMinor >= 0 && currentMinor <= 10000)
									{
										credential.Jackpots.Minor = currentMinor;
									}
									minorJackpot.DPD!.Toggles.MinorPopped = false;
									credential.Thresholds.NewMinor(credential.Jackpots.Minor);
									if (gameSignal != null && gameSignal.Priority.Equals(2))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
									Dashboard.AddWin(new WonEntry(
										credential.House ?? "Unknown", credential.Game, "Minor",
										minorJackpot.Threshold, DateTime.UtcNow));
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
								var miniJackpot = uow.Jackpots.Get("Mini", credential.House!, credential.Game!);
								if (miniJackpot != null && miniJackpot.DPD!.Toggles.MiniPopped == true)
								{
									if (currentMini >= 0 && currentMini <= 10000)
									{
										credential.Jackpots.Mini = currentMini;
									}
									miniJackpot.DPD!.Toggles.MiniPopped = false;
									credential.Thresholds.NewMini(credential.Jackpots.Mini);
									if (gameSignal != null && gameSignal.Priority.Equals(1))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
									Dashboard.AddWin(new WonEntry(
										credential.House ?? "Unknown", credential.Game, "Mini",
										miniJackpot.Threshold, DateTime.UtcNow));
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
						ReleaseCredentialLock(uow, credential, "PrePersistUnlock");

						credential.LastUpdated = DateTime.UtcNow;
						credential.Balance = currentBalance;
						lastRetrievedGrand = currentGrand;
						uow.Credentials.Upsert(credential);
						lastCredential = credential;

						// DECISION_085: Update jackpot entities with current values for accurate ETA calculations
						UpdateJackpotValues(uow, credential.House!, credential.Game!, currentGrand, currentMajor, currentMinor, currentMini);

						// Track successful poll
						Dashboard.IncrementPoll(true);
						Dashboard.ActiveCredentials = 1;

						// Periodic health monitoring with full system health check
						if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5)
						{
							if (s_healthService != null)
							{
								C0MMON.Monitoring.SystemHealth health = s_healthService.GetSystemHealthAsync().GetAwaiter().GetResult();
								string checksummary = string.Join(" | ", health.Checks.Select(c => $"{c.Component}:{c.Status}"));
								Dashboard.UpdateHealthStatus(
									health.OverallStatus.ToString(),
									checksummary,
									s_degradation.CurrentLevel.ToString(),
									health.Uptime
								);
							}
							lastHealthCheck = DateTime.Now;
						}

						RenderDashboard();

						// Degradation-aware throttling
						int delay = s_degradation.CurrentLevel switch
						{
							DegradationLevel.Emergency => 30000,
							DegradationLevel.Minimal => 15000,
							DegradationLevel.Reduced => 8000,
							_ => Random.Shared.Next(3000, 5001),
						};
						Thread.Sleep(delay);
					}
					catch (CircuitBreakerOpenException)
					{
						s_errors.CaptureWarning(
							"H0UND-CIRCUIT-OPEN-001",
							"API circuit open; poll iteration skipped",
							context: new Dictionary<string, object>
							{
								["game"] = credential.Game,
								["house"] = credential.House ?? "Unknown",
								["credentialId"] = credential._id.ToString(),
							});

						Dashboard.AddLog($"API circuit open - skipping {credential.Username}@{credential.Game}", "yellow");
						Dashboard.IncrementPoll(false);
						RenderDashboard();
						ReleaseCredentialLock(uow, credential, "MainLoopCircuitOpen");
						Thread.Sleep(5000);
					}
					catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
					{
						Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}", "red");
						Dashboard.TrackError("AccountSuspended");
						Dashboard.IncrementPoll(false);
						RenderDashboard();
						ReleaseCredentialLock(uow, credential, "MainLoopSuspended");
					}
					finally
					{
						ReleaseCredentialLock(uow, credential, "MainLoopFinally");
					}
				}
			}
			catch (Exception ex)
			{
				if (ex.Message.Contains("No enabled, non-banned credentials found", StringComparison.OrdinalIgnoreCase))
				{
					Dashboard.CurrentTask = "Idle - No Enabled Credentials";
					if ((DateTime.UtcNow - s_lastNoCredentialsNoticeUtc).TotalSeconds >= NoCredentialsNoticeIntervalSeconds)
					{
						s_lastNoCredentialsNoticeUtc = DateTime.UtcNow;
						Dashboard.AddLog("MongoDB connected. No enabled credentials available; starting credential-state investigation path.", "yellow");
						ReportCredentialStateInvestigation(uow);
						RenderDashboard();
					}

					Thread.Sleep(10000);
					continue;
				}

				s_errors.Capture(
					ex,
					"H0UND-MAIN-LOOP-ERR-001",
					"Unhandled exception in H0UND main loop",
					context: new Dictionary<string, object>
					{
						["task"] = Dashboard.CurrentTask ?? string.Empty,
					});

				Dashboard.CurrentTask = "Error - Recovery";
				Dashboard.AddLog($"Error processing credential: {ex.Message}", "red");
				Dashboard.TrackError("GeneralException");
				Dashboard.IncrementPoll(false);
				RenderDashboard();

				// Reduce recovery time and be more intelligent about extension failures
				if (ex.Message.Contains("Extension failure"))
				{
					Thread.Sleep(5000);
					Dashboard.AddLog("Extension failure recovered, continuing...", "yellow");
				}
				else
				{
					Thread.Sleep(10000);
				}
			}
		}

		s_serviceOrchestrator?.StopAllAsync().GetAwaiter().GetResult();
		s_serviceOrchestrator?.Dispose();
		s_trayHost?.Dispose();
		s_consoleWindowManager?.Dispose();
	}

	private static void RenderDashboard()
	{
		if (!s_noUiMode)
		{
			Dashboard.Render();
		}
	}

	private static void ReportCredentialStateInvestigation(IUnitOfWork uow)
	{
		List<Credential> credentials = uow.Credentials.GetAll();
		int enabled = credentials.Count(c => c.Enabled);
		int banned = credentials.Count(c => c.Banned);
		int enabledAndBanned = credentials.Count(c => c.Enabled && c.Banned);
		int enabledAndNotBanned = credentials.Count(c => c.Enabled && !c.Banned);

		Dashboard.AddLog(
			$"Credential state snapshot: total={credentials.Count}, enabled={enabled}, banned={banned}, enabled+banned={enabledAndBanned}, actionable={enabledAndNotBanned}",
			"grey");
		Dashboard.AddLog("Investigation path: review CR3D3N7IAL Enabled/Banned flags and unlock at least one actionable credential.", "grey");
	}

	private static IErrorEvidence CreateErrorEvidence()
	{
		try
		{
			MongoConnectionOptions mongoOptions = MongoConnectionOptions.FromEnvironment();
			MongoDatabaseProvider provider = new(mongoOptions);
			ErrorEvidenceOptions options = new();
			IErrorEvidenceRepository repository = new MongoDebugEvidenceRepository(provider, options);
			IErrorEvidenceFactory factory = new ErrorEvidenceFactory(options);
			return new ErrorEvidenceService(repository, factory, options, msg => Dashboard.AddLog(msg, "grey"));
		}
		catch
		{
			return NoopErrorEvidence.Instance;
		}
	}

	private static void AcquireCredentialLock(IUnitOfWork uow, Credential credential, string operation)
	{
		uow.Credentials.Lock(credential);
		int depth = Interlocked.Increment(ref s_credentialLockDepth);
		if (depth <= 0)
		{
			s_errors.CaptureInvariantFailure(
				"H0UND-LOCK-INV-001",
				"Credential lock depth must remain positive after acquire",
				expected: true,
				actual: depth > 0,
				context: new Dictionary<string, object>
				{
					["operation"] = operation,
					["depth"] = depth,
					["credentialId"] = credential._id.ToString(),
				});
		}
	}

	private static void ReleaseCredentialLock(IUnitOfWork uow, Credential credential, string operation)
	{
		try
		{
			uow.Credentials.Unlock(credential);
		}
		catch (Exception ex)
		{
			s_errors.Capture(
				ex,
				"H0UND-LOCK-REL-ERR-001",
				"Credential unlock failed",
				context: new Dictionary<string, object>
				{
					["operation"] = operation,
					["credentialId"] = credential._id.ToString(),
				});
			return;
		}

		int depth = Interlocked.Decrement(ref s_credentialLockDepth);
		if (depth < 0)
		{
			s_errors.CaptureInvariantFailure(
				"H0UND-LOCK-INV-002",
				"Credential lock depth must not be negative",
				expected: true,
				actual: depth >= 0,
				context: new Dictionary<string, object>
				{
					["operation"] = operation,
					["depth"] = depth,
					["credentialId"] = credential._id.ToString(),
				});
		}
	}

	public static void RecordCircuitOpenSkip(IErrorEvidence errors, Credential credential)
	{
		errors.CaptureWarning(
			"H0UND-CIRCUIT-OPEN-001",
			"API circuit open; poll iteration skipped",
			context: new Dictionary<string, object>
			{
				["game"] = credential.Game,
				["house"] = credential.House ?? "Unknown",
				["credentialId"] = credential._id.ToString(),
			});
	}

	public static void RecordMainLoopError(IErrorEvidence errors, Exception ex, string task)
	{
		errors.Capture(
			ex,
			"H0UND-MAIN-LOOP-ERR-001",
			"Unhandled exception in H0UND main loop",
			context: new Dictionary<string, object>
			{
				["task"] = task,
			});
	}

	private static void StartTrayHost()
	{
		Thread trayThread = new(() =>
		{
			Application.EnableVisualStyles();
			s_trayHost = new TrayHost(
				new TrayCallback(
					onShowRequested: () => s_consoleWindowManager?.Show(),
					onHideRequested: () => s_consoleWindowManager?.Hide(),
					onExitRequested: () => s_exitRequested = true
				)
			);
			Application.Run();
		});

		trayThread.IsBackground = true;
		trayThread.Name = "TrayHostThread";
		trayThread.SetApartmentState(ApartmentState.STA);
		trayThread.Start();
	}

	private static void InitializeServiceOrchestrator()
	{
		var autostartConfigPath = ResolveAutostartConfigPath();
		var autostartConfig = AutostartConfig.LoadOrDefault(autostartConfigPath);

		// Pass startup config for delay/staggering support
		s_serviceOrchestrator = new ServiceOrchestrator(
			TimeSpan.FromSeconds(30),
			autostartConfig.Startup);

		s_serviceOrchestrator.OrchestratorEvent += (_, e) =>
			Dashboard.AddLog($"[Services] {e.ServiceName}: {e.EventType} - {e.Message}", "grey");

		if (autostartConfig.Services.Count == 0)
		{
			Dashboard.AddLog(
				$"No services found in autostart config: {autostartConfigPath}",
				"yellow");
		}

		foreach (var service in autostartConfig.Services)
		{
			// Use NodeManagedService for Node.js services with extended configuration
			bool hasNodeConfig = !string.IsNullOrWhiteSpace(service.WorkingDirectory)
				|| service.Environment.Count > 0
				|| service.StartupDelay > 0
				|| service.Type.Equals("node", StringComparison.OrdinalIgnoreCase);

			if (hasNodeConfig)
			{
				s_serviceOrchestrator.RegisterService(new NodeManagedService(
					service.Name,
					service.Executable,
					service.Arguments,
					service.HealthCheckUrl,
					service.WorkingDirectory,
					service.Environment,
					service.StartupDelay));
				continue;
			}

			if (service.Type.Equals("http", StringComparison.OrdinalIgnoreCase)
				&& !string.IsNullOrWhiteSpace(service.HealthCheckUrl))
			{
				s_serviceOrchestrator.RegisterService(new HttpManagedService(
					service.Name,
					service.Executable,
					service.Arguments,
					service.HealthCheckUrl));
				continue;
			}

			s_serviceOrchestrator.RegisterService(new StdioManagedService(
				service.Name,
				service.Executable,
				service.Arguments));
		}

		// Initialize ToolHive workloads if enabled
		if (autostartConfig.ToolHive.Enabled && autostartConfig.ToolHive.AutoStartWorkloads.Count > 0)
		{
			var toolHiveService = new ToolHiveWorkloadService(autostartConfig.ToolHive);
			toolHiveService.LogMessage += (_, msg) => Dashboard.AddLog(msg, "grey");

			// Start ToolHive workloads after a brief delay to let desktop initialize
			_ = Task.Run(async () =>
			{
				await Task.Delay(5000); // Wait for ToolHive desktop to initialize
				var started = await toolHiveService.StartWorkloadsAsync();
				Dashboard.AddLog($"[ToolHive] Started {started.Count}/{autostartConfig.ToolHive.AutoStartWorkloads.Count} workloads", "green");
			});
		}

		// Start all services (with stagger/delay from StartupConfig)
		_ = s_serviceOrchestrator.StartAllAsync();
	}

	private static string ResolveAutostartConfigPath()
	{
		var envPath = Environment.GetEnvironmentVariable("P4NTHE0N_AUTOSTART_CONFIG");
		if (!string.IsNullOrWhiteSpace(envPath) && File.Exists(envPath))
		{
			return envPath;
		}

		var candidates = new[]
		{
			@"C:\P4NTHE0N\config\autostart.json",
			Path.Combine(AppContext.BaseDirectory, "config", "autostart.json"),
			Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "config", "autostart.json")),
		};

		foreach (var candidate in candidates)
		{
			if (File.Exists(candidate))
			{
				return candidate;
			}
		}

		return candidates[0];
	}

	private sealed class TrayCallback : ITrayCallback
	{
		private readonly Action _onShowRequested;
		private readonly Action _onHideRequested;
		private readonly Action _onExitRequested;

		public TrayCallback(Action onShowRequested, Action onHideRequested, Action onExitRequested)
		{
			_onShowRequested = onShowRequested;
			_onHideRequested = onHideRequested;
			_onExitRequested = onExitRequested;
		}

		public void OnShowRequested() => _onShowRequested();

		public void OnHideRequested() => _onHideRequested();

		public void OnExitRequested() => _onExitRequested();
	}

	/// <summary>
	/// DECISION_085: Refresh dashboard schedule, withdraw accounts, and deposit-needed data from UoW.
	/// Called every 30s from the main loop.
	/// </summary>
	private static void RefreshDashboardSchedule(MongoUnitOfWork uow)
	{
		try
		{
			// Build jackpot schedule sorted by ETA (soonest first)
			List<Jackpot> allJackpots = uow.Jackpots.GetAll();
			var schedule = allJackpots
				.Where(j => j.EstimatedDate > DateTime.UtcNow && j.EstimatedDate < DateTime.UtcNow.AddDays(14))
				.OrderBy(j => j.EstimatedDate)
				.Select(j => new ScheduleEntry(
					j.House, j.Game, j.Category,
					j.EstimatedDate, j.Current, j.Threshold, j.Priority))
				.ToList();
			Dashboard.UpdateSchedule(schedule);

			// Build account lists from credentials
			List<Credential> allCreds = uow.Credentials.GetAll();

			// Withdraw: accounts with positive balance
			var withdraw = allCreds
				.Where(c => c.Balance > 0.01)
				.OrderByDescending(c => c.Balance)
				.Select(c => new AccountEntry(
					c.Username, c.House, c.Game, c.Balance, c.CashedOut, c.LastDepositDate))
				.ToList();
			Dashboard.UpdateWithdrawAccounts(withdraw);

			// Deposit needed: cashed-out accounts linked to upcoming jackpots (< 24h)
			var upcomingGames = schedule
				.Where(s => s.TimeUntil.TotalHours < 24)
				.Select(s => (s.House, s.Game, s.TimeUntil, s.Tier))
				.Distinct()
				.ToList();

			var deposits = new List<DepositEntry>();
			foreach (var (house, game, timeUntil, tier) in upcomingGames)
			{
				var cashedOutCreds = allCreds
					.Where(c => c.House == house && c.Game == game && c.CashedOut)
					.ToList();
				foreach (var cred in cashedOutCreds)
				{
					deposits.Add(new DepositEntry(
						cred.Username, cred.House, cred.Game, tier, timeUntil));
				}
			}
			Dashboard.UpdateDepositNeeded(
				deposits.OrderBy(d => d.TimeUntilJackpot).ToList());
		}
		catch (Exception ex)
		{
			Dashboard.AddLog($"Schedule refresh error: {ex.Message}", "yellow");
		}
	}

	/// <summary>
	/// DECISION_085: Update jackpot entities with current polling values.
	/// Ensures ETA calculations are based on latest data for all credentials, regardless of balance.
	/// </summary>
	private static void UpdateJackpotValues(MongoUnitOfWork uow, string house, string game, 
		double currentGrand, double currentMajor, double currentMinor, double currentMini)
	{
		try
		{
			// Update Grand
			var grand = uow.Jackpots.Get("Grand", house, game);
			if (grand != null)
			{
				grand.Current = currentGrand;
				grand.LastUpdated = DateTime.UtcNow;
				uow.Jackpots.Upsert(grand);
			}

			// Update Major
			var major = uow.Jackpots.Get("Major", house, game);
			if (major != null)
			{
				major.Current = currentMajor;
				major.LastUpdated = DateTime.UtcNow;
				uow.Jackpots.Upsert(major);
			}

			// Update Minor
			var minor = uow.Jackpots.Get("Minor", house, game);
			if (minor != null)
			{
				minor.Current = currentMinor;
				minor.LastUpdated = DateTime.UtcNow;
				uow.Jackpots.Upsert(minor);
			}

			// Update Mini
			var mini = uow.Jackpots.Get("Mini", house, game);
			if (mini != null)
			{
				mini.Current = currentMini;
				mini.LastUpdated = DateTime.UtcNow;
				uow.Jackpots.Upsert(mini);
			}
		}
		catch (Exception ex)
		{
			// Don't let jackpot update failures break the polling loop
			Dashboard.AddLog($"Jackpot update error for {house}/{game}: {ex.Message}", "yellow");
		}
	}
}

public static class H0UNDEvidenceHooks
{
	public static void RecordCircuitOpenSkip(IErrorEvidence errors, Credential credential)
	{
		errors.CaptureWarning(
			"H0UND-CIRCUIT-OPEN-001",
			"API circuit open; poll iteration skipped",
			context: new Dictionary<string, object>
			{
				["game"] = credential.Game,
				["house"] = credential.House ?? "Unknown",
				["credentialId"] = credential._id.ToString(),
			});
	}

	public static void RecordMainLoopError(IErrorEvidence errors, Exception ex, string task)
	{
		errors.Capture(
			ex,
			"H0UND-MAIN-LOOP-ERR-001",
			"Unhandled exception in H0UND main loop",
			context: new Dictionary<string, object>
			{
				["task"] = task,
			});
	}
}
