using System.Diagnostics;
using System.Drawing;
using System.Text.Json;
using Figgle;
using P4NTH30N;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.C0MMON.Infrastructure.Resilience;
using P4NTH30N.C0MMON.Monitoring;
using P4NTH30N.C0MMON.Versioning;
using P4NTH30N.H0UND.Application.Analytics;
using P4NTH30N.H0UND.Application.Polling;
using P4NTH30N.H0UND.Domain.Signals;
using P4NTH30N.H0UND.Infrastructure.Polling;
using P4NTH30N.C0MMON.Services.Display;
using P4NTH30N.H0UND.Services;
using P4NTH30N.Services;

namespace P4NTH30N;

[GenerateFiggleText(sourceText: "v    0 . 8 . 6 . 3", memberName: "Version", fontName: "colossal")]
internal static partial class Header { }

internal class Program
{
	private static readonly MongoUnitOfWork s_uow = new();

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

	// DECISION_025: Anomaly detection for jackpot patterns
	private static readonly AnomalyDetector s_anomalyDetector = new(
		windowSize: 50,
		compressionThreshold: 1.3,
		zScoreThreshold: 3.0,
		onAnomaly: anomaly =>
		{
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
					ErrorSeverity.High
				));
			}
			catch { /* don't let anomaly logging break the main loop */ }
		}
	);

	static void Main(string[] args)
	{
		MongoUnitOfWork uow = s_uow;

		// DECISION_085: Initialize display pipeline before anything else
		DisplayEventBus displayBus = Dashboard.InitializeDisplayPipeline();

		// Initialize idempotent signal generation infrastructure
		AnalyticsWorker analyticsWorker;
		if (UseIdempotentSignals)
		{
			// DECISION_085: Route infrastructure loggers through display bus with proper levels
			Action<string> lockLogger = displayBus.CreateLogger("DistributedLock", DisplayLogLevel.Silent);
			Action<string> signalLogger = displayBus.CreateSmartLogger("IdempotentSignal", DisplayLogLevel.Debug);
			Action<string> metricsLogger = displayBus.CreateLogger("SignalMetrics", DisplayLogLevel.Detail, "cyan");

			DistributedLockService lockService = new(uow.DatabaseProvider, lockLogger);
			SignalDeduplicationCache dedupCache = new();
			InMemoryDeadLetterQueue deadLetterQueue = new();
			RetryPolicy retryPolicy = new(maxRetries: 3, baseDelay: TimeSpan.FromMilliseconds(100),
				logger: displayBus.CreateSmartLogger("RetryPolicy", DisplayLogLevel.Debug));
			P4NTH30N.C0MMON.Infrastructure.Monitoring.SignalMetrics signalMetrics = new(
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

		BalanceProviderFactory balanceProviderFactory = new BalanceProviderFactory();
		PollingWorker pollingWorker = new PollingWorker(balanceProviderFactory);
		s_healthService = new C0MMON.Monitoring.HealthCheckService(uow.DatabaseProvider, s_apiCircuit, s_mongoCircuit, uow);

		// Initialize dashboard with startup info
		Dashboard.AddLog($"{Header.Version}", "blue");
		Dashboard.AddLog("H0UND Started", "blue");
		Dashboard.AddLog($"Priority: {(UsePriorityCalculation ? "ON" : "OFF (Full Sweep)")}", "blue");
		Dashboard.AddAnalyticsLog("Analytics engine initialized", "cyan");
		Dashboard.AddAnalyticsLog("Awaiting telemetry...", "grey");

		// Set total credentials count
		try
		{
			var allCreds = uow.Credentials.GetAll();
			Dashboard.TotalCredentials = allCreds.Count();
			Dashboard.AddLog($"Loaded {Dashboard.TotalCredentials} credentials", "green");
		}
		catch (Exception ex)
		{
			Dashboard.AddLog($"Warning: Could not load credential count: {ex.Message}", "yellow");
		}

		while (true)
		{
			DateTime lastHealthCheck = DateTime.MinValue;

			try
			{
				double lastRetrievedGrand = 0;
				Credential? lastCredential = null;

				while (true)
				{
					// Handle pause state
					if (Dashboard.IsPaused)
					{
						Dashboard.Render();
						Thread.Sleep(100);
						continue;
					}

					// Time-gated analytics phase
					if ((DateTime.UtcNow - s_lastAnalyticsRunUtc).TotalSeconds >= AnalyticsIntervalSeconds)
					{
						Dashboard.CurrentTask = "Running Analytics";
						Dashboard.Render();
						analyticsWorker.RunAnalytics(uow);
						s_lastAnalyticsRunUtc = DateTime.UtcNow;
					}

					// DECISION_085: Periodic schedule/account data refresh
					if ((DateTime.UtcNow - s_lastScheduleRefreshUtc).TotalSeconds >= ScheduleRefreshIntervalSeconds)
					{
						RefreshDashboardSchedule(uow);
						s_lastScheduleRefreshUtc = DateTime.UtcNow;
					}

					Dashboard.CurrentTask = "Polling Queue";
					Dashboard.Render();

					Credential credential = uow.Credentials.GetNext(UsePriorityCalculation);

					Dashboard.CurrentGame = credential.Game;
					Dashboard.CurrentUser = credential.Username ?? "None";
					Dashboard.CurrentHouse = credential.House ?? "Unknown";
					Dashboard.CurrentTask = "Retrieving Balances";
					Dashboard.Render();

					uow.Credentials.Lock(credential);

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
									ErrorSeverity.Critical
								)
							);
							P4NTH30N.C0MMON.ProcessEvent alert = P4NTH30N.C0MMON.ProcessEvent.Log(
								"H0UND",
								$"Validation failure for {credential.Game}: invalid raw values"
							);
							s_uow.ProcessEvents.Insert(alert.Record(credential));
							uow.Credentials.Unlock(credential);
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
						uow.Credentials.Unlock(credential);

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
								Dashboard.AddLog(
									$"H0UND Health: {health.OverallStatus} | {checksummary} | Degradation: {s_degradation.CurrentLevel} | Uptime: {health.Uptime:hh\\:mm\\:ss}",
									health.OverallStatus == C0MMON.Monitoring.HealthStatus.Healthy ? "blue" : "red"
								);
							}
							lastHealthCheck = DateTime.Now;
						}

						Dashboard.Render();

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
						Dashboard.AddLog($"API circuit open - skipping {credential.Username}@{credential.Game}", "yellow");
						Dashboard.IncrementPoll(false);
						Dashboard.Render();
						uow.Credentials.Unlock(credential);
						Thread.Sleep(5000);
					}
					catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
					{
						Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}", "red");
						Dashboard.TrackError("AccountSuspended");
						Dashboard.IncrementPoll(false);
						Dashboard.Render();
						uow.Credentials.Unlock(credential);
					}
					finally
					{
						// DECISION_070: Safety net — credential must never stay permanently locked
						try { uow.Credentials.Unlock(credential); } catch { }
					}
				}
			}
			catch (Exception ex)
			{
				Dashboard.CurrentTask = "Error - Recovery";
				Dashboard.AddLog($"Error processing credential: {ex.Message}", "red");
				Dashboard.TrackError("GeneralException");
				Dashboard.IncrementPoll(false);
				Dashboard.Render();

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
