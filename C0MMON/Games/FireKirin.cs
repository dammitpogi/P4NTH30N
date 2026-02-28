using System;
using System.Collections.Generic;
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
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.C0MMON;

public static class FireKirin
{
	public sealed record FireKirinBalances(decimal Balance, decimal Grand, decimal Major, decimal Minor, decimal Mini);

	private sealed record FireKirinNetConfig(string BsIp, int WsPort, string WsProtocol, string GameProtocol, string Version);

	// DECISION_073: Config cache to survive transient HTTP failures
	private static FireKirinNetConfig? s_cachedConfig;
	private static DateTime s_configCachedAt = DateTime.MinValue;
	private static readonly TimeSpan s_configCacheTtl = TimeSpan.FromMinutes(10);

	public static Signal? SpinSlots(ChromeDriver driver, Credential credential, Signal signal, IUnitOfWork uow)
	{
		Signal? overrideSignal = null;
		bool FortunePiggyLoaded = Games.FortunePiggy.LoadSucessfully(driver, credential, signal, uow);
		bool Gold777Loaded = FortunePiggyLoaded ? false : Games.Gold777.LoadSucessfully(driver, credential, signal, uow);

		if (FortunePiggyLoaded)
		{
			overrideSignal = Games.FortunePiggy.Spin(driver, credential, signal, uow);
		}
		else if (Gold777Loaded)
		{
			overrideSignal = Games.Gold777.Spin(driver, credential, signal, uow);
		}

		// TODO: FIX - Hardcoded casino URLs throughout code (Decision 0)
		// Current: Cannot update URLs without code changes, brittle if casinos change domains
		// Fix: Move URLs to configuration files or settings
		driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
		P4NTHE0N.C0MMON.Screen.WaitForColor(new Point(925, 120), Color.FromArgb(255, 255, 251, 48));
		Thread.Sleep(2000);
		Mouse.Click(80, 235);
		Thread.Sleep(800);
		return overrideSignal;
	}

	public static void Logout()
	{
		Mouse.Click(996, 184);
		Thread.Sleep(2400);
		Mouse.Click(858, 548);
		Thread.Sleep(3200);
		Mouse.Click(533, 500);
	}

	public static bool Login(ChromeDriver driver, string username, string password)
	{
		try
		{
			int iterations = 0;
			while (true)
			{
				// Console.WriteLine("LoginIteration: " + iterations);
				if (iterations++.Equals(10))
					throw new Exception($"[{username}] Credential retries limit exceeded. Skipping this Credential.");

				Mouse.Click(470, 310);
				Thread.Sleep(400);
				Keyboard.Send(username);
				Mouse.Click(470, 380);
				Thread.Sleep(400);
				Keyboard.Send(password).Wait(400).Enter();
				bool NotReloaded = true,
					Loaded = false;

				int loadingIterations = 0;
				while (Loaded == false && NotReloaded)
				{
					Thread.Sleep(200);

					bool HomeScreenLoaded = Screen.GetColorAt(new Point(925, 120)).Equals(Color.FromArgb(255, 255, 251, 48));
					bool MessageBoxPopped = Screen.GetColorAt(new Point(937, 177)).Equals(Color.FromArgb(255, 228, 227, 70));
					Loaded = HomeScreenLoaded || MessageBoxPopped;

					loadingIterations++;
					if (loadingIterations > 300)
					{
						throw new Exception("Login took too long.");
					}

					if (Screen.GetColorAt(new Point(535, 403)).Equals(Color.FromArgb(255, 121, 125, 47)))
					{
						driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
						Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51));
						NotReloaded = false;
						break;
					}

					if (Loaded)
					{
						for (int i = 0; i < 14; i++)
						{
							if (Screen.GetColorAt(new Point(937, 177)).Equals(Color.FromArgb(255, 228, 227, 70)))
							{
								Mouse.Click(937, 177);
								break;
							}
							else
								Thread.Sleep(200);
						}
					}
				}
				if (NotReloaded)
					break;
			}
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Exception on Login: {ex.Message}");
			return false;
		}
	}

	public static FireKirinBalances QueryBalances(string username, string password)
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
				Console.WriteLine($"[DECISION_073] FireKirin.QueryBalances attempt {attempt + 1}/{maxAttempts} failed for {username}: {ex.Message}");
			}
		}

		Console.WriteLine($"[DECISION_073][ERROR] FireKirin.QueryBalances exhausted retries for {username}: {lastEx?.Message} — returning zeros");
		return new FireKirinBalances(0, 0, 0, 0, 0);
	}

	private static FireKirinBalances QueryBalancesCore(string username, string password)
	{
		FireKirinNetConfig config = FetchNetConfig();
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

		return new FireKirinBalances(balance, grand, major, minor, mini);
	}

	private static decimal AdjustJackpot(decimal value)
	{
		return value > 2000 ? value / 100 : value;
	}

	private static FireKirinNetConfig FetchNetConfig()
	{
		// DECISION_073: Serve from cache if fresh
		if (s_cachedConfig != null && (DateTime.UtcNow - s_configCachedAt) < s_configCacheTtl)
			return s_cachedConfig;

		const string configUrl = "http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json";

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
				throw new InvalidOperationException("Missing bsIp in FireKirin config.");

			s_cachedConfig = new FireKirinNetConfig(bsIp, wsPort, wsProtocol, gameProtocol, version);
			s_configCachedAt = DateTime.UtcNow;
			return s_cachedConfig;
		}
		catch when (s_cachedConfig != null)
		{
			// DECISION_073: Use stale cache on fetch failure
			Console.WriteLine("[DECISION_073] FireKirin config fetch failed — using cached config");
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
