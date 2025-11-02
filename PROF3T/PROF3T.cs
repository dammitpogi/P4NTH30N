using System.Diagnostics;
using System.Drawing;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.DevTools.V136.Browser;
using P4NTH30N.C0MMON;
using System.Text.Json;

namespace P4NTH30N;

class PROF3T {
    static void Main() {
        // LaunchBrowser();
        //sandbox();
        // BurnAccount("ShariNor55", "123qwe");
        // ResetSignalsTest("FireKirin");
        TestSignals("FireKirin");
        // PrioritizeTesting("OrionStars");

        // Sandbox();

        // RemoveInvalidDPD_Date();
        // CheckSignals();
        // SetThresholdsToDefault();
        // GamesWithNoCredentials();
        // ClearBalances();
        // ResetDPD();
        // FixDPD();
        // Fix();p
    }

    private static void LaunchBrowser() {
        ChromeDriver driver = Actions.Launch();
    }

    private static void sandbox() {
        List<int> History = []; Dictionary<int, int> Occurences = [];
        History = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 10, 10, 11, 12, 12, 12, 12, 14, 14, 14];
        History.ForEach(Spins => {
            if (Occurences.Any(x => x.Key == Spins)) Occurences[Spins] = Occurences[Spins] + 1;
            else Occurences.Add(Spins, 1);
        });
        List<string> log = []; int y = 0, rows = 4;
        for (int i = 0; i < rows; i++) { log.Add(""); }
        Occurences.ToList().ForEach(x => {
            log[y] = log[y] = $"{(log[y].Length.Equals(0) ? "" : log[y] + " | ")}{x.Key,2}: {x.Value,-3}";
            y++; if (y.Equals(rows)) y = 0;
        });
        log.ToList().ForEach(Console.WriteLine);
        Console.WriteLine();
    }

    private static void BurnAccount(string Username, string Password) {
        ChromeDriver driver = Actions.Launch();
        Mouse.Click(1026, 122);
        driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
        Mouse.RtClick(182, 30);
        Mouse.Click(243, 268);
        Color loginScreen = Screen.GetColorAt(new Point(999, 128));
        while (loginScreen.Equals(Color.FromArgb(255, 2, 125, 51)) == false) {
            Thread.Sleep(500); loginScreen = Screen.GetColorAt(new Point(999, 128));
        }
        bool loggedIn = false;
        while (loggedIn == false) {
            loggedIn = driver.Login(Username, Password);
        }
        for (int i = 1; i < 10; i++) {
            Mouse.Click(937, 177); Thread.Sleep(800);
        }
        Mouse.Click(450, 450);
        Screen.WaitForColor(new Point(929, 612), Color.FromArgb(255, 253, 253, 14));
        double balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
        while (balance.Equals(0)) {
            Thread.Sleep(300);
            balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
        }

        bool Raised = false; int BadSpins = 0, AvgSpinsFTW = 0, Increase = 5, Capacity = 12;
        List<int> History = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 10, 10, 11, 11, 11, 12, 12, 12, 12, 13, 14, 14, 14, 15, 16, 16, 16, 16, 17, 18];
        List<int> WorkingSet = [];

        //Console.WriteLine(balance);
        while (balance > 400 && balance < 600) {
            if (BadSpins.Equals(AvgSpinsFTW) && Raised.Equals(false) && WorkingSet.Count > Capacity) {
                for (int i = 1; i < Increase; i++) {
                    Mouse.Click(843, 623); Thread.Sleep(400);
                }
                Raised = true;
            }

            double priorBalance = balance;
            Mouse.Click(877, 623); Thread.Sleep(300);
            Screen.WaitForColor(new Point(996, 614), Color.FromArgb(255, 244, 253, 7));
            Mouse.Click(877, 623); Thread.Sleep(300);
            Screen.WaitForColor(new Point(929, 612), Color.FromArgb(255, 253, 253, 14));
            balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
            //Console.WriteLine($"                                                                                                                                                                                                                         {balance}");

            int logSpins = BadSpins;
            if (balance > priorBalance) {
                History.Add(BadSpins); WorkingSet.Add(BadSpins);
                AvgSpinsFTW = WorkingSet.GroupBy(i => i).OrderByDescending(grp => grp.Count()).Select(grp => grp.Key).First();
                if (WorkingSet.Count > 24) WorkingSet.RemoveAt(0);
                BadSpins = 0;
            } else {
                BadSpins++;
            }

            Console.WriteLine($"Spins:{logSpins}, BetRaise: {Raised}, Bal:{balance}, Backup: {JsonSerializer.Serialize(History.Order())};");
            Dictionary<int, int> Occurences = [];
            if (BadSpins.Equals(0)) {
                History.ForEach(Spins => {
                    if (Occurences.Any(x => x.Key == Spins)) Occurences[Spins] = Occurences[Spins] + 1;
                    else Occurences.Add(Spins, 1);
                });
                List<string> log = []; int y = 0, rows = 4; for (int i = 0; i < rows; i++) { log.Add(""); }
                Occurences.ToList().ForEach(x => {
                    log[y] = log[y] = $"{(log[y].Length.Equals(0) ? "" : log[y] + " | ")}{x.Key,2}: {x.Value,-3}";
                    y++; if (y.Equals(rows)) y = 0;
                });
                log.Sort();
                log.ToList().ForEach(Console.WriteLine);
                Console.WriteLine($"RaiseOn:{AvgSpinsFTW}, WorkingSet:{WorkingSet.Count}, History:{History.Count} ");
                Console.WriteLine();
            }

            if (Raised) {
                for (int i = 1; i < Increase; i++) {
                    Mouse.Click(702, 623); Thread.Sleep(200);
                }
                Raised = false;
            }
        }
        driver.Quit();
    }

    private static void ResetSignalsTest(string Platform) {
        List<Game> games = Game.GetAll();
        games.ForEach(delegate (Game game) {
            if (game.Settings.Gold777 == null) game.Settings.Gold777 = new Gold777_Settings();
            if (game.Settings.Gold777.ButtonVerified == false) {
                if (game.Name == Platform) {
                    Gold777_Settings x = game.Settings.Gold777;
                    if (x.Page == 10 && x.Button_X == 440 && x.Button_Y == 450) {
                        game.Settings.Gold777.Button_X = 210;
                        game.Settings.Gold777.Button_Y = 450;
                        game.Settings.Gold777.Page = 10;
                        //game.Settings.Gold777.ButtonVerified = false;
                        game.Save();
                    }
                }
            }
        });
    }

    private static void PrioritizeTesting(string Platform) {
        while (true) {
            List<Game> games = Game.GetAll();
            games.ForEach(delegate (Game game) {
                game.Updated = game.Name.Equals(Platform).Equals(false);
                game.Save();
            });
            Thread.Sleep(TimeSpan.FromSeconds(60));
        }
    }

    private static void TestSignals(string Platform) {
        while (true) {
            List<Game> games = Game.GetAll().FindAll(x => x.Name.Equals(Platform));
            games.OrderBy(game => game.LastUpdated);
            double lastRetrievedGrand = 0.0;

            ChromeDriver driver = Actions.Launch();
            switch (Platform) {
                case "FireKirin":
                    driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                    break;
                case "OrionStars":
                    driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                    if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false)
                        throw new Exception("Took too long to load.");
                    Mouse.Click(535, 615);
                    break;
            }


            int iteration = 0;
            foreach (Game game in games) {
                Console.WriteLine($"{DateTime.UtcNow} - Retrieving Game");
                Game retrievedGame = Game.Get(game.House, game.Name);
                if (retrievedGame.Settings.Gold777.ButtonVerified == false) { //&& retrievedGame.Unlocked) {
                    Console.WriteLine($"{DateTime.UtcNow} - Retrieving Credential");
                    List<Credential> gameCredentials = Credential.GetBy(retrievedGame).Where(x => x.Enabled && x.Balance > 0).ToList();
                    Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];
                    Console.WriteLine($"{DateTime.UtcNow} - {retrievedGame.House}/{credential?.Username}");
                    if (credential != null) {
                        retrievedGame.Lock();
                        switch (retrievedGame.Name) {
                            case "FireKirin":
                                if (Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 30) == false) {
                                    throw new Exception("Took too long to load.");
                                }
                                bool loggedIn = false;
                                while (loggedIn == false) {
                                    loggedIn = driver.Login(credential.Username, credential.Password);
                                }

                                Color hallScreen = Screen.GetColorAt(new Point(293, 179));
                                while (hallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false) {
                                    Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {hallScreen}");
                                    Thread.Sleep(500); hallScreen = Screen.GetColorAt(new Point(293, 179));
                                }
                                Mouse.Click(81, 233); Thread.Sleep(800);
                                for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++) {
                                    Mouse.Click(937, 177); Thread.Sleep(800);
                                }
                                break;

                            case "OrionStars":
                                if (OrionStars.Login(driver, credential.Username, credential.Password) == false) {
                                    break;
                                }
                                Mouse.Click(80, 218);
                                for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++) {
                                    Mouse.Click(995, 375); Thread.Sleep(800);
                                }
                                break;
                        }



                        Mouse.Move(retrievedGame.Settings.Gold777.Button_X, retrievedGame.Settings.Gold777.Button_Y);

                        retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
                        Mouse.Click(retrievedGame.Settings.Gold777.Button_X, retrievedGame.Settings.Gold777.Button_Y);

                        int checkAttempts = 0; bool buttonVerified = false;
                        while (checkAttempts <= 20 && buttonVerified == false) {
                            // Color splashScreen = Screen.GetColorAt(new Point(620, 305)); // FortunePiggy
                            // buttonVerified = splashScreen.Equals(Color.FromArgb(255, 252, 227, 227)); // FortunePiggy
                            Color splashScreen = Color.White;
                            switch (Platform) {
                                case "FireKirin":
                                    splashScreen = Screen.GetColorAt(new Point(316, 434)); // Gold777
                                    buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 183));
                                    break;
                                case "OrionStars":
                                    splashScreen = Screen.GetColorAt(new Point(314, 432)); // Gold777
                                    buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 194));
                                    break;
                            }
                            Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {splashScreen}");
                            Thread.Sleep(500); checkAttempts++;
                        }

                        if (buttonVerified) {
                            retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
                            retrievedGame.Settings.Gold777.ButtonVerified = true;
                            retrievedGame.Save();
                        }
                        switch (Platform) {
                            case "FireKirin":
                                driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                                Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));
                                break;
                            case "OrionStars":
                                driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                                break;
                        }

                        // Color hallScreen = Screen.GetColorAt(new Point(294, 171));
                        // while (hallScreen.Equals(Color.FromArgb(255, 0, 130, 55)) == false) {
                        //     Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {hallScreen}");
                        //     Thread.Sleep(500); hallScreen = Screen.GetColorAt(new Point(294, 171));
                        // }

                        int grandChecked = 0;
                        double currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;

                        while (currentGrand.Equals(0) || lastRetrievedGrand.Equals(currentGrand)) {
                            Thread.Sleep(500);
                            if (grandChecked++ > 40) throw new Exception("Extension failure.");
                            currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
                        }

                        double currentMajor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
                        double currentMinor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
                        double currentMini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;

                        if (lastRetrievedGrand.Equals(currentGrand) == false) {
                            if (currentGrand < retrievedGame.Jackpots.Grand && (retrievedGame.Jackpots.Grand - currentGrand) > 0.1) {
                                if (retrievedGame.DPD.Toggles.GrandPopped == true) {
                                    retrievedGame.Jackpots.Grand = currentGrand;
                                    retrievedGame.DPD.Toggles.GrandPopped = false;
                                    retrievedGame.Thresholds.NewGrand(retrievedGame.Jackpots.Grand);
                                } else retrievedGame.DPD.Toggles.GrandPopped = true;
                            } else retrievedGame.Jackpots.Grand = currentGrand;

                            if (currentMajor < retrievedGame.Jackpots.Major && (retrievedGame.Jackpots.Major - currentMajor) > 0.1) {
                                if (retrievedGame.DPD.Toggles.MajorPopped == true) {
                                    retrievedGame.Jackpots.Major = currentMajor;
                                    retrievedGame.DPD.Toggles.MajorPopped = false;
                                    retrievedGame.Thresholds.NewMajor(retrievedGame.Jackpots.Major);
                                } else retrievedGame.DPD.Toggles.MajorPopped = true;
                            } else retrievedGame.Jackpots.Major = currentMajor;

                            if (currentMinor < retrievedGame.Jackpots.Minor && (retrievedGame.Jackpots.Minor - currentMinor) > 0.1) {
                                if (retrievedGame.DPD.Toggles.MinorPopped == true) {
                                    retrievedGame.Jackpots.Minor = currentMinor;
                                    retrievedGame.DPD.Toggles.MinorPopped = false;
                                    retrievedGame.Thresholds.NewMinor(retrievedGame.Jackpots.Minor);
                                } else retrievedGame.DPD.Toggles.MinorPopped = true;
                            } else retrievedGame.Jackpots.Minor = currentMinor;

                            if (currentMini < retrievedGame.Jackpots.Mini && (retrievedGame.Jackpots.Mini - currentMini) > 0.1) {
                                if (retrievedGame.DPD.Toggles.MiniPopped == true) {
                                    retrievedGame.Jackpots.Mini = currentMini;
                                    retrievedGame.DPD.Toggles.MiniPopped = false;
                                    retrievedGame.Thresholds.NewMini(retrievedGame.Jackpots.Mini);
                                } else retrievedGame.DPD.Toggles.MiniPopped = true;
                            } else retrievedGame.Jackpots.Mini = currentMini;

                        } else {
                            throw new Exception("Invalid grand retrieved.");
                        }

                        float currentBalance = Convert.ToSingle(driver.ExecuteScript("return window.parent.Balance")) / 100;
                        if (credential.CashedOut && (currentBalance > credential.Balance) && (currentBalance - credential.Balance > 5)) {
                            credential.LastDepositDate = DateTime.UtcNow;
                            credential.CashedOut = false;
                        }
                        credential.LastUpdated = DateTime.UtcNow;
                        credential.Balance = currentBalance;
                        lastRetrievedGrand = currentGrand;

                        credential.Save();
                        retrievedGame.Unlock();

                        switch (Platform) {
                            case "FireKirin":
                                // for (int i = 0; i < retrievedGame.Settings.Gold777.Page; i++) {
                                //     Mouse.Click(880, 177); Thread.Sleep(800);
                                // }
                                Mouse.Click(81, 233); Thread.Sleep(800);
                                FireKirin.Logout();
                                break;
                            case "OrionStars":
                                Mouse.Click(80, 218); Thread.Sleep(800);
                                OrionStars.Logout();
                                break;
                        }





                    }
                }
            }
            ;
            driver.Quit();
        }
    }

    private static void ResetDPD() {
        // var x = Game.GetNext();
        // var y = Credential.GetBy(x);
        // Console.WriteLine(y);
        // List<Game> games = Game.GetAll();
        // games.ForEach(delegate (Game game) {
        //     game.DPD = new DPD();
        //     game.Save();
        // });

    }

    private static void CheckSignals() {
        Game game = Game.GetNext();
        Credential credential = Credential.GetBy(game)[0];
        Signal signal = new Signal(100, credential);
        signal.Save();
    }

    private static void Fix() {
        List<Game> games = Game.GetAll();
        games.ForEach(delegate (Game game) {
            if (game.House.Equals("Candies GameRoom")) {
                List<DPD_Data> data = game.DPD.History[^1].Data;
                // game.DPD.Data.RemoveAt(0);
                data.AddRange(game.DPD.Data);
                game.DPD.Data = data;
                game.Save();
            }
        });
    }


    private static void Sandbox() {
        int dataCount = 0;
        List<Game> games = Game.GetAll();
        games.ForEach(delegate (Game game) {
            int count = game.DPD.Data.Count;
            dataCount = count > dataCount ? count : dataCount;
        });
        Console.WriteLine(dataCount);
    }
    private static void GamesWithNoCredentials() {
        List<Game> games = Game.GetAll();
        List<Credential> gamesWithNoCredentials = [];
        List<Credential> credentials = Credential.Database();
        credentials.ForEach(delegate (Credential credential) {
            if (games.FindAll(c => c.House.Equals(credential.House)).Count.Equals(0)) {
                Console.WriteLine($"[{gamesWithNoCredentials.Count}] - {credential.Username}");
                Console.WriteLine($"[{credential.House}]");
                gamesWithNoCredentials.Add(credential);
                Console.WriteLine();
            }
        });
        Console.WriteLine(gamesWithNoCredentials.Count);

    }

    private static void RemoveInvalidDPD_Date() {
        List<Game> games = Game.GetAll();
        // games.RemoveAll(game => game.DPD.Data[0].Grand < 0);
        games.ForEach(delegate (Game game) {
            if (game.DPD.Data[0].Grand < 0) {
                game.DPD.Data.RemoveAll(Data => Data.Grand < 0);
                game.Save();
            }
        });
    }
    static void ClearBalances() {
        List<Credential> credentials = Credential.GetAll();
        credentials.ForEach(delegate (Credential credential) {
            credential.Balance = 0F;
            credential.Save();
        });
    }
    static void SetThresholdsToDefault() {
        List<Game> games = Game.GetAll();
        games.ForEach(delegate (Game game) {
            game.Thresholds.Grand = 1785F;
            game.Thresholds.Major = 565F;
            game.Thresholds.Minor = 117F;
            game.Thresholds.Mini = 23F;
            // game.Thresholds.Data = new Thresholds_Data();
            game.Save();
        });
    }

    static void FixDPD() {
        // Game game = Game.GetBy.House(house);
        List<Game> games = Game.GetAll();
        games.RemoveAll(game => game.House != "Lucky Heart Gameroom");

        games.ForEach(delegate (Game game) {
            // List<DPD_Data> archive = new List<DPD_Data>();
            // game.DPD.History.ForEach(delegate (DPD_History dto) {
            //     archive.AddRange(dto.Data);
            // });
            //archive.AddRange(game.DPD.Data);

            game.DPD.Data = game.DPD.History[^1].Data;
            game.DPD.Average = game.DPD.History[^1].Average;
            game.Jackpots.Grand = game.DPD.Data[^1].Grand;
            // game.Unlock();
            // game.DPD.Average = 0F;
            // game.DPD.Data = [];
            // game.DPD.History = [];

            // for (int i = 0; i < archive.Count; i++) {
            //     DPD_Data dto = archive[i];
            //     float currentGrand = dto.Grand;
            //     if (game.DPD.Data.Count == 0) game.DPD.Data.Add(dto);
            //     else {
            //         float previousGrand = game.DPD.Data[game.DPD.Data.Count - 1].Grand;
            //         if (currentGrand != previousGrand) {
            //             if (currentGrand > previousGrand) {
            //                 game.DPD.Data.Add(dto);
            //                 float minutes = Convert.ToSingle((game.DPD.Data[game.DPD.Data.Count - 1].Timestamp - game.DPD.Data[0].Timestamp).TotalMinutes);
            //                 float dollars = game.DPD.Data[game.DPD.Data.Count - 1].Grand - game.DPD.Data[0].Grand;
            //                 float MinutesInADay = Convert.ToSingle(TimeSpan.FromDays(1).TotalMinutes);
            //                 float days = minutes / MinutesInADay;
            //                 float dollarsPerDay = dollars / days;
            //                 game.DPD.Average = dollarsPerDay;
            //                 Console.WriteLine("[" + i + "] DPD: " + game.DPD.Average);
            //             } else {
            //                 // game.DPD.History.Add(new DPD_History(game.DPD.Average, game.DPD.Data));
            //                 // game.DPD.Data = [];
            //                 // game.DPD.Average = 0F;
            //                 // game.DPD.Data.Add(dto);
            //             }
            //         }
            //     }
            // }
            // game.DPD.History[0].Timestamp = DateTime.Now;
            // game.Unlocked = true;
            game.Save();
        });
    }
}