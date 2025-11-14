using System.Diagnostics;
using System.Drawing;
using OpenQA.Selenium.Chrome;
using P4NTH30N;
using Figgle;

using P4NTH30N.C0MMON;


namespace P4NTH30N {
    [GenerateFiggleText(sourceText: "v    0 . 6 . 4 . 4", memberName: "Version", fontName: "colossal")]
    internal static partial class Header { }
}
internal class Program {
    private static void Main(string[] args) {
        Signal? _Override = null;
        Dictionary<string, string> GamesQueue = [];

        double lastRetrievedGrand = 0;

        while (true) {
            Console.WriteLine(Header.Version);

            Signal? signal;
            if (_Override == null) {
                signal = Signal.GetNext();
            } else {
                signal = _Override;
                _Override = null;
            }

            if (signal == null) {
                Game game = Game.GetNext();
                // game = Game.Get("GameVault Ultra Lounge", "OrionStars");
                // int GamesCheckedSinceRefresh = 0;
                // string QueuedGame = "", priorGame = "";
                bool ranOnce = false,
                    loginScreenLoaded = false;

                game.Lock();
                ChromeDriver driver = Actions.Launch();

                try {
                    while (true) {
                        signal = Signal.GetNext();
                        if (signal != null) {
                            _Override = signal;
                            signal.Acknowledge();
                            break;
                        }

                        Game? lastGame = game;
                        // priorGame = game != null ? game.Name : "";
                        // if (GamesCheckedSinceRefresh++ > 5) {
                        //     game = Game.GetNext();
                        //     QueuedGame = game != null ? game.Name : "";
                        //     GamesCheckedSinceRefresh = 0;
                        // } else {
                        //     if (RanOnce) {
                        //         game = Game.GetNext(QueuedGame);
                        //         if (game == null) {
                        //             game = Game.GetNext();
                        //             if (game == null) {
                        //                 Game.UpdatesComplete();
                        //                 game = Game.GetNext();
                        //             }
                        //             QueuedGame = game != null ? game.Name : "";
                        //         }

                        //     } else {
                        //         game = Game.GetNext("OrionStars");
                        //         QueuedGame = game != null ? game.Name : "";
                        //         RanOnce = true;
                        //     }
                        // }

                        if (ranOnce) {
                            game = Game.GetNext();
                            game.Lock();
                        } else {
                            ranOnce = true;
                        }

                        if (game != null && lastGame != null && lastGame.Name.Equals(game.Name).Equals(false)) {
                            loginScreenLoaded = false;
                        }

                        if (game != null) {
                            List<Credential> gameCredentials = Credential.GetBy(game);
                            Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];
                            if (credential == null) {
                                game.Updated = true;
                                game.Unlock();
                            } else {
                                game.Lock();

                                switch (game.Name) {
                                    case "FireKirin":
                                        if (loginScreenLoaded.Equals(false)) {
                                            driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                                            loginScreenLoaded = true;
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
                                        if (loginScreenLoaded.Equals(false)) {
                                            driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                            if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false) {
                                                Console.WriteLine($"{DateTime.Now} - {game.House} took too long to load for {game.Name}");
                                                game.Lock();
                                                continue;
                                            }
                                            loginScreenLoaded = true;
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

                                while (currentGrand.Equals(0) || lastRetrievedGrand.Equals(currentGrand) && (lastGame == null || game.Name != lastGame.Name && game.House != lastGame.House)) {
                                    Thread.Sleep(500);
                                    if (grandChecked++ > 40) {
                                        throw new Exception("Extension failure.");
                                    }
                                    currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
                                }

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
                } catch (Exception ex) {
                    StackTrace st = new StackTrace(ex, true);
                    StackFrame? frame = st.GetFrame(0);
                    int line = frame != null ? frame.GetFileLineNumber() : 0;
                    Console.WriteLine($"[{line}]Processing failed: {ex.Message}");
                    Console.WriteLine(ex);
                } finally {
                    driver.Quit();
                }
            } else {
                signal.Acknowledge();

                ChromeDriver driver = Actions.Launch();

                Mouse.Click(1026, 122);
                driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                Mouse.RtClick(182, 30);
                Mouse.Click(243, 268);

                try {
                    signal.Acknowledge();
                    Game game = Game.Get(signal.House, signal.Game);
                    game.Lock();

                    ProcessEvent.Log("SignalReceived", $"Signal for {game.House} - Username: {signal.Username}").Record(signal).Save();

                    switch (signal.Game) {
                        case "FireKirin":
                            driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                            if (Screen.WaitForColor(new Point(650, 505), Color.FromArgb(255, 11, 241, 85), 30) == false)
                                throw new Exception("Took too long to load.");
                            while (FireKirin.Login(driver, signal.Username, signal.Password) == false) {
                                signal.Acknowledge();
                            }
                            break;

                        case "OrionStars":
                            driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                            if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 30) == false)
                                throw new Exception("Took too long to load.");
                            Mouse.Click(535, 615);
                            while (OrionStars.Login(driver, signal.Username, signal.Password) == false) {
                                signal.Acknowledge();
                            }
                            break;

                        default:
                            throw new Exception($"Uncrecognized Game Found. ('{signal.Game}')");
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
                            Games.Gold777(driver, game, signal);
                            // Games.FortunePiggy(driver, game, signal);
                            break;
                        case "OrionStars":
                            //Games.Gold777(driver, game, signal);
                            Games.FortunePiggy(driver, game, signal);
                            break;
                    }

                    // Games.Quintuple5X(driver, game, signal);
                    // Games.FortunePiggy(driver, game, signal);
                    Console.WriteLine($"({DateTime.Now}) {game.House} - Completed Reel Spins...");
                    ProcessEvent.Log("SignalReceived", $"Finished Spinning for {game.House} - Username: {signal.Username}").Record(signal).Save();
                    // Signal? nextSignal = Signal.GetNext();
                    // if (nextSignal != null && nextSignal.Priority > signal.Priority) {
                    //     nextSignal.Acknowledge();
                    //     _Override = nextSignal;
                    // }

                    game.Unlock();
                    // signal = Signal.GetNext();
                    // if (signal != null) {
                    //     _Override = signal;
                    //     signal.Acknowledge();
                    //     break;
                    // }

                    throw new Exception("Finished Signal.");
                    // for (int i = 0; i < 8; i++) {
                    //     Mouse.Click(937, 177); Thread.Sleep(800);
                    // }
                } catch (Exception ex) {
                    StackTrace st = new StackTrace(ex, true);
                    StackFrame? frame = st.GetFrame(0);

                    int line = frame != null ? frame.GetFileLineNumber() : 0;
                    Console.WriteLine($"[{line}]Processing failed: {ex.Message}");
                    Console.WriteLine(ex);

                    if (signal != null) {
                        signal.Acknowledge();
                    }
                }
                driver.Quit();
            }
            Thread.Sleep(Convert.ToInt32(TimeSpan.FromSeconds(20).TotalMilliseconds));
        }
    }
}
