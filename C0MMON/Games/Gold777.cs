using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static partial class Games {
    public static void Gold777(ChromeDriver driver, Game game, Signal signal) {
        if (game.Settings.Gold777 == null)
            game.Settings.Gold777 = new Gold777_Settings();

        switch (game.Name) {
            case "FireKirin":
                for (int i = 1; i < game.Settings.Gold777.Page; i++) {
                    Mouse.Click(937, 177); Thread.Sleep(800);
                }
                break;
            case "OrionStars":
                Mouse.Click(80, 218);
                for (int i = 1; i < game.Settings.Gold777.Page; i++) {
                    Mouse.Click(995, 375); Thread.Sleep(800);
                }
                break;
        }

        double balance = 0; int iterations = 0; bool slotsLoaded = false;
        Mouse.Move(game.Settings.Gold777.Button_X, game.Settings.Gold777.Button_Y);

        while (slotsLoaded == false) {
            signal.Acknowledge();
            Mouse.Click(game.Settings.Gold777.Button_X, game.Settings.Gold777.Button_Y);
            // Mouse.Click(970, 440);

            string page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;

            //signal.Acknowledge();

            // while ((page.Equals("Slots") || page.Equals("Game")).Equals(false)) {
            while (new string[] { "Slots", "Game" }.Contains(page).Equals(false)) {
                if (Screen.GetColorAt(new Point(544, 391)).Equals(Color.FromArgb(255, 129, 1, 1))) {
                    throw new Exception("Account is already spinning Slots.");
                }

                if (iterations++ > 120) {
                    throw new Exception("Took too long to load page in Slots.");
                }

                Thread.Sleep(500);
                page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
                Console.WriteLine(page);
            }

            int balanceIterations = 0;
            signal.Acknowledge();
            balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
            Console.WriteLine($"{balanceIterations} - ${balance}");
            while (balance.Equals(0)) {
                if (balanceIterations++ > 30) {
                    driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                    Console.WriteLine("Took too long to load balance in Slots.");

                    Thread.Sleep(2000);
                    string reloadedPage = string.Empty; int ClicksWhileWaiting = 0;
                    while (new string[] { "Slots", "Game" }.Contains(reloadedPage).Equals(false)) {
                        Mouse.Click(game.Settings.Gold777.Button_X, game.Settings.Gold777.Button_Y);
                        reloadedPage = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
                        if (ClicksWhileWaiting++ > 20) break;
                        Thread.Sleep(500);
                    }
                    break;
                }
                Thread.Sleep(500);
                signal.Acknowledge();
                balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
                Console.WriteLine($"{balanceIterations} - ${balance}");
            }
            Color SpinButtonFontColor = Color.Black;
            Color Confirmation = game.Name switch {
                "FireKirin" => Color.FromArgb(255, 253, 253, 14),
                "OrionStars" => Color.FromArgb(255, 253, 253, 14),
                _ => Color.Black
            };

            bool SpinButtonLocated = false;
            int Iterations_SpinButtonLocated = 0;
            while (Iterations_SpinButtonLocated++ < 120 && SpinButtonLocated.Equals(false)) {
                SpinButtonFontColor = Screen.GetColorAt(new Point(929, 612));
                SpinButtonLocated = SpinButtonFontColor.Equals(Confirmation);
                Thread.Sleep(500);
            }
            // Console.WriteLine("");
            Console.WriteLine($"[{game.Name}] Gold777 Confirmation: {Confirmation}");
            Console.WriteLine($"[{game.Name}] Gold777 SpinButtonFontColor: {SpinButtonFontColor}");

            if (SpinButtonLocated == false) {
                // Console.WriteLine("");
                // Console.WriteLine("Failed to load Gold777 Slots.");
                // Console.WriteLine("Failed to load Gold777 Slots.");
                throw new Exception("Failed to load Gold777 Slots.");
            }
            // Console.WriteLine("");

            slotsLoaded = balance > 0;
        }

        Mouse.LongClick(929, 612);
        // Mouse.Click(955, 290);

        int FailedSpinChecks = 0, remainingIterations = 20, missingSignalIterations = 5;
        double grandPrior = game.Jackpots.Grand;
        double majorPrior = game.Jackpots.Major;
        double minorPrior = game.Jackpots.Minor;
        double miniPrior = game.Jackpots.Mini;
        bool jackpotPopped = false;

        while (remainingIterations > 0) {
            string page = driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
            if (new string[] { "Slots", "Game" }.Contains(page).Equals(false)) { break; }

            Signal? newSignal = Signal.GetNext();
            if (newSignal != null && newSignal.Priority > signal.Priority) {
                signal.Acknowledged = true; signal.Timeout = DateTime.UtcNow.AddMinutes(2); signal.Save();
                throw new Exception($"Signal for {newSignal.House} stronger than previous signal from {signal.House}.");
            }

            if (signal.Check() == false) {
                if (missingSignalIterations == 0) {
                    jackpotPopped = true;
                }
                missingSignalIterations--;
            } else {
                missingSignalIterations = 5;
                remainingIterations = 20;
                jackpotPopped = false;
            }

            // double balancePrior = balance;
            Thread.Sleep(TimeSpan.FromSeconds(10));
            Mouse.Click(534, 466);
            Mouse.Click(534, 523);
            Mouse.Click(533, 564);
            signal.Acknowledge();

            game = Game.Get(signal.House, signal.Game);

            game.Jackpots.Grand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
            game.Jackpots.Major = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
            game.Jackpots.Minor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
            game.Jackpots.Mini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;

            if (game.Jackpots.Grand.Equals(0)) {
                throw new Exception("Failed to retrieve Jackpot data.");
            }

            if (grandPrior > game.Jackpots.Grand && (grandPrior - game.Jackpots.Grand) > 1) {
                if (signal.Priority.Equals(4)) { jackpotPopped = true; signal.Close(grandPrior); signal.Delete(); }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Grand Popped!!");
                game.Thresholds.NewGrand(grandPrior);
                Console.WriteLine();
            }
            if (majorPrior > game.Jackpots.Major && (majorPrior - game.Jackpots.Major) > 1) {
                if (signal.Priority.Equals(3)) { jackpotPopped = true; signal.Close(majorPrior); signal.Delete(); }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Major Popped!!");
                game.Thresholds.NewMajor(majorPrior);
                Console.WriteLine();
            }
            if (minorPrior > game.Jackpots.Minor && (minorPrior - game.Jackpots.Minor) > 1) {
                if (signal.Priority.Equals(2)) { jackpotPopped = true; signal.Close(minorPrior); signal.Delete(); }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Minor Popped!!");
                game.Thresholds.NewMinor(minorPrior);
                Console.WriteLine();
            }
            if (miniPrior > game.Jackpots.Mini && (miniPrior - game.Jackpots.Mini) > 1) {
                if (signal.Priority.Equals(1)) { jackpotPopped = true; signal.Close(miniPrior); signal.Delete(); }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Mini Popped!!");
                game.Thresholds.NewMini(miniPrior);
                Console.WriteLine();
            }

            game.LastUpdated = DateTime.UtcNow;
            grandPrior = game.Jackpots.Grand;
            majorPrior = game.Jackpots.Major;
            minorPrior = game.Jackpots.Minor;
            miniPrior = game.Jackpots.Mini;
            game.Save();

            double balancePrior = balance;
            balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
            Credential? credential = Credential.GetBy(Game.Get(signal.House, signal.Game), signal.Username);
            if (credential != null) {
                credential.LastUpdated = DateTime.UtcNow;
                credential.Balance = balance;
                credential.Save();
            }

            if (balance.Equals(balancePrior)) {
                if (FailedSpinChecks++ > 3) {
                    Mouse.LongClick(929, 612);
                    FailedSpinChecks = 0;
                }
            } else {
                FailedSpinChecks = 0;
            }

            if (jackpotPopped) {
                remainingIterations--;
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - {remainingIterations} Remaining Iterations...");
            }
        }
    }
}