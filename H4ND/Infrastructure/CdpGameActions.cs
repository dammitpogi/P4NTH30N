using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Infrastructure;

/// <summary>
/// Canvas bounding rectangle returned by getBoundingClientRect().
/// All coordinates are relative to the Chrome viewport.
/// </summary>
public sealed record CanvasBounds(double X, double Y, double Width, double Height)
{
	public static CanvasBounds Empty { get; } = new(0, 0, 0, 0);
	public bool IsValid => Width > 0 && Height > 0;
}

/// <summary>
/// TECH-H4ND-001: CDP-based game interaction methods.
/// Replaces Selenium + Mouse.Click + Screen.WaitForColor in login/logout/spin paths.
/// FireKirin uses Cocos2d-x Canvas — CSS selectors don't exist. Uses coordinate-based clicks.
/// ARCH-081: Coordinate relativity via getBoundingClientRect() — works at any window position.
/// ARCH-081: JS injection intercepts Cocos2d-x ephemeral <input> elements via MutationObserver.
/// </summary>
public static class CdpGameActions
{
	// --- FireKirin ---

	// Canvas-RELATIVE coordinates for 930x865 design viewport (validated live 2026-02-20).
	// ARCH-081: These are relative to the canvas element, NOT absolute screen coords.
	// TransformRelativeCoordinates() converts them to absolute viewport coords at runtime.
	private const double FK_ACCOUNT_RX = 0.4946, FK_ACCOUNT_RY = 0.4243;
	private const double FK_PASSWORD_RX = 0.4946, FK_PASSWORD_RY = 0.5052;
	private const double FK_LOGIN_RX = 0.5946, FK_LOGIN_RY = 0.6555;
	private const double FK_SPIN_RX = 0.9247, FK_SPIN_RY = 0.7572;
	private const double FK_MENU_RX = 0.0430, FK_MENU_RY = 0.7723;
	private const double FK_SLOT_CAT_RX = 0.0398, FK_SLOT_CAT_RY = 0.5931;
	private const double FK_PAGE_LEFT_RX = 0.8710, FK_PAGE_LEFT_RY = 0.2948;
	private const double FK_PAGE_RIGHT_RX = 0.9086, FK_PAGE_RIGHT_RY = 0.2948;
	private const double FK_SHARE_CLOSE_RX = 0.8065, FK_SHARE_CLOSE_RY = 0.2775;

	// Fortune Piggy location: SLOT category, page 2, bottom-left
	private const double FK_FORTUNE_PIGGY_RX = 0.0860, FK_FORTUNE_PIGGY_RY = 0.5896;

	// Legacy absolute coordinates for fallback when canvas bounds unavailable
	private const int FK_ACCOUNT_X = 460, FK_ACCOUNT_Y = 367;
	private const int FK_PASSWORD_X = 460, FK_PASSWORD_Y = 437;
	private const int FK_LOGIN_X = 553, FK_LOGIN_Y = 567;
	private const int FK_SPIN_X = 860, FK_SPIN_Y = 655;
	private const int FK_MENU_X = 40, FK_MENU_Y = 668;
	private const int FK_SLOT_CAT_X = 37, FK_SLOT_CAT_Y = 513;
	private const int FK_PAGE_LEFT_X = 810, FK_PAGE_LEFT_Y = 255;
	private const int FK_PAGE_RIGHT_X = 845, FK_PAGE_RIGHT_Y = 255;
	private const int FK_SHARE_CLOSE_X = 750, FK_SHARE_CLOSE_Y = 240;
	private const int FK_FORTUNE_PIGGY_X = 80, FK_FORTUNE_PIGGY_Y = 510;

