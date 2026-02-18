using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON;

public static partial class Games
{
	public static class FortunePiggy
	{
		public static bool LoadSucessfully(ChromeDriver driver, Credential credential, Signal signal, IUnitOfWork uow)
		{
			for (int i = 1; i < credential.Settings.FortunePiggy.Page; i++)
			{
				switch (credential.Game)
				{
					case "FireKirin":
						Mouse.Click(937, 177);
						break;
					case "OrionStars":
						Mouse.Click(995, 375);
						break;
				}
			}

			Mouse.Move(credential.Settings.FortunePiggy.Button_X, credential.Settings.FortunePiggy.Button_Y);
			int iterations = 0;
			bool slotsLoaded = false;
			Thread.Sleep(800);

			while (slotsLoaded == false)
			{
				uow.Signals.Acknowledge(signal);
				Mouse.Click(credential.Settings.FortunePiggy.Button_X, credential.Settings.FortunePiggy.Button_Y);
				string page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
				// while ((page.Equals("Slots") || page.Equals("Game")).Equals(false)) {
				if (Screen.GetColorAt(new Point(544, 391)).Equals(Color.FromArgb(255, 129, 1, 1)))
				{
					while (
						new string[] { "Slots", "Game" }
							.Contains(page)
							.Equals(false)
					)
					{
						throw new Exception("Account is already spinning Slots.");
					}

					if (iterations++ > 120)
					{
						throw new Exception("Took too long to load page in Slots.");
					}

					Thread.Sleep(500);
					page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
					Console.WriteLine(page);
				}

				int balanceIterations = 0;
				uow.Signals.Acknowledge(signal);
				double balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
				Console.WriteLine($"{balanceIterations} - ${balance}");
				while (balance.Equals(0))
				{
					if (balanceIterations++ > 20)
					{
						driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
						Console.WriteLine("Took too long to load balance in Slots.");

						Thread.Sleep(2000);
						string reloadedPage = string.Empty;
						int ClicksWhileWaiting = 0;
						balanceIterations = 0;
						while (
							new string[] { "Slots", "Game" }
								.Contains(reloadedPage)
								.Equals(false)
						)
						{
							Mouse.Click(credential.Settings.FortunePiggy.Button_X, credential.Settings.FortunePiggy.Button_Y);
							reloadedPage = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
							if (ClicksWhileWaiting++ > 20)
								break;
							Thread.Sleep(500);
						}
					}
					Thread.Sleep(500);
					uow.Signals.Acknowledge(signal);
					balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
					Console.WriteLine($"{balanceIterations} - ${balance}");
				}

				Color Confirmation = credential.Game switch
				{
					"FireKirin" => Color.FromArgb(255, 255, 255, 255),
					"OrionStars" => Color.FromArgb(255, 51, 199, 109),
					_ => Color.Black,
				};

				if (Screen.WaitForColor(new Point(957, 602), Confirmation, 30) == false)
				{
					return false;
				}

				slotsLoaded = balance > 0;
			}
			return slotsLoaded;
		}

