using OpenQA.Selenium.Chrome;
using P4NTH30N;
using Figgle;

using P4NTH30N.C0MMON;
using System.Drawing;
using System.Text.Json;

namespace P4NTH30N {
	[GenerateFiggleText(sourceText: "v    0 . 9 . 0 . 1", memberName: "Version", fontName: "colossal")]
	internal static partial class Header { }
}

internal class Program {
	private static void Main(string[] args) {
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

			ChromeDriver driver = Actions.Launch();
			try {
				double lastRetrievedGrand = 0;
				SignalRecord? overrideSignal = null;
				CredentialRecord? lastCredential = null;

				while (true) {
					// Signals preempt the normal credential queue so urgent spins can run immediately.
					SignalRecord? signal = listenForSignals ? (overrideSignal ?? SignalRecord.GetNext()) : null;
					overrideSignal = null;

					// We now iterate through credentials directly (instead of iterating through Games).
					// This keeps lock/unlock behavior scoped to an account while reusing the same game flow.
					CredentialRecord? credential = (signal == null)
						? CredentialRecord.GetNext()
						: CredentialRecord.GetBy.Username(signal.Game, signal.Username);

					if (credential == null) {
						// If a signal references a missing credential, acknowledge and drop it so the loop can continue.
						if (signal != null) {
							signal.Acknowledge();
							signal.Delete();
						}
						continue;
					}

					credential.Lock();
					signal?.Acknowledge();

					switch (credential.Game) {
						case "FireKirin":
							if (lastCredential == null || lastCredential.Game != credential.Game) {
								driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
							}
							// if (Screen.WaitForColor(new Point(650, 505), Color.FromArgb(255, 11, 241, 85), 60) == false) {
							if (Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 60) == false) {
								Console.WriteLine($"{DateTime.Now} - {credential.House} took too long to load for {credential.Game}");
								credential.Lock(); //throw new Exception("Took too long to load.");
							}
							if (FireKirinFlow.Login(driver, credential.Username, credential.Password) == false) {
								if (Screen.GetColorAt(new Point(893, 117)).Equals(Color.FromArgb(255, 125, 124, 27)))
									throw new Exception("This looks like a stuck Hall Screen. Resetting.");
								credential.Lock();
								continue;
							}
							break;

						case "OrionStars":
							if (lastCredential == null || lastCredential.Game != credential.Game) {
								driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
								if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false) {
									Console.WriteLine($"{DateTime.Now} - {credential.House} took too long to load for {credential.Game}");
									credential.Lock(); //throw new Exception("Took too long to load.");
								}
								Mouse.Click(535, 615);
							}
							if (OrionStars.Login(driver, credential.Username, credential.Password) == false) {
								Console.WriteLine($"{DateTime.Now} - {credential.House} login failed for {credential.Game}");
								Console.WriteLine($"{DateTime.Now} - {credential.Username} : {credential.Password}");
								credential.Lock();
								continue;
							}
							break;

						default:
							throw new Exception($"Uncrecognized Game Found. ('{credential.Game}')");
					}


					int grandChecked = 0;
					// Jackpot values are read from the game's shared parent frame for the current account.
					double currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
					while (currentGrand <= 0 || (lastRetrievedGrand.Equals(currentGrand) && lastCredential != null && (credential.Game != lastCredential.Game || credential.URL != lastCredential.URL))) {
						Thread.Sleep(500);
						if (grandChecked++ >= 40) {
							if (lastRetrievedGrand.Equals(currentGrand) && lastCredential != null && (credential.Game != lastCredential.Game || credential.URL != lastCredential.URL)) {
								throw new Exception("Invalid Grand received. It appears to be the same amount as the previously received Grand.");
							}
							throw new Exception($"Checking Grand failed after {grandChecked} attempts. ({credential.House}, {credential.Game})");
						}
						currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
					}
					double currentMajor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
					double currentMinor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
					double currentMini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;

					// Update per-credential jackpot tracking, including pop detection + signal cleanup.
					SignalRecord? credentialSignal = SignalRecord.Get(credential);
					credential.Jackpots.Grand = UpdateJackpot(credential, "Grand", currentGrand, credentialSignal);
					credential.Jackpots.Major = UpdateJackpot(credential, "Major", currentMajor, credentialSignal);
					credential.Jackpots.Minor = UpdateJackpot(credential, "Minor", currentMinor, credentialSignal);
					credential.Jackpots.Mini = UpdateJackpot(credential, "Mini", currentMini, credentialSignal);

					// Balance and timestamps are saved on the credential record for later analytics (HUN7ERv2, etc.).
					double currentBalance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
					credential.Dates.LastUpdated = DateTime.UtcNow;
					credential.Balance = currentBalance;
					credential.Save();
					lastRetrievedGrand = currentGrand;
					lastCredential = credential;

					if (signal != null) {
						signal.Acknowledge();
						File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(true));

						switch (signal.Priority) {
							case 1: signal.Receive(currentMini); break;
							case 2: signal.Receive(currentMinor); break;
							case 3: signal.Receive(currentMajor); break;
							case 4: signal.Receive(currentGrand); break;
						}

						signal.Acknowledge();
						switch (credential.Game) {
							case "FireKirin":
								Mouse.Click(80, 235); Thread.Sleep(800); //Reset Hall Screen
								overrideSignal = FireKirinFlow.SpinSlots(driver, credential, signal);
								break;
							case "OrionStars":
								Mouse.Click(80, 200); Thread.Sleep(800);
								bool fortunePiggyLoaded = FortunePiggyFlow.LoadSucessfully(driver, credential, signal);
								overrideSignal = fortunePiggyLoaded
									? FortunePiggyFlow.Spin(driver, credential, signal)
									: null;

								driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
								P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
								Thread.Sleep(2000); Mouse.Click(80, 200); Thread.Sleep(800);
								break;
						}

						// ProcessEvent.Log("SignalReceived", $"Finished Spinning for {game.House} - Username: {signal.Username}").Record(signal).Save();
						// throw new Exception("Finished Spinning");

						Console.WriteLine($"({DateTime.Now}) {credential.House} - Completed Reel Spins...");
						lastCredential = null;


					}

