using OpenQA.Selenium.Chrome;
using P4NTH30N;
using Figgle;

using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Versioning;
using System.Drawing;
using System.Text.Json;
using System.Diagnostics;
using Figgle.Fonts;


namespace P4NTH30N {
    internal static class Header {
        public static string Version => FiggleFonts.Colossal.Render($"v 0  .  8  .  6  .  3");
    }
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
            ChromeDriver? driver = null;
            bool driverFresh = false;
            try {
                double lastRetrievedGrand = 0;
                Signal? overrideSignal = null;
                Game? lastGame = null;

                while (true) {
                    Signal? signal = listenForSignals ? (overrideSignal ?? Signal.GetNext()) : null;
                    Game game = (signal == null) ? Game.GetNext() : Game.Get(signal.House, signal.Game); overrideSignal = null;
                    Credential? credential = (signal == null) ? Credential.GetBy(game)[0] : Credential.GetBy(game, signal.Username);

                    if (signal == null && driver != null) {
                        driver.Quit();
                        driver = null;
                        driverFresh = false;
                    }

                    if (credential == null) {
                        game.Unlock();
                    } else {
                        game.Lock();
                        signal?.Acknowledge();

                        if (signal != null) {
                            if (driver == null) {
                                driver = Actions.Launch();
                                driverFresh = true;
                            }

                            switch (game.Name) {
                                case "FireKirin":
                                    if (driverFresh || lastGame == null || lastGame.Name != game.Name) {
                                        driver!.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                                    }
                                    // if (Screen.WaitForColor(new Point(650, 505), Color.FromArgb(255, 11, 241, 85), 60) == false) {
                                    if (Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 60) == false) {
                                        Console.WriteLine($"{DateTime.Now} - {game.House} took too long to load for {game.Name}");
                                        game.Lock(); //throw new Exception("Took too long to load.");
                                    }
                                    if (FireKirin.Login(driver!, credential.Username, credential.Password) == false) {
                                        if (Screen.GetColorAt(new Point(893, 117)).Equals(Color.FromArgb(255, 125, 124, 27)))
                                            throw new Exception("This looks like a stuck Hall Screen. Resetting.");
                                        game.Lock();
                                        continue;
                                    }
                                    break;

                                case "OrionStars":
                                    if (driverFresh || lastGame == null || lastGame.Name != game.Name) {
                                        driver!.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                        if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false) {
                                            Console.WriteLine($"{DateTime.Now} - {game.House} took too long to load for {game.Name}");
                                            game.Lock(); //throw new Exception("Took too long to load.");
                                        }
                                        Mouse.Click(535, 615);
                                    }
                                    if (OrionStars.Login(driver!, credential.Username, credential.Password) == false) {
                                        Console.WriteLine($"{DateTime.Now} - {game.House} login failed for {game.Name}");
                                        Console.WriteLine($"{DateTime.Now} - {credential.Username} : {credential.Password}");
                                        game.Lock();
                                        continue;
                                    }
                                    break;

                                default:
                                    throw new Exception($"Uncrecognized Game Found. ('{game.Name}')");
                            }

                            driverFresh = false;
                        }

                        var balances = GetBalancesWithRetry(game, credential);
                        double currentGrand = balances.Grand;

                        if (signal != null) {
                            signal.Acknowledge();
                            File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(true));
                            switch (signal.Priority) {
                                case 1: signal.Receive(balances.Mini); break;
                                case 2: signal.Receive(balances.Minor); break;
                                case 3: signal.Receive(balances.Major); break;
                                case 4: signal.Receive(currentGrand); break;
                            }

                            signal.Acknowledge();
                            switch (game.Name) {
                                case "FireKirin":
                                    Mouse.Click(80, 235); Thread.Sleep(800); //Reset Hall Screen
                                    FireKirin.SpinSlots(driver!, game, signal);
                                    break;
                                case "OrionStars":
                                    Mouse.Click(80, 200); Thread.Sleep(800);
                                    // overrideSignal = Games.Gold777(driver, game, signal);
                                    bool FortunePiggyLoaded = Games.FortunePiggy.LoadSucessfully(driver!, game, signal);
                                    overrideSignal = FortunePiggyLoaded ? Games.FortunePiggy.Spin(driver!, game, signal) : null;

                                    driver!.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                    P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                                    Thread.Sleep(2000); Mouse.Click(80, 200); Thread.Sleep(800);
                                    break;
                            }
                            Console.WriteLine($"({DateTime.Now}) {game.House} - Completed Reel Spins...");
                            //ProcessEvent.Log("SignalReceived", $"Finished Spinning for {game.House} - Username: {signal.Username}").Record(signal).Save();
                            // throw new Exception("Finished Spinning");
                            lastGame = null;
                            balances = GetBalancesWithRetry(game, credential);
                        } else if (signal == null) {
                            game.Lock();
                        }

