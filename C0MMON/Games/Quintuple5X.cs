using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static partial class Games {
	public static void Quintuple5X(ChromeDriver driver, Game game, Signal signal) {
		for (int i = 1; i < game.Settings.Quintuple5X.Page; i++) {
			Mouse.Click(937, 177);
			Thread.Sleep(800);
		}
		float balance = 0;
		int iterations = 0;
		bool slotsLoaded = false;
		Mouse.Move(game.Settings.Quintuple5X.Button_X, game.Settings.Quintuple5X.Button_Y);
		// Mouse.Move(970, 440);
		// while (true) {
		//     Console.WriteLine(Screen.GetColorAt(new Point(970, 440)));
		//     Thread.Sleep(1000);
		// }

		// Color[] buttonColors = [
		//     Color.FromArgb(255, 38, 253, 60),
		//     Color.FromArgb(255, 28, 252, 61),
		//     Color.FromArgb(255, 97, 255, 130),
		//     Color.FromArgb(255, 124, 139, 56)
		// ];

		// if (Screen.WaitForColor(new Point(game.Settings.Quintuple5X.Button_X, game.Settings.Quintuple5X.Button_Y), Color.FromArgb(255, 38, 253, 60), 30) == false) {
		//     // if (Screen.WaitForColor(new Point(970, 440), Color.FromArgb(255, 38, 253, 60), 30) == false) {
		//     throw new Exception("Wrong button.");
		// }

		while (slotsLoaded == false) {
			signal.Acknowledge();
			Mouse.Click(game.Settings.Quintuple5X.Button_X, game.Settings.Quintuple5X.Button_Y);
			// Mouse.Click(970, 440);

			string page =
				driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;

			signal.Acknowledge();
			while (page != "Slots") {
				if (Screen.GetColorAt(new Point(544, 391)).Equals(Color.FromArgb(255, 129, 1, 1))) {
					throw new Exception("Account is already spinning Slots.");
				}

				if (iterations++ > 120)
					throw new Exception("Took too long to load page in Slots.");

				Thread.Sleep(500);
				page =
					driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
				Console.WriteLine(page);
			}

			iterations = 0;
			signal.Acknowledge();
			balance = Convert.ToSingle(driver.ExecuteScript("return window.parent.Balance")) / 100;
			while (balance.Equals(0)) {
				if (iterations++ > 30) {
					driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
					Console.WriteLine("Took too long to load balance in Slots.");

					Thread.Sleep(2000);
					string reloadedPage = string.Empty;
					int ClicksWhileWaiting = 0;
					while (reloadedPage.Equals("Slots") == false) {
						Mouse.Click(
							game.Settings.Quintuple5X.Button_X,
							game.Settings.Quintuple5X.Button_Y
						);
						reloadedPage =
							driver.ExecuteScript("return window.parent.Page")?.ToString()
							?? string.Empty;
						if (ClicksWhileWaiting++ > 20)
							break;
						Thread.Sleep(500);
					}
					break;
				}
				Thread.Sleep(500);
				signal.Acknowledge();
				balance =
					Convert.ToSingle(driver.ExecuteScript("return window.parent.Balance")) / 100;
				Console.WriteLine(iterations);
			}

			if (
				Screen.WaitForColor(new Point(957, 602), Color.FromArgb(255, 255, 255, 255), 30)
				== false
			) {
				throw new Exception("Failed to load Quintuple 5x Slots.");
			}
			slotsLoaded = balance > 0;
		}

		Mouse.LongClick(950, 620);
		Mouse.Click(955, 290);
		bool jackpotPopped = false;
		int FailedSpinChecks = 0,
			remainingIterations = 30;
		double balancePrior = 0,
			grandPrior = 0,
			majorPrior = 0,
			minorPrior = 0,
			miniPrior = 0;

		while (true) {
			string page =
				driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
			if (page != "Slots") {
				break;
			}

			game = Game.Get(signal.House, signal.Game);

			balancePrior = (balance * 2) - balance;
			grandPrior = game.Jackpots.Grand;
			majorPrior = game.Jackpots.Major;
			minorPrior = game.Jackpots.Minor;
			miniPrior = game.Jackpots.Mini;

			if (signal.Check() == false)
				break;

			signal.Acknowledge();
			Thread.Sleep(TimeSpan.FromSeconds(10));

			game = Game.Get(signal.House, signal.Game);
			balance = Convert.ToSingle(driver.ExecuteScript("return window.parent.Balance")) / 100;
			game.Jackpots.Grand =
				Convert.ToSingle(driver.ExecuteScript("return window.parent.Grand")) / 100F;
			game.Jackpots.Major =
				Convert.ToSingle(driver.ExecuteScript("return window.parent.Major")) / 100F;
			game.Jackpots.Minor =
				Convert.ToSingle(driver.ExecuteScript("return window.parent.Minor")) / 100F;
			game.Jackpots.Mini =
				Convert.ToSingle(driver.ExecuteScript("return window.parent.Mini")) / 100F;

			if (game.Jackpots.Grand.Equals(0)) {
				throw new Exception("Failed to retrieve Jackpot data.");
			}

			if (grandPrior > game.Jackpots.Grand && (grandPrior - game.Jackpots.Grand) > 0.1) {
				if (signal.Priority.Equals(4))
					jackpotPopped = true;
				game.Thresholds.NewGrand(grandPrior);
			}
			if (majorPrior > game.Jackpots.Major && (majorPrior - game.Jackpots.Major) > 0.1) {
				if (signal.Priority.Equals(3))
					jackpotPopped = true;
				game.Thresholds.NewMajor(majorPrior);
			}
			if (minorPrior > game.Jackpots.Minor && (minorPrior - game.Jackpots.Minor) > 0.1) {
				if (signal.Priority.Equals(2))
					jackpotPopped = true;
				game.Thresholds.NewMinor(minorPrior);
			}
			if (miniPrior > game.Jackpots.Mini && (miniPrior - game.Jackpots.Mini) > 0.1) {
				if (signal.Priority.Equals(1))
					jackpotPopped = true;
				game.Thresholds.NewMini(miniPrior);
			}
			game.Save();

			Credential? credential = Credential.GetBy(game, signal.Username);
			if (credential != null) {
				credential.LastUpdated = DateTime.UtcNow;
				credential.Balance = balance;
				credential.Save();
			}

			Mouse.Click(534, 466);
			Mouse.Click(534, 523);

			if (balance.Equals(balancePrior)) {
				if (FailedSpinChecks++ > 3) {
					Mouse.LongClick(950, 620);
					Mouse.Click(955, 290);
					FailedSpinChecks = 0;
				}
			} else
				FailedSpinChecks = 0;

			if (jackpotPopped) {
				if (remainingIterations.Equals(30)) {
					signal.Delete();
				} else
					remainingIterations--;
				if (remainingIterations.Equals(0))
					break;
			}
		}
	}
}
