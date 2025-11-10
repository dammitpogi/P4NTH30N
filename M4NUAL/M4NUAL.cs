using OpenQA.Selenium.Chrome;
using P4NTH30N.C0MMON;
using P4NTH30N;
using Figgle;
using System.Drawing;
using System.Runtime.InteropServices;
using OpenQA.Selenium.BiDi.Input;

namespace P4NTH30N {
    [GenerateFiggleText(sourceText: "v    0 . 2 . 0", memberName: "Version", fontName: "colossal")]
    internal static partial class Header { }
}

public class Program {
    public static void Main(string[] args) {
        bool checkLockedGames = true, massUpdateGames = false;
        string selectedPlatform = string.Empty, selectedGame = string.Empty,
            errorString = string.Empty, checkLockedSelection = string.Empty,
            massUpdateSelection = string.Empty;

        Console.WriteLine(Header.Version);
        while (selectedPlatform.Equals(string.Empty)) {
            Console.WriteLine("--- Platform Selection ---");
            List<string> platformOptions = ["FireKirin", "OrionStars"];

            for (int i = 0; i < platformOptions.Count; i++)
                Console.WriteLine($"{i + 1}. {platformOptions[i]}");
            Console.WriteLine($"{errorString}");
            Console.Write("Choose Platform: ");

            string platformInput = Console.ReadKey(true).KeyChar.ToString();
            if (int.TryParse(platformInput, out int platformChoice))
                if (platformChoice >= 1 && platformChoice <= platformOptions.Count)
                    selectedPlatform = platformOptions[platformChoice - 1];
            errorString = string.Empty;
            if (selectedPlatform.Equals(string.Empty)) {
                errorString = $"Invalid Option Chosen. {platformInput}";
                Console.Clear();
                continue;
            }
            Console.WriteLine($"{selectedPlatform}\n");
        }

        while (selectedGame.Equals(string.Empty)) {
            Console.WriteLine("--- Game Selection ---");
            List<string> gameOptions = ["Gold777", "FortunePiggy"];

            for (int i = 0; i < gameOptions.Count; i++)
                Console.WriteLine($"{i + 1}. {gameOptions[i]}");
            Console.WriteLine($"{errorString}");
            Console.Write("Choose Game: ");

            string gameInput = Console.ReadKey(true).KeyChar.ToString();
            if (int.TryParse(gameInput, out int gameChoice))
                if (gameChoice >= 1 && gameChoice <= gameOptions.Count)
                    selectedGame = gameOptions[gameChoice - 1];

            errorString = string.Empty;
            if (selectedGame.Equals(string.Empty)) {
                errorString = $"Invalid Option Chosen. ({gameInput})";
                Console.Clear();
                continue;
            }
            Console.WriteLine($"{selectedGame}\n");
        }

        while (checkLockedSelection.Equals(string.Empty)) {
            Console.WriteLine("--- Respect Locked Games ---");
            Console.WriteLine("1. Yes\n2. No");
            Console.WriteLine($"{errorString}");
            Console.Write("Skip Locked Games: ");

            string checkLockedInput = Console.ReadKey(true).KeyChar.ToString();
            if (int.TryParse(checkLockedInput, out int checkLockedChoice))
                if (new int[] { 1, 2 }.Contains(checkLockedChoice))
                    checkLockedSelection = checkLockedChoice.Equals(1) ? "False" : "True";

            errorString = string.Empty;
            if (checkLockedSelection.Equals(string.Empty)) {
                errorString = $"Invalid Option Chosen. {checkLockedInput}";
                Console.Clear();
                continue;
            } else {
                _ = bool.TryParse(checkLockedSelection, out checkLockedGames);
            }
            Console.WriteLine($"{(checkLockedGames ? "No" : "Yes")}\n");
        }

        while (massUpdateSelection.Equals(string.Empty)) {
            Console.WriteLine("--- Update Similar Games ---");
            Console.WriteLine("1. Yes\n2. No");
            Console.WriteLine($"{errorString}");
            Console.Write("Propagate Updates: ");

            string massUpdateInput = Console.ReadKey(true).KeyChar.ToString();
            if (int.TryParse(massUpdateInput, out int massUpdateChoice))
                if (new int[] { 1, 2 }.Contains(massUpdateChoice))
                    massUpdateSelection = massUpdateChoice.Equals(1) ? "True" : "False";

            errorString = string.Empty;
            if (massUpdateSelection.Equals(string.Empty)) {
                errorString = $"Invalid Option Chosen. {massUpdateInput}";
                Console.Clear();
                continue;
            } else {
                _ = bool.TryParse(massUpdateSelection, out massUpdateGames);
            }
            Console.WriteLine($"{(massUpdateGames ? "Yes" : "No")}\n");
        }
        Console.WriteLine("----------------------------------");

        List<Game> unverifiedGames = Game.GetUnverified(selectedPlatform, selectedGame);
        Console.WriteLine($"{unverifiedGames.Count} Unverified Games Remaining...");

        ChromeOptions options = new();
        ChromeDriverService service = ChromeDriverService.CreateDefaultService();
        options.AddArguments(["--disable-logging", "--log-level=3"]);
        service.SuppressInitialDiagnosticInformation = true;
        options.AddExcludedArgument("enable-logging");

        while (true) {
            // Mouse.Click(1279, 180);
            ChromeDriver driver = new(service, options);
            string originalWindowHandle = driver.CurrentWindowHandle;
            Size windowSize = driver.Manage().Window.Size;
            Mouse.Click(1024, 121);
            try {
                switch (selectedPlatform) {
                    case "FireKirin":
                        driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                        break;
                    case "OrionStars":
                        driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                        if (P4NTH30N.C0MMON.Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false)
                            throw new Exception("Took too long to load.");
                        Mouse.Click(535, 615);
                        break;
                }

                foreach (Game game in unverifiedGames) {
                    //Console.WriteLine($"{DateTime.UtcNow} - Retrieving Game");
                    Game retrievedGame = Game.Get(game.House, game.Name);
                    // retrievedGame = Game.Get("Playing Bar", "FireKirin");
                    // retrievedGame.Settings.Gold777.ButtonVerified = false;

                    if (retrievedGame.Settings.Gold777.ButtonVerified == false && (checkLockedGames || retrievedGame.Unlocked)) {
                        //Console.WriteLine($"{DateTime.UtcNow} - Retrieving Credential");
                        List<Credential> gameCredentials = Credential.GetBy(retrievedGame).Where(x => x.Enabled && x.Banned == false).ToList();
                        Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];
                        Console.WriteLine($"{DateTime.Now} - {retrievedGame.House}/{credential?.Username}");
                        if (credential != null) {
                            retrievedGame.Lock();
                            switch (retrievedGame.Name) {
                                case "FireKirin":
                                    if (P4NTH30N.C0MMON.Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 30) == false) {
                                        throw new Exception("Took too long to load.");
                                    }
                                    bool loggedIn = false;
                                    while (loggedIn == false) {
                                        loggedIn = driver.Login(credential.Username, credential.Password);
                                    }

                                    Color HallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                                    while (HallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false) {
                                        //Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {HallScreen}");
                                        Thread.Sleep(500);
                                        HallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                                    }
                                    Mouse.Click(81, 233);
                                    Thread.Sleep(800);
                                    for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++) {
                                        Mouse.Click(937, 177);
                                        Thread.Sleep(800);
                                    }
                                    break;

                                case "OrionStars":
                                    if (OrionStars.Login(driver, credential.Username, credential.Password) == false) {
                                        break;
                                    }
                                    Mouse.Click(80, 218);
                                    for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++) {
                                        Mouse.Click(995, 375);
                                        Thread.Sleep(800);
                                    }
                                    break;
                                default:
                                    continue;
                            }

                            Mouse.Click(retrievedGame.Settings.Gold777.Button_X, retrievedGame.Settings.Gold777.Button_Y);

                            int checkAttempts = 0;
                            bool buttonVerified = false;
                            while (checkAttempts <= 20 && buttonVerified == false) {
                                Color splashScreen = Color.White;
                                switch (selectedPlatform) {
                                    case "FireKirin":
                                        splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(316, 434)); // Gold777
                                        buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 183));
                                        break;
                                    case "OrionStars":
                                        splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(314, 432)); // Gold777
                                        buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 194));
                                        break;
                                }
                                //Console.WriteLine($"({checkAttempts + 1}) - {retrievedGame.House} - {splashScreen}");
                                Thread.Sleep(500);
                                checkAttempts++;
                            }

                            switch (selectedPlatform) {
                                case "FireKirin":
                                    driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                                    P4NTH30N.C0MMON.Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));
                                    break;
                                case "OrionStars":
                                    driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                    P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                                    break;
                            }

                            Color secondHallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                            while (secondHallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false) {
                                //Console.WriteLine($"Waiting for Hall - {retrievedGame.House} - {secondHallScreen}");
                                Thread.Sleep(500);
                                secondHallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                            }

                            if (buttonVerified) {
                                retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
                                retrievedGame.Settings.Gold777.ButtonVerified = true;
                                retrievedGame.Save();
                            } else {
                                Keyboard.AltTab();
                                Console.WriteLine("Game not found at location in Settings..");
                                Console.Write("Press the ANY key. Then coords at mouse cursor.");
                                while (!Console.KeyAvailable) { Thread.Sleep(500); }
                                Point cursorPosition = new(); GetCursorPos(ref cursorPosition);
                                Point buttonPosition = new((int)Math.Round(cursorPosition.X / 10.0, MidpointRounding.AwayFromZero) * 10,
                                    (int)Math.Round(cursorPosition.Y / 10.0, MidpointRounding.AwayFromZero) * 10);
                                Console.WriteLine($" ({buttonPosition.X}, {buttonPosition.Y})");

                                Thread.Sleep(2000);
                                int x = retrievedGame.Settings.Gold777.Button_X,
                                    y = retrievedGame.Settings.Gold777.Button_Y,
                                    page = retrievedGame.Settings.Gold777.Page;

                                Console.Write($"(Original Page: {page}). Press ENTER or provide New Page: ");
                                if (int.TryParse(Console.ReadLine() ?? "", out int newPage) == false) newPage = page;
                                Console.WriteLine($"Recording the game located on page {newPage}.");

                                retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
                                retrievedGame.Settings.Gold777.Button_X = buttonPosition.X;
                                retrievedGame.Settings.Gold777.Button_Y = buttonPosition.Y;
                                retrievedGame.Settings.Gold777.ButtonVerified = true;
                                retrievedGame.Settings.Gold777.Page = newPage;
                                retrievedGame.Save();

                                int updatesMade = 1;
                                if (massUpdateGames) {
                                    foreach (Game unverifiedGame in unverifiedGames) {
                                        Game g = Game.Get(unverifiedGame.House, unverifiedGame.Name);
                                        if (g.Settings.Gold777.ButtonVerified == false) {
                                            Gold777_Settings s = g.Settings.Gold777;
                                            if (s.Page == page && Math.Abs(s.Button_X - x) < 100 && Math.Abs(s.Button_Y - y) < 100) {
                                                unverifiedGame.Settings.Gold777.Button_X = buttonPosition.X;
                                                unverifiedGame.Settings.Gold777.Button_Y = buttonPosition.Y;
                                                unverifiedGame.Settings.Gold777.Page = newPage;
                                                g.Settings.Gold777.Button_X = buttonPosition.X;
                                                g.Settings.Gold777.Button_Y = buttonPosition.Y;
                                                g.Settings.Gold777.Page = newPage;
                                                updatesMade++;
                                                g.Save();
                                            }
                                        }
                                    }
                                }

                                Console.WriteLine($"{updatesMade} updates made.");
                                Keyboard.AltTab();
                            }

                            // driver.SwitchTo().Window(originalWindowHandle);
                            switch (selectedPlatform) {
                                case "FireKirin":
                                    // for (int i = 0; i < retrievedGame.Settings.Gold777.Page; i++) {
                                    //     Mouse.Click(880, 177); Thread.Sleep(800);
                                    // }
                                    Mouse.Click(81, 233);
                                    Thread.Sleep(800);
                                    FireKirin.Logout();
                                    break;
                                case "OrionStars":
                                    Mouse.Click(80, 218);
                                    Thread.Sleep(800);
                                    OrionStars.Logout(driver);
                                    break;
                            }
                        }
                        Console.WriteLine();
                    }
                }
            } catch { } finally {
                driver.Quit();
            }
        }
    }

    [DllImport("user32.dll")]
    static extern bool GetCursorPos(ref Point lpPoint);
}

