using OpenQA.Selenium.Chrome;
using P4NTH30N;
using Figgle;

using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Versioning;
using P4NTH30N.C0MMON.SanityCheck;
using P4NTH30N.C0MMON.Persistence;
using P4NTH30N.Services;
using System.Drawing;
using System.Text.Json;
using System.Diagnostics;
using Figgle.Fonts;


namespace P4NTH30N {
    internal static class Header {
        public static string Version => FiggleFonts.Colossal.Render($"v {AppVersion.GetDisplayVersion()}");
    }
}

internal class Program {
	private static readonly MongoUnitOfWork s_uow = new();

    private static void Main(string[] args) {
		MongoUnitOfWork uow = s_uow;
        string runMode = args.Length > 0 ? args[0] : "H4ND"; bool listenForSignals = true;
        if (new[] { "H4ND", "H0UND" }.Contains(runMode).Equals(false)) {
            string errorMessage = $"RunMode Argument was invalid. ({runMode})";
            Console.WriteLine(errorMessage); Console.ReadKey(true).KeyChar.ToString();
            throw new Exception(errorMessage);
        } else if (runMode.Equals("H0UND")) {
            listenForSignals = false;
        }

		while (true) {
			Console.WriteLine(Header.Version);
			ChromeDriver? driver = null;
			
			// Health monitoring for H4ND
			List<(string tier, double value, double threshold)> recentJackpots = new();
			DateTime lastHealthCheck = DateTime.MinValue;
			
            try {
                double lastRetrievedGrand = 0;
                Signal? overrideSignal = null;
                Credential? lastCredential = null;

                while (true) {
                    // Credential credential = Credential.GetBy("FireKirin", "MIDAS 2", "Stone1020");
                    // Signal signal = new Signal(4, credential);
					Signal? signal = listenForSignals ? (overrideSignal ?? uow.Signals.GetNext()) : null;
					Credential? credential = (signal == null) ? uow.Credentials.GetNext(false) : uow.Credentials.GetBy(signal.House, signal.Game, signal.Username);
					overrideSignal = null;

                    if (credential == null) {
                        continue;
                    } else {
						uow.Credentials.Lock(credential);
						if (signal != null)
							uow.Signals.Acknowledge(signal);

						if (signal != null) {
							if (driver == null) {
								driver = Actions.Launch();
							}

							switch (credential.Game) {
								case "FireKirin":
									break;
                                case "OrionStars":
                                    if (lastCredential == null || lastCredential.Game != credential.Game) {
                                        driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
										if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false) {
											Console.WriteLine($"{DateTime.Now} - {credential.House} took too long to load for {credential.Game}");
											uow.Credentials.Lock(credential); //throw new Exception("Took too long to load.");
										}
                                        Mouse.Click(535, 615);
                                    }
										if (OrionStars.Login(driver, credential.Username, credential.Password) == false) {
											Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
											Console.WriteLine($"{DateTime.Now} - {credential.Username} : {credential.Password}");
											uow.Credentials.Lock(credential);
											continue;
										}
                                    break;
                                default:
                                    throw new Exception($"Uncrecognized Game Found. ('{credential.Game}')");
                            }
                        }

						int grandChecked = 0;
						if (driver == null) {
							driver = Actions.Launch();
						}

						ChromeDriver activeDriver = driver;
						double extensionGrand = Convert.ToDouble(activeDriver.ExecuteScript("return window.parent.Grand")) / 100;
						while (extensionGrand.Equals(0)) {
							Thread.Sleep(500);
									if (grandChecked++ > 40) {
										ProcessEvent alert = ProcessEvent.Log("H4ND",$"Grand check signalled an Extension Failure for {credential.Game}");
										Console.WriteLine($"Checking Grand on {credential.Game} failed at {grandChecked} attempts.");
										uow.ProcessEvents.Insert(alert.Record(credential));
										throw new Exception("Extension failure.");
									}
							extensionGrand = Convert.ToDouble(activeDriver.ExecuteScript("return window.parent.Grand")) / 100;
						}

                        var balances = GetBalancesWithRetry(credential);

                        // SANITY CHECK: Validate all retrieved values before processing
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
								Dashboard.Render();
								uow.Credentials.Unlock(credential);
								credential.LastUpdated = DateTime.UtcNow;
								uow.Credentials.Upsert(credential);
								continue; // Skip this iteration for corrupted data
							}
                        
                        // Use validated values for all subsequent processing
                        double currentGrand = grandValidation.ValidatedValue;
                        double currentMajor = majorValidation.ValidatedValue;
                        double currentMinor = minorValidation.ValidatedValue;
                        double currentMini = miniValidation.ValidatedValue;
                        double validatedBalance = balanceValidation.ValidatedBalance;
                        
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
                        
                        // Track for health monitoring
                        recentJackpots.Add(("Grand", currentGrand, grandValidation.ValidatedThreshold));
                        recentJackpots.Add(("Major", currentMajor, majorValidation.ValidatedThreshold));
                        recentJackpots.Add(("Minor", currentMinor, minorValidation.ValidatedThreshold));
                        recentJackpots.Add(("Mini", currentMini, miniValidation.ValidatedThreshold));
                        
                        // Limit to last 40 entries
                        if (recentJackpots.Count > 40) {
                            recentJackpots.RemoveRange(0, 4);
                        }

							if (signal != null) {
								uow.Signals.Acknowledge(signal);
								File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(true));
								switch (signal.Priority) {
									case 1: signal.Receive(currentMini, uow.Received); break;
									case 2: signal.Receive(currentMinor, uow.Received); break;
									case 3: signal.Receive(currentMajor, uow.Received); break;
									case 4: signal.Receive(currentGrand, uow.Received); break;
								}

								uow.Signals.Acknowledge(signal);
								switch (credential.Game) {
									case "FireKirin":
										Mouse.Click(80, 235); Thread.Sleep(800); //Reset Hall Screen
										FireKirin.SpinSlots(driver, credential, signal, uow);
										break;
									case "OrionStars":
										Mouse.Click(80, 200); Thread.Sleep(800);
										// overrideSignal = Games.Gold777(driver, credential, signal);
										bool FortunePiggyLoaded = Games.FortunePiggy.LoadSucessfully(driver, credential, signal, uow);
										overrideSignal = FortunePiggyLoaded ? Games.FortunePiggy.Spin(driver, credential, signal, uow) : null;

                                    driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                    P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                                    Thread.Sleep(2000); Mouse.Click(80, 200); Thread.Sleep(800);
                                    break;
                            }
                            Console.WriteLine($"({DateTime.Now}) {credential.House} - Completed Reel Spins...");
                            //ProcessEvent.Log("SignalReceived", $"Finished Spinning for {credential.House} - Username: {signal.Username}").Record(signal).Save();
                            // throw new Exception("Finished Spinning");
                            lastCredential = null;
                            balances = GetBalancesWithRetry(credential);
                            // Re-validate post-spin balances
                            var postSpinBalanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username ?? "Unknown");
							validatedBalance = postSpinBalanceValidation.ValidatedBalance;
						} else if (signal == null) {
							uow.Credentials.Lock(credential);
						}

                        // Use validated values from earlier in the processing loop
                        // currentMajor, currentMinor, currentMini already set from validation above

if ((lastRetrievedGrand.Equals(currentGrand) && (lastCredential == null || credential.Game != lastCredential.Game && credential.House != lastCredential.House)) == false) {
							Signal? gameSignal = uow.Signals.GetOne(credential.House, credential.Game);
                            if (currentGrand < credential.Jackpots.Grand && credential.Jackpots.Grand - currentGrand > 0.1) {
                                if (credential.DPD.Toggles.GrandPopped == true) {
                                    if (currentGrand >= 0 && currentGrand <= 10000) {
                                        credential.Jackpots.Grand = currentGrand;
                                    }
                                    credential.DPD.Toggles.GrandPopped = false;
                                    credential.Thresholds.NewGrand(credential.Jackpots.Grand);
                                    if (gameSignal != null && gameSignal.Priority.Equals(4))
									uow.Signals.DeleteAll(credential.House, credential.Game);
} else
                                    credential.DPD.Toggles.GrandPopped = true;
                            } else {
                                if (currentGrand >= 0 && currentGrand <= 10000) {
                                    credential.Jackpots.Grand = currentGrand;
                                }
                            }

if (currentMajor < credential.Jackpots.Major && credential.Jackpots.Major - currentMajor > 0.1) {
                                if (credential.DPD.Toggles.MajorPopped == true) {
                                    if (currentMajor >= 0 && currentMajor <= 10000) {
                                        credential.Jackpots.Major = currentMajor;
                                    }
                                    credential.DPD.Toggles.MajorPopped = false;
                                    credential.Thresholds.NewMajor(credential.Jackpots.Major);
                                    if (gameSignal != null && gameSignal.Priority.Equals(3))
									uow.Signals.DeleteAll(credential.House, credential.Game);
} else
                                    credential.DPD.Toggles.MajorPopped = true;
                            } else {
                                if (currentMajor >= 0 && currentMajor <= 10000) {
                                    credential.Jackpots.Major = currentMajor;
                                }
                            }

if (currentMinor < credential.Jackpots.Minor && credential.Jackpots.Minor - currentMinor > 0.1) {
                                if (credential.DPD.Toggles.MinorPopped == true) {
                                    if (currentMinor >= 0 && currentMinor <= 10000) {
                                        credential.Jackpots.Minor = currentMinor;
                                    }
                                    credential.DPD.Toggles.MinorPopped = false;
                                    credential.Thresholds.NewMinor(credential.Jackpots.Minor);
                                    if (gameSignal != null && gameSignal.Priority.Equals(2))
									uow.Signals.DeleteAll(credential.House, credential.Game);
} else
                                    credential.DPD.Toggles.MinorPopped = true;
                            } else {
                                if (currentMinor >= 0 && currentMinor <= 10000) {
                                    credential.Jackpots.Minor = currentMinor;
                                }
                            }

if (currentMini < credential.Jackpots.Mini && credential.Jackpots.Mini - currentMini > 0.1) {
                                if (credential.DPD.Toggles.MiniPopped == true) {
                                    if (currentMini >= 0 && currentMini <= 10000) {
                                        credential.Jackpots.Mini = currentMini;
                                    }
                                    credential.DPD.Toggles.MiniPopped = false;
                                    credential.Thresholds.NewMini(credential.Jackpots.Mini);
                                    if (gameSignal != null && gameSignal.Priority.Equals(1))
									uow.Signals.DeleteAll(credential.House, credential.Game);
} else
                                    credential.DPD.Toggles.MiniPopped = true;
                            } else {
                                if (currentMini >= 0 && currentMini <= 10000) {
                                    credential.Jackpots.Mini = currentMini;
                                }
                            }
                        } else {
                            throw new Exception("Invalid grand retrieved.");
                        }

						if (credential.Settings.Gold777 == null)
							credential.Settings.Gold777 = new Gold777_Settings();
						credential.Updated = true;
						uow.Credentials.Unlock(credential);

						credential.LastUpdated = DateTime.UtcNow;
						credential.Balance = validatedBalance; // Use validated balance
						lastRetrievedGrand = currentGrand;
						uow.Credentials.Upsert(credential);
                        lastCredential = credential;

                        // SANITY CHECK: Periodic health monitoring
                        if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5) {
                            P4NTH30NSanityChecker.PerformHealthCheck(recentJackpots);
                            var healthStatus = P4NTH30NSanityChecker.GetSystemHealth();
                            Console.WriteLine($"💊 H4ND Health: {healthStatus.Status} | Errors: {healthStatus.ErrorCount} | Repairs: {healthStatus.RepairCount} | Rate: {healthStatus.RepairSuccessRate:P1}");
                            lastHealthCheck = DateTime.Now;
                        }

