using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON;

public static partial class Games
{
	public static class Gold777
	{
		public static bool LoadSucessfully(ChromeDriver driver, Credential credential, Signal signal, IUnitOfWork uow)
		{
			for (int i = 1; i < (credential.Settings?.Gold777?.Page ?? 1); i++)
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
			Thread.Sleep(800);
			int iterations = 0;
			bool slotsLoaded = false;
			Mouse.Move(credential.Settings?.Gold777?.Button_X ?? 0, credential.Settings?.Gold777?.Button_Y ?? 0);

			uow.Credentials.Lock(credential);
			uow.Signals.Acknowledge(signal);
			while (slotsLoaded == false)
			{
				Mouse.Click(credential.Settings?.Gold777?.Button_X ?? 0, credential.Settings?.Gold777?.Button_Y ?? 0);

				int checkAttempts = 20;
				bool buttonVerified = false;
				while (checkAttempts >= 0 && buttonVerified == false)
				{
					Color splashScreen;
					switch (credential.Game)
					{
						case "FireKirin":
							splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(316, 434)); // Gold777
							buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 183));
							break;
						case "OrionStars":
							splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(314, 432)); // Gold777
							buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 194));
							break;
					}
					Thread.Sleep(500);
					checkAttempts--;
				}

				if (buttonVerified == false)
				{
					if (credential.Settings?.Gold777?.ButtonVerified == true)
					{
						if (credential.Settings?.Gold777 != null)
							credential.Settings.Gold777.ButtonVerified = false;
						uow.Credentials.Upsert(credential);
					}

					switch (credential.Game)
					{
						case "FireKirin":
							driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
							P4NTH30N.C0MMON.Screen.WaitForColor(new Point(925, 120), Color.FromArgb(255, 255, 251, 48));
							break;
						case "OrionStars":
							driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
							P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
							break;
					}

					// Color secondHallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
					// while (secondHallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false) {
					//     Console.WriteLine($"Waiting for Hall - {credential.House} - {secondHallScreen}");
					//     Thread.Sleep(500);
					//     secondHallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
					// }

					Console.WriteLine($"{DateTime.Now} - Game was not found. Beginning Search.");

					Thread.Sleep(TimeSpan.FromSeconds(5));
					if (System.Windows.Forms.Screen.PrimaryScreen != null)
					{
						int screenHeight = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height;
						int screenWidth = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width;
						int searchAttempts = 30,
							x = 110,
							y = 220;
						bool foundPixels = false;
						Bitmap screenshot = new(screenWidth, screenHeight);
						List<string> foundPossibilities = [];
						Point possibleButton = new(0, 0);

						// driver.Manage().Window.Minimize();
						foreach (int pageModifier in new int[] { 0, -1, 1, -2, 2 })
						{
							uow.Signals.Acknowledge(signal);
							int workingPage = (credential.Settings?.Gold777?.Page ?? 1) + pageModifier;
							if (pageModifier.Equals(0) == false)
							{
								Mouse.Click(81, 233);
								Thread.Sleep(800);
								for (int i = 1; i < workingPage; i++)
								{
									Mouse.Click(937, 177);
									Thread.Sleep(800);
								}
							}
							Thread.Sleep(3000);
							using (Bitmap bitmap = new(screenWidth, screenHeight))
							{
								using (Graphics graphics = Graphics.FromImage(bitmap))
								{
									graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);
									screenshot.Dispose();
									screenshot = (Bitmap)bitmap.Clone();
								}
							}
							while (buttonVerified == false && searchAttempts > 0)
							{
								Color originColor = screenshot.GetPixel(x, y);

								Color[] possibleOrigins =
								[
									Color.FromArgb(3, 130, 50),
									Color.FromArgb(141, 79, 54),
									Color.FromArgb(139, 76, 48),
									Color.FromArgb(126, 79, 70),
									Color.FromArgb(15, 130, 51),
									Color.FromArgb(9, 119, 51),
								];

								if (possibleOrigins.Contains(originColor))
								{
									Color top = screenshot.GetPixel(x, y - 60);
									Color bottom = screenshot.GetPixel(x, y + 30);

									bool foundLeft =
										top == Color.FromArgb(0, 89, 46) && originColor == Color.FromArgb(3, 130, 50) && bottom == Color.FromArgb(155, 39, 43);
									foundLeft =
										foundLeft
										|| (top == Color.FromArgb(1, 92, 46) && originColor == Color.FromArgb(3, 130, 50) && bottom == Color.FromArgb(144, 16, 31));
									foundLeft =
										foundLeft
										|| (top == Color.FromArgb(219, 208, 86) && originColor == Color.FromArgb(3, 130, 50) && bottom == Color.FromArgb(37, 216, 54));

									bool foundCenter =
										top == Color.FromArgb(145, 89, 75) && originColor == Color.FromArgb(141, 79, 54) && bottom == Color.FromArgb(214, 135, 88);
									foundCenter =
										foundCenter
										|| (top == Color.FromArgb(143, 87, 73) && originColor == Color.FromArgb(139, 76, 48) && bottom == Color.FromArgb(218, 142, 91));
									foundCenter =
										foundCenter
										|| (top == Color.FromArgb(97, 54, 36) && originColor == Color.FromArgb(126, 79, 70) && bottom == Color.FromArgb(226, 191, 175));

									bool foundRight =
										top == Color.FromArgb(0, 83, 45) && originColor == Color.FromArgb(15, 130, 51) && bottom == Color.FromArgb(63, 151, 45);
									foundRight =
										foundRight
										|| (top == Color.FromArgb(0, 88, 46) && originColor == Color.FromArgb(15, 130, 51) && bottom == Color.FromArgb(83, 147, 44));
									foundRight =
										foundRight
										|| (top == Color.FromArgb(219, 208, 66) && originColor == Color.FromArgb(9, 119, 51) && bottom == Color.FromArgb(59, 158, 47));

									if (foundCenter)
									{
										possibleButton = new Point(x, y);
										foundPixels = true;
									}
									if (foundLeft)
									{
										possibleButton = new Point(x + 70, y);
										foundPixels = true;
									}
									if (foundRight)
									{
										possibleButton = new Point(x - 70, y);
										foundPixels = true;
									}
								}

								if (foundPixels)
								{
									checkAttempts = 0;

									// Mouse.Click(815, 695); Thread.Sleep(2000);
									// P4NTH30N.C0MMON.Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));

									Console.Write($"{DateTime.Now} - Clicking through at ({possibleButton.X},{possibleButton.Y}). ");
									Mouse.Click(possibleButton.X, possibleButton.Y);
									while (checkAttempts <= 20 && buttonVerified == false)
									{
										Color splashScreen = Color.White;
										switch (credential.Game)
										{
											case "FireKirin":
												splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(316, 434)); // Gold777
												buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 183));
												break;
											case "OrionStars":
												splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(314, 432)); // Gold777
												buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 194));
												break;
										}
										// Console.WriteLine($"{checkAttempts + 1} {credential.House} - {splashScreen}");
										Thread.Sleep(500);
										checkAttempts++;
									}

									if (buttonVerified == false)
									{
										foundPixels = false;
										Console.WriteLine("But it wasn't the right one.");
										switch (credential.Game)
										{
											case "FireKirin":
												driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
												Console.WriteLine("Returning to Menu");
												P4NTH30N.C0MMON.Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));
												break;
											case "OrionStars":
												driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
												P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
												break;
										}
									}
									else
										Console.WriteLine("And the correct game loaded.");
								}
								x++;
								if (x >= 1040)
								{
									// Console.WriteLine($"Checking pixels at y-level: {y}");
									x = 120;
									y++;
								}
								if (y >= 530)
								{
									// Mouse.Click(815, 695); Thread.Sleep(4000);
									x = 110;
									y = 220;
									searchAttempts--;
									if (searchAttempts > 0)
									{
										Thread.Sleep(500);
										using (Bitmap bitmap = new(screenWidth, screenHeight))
										{
											using (Graphics graphics = Graphics.FromImage(bitmap))
											{
												graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);
												screenshot.Dispose();
												screenshot = (Bitmap)bitmap.Clone();
											}
										}
									}
								}
							}
							if (buttonVerified)
							{
								if (credential.Settings?.Gold777 != null)
								{
									credential.Settings.Gold777.Button_X = possibleButton.X;
									credential.Settings.Gold777.Button_Y = possibleButton.Y;
									credential.Settings.Gold777.Page = workingPage;
								}
								break;
							}
							searchAttempts = 5;
						}
						screenshot.Dispose();
						// foundPossibilities.Order().ToList().ForEach(Console.WriteLine);
					}
				}
				if (credential.Settings?.Gold777?.ButtonVerified == false)
				{
					if (buttonVerified)
					{
						if (credential.Settings?.Gold777 != null)
							credential.Settings.Gold777.ButtonVerified = true;
						uow.Credentials.Upsert(credential);
					}
					else
					{
						// throw new Exception("Couldn't find the damn button.");
						Console.WriteLine("Couldn't find the damn button.");
						return false;
					}
				}

				string page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;

				while (
					new string[] { "Slots", "Game" }
						.Contains(page)
						.Equals(false)
				)
				{
					if (Screen.GetColorAt(new Point(544, 391)).Equals(Color.FromArgb(255, 129, 1, 1)))
					{
						// throw new Exception("Account is already spinning Slots.");
						Console.WriteLine("Account is already spinning Slots.");
						return false;
					}

					if (iterations++ > 120)
					{
						// throw new Exception("Took too long to load page in Slots.");
						Console.WriteLine("Took too long to load page in Slots.");
						return false;
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
						int clicksWhileWaiting = 0;
						while (
							new string[] { "Slots", "Game" }
								.Contains(reloadedPage)
								.Equals(false)
						)
						{
							Mouse.Click(credential.Settings?.Gold777?.Button_X ?? 0, credential.Settings?.Gold777?.Button_Y ?? 0);
							reloadedPage = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
							if (clicksWhileWaiting++ > 20)
								break;
							Thread.Sleep(500);
						}
						balanceIterations = 0;
					}
					Thread.Sleep(500);
					uow.Signals.Acknowledge(signal);
					balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
					Console.WriteLine($"{balanceIterations} - ${balance}");
				}
				Color SpinButtonFontColor = Color.Black;
				Color Confirmation = credential.Game switch
				{
					"FireKirin" => Color.FromArgb(255, 253, 253, 14),
					"OrionStars" => Color.FromArgb(255, 253, 253, 14),
					_ => Color.Black,
				};

				bool SpinButtonLocated = false;
				int Iterations_SpinButtonLocated = 0;
				while (Iterations_SpinButtonLocated++ < 120 && SpinButtonLocated.Equals(false))
				{
					SpinButtonFontColor = Screen.GetColorAt(new Point(929, 612));
					SpinButtonLocated = SpinButtonFontColor.Equals(Confirmation);
					Thread.Sleep(500);
				}
				// Console.WriteLine("");
				Console.WriteLine($"[{credential.Game}] Gold777 Confirmation: {Confirmation}");
				Console.WriteLine($"[{credential.Game}] Gold777 SpinButtonFontColor: {SpinButtonFontColor}");

				if (SpinButtonLocated == false)
				{
					// Console.WriteLine("");
					// Console.WriteLine("Failed to load Gold777 Slots.");
					// Console.WriteLine("Failed to load Gold777 Slots.");
					// throw new Exception(""Failed to load Gold777 Slots."");
					Console.WriteLine("Failed to load Gold777 Slots.");
					return false;
				}
				// Console.WriteLine("");

				slotsLoaded = balance > 0;
			}
			return slotsLoaded;
		}

		public static Signal? Spin(ChromeDriver driver, Credential credential, Signal signal, IUnitOfWork uow)
		{
			Mouse.LongClick(929, 612);
			// Mouse.Click(955, 290);

			int FailedSpinChecks = 0,
				remainingIterations = 10;
			double grandPrior = credential.Jackpots.Grand;
			double majorPrior = credential.Jackpots.Major;
			double minorPrior = credential.Jackpots.Minor;
			double miniPrior = credential.Jackpots.Mini;
			bool jackpotPopped = false;
			double balance = 0;

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
						Mouse.LongClick(929, 612);
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
			return null;
		}
	}
}
