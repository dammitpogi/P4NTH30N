using System.Diagnostics;
using System.Drawing;
using System.Text.Json;
using Figgle;
using P4NTH30N;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Versioning;
using P4NTH30N.C0MMON.SanityCheck;
using P4NTH30N.Services;

namespace P4NTH30N;

[GenerateFiggleText(sourceText: "v    0 . 8 . 6 . 3", memberName: "Version", fontName: "colossal")]
internal static partial class Header { }

class H0UND
{
	// Control flag: true = use priority calculation, false = full sweep (oldest first)
	private static readonly bool UsePriorityCalculation = false;
	
	static void Main(string[] args)
	{
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

					Credential credential = Credential.GetNext(UsePriorityCalculation);

					Dashboard.CurrentGame = credential.Game;
					Dashboard.CurrentUser = credential.Username ?? "None";
					Dashboard.CurrentTask = "Retrieving Balances";
					Dashboard.Render();

					credential.Lock();

					try
					{
						var balances = GetBalancesWithRetry(credential);
							
						// SANITY CHECK: Validate all jackpot values before processing
							var grandValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", balances.Grand, credential.Thresholds.Grand);
							var majorValidation = P4NTH30NSanityChecker.ValidateJackpot("Major", balances.Major, credential.Thresholds.Major);
							var minorValidation = P4NTH30NSanityChecker.ValidateJackpot("Minor", balances.Minor, credential.Thresholds.Minor);
							var miniValidation = P4NTH30NSanityChecker.ValidateJackpot("Mini", balances.Mini, credential.Thresholds.Mini);
						var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username ?? "Unknown");

							// Check for critical validation failures
							if (!grandValidation.IsValid || !majorValidation.IsValid ||
								!minorValidation.IsValid || !miniValidation.IsValid || !balanceValidation.IsValid)
							{
								Dashboard.AddLog($"🔴 Critical validation failure for {credential.Game} - {credential.Username}", "red");
								credential.Unlock();
								continue; // Skip this iteration for corrupted data
							}
							
							// Use validated values
							double currentGrand = grandValidation.ValidatedValue;
							double currentMajor = majorValidation.ValidatedValue;
							double currentMinor = minorValidation.ValidatedValue;
							double currentMini = miniValidation.ValidatedValue;
							double currentBalance = balanceValidation.ValidatedBalance;
							
							// Log any repairs that were made
							if (grandValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Grand for {credential.Game}: {string.Join(", ", grandValidation.RepairActions)}", "yellow");
							}
							if (majorValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Major for {credential.Game}: {string.Join(", ", majorValidation.RepairActions)}", "yellow");
							}
							if (minorValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Minor for {credential.Game}: {string.Join(", ", minorValidation.RepairActions)}", "yellow");
							}
							if (miniValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Mini for {credential.Game}: {string.Join(", ", miniValidation.RepairActions)}", "yellow");
							}
							if (balanceValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Balance for {credential.Username}: {string.Join(", ", balanceValidation.RepairActions)}", "yellow");
							}
							
							// Track validated values for health monitoring
							recentJackpots.Add(("Grand", currentGrand, grandValidation.ValidatedThreshold));
							recentJackpots.Add(("Major", currentMajor, majorValidation.ValidatedThreshold));
							recentJackpots.Add(("Minor", currentMinor, minorValidation.ValidatedThreshold));
							recentJackpots.Add(("Mini", currentMini, miniValidation.ValidatedThreshold));
							
							// Limit to last 40 entries (10 per tier)
							if (recentJackpots.Count > 40) {
								recentJackpots.RemoveRange(0, 4);
							}

							if ((lastRetrievedGrand.Equals(currentGrand) && (lastCredential == null || credential.Game != lastCredential.Game && credential.House != lastCredential.House)) == false)
							{
								Signal? gameSignal = Signal.GetOne(credential.House, credential.Game);
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
											Signal.DeleteAll(credential.House, credential.Game);
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
											Signal.DeleteAll(credential.House, credential.Game);
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
											Signal.DeleteAll(credential.House, credential.Game);
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
											Signal.DeleteAll(credential.House, credential.Game);
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
							credential.Unlock();

							credential.LastUpdated = DateTime.UtcNow;
							credential.Balance = currentBalance; // Use validated balance
							lastRetrievedGrand = currentGrand;
							credential.Save();
							lastCredential = credential;

							// SANITY CHECK: Periodic health monitoring
							if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5) {
								P4NTH30NSanityChecker.PerformHealthCheck(recentJackpots);
								var healthStatus = P4NTH30NSanityChecker.GetSystemHealth();
								Dashboard.AddLog($"💊 H0UND Health: {healthStatus.Status} | E:{healthStatus.ErrorCount} R:{healthStatus.RepairCount}", "blue");
								lastHealthCheck = DateTime.Now;
							}

						Dashboard.Render();
						Thread.Sleep(Random.Shared.Next(3000, 5001));
					}
						catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
						{
							Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}", "red");
							Dashboard.Render();
							credential.Unlock();
					}
				}
			}
		catch (Exception ex)
			{
				Dashboard.CurrentTask = "Error - Waiting";
				Dashboard.AddLog(ex.Message, "red");
				Dashboard.Render();
				Thread.Sleep(30000);
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
					// Console.WriteLine($"{DateTime.Now} - Querying FireKirin balances and jackpot data for {credential.Username}");
					var balances = FireKirin.QueryBalances(credential.Username, credential.Password);

					// SANITY CHECK: Validate retrieved balances before logging
					var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username ?? "Unknown");
					var grandValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", balances.Grand, 10000);
					var majorValidation = P4NTH30NSanityChecker.ValidateJackpot("Major", balances.Major, 1000);
					var minorValidation = P4NTH30NSanityChecker.ValidateJackpot("Minor", balances.Minor, 200);
					var miniValidation = P4NTH30NSanityChecker.ValidateJackpot("Mini", balances.Mini, 50);

					// Use validated values for logging and return
					double validatedBalance = balanceValidation.ValidatedBalance;
					double validatedGrand = grandValidation.ValidatedValue;
					double validatedMajor = majorValidation.ValidatedValue;
					double validatedMinor = minorValidation.ValidatedValue;
					double validatedMini = miniValidation.ValidatedValue;

					Dashboard.AddLog(
						$"{credential.Game} - {credential.House} - {credential.Username} - ${validatedBalance:F2} - [{validatedGrand:F2}, {validatedMajor:F2}, {validatedMinor:F2}, {validatedMini:F2}]",
						"green"
					);
					return (validatedBalance, validatedGrand, validatedMajor, validatedMinor, validatedMini);
				}
				case "OrionStars":
				{
					// Console.WriteLine($"{DateTime.Now} - Querying OrionStars balances and jackpot data for {credential.Username}");
					var balances = OrionStars.QueryBalances(credential.Username, credential.Password);

					// SANITY CHECK: Validate retrieved balances before logging
					var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username ?? "Unknown");
					var grandValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", balances.Grand, 10000);
					var majorValidation = P4NTH30NSanityChecker.ValidateJackpot("Major", balances.Major, 1000);
					var minorValidation = P4NTH30NSanityChecker.ValidateJackpot("Minor", balances.Minor, 200);
					var miniValidation = P4NTH30NSanityChecker.ValidateJackpot("Mini", balances.Mini, 50);

					// Use validated values for logging and return
					double validatedBalance = balanceValidation.ValidatedBalance;
					double validatedGrand = grandValidation.ValidatedValue;
					double validatedMajor = majorValidation.ValidatedValue;
					double validatedMinor = minorValidation.ValidatedValue;
					double validatedMini = miniValidation.ValidatedValue;

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
			credential.Save();
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
			Dashboard.AddLog($"Grand jackpot is 0 for {credential.Game}, retrying attempt {grandChecked}/40", "yellow");
			Dashboard.Render();
			Thread.Sleep(500);
			if (grandChecked > 40)
			{
				ProcessEvent alert = ProcessEvent.Log("H0UND", $"Grand check signalled an Extension Failure for {credential.Game}");
				Dashboard.AddLog($"Checking Grand on {credential.Game} failed at {grandChecked} attempts.", "red");
				Dashboard.Render();
				alert.Record(credential).Save();
				throw new Exception("Extension failure.");
			}
			Dashboard.AddLog($"Retrying balance query for {credential.Game} (attempt {grandChecked})", "yellow");
			Dashboard.Render();
			balances = ExecuteQuery();
			currentGrand = balances.Grand;
		}

		return balances;
	}
}
