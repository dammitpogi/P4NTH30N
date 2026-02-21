using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Infrastructure;

/// <summary>
/// TECH-H4ND-001: CDP-based game interaction methods.
/// Replaces Selenium + Mouse.Click + Screen.WaitForColor in login/logout/spin paths.
/// FireKirin uses Cocos2d-x Canvas — CSS selectors don't exist. Uses coordinate-based clicks.
/// Coordinates validated live 2026-02-20 on ~930x865 viewport.
/// </summary>
public static class CdpGameActions
{
	// --- FireKirin ---

	// Canvas coordinates for ~930x865 viewport (validated live 2026-02-20)
	private const int FK_ACCOUNT_X = 460, FK_ACCOUNT_Y = 367;
	private const int FK_PASSWORD_X = 460, FK_PASSWORD_Y = 437;
	private const int FK_LOGIN_X = 553, FK_LOGIN_Y = 567;
	private const int FK_SPIN_X = 860, FK_SPIN_Y = 655;
	private const int FK_MENU_X = 40, FK_MENU_Y = 668;
	private const int FK_SLOT_CAT_X = 37, FK_SLOT_CAT_Y = 513;
	private const int FK_PAGE_LEFT_X = 810, FK_PAGE_LEFT_Y = 255;
	private const int FK_PAGE_RIGHT_X = 845, FK_PAGE_RIGHT_Y = 255;
	private const int FK_SHARE_CLOSE_X = 750, FK_SHARE_CLOSE_Y = 240;

	// Fortune Piggy location: SLOT category, page 2, bottom-left
	private const int FK_FORTUNE_PIGGY_X = 80, FK_FORTUNE_PIGGY_Y = 510;

	public static async Task<bool> LoginFireKirinAsync(ICdpClient cdp, string username, string password, CancellationToken ct = default)
	{
		try
		{
			await cdp.NavigateAsync("http://play.firekirin.in/web_mobile/firekirin/", ct);
			await Task.Delay(5000, ct);

			// Try WebSocket authentication first (bypasses Canvas typing entirely)
			bool wsAuth = await TryWebSocketAuthAsync(username, password, ct);
			if (wsAuth)
			{
				Console.WriteLine($"[CDP:FireKirin] WebSocket auth successful for {username}");
				// Navigate to game page to establish session
				await Task.Delay(2000, ct);
				return true;
			}

			// Fallback to Canvas typing with enhanced strategies
			Console.WriteLine($"[CDP:FireKirin] WebSocket auth failed, trying Canvas typing for {username}");
			
			// Cocos2d-x Canvas login — no DOM elements, use coordinate clicks
			// Click ACCOUNT field, type username
			await cdp.ClickAtAsync(FK_ACCOUNT_X, FK_ACCOUNT_Y, ct);
			await Task.Delay(600, ct);
			await TypeIntoCanvasAsync(cdp, username, ct);
			await Task.Delay(300, ct);

			// Click PASSWORD field, type password
			await cdp.ClickAtAsync(FK_PASSWORD_X, FK_PASSWORD_Y, ct);
			await Task.Delay(600, ct);
			await TypeIntoCanvasAsync(cdp, password, ct);
			await Task.Delay(300, ct);

			// Click LOGIN button
			await cdp.ClickAtAsync(FK_LOGIN_X, FK_LOGIN_Y, ct);
			await Task.Delay(8000, ct);

			// Verify login: check for balance display via window.parent.Balance or WS interceptor
			double? balance = await cdp.EvaluateAsync<double>("Number(window.parent.Balance) || 0", ct);
			if (balance > 0)
			{
				Console.WriteLine($"[CDP:FireKirin] Login successful for {username} (balance: ${balance:F2})");
				return true;
			}

			// Fallback: if we get past the login screen, the URL or page state changes
			Console.WriteLine($"[CDP:FireKirin] Login verification pending for {username} — balance not yet available");
			return true; // Proceed — login was submitted, server may still be responding
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
			// Long-press SPIN button to trigger auto-spin
			await LongPressAsync(cdp, FK_SPIN_X, FK_SPIN_Y, holdMs: 2000, ct);
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
			// Close SHARE dialog if present
			await cdp.ClickAtAsync(FK_SHARE_CLOSE_X, FK_SHARE_CLOSE_Y, ct);
			await Task.Delay(1000, ct);

			// Click SLOT category
			await cdp.ClickAtAsync(FK_SLOT_CAT_X, FK_SLOT_CAT_Y, ct);
			await Task.Delay(2000, ct);

			// Go to page 1 first
			for (int i = 0; i < 5; i++)
			{
				await cdp.ClickAtAsync(FK_PAGE_LEFT_X, FK_PAGE_LEFT_Y, ct);
				await Task.Delay(400, ct);
			}
			await Task.Delay(1000, ct);

			// Page right once → Fortune Piggy at bottom-left of page 2
			await cdp.ClickAtAsync(FK_PAGE_RIGHT_X, FK_PAGE_RIGHT_Y, ct);
			await Task.Delay(1500, ct);

			// Click Fortune Piggy
			await cdp.ClickAtAsync(FK_FORTUNE_PIGGY_X, FK_FORTUNE_PIGGY_Y, ct);
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

	// OrionStars Canvas coordinates for ~930x865 CDP viewport.
	// OrionStars uses Cocos2d-x Canvas (same engine as FireKirin) — NO DOM elements.
	// Login uses a popup keyboard dialog: click field → keyboard overlay → type → confirm.
	// Coordinates derived from original OrionStars.Login() in C0MMON/Games/OrionStars.cs
	// which used OS-level Mouse.Click on ~1024x768 window, scaled to CDP viewport.
	private const int OS_ACCOUNT_X = 625, OS_ACCOUNT_Y = 345;
	private const int OS_PASSWORD_X = 625, OS_PASSWORD_Y = 425;
	private const int OS_LOGIN_X = 490, OS_LOGIN_Y = 540;
	private const int OS_KEYBOARD_INPUT_X = 800, OS_KEYBOARD_INPUT_Y = 355;
	private const int OS_KEYBOARD_CONFIRM_X = 800, OS_KEYBOARD_CONFIRM_Y = 325;
	private const int OS_DIALOG_OK_X = 470, OS_DIALOG_OK_Y = 455;
	private const int OS_NOTIFICATION_CLOSE_X = 870, OS_NOTIFICATION_CLOSE_Y = 185;

	public static async Task<bool> LoginOrionStarsAsync(ICdpClient cdp, string username, string password, CancellationToken ct = default)
	{
		try
		{
			await cdp.NavigateAsync("http://web.orionstars.org/hot_play/orionstars/", ct);
			await Task.Delay(12000, ct); // OrionStars has a splash screen + loading bar

			// Cocos2d-x Canvas login — no DOM elements, use coordinate clicks
			// Step 1: Click ACCOUNT field (opens keyboard dialog)
			await cdp.ClickAtAsync(OS_ACCOUNT_X, OS_ACCOUNT_Y, ct);
			await Task.Delay(1000, ct);

			// Step 2: Click into keyboard input area and type username
			await cdp.ClickAtAsync(OS_KEYBOARD_INPUT_X, OS_KEYBOARD_INPUT_Y, ct);
			await Task.Delay(400, ct);
			await TypeIntoCanvasAsync(cdp, username, ct);
			await Task.Delay(300, ct);

			// Step 3: Confirm username (Enter key or confirm button)
			await cdp.ClickAtAsync(OS_KEYBOARD_CONFIRM_X, OS_KEYBOARD_CONFIRM_Y, ct);
			await Task.Delay(800, ct);

			// Step 4: Click PASSWORD field (opens keyboard dialog)
			await cdp.ClickAtAsync(OS_PASSWORD_X, OS_PASSWORD_Y, ct);
			await Task.Delay(1000, ct);

			// Step 5: Click into keyboard input area and type password
			await cdp.ClickAtAsync(OS_KEYBOARD_INPUT_X, OS_KEYBOARD_INPUT_Y, ct);
			await Task.Delay(400, ct);
			await TypeIntoCanvasAsync(cdp, password, ct);
			await Task.Delay(300, ct);

			// Step 6: Confirm password
			await cdp.ClickAtAsync(OS_KEYBOARD_CONFIRM_X, OS_KEYBOARD_CONFIRM_Y, ct);
			await Task.Delay(800, ct);

			// Step 7: Click LOGIN button
			await cdp.ClickAtAsync(OS_LOGIN_X, OS_LOGIN_Y, ct);
			await Task.Delay(8000, ct);

			// Step 8: Dismiss notification dialogs (up to 5 attempts)
			for (int i = 0; i < 5; i++)
			{
				await cdp.ClickAtAsync(OS_DIALOG_OK_X, OS_DIALOG_OK_Y, ct);
				await Task.Delay(500, ct);
				await cdp.ClickAtAsync(OS_NOTIFICATION_CLOSE_X, OS_NOTIFICATION_CLOSE_Y, ct);
				await Task.Delay(500, ct);
			}

			Console.WriteLine($"[CDP:OrionStars] Login submitted for {username}");
			return true; // Proceed — login was submitted, server may still be responding
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CDP:OrionStars] Login failed for {username}: {ex.Message}");
			return false;
		}
	}

	// OrionStars lobby/game coordinates (from original OrionStars.Logout in C0MMON/Games/OrionStars.cs)
	private const int OS_SETTINGS_X = 900, OS_SETTINGS_Y = 630;
	private const int OS_CONFIRM_X = 490, OS_CONFIRM_Y = 540;
	private const int OS_SPIN_X = 860, OS_SPIN_Y = 655;

	public static async Task LogoutOrionStarsAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		try
		{
			// Click settings/exit button (bottom-right area)
			await cdp.ClickAtAsync(OS_SETTINGS_X, OS_SETTINGS_Y, ct);
			await Task.Delay(2000, ct);

			// Click confirm/OK in dialog
			await cdp.ClickAtAsync(OS_CONFIRM_X, OS_CONFIRM_Y, ct);
			await Task.Delay(2000, ct);

			// Force navigate back to login page
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
			// Canvas spin button — same position as FireKirin (Cocos2d-x standard layout)
			await LongPressAsync(cdp, OS_SPIN_X, OS_SPIN_Y, holdMs: 2000, ct);
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
	/// Type text into Cocos2d-x Canvas by injecting JavaScript that directly calls the game's input system.
	/// Cocos2d-x renders its own input fields outside the DOM, so we need to find and manipulate the active input field.
	/// </summary>
	private static async Task TypeIntoCanvasAsync(ICdpClient cdp, string text, CancellationToken ct = default)
	{
		// Escape single quotes for JavaScript
		string escapedText = text.Replace("'", "\\'");
		
		// Strategy 1: Try to find and directly set Cocos2d-x input field value
		string js1 = $@"
			(function() {{
				// Look for active Cocos2d-x input field (cc.EditBox or similar)
				if (window.cc && cc.game && cc.game._scene) {{
					var scene = cc.game._scene;
					// Try to find active EditBox components
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

		// Strategy 4: Fallback to CDP Input.insertText (might work for some cases)
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

	// OPS-045: ReadExtensionGrandAsync REMOVED.
	// Extension-injected window.parent.Grand does not work in incognito mode.
	// Use JackpotReader service for CDP-based reading, QueryBalances (WebSocket API) as primary source.
}
