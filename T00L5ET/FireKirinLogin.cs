using System.Text.Json;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.T00L5ET;

/// <summary>
/// FireKirin Canvas login via CDP + WebSocket interception for jackpot values.
/// No Chrome extension needed — CDP gives us full DevTools access.
///
/// Login: Cocos2d-x Canvas clicks + hidden input typing (like original FireKirin.Login)
/// Jackpots: CDP Network.enable captures WebSocket frames with mainID=100/subID=120
/// </summary>
public static class FireKirinLogin
{
	// URL from codebase: C0MMON/Games/FireKirin.cs line 41, CdpGameActions.cs line 18
	private const string FireKirinUrl = "http://play.firekirin.in/web_mobile/firekirin/";

	public static async Task<bool> LoginAsync(CdpClient cdp, IMongoDatabase db)
	{
		Console.WriteLine("\n=== FireKirin CDP Login ===");

		// Enable Network + inject WebSocket interceptor BEFORE page load
		Console.WriteLine("\n  --- Enabling WebSocket interception ---");
		await cdp.SendCommandAsync("Network.enable");

		// Inject interceptor that runs before ANY page JS — catches WebSocket from the start
		await cdp.SendCommandAsync("Page.addScriptToEvaluateOnNewDocument", new { source = @"
			window._wsFrames = [];
			window._wsJackpots = {};
			(function() {
				var origSend = WebSocket.prototype.send;
				WebSocket.prototype.send = function(data) {
					try { window._wsFrames.push({dir:'out', data: typeof data === 'string' ? data : 'binary', t: Date.now()}); } catch(e) {}
					return origSend.apply(this, arguments);
				};
				var origWS = window.WebSocket;
				window.WebSocket = function(url, protocols) {
					var ws = protocols ? new origWS(url, protocols) : new origWS(url);
					ws.addEventListener('message', function(e) {
						try {
							window._wsFrames.push({dir:'in', data: e.data, t: Date.now()});
							var msg = JSON.parse(e.data);
							if (msg.mainID === 100 && msg.subID === 120 && msg.data) {
								window._wsJackpots = {
									grand: (msg.data.grand || 0) / 100,
									major: (msg.data.major || 0) / 100,
									minor: (msg.data.minor || 0) / 100,
									mini: (msg.data.mini || 0) / 100,
									ts: Date.now()
								};
							}
							if (msg.mainID === 100 && msg.subID === 116 && msg.data) {
								window._wsLoginResult = {
									result: msg.data.result,
									score: (msg.data.score || 0) / 100,
									bossid: msg.data.bossid,
									msg: msg.data.msg || '',
									ts: Date.now()
								};
							}
						} catch(e) {}
					});
					window._lastWS = ws;
					return ws;
				};
				window.WebSocket.prototype = origWS.prototype;
				window.WebSocket.CONNECTING = origWS.CONNECTING;
				window.WebSocket.OPEN = origWS.OPEN;
				window.WebSocket.CLOSING = origWS.CLOSING;
				window.WebSocket.CLOSED = origWS.CLOSED;
			})();
		" });
		Console.WriteLine("  [OK] WebSocket interceptor registered for new documents");

		// Cycle through credentials — log failures, move to next
		var failLog = new List<(string Username, string Reason, DateTime Time)>();
		const int maxCredentials = 10;

		for (int credIdx = 0; credIdx < maxCredentials; credIdx++)
		{
			var cred = await GetCredentialAsync(db, credIdx);
			if (cred == null)
			{
				Console.WriteLine($"  No more credentials (tried {credIdx})");
				break;
			}

			string username = cred.GetValue("Username", "").AsString;
			string password = cred.GetValue("Password", "").AsString;
			string house = cred.GetValue("House", "").AsString;
			double balance = cred.GetValue("Balance", 0).ToDouble();
			Console.WriteLine($"\n  === Credential {credIdx + 1}: {username} | {house} | ${balance:F2} ===");

			// Reload page fresh for each credential
			await cdp.NavigateAsync(FireKirinUrl);
			await Task.Delay(5000);

			// Type credentials into Canvas
			await cdp.ClickAtAsync(460, 367);
			await Task.Delay(600);
			await TypeIntoCanvas(cdp, username);
			await Task.Delay(300);

			await cdp.ClickAtAsync(460, 437);
			await Task.Delay(600);
			await TypeIntoCanvas(cdp, password);
			await Task.Delay(300);

			// Click LOGIN
			await cdp.ClickAtAsync(553, 567);
			await Task.Delay(8000);

			await SaveScreenshot(cdp, $"cred_{credIdx + 1}_{username}");

			// Check results
			string? wsLoginResult = await cdp.EvaluateAsync<string>("JSON.stringify(window._wsLoginResult || 'none')");
			int? wsFrameCount = await cdp.EvaluateAsync<int>("(window._wsFrames || []).length");
			double? parentGrand = await cdp.EvaluateAsync<double>("Number(window.parent.Grand) || 0");

			Console.WriteLine($"  WS frames: {wsFrameCount} | Login: {wsLoginResult} | Grand: {parentGrand}");

			bool loggedIn = parentGrand > 0
				|| (wsLoginResult != null && wsLoginResult != "\"none\"" && !wsLoginResult.Contains("\"result\":3"));

			if (loggedIn)
			{
				Console.WriteLine($"\n  [OK] Login SUCCESS with {username}!");
				string? lastFrames = await cdp.EvaluateAsync<string>(
					"(window._wsFrames || []).slice(-10).map(f => f.dir + ':' + (f.data||'').substring(0,120)).join('\\n')"
				);
				Console.WriteLine($"  WS frames:\n{lastFrames}");

				// Log all failures for the record
				if (failLog.Count > 0) LogFailures(failLog);
				return true;
			}

			// Log failure and move on
			string reason = wsLoginResult != null && wsLoginResult != "\"none\""
				? wsLoginResult
				: "Server busy / no WS response";
			failLog.Add((username, reason, DateTime.UtcNow));
			Console.WriteLine($"  [FAIL] {username}: {reason} — moving to next credential");
		}

		// All credentials exhausted
		Console.WriteLine($"\n  [FAIL] All credentials failed ({failLog.Count} tried)");
		LogFailures(failLog);
		await SaveScreenshot(cdp, "all_failed");
		return false;
	}

	private static async Task TypeIntoCanvas(CdpClient cdp, string text)
	{
		// Check if Cocos2d-x created a hidden text input
		bool? hasTextInput = await cdp.EvaluateAsync<bool>(
			"document.querySelectorAll('input:not([type=image]):not([type=hidden]),textarea').length > 0"
		);
		if (hasTextInput == true)
		{
			// Set value directly on the hidden input
			await cdp.EvaluateAsync<object>($@"
				var inp = document.querySelector('input:not([type=image]):not([type=hidden]),textarea');
				if (inp) {{ inp.value = '{text}'; inp.dispatchEvent(new Event('input', {{bubbles:true}})); }}
			");
			await cdp.SendCommandAsync("Input.dispatchKeyEvent", new { type = "rawKeyDown", windowsVirtualKeyCode = 13, key = "Enter", code = "Enter" });
			await Task.Delay(50);
			await cdp.SendCommandAsync("Input.dispatchKeyEvent", new { type = "keyUp", windowsVirtualKeyCode = 13, key = "Enter", code = "Enter" });
		}
		else
		{
			// Type character by character — Canvas receives these as keyboard events
			foreach (char c in text)
			{
				await cdp.SendCommandAsync("Input.dispatchKeyEvent", new { type = "char", text = c.ToString() });
				await Task.Delay(40);
			}
		}
	}

	private static void LogFailures(List<(string Username, string Reason, DateTime Time)> failures)
	{
		string logPath = Path.Combine("C:\\P4NTH30N", "test-results", "login_failures.log");
		Directory.CreateDirectory(Path.GetDirectoryName(logPath)!);
		var lines = failures.Select(f => $"{f.Time:yyyy-MM-dd HH:mm:ss} | {f.Username} | {f.Reason}");
		File.AppendAllLines(logPath, lines);
		Console.WriteLine($"\n  --- Failed Credentials Log ({failures.Count} entries) → {logPath} ---");
		foreach (var f in failures)
			Console.WriteLine($"  {f.Time:HH:mm:ss} {f.Username}: {f.Reason}");
	}

	private static async Task<BsonDocument?> GetCredentialAsync(IMongoDatabase db, int skip = 0)
	{
		var creds = db.GetCollection<BsonDocument>("CRED3N7IAL");
		var filter = Builders<BsonDocument>.Filter.And(
			Builders<BsonDocument>.Filter.Eq("Game", "FireKirin"),
			Builders<BsonDocument>.Filter.Eq("Enabled", true),
			Builders<BsonDocument>.Filter.Ne("Banned", true),
			Builders<BsonDocument>.Filter.Gt("Balance", 0.0)
		);
		var results = await creds.Find(filter)
			.Sort(Builders<BsonDocument>.Sort.Descending("Balance"))
			.Skip(skip)
			.Limit(1)
			.ToListAsync();
		if (results.Count == 0)
		{
			Console.WriteLine($"  [FAIL] No enabled FireKirin credential found (skip={skip})");
			return null;
		}
		return results[0];
	}

	private static async Task SaveScreenshot(CdpClient cdp, string label)
	{
		try
		{
			JsonElement ssResult = await cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png", quality = 80 });
			if (ssResult.TryGetProperty("result", out var res) && res.TryGetProperty("data", out var data))
			{
				byte[] bytes = Convert.FromBase64String(data.GetString() ?? "");
				string path = Path.Combine("C:\\P4NTH30N", "test-results", $"fk_{label}_{DateTime.UtcNow:yyyyMMdd_HHmmss}.png");
				Directory.CreateDirectory(Path.GetDirectoryName(path)!);
				await File.WriteAllBytesAsync(path, bytes);
				Console.WriteLine($"  Screenshot: {path} ({bytes.Length:N0} bytes)");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  Screenshot failed: {ex.Message}");
		}
	}
}
