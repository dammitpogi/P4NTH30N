using OpenQA.Selenium.Chrome;
using P4NTH30N.C0MMON;
using P4NTH30N;
using Figgle;
using System.Drawing;
using System.Runtime.InteropServices;
using OpenQA.Selenium.BiDi.Input;

namespace P4NTH30N
{
    [GenerateFiggleText(sourceText: "v    0 . 0 . 8", memberName: "Version", fontName: "colossal")]
    internal static partial class Header { }
}

public class ColorCombination(Color origin)
{
    public int Occurences { get; set; } = 0;
    public Color Origin { get; set; } = origin;

}

public class Program
{
    public static void Main(string[] args)
    {
        bool checkLockedGames = true, massUpdateGames = false;
        string selectedPlatform = string.Empty, selectedGame = string.Empty,
            errorString = string.Empty, checkLockedSelection = string.Empty,
            massUpdateSelection = string.Empty;

        Console.WriteLine(Header.Version);
        while (selectedPlatform.Equals(string.Empty))
        {
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
            if (selectedPlatform.Equals(string.Empty))
            {
                errorString = $"Invalid Option Chosen. {platformInput}";
                Console.Clear();
                continue;
            }
            Console.WriteLine($"{selectedPlatform}\n");
        }

        while (selectedGame.Equals(string.Empty))
        {
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
            if (selectedGame.Equals(string.Empty))
            {
                errorString = $"Invalid Option Chosen. ({gameInput})";
                Console.Clear();
                continue;
            }
            Console.WriteLine($"{selectedGame}\n");
        }

        while (checkLockedSelection.Equals(string.Empty))
        {
            Console.WriteLine("--- Respect Locked Games ---");
            Console.WriteLine("1. Yes\n2. No");
            Console.WriteLine($"{errorString}");
            Console.Write("Skip Locked Games: ");

            string checkLockedInput = Console.ReadKey(true).KeyChar.ToString();
            if (int.TryParse(checkLockedInput, out int checkLockedChoice))
                if (new int[] { 1, 2 }.Contains(checkLockedChoice))
                    checkLockedSelection = checkLockedChoice.Equals(1) ? "False" : "True";

            errorString = string.Empty;
            if (checkLockedSelection.Equals(string.Empty))
            {
                errorString = $"Invalid Option Chosen. {checkLockedInput}";
                Console.Clear();
                continue;
            }
            else
            {
                _ = bool.TryParse(checkLockedSelection, out checkLockedGames);
            }
            Console.WriteLine($"{(checkLockedGames ? "No" : "Yes")}\n");
        }

        while (massUpdateSelection.Equals(string.Empty))
        {
            Console.WriteLine("--- Update Similar Games ---");
            Console.WriteLine("1. Yes\n2. No");
            Console.WriteLine($"{errorString}");
            Console.Write("Propagate Updates: ");

            string massUpdateInput = Console.ReadKey(true).KeyChar.ToString();
            if (int.TryParse(massUpdateInput, out int massUpdateChoice))
                if (new int[] { 1, 2 }.Contains(massUpdateChoice))
                    massUpdateSelection = massUpdateChoice.Equals(1) ? "True" : "False";

            errorString = string.Empty;
            if (massUpdateSelection.Equals(string.Empty))
            {
                errorString = $"Invalid Option Chosen. {massUpdateInput}";
                Console.Clear();
                continue;
            }
            else
            {
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

        while (true)
        {
            ChromeDriver driver = new(service, options);
            string originalWindowHandle = driver.CurrentWindowHandle;
            Size windowSize = driver.Manage().Window.Size;
            Mouse.Click(1024, 121);
            try
            {
                switch (selectedPlatform)
                {
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

                foreach (Game game in unverifiedGames)
                {
                    // if (game.House != "") continue; 
                    //Console.WriteLine($"{DateTime.UtcNow} - Retrieving Game");
                    Game retrievedGame = Game.Get(game.House, game.Name);
                    // retrievedGame = Game.Get("Playing Bar", "FireKirin");
                    // retrievedGame.Settings.Gold777.ButtonVerified = false;

                    if (retrievedGame.Settings.Gold777.ButtonVerified == false && (checkLockedGames || retrievedGame.Unlocked))
                    {
                        //Console.WriteLine($"{DateTime.UtcNow} - Retrieving Credential");
                        List<Credential> gameCredentials = Credential.GetBy(retrievedGame).Where(x => x.Enabled && x.Banned == false).ToList();
                        Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];
                        Console.WriteLine($"{DateTime.Now} - {retrievedGame.House}/{credential?.Username}");
                        if (credential != null)
                        {
                            retrievedGame.Lock();
                            switch (retrievedGame.Name)
                            {
                                case "FireKirin":
                                    if (P4NTH30N.C0MMON.Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 30) == false)
                                    {
                                        throw new Exception("Took too long to load.");
                                    }
                                    bool loggedIn = false;
                                    while (loggedIn == false)
                                    {
                                        loggedIn = driver.Login(credential.Username, credential.Password);
                                    }

                                    Color HallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                                    while (HallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false)
                                    {
                                        //Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {HallScreen}");
                                        Thread.Sleep(500);
                                        HallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                                    }
                                    Mouse.Click(81, 233);
                                    Thread.Sleep(800);
                                    for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++)
                                    {
                                        Mouse.Click(937, 177);
                                        Thread.Sleep(800);
                                    }
                                    break;

                                case "OrionStars":
                                    if (OrionStars.Login(driver, credential.Username, credential.Password) == false)
                                    {
                                        break;
                                    }
                                    Mouse.Click(80, 218);
                                    for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++)
                                    {
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
                            while (checkAttempts <= 20 && buttonVerified == false)
                            {
                                Color splashScreen = Color.White;
                                switch (selectedPlatform)
                                {
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

                            switch (selectedPlatform)
                            {
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
                            while (secondHallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false)
                            {
                                //Console.WriteLine($"Waiting for Hall - {retrievedGame.House} - {secondHallScreen}");
                                Thread.Sleep(500);
                                secondHallScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(293, 179));
                            }

                            if (buttonVerified)
                            {
                                Thread.Sleep(TimeSpan.FromSeconds(5));
                                int x = retrievedGame.Settings.Gold777.Button_X;
                                int y = retrievedGame.Settings.Gold777.Button_Y;

                                ColorCombination[] History = [];

                                Console.WriteLine("Creating a history of button color combinations.");
                                Console.Write("Press the ANY key to complete collection and generate results.");
                                while (!Console.KeyAvailable)
                                {
                                    originColor = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(x, y));

                                    History.Add(new ColorCombination(
                                        originColor
                                    ));                                  
                                    Thread.Sleep(200);
                                }

                            }
                            else
                            {
                                Console.WriteLine($"{DateTime.Now} - Game was not found. Beginning Search.");

                                Thread.Sleep(TimeSpan.FromSeconds(5));
                                if (System.Windows.Forms.Screen.PrimaryScreen != null)
                                {
                                    int screenHeight = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height;
                                    int screenWidth = System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width;
                                    int searchAttempts = 30, x = 110, y = 220, second_x = 0, second_y = 0;
                                    bool foundPixels = false, checkOne = false, checkTwo = false;
                                    Bitmap screenshot = new(screenWidth, screenHeight);
                                    List<string> foundPossibilities = [];
                                    Point possibleButton = new(0, 0);

                                    // driver.Manage().Window.Minimize();
                                    foreach (int pageModifier in new int[] { 0, -1, 1 })
                                    {
                                        int workingPage = retrievedGame.Settings.Gold777.Page + pageModifier;
                                        if (pageModifier.Equals(0) == false)
                                        {
                                            Mouse.Click(81, 233); Thread.Sleep(800);
                                            for (int i = 1; i < workingPage; i++)
                                            {
                                                Mouse.Click(937, 177); Thread.Sleep(800);
                                            }
                                        }
                                        Thread.Sleep(3000);
                                        using (Bitmap bitmap = new(screenWidth, screenHeight))
                                        {
                                            using (Graphics graphics = Graphics.FromImage(bitmap))
                                            {
                                                graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);
                                                screenshot.Dispose(); screenshot = (Bitmap)bitmap.Clone();
                                            }
                                        }

                                        while (buttonVerified == false && searchAttempts > 0)
                                        {
                                            Color[] possibleOrigins = [Color.FromArgb(116, 73, 64)];

                                            Color originColor = screenshot.GetPixel(x, y);
                                            if (possibleOrigins.Contains(originColor))
                                            {
                                                second_x = x + 85; second_y = y + 35;
                                                Color colorOne = screenshot.GetPixel(x, second_y);
                                                Color colorTwo = screenshot.GetPixel(second_x, y);

                                                checkOne = new Color[] {
                                                Color.FromArgb(144, 16, 31), Color.FromArgb(176, 21, 41), Color.FromArgb(161, 19, 36) }.Contains(colorOne);

                                                checkTwo = second_x >= 1270 || new Color[] {
                                                Color.FromArgb(176, 128, 116), Color.FromArgb(10, 14, 19), Color.FromArgb(66, 61, 52) }.Contains(colorTwo);

                                                // checkOne = new Color[] { Color.FromArgb(144, 16, 31), Color.FromArgb(176, 21, 41),
                                                //     Color.FromArgb(161, 19, 36), Color.FromArgb(110, 14, 80), Color.FromArgb(86, 71, 60),
                                                //     Color.FromArgb(80, 53, 58), Color.FromArgb(136, 76, 62), Color.FromArgb(55, 23, 12) }.Contains(colorOne);

                                                // checkTwo = second_x >= 1270 || new Color[] {
                                                //     Color.FromArgb(176, 128, 116), Color.FromArgb(10, 14, 19), Color.FromArgb(66, 61, 52),
                                                //     Color.FromArgb(230, 211, 67), Color.FromArgb(230, 225, 176), Color.FromArgb(229, 221, 174),
                                                //     Color.FromArgb(221, 192, 146), Color.FromArgb(3, 112, 49) }.Contains(colorTwo);

                                                foundPossibilities.Add($"Page: {workingPage} - Coords: {x},{y} - Origin: {originColor.R},{originColor.G},{originColor.B} One: {colorOne.R},{colorOne.G},{colorOne.B}, Two: {colorTwo.R},{colorTwo.G},{colorTwo.B}");

                                                if (checkOne || checkTwo)
                                                {
                                                    int check_x = second_x + 40 < 1279 ? second_x + 40 : second_x;
                                                    possibleButton = new Point(check_x, y);
                                                    foundPixels = true;
                                                }
                                            }

                                            if (foundPixels)
                                            {
                                                checkAttempts = 0;

                                                // Mouse.Click(815, 695); Thread.Sleep(2000);
                                                // P4NTH30N.C0MMON.Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));

                                                Console.Write($"{DateTime.Now} - Clicking through at ({possibleButton.X},{possibleButton.Y}). ");
                                                Mouse.Click(possibleButton.X, possibleButton.Y);
                                                while (checkAttempts <= 20 && buttonVerified == false)
                                                {
                                                    Color splashScreen = Color.White;
                                                    switch (selectedPlatform)
                                                    {
                                                        case "FireKirin":
                                                            splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(316, 434)); // Gold777
                                                            buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 183));
                                                            break;
                                                        case "OrionStars":
                                                            splashScreen = P4NTH30N.C0MMON.Screen.GetColorAt(new Point(314, 432)); // Gold777
                                                            buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 194));
                                                            break;
                                                    }
                                                    // Console.WriteLine($"{checkAttempts + 1} {retrievedGame.House} - {splashScreen}");
                                                    Thread.Sleep(500);
                                                    checkAttempts++;
                                                }

                                                switch (selectedPlatform)
                                                {
                                                    case "FireKirin":
                                                        driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                                                        Console.WriteLine("Returning to Menu");
                                                        P4NTH30N.C0MMON.Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));
                                                        break;
                                                    case "OrionStars":
                                                        driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
                                                        P4NTH30N.C0MMON.Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
                                                        break;
                                                }
                                                if (buttonVerified == false)
                                                {
                                                    foundPixels = false;
                                                    Console.WriteLine("But it wasn't the right one.");
                                                }
                                                else Console.WriteLine("And the correct game loaded.");
                                            }
                                            x++;
                                            if (x >= 1040)
                                            {
                                                // Console.WriteLine($"Checking pixels at y-level: {y}");
                                                x = 120;
                                                y++;
                                            }
                                            if (y >= 530)
                                            {
                                                // Mouse.Click(815, 695); Thread.Sleep(4000);
                                                x = 110; y = 220;
                                                searchAttempts--;
                                                if (searchAttempts > 0)
                                                {
                                                    Thread.Sleep(500);
                                                    using (Bitmap bitmap = new(screenWidth, screenHeight))
                                                    {
                                                        using (Graphics graphics = Graphics.FromImage(bitmap))
                                                        {
                                                            graphics.CopyFromScreen(0, 0, 0, 0, bitmap.Size);
                                                            screenshot.Dispose(); screenshot = (Bitmap)bitmap.Clone();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        if (buttonVerified) break;
                                        searchAttempts = 5;
                                    }
                                    screenshot.Dispose();
                                    foundPossibilities.Order().ToList().ForEach(Console.WriteLine);

                                    if (buttonVerified)
                                    {
                                        retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
                                        retrievedGame.Settings.Gold777.Button_X = possibleButton.X;
                                        retrievedGame.Settings.Gold777.Button_Y = possibleButton.Y;
                                        retrievedGame.Settings.Gold777.ButtonVerified = true;
                                        retrievedGame.Save();
                                    }
                                }

                                switch (selectedPlatform)
                                {
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
                }
            }
            catch { }
            finally
            {
                driver.Quit();
            }
        }
    }
}

