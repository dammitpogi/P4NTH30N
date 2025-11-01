using System.Diagnostics;
using System.Drawing;
using OpenQA.Selenium.Chrome;
using P4NTH30N.C0MMON;

namespace P4NTH30N;

class H0UND {
    static void Main() {
        float lastRetrievedGrand = 0;
        while (true) {
            Game game = Game.GetNext(); bool RanOnce = false;
            List<Credential> gameCredentials = Credential.GetBy(game);

            ChromeDriver driver = Actions.Launch();
            Mouse.Click(1026, 122);
            driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
            Mouse.RtClick(182, 30);
            Mouse.Click(243, 268);

            try {
                while (true) {
                    if (RanOnce) {
                        game = Game.GetNext();
                        gameCredentials = Credential.GetBy(game);
                    }

                    Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];

                    if (credential == null) {
                        game.Unlock();
                    } else {
                        game.Lock();
                        if (Screen.WaitForColor(new Point(650, 505), Color.FromArgb(255, 11, 241, 85), 30) == false) {
                            throw new Exception("Took too long to load.");
                        }
                        // Console.WriteLine("LoginAttempt: " + game.House);
                        // Console.WriteLine("LoginAttempt: " + credential.Username);
                        if (driver.Login(credential.Username, credential.Password) == false) {
                            if (Screen.GetColorAt(new Point(893, 117)).Equals(Color.FromArgb(255, 125, 124, 27))) {
                                throw new Exception("This looks like a stuck Hall Screen. Resetting.");
                            }
                            RanOnce = true;
                            game.Lock();
                            continue;
                        }

                        int grandChecked = 0;
                        float currentGrand = Convert.ToSingle(driver.ExecuteScript("return window.parent.Grand")) / 100F;
                        
                        while (currentGrand.Equals(0) || lastRetrievedGrand.Equals(currentGrand)) { 
                            Thread.Sleep(500);
                            if (grandChecked++ > 40) throw new Exception("Extension failure.");
                            currentGrand = Convert.ToSingle(driver.ExecuteScript("return window.parent.Grand")) / 100F;
                        }

                        float currentMajor = Convert.ToSingle(driver.ExecuteScript("return window.parent.Major")) / 100F;
                        float currentMinor = Convert.ToSingle(driver.ExecuteScript("return window.parent.Minor")) / 100F;
                        float currentMini = Convert.ToSingle(driver.ExecuteScript("return window.parent.Mini")) / 100F;

                        if (lastRetrievedGrand.Equals(currentGrand) == false) {
                            if (currentGrand < game.Jackpots.Grand && (game.Jackpots.Grand - currentGrand) > 0.1) {
                                if (game.DPD.Toggles.GrandPopped == true) {
                                    game.Jackpots.Grand = currentGrand;
                                    game.DPD.Toggles.GrandPopped = false;
                                    game.Thresholds.NewGrand(game.Jackpots.Grand);
                                } else game.DPD.Toggles.GrandPopped = true;
                            } else game.Jackpots.Grand = currentGrand;

                            if (currentMajor < game.Jackpots.Major && (game.Jackpots.Major - currentMajor) > 0.1) {
                                if (game.DPD.Toggles.MajorPopped == true) {
                                    game.Jackpots.Major = currentMajor;
                                    game.DPD.Toggles.MajorPopped = false;
                                    game.Thresholds.NewMajor(game.Jackpots.Major);
                                } else game.DPD.Toggles.MajorPopped = true;
                            } else game.Jackpots.Major = currentMajor;

                            if (currentMinor < game.Jackpots.Minor && (game.Jackpots.Minor - currentMinor) > 0.1) {
                                if (game.DPD.Toggles.MinorPopped == true) {
                                    game.Jackpots.Minor = currentMinor;
                                    game.DPD.Toggles.MinorPopped = false;
                                    game.Thresholds.NewMinor(game.Jackpots.Minor);
                                } else game.DPD.Toggles.MinorPopped = true;
                            } else game.Jackpots.Minor = currentMinor;

                            if (currentMini < game.Jackpots.Mini && (game.Jackpots.Mini - currentMini) > 0.1) {
                                if (game.DPD.Toggles.MiniPopped == true) {
                                    game.Jackpots.Mini = currentMini;
                                    game.DPD.Toggles.MiniPopped = false;
                                    game.Thresholds.NewMini(game.Jackpots.Mini);
                                } else game.DPD.Toggles.MiniPopped = true;
                            } else game.Jackpots.Mini = currentMini;

                        } else {
                            throw new Exception("Invalid grand retrieved.");
                        }
                        game.Unlock();

                        float currentBalance = Convert.ToSingle(driver.ExecuteScript("return window.parent.Balance")) / 100;
                        credential.LastUpdated = DateTime.UtcNow;
                        credential.Balance = currentBalance;
                        lastRetrievedGrand = currentGrand;
                        credential.Save();

                        Actions.Logout();
                    }
                    RanOnce = true;
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
        }
    }
}