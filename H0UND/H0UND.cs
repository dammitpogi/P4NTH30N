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
	static async Task Main(string[] args)
	{
		// Check if we should run the VPN test program instead
		if (args.Length > 0 && args[0].Equals("test", StringComparison.OrdinalIgnoreCase))
		{
			await P4NTH30N.Testing.VPNTestProgram.RunTest(args.Skip(1).ToArray());
			return;
		}

		await VPNService.Initialize();
		Dashboard.VPNStatus = "Active";
		while (true)
		{
			// Health monitoring for H0UND
			List<(string tier, double value, double threshold)> recentJackpots = new();
			DateTime lastHealthCheck = DateTime.MinValue;
			
			while (!await VPNService.EnsureCompliantConnection())
			{
				Dashboard.VPNStatus = "Non-Compliant";
				Dashboard.CurrentTask = "VPN Wait";
				Dashboard.AddLog("VPN Non-Compliant. Retrying...", "yellow");
				Dashboard.Render();
				Thread.Sleep(5000);
			}
			Dashboard.VPNStatus = "Active";
			Dashboard.AddLog($"H0UND {Header.Version}", "blue");
			try
			{
				double lastRetrievedGrand = 0;
				Game? lastGame = null;

				while (true)
				{
					Dashboard.CurrentTask = "Polling Queue";
					Dashboard.Render();

					Game game = Game.GetNext();
					Credential? credential = Credential.GetBy(game)[0];

					Dashboard.CurrentGame = game.Name;
					Dashboard.CurrentUser = credential?.Username ?? "None";
					Dashboard.CurrentTask = "Retrieving Balances";
					Dashboard.Render();

					if (credential == null)
					{
						game.Unlock();
					}
					else
					{
						game.Lock();

						try
						{
							var balances = GetBalancesWithRetry(game, credential);
							
							// SANITY CHECK: Validate all jackpot values before processing
							var grandValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", balances.Grand, game.Thresholds.Grand);
							var majorValidation = P4NTH30NSanityChecker.ValidateJackpot("Major", balances.Major, game.Thresholds.Major);
							var minorValidation = P4NTH30NSanityChecker.ValidateJackpot("Minor", balances.Minor, game.Thresholds.Minor);
							var miniValidation = P4NTH30NSanityChecker.ValidateJackpot("Mini", balances.Mini, game.Thresholds.Mini);
							var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username);
							
							// Check for critical validation failures
							if (!grandValidation.IsValid || !majorValidation.IsValid || 
								!minorValidation.IsValid || !miniValidation.IsValid || !balanceValidation.IsValid)
							{
								Dashboard.AddLog($"🔴 Critical validation failure for {game.Name} - {credential.Username}", "red");
								game.Unlock();
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
								Dashboard.AddLog($"🔧 Repaired Grand for {game.Name}: {string.Join(", ", grandValidation.RepairActions)}", "yellow");
							}
							if (majorValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Major for {game.Name}: {string.Join(", ", majorValidation.RepairActions)}", "yellow");
							}
							if (minorValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Minor for {game.Name}: {string.Join(", ", minorValidation.RepairActions)}", "yellow");
							}
							if (miniValidation.WasRepaired) {
								Dashboard.AddLog($"🔧 Repaired Mini for {game.Name}: {string.Join(", ", miniValidation.RepairActions)}", "yellow");
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

							if ((lastRetrievedGrand.Equals(currentGrand) && (lastGame == null || game.Name != lastGame.Name && game.House != lastGame.House)) == false)
							{
								Signal? gameSignal = Signal.GetOne(game);
								if (currentGrand < game.Jackpots.Grand && game.Jackpots.Grand - currentGrand > 0.1)
								{
									if (game.DPD.Toggles.GrandPopped == true)
									{
										if (currentGrand >= 0 && currentGrand <= 10000)
										{
											game.Jackpots.Grand = currentGrand;
										}
										game.DPD.Toggles.GrandPopped = false;
										game.Thresholds.NewGrand(game.Jackpots.Grand);
										if (gameSignal != null && gameSignal.Priority.Equals(4))
											Signal.DeleteAll(game);
									}
									else
										game.DPD.Toggles.GrandPopped = true;
								}
								else
								{
									if (currentGrand >= 0 && currentGrand <= 10000)
									{
										game.Jackpots.Grand = currentGrand;
									}
								}

								if (currentMajor < game.Jackpots.Major && game.Jackpots.Major - currentMajor > 0.1)
								{
									if (game.DPD.Toggles.MajorPopped == true)
									{
										if (currentMajor >= 0 && currentMajor <= 10000)
										{
											game.Jackpots.Major = currentMajor;
										}
										game.DPD.Toggles.MajorPopped = false;
										game.Thresholds.NewMajor(game.Jackpots.Major);
										if (gameSignal != null && gameSignal.Priority.Equals(3))
											Signal.DeleteAll(game);
									}
									else
										game.DPD.Toggles.MajorPopped = true;
								}
								else
								{
									if (currentMajor >= 0 && currentMajor <= 10000)
									{
										game.Jackpots.Major = currentMajor;
									}
								}

								if (currentMinor < game.Jackpots.Minor && game.Jackpots.Minor - currentMinor > 0.1)
								{
									if (game.DPD.Toggles.MinorPopped == true)
									{
										if (currentMinor >= 0 && currentMinor <= 10000)
										{
											game.Jackpots.Minor = currentMinor;
										}
										game.DPD.Toggles.MinorPopped = false;
										game.Thresholds.NewMinor(game.Jackpots.Minor);
										if (gameSignal != null && gameSignal.Priority.Equals(2))
											Signal.DeleteAll(game);
									}
									else
										game.DPD.Toggles.MinorPopped = true;
								}
								else
								{
									if (currentMinor >= 0 && currentMinor <= 10000)
									{
										game.Jackpots.Minor = currentMinor;
									}
								}

								if (currentMini < game.Jackpots.Mini && game.Jackpots.Mini - currentMini > 0.1)
								{
									if (game.DPD.Toggles.MiniPopped == true)
									{
										if (currentMini >= 0 && currentMini <= 10000)
										{
											game.Jackpots.Mini = currentMini;
										}
										game.DPD.Toggles.MiniPopped = false;
										game.Thresholds.NewMini(game.Jackpots.Mini);
										if (gameSignal != null && gameSignal.Priority.Equals(1))
											Signal.DeleteAll(game);
									}
									else
										game.DPD.Toggles.MiniPopped = true;
								}
								else
								{
									if (currentMini >= 0 && currentMini <= 10000)
									{
										game.Jackpots.Mini = currentMini;
									}
								}
							}
							else
							{
								throw new Exception("Invalid grand retrieved.");
							}

							if (game.Settings.Gold777 == null)
								game.Settings.Gold777 = new Gold777_Settings();
							game.Updated = true;
							game.Unlock();

							credential.LastUpdated = DateTime.UtcNow;
							credential.Balance = currentBalance; // Use validated balance
							lastRetrievedGrand = currentGrand;
							credential.Save();
							lastGame = game;

							// SANITY CHECK: Periodic health monitoring
							if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5) {
								P4NTH30NSanityChecker.PerformHealthCheck(recentJackpots);
								var healthStatus = P4NTH30NSanityChecker.GetSystemHealth();
								Dashboard.AddLog($"💊 H0UND Health: {healthStatus.Status} | E:{healthStatus.ErrorCount} R:{healthStatus.RepairCount}", "blue");
								lastHealthCheck = DateTime.Now;
							}

							Dashboard.Render();
							Thread.Sleep(new Random().Next(0, 1501));
						}
						catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
						{
							Dashboard.AddLog($"Account suspended for {credential.Username} on {game.Name}", "red");
							Dashboard.Render();
							game.Unlock();
						}
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

	private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalances(Game game, Credential credential)
	{
		Random random = new();
		int delayMs = random.Next(500, 2001);
		Thread.Sleep(delayMs);

		try
		{
			switch (game.Name)
			{
				case "FireKirin":
				{
					// Console.WriteLine($"{DateTime.Now} - Querying FireKirin balances and jackpot data for {credential.Username}");
					var balances = FireKirin.QueryBalances(credential.Username, credential.Password);
					
					// SANITY CHECK: Validate retrieved balances before logging
					var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username);
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
						$"{game.Name} - {game.House} - {credential.Username} - ${validatedBalance:F2} - [{validatedGrand:F2}, {validatedMajor:F2}, {validatedMinor:F2}, {validatedMini:F2}]",
						"green"
					);
					return (validatedBalance, validatedGrand, validatedMajor, validatedMinor, validatedMini);
				}
				case "OrionStars":
				{
					// Console.WriteLine($"{DateTime.Now} - Querying OrionStars balances and jackpot data for {credential.Username}");
					var balances = OrionStars.QueryBalances(credential.Username, credential.Password);
					
					// SANITY CHECK: Validate retrieved balances before logging
					var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username);
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
						$"{game.Name} - {game.House} - {credential.Username} - ${validatedBalance:F2} - [{validatedGrand:F2}, {validatedMajor:F2}, {validatedMinor:F2}, {validatedMini:F2}]",
						"green"
					);
					return (validatedBalance, validatedGrand, validatedMajor, validatedMinor, validatedMini);
				}
				default:
					throw new Exception($"Uncrecognized Game Found. ('{game.Name}')");
			}
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
		{
			Dashboard.AddLog($"Account suspended for {credential.Username} on {game.Name}. Marking as banned.", "red");
			credential.Banned = true;
			credential.Save();
			throw;
		}
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(Game game, Credential credential)
	{
		(double Balance, double Grand, double Major, double Minor, double Mini) ExecuteQuery()
		{
			int networkAttempts = 0;
			while (true)
			{
				try
				{
					return QueryBalances(game, credential);
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
					Thread.Sleep(2000);
				}
			}
		}

		int grandChecked = 0;
		var balances = ExecuteQuery();
		double currentGrand = balances.Grand;
		while (currentGrand.Equals(0))
		{
			grandChecked++;
			Dashboard.AddLog($"Grand jackpot is 0 for {game.Name}, retrying attempt {grandChecked}/40", "yellow");
			Dashboard.Render();
			Thread.Sleep(500);
			if (grandChecked > 40)
			{
				ProcessEvent alert = ProcessEvent.Log("H0UND", $"Grand check signalled an Extension Failure for {game.Name}");
				Dashboard.AddLog($"Checking Grand on {game.Name} failed at {grandChecked} attempts.", "red");
				Dashboard.Render();
				alert.Record(credential).Save();
				throw new Exception("Extension failure.");
			}
			Dashboard.AddLog($"Retrying balance query for {game.Name} (attempt {grandChecked})", "yellow");
			Dashboard.Render();
			balances = ExecuteQuery();
			currentGrand = balances.Grand;
		}

		return balances;
	}
}