					credential.Unlock();
					if (overrideSignal == null) {
						File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(false));
					}

					switch (credential.Game) {
						case "FireKirin":
							FireKirinFlow.Logout();
							break;
						case "OrionStars":
							OrionStars.Logout(driver);
							break;
					}

				}
			} catch (Exception ex) {
				Console.WriteLine(ex.Message);
				Console.WriteLine(ex);
				driver.Quit();
			}
		}
	}

	private static double UpdateJackpot(CredentialRecord credential, string category, double currentValue, SignalRecord? credentialSignal) {
		JackpotRecord jackpot = JackpotRecord.Get(credential, category) ?? new JackpotRecord(category, credential);
		double priorValue = jackpot.Current;

		// Mirror the legacy pop-detection flow by requiring a second consecutive drop before resetting.
		bool dropDetected = currentValue < priorValue && priorValue - currentValue > 0.1;
		if (dropDetected) {
			if (jackpot.Toggles.PendingReset) {
				jackpot.Current = currentValue;
				jackpot.Toggles.PendingReset = false;
				jackpot.Dates.ResetDate = DateTime.UtcNow;

				if (credentialSignal != null && credentialSignal.Priority.Equals(jackpot.Priority)) {
					SignalRecord.DeleteAll(credential);
				}
			} else {
				jackpot.Toggles.PendingReset = true;
			}
		} else {
			jackpot.Current = currentValue;
		}

		if (jackpot.Current != priorValue) {
			jackpot.DPD.Data.Add(new DpdRecordData(jackpot.Current));
		}

		jackpot.Dates.LastUpdated = DateTime.UtcNow;
		jackpot.Save();

		return jackpot.Current;
	}
}
