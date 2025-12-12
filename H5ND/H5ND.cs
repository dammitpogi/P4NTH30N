using OpenQA.Selenium.Chrome;
using P4NTH30N;
using Figgle;

using P4NTH30N.C0MMON;
using System.Drawing;
using System.Text.Json;


namespace P4NTH30N {
    [GenerateFiggleText(sourceText: "v    0 . 9 . 0 . 0", memberName: "Version", fontName: "colossal")]
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
                NewSignal? overrideSignal = null;
                NewCredential? lastNewCredential = null;

                while (true) {
                    // Game game = Game.Get("MIDAS 2", "FireKirin", false);
                    // NewCredential credential = NewCredential.GetBy(game, "Stone1020");
                    // Signal signal = new Signal(4, credential);


                    NewSignal? signal = listenForSignals ? (overrideSignal ?? NewSignal.GetNext()) : null;
                    NewCredential credential = (signal == null) ? NewCredential.GetNext() : NewCredential.GetBy.Username(signal.Game, signal.Username);
                    overrideSignal = null; signal?.Acknowledge(); credential.Lock();

                    switch (credential.Game) {
                        case "FireKirin":
                            if (lastNewCredential == null || lastNewCredential.Game != credential.Game) {
                                driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                            }
                            // if (Screen.WaitForColor(new Point(650, 505), Color.FromArgb(255, 11, 241, 85), 60) == false) {
                            if (Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 60) == false) {
                                Console.WriteLine($"{DateTime.Now} - {credential.House} took too long to load for {credential.Game}");
                                credential.Lock(); //throw new Exception("Took too long to load.");
                            }
                            if (NewFireKirin.Login(driver, credential.Username, credential.Password) == false) {
                                if (Screen.GetColorAt(new Point(893, 117)).Equals(Color.FromArgb(255, 125, 124, 27)))
                                    throw new Exception("This looks like a stuck Hall Screen. Resetting.");
                                credential.Lock();
                                continue;
                            }
                            break;

                        case "OrionStars":
                            if (lastNewCredential == null || lastNewCredential.Game != credential.Game) {
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


                    bool goodGrand = false; int grandChecked = 0;
                    double currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
                    while (currentGrand.Equals(0)) {
                        Thread.Sleep(500);
                        if (grandChecked++ >= 40) {
                            Console.WriteLine($"Checking Grand failed at {grandChecked} attempts.");
                            throw new Exception($"Checking Grand failed at {grandChecked} attempts.");
                        }
                        currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
                    }

                    if (lastRetrievedGrand.Equals(currentGrand) && (lastNewCredential != null && credential.Game == lastNewCredential.Game && credential.URL == lastNewCredential.URL) == false) {
                        
                    }

                    double currentMajor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
                    double currentMinor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
                    double currentMini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;


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
                                overrideSignal = NewFireKirin.SpinSlots(driver, credential, signal);
                                break;
                            case "OrionStars":
                                Mouse.Click(80, 200); Thread.Sleep(800);
                                // overrideSignal = Games.Gold777(driver, game, signal);
                                bool FortunePiggyLoaded = Games.NewFortunePiggy.LoadSucessfully(driver, credential, signal);
                                overrideSignal = FortunePiggyLoaded ? Games.NewFortunePiggy.Spin(driver, credential, signal) : null;

                                driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                                Thread.Sleep(2000); Mouse.Click(80, 200); Thread.Sleep(800);
                                break;
                        }
                        Console.WriteLine($"({DateTime.Now}) {credential.House} - Completed Reel Spins...");
                        //ProcessEvent.Log("SignalReceived", $"Finished Spinning for {game.House} - Username: {signal.Username}").Record(signal).Save();
                        // throw new Exception("Finished Spinning");
                        lastNewCredential = null;

                    } else if (signal == null) {
                        credential.Lock();
                    }


                    if ((lastRetrievedGrand.Equals(currentGrand) && (lastNewCredential == null || (credential.Game != lastNewCredential.Game && credential.Username != lastNewCredential.Username))) == false) {

                        if (currentGrand < credential.Jackpots.Grand && credential.Jackpots.Grand - currentGrand > 0.1) {
                            if (credential.DPD.Toggles.GrandPopped == true) {
                                credential.Jackpots.Grand = currentGrand;
                                credential.DPD.Toggles.GrandPopped = false;
                                credential.Thresholds.NewGrand(credential.Jackpots.Grand);
                            } else
                                credential.DPD.Toggles.GrandPopped = true;
                        } else
                            credential.Jackpots.Grand = currentGrand;

                        if (currentMajor < credential.Jackpots.Major && credential.Jackpots.Major - currentMajor > 0.1) {
                            if (credential.DPD.Toggles.MajorPopped == true) {
                                credential.Jackpots.Major = currentMajor;
                                credential.DPD.Toggles.MajorPopped = false;
                                credential.Thresholds.NewMajor(credential.Jackpots.Major);
                            } else
                                credential.DPD.Toggles.MajorPopped = true;
                        } else
                            credential.Jackpots.Major = currentMajor;

                        if (currentMinor < credential.Jackpots.Minor && credential.Jackpots.Minor - currentMinor > 0.1) {
                            if (credential.DPD.Toggles.MinorPopped == true) {
                                credential.Jackpots.Minor = currentMinor;
                                credential.DPD.Toggles.MinorPopped = false;
                                credential.Thresholds.NewMinor(credential.Jackpots.Minor);
                            } else
                                credential.DPD.Toggles.MinorPopped = true;
                        } else
                            credential.Jackpots.Minor = currentMinor;

                        if (currentMini < credential.Jackpots.Mini && credential.Jackpots.Mini - currentMini > 0.1) {
                            if (credential.DPD.Toggles.MiniPopped == true) {
                                credential.Jackpots.Mini = currentMini;
                                credential.DPD.Toggles.MiniPopped = false;
                                credential.Thresholds.NewMini(credential.Jackpots.Mini);
                            } else
                                credential.DPD.Toggles.MiniPopped = true;
                        } else
                            credential.Jackpots.Mini = currentMini;
                    } else {
                        throw new Exception("Invalid grand retrieved.");
                    }

                    double currentBalance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
                    credential.Dates.LastUpdated = DateTime.UtcNow;
                    credential.Balance = currentBalance;
                    lastRetrievedGrand = currentGrand;
                    lastNewCredential = credential;
                    credential.Unlock();

                    if (overrideSignal == null) {
                        File.WriteAllText(@"D:\S1GNAL.json", JsonSerializer.Serialize(false));
                    }

                    switch (credential.Game) {
                        case "FireKirin":
                            NewFireKirin.Logout();
                            break;
                        case "OrionStars":
                            OrionStars.Logout(driver);
                            break;
                    }

                }
            } catch {
                driver.Quit();
            }
        }
    }
}