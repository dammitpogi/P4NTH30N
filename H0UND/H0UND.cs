using System.Diagnostics;
using System.Drawing;
using System.Text.Json;
using Figgle;
using P4NTH30N;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Versioning;
using P4NTH30N.C0MMON.Persistence;
using P4NTH30N.Services;

namespace P4NTH30N;

[GenerateFiggleText(sourceText: "v    0 . 8 . 6 . 3", memberName: "Version", fontName: "colossal")]
internal static partial class Header { }

class H0UND
{
	private static readonly MongoUnitOfWork s_uow = new();

	// Control flag: true = use priority calculation, false = full sweep (oldest first)
	private static readonly bool UsePriorityCalculation = false;
	
	static void Main(string[] args)
	{
		MongoUnitOfWork uow = s_uow;
		while (true)
		{
			// Health monitoring for H0UND
			List<(string tier, double value, double threshold)> recentJackpots = new();
			DateTime lastHealthCheck = DateTime.MinValue;
			
			Dashboard.AddLog($"{Header.Version}", "blue");
			Dashboard.AddLog("H0UND", "blue");
			Dashboard.AddLog($"Priority: {(UsePriorityCalculation ? "ON" : "OFF (Full Sweep)")}", "blue");
			try
			{
				double lastRetrievedGrand = 0;
				Credential? lastCredential = null;

				while (true)
				{
					Dashboard.CurrentTask = "Polling Queue";
					Dashboard.Render();

					Credential credential = uow.Credentials.GetNext(UsePriorityCalculation);

					Dashboard.CurrentGame = credential.Game;
					Dashboard.CurrentUser = credential.Username ?? "None";
					Dashboard.CurrentTask = "Retrieving Balances";
					Dashboard.Render();

					uow.Credentials.Lock(credential);

					try
					{
						var balances = GetBalancesWithRetry(credential);
							
						// Validate raw values before processing
						bool rawValuesValid = 
							!double.IsNaN(balances.Grand) && !double.IsInfinity(balances.Grand) && balances.Grand >= 0 &&
							!double.IsNaN(balances.Major) && !double.IsInfinity(balances.Major) && balances.Major >= 0 &&
							!double.IsNaN(balances.Minor) && !double.IsInfinity(balances.Minor) && balances.Minor >= 0 &&
							!double.IsNaN(balances.Mini) && !double.IsInfinity(balances.Mini) && balances.Mini >= 0 &&
							!double.IsNaN(balances.Balance) && !double.IsInfinity(balances.Balance) && balances.Balance >= 0;

						if (!rawValuesValid) {
							Dashboard.AddLog($"🔴 Critical validation failure for {credential.Game} - {credential.Username}: invalid raw values", "red");
							uow.Errors.Insert(ErrorLog.Create(
								ErrorType.ValidationError,
								"H0UND",
								$"Invalid raw values for {credential.Username}@{credential.Game}: Grand={balances.Grand}, Major={balances.Major}, Minor={balances.Minor}, Mini={balances.Mini}, Balance={balances.Balance}",
								ErrorSeverity.Critical
							));
							ProcessEvent alert = ProcessEvent.Log("H0UND", $"Validation failure for {credential.Game}: invalid raw values");
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

						// Track values for health monitoring
						recentJackpots.Add(("Grand", currentGrand, credential.Thresholds.Grand));
						recentJackpots.Add(("Major", currentMajor, credential.Thresholds.Major));
						recentJackpots.Add(("Minor", currentMinor, credential.Thresholds.Minor));
						recentJackpots.Add(("Mini", currentMini, credential.Thresholds.Mini));
						
						// Limit to last 40 entries (10 per tier)
						if (recentJackpots.Count > 40) {
							recentJackpots.RemoveRange(0, 4);
						}

							if ((lastRetrievedGrand.Equals(currentGrand) && (lastCredential == null || credential.Game != lastCredential.Game && credential.House != lastCredential.House)) == false)
							{
								Signal? gameSignal = uow.Signals.GetOne(credential.House, credential.Game);
								if (currentGrand < credential.Jackpots.Grand && credential.Jackpots.Grand - currentGrand > 0.1)
								{
									if (credential.DPD.Toggles.GrandPopped == true)
									{
										if (currentGrand >= 0 && currentGrand <= 10000)
										{
											credential.Jackpots.Grand = currentGrand;
										}
										credential.DPD.Toggles.GrandPopped = false;
										credential.Thresholds.NewGrand(credential.Jackpots.Grand);
										if (gameSignal != null && gameSignal.Priority.Equals(4))
											uow.Signals.DeleteAll(credential.House, credential.Game);
									}
									else
										credential.DPD.Toggles.GrandPopped = true;
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
									if (credential.DPD.Toggles.MajorPopped == true)
									{
										if (currentMajor >= 0 && currentMajor <= 10000)
										{
											credential.Jackpots.Major = currentMajor;
										}
										credential.DPD.Toggles.MajorPopped = false;
										credential.Thresholds.NewMajor(credential.Jackpots.Major);
										if (gameSignal != null && gameSignal.Priority.Equals(3))
											uow.Signals.DeleteAll(credential.House, credential.Game);
									}
									else
										credential.DPD.Toggles.MajorPopped = true;
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
									if (credential.DPD.Toggles.MinorPopped == true)
									{
										if (currentMinor >= 0 && currentMinor <= 10000)
										{
											credential.Jackpots.Minor = currentMinor;
										}
										credential.DPD.Toggles.MinorPopped = false;
										credential.Thresholds.NewMinor(credential.Jackpots.Minor);
										if (gameSignal != null && gameSignal.Priority.Equals(2))
											uow.Signals.DeleteAll(credential.House, credential.Game);
									}
									else
										credential.DPD.Toggles.MinorPopped = true;
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
									if (credential.DPD.Toggles.MiniPopped == true)
									{
										if (currentMini >= 0 && currentMini <= 10000)
										{
											credential.Jackpots.Mini = currentMini;
										}
										credential.DPD.Toggles.MiniPopped = false;
										credential.Thresholds.NewMini(credential.Jackpots.Mini);
										if (gameSignal != null && gameSignal.Priority.Equals(1))
											uow.Signals.DeleteAll(credential.House, credential.Game);
									}
									else
										credential.DPD.Toggles.MiniPopped = true;
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
							credential.Balance = currentBalance; // Use validated balance
							lastRetrievedGrand = currentGrand;
							uow.Credentials.Upsert(credential);
							lastCredential = credential;

							// Periodic health monitoring
							if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5) {
								var recentErrors = uow.Errors.GetBySource("H0UND").Take(10).ToList();
								string status = recentErrors.Any(e => e.Severity == ErrorSeverity.Critical) ? "CRITICAL" : "HEALTHY";
								Dashboard.AddLog($"💊 H0UND Health: {status} | Errors: {recentErrors.Count}", "blue");
								lastHealthCheck = DateTime.Now;
							}

						Dashboard.Render();
						Thread.Sleep(Random.Shared.Next(3000, 5001));
					}
						catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
						{
							Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}", "red");
							Dashboard.Render();
							uow.Credentials.Unlock(credential);
					}
				}
			}
		catch (Exception ex)
		{
			Dashboard.CurrentTask = "Error - Recovery";
			Dashboard.AddLog($"Error processing credential: {ex.Message}", "red");
			Dashboard.Render();
			
			// Reduce recovery time and be more intelligent about extension failures
			if (ex.Message.Contains("Extension failure"))
			{
				Thread.Sleep(5000); // Reduced from 30 seconds to 5 seconds
				Dashboard.AddLog("Extension failure recovered, continuing...", "yellow");
			}
			else
			{
				Thread.Sleep(10000); // 10 seconds for other errors
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
					if (double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0) {
						validatedBalance = 0;
					}
					if (double.IsNaN(validatedGrand) || double.IsInfinity(validatedGrand) || validatedGrand < 0) {
						validatedGrand = 0;
					}
					if (double.IsNaN(validatedMajor) || double.IsInfinity(validatedMajor) || validatedMajor < 0) {
						validatedMajor = 0;
					}
					if (double.IsNaN(validatedMinor) || double.IsInfinity(validatedMinor) || validatedMinor < 0) {
						validatedMinor = 0;
					}
					if (double.IsNaN(validatedMini) || double.IsInfinity(validatedMini) || validatedMini < 0) {
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
					if (double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0) {
						validatedBalance = 0;
					}
					if (double.IsNaN(validatedGrand) || double.IsInfinity(validatedGrand) || validatedGrand < 0) {
						validatedGrand = 0;
					}
					if (double.IsNaN(validatedMajor) || double.IsInfinity(validatedMajor) || validatedMajor < 0) {
						validatedMajor = 0;
					}
					if (double.IsNaN(validatedMinor) || double.IsInfinity(validatedMinor) || validatedMinor < 0) {
						validatedMinor = 0;
					}
					if (double.IsNaN(validatedMini) || double.IsInfinity(validatedMini) || validatedMini < 0) {
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
		var balances = ExecuteQuery();
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
				s_uow.ProcessEvents.Insert(alert.Record(credential));
				// Don't throw exception - treat zero as valid and continue processing
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
