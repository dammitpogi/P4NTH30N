using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static partial class Games {
    public static Signal? FortunePiggy(ChromeDriver driver, Game game, Signal signal) {
        for (int i = 1; i < game.Settings.FortunePiggy.Page; i++) {
            switch (game.Name) {
                case "FireKirin":
                    Mouse.Click(937, 177);
                    Thread.Sleep(800);
                    break;
                case "OrionStars":
                    Mouse.Click(995, 375);
                    Thread.Sleep(800);
                    break;
            }
        }
        double balance = 0;
        int iterations = 0;
        bool slotsLoaded = false;
        Mouse.Move(game.Settings.FortunePiggy.Button_X, game.Settings.FortunePiggy.Button_Y);

        while (slotsLoaded == false) {
            signal.Acknowledge();
            Mouse.Click(game.Settings.FortunePiggy.Button_X, game.Settings.FortunePiggy.Button_Y);
            // Mouse.Click(970, 440);

            string page =
                driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;

            //signal.Acknowledge();

            // while ((page.Equals("Slots") || page.Equals("Game")).Equals(false)) {
            while (
                new string[] { "Slots", "Game" }
                    .Contains(page)
                    .Equals(false)
            ) {
                if (Screen.GetColorAt(new Point(544, 391)).Equals(Color.FromArgb(255, 129, 1, 1))) {
                    throw new Exception("Account is already spinning Slots.");
                }

                if (iterations++ > 120) {
                    throw new Exception("Took too long to load page in Slots.");
                }

                Thread.Sleep(500);
                page =
                    driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
                Console.WriteLine(page);
            }

            int balanceIterations = 0;
            signal.Acknowledge();
            balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
            Console.WriteLine($"{balanceIterations} - ${balance}");
            while (balance.Equals(0)) {
                if (balanceIterations++ > 20) {
                    driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                    Console.WriteLine("Took too long to load balance in Slots.");

                    Thread.Sleep(2000);
                    string reloadedPage = string.Empty;
                    int ClicksWhileWaiting = 0;
                    while (
                        new string[] { "Slots", "Game" }
                            .Contains(reloadedPage)
                            .Equals(false)
                    ) {
                        Mouse.Click(
                            game.Settings.FortunePiggy.Button_X,
                            game.Settings.FortunePiggy.Button_Y
                        );
                        reloadedPage =
                            driver.ExecuteScript("return window.parent.Page")?.ToString()
                            ?? string.Empty;
                        if (ClicksWhileWaiting++ > 20)
                            break;
                        Thread.Sleep(500);
                        balanceIterations = 0;
                    }
                }
                Thread.Sleep(500);
                signal.Acknowledge();
                balance =
                    Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
                Console.WriteLine($"{balanceIterations} - ${balance}");
            }

            Color Confirmation = game.Name switch {
                "FireKirin" => Color.FromArgb(255, 255, 255, 255),
                "OrionStars" => Color.FromArgb(255, 51, 199, 109),
                _ => Color.Black,
            };

            if (Screen.WaitForColor(new Point(957, 602), Confirmation, 30) == false) {
                throw new Exception("Failed to load Fortune Piggy Slots.");
            }
            slotsLoaded = balance > 0;
        }

        Mouse.LongClick(950, 620);
        Mouse.Click(955, 290);

        int FailedSpinChecks = 0,
            remainingIterations = 10,
            missingSignalIterations = 5;
        double grandPrior = game.Jackpots.Grand;
        double majorPrior = game.Jackpots.Major;
        double minorPrior = game.Jackpots.Minor;
        double miniPrior = game.Jackpots.Mini;
        bool jackpotPopped = false;

        while (remainingIterations > 0) {
            string page =
                driver.ExecuteScript("return window.parent.Page")?.ToString() ?? string.Empty;
            if (
                new string[] { "Slots", "Game" }
                    .Contains(page)
                    .Equals(false)
            ) {
                break;
            }

            Signal? newSignal = Signal.GetNext();
            // newSignal = (Signal)signal.Clone(); newSignal.Priority = 4;
            if (newSignal != null && newSignal.Priority > signal.Priority) {
                newSignal.Acknowledge();
                Mouse.Click(950, 620); Thread.Sleep(3000);
                switch (game.Name) {
                    case "FireKirin":
                        driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                        P4NTH30N.C0MMON.Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));
                        break;
                    case "OrionStars":
                        driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                        P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                        break;
                }
                return newSignal;
            }

            if (signal.Check() == false) {
                if (missingSignalIterations == 0) {
                    jackpotPopped = true;
                }
                missingSignalIterations--;
            } else {
                missingSignalIterations = 5;
                remainingIterations = 10;
                jackpotPopped = false;
            }

            Thread.Sleep(TimeSpan.FromSeconds(10));
            Mouse.Click(534, 466);
            Mouse.Click(534, 523);
            Mouse.Click(533, 564);
            signal.Acknowledge();

            game = Game.Get(signal.House, signal.Game);

            game.Jackpots.Grand =
                Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
            game.Jackpots.Major =
                Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
            game.Jackpots.Minor =
                Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
            game.Jackpots.Mini =
                Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;

            if (game.Jackpots.Grand.Equals(0)) {
                throw new Exception("Failed to retrieve Jackpot data.");
            }

            if (grandPrior > game.Jackpots.Grand && (grandPrior - game.Jackpots.Grand) > 0.1) {
                if (signal.Priority.Equals(4)) {
                    jackpotPopped = true;
                    signal.Close(grandPrior);
                    signal.Delete();
                }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Grand Popped!!");
                game.Thresholds.NewGrand(grandPrior);
                Console.WriteLine();
            }
            if (majorPrior > game.Jackpots.Major && (majorPrior - game.Jackpots.Major) > 0.1) {
                if (signal.Priority.Equals(3)) {
                    jackpotPopped = true;
                    signal.Close(majorPrior);
                    signal.Delete();
                }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Major Popped!!");
                game.Thresholds.NewMajor(majorPrior);
                Console.WriteLine();
            }
            if (minorPrior > game.Jackpots.Minor && (minorPrior - game.Jackpots.Minor) > 0.1) {
                if (signal.Priority.Equals(2)) {
                    jackpotPopped = true;
                    signal.Close(minorPrior);
                    signal.Delete();
                }
                Console.WriteLine($"({DateTime.UtcNow}) {game.House} - Minor Popped!!");
                game.Thresholds.NewMinor(minorPrior);
                Console.WriteLine();
            }
            if (miniPrior > game.Jackpots.Mini && (miniPrior - game.Jackpots.Mini) > 0.1) {
                if (signal.Priority.Equals(1)) {
                    jackpotPopped = true;
                    signal.Close(miniPrior);
                    signal.Delete();
                }
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
            Credential? credential = Credential.GetBy(
                Game.Get(signal.House, signal.Game),
                signal.Username
            );
            if (credential != null) {
                credential.LastUpdated = DateTime.UtcNow;
                credential.Balance = balance;
                credential.Save();
            }

            if (balance.Equals(balancePrior)) {
                if (FailedSpinChecks++ > 3) {
                    Mouse.LongClick(950, 620);
                    Mouse.Click(955, 290);
                    FailedSpinChecks = 0;
                }
            } else {
                FailedSpinChecks = 0;
            }

            if (jackpotPopped) {
                remainingIterations--;
                Console.WriteLine(
                    $"({DateTime.UtcNow}) {game.House} - {remainingIterations} Remaining Iterations..."
                );
            }
        }
        return null;
    }
}
