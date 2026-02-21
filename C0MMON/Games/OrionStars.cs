using System;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Net.Http;
using System.Net.WebSockets;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;

namespace P4NTH30N.C0MMON;

public static class OrionStars
{
	public sealed record OrionStarsBalances(decimal Balance, decimal Grand, decimal Major, decimal Minor, decimal Mini);

	private sealed record OrionStarsNetConfig(string BsIp, int WsPort, string WsProtocol, string GameProtocol, string Version);

	// DECISION_073: Config cache to survive transient HTTP failures
	private static OrionStarsNetConfig? s_cachedConfig;
	private static DateTime s_configCachedAt = DateTime.MinValue;
	private static readonly TimeSpan s_configCacheTtl = TimeSpan.FromMinutes(10);

	public static void Logout(ChromeDriver driver)
	{
		bool loggedOut = false;
		int iterations = 6;
		while (loggedOut == false)
		{
			Thread.Sleep(3000);
			Mouse.Click(975, 630);
			Thread.Sleep(2000);
			Screen.WaitForColor(new Point(533, 550), Color.FromArgb(255, 228, 228, 228), 5);
			Mouse.Click(535, 555);
			Thread.Sleep(2000);
			loggedOut = Screen.WaitForColor(new Point(850, 210), Color.FromArgb(255, 229, 148, 29), 5);
			if (iterations-- < 0)
			{
				driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
				iterations = 6;
				Thread.Sleep(3000);
			}
		}
	}

