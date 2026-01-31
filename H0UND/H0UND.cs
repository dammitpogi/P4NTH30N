using System.Diagnostics;
using System.Drawing;
using System.Text.Json;
using Figgle;
using P4NTH30N;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Versioning;

namespace P4NTH30N;

[GenerateFiggleText(sourceText: "v    0 . 8 . 6 . 3", memberName: "Version", fontName: "colossal")]
internal static partial class Header { }

class H0UND
{
	static void Main(string[] args)
	{
		while (true)
		{
			Console.WriteLine(Header.Version);
			try
			{
				double lastRetrievedGrand = 0;
				Game? lastGame = null;

				while (true)
				{
					Game game = Game.GetNext();
					Credential? credential = Credential.GetBy(game)[0];

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
							double currentGrand = balances.Grand;

							double currentMajor = balances.Major;
							double currentMinor = balances.Minor;
							double currentMini = balances.Mini;

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

							double currentBalance = balances.Balance;
							credential.LastUpdated = DateTime.UtcNow;
							credential.Balance = currentBalance;
							lastRetrievedGrand = currentGrand;
							credential.Save();
							lastGame = game;

							// Console.WriteLine($"{DateTime.Now} - {game.House} - Completed data retrieval for {game.Name}");
							Thread.Sleep(new Random().Next(0, 1501));
						}
						catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
						{
							game.Unlock();
						}
					}
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex.Message);
				Console.WriteLine(ex);
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
					Console.WriteLine(
						$"{DateTime.Now} - {game.Name} - {game.House} - {credential.Username} - ${balances.Balance:F2} - [{balances.Grand:F2}, {balances.Major:F2}, {balances.Minor:F2}, {balances.Mini:F2}]"
					);
					return ((double)balances.Balance, (double)balances.Grand, (double)balances.Major, (double)balances.Minor, (double)balances.Mini);
				}
				case "OrionStars":
				{
					// Console.WriteLine($"{DateTime.Now} - Querying OrionStars balances and jackpot data for {credential.Username}");
					var balances = OrionStars.QueryBalances(credential.Username, credential.Password);
					Console.WriteLine(
						$"{DateTime.Now} - {game.Name} - {game.House} - {credential.Username} - ${balances.Balance:F2} - [{balances.Grand:F2}, {balances.Major:F2}, {balances.Minor:F2}, {balances.Mini:F2}]"
					);
					return ((double)balances.Balance, (double)balances.Grand, (double)balances.Major, (double)balances.Minor, (double)balances.Mini);
				}
				default:
					throw new Exception($"Uncrecognized Game Found. ('{game.Name}')");
			}
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
		{
			Console.WriteLine($"{DateTime.Now} - Account suspended for {credential.Username} on {game.Name}. Marking as banned.");
			credential.Banned = true;
			credential.Save();
			throw;
		}
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(Game game, Credential credential)
	{
		int grandChecked = 0;
		var balances = QueryBalances(game, credential);
		double currentGrand = balances.Grand;
		while (currentGrand.Equals(0))
		{
			grandChecked++;
			Console.WriteLine($"{DateTime.Now} - Grand jackpot is 0 for {game.Name}, retrying attempt {grandChecked}/40");
			Thread.Sleep(500);
			if (grandChecked > 40)
			{
				ProcessEvent alert = ProcessEvent.Log("H0UND", $"Grand check signalled an Extension Failure for {game.Name}");
				Console.WriteLine($"Checking Grand on {game.Name} failed at {grandChecked} attempts.");
				alert.Record(credential).Save();
				throw new Exception("Extension failure.");
			}
			try
			{
				Console.WriteLine($"{DateTime.Now} - Retrying balance query for {game.Name} (attempt {grandChecked})");
				balances = QueryBalances(game, credential);
				currentGrand = balances.Grand;
			}
			catch (InvalidOperationException ex) when (ex.Message.Contains("Your account has been suspended"))
			{
				throw;
			}
		}

		return balances;
	}
}