                        if (overrideSignal == null) {
                            File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(false));
                        }

                        switch (credential.Game) {
                            case "FireKirin":
                                FireKirin.Logout();
                                break;
                            case "OrionStars":
                                OrionStars.Logout(driver);
                                break;
                        }
                    }
                }
            } catch (Exception ex) {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex);
                Thread.Sleep(5000);
                if (driver != null) {
                    driver.Quit();
                }
            }
        }
    }

    private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalances(
        Credential credential
    ) {
        Random random = new();
        int delayMs = random.Next(3000, 5001);
        Thread.Sleep(delayMs);

        try {
            switch (credential.Game) {
                case "FireKirin": {
                    var balances = FireKirin.QueryBalances(credential.Username, credential.Password);

                    var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username ?? "Unknown");
                    var grandValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", balances.Grand, 10000);
                    var majorValidation = P4NTH30NSanityChecker.ValidateJackpot("Major", balances.Major, 1000);
                    var minorValidation = P4NTH30NSanityChecker.ValidateJackpot("Minor", balances.Minor, 200);
                    var miniValidation = P4NTH30NSanityChecker.ValidateJackpot("Mini", balances.Mini, 50);

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
                case "OrionStars": {
                    var balances = OrionStars.QueryBalances(credential.Username, credential.Password);

                    var balanceValidation = P4NTH30NSanityChecker.ValidateBalance(balances.Balance, credential.Username ?? "Unknown");
                    var grandValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", balances.Grand, 10000);
                    var majorValidation = P4NTH30NSanityChecker.ValidateJackpot("Major", balances.Major, 1000);
                    var minorValidation = P4NTH30NSanityChecker.ValidateJackpot("Minor", balances.Minor, 200);
                    var miniValidation = P4NTH30NSanityChecker.ValidateJackpot("Mini", balances.Mini, 50);

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
		} catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended")) {
			Dashboard.AddLog($"Account suspended for {credential.Username} on {credential.Game}. Marking as banned.", "red");
			credential.Banned = true;
			s_uow.Credentials.Upsert(credential);
			throw;
		}
    }

    private static (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(
        Credential credential
    ) {
        (double Balance, double Grand, double Major, double Minor, double Mini) ExecuteQuery() {
            int networkAttempts = 0;
            while (true) {
                try {
                    return QueryBalances(credential);
                } catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended")) {
                    throw;
                } catch (Exception ex) {
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

        int grandChecked = 0;
        var balances = ExecuteQuery();
        double currentGrand = balances.Grand;
        while (currentGrand.Equals(0)) {
            grandChecked++;
            Dashboard.AddLog($"Grand jackpot is 0 for {credential.Game}, retrying attempt {grandChecked}/40", "yellow");
            Dashboard.Render();
            Thread.Sleep(500);
			if (grandChecked > 40) {
				ProcessEvent alert = ProcessEvent.Log("H4ND", $"Grand check signalled an Extension Failure for {credential.Game}");
				Dashboard.AddLog($"Checking Grand on {credential.Game} failed at {grandChecked} attempts.", "red");
				Dashboard.Render();
				s_uow.ProcessEvents.Insert(alert.Record(credential));
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
