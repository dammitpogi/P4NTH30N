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
    private const string FireKirinBaseUrl = "http://play.firekirin.in/web_mobile/firekirin/";
    private const string FireKirinPlatform = "orionstars";

    public sealed record FireKirinAccountSnapshot(
        decimal Balance,
        decimal Grand,
        decimal Major,
        decimal Minor,
        decimal Mini
    );

    public static async Task<FireKirinAccountSnapshot> FetchAccountSnapshotAsync(
        string username,
        string password,
        CancellationToken cancellationToken = default
    ) {
        // Intent: pull live balance + jackpots directly from FireKirin's server without UI automation.
        // Edge case: if the server never returns both balance + jackpot values, we time out to avoid hangs.
        if (string.IsNullOrWhiteSpace(username)) {
            throw new ArgumentException("Username is required.", nameof(username));
        }

        if (string.IsNullOrWhiteSpace(password)) {
            throw new ArgumentException("Password is required.", nameof(password));
        }

        using HttpClient httpClient = new();
        FireKirinWebSocketConfig config = await GetWebSocketConfigAsync(httpClient, cancellationToken);
        using ClientWebSocket socket = new();

        if (!string.IsNullOrWhiteSpace(config.WebSocketProtocol)) {
            socket.Options.AddSubProtocol(config.WebSocketProtocol);
        }

        await socket.ConnectAsync(config.WebSocketUrl, cancellationToken);

        try {
            await SendWebSocketMessageAsync(
                socket,
                new {
                    account = username,
                    password,
                    version = config.Version,
                    mainID = 100,
                    subID = 6
                },
                cancellationToken
            );

            decimal? balance = null;
            decimal? grand = null;
            decimal? major = null;
            decimal? minor = null;
            decimal? mini = null;
            long? userId = null;
            long? bossId = null;

            DateTimeOffset timeoutAt = DateTimeOffset.UtcNow.AddSeconds(20);

            while (DateTimeOffset.UtcNow < timeoutAt && socket.State == WebSocketState.Open) {
                string? message = await ReceiveWebSocketMessageAsync(socket, cancellationToken);
                if (string.IsNullOrWhiteSpace(message)) {
                    continue;
                }

                using JsonDocument payload = JsonDocument.Parse(message);
                JsonElement root = payload.RootElement;

                if (!root.TryGetProperty("mainID", out JsonElement mainIdElement) ||
                    !root.TryGetProperty("subID", out JsonElement subIdElement)) {
                    continue;
                }

                int mainId = mainIdElement.GetInt32();
                int subId = subIdElement.GetInt32();

                if (mainId != 100 || !root.TryGetProperty("data", out JsonElement dataElement)) {
                    continue;
                }

                switch (subId) {
                    case 116: {
                        if (dataElement.TryGetProperty("result", out JsonElement resultElement) &&
                            resultElement.GetInt32() != 0) {
                            string messageText = dataElement.TryGetProperty("msg", out JsonElement msgElement)
                                ? msgElement.GetString() ?? "Login failed."
                                : "Login failed.";
                            throw new InvalidOperationException(messageText);
                        }

                        if (dataElement.TryGetProperty("userid", out JsonElement userElement)) {
                            userId = userElement.GetInt64();
                        }

                        if (dataElement.TryGetProperty("bossid", out JsonElement bossElement)) {
                            bossId = bossElement.GetInt64();
                        }

                        if (TryGetBalance(dataElement, out decimal balanceValue)) {
                            balance = balanceValue;
                        }

                        if (userId.HasValue) {
                            await SendWebSocketMessageAsync(
                                socket,
                                new {
                                    userid = userId.Value,
                                    password,
                                    mainID = 100,
                                    subID = 26
                                },
                                cancellationToken
                            );
                        }

                        if (bossId.HasValue) {
                            await SendWebSocketMessageAsync(
                                socket,
                                new {
                                    bossid = bossId.Value,
                                    mainID = 100,
                                    subID = 10
                                },
                                cancellationToken
                            );
                        }

                        break;
                    }
                    case 142: {
                        if (dataElement.TryGetProperty("result", out JsonElement resultElement) &&
                            resultElement.GetInt32() == 0 &&
                            TryGetBalance(dataElement, out decimal balanceValue)) {
                            balance = balanceValue;
                        }

                        break;
                    }
                    case 120: {
                        grand = GetDecimalProperty(dataElement, "grand");
                        major = GetDecimalProperty(dataElement, "major");
                        minor = GetDecimalProperty(dataElement, "minor");
                        mini = GetDecimalProperty(dataElement, "mini");
                        break;
                    }
                }

                if (balance.HasValue && grand.HasValue && major.HasValue && minor.HasValue && mini.HasValue) {
                    return new FireKirinAccountSnapshot(
                        balance.Value,
                        grand.Value,
                        major.Value,
                        minor.Value,
                        mini.Value
                    );
                }
            }

            throw new TimeoutException("Timed out waiting for balance and jackpot values.");
        } finally {
            if (socket.State == WebSocketState.Open || socket.State == WebSocketState.CloseReceived) {
                await socket.CloseAsync(
                    WebSocketCloseStatus.NormalClosure,
                    "Account snapshot complete.",
                    CancellationToken.None
                );
            }
        }
    }

    private static async Task<FireKirinWebSocketConfig> GetWebSocketConfigAsync(
        HttpClient httpClient,
        CancellationToken cancellationToken
    ) {
        string basePath = FireKirinBaseUrl.TrimEnd('/');
        string configUrl =
            $"{basePath}/plat/config/hall/{FireKirinPlatform}/config.json?={DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()}";

        using HttpResponseMessage response = await httpClient.GetAsync(configUrl, cancellationToken);
        response.EnsureSuccessStatusCode();
        string payload = await response.Content.ReadAsStringAsync(cancellationToken);
        using JsonDocument document = JsonDocument.Parse(payload);

        JsonElement root = document.RootElement;
        string? bsIp = root.TryGetProperty("bsIp", out JsonElement bsIpElement)
            ? bsIpElement.GetString()
            : null;
        int wsPort = root.TryGetProperty("wsPort", out JsonElement wsPortElement)
            ? wsPortElement.GetInt32()
            : 0;
        string gameProtocol = root.TryGetProperty("gameProtocol", out JsonElement protocolElement)
            ? protocolElement.GetString() ?? "ws://"
            : "ws://";
        string wsProtocol = root.TryGetProperty("wsProtocol", out JsonElement wsProtocolElement)
            ? wsProtocolElement.GetString() ?? "wl"
            : "wl";
        string version = root.TryGetProperty("version", out JsonElement versionElement)
            ? versionElement.GetString() ?? "2.0.1"
            : "2.0.1";

        if (string.IsNullOrWhiteSpace(bsIp) || wsPort == 0) {
            throw new InvalidOperationException("Missing WebSocket configuration data.");
        }

        Uri wsUrl = new($"{gameProtocol}{bsIp}:{wsPort}");
        return new FireKirinWebSocketConfig(wsUrl, wsProtocol, version);
    }

    private static async Task SendWebSocketMessageAsync(
        ClientWebSocket socket,
        object payload,
        CancellationToken cancellationToken
    ) {
        string json = JsonSerializer.Serialize(payload);
        byte[] bytes = Encoding.UTF8.GetBytes(json);
        await socket.SendAsync(
            new ArraySegment<byte>(bytes),
            WebSocketMessageType.Text,
            true,
            cancellationToken
        );
    }

    private static async Task<string?> ReceiveWebSocketMessageAsync(
        ClientWebSocket socket,
        CancellationToken cancellationToken
    ) {
        byte[] buffer = new byte[8192];
        using MemoryStream stream = new();
        WebSocketReceiveResult? result = null;

        do {
            result = await socket.ReceiveAsync(buffer, cancellationToken);
            if (result.MessageType == WebSocketMessageType.Close) {
                return null;
            }

            stream.Write(buffer, 0, result.Count);
        } while (!result.EndOfMessage);

        return Encoding.UTF8.GetString(stream.ToArray());
    }

    private static bool TryGetBalance(JsonElement dataElement, out decimal balance) {
        balance = 0;
        if (!dataElement.TryGetProperty("score", out JsonElement scoreElement) ||
            !dataElement.TryGetProperty("winscore", out JsonElement winScoreElement)) {
            return false;
        }

        balance = GetDecimal(scoreElement) + GetDecimal(winScoreElement);
        return true;
    }

    private static decimal GetDecimalProperty(JsonElement parent, string propertyName) {
        return parent.TryGetProperty(propertyName, out JsonElement valueElement)
            ? GetDecimal(valueElement)
            : 0;
    }

    private static decimal GetDecimal(JsonElement element) {
        return element.ValueKind switch {
            JsonValueKind.Number => element.GetDecimal(),
            JsonValueKind.String when decimal.TryParse(element.GetString(), out decimal value) => value,
            _ => 0
        };
    }

    private sealed record FireKirinWebSocketConfig(Uri WebSocketUrl, string WebSocketProtocol, string Version);

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
}