                        double currentMajor = balances.Major;
                        double currentMinor = balances.Minor;
                        double currentMini = balances.Mini;

if ((lastRetrievedGrand.Equals(currentGrand) && (lastGame == null || game.Name != lastGame.Name && game.House != lastGame.House)) == false) {
                            Signal? gameSignal = Signal.GetOne(game);
                            if (currentGrand < game.Jackpots.Grand && game.Jackpots.Grand - currentGrand > 0.1) {
                                if (game.DPD.Toggles.GrandPopped == true) {
                                    if (currentGrand >= 0 && currentGrand <= 10000) {
                                        game.Jackpots.Grand = currentGrand;
                                    }
                                    game.DPD.Toggles.GrandPopped = false;
                                    game.Thresholds.NewGrand(game.Jackpots.Grand);
                                    if (gameSignal != null && gameSignal.Priority.Equals(4))
                                        Signal.DeleteAll(game);
} else
                                    game.DPD.Toggles.GrandPopped = true;
                            } else {
                                if (currentGrand >= 0 && currentGrand <= 10000) {
                                    game.Jackpots.Grand = currentGrand;
                                }
                            }

if (currentMajor < game.Jackpots.Major && game.Jackpots.Major - currentMajor > 0.1) {
                                if (game.DPD.Toggles.MajorPopped == true) {
                                    if (currentMajor >= 0 && currentMajor <= 10000) {
                                        game.Jackpots.Major = currentMajor;
                                    }
                                    game.DPD.Toggles.MajorPopped = false;
                                    game.Thresholds.NewMajor(game.Jackpots.Major);
                                    if (gameSignal != null && gameSignal.Priority.Equals(3))
                                        Signal.DeleteAll(game);
} else
                                    game.DPD.Toggles.MajorPopped = true;
                            } else {
                                if (currentMajor >= 0 && currentMajor <= 10000) {
                                    game.Jackpots.Major = currentMajor;
                                }
                            }

if (currentMinor < game.Jackpots.Minor && game.Jackpots.Minor - currentMinor > 0.1) {
                                if (game.DPD.Toggles.MinorPopped == true) {
                                    if (currentMinor >= 0 && currentMinor <= 10000) {
                                        game.Jackpots.Minor = currentMinor;
                                    }
                                    game.DPD.Toggles.MinorPopped = false;
                                    game.Thresholds.NewMinor(game.Jackpots.Minor);
                                    if (gameSignal != null && gameSignal.Priority.Equals(2))
                                        Signal.DeleteAll(game);
} else
                                    game.DPD.Toggles.MinorPopped = true;
                            } else {
                                if (currentMinor >= 0 && currentMinor <= 10000) {
                                    game.Jackpots.Minor = currentMinor;
                                }
                            }

if (currentMini < game.Jackpots.Mini && game.Jackpots.Mini - currentMini > 0.1) {
                                if (game.DPD.Toggles.MiniPopped == true) {
                                    if (currentMini >= 0 && currentMini <= 10000) {
                                        game.Jackpots.Mini = currentMini;
                                    }
                                    game.DPD.Toggles.MiniPopped = false;
                                    game.Thresholds.NewMini(game.Jackpots.Mini);
                                    if (gameSignal != null && gameSignal.Priority.Equals(1))
                                        Signal.DeleteAll(game);
} else
                                    game.DPD.Toggles.MiniPopped = true;
                            } else {
                                if (currentMini >= 0 && currentMini <= 10000) {
                                    game.Jackpots.Mini = currentMini;
                                }
                            }
                        } else {
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

                        if (overrideSignal == null) {
                            File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(false));
                        }