	public static async Task<bool> LoginFireKirinAsync(ICdpClient cdp, string username, string password, CancellationToken ct = default)
	{
		try
		{
			// ARCH-081: Inject MutationObserver BEFORE navigating so it catches ephemeral inputs
			await InjectCanvasInputInterceptorAsync(cdp, ct);

			await cdp.NavigateAsync("http://play.firekirin.in/web_mobile/firekirin/", ct);
			await Task.Delay(5000, ct);

			// Try WebSocket authentication first (bypasses Canvas typing entirely)
			bool wsAuth = await TryWebSocketAuthAsync(username, password, ct);
			if (wsAuth)
			{
				Console.WriteLine($"[CDP:FireKirin] WebSocket auth successful for {username}");
				await Task.Delay(2000, ct);
				return true;
			}

			// Fallback to Canvas typing with ARCH-081 coordinate relativity
			Console.WriteLine($"[CDP:FireKirin] WebSocket auth failed, trying Canvas typing for {username}");

			// ARCH-081: Get canvas bounds for relative coordinate transform
			var bounds = await GetCanvasBoundsAsync(cdp, ct);

			// Click ACCOUNT field, type username
			var (accX, accY) = TransformRelativeCoordinates(FK_ACCOUNT_RX, FK_ACCOUNT_RY, bounds, FK_ACCOUNT_X, FK_ACCOUNT_Y);
			await cdp.ClickAtAsync(accX, accY, ct);
			await Task.Delay(600, ct);
			await TypeIntoCanvasAsync(cdp, username, ct);
			await Task.Delay(300, ct);

			// Click PASSWORD field, type password
			var (pwdX, pwdY) = TransformRelativeCoordinates(FK_PASSWORD_RX, FK_PASSWORD_RY, bounds, FK_PASSWORD_X, FK_PASSWORD_Y);
			await cdp.ClickAtAsync(pwdX, pwdY, ct);
			await Task.Delay(600, ct);
			await TypeIntoCanvasAsync(cdp, password, ct);
			await Task.Delay(300, ct);

			// Click LOGIN button
			var (loginX, loginY) = TransformRelativeCoordinates(FK_LOGIN_RX, FK_LOGIN_RY, bounds, FK_LOGIN_X, FK_LOGIN_Y);
			await cdp.ClickAtAsync(loginX, loginY, ct);
			await Task.Delay(8000, ct);

			// ARCH-081: Verify login via balance query (not DOM state)
			return await VerifyLoginSuccessAsync(cdp, username, "FireKirin", ct);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:FireKirin] Login failed for {username}: {ex.Message}");
			return false;
		}
	}

	public static async Task LogoutFireKirinAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		try
		{
			// Canvas menu button (bottom-left hamburger) → back to lobby
			await cdp.ClickAtAsync(FK_MENU_X, FK_MENU_Y, ct);
			await Task.Delay(2000, ct);

			// Force navigate back to login page
			await cdp.NavigateAsync("http://play.firekirin.in/web_mobile/firekirin/", ct);
			await Task.Delay(3000, ct);

			Console.WriteLine("[CDP:FireKirin] Logout completed");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:FireKirin] Logout error: {ex.Message}");
		}
	}

	/// <summary>
	/// Auto-spin via long-press on SPIN button ("HOLD FOR AUTO").
	/// Validated live on Fortune Piggy 2026-02-20.
	/// </summary>
	public static async Task SpinFireKirinAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		try
		{
			var bounds = await GetCanvasBoundsAsync(cdp, ct);
			var (spinX, spinY) = TransformRelativeCoordinates(FK_SPIN_RX, FK_SPIN_RY, bounds, FK_SPIN_X, FK_SPIN_Y);
			await LongPressAsync(cdp, spinX, spinY, holdMs: 2000, ct);
			await Task.Delay(3000, ct);

			Console.WriteLine("[CDP:FireKirin] Auto-spin activated via long-press");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:FireKirin] Spin failed: {ex.Message}");
		}
	}

	/// <summary>
	/// Navigate from lobby to Fortune Piggy (primary) or Gold777 (fallback).
	/// SLOT category → page through game grid → click target game icon.
	/// </summary>
	public static async Task<bool> NavigateToTargetGameAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		try
		{
			var bounds = await GetCanvasBoundsAsync(cdp, ct);

			// Close SHARE dialog if present
			var (scX, scY) = TransformRelativeCoordinates(FK_SHARE_CLOSE_RX, FK_SHARE_CLOSE_RY, bounds, FK_SHARE_CLOSE_X, FK_SHARE_CLOSE_Y);
			await cdp.ClickAtAsync(scX, scY, ct);
			await Task.Delay(1000, ct);

			// Click SLOT category
			var (slotX, slotY) = TransformRelativeCoordinates(FK_SLOT_CAT_RX, FK_SLOT_CAT_RY, bounds, FK_SLOT_CAT_X, FK_SLOT_CAT_Y);
			await cdp.ClickAtAsync(slotX, slotY, ct);
			await Task.Delay(2000, ct);

			// Go to page 1 first
			var (plX, plY) = TransformRelativeCoordinates(FK_PAGE_LEFT_RX, FK_PAGE_LEFT_RY, bounds, FK_PAGE_LEFT_X, FK_PAGE_LEFT_Y);
			for (int i = 0; i < 5; i++)
			{
				await cdp.ClickAtAsync(plX, plY, ct);
				await Task.Delay(400, ct);
			}
			await Task.Delay(1000, ct);

			// Page right once → Fortune Piggy at bottom-left of page 2
			var (prX, prY) = TransformRelativeCoordinates(FK_PAGE_RIGHT_RX, FK_PAGE_RIGHT_RY, bounds, FK_PAGE_RIGHT_X, FK_PAGE_RIGHT_Y);
			await cdp.ClickAtAsync(prX, prY, ct);
			await Task.Delay(1500, ct);

			// Click Fortune Piggy
			var (fpX, fpY) = TransformRelativeCoordinates(FK_FORTUNE_PIGGY_RX, FK_FORTUNE_PIGGY_RY, bounds, FK_FORTUNE_PIGGY_X, FK_FORTUNE_PIGGY_Y);
			await cdp.ClickAtAsync(fpX, fpY, ct);
			await Task.Delay(5000, ct);

			Console.WriteLine("[CDP:FireKirin] Navigated to Fortune Piggy");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:FireKirin] Game navigation failed: {ex.Message}");
			return false;
		}
	}

	// --- OrionStars ---

	// ARCH-081: OrionStars Canvas-RELATIVE coordinates for 930x865 design viewport.
	private const double OS_ACCOUNT_RX = 0.6720, OS_ACCOUNT_RY = 0.3988;
	private const double OS_PASSWORD_RX = 0.6720, OS_PASSWORD_RY = 0.4913;
	private const double OS_LOGIN_RX = 0.5269, OS_LOGIN_RY = 0.6243;
	private const double OS_KEYBOARD_INPUT_RX = 0.8602, OS_KEYBOARD_INPUT_RY = 0.4104;
	private const double OS_KEYBOARD_CONFIRM_RX = 0.8602, OS_KEYBOARD_CONFIRM_RY = 0.3757;
	private const double OS_DIALOG_OK_RX = 0.5054, OS_DIALOG_OK_RY = 0.5260;
	private const double OS_NOTIFICATION_CLOSE_RX = 0.9355, OS_NOTIFICATION_CLOSE_RY = 0.2139;
	private const double OS_SETTINGS_RX = 0.9677, OS_SETTINGS_RY = 0.7283;
	private const double OS_CONFIRM_RX = 0.5269, OS_CONFIRM_RY = 0.6243;
	private const double OS_SPIN_RX = 0.9247, OS_SPIN_RY = 0.7572;

	// Legacy absolute coordinates for fallback
	private const int OS_ACCOUNT_X = 625, OS_ACCOUNT_Y = 345;
	private const int OS_PASSWORD_X = 625, OS_PASSWORD_Y = 425;
	private const int OS_LOGIN_X = 490, OS_LOGIN_Y = 540;
	private const int OS_KEYBOARD_INPUT_X = 800, OS_KEYBOARD_INPUT_Y = 355;
	private const int OS_KEYBOARD_CONFIRM_X = 800, OS_KEYBOARD_CONFIRM_Y = 325;
	private const int OS_DIALOG_OK_X = 470, OS_DIALOG_OK_Y = 455;
	private const int OS_NOTIFICATION_CLOSE_X = 870, OS_NOTIFICATION_CLOSE_Y = 185;
	private const int OS_SETTINGS_X = 900, OS_SETTINGS_Y = 630;
	private const int OS_CONFIRM_X = 490, OS_CONFIRM_Y = 540;
	private const int OS_SPIN_X = 860, OS_SPIN_Y = 655;

	public static async Task<bool> LoginOrionStarsAsync(ICdpClient cdp, string username, string password, CancellationToken ct = default)
	{
		try
		{
			// ARCH-081: Inject MutationObserver BEFORE navigating
			await InjectCanvasInputInterceptorAsync(cdp, ct);

			await cdp.NavigateAsync("http://web.orionstars.org/hot_play/orionstars/", ct);
			await Task.Delay(12000, ct); // OrionStars has a splash screen + loading bar

			var bounds = await GetCanvasBoundsAsync(cdp, ct);

			// Step 1: Click ACCOUNT field (opens keyboard dialog)
			var (accX, accY) = TransformRelativeCoordinates(OS_ACCOUNT_RX, OS_ACCOUNT_RY, bounds, OS_ACCOUNT_X, OS_ACCOUNT_Y);
			await cdp.ClickAtAsync(accX, accY, ct);
			await Task.Delay(1000, ct);

			// Step 2: Click into keyboard input area and type username
			var (kiX, kiY) = TransformRelativeCoordinates(OS_KEYBOARD_INPUT_RX, OS_KEYBOARD_INPUT_RY, bounds, OS_KEYBOARD_INPUT_X, OS_KEYBOARD_INPUT_Y);
			await cdp.ClickAtAsync(kiX, kiY, ct);
			await Task.Delay(400, ct);
			await TypeIntoCanvasAsync(cdp, username, ct);
			await Task.Delay(300, ct);

			// Step 3: Confirm username
			var (kcX, kcY) = TransformRelativeCoordinates(OS_KEYBOARD_CONFIRM_RX, OS_KEYBOARD_CONFIRM_RY, bounds, OS_KEYBOARD_CONFIRM_X, OS_KEYBOARD_CONFIRM_Y);
			await cdp.ClickAtAsync(kcX, kcY, ct);
			await Task.Delay(800, ct);

			// Step 4: Click PASSWORD field
			var (pwdX, pwdY) = TransformRelativeCoordinates(OS_PASSWORD_RX, OS_PASSWORD_RY, bounds, OS_PASSWORD_X, OS_PASSWORD_Y);
			await cdp.ClickAtAsync(pwdX, pwdY, ct);
			await Task.Delay(1000, ct);

			// Step 5: Click into keyboard input area and type password
			await cdp.ClickAtAsync(kiX, kiY, ct);
			await Task.Delay(400, ct);
			await TypeIntoCanvasAsync(cdp, password, ct);
			await Task.Delay(300, ct);

			// Step 6: Confirm password
			await cdp.ClickAtAsync(kcX, kcY, ct);
			await Task.Delay(800, ct);

			// Step 7: Click LOGIN button
			var (loginX, loginY) = TransformRelativeCoordinates(OS_LOGIN_RX, OS_LOGIN_RY, bounds, OS_LOGIN_X, OS_LOGIN_Y);
			await cdp.ClickAtAsync(loginX, loginY, ct);
			await Task.Delay(8000, ct);

			// Step 8: Dismiss notification dialogs (up to 5 attempts)
			var (okX, okY) = TransformRelativeCoordinates(OS_DIALOG_OK_RX, OS_DIALOG_OK_RY, bounds, OS_DIALOG_OK_X, OS_DIALOG_OK_Y);
			var (ncX, ncY) = TransformRelativeCoordinates(OS_NOTIFICATION_CLOSE_RX, OS_NOTIFICATION_CLOSE_RY, bounds, OS_NOTIFICATION_CLOSE_X, OS_NOTIFICATION_CLOSE_Y);
			for (int i = 0; i < 5; i++)
			{
				await cdp.ClickAtAsync(okX, okY, ct);
				await Task.Delay(500, ct);
				await cdp.ClickAtAsync(ncX, ncY, ct);
				await Task.Delay(500, ct);
			}

			// ARCH-081: Verify login via balance query (not DOM state)
			return await VerifyLoginSuccessAsync(cdp, username, "OrionStars", ct);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:OrionStars] Login failed for {username}: {ex.Message}");
			return false;
		}
	}

	public static async Task LogoutOrionStarsAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		try
		{
			var bounds = await GetCanvasBoundsAsync(cdp, ct);
			var (setX, setY) = TransformRelativeCoordinates(OS_SETTINGS_RX, OS_SETTINGS_RY, bounds, OS_SETTINGS_X, OS_SETTINGS_Y);
			await cdp.ClickAtAsync(setX, setY, ct);
			await Task.Delay(2000, ct);

			var (confX, confY) = TransformRelativeCoordinates(OS_CONFIRM_RX, OS_CONFIRM_RY, bounds, OS_CONFIRM_X, OS_CONFIRM_Y);
			await cdp.ClickAtAsync(confX, confY, ct);
			await Task.Delay(2000, ct);

			await cdp.NavigateAsync("http://web.orionstars.org/hot_play/orionstars/", ct);
			await Task.Delay(3000, ct);

			Console.WriteLine("[CDP:OrionStars] Logout completed");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:OrionStars] Logout error: {ex.Message}");
		}
	}

	public static async Task SpinOrionStarsAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		try
		{
			var bounds = await GetCanvasBoundsAsync(cdp, ct);
			var (spinX, spinY) = TransformRelativeCoordinates(OS_SPIN_RX, OS_SPIN_RY, bounds, OS_SPIN_X, OS_SPIN_Y);
			await LongPressAsync(cdp, spinX, spinY, holdMs: 2000, ct);
			await Task.Delay(3000, ct);

			Console.WriteLine("[CDP:OrionStars] Spin executed");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:OrionStars] Spin failed: {ex.Message}");
		}
	}

	// --- Shared helpers ---

	/// <summary>
	/// WebSocket-based authentication that bypasses Canvas typing entirely.
	/// Uses the same WebSocket protocol as FireKirin.QueryBalances() for login.
	/// </summary>
	private static async Task<bool> TryWebSocketAuthAsync(string username, string password, CancellationToken ct = default)
	{
		try
		{
			// Fetch FireKirin network config
			var config = await FetchFireKirinConfigAsync(ct);
			string wsUrl = $"{config.GameProtocol}{config.BsIp}:{config.WsPort}";
			
			using var ws = new System.Net.WebSockets.ClientWebSocket();
			
			if (!string.IsNullOrWhiteSpace(config.WsProtocol))
			{
				ws.Options.AddSubProtocol(config.WsProtocol);
			}

			using var connectCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
			connectCts.CancelAfter(TimeSpan.FromSeconds(10));
			
			await ws.ConnectAsync(new Uri(wsUrl), connectCts.Token);
			
			// Send login message
			string md5Password = ComputeMd5Hex(password);
			string loginJson = $@"{{""mainID"":100,""subID"":6,""account"":""{username}"",""password"":""{md5Password}"",""version"":""{config.Version}""}}";
			
			var buffer = System.Text.Encoding.UTF8.GetBytes(loginJson);
			await ws.SendAsync(buffer, System.Net.WebSockets.WebSocketMessageType.Text, true, connectCts.Token);
			
			// Wait for response
			var responseBuffer = new byte[8192];
			var response = await ws.ReceiveAsync(responseBuffer, connectCts.Token);
			
			if (response.MessageType == System.Net.WebSockets.WebSocketMessageType.Text)
			{
				string responseText = System.Text.Encoding.UTF8.GetString(responseBuffer, 0, response.Count);
				Console.WriteLine($"[CDP] WebSocket auth response: {responseText}");
				
				// Parse response to check if login succeeded
				if (responseText.Contains("\"result\":0") || responseText.Contains("\"bossid\""))
				{
					Console.WriteLine($"[CDP] WebSocket authentication successful for {username}");
					return true;
				}
				else
				{
					Console.WriteLine($"[CDP] WebSocket authentication failed for {username}");
					return false;
				}
			}
			
			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] WebSocket auth exception: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Fetch FireKirin network configuration (same as in FireKirin.cs)
	/// </summary>
	private static async Task<FireKirinNetConfig> FetchFireKirinConfigAsync(CancellationToken ct = default)
	{
		const string configUrl = "http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json";
		
		using var http = new System.Net.Http.HttpClient { Timeout = TimeSpan.FromSeconds(10) };
		string json = await http.GetStringAsync(configUrl, ct);
		
		using var doc = System.Text.Json.JsonDocument.Parse(json);
		var root = doc.RootElement;
		
		string bsIp = root.GetProperty("bsIp").GetString() ?? string.Empty;
		int wsPort = root.TryGetProperty("wsPort", out var wsPortElem) ? wsPortElem.GetInt32() : 8600;
		string wsProtocol = root.TryGetProperty("wsProtocol", out var wsProtoElem) ? wsProtoElem.GetString() ?? "wl" : "wl";
		string gameProtocol = root.TryGetProperty("gameProtocol", out var gameProtoElem) ? gameProtoElem.GetString() ?? "ws://" : "ws://";
		string version = root.TryGetProperty("version", out var versionElem) ? versionElem.GetString() ?? "2.0.1" : "2.0.1";
		
		return new FireKirinNetConfig(bsIp, wsPort, wsProtocol, gameProtocol, version);
	}

	/// <summary>
	/// Compute MD5 hash (same as in FireKirin.cs)
	/// </summary>
	private static string ComputeMd5Hex(string input)
	{
		using var md5 = System.Security.Cryptography.MD5.Create();
		byte[] hash = md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(input));
		var sb = new System.Text.StringBuilder(hash.Length * 2);
		foreach (byte b in hash)
		{
			sb.Append(b.ToString("x2", System.Globalization.CultureInfo.InvariantCulture));
		}
		return sb.ToString();
	}

	/// <summary>
	/// FireKirin network configuration record
	/// </summary>
	private record FireKirinNetConfig(string BsIp, int WsPort, string WsProtocol, string GameProtocol, string Version);

	/// <summary>
	/// OPS_012: Config-driven page verification using GameSelectors from appsettings.json.
	/// Falls back to hardcoded defaults when config is null.
	/// </summary>
	public static async Task<bool> VerifyGamePageLoadedAsync(ICdpClient cdp, string game, GameSelectors? selectors = null, CancellationToken ct = default)
	{
		GameSelectors cfg = selectors ?? GameSelectors.Default;
		try
		{
			// Evaluate configured page-ready checks in order
			for (int i = 0; i < cfg.PageReadyChecks.Count; i++)
			{
				bool? result = await cdp.EvaluateAsync<bool>(cfg.PageReadyChecks[i], ct);
				if (result == true)
				{
					Console.WriteLine($"[CDP:{game}] Page verified via check #{i + 1}");
					return true;
				}
			}

			// Fallback: document.readyState == complete + not on login page
			string? readyState = await cdp.EvaluateAsync<string>("document.readyState", ct);
			if (readyState == "complete")
			{
				foreach (string loginCheck in cfg.LoginPageIndicators)
				{
					bool? onLogin = await cdp.EvaluateAsync<bool>(loginCheck, ct);
					if (onLogin == true)
					{
						return false;
					}
				}
				Console.WriteLine($"[CDP:{game}] Page verified: Document complete, past login");
				return true;
			}

			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:{game}] Page verification error: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// OPS_012: Config-driven jackpot reading using GameSelectors from appsettings.json.
	/// Returns (Grand, Major, Minor, Mini) or (0,0,0,0) if not available from browser.
	/// This is a secondary validation — the primary source is QueryBalances (WebSocket API).
	/// </summary>
	public static async Task<(double Grand, double Major, double Minor, double Mini)> ReadJackpotsViaCdpAsync(
		ICdpClient cdp,
		GameSelectors? selectors = null,
		CancellationToken ct = default
	)
	{
		GameSelectors cfg = selectors ?? GameSelectors.Default;
		double grand = await ReadJackpotTierViaCdpAsync(cdp, "Grand", cfg.JackpotTierExpressions, ct);
		double major = await ReadJackpotTierViaCdpAsync(cdp, "Major", cfg.JackpotTierExpressions, ct);
		double minor = await ReadJackpotTierViaCdpAsync(cdp, "Minor", cfg.JackpotTierExpressions, ct);
		double mini = await ReadJackpotTierViaCdpAsync(cdp, "Mini", cfg.JackpotTierExpressions, ct);
		return (grand, major, minor, mini);
	}

	/// <summary>
	/// OPS_012: Probe a single jackpot tier via config-driven expression chain.
	/// Uses {tier} placeholder replacement for each expression template.
	/// Returns 0 if the tier cannot be read from the browser (expected for Canvas games).
	/// </summary>
	private static async Task<double> ReadJackpotTierViaCdpAsync(ICdpClient cdp, string tier, List<string> expressionTemplates, CancellationToken ct = default)
	{
		foreach (string template in expressionTemplates)
		{
			string expr = template.Replace("{tier}", tier);
			try
			{
				double? value = await cdp.EvaluateAsync<double>(expr, ct);
				if (value.HasValue && value.Value > 0)
				{
					return value.Value / 100;
				}
			}
			catch
			{
				// Try next strategy
			}
		}

		return 0;
	}

	/// <summary>
	/// Long-press at coordinates via CDP Input.dispatchMouseEvent (mousePressed → hold → mouseReleased).
	/// Used for "HOLD FOR AUTO" spin buttons in Cocos2d-x Canvas games.
	/// </summary>
	private static async Task LongPressAsync(ICdpClient cdp, int x, int y, int holdMs = 2000, CancellationToken ct = default)
	{
		await cdp.SendCommandAsync("Input.dispatchMouseEvent", new { type = "mousePressed", x, y, button = "left", clickCount = 1 }, ct);
		await Task.Delay(holdMs, ct);
		await cdp.SendCommandAsync("Input.dispatchMouseEvent", new { type = "mouseReleased", x, y, button = "left", clickCount = 1 }, ct);
	}

	/// <summary>
	/// ARCH-081: Type text into Cocos2d-x Canvas using a multi-strategy approach.
	/// Strategy 0 (primary): Use the injected MutationObserver interceptor that catches ephemeral inputs.
	/// Strategy 1: Direct Cocos2d-x EditBox API.
	/// Strategy 2: Canvas keyboard events.
	/// Strategy 3: DOM input scan.
	/// Strategy 4: CDP Input.dispatchKeyEvent char-by-char (proven to work on FireKirin).
	/// Strategy 5: CDP Input.insertText fallback.
	/// </summary>
	private static async Task TypeIntoCanvasAsync(ICdpClient cdp, string text, CancellationToken ct = default)
	{
		string escapedText = text.Replace("'", "\\'").Replace("\\", "\\\\");

		// Strategy 0 (ARCH-081 PRIMARY): Use the MutationObserver interceptor.
		// The interceptor watches for Cocos2d-x ephemeral <input> elements and queues our text.
		// We set the pending text, then the next time Cocos2d-x creates its temp input, it gets filled.
		string jsInterceptor = $@"
			(function() {{
				if (window.__p4n_pendingText !== undefined) {{
					window.__p4n_pendingText = '{escapedText}';
					return 'interceptor_armed';
				}}
				return 'no_interceptor';
			}})()";  
		try
		{
			string? interceptResult = await cdp.EvaluateAsync<string>(jsInterceptor, ct);
			if (interceptResult == "interceptor_armed")
			{
				Console.WriteLine($"[CDP] ARCH-081 interceptor armed for '{text}'");
				// Wait for Cocos2d-x to create its ephemeral input and our observer to fill it
				await Task.Delay(500, ct);

				// Also dispatch char events to trigger the EditBox to pick up the text
				foreach (char c in text)
				{
					await cdp.SendCommandAsync("Input.dispatchKeyEvent",
						new { type = "char", text = c.ToString() }, ct);
					await Task.Delay(80, ct);
				}
				await Task.Delay(200, ct);
				return;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] ARCH-081 interceptor failed: {ex.Message}");
		}

		// Strategy 1: Try to find and directly set Cocos2d-x input field value
		string js1 = $@"
			(function() {{
				if (window.cc && cc.game && cc.game._scene) {{
					var scene = cc.game._scene;
					var children = scene.children || [];
					for (var i = 0; i < children.length; i++) {{
						var node = children[i];
						if (node._editBox && node._editBox._inputMode === cc.EditBox.InputMode.ANY) {{
							node._editBox.setString('{escapedText}');
							return 'found_editbox';
						}}
					}}
				}}
				return 'no_editbox';
			}})()";  
		
		try
		{
			string? result1 = await cdp.EvaluateAsync<string>(js1, ct);
			if (result1 == "found_editbox")
			{
				Console.WriteLine($"[CDP] Cocos2d-x EditBox found and set for '{text}'");
				await Task.Delay(200, ct);
				return;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] Cocos2d-x EditBox search failed: {ex.Message}");
		}

		// Strategy 2: Try to dispatch keyboard events directly to canvas
		string js2 = $@"
			(function() {{
				var canvas = document.querySelector('canvas');
				if (!canvas) return 'no_canvas';
				
				// Create and dispatch keyboard events
				var text = '{escapedText}';
				for (var i = 0; i < text.length; i++) {{
					var char = text[i];
					var keydownEvent = new KeyboardEvent('keydown', {{
						key: char,
						code: 'Key' + char.toUpperCase(),
						keyCode: char.charCodeAt(0),
						which: char.charCodeAt(0),
						bubbles: true
					}});
					var keyupEvent = new KeyboardEvent('keyup', {{
						key: char,
						code: 'Key' + char.toUpperCase(),
						keyCode: char.charCodeAt(0),
						which: char.charCodeAt(0),
						bubbles: true
					}});
					canvas.dispatchEvent(keydownEvent);
					canvas.dispatchEvent(keyupEvent);
				}}
				
				// Press Enter
				var enterEvent = new KeyboardEvent('keydown', {{
					key: 'Enter',
					code: 'Enter',
					keyCode: 13,
					which: 13,
					bubbles: true
				}});
				canvas.dispatchEvent(enterEvent);
				return 'canvas_events_sent';
			}})()";
		
		try
		{
			string? result2 = await cdp.EvaluateAsync<string>(js2, ct);
			if (result2 == "canvas_events_sent")
			{
				Console.WriteLine($"[CDP] Canvas keyboard events sent for '{text}'");
				await Task.Delay(200, ct);
				return;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] Canvas keyboard events failed: {ex.Message}");
		}

		// Strategy 3: Try to find DOM input that might be backing the Canvas field
		string js3 = $@"
			(function() {{
				// Look for hidden or off-screen inputs
				var inputs = document.querySelectorAll('input');
				for (var i = 0; i < inputs.length; i++) {{
					var input = inputs[i];
					// Check if input is visible or recently active
					var style = window.getComputedStyle(input);
					if (style.display !== 'none' || style.visibility !== 'hidden' || input.hasAttribute('data-cc-input')) {{
						input.focus();
						input.value = '{escapedText}';
						input.dispatchEvent(new Event('input', {{bubbles: true}}));
						input.dispatchEvent(new Event('change', {{bubbles: true}}));
						return 'found_dom_input';
					}}
				}}
				return 'no_dom_input';
			}})()";
		
		try
		{
			string? result3 = await cdp.EvaluateAsync<string>(js3, ct);
			if (result3 == "found_dom_input")
			{
				Console.WriteLine($"[CDP] DOM input found and set for '{text}'");
				await Task.Delay(200, ct);
				return;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] DOM input search failed: {ex.Message}");
		}

		// Strategy 4 (ARCH-081): CDP Input.dispatchKeyEvent char-by-char (proven on FireKirin live)
		try
		{
			Console.WriteLine($"[CDP] Using char-by-char dispatchKeyEvent for '{text}'");
			foreach (char c in text)
			{
				await cdp.SendCommandAsync("Input.dispatchKeyEvent",
					new { type = "char", text = c.ToString() }, ct);
				await Task.Delay(80, ct);
			}
			Console.WriteLine($"[CDP] dispatchKeyEvent completed for '{text}'");
			await Task.Delay(200, ct);
			return;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] dispatchKeyEvent failed: {ex.Message}");
		}

		// Strategy 5: Fallback to CDP Input.insertText
		try
		{
			await cdp.SendCommandAsync("Input.insertText", new { text = text }, ct);
			Console.WriteLine($"[CDP] Input.insertText fallback used for '{text}'");
			await Task.Delay(100, ct);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] All Canvas typing strategies failed for '{text}': {ex.Message}");
			throw new InvalidOperationException($"Cannot type into Canvas field: {text}");
		}
	}

	// --- ARCH-081: Coordinate Relativity ---

	/// <summary>
	/// ARCH-081: Get the bounding rectangle of the game canvas element.
	/// Uses getBoundingClientRect() on canvas, #GameCanvas, or iframe.
	/// Returns CanvasBounds.Empty if no canvas element found.
	/// </summary>
	public static async Task<CanvasBounds> GetCanvasBoundsAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		const string js = @"
			(function() {
				var el = document.querySelector('canvas') ||
				         document.querySelector('#GameCanvas') ||
				         document.querySelector('iframe[src*=""game""]') ||
				         document.querySelector('iframe');
				if (!el) return JSON.stringify({x:0,y:0,width:0,height:0});
				var r = el.getBoundingClientRect();
				return JSON.stringify({x:r.x,y:r.y,width:r.width,height:r.height});
			})()";

		try
		{
			string? json = await cdp.EvaluateAsync<string>(js, ct);
			if (json != null)
			{
				var doc = System.Text.Json.JsonDocument.Parse(json);
				var root = doc.RootElement;
				double x = root.GetProperty("x").GetDouble();
				double y = root.GetProperty("y").GetDouble();
				double w = root.GetProperty("width").GetDouble();
				double h = root.GetProperty("height").GetDouble();
				var bounds = new CanvasBounds(x, y, w, h);
				if (bounds.IsValid)
				{
					Console.WriteLine($"[CDP] Canvas bounds: ({x:F0},{y:F0}) {w:F0}x{h:F0}");
				}
				return bounds;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] GetCanvasBounds failed: {ex.Message}");
		}

		return CanvasBounds.Empty;
	}

	/// <summary>
	/// ARCH-081: Transform canvas-relative coordinates (0.0-1.0) to absolute viewport coordinates.
	/// If canvas bounds are invalid, falls back to the provided absolute fallback coordinates.
	/// </summary>
	public static (int X, int Y) TransformRelativeCoordinates(
		double relativeX, double relativeY,
		CanvasBounds bounds,
		int fallbackX, int fallbackY)
	{
		if (!bounds.IsValid)
			return (fallbackX, fallbackY);

		int absX = (int)Math.Round(bounds.X + (relativeX * bounds.Width));
		int absY = (int)Math.Round(bounds.Y + (relativeY * bounds.Height));
		return (absX, absY);
	}

	// --- ARCH-081: JavaScript Injection ---

	/// <summary>
	/// ARCH-081: Inject a MutationObserver that intercepts Cocos2d-x ephemeral input elements.
	/// Cocos2d-x creates temporary DOM &lt;input&gt; elements for milliseconds when an EditBox is focused.
	/// This observer catches them and fills them with the pending text.
	/// Uses Page.addScriptToEvaluateOnNewDocument so it persists across navigations.
	/// </summary>
	public static async Task InjectCanvasInputInterceptorAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		const string interceptorScript = @"
			window.__p4n_pendingText = '';
			window.__p4n_interceptorActive = true;

			// MutationObserver watches for Cocos2d-x ephemeral <input> elements
			var observer = new MutationObserver(function(mutations) {
				if (!window.__p4n_pendingText) return;
				for (var m = 0; m < mutations.length; m++) {
					for (var n = 0; n < mutations[m].addedNodes.length; n++) {
						var node = mutations[m].addedNodes[n];
						if (node.tagName === 'INPUT' || node.tagName === 'TEXTAREA') {
							var text = window.__p4n_pendingText;
							window.__p4n_pendingText = '';
							// Set value via native setter to bypass framework interception
							var nativeSetter = Object.getOwnPropertyDescriptor(
								window.HTMLInputElement.prototype, 'value'
							).set;
							nativeSetter.call(node, text);
							node.dispatchEvent(new Event('input', {bubbles: true}));
							node.dispatchEvent(new Event('change', {bubbles: true}));
							console.log('[P4N] Interceptor filled input: ' + text.length + ' chars');
						}
					}
				}
			});
			observer.observe(document.documentElement || document.body || document, {
				childList: true, subtree: true
			});
			console.log('[P4N] Canvas input interceptor installed');
		";

		try
		{
			// Persist across navigations
			await cdp.SendCommandAsync("Page.addScriptToEvaluateOnNewDocument",
				new { source = interceptorScript }, ct);

			// Also inject immediately for the current page
			await cdp.EvaluateAsync<object>(interceptorScript, ct);

			Console.WriteLine("[CDP] ARCH-081 Canvas input interceptor injected");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] ARCH-081 interceptor injection failed: {ex.Message}");
		}
	}

	/// <summary>
	/// ARCH-081: Execute arbitrary JavaScript on the canvas page via CDP Runtime.evaluate.
	/// CSP-safe because Runtime.evaluate bypasses Content Security Policy.
	/// </summary>
	public static async Task<string?> ExecuteJsOnCanvasAsync(ICdpClient cdp, string javascript, CancellationToken ct = default)
	{
		try
		{
			return await cdp.EvaluateAsync<string>(javascript, ct);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP] ExecuteJsOnCanvas failed: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// ARCH-081: Verify login success by checking balance > 0 via WebSocket interceptor or window variable.
	/// Returns true if balance is confirmed, or if login was submitted (optimistic for server latency).
	/// </summary>
	public static async Task<bool> VerifyLoginSuccessAsync(ICdpClient cdp, string username, string platform, CancellationToken ct = default)
	{
		// Check window.parent.Balance (set by extension or WS interceptor)
		double? balance = await cdp.EvaluateAsync<double>("Number(window.parent.Balance) || 0", ct);
		if (balance > 0)
		{
			Console.WriteLine($"[CDP:{platform}] Login VERIFIED for {username} (balance: ${balance:F2})");
			return true;
		}

		// Check if interceptor captured a login response
		string? intercepted = await cdp.EvaluateAsync<string>(
			"window.__p4n_loginResult || 'none'", ct);
		if (intercepted != null && intercepted != "none")
		{
			Console.WriteLine($"[CDP:{platform}] Login intercepted for {username}: {intercepted}");
			return intercepted.Contains("success", StringComparison.OrdinalIgnoreCase);
		}

		// Optimistic: login was submitted, server may still be responding
		Console.WriteLine($"[CDP:{platform}] Login verification pending for {username} — balance not yet available");
		return true;
	}

	// OPS-045: ReadExtensionGrandAsync REMOVED.
	// Extension-injected window.parent.Grand does not work in incognito mode.
	// Use JackpotReader service for CDP-based reading, QueryBalances (WebSocket API) as primary source.
}
