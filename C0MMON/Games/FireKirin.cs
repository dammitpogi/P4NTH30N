using System;
using System.Drawing;
using System.IO;
using System.Net.Http;
using System.Net.WebSockets;
using System.Text;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static class FireKirin {
    public sealed record BalanceSnapshot(
        decimal Balance,
        decimal Grand,
        decimal Major,
        decimal Minor,
        decimal Mini
    );

    public static Signal? SpinSlots(ChromeDriver driver, Game game, Signal signal) {
        Signal? overrideSignal = null;
        bool FortunePiggyLoaded = Games.FortunePiggy.LoadSucessfully(driver, game, signal);
        bool Gold777Loaded = FortunePiggyLoaded ? false : Games.Gold777.LoadSucessfully(driver, game, signal);

        if (FortunePiggyLoaded) {
            overrideSignal = Games.FortunePiggy.Spin(driver, game, signal);
        } else if (Gold777Loaded) { overrideSignal = Games.Gold777.Spin(driver, game, signal); }

        driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
        P4NTH30N.C0MMON.Screen.WaitForColor(new Point(925, 120), Color.FromArgb(255, 255, 251, 48));
        Thread.Sleep(2000); Mouse.Click(80, 235); Thread.Sleep(800);
        return overrideSignal;
    }

    public static void Logout() {
        Mouse.Click(996, 184); Thread.Sleep(2400);
        Mouse.Click(858, 548); Thread.Sleep(3200);
        Mouse.Click(533, 500);
    }

    public static bool Login(ChromeDriver driver, string username, string password) {
        try {
            int iterations = 0;
            while (true) {
                // Console.WriteLine("LoginIteration: " + iterations);
                if (iterations++.Equals(10))
                    throw new Exception(
                        $"[{username}] Credential retries limit exceeded. Skipping this Credential."
                    );

                Mouse.Click(470, 310);
                Thread.Sleep(400);
                Keyboard.Send(username);
                Mouse.Click(470, 380);
                Thread.Sleep(400);
                Keyboard.Send(password).Wait(400).Enter();
                bool NotReloaded = true,
                    Loaded = false;

                int loadingIterations = 0;
                while (Loaded == false && NotReloaded) {
                    Thread.Sleep(200);

                    bool HomeScreenLoaded = Screen
                        .GetColorAt(new Point(925, 120))
                        .Equals(Color.FromArgb(255, 255, 251, 48));
                    bool MessageBoxPopped = Screen
                        .GetColorAt(new Point(937, 177))
                        .Equals(Color.FromArgb(255, 228, 227, 70));
                    Loaded = HomeScreenLoaded || MessageBoxPopped;

                    loadingIterations++;
                    if (loadingIterations > 300) {
                        throw new Exception("Login took too long.");
                    }

                    if (
                        Screen
                            .GetColorAt(new Point(535, 403))
                            .Equals(Color.FromArgb(255, 121, 125, 47))
                    ) {
                        driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
                        Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51));
                        NotReloaded = false;
                        break;
                    }

                    if (Loaded) {
                        for (int i = 0; i < 14; i++) {
                            if (
                                Screen
                                    .GetColorAt(new Point(937, 177))
                                    .Equals(Color.FromArgb(255, 228, 227, 70))
                            ) {
                                Mouse.Click(937, 177);
                                break;
                            } else
                                Thread.Sleep(200);
                        }
                    }
                }
                if (NotReloaded)
                    break;
            }
            return true;
        } catch (Exception ex) {
            Console.WriteLine($"Exception on Login: {ex.Message}");
            return false;
        }
    }

    /// <summary>
    /// Queries the FireKirin server for balance and jackpot values using username/password credentials.
    /// Intent: bypass DOM scraping by issuing the same websocket commands used by the web client.
    /// Edge cases: if the config path or websocket protocol changes, callers can override baseUrl/configSuffix.
    /// </summary>
    public static async Task<BalanceSnapshot> FetchBalanceSnapshotAsync(
        string username,
        string password,
        string baseUrl = "http://play.firekirin.in/web_mobile/firekirin/",
        string configSuffix = "",
        CancellationToken cancellationToken = default
    ) {
        using HttpClient httpClient = new();
        Uri baseUri = new(baseUrl, UriKind.Absolute);
        Uri basePathUri = new(baseUri, "../");
        string configPath = $"plat/config/hall/orionstars{configSuffix}/config.json";
        Uri configUri = new(basePathUri, configPath);

        using HttpResponseMessage configResponse = await httpClient
            .GetAsync(configUri, cancellationToken)
            .ConfigureAwait(false);
        configResponse.EnsureSuccessStatusCode();

        using Stream configStream = await configResponse.Content
            .ReadAsStreamAsync(cancellationToken)
            .ConfigureAwait(false);
        using JsonDocument configDoc = await JsonDocument
            .ParseAsync(configStream, cancellationToken: cancellationToken)
            .ConfigureAwait(false);
        JsonElement configRoot = configDoc.RootElement;

        string bsIp = GetRequiredString(configRoot, "bsIp");
        int wsPort = GetRequiredInt(configRoot, "wsPort");
        string gameProtocol = GetStringOrDefault(configRoot, "gameProtocol", "ws://");
        string wsProtocol = GetStringOrDefault(configRoot, "wsProtocol", "wl");
        string version = GetStringOrDefault(configRoot, "version", "2.0.1");

        Uri wsUri = new($"{gameProtocol}{bsIp}:{wsPort}");
        using ClientWebSocket socket = new();
        socket.Options.AddSubProtocol(wsProtocol);
        await socket.ConnectAsync(wsUri, cancellationToken).ConfigureAwait(false);

        JsonDocument loginResponse = await SendAndWaitAsync(
            socket,
            new {
                mainID = 100,
                subID = 6,
                account = username,
                password,
                version
            },
            message => message.mainID == 100 && message.subID == 116,
            cancellationToken
        ).ConfigureAwait(false);

        JsonElement loginData = loginResponse.RootElement.GetProperty("data");
        int loginResult = GetRequiredInt(loginData, "result");
        if (loginResult != 0) {
            string message = GetStringOrDefault(loginData, "msg", "Login failed.");
            throw new InvalidOperationException($"FireKirin login failed: {message}");
        }

        decimal score = GetDecimal(loginData, "score");
        decimal winScore = GetDecimal(loginData, "winscore");
        decimal balance = score + winScore;
        int bossId = GetRequiredInt(loginData, "bossid");

        JsonDocument jpResponse = await SendAndWaitAsync(
            socket,
            new {
                mainID = 100,
                subID = 10,
                bossid = bossId
            },
            message => message.mainID == 100 && message.subID == 120,
            cancellationToken
        ).ConfigureAwait(false);

        JsonElement jpData = jpResponse.RootElement.GetProperty("data");
        decimal grand = GetDecimal(jpData, "grand");
        decimal major = GetDecimal(jpData, "major");
        decimal minor = GetDecimal(jpData, "minor");
        decimal mini = GetDecimal(jpData, "mini");

        return new BalanceSnapshot(balance, grand, major, minor, mini);
    }

    private static async Task<JsonDocument> SendAndWaitAsync(
        ClientWebSocket socket,
        object payload,
        Func<(int mainID, int subID), bool> predicate,
        CancellationToken cancellationToken
    ) {
        string payloadJson = JsonSerializer.Serialize(payload);
        ArraySegment<byte> buffer = new(Encoding.UTF8.GetBytes(payloadJson));
        await socket.SendAsync(buffer, WebSocketMessageType.Text, true, cancellationToken)
            .ConfigureAwait(false);

        while (true) {
            JsonDocument message = await ReceiveJsonAsync(socket, cancellationToken)
                .ConfigureAwait(false);
            JsonElement root = message.RootElement;
            int mainID = root.GetProperty("mainID").GetInt32();
            int subID = root.GetProperty("subID").GetInt32();
            if (predicate((mainID, subID))) {
                return message;
            }
            message.Dispose();
        }
    }

    private static async Task<JsonDocument> ReceiveJsonAsync(
        ClientWebSocket socket,
        CancellationToken cancellationToken
    ) {
        byte[] buffer = new byte[8192];
        using MemoryStream stream = new();
        WebSocketReceiveResult result;
        do {
            result = await socket.ReceiveAsync(buffer, cancellationToken)
                .ConfigureAwait(false);
            if (result.MessageType == WebSocketMessageType.Close) {
                throw new InvalidOperationException("FireKirin websocket closed unexpectedly.");
            }
            stream.Write(buffer, 0, result.Count);
        } while (!result.EndOfMessage);

        stream.Position = 0;
        return await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken)
            .ConfigureAwait(false);
    }

    private static string GetRequiredString(JsonElement element, string propertyName) {
        if (!element.TryGetProperty(propertyName, out JsonElement value) || value.ValueKind != JsonValueKind.String) {
            throw new InvalidOperationException($"Missing required config value: {propertyName}");
        }
        return value.GetString() ?? string.Empty;
    }

    private static string GetStringOrDefault(JsonElement element, string propertyName, string fallback) {
        if (!element.TryGetProperty(propertyName, out JsonElement value) || value.ValueKind != JsonValueKind.String) {
            return fallback;
        }
        return value.GetString() ?? fallback;
    }

    private static int GetRequiredInt(JsonElement element, string propertyName) {
        if (!element.TryGetProperty(propertyName, out JsonElement value) || !value.TryGetInt32(out int result)) {
            throw new InvalidOperationException($"Missing required value: {propertyName}");
        }
        return result;
    }

    private static decimal GetDecimal(JsonElement element, string propertyName) {
        if (!element.TryGetProperty(propertyName, out JsonElement value)) {
            return 0m;
        }
        if (value.ValueKind == JsonValueKind.Number && value.TryGetDecimal(out decimal numeric)) {
            return numeric;
        }
        if (value.ValueKind == JsonValueKind.Number && value.TryGetInt64(out long integer)) {
            return integer;
        }
        return 0m;
    }
}