		public static Signal? Spin(ChromeDriver driver, Credential credential, Signal signal, IUnitOfWork uow)
		{
			Color Confirmation = credential.Game switch
			{
				"FireKirin" => Color.FromArgb(255, 255, 255, 255),
				"OrionStars" => Color.FromArgb(255, 51, 199, 109),
				_ => Color.Black,
			};

			if (Screen.WaitForColor(new Point(957, 602), Confirmation, 30) == false)
			{
				Console.WriteLine($"Failed to Spin FortunePiggy on {credential.Game} for {credential.House}. Username: {signal.Username}");
				throw new Exception($"Failed to Spin FortunePiggy on {credential.Game} for {credential.House}. Username: {signal.Username}");
			}

			Mouse.LongClick(950, 620);
			Mouse.Click(955, 290);

			int FailedSpinChecks = 0,
				remainingIterations = 10;
			double grandPrior = credential.Jackpots.Grand;
			double majorPrior = credential.Jackpots.Major;
			double minorPrior = credential.Jackpots.Minor;
			double miniPrior = credential.Jackpots.Mini;
			bool jackpotPopped = false;

			while (remainingIterations > 0)
			{
				string page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
				if (
					new string[] { "Slots", "Game" }
						.Contains(page)
						.Equals(false)
				)
				{
					break;
				}

				Signal? newSignal = uow.Signals.GetNext();
				// newSignal = (Signal)signal.Clone(); newSignal.Priority = 4;
				if (newSignal != null && newSignal.Priority > signal.Priority)
				{
					uow.Signals.Acknowledge(newSignal);
					Mouse.Click(950, 620);
					Thread.Sleep(3000);
					switch (credential.Game)
					{
						case "FireKirin":
							driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
							// .GetColorAt(new Point(925, 120)).Equals(Color.FromArgb(255, 255, 251, 48));
							P4NTH30N.C0MMON.Screen.WaitForColor(new Point(925, 120), Color.FromArgb(255, 255, 251, 48));
							break;
						case "OrionStars":
							driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
							P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
							break;
					}
					return newSignal;
				}

				if (uow.Signals.Exists(signal) == false)
				{
					remainingIterations--;
				}
				else
				{
					remainingIterations = 10;
					jackpotPopped = false;
				}

				Thread.Sleep(TimeSpan.FromSeconds(10));
				Mouse.Click(534, 466);
				Mouse.Click(534, 523);
				Mouse.Click(533, 564);
				uow.Signals.Acknowledge(signal);

				double balance = 0;
				// TODO: FIX - JavaScript extraction from window.parent relies on browser extension (Decision 0)
				// Current: Fails if extension not loaded or casino changed JS structure
				// Fix: Add fallback extraction method or extension health check
				double currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
				double currentMajor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
				double currentMinor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
				double currentMini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;
				if (currentGrand.Equals(0))
					throw new Exception("Failed to retrieve Jackpot data.");

				if (grandPrior > currentGrand && (grandPrior - currentGrand) > 0.1)
				{
					if (signal.Priority.Equals(4))
					{
						jackpotPopped = true;
						signal.Close(grandPrior, uow.Received);
						uow.Signals.Delete(signal);
					}
					Console.WriteLine($"({DateTime.UtcNow}) {credential.House} - Grand Popped!!");
					credential.Thresholds.NewGrand(grandPrior);
					Console.WriteLine();
				}
				if (majorPrior > currentMajor && (majorPrior - currentMajor) > 0.1)
				{
					if (signal.Priority.Equals(3))
					{
						jackpotPopped = true;
						signal.Close(majorPrior, uow.Received);
						uow.Signals.Delete(signal);
					}
					Console.WriteLine($"({DateTime.UtcNow}) {credential.House} - Major Popped!!");
					credential.Thresholds.NewMajor(majorPrior);
					Console.WriteLine();
				}
				if (minorPrior > currentMinor && (minorPrior - currentMinor) > 0.1)
				{
					if (signal.Priority.Equals(2))
					{
						jackpotPopped = true;
						signal.Close(minorPrior, uow.Received);
						uow.Signals.Delete(signal);
					}
					Console.WriteLine($"({DateTime.UtcNow}) {credential.House} - Minor Popped!!");
					credential.Thresholds.NewMinor(minorPrior);
					Console.WriteLine();
				}
				if (miniPrior > currentMini && (miniPrior - currentMini) > 0.1)
				{
					if (signal.Priority.Equals(1))
					{
						jackpotPopped = true;
						signal.Close(miniPrior, uow.Received);
						uow.Signals.Delete(signal);
					}
					Console.WriteLine($"({DateTime.UtcNow}) {credential.House} - Mini Popped!!");
					credential.Thresholds.NewMini(miniPrior);
					Console.WriteLine();
				}

				credential.LastUpdated = DateTime.UtcNow;
				if (currentGrand >= 0 && currentGrand <= 10000)
				{
					credential.Jackpots.Grand = currentGrand;
					grandPrior = credential.Jackpots.Grand;
				}
				if (currentMajor >= 0 && currentMajor <= 10000)
				{
					credential.Jackpots.Major = currentMajor;
					majorPrior = credential.Jackpots.Major;
				}
				if (currentMinor >= 0 && currentMinor <= 10000)
				{
					credential.Jackpots.Minor = currentMinor;
					minorPrior = credential.Jackpots.Minor;
				}
				if (currentMini >= 0 && currentMini <= 10000)
				{
					credential.Jackpots.Mini = currentMini;
					miniPrior = credential.Jackpots.Mini;
				}
				uow.Credentials.Upsert(credential);

				double balancePrior = balance;
				balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
				credential.LastUpdated = DateTime.UtcNow;
				credential.Balance = balance;
				uow.Credentials.Upsert(credential);

				if (balance.Equals(balancePrior))
				{
					if (FailedSpinChecks++ > 3)
					{
						Mouse.LongClick(950, 620);
						Mouse.Click(955, 290);
						FailedSpinChecks = 0;
					}
				}
				else
				{
					FailedSpinChecks = 0;
				}

				if (jackpotPopped)
				{
					remainingIterations--;
					Console.WriteLine($"({DateTime.UtcNow}) {credential.House} - {remainingIterations} Remaining Iterations...");
				}
			}

			Mouse.Click(950, 620);
			Thread.Sleep(6000);

			switch (credential.Game)
			{
				case "FireKirin":
					driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
					// .GetColorAt(new Point(925, 120)).Equals(Color.FromArgb(255, 255, 251, 48));
					P4NTH30N.C0MMON.Screen.WaitForColor(new Point(925, 120), Color.FromArgb(255, 255, 251, 48));
					break;
				case "OrionStars":
					driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
					P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
					break;
			}
			return null;
		}
	}
}
