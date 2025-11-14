using OpenQA.Selenium.Chrome;
using P4NTH30N;
using Figgle;

using P4NTH30N.C0MMON;
using System.Drawing;


namespace P4NTH30N {
    [GenerateFiggleText(sourceText: "v    0 . 7 . 0 . 1", memberName: "Version", fontName: "colossal")]
    internal static partial class Header { }
}

internal class Program {
    private static void Main(string[] args) {
        Console.WriteLine(Header.Version);
        double lastRetrievedGrand = 0;
        Signal? overrideSignal = null;
        Game? lastGame = null;

        ChromeDriver driver = Actions.Launch();
        while (true) {
            Signal? signal = overrideSignal ?? Signal.GetNext();
            Game game = (signal == null) ? Game.GetNext() : Game.Get(signal.House, signal.Game);

            overrideSignal = null;
            List<Credential> gameCredentials = Credential.GetBy(game);
            Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];

            if (credential == null || credential.Balance < 1) {
                game.Unlock();
            } else {
                // signal = new Signal(3, credential);
                signal?.Acknowledge();
                switch (game.Name) {
                    case "FireKirin":
                        if (lastGame == null || lastGame.Name != game.Name) {
                            driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                        }
                        if (Screen.WaitForColor(new Point(650, 505), Color.FromArgb(255, 11, 241, 85), 60) == false) {
                            Console.WriteLine($"{DateTime.Now} - {game.House} took too long to load for {game.Name}");
                            game.Lock();
                            continue;
                        }
                        if (FireKirin.Login(driver, credential.Username, credential.Password) == false) {
                            if (Screen.GetColorAt(new Point(893, 117)).Equals(Color.FromArgb(255, 125, 124, 27)))
                                throw new Exception("This looks like a stuck Hall Screen. Resetting.");
                            game.Lock();
                            continue;
                        }
                        break;

                    case "OrionStars":
                        if (lastGame == null || lastGame.Name != game.Name) {
                            driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                            if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false) {
                                Console.WriteLine($"{DateTime.Now} - {game.House} took too long to load for {game.Name}");
                                game.Lock();
                                continue;
                            }
                            Mouse.Click(535, 615);
                        }
                        if (OrionStars.Login(driver, credential.Username, credential.Password) == false) {
                            Console.WriteLine($"{DateTime.Now} - {game.House} login failed for {game.Name}");
                            Console.WriteLine($"{DateTime.Now} - {credential.Username} : {credential.Password}");
                            game.Lock();
                            continue;
                        }
                        break;

                    default:
                        throw new Exception($"Uncrecognized Game Found. ('{game.Name}')");
                }

                int grandChecked = 0;
                double currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
                while (currentGrand.Equals(0)) {
                    Thread.Sleep(500);
                    if (grandChecked++ > 40) {
                        throw new Exception("Extension failure.");
                    }
                    currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
                }

                if (signal != null) {
                    signal.Acknowledge();
                    switch (signal.Priority) {
                        case 1:
                            signal.Receive(Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100);
                            break;
                        case 2:
                            signal.Receive(Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100);
                            break;
                        case 3:
                            signal.Receive(Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100);
                            break;
                        case 4:
                            signal.Receive(currentGrand);
                            break;
                    }

                    signal.Acknowledge();
                    switch (game.Name) {
                        case "FireKirin":
                            overrideSignal = Games.Gold777(driver, game, signal);
                            // Games.FortunePiggy(driver, game, signal);
                            break;
                        case "OrionStars":
                            //Games.Gold777(driver, game, signal);
                            overrideSignal = Games.FortunePiggy(driver, game, signal);
                            break;
                    }

                    Console.WriteLine($"({DateTime.Now}) {game.House} - Completed Reel Spins...");
                    ProcessEvent.Log("SignalReceived", $"Finished Spinning for {game.House} - Username: {signal.Username}").Record(signal).Save();
                } else if (signal == null) {
                    game.Lock();

                    double currentMajor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
                    double currentMinor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
                    double currentMini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;

                    if ((lastRetrievedGrand.Equals(currentGrand) && (lastGame == null || game.Name != lastGame.Name && game.House != lastGame.House)) == false) {
                        Signal? gameSignal = Signal.GetOne(game);
                        if (currentGrand < game.Jackpots.Grand && game.Jackpots.Grand - currentGrand > 0.1) {
                            if (game.DPD.Toggles.GrandPopped == true) {
                                game.Jackpots.Grand = currentGrand;
                                game.DPD.Toggles.GrandPopped = false;
                                game.Thresholds.NewGrand(game.Jackpots.Grand);
                                if (gameSignal != null && gameSignal.Priority.Equals(4))
                                    Signal.DeleteAll(game);
                            } else
                                game.DPD.Toggles.GrandPopped = true;
                        } else
                            game.Jackpots.Grand = currentGrand;

                        if (currentMajor < game.Jackpots.Major && game.Jackpots.Major - currentMajor > 0.1) {
                            if (game.DPD.Toggles.MajorPopped == true) {
                                game.Jackpots.Major = currentMajor;
                                game.DPD.Toggles.MajorPopped = false;
                                game.Thresholds.NewMajor(game.Jackpots.Major);
                                if (gameSignal != null && gameSignal.Priority.Equals(3))
                                    Signal.DeleteAll(game);
                            } else
                                game.DPD.Toggles.MajorPopped = true;
                        } else
                            game.Jackpots.Major = currentMajor;

                        if (currentMinor < game.Jackpots.Minor && game.Jackpots.Minor - currentMinor > 0.1) {
                            if (game.DPD.Toggles.MinorPopped == true) {
                                game.Jackpots.Minor = currentMinor;
                                game.DPD.Toggles.MinorPopped = false;
                                game.Thresholds.NewMinor(game.Jackpots.Minor);
                                if (gameSignal != null && gameSignal.Priority.Equals(2))
                                    Signal.DeleteAll(game);
                            } else
                                game.DPD.Toggles.MinorPopped = true;
                        } else
                            game.Jackpots.Minor = currentMinor;

                        if (currentMini < game.Jackpots.Mini && game.Jackpots.Mini - currentMini > 0.1) {
                            if (game.DPD.Toggles.MiniPopped == true) {
                                game.Jackpots.Mini = currentMini;
                                game.DPD.Toggles.MiniPopped = false;
                                game.Thresholds.NewMini(game.Jackpots.Mini);
                                if (gameSignal != null && gameSignal.Priority.Equals(1))
                                    Signal.DeleteAll(game);
                            } else
                                game.DPD.Toggles.MiniPopped = true;
                        } else
                            game.Jackpots.Mini = currentMini;
                    } else {
                        throw new Exception("Invalid grand retrieved.");
                    }

                    if (game.Settings.Gold777 == null)
                        game.Settings.Gold777 = new Gold777_Settings();
                    game.Updated = true;
                    game.Unlock();

                    double currentBalance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
                    credential.LastUpdated = DateTime.UtcNow;
                    credential.Balance = currentBalance;
                    lastRetrievedGrand = currentGrand;
                    credential.Save();
                }

                lastGame = game;
                switch (game.Name) {
                    case "FireKirin":
                        FireKirin.Logout();
                        break;
                    case "OrionStars":
                        OrionStars.Logout(driver);
                        break;
                }
            }
        }
    }
}