using System.Text.Json;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.T00L5ET;

/// <summary>
/// Diagnose why FireKirin login gets "server busy" on every credential.
/// Checks: cookies, storage, WebSocket connections, network errors, security state.
/// </summary>
public static class CdpDiagnostic
{
	public static async Task RunAsync()
	{
		Console.WriteLine("\n=== CDP Network Diagnostic ===\n");

		var cdpConfig = new CdpConfig { HostIp = "127.0.0.1", Port = 9222 };
		using var cdp = new CdpClient(cdpConfig);
		if (!await cdp.ConnectAsync())
		{
			Console.WriteLine("[FAIL] CDP connect failed");
			return;
		}

		// 1. Current page state
		string? url = await cdp.EvaluateAsync<string>("window.location.href");
		Console.WriteLine($"[1] URL: {url}");

		// 2. Check cookies for firekirin domain
		Console.WriteLine("\n[2] Cookies for firekirin:");
		var cookieResult = await cdp.SendCommandAsync("Network.getCookies", new { urls = new[] { "http://play.firekirin.in", "https://play.firekirin.in" } });
		if (cookieResult.TryGetProperty("result", out var cookieRes) && cookieRes.TryGetProperty("cookies", out var cookies))
		{
			Console.WriteLine($"  Cookie count: {cookies.GetArrayLength()}");
			foreach (var c in cookies.EnumerateArray())
			{
				string name = c.GetProperty("name").GetString() ?? "";
				string value = c.GetProperty("value").GetString() ?? "";
				string domain = c.GetProperty("domain").GetString() ?? "";
				bool secure = c.TryGetProperty("secure", out var s) && s.GetBoolean();
				bool httpOnly = c.TryGetProperty("httpOnly", out var h) && h.GetBoolean();
				Console.WriteLine($"  {name}={value[..Math.Min(value.Length, 30)]} | domain={domain} secure={secure} httpOnly={httpOnly}");
			}
		}

		// 3. Check if third-party cookies are blocked
		Console.WriteLine("\n[3] Browser storage state:");
		string? storageTest = await cdp.EvaluateAsync<string>(@"
			try {
				localStorage.setItem('_test', '1');
				var ls = localStorage.getItem('_test');
				localStorage.removeItem('_test');
				var ss = sessionStorage.length;
				return 'localStorage: OK, sessionStorage items: ' + ss;
			} catch(e) {
				return 'Storage ERROR: ' + e.message;
			}
		");
		Console.WriteLine($"  {storageTest}");

		// 4. Fetch game config and test WebSocket
		Console.WriteLine("\n[4] FireKirin config + WebSocket test:");
		string bsIp = "", gameProto = "";
		int wsPort = 0;
		try
		{
			using var http = new System.Net.Http.HttpClient { Timeout = TimeSpan.FromSeconds(10) };
			string configJson = await http.GetStringAsync("http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json");
			Console.WriteLine($"  Raw config: {configJson[..Math.Min(configJson.Length, 300)]}");
			using var doc = JsonDocument.Parse(configJson);
			var root = doc.RootElement;
			foreach (var prop in root.EnumerateObject())
				Console.WriteLine($"  {prop.Name}: {prop.Value}");
			bsIp = root.TryGetProperty("bsIp", out var bi) ? bi.GetString() ?? "" : "";
			wsPort = root.TryGetProperty("wsPort", out var wp) ? (wp.ValueKind == JsonValueKind.Number ? wp.GetInt32() : int.Parse(wp.GetString() ?? "0")) : 0;
			gameProto = root.TryGetProperty("gameProtocol", out var gp) ? gp.GetString() ?? "ws://" : "ws://";
			Console.WriteLine($"\n  WS target: {gameProto}{bsIp}:{wsPort}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  Config fetch: {ex.Message}");
		}

		// 4b. Test WebSocket from the browser context
		if (!string.IsNullOrEmpty(bsIp))
		{
			string wsUrl = $"{gameProto}{bsIp}:{wsPort}";
			Console.WriteLine($"\n  Testing WS from browser to {wsUrl}:");
			string? wsTest = await cdp.EvaluateAsync<string>($@"
				new Promise(function(resolve) {{
					try {{
						var ws = new WebSocket('{wsUrl}', 'wl');
						ws.onopen = function() {{ resolve('OPEN readyState=' + ws.readyState); ws.close(); }};
						ws.onerror = function(e) {{ resolve('ERROR type=' + e.type); }};
						ws.onclose = function(e) {{ resolve('CLOSED code=' + e.code + ' reason=' + e.reason + ' wasClean=' + e.wasClean); }};
						setTimeout(function() {{ resolve('TIMEOUT readyState=' + ws.readyState); }}, 5000);
					}} catch(e) {{
						resolve('EXCEPTION: ' + e.message);
					}}
				}})
			");
			Console.WriteLine($"  Result: {wsTest}");

			// Also try wss:// in case server supports it
			string wssUrl = wsUrl.Replace("ws://", "wss://");
			Console.WriteLine($"\n  Testing WSS from browser to {wssUrl}:");
			string? wssTest = await cdp.EvaluateAsync<string>($@"
				new Promise(function(resolve) {{
					try {{
						var ws = new WebSocket('{wssUrl}', 'wl');
						ws.onopen = function() {{ resolve('OPEN readyState=' + ws.readyState); ws.close(); }};
						ws.onerror = function(e) {{ resolve('ERROR type=' + e.type); }};
						ws.onclose = function(e) {{ resolve('CLOSED code=' + e.code + ' reason=' + e.reason + ' wasClean=' + e.wasClean); }};
						setTimeout(function() {{ resolve('TIMEOUT readyState=' + ws.readyState); }}, 5000);
					}} catch(e) {{
						resolve('EXCEPTION: ' + e.message);
					}}
				}})
			");
			Console.WriteLine($"  Result: {wssTest}");
		}

		// 4c. Try allowing insecure content via CDP
		Console.WriteLine("\n[4c] Enabling insecure content via CDP:");
		try
		{
			await cdp.SendCommandAsync("Security.setIgnoreCertificateErrors", new { ignore = true });
			Console.WriteLine("  Security.setIgnoreCertificateErrors: OK");
		}
		catch (Exception ex) { Console.WriteLine($"  Security: {ex.Message}"); }

		// 4d. Check Chrome launch flags
		Console.WriteLine("\n[4d] Chrome user agent + flags:");
		string? ua = await cdp.EvaluateAsync<string>("navigator.userAgent");
		Console.WriteLine($"  UA: {ua}");
		var browserInfo = await cdp.SendCommandAsync("Browser.getVersion");
		if (browserInfo.TryGetProperty("result", out var bInfo))
			Console.WriteLine($"  Browser: {bInfo}");

		// 5. Check existing WebSocket connections on the page
		Console.WriteLine("\n[5] Page JS globals (login/network related):");
		string? globals = await cdp.EvaluateAsync<string>(@"
			var keys = Object.keys(window).filter(k => 
				k.toLowerCase().includes('net') || 
				k.toLowerCase().includes('ws') || 
				k.toLowerCase().includes('socket') || 
				k.toLowerCase().includes('login') ||
				k.toLowerCase().includes('config') ||
				k === 'cc' || k === 'BsNet'
			);
			keys.slice(0, 30).join(', ')
		");
		Console.WriteLine($"  {globals}");

		// 6. Check if the game's own WS is connected
		string? gameWs = await cdp.EvaluateAsync<string>(@"
			try {
				var nets = Object.keys(window).filter(k => window[k] && window[k].readyState !== undefined && typeof window[k].send === 'function');
				if (nets.length > 0) return 'Found WS objects: ' + nets.join(', ');
				// Check for BsNet or similar
				if (typeof BsNet !== 'undefined') return 'BsNet exists: ' + typeof BsNet;
				if (typeof loginNetOpen !== 'undefined') return 'loginNetOpen: ' + typeof loginNetOpen;
				return 'No active WS found';
			} catch(e) { return 'Error: ' + e.message; }
		");
		Console.WriteLine($"  Game WS: {gameWs}");

		// 7. Check security state
		Console.WriteLine("\n[6] Security / mixed content:");
		string? securityInfo = await cdp.EvaluateAsync<string>(@"
			'protocol=' + location.protocol + 
			' secure=' + (location.protocol === 'https:') +
			' mixed_blocked=' + (typeof window.isSecureContext !== 'undefined' ? window.isSecureContext : 'unknown')
		");
		Console.WriteLine($"  {securityInfo}");

		// 8. Try navigating to HTTP (not HTTPS) and check redirect
		Console.WriteLine("\n[7] HTTP vs HTTPS redirect test:");
		Console.WriteLine("  Navigating to HTTP...");
		await cdp.NavigateAsync("http://play.firekirin.in/web_mobile/firekirin/");
		await Task.Delay(3000);
		string? afterNav = await cdp.EvaluateAsync<string>("window.location.href + ' | protocol=' + window.location.protocol");
		Console.WriteLine($"  After nav: {afterNav}");

		// 9. Console errors
		Console.WriteLine("\n[8] Checking for JS errors via console:");
		string? errors = await cdp.EvaluateAsync<string>(@"
			window._consoleErrors = window._consoleErrors || [];
			var origError = console.error;
			console.error = function() { 
				window._consoleErrors.push(Array.from(arguments).join(' ')); 
				origError.apply(console, arguments); 
			};
			window._consoleErrors.length + ' errors: ' + window._consoleErrors.slice(-3).join(' | ')
		");
		Console.WriteLine($"  {errors}");

		Console.WriteLine("\n=== Diagnostic Complete ===");
	}
}
