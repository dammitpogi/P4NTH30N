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
using P4NTH30N.H0UND.Infrastructure.Polling;
using P4NTH30N.Services;

namespace P4NTH30N;

[GenerateFiggleText(sourceText: "v    0 . 8 . 6 . 3", memberName: "Version", fontName: "colossal")]
internal static partial class Header { }

internal class Program
{
	private static readonly MongoUnitOfWork s_uow = new();

	// Control flag: true = use priority calculation, false = full sweep (oldest first)
	private static readonly bool UsePriorityCalculation = false;

	// Analytics phase timing
	private static DateTime s_lastAnalyticsRunUtc = DateTime.MinValue;
	private const int AnalyticsIntervalSeconds = 10;

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
	private static HealthCheckService? s_healthService;

	static void Main(string[] args)
	{
		MongoUnitOfWork uow = s_uow;
		AnalyticsWorker analyticsWorker = new AnalyticsWorker();
		BalanceProviderFactory balanceProviderFactory = new BalanceProviderFactory();
		PollingWorker pollingWorker = new PollingWorker(balanceProviderFactory);
		s_healthService = new HealthCheckService(uow.DatabaseProvider, s_apiCircuit, s_mongoCircuit, uow);

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
								var grandJackpot = uow.Jackpots.Get("Grand", credential.House, credential.Game);
								if (grandJackpot != null && grandJackpot.DPD.Toggles.GrandPopped == true)
								{
									if (currentGrand >= 0 && currentGrand <= 10000)
									{
										credential.Jackpots.Grand = currentGrand;
									}
									grandJackpot.DPD.Toggles.GrandPopped = false;
									credential.Thresholds.NewGrand(credential.Jackpots.Grand);
									if (gameSignal != null && gameSignal.Priority.Equals(4))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
								}
								else
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
								if (majorJackpot != null && majorJackpot.DPD.Toggles.MajorPopped == true)
								{
									if (currentMajor >= 0 && currentMajor <= 10000)
									{
										credential.Jackpots.Major = currentMajor;
									}
									majorJackpot.DPD.Toggles.MajorPopped = false;
									credential.Thresholds.NewMajor(credential.Jackpots.Major);
									if (gameSignal != null && gameSignal.Priority.Equals(3))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
								}
								else
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
								if (minorJackpot != null && minorJackpot.DPD.Toggles.MinorPopped == true)
								{
									if (currentMinor >= 0 && currentMinor <= 10000)
									{
										credential.Jackpots.Minor = currentMinor;
									}
									minorJackpot.DPD.Toggles.MinorPopped = false;
									credential.Thresholds.NewMinor(credential.Jackpots.Minor);
									if (gameSignal != null && gameSignal.Priority.Equals(2))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
								}
								else
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
								if (miniJackpot != null && miniJackpot.DPD.Toggles.MiniPopped == true)
								{
									if (currentMini >= 0 && currentMini <= 10000)
									{
										credential.Jackpots.Mini = currentMini;
									}
									miniJackpot.DPD.Toggles.MiniPopped = false;
									credential.Thresholds.NewMini(credential.Jackpots.Mini);
									if (gameSignal != null && gameSignal.Priority.Equals(1))
										uow.Signals.DeleteAll(credential.House ?? "Unknown", credential.Game);
								}
								else
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

						// Track successful poll
						Dashboard.IncrementPoll(true);
						Dashboard.ActiveCredentials = 1;

						// Periodic health monitoring with full system health check
						if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5)
						{
							if (s_healthService != null)
							{
								SystemHealth health = s_healthService.GetSystemHealthAsync().GetAwaiter().GetResult();
								string checksummary = string.Join(" | ", health.Checks.Select(c => $"{c.Component}:{c.Status}"));
								Dashboard.AddLog(
									$"H0UND Health: {health.OverallStatus} | {checksummary} | Degradation: {s_degradation.CurrentLevel} | Uptime: {health.Uptime:hh\\:mm\\:ss}",
									health.OverallStatus == HealthStatus.Healthy ? "blue" : "red"
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
}