                        if (signal != null) {
                            switch (game.Name) {
                                case "FireKirin":
                                    FireKirin.Logout();
                                    break;
                                case "OrionStars":
                                    OrionStars.Logout(driver!);
                                    break;
                            }

                            if (overrideSignal == null && driver != null) {
                                driver.Quit();
                                driver = null;
                                driverFresh = false;
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex);
                if (driver != null) {
                    driver.Quit();
                }
            }
        }
    }

    private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalances(
        Game game,
        Credential credential
    ) {
        // Add human-like staggering before each balance query (3-5 seconds)
        Random random = new();
        int delayMs = random.Next(3000, 5001);
        Console.WriteLine($"{DateTime.Now} - Waiting {delayMs / 1000.0:F1}s before querying {game.Name} balances for {credential.Username}");
        Thread.Sleep(delayMs);

        switch (game.Name) {
            case "FireKirin": {
                Console.WriteLine($"{DateTime.Now} - Querying FireKirin balances and jackpot data for {credential.Username}");
                var balances = FireKirin.QueryBalances(credential.Username, credential.Password);
                Console.WriteLine($"{DateTime.Now} - FireKirin retrieved: Balance={balances.Balance:F2}, Grand={balances.Grand:F2}, Major={balances.Major:F2}, Minor={balances.Minor:F2}, Mini={balances.Mini:F2}");
                return (
                    (double)balances.Balance,
                    (double)balances.Grand,
                    (double)balances.Major,
                    (double)balances.Minor,
                    (double)balances.Mini
                );
            }
            case "OrionStars": {
                Console.WriteLine($"{DateTime.Now} - Querying OrionStars balances and jackpot data for {credential.Username}");
                var balances = OrionStars.QueryBalances(credential.Username, credential.Password);
                Console.WriteLine($"{DateTime.Now} - OrionStars retrieved: Balance={balances.Balance:F2}, Grand={balances.Grand:F2}, Major={balances.Major:F2}, Minor={balances.Minor:F2}, Mini={balances.Mini:F2}");
                return (
                    (double)balances.Balance,
                    (double)balances.Grand,
                    (double)balances.Major,
                    (double)balances.Minor,
                    (double)balances.Mini
                );
            }
            default:
                throw new Exception($"Uncrecognized Game Found. ('{game.Name}')");
        }
    }

    private static (double Balance, double Grand, double Major, double Minor, double Mini) GetBalancesWithRetry(
        Game game,
        Credential credential
    ) {
        int grandChecked = 0;
        var balances = QueryBalances(game, credential);
        double currentGrand = balances.Grand;
        while (currentGrand.Equals(0)) {
            grandChecked++;
            Console.WriteLine($"{DateTime.Now} - Grand jackpot is 0 for {game.Name}, retrying attempt {grandChecked}/40");
            Thread.Sleep(500);
            if (grandChecked > 40) {
                ProcessEvent alert = ProcessEvent.Log("H4ND", $"Grand check signalled an Extension Failure for {game.Name}");
                Console.WriteLine($"Checking Grand on {game.Name} failed at {grandChecked} attempts.");
                alert.Record(credential).Save();
                throw new Exception("Extension failure.");
            }
            Console.WriteLine($"{DateTime.Now} - Retrying balance query for {game.Name} (attempt {grandChecked})");
            balances = QueryBalances(game, credential);
            currentGrand = balances.Grand;
        }

        return balances;
    }
}