	public static bool Login(ChromeDriver driver, string username, string password)
	{
		try
		{
			Screen.WaitForColor(new Point(850, 210), Color.FromArgb(255, 229, 148, 29));

			Mouse.Click(685, 345);
			Screen.WaitForColor(new Point(975, 490), Color.FromArgb(255, 216, 216, 216));
			Mouse.Click(865, 355);
			Thread.Sleep(800);
			Keyboard.Send(username).Enter();
			Mouse.Click(865, 325);

			Mouse.Click(685, 425);
			Screen.WaitForColor(new Point(975, 490), Color.FromArgb(255, 216, 216, 216));
			Mouse.Click(865, 355);
			Thread.Sleep(800);
			Keyboard.Send(password).Enter();
			Mouse.Click(865, 325);

			Thread.Sleep(400);
			Mouse.Click(535, 555);
			Thread.Sleep(400);

			int Iterations_LoginNotifications = 0;
			while (Iterations_LoginNotifications++ < 30)
			{
				Thread.Sleep(250);
				bool dialogBoxPopped = Screen.GetColorAt(new Point(525, 315)).Equals(Color.FromArgb(255, 0, 55, 135));
				bool messageBoxPopped = Screen.GetColorAt(new Point(525, 315)).Equals(Color.FromArgb(255, 0, 55, 135));
				if (dialogBoxPopped)
				{
					Thread.Sleep(400);
					Mouse.Click(515, 455);
				}
				if (messageBoxPopped)
				{
					Thread.Sleep(400);
					Mouse.Click(940, 185);
				}
				if (dialogBoxPopped && messageBoxPopped)
					break;
			}

			// if (Screen.GetColorAt(new Point(930, 187)).Equals(Color.FromArgb(255, 228, 161, 35))) Mouse.Click(940, 185);
			if (Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181), 15).Equals(false))
			{
				throw new Exception("Home Screen failed to load after 15 seconds.");
			}

			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Exception on Login: {ex.Message}");
			return false;
		}
	}

	public static OrionStarsBalances QueryBalances(string username, string password)
	{
		// DECISION_073: Retry with exponential backoff; return zeros after exhaustion
		const int maxAttempts = 3;
		Exception? lastEx = null;

		for (int attempt = 0; attempt < maxAttempts; attempt++)
		{
			if (attempt > 0)
				Thread.Sleep(500 * attempt); // 500ms, 1000ms

			try
			{
				return QueryBalancesCore(username, password);
			}
			catch (InvalidOperationException)
			{
				throw; // Don't retry auth failures (wrong password, suspended account)
			}
			catch (Exception ex)
			{
				lastEx = ex;
				Console.WriteLine($"[DECISION_073] OrionStars.QueryBalances attempt {attempt + 1}/{maxAttempts} failed for {username}: {ex.Message}");
			}
		}

		Console.WriteLine($"[DECISION_073][ERROR] OrionStars.QueryBalances exhausted retries for {username}: {lastEx?.Message} — returning zeros");
		return new OrionStarsBalances(0, 0, 0, 0, 0);
	}

	private static OrionStarsBalances QueryBalancesCore(string username, string password)
	{
		OrionStarsNetConfig config = FetchNetConfig();
		string wsUrl = $"{config.GameProtocol}{config.BsIp}:{config.WsPort}";
		using var ws = new ClientWebSocket();

		if (!string.IsNullOrWhiteSpace(config.WsProtocol))
		{
			ws.Options.AddSubProtocol(config.WsProtocol);
		}

		using var connectCts = new CancellationTokenSource(TimeSpan.FromSeconds(10));
		ws.ConnectAsync(new Uri(wsUrl), connectCts.Token).GetAwaiter().GetResult();

		string md5Password = ComputeMd5Hex(password);
		SendJson(
			ws,
			new
			{
				mainID = 100,
				subID = 6,
				account = username,
				password = md5Password,
				version = config.Version,
			},
			TimeSpan.FromSeconds(10)
		);

		int bossId = 0;
		decimal balance = 0;
		WaitForMessage(
			ws,
			100,
			116,
			TimeSpan.FromSeconds(10),
			data =>
			{
				int result = GetInt32(data, "result");
				if (result != 0)
				{
					string message = GetString(data, "msg") ?? "Login failed.";
					throw new InvalidOperationException(message);
				}

				bossId = GetInt32(data, "bossid");
				balance = GetDecimal(data, "score") / 100;
			}
		);

		SendJson(
			ws,
			new
			{
				mainID = 100,
				subID = 10,
				bossid = bossId,
			},
			TimeSpan.FromSeconds(10)
		);

		decimal grand = 0;
		decimal major = 0;
		decimal minor = 0;
		decimal mini = 0;

		WaitForMessage(
			ws,
			100,
			120,
			TimeSpan.FromSeconds(10),
			data =>
			{
				grand = AdjustJackpot(GetDecimal(data, "grand") / 100);
				major = AdjustJackpot(GetDecimal(data, "major") / 100);
				minor = AdjustJackpot(GetDecimal(data, "minor") / 100);
				mini = AdjustJackpot(GetDecimal(data, "mini") / 100);
			}
		);

		try
		{
			if (ws.State == WebSocketState.Open || ws.State == WebSocketState.CloseReceived)
			{
				ws.CloseAsync(WebSocketCloseStatus.NormalClosure, "done", CancellationToken.None).GetAwaiter().GetResult();
			}
		}
		catch (WebSocketException)
		{
			// Ignore close handshake failures from server.
		}

		return new OrionStarsBalances(balance, grand, major, minor, mini);
	}

	private static decimal AdjustJackpot(decimal value)
	{
		return value > 2000 ? value / 100 : value;
	}

	private static OrionStarsNetConfig FetchNetConfig()
	{
		// DECISION_073: Serve from cache if fresh
		if (s_cachedConfig != null && (DateTime.UtcNow - s_configCachedAt) < s_configCacheTtl)
			return s_cachedConfig;

		const string configUrl = "http://web.orionstars.org/hot_play/plat/config/hall/orionstars/config.json";

		try
		{
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(10) };
			string json = http.GetStringAsync(configUrl).GetAwaiter().GetResult();
			using var doc = JsonDocument.Parse(json);
			JsonElement root = doc.RootElement;

			string bsIp = GetString(root, "bsIp") ?? string.Empty;
			int wsPort = GetInt32(root, "wsPort", 8600);
			string wsProtocol = GetString(root, "wsProtocol") ?? "wl";
			string gameProtocol = GetString(root, "gameProtocol") ?? "ws://";
			string version = GetString(root, "version") ?? "2.0.1";

			if (string.IsNullOrWhiteSpace(bsIp))
				throw new InvalidOperationException("Missing bsIp in OrionStars config.");

			s_cachedConfig = new OrionStarsNetConfig(bsIp, wsPort, wsProtocol, gameProtocol, version);
			s_configCachedAt = DateTime.UtcNow;
			return s_cachedConfig;
		}
		catch when (s_cachedConfig != null)
		{
			// DECISION_073: Use stale cache on fetch failure
			Console.WriteLine("[DECISION_073] OrionStars config fetch failed — using cached config");
			return s_cachedConfig;
		}
	}

	private static void SendJson(ClientWebSocket ws, object payload, TimeSpan timeout)
	{
		string json = JsonSerializer.Serialize(payload);
		byte[] bytes = Encoding.UTF8.GetBytes(json);

		using var sendCts = new CancellationTokenSource(timeout);
		ws.SendAsync(bytes, WebSocketMessageType.Text, true, sendCts.Token).GetAwaiter().GetResult();
	}

	private static void WaitForMessage(ClientWebSocket ws, int mainId, int subId, TimeSpan timeout, Action<JsonElement> onData)
	{
		DateTime deadline = DateTime.UtcNow.Add(timeout);

		while (DateTime.UtcNow <= deadline)
		{
			TimeSpan remaining = deadline - DateTime.UtcNow;
			if (remaining <= TimeSpan.Zero)
			{
				break;
			}

			string message = ReceiveText(ws, remaining);
			using var doc = JsonDocument.Parse(message);
			JsonElement root = doc.RootElement;

			if (GetInt32(root, "mainID") == mainId && GetInt32(root, "subID") == subId && root.TryGetProperty("data", out JsonElement data))
			{
				onData(data);
				return;
			}
		}

		throw new TimeoutException($"Timed out waiting for {mainId}/{subId}.");
	}

	private static string ReceiveText(ClientWebSocket ws, TimeSpan timeout)
	{
		using var receiveCts = new CancellationTokenSource(timeout);
		ArraySegment<byte> buffer = new(new byte[8192]);
		using var ms = new MemoryStream();

		while (true)
		{
			WebSocketReceiveResult result = ws.ReceiveAsync(buffer, receiveCts.Token).GetAwaiter().GetResult();

			if (result.MessageType == WebSocketMessageType.Close)
			{
				throw new WebSocketException("WebSocket closed while waiting for data.");
			}

			ms.Write(buffer.Array!, buffer.Offset, result.Count);
			if (result.EndOfMessage)
			{
				break;
			}
		}

		return Encoding.UTF8.GetString(ms.ToArray());
	}

	private static string ComputeMd5Hex(string input)
	{
		using var md5 = MD5.Create();
		byte[] hash = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
		var sb = new StringBuilder(hash.Length * 2);
		foreach (byte b in hash)
		{
			sb.Append(b.ToString("x2", CultureInfo.InvariantCulture));
		}
		return sb.ToString();
	}

	private static int GetInt32(JsonElement element, string name, int fallback = 0)
	{
		if (element.TryGetProperty(name, out JsonElement value))
		{
			if (value.ValueKind == JsonValueKind.Number && value.TryGetInt32(out int i))
			{
				return i;
			}

			if (value.ValueKind == JsonValueKind.String && int.TryParse(value.GetString(), NumberStyles.Integer, CultureInfo.InvariantCulture, out int s))
			{
				return s;
			}
		}

		return fallback;
	}

	private static decimal GetDecimal(JsonElement element, string name, decimal fallback = 0)
	{
		if (element.TryGetProperty(name, out JsonElement value))
		{
			if (value.ValueKind == JsonValueKind.Number && value.TryGetDecimal(out decimal d))
			{
				return d;
			}

			if (value.ValueKind == JsonValueKind.String && decimal.TryParse(value.GetString(), NumberStyles.Any, CultureInfo.InvariantCulture, out decimal s))
			{
				return s;
			}
		}

		return fallback;
	}

	private static string? GetString(JsonElement element, string name)
	{
		if (element.TryGetProperty(name, out JsonElement value) && value.ValueKind == JsonValueKind.String)
		{
			return value.GetString();
		}

		return null;
	}
}
