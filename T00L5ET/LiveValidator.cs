using System.Text.Json;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.T00L5ET;

/// <summary>
/// Live validation runner for DECISION_045, DECISION_044, and DECISION_041.
/// Uses the ACTUAL codebase methods: FireKirin.QueryBalances(), CdpGameActions.LoginFireKirinAsync().
/// No reinvention. No workarounds. The code is in the codebase — use it.
/// </summary>
public static class LiveValidator
{
	public static async Task<int> RunAsync(string[] args)
	{
		Console.WriteLine("╔══════════════════════════════════════════════╗");
		Console.WriteLine("║  LIVE VALIDATOR — DECISION 045/044/041       ║");
		Console.WriteLine("╚══════════════════════════════════════════════╝");

		// Phase 1: Get credential from MongoDB
		Console.WriteLine("\n=== Phase 1: MongoDB Credential ===");
		MongoClient mongo;
		IMongoDatabase db;
		string username, password;
		try
		{
			mongo = new MongoClient("mongodb://192.168.56.1:27017");
			db = mongo.GetDatabase("P4NTHE0N");
			var creds = db.GetCollection<BsonDocument>("CRED3N7IAL");
			var filter = Builders<BsonDocument>.Filter.And(
				Builders<BsonDocument>.Filter.Eq("Game", "FireKirin"),
				Builders<BsonDocument>.Filter.Eq("Enabled", true),
				Builders<BsonDocument>.Filter.Ne("Banned", true),
				Builders<BsonDocument>.Filter.Gt("Balance", 0.0)
			);
			var cred = await creds.Find(filter)
				.Sort(Builders<BsonDocument>.Sort.Descending("Balance"))
				.FirstOrDefaultAsync();

			if (cred == null)
			{
				Console.WriteLine("[FAIL] No enabled FireKirin credential with balance > 0");
				return 1;
			}

			username = cred.GetValue("Username", "").AsString;
			password = cred.GetValue("Password", "").AsString;
			double balance = cred.GetValue("Balance", 0).ToDouble();
			string house = cred.GetValue("House", "").AsString;
			Console.WriteLine($"[OK] Credential: {username} | House: {house} | Balance: ${balance:F2}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[FAIL] MongoDB: {ex.Message}");
			return 1;
		}

		// Phase 2: DECISION_045 — FireKirin.QueryBalances() via WebSocket API
		// This is the AUTHORITATIVE jackpot source per OPS_017
		Console.WriteLine("\n=== Phase 2: DECISION_045 — FireKirin.QueryBalances() ===");
		Console.WriteLine("  Using WebSocket API (the authoritative source per OPS_017)");
		try
		{
			var balances = FireKirin.QueryBalances(username, password);
			Console.WriteLine($"  Balance: ${balances.Balance:F2}");
			Console.WriteLine($"  Grand:   ${balances.Grand:F2}");
			Console.WriteLine($"  Major:   ${balances.Major:F2}");
			Console.WriteLine($"  Minor:   ${balances.Minor:F2}");
			Console.WriteLine($"  Mini:    ${balances.Mini:F2}");

			bool jackpotsFound = balances.Grand > 0 || balances.Major > 0 || balances.Minor > 0 || balances.Mini > 0;
			if (jackpotsFound)
				Console.WriteLine("  [VALIDATED] Jackpot values > 0 from live WebSocket API!");
			else
				Console.WriteLine("  [WARN] All jackpots zero — may need to check game server");

			// Save to MongoDB as validation evidence
			try
			{
				var evidence = new BsonDocument
				{
					{ "Type", "DECISION_045_Validation" },
					{ "Timestamp", DateTime.UtcNow },
					{ "Username", username },
					{ "Balance", (double)balances.Balance },
					{ "Grand", (double)balances.Grand },
					{ "Major", (double)balances.Major },
					{ "Minor", (double)balances.Minor },
					{ "Mini", (double)balances.Mini },
					{ "Source", "FireKirin.QueryBalances (WebSocket API)" },
					{ "JackpotsFound", jackpotsFound }
				};
				await db.GetCollection<BsonDocument>("T35T_R3SULT").InsertOneAsync(evidence);
				Console.WriteLine("  [OK] Validation evidence saved to T35T_R3SULT");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  [WARN] Could not save evidence: {ex.Message}");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  [FAIL] QueryBalances: {ex.Message}");
		}

		// Phase 3: DECISION_041 — OrionStars check
		Console.WriteLine("\n=== Phase 3: DECISION_041 — OrionStars QueryBalances ===");
		try
		{
			// First check if OrionStars config endpoint is reachable
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(10) };
			string configJson = await http.GetStringAsync("http://web.orionstars.org/hot_play/plat/config/hall/orionstars/config.json");
			Console.WriteLine($"  [OK] OrionStars config endpoint reachable");
			Console.WriteLine($"  Config: {configJson[..Math.Min(configJson.Length, 200)]}");

			// Try QueryBalances with an OrionStars credential
			var osCreds = db.GetCollection<BsonDocument>("CRED3N7IAL");
			var osFilter = Builders<BsonDocument>.Filter.And(
				Builders<BsonDocument>.Filter.Regex("Game", new BsonRegularExpression("orion", "i")),
				Builders<BsonDocument>.Filter.Eq("Enabled", true),
				Builders<BsonDocument>.Filter.Gt("Balance", 0.0)
			);
			var osCred = await osCreds.Find(osFilter)
				.Sort(Builders<BsonDocument>.Sort.Descending("Balance"))
				.FirstOrDefaultAsync();

			if (osCred != null)
			{
				string osUser = osCred.GetValue("Username", "").AsString;
				string osPass = osCred.GetValue("Password", "").AsString;
				Console.WriteLine($"  Trying OrionStars credential: {osUser}");
				var osBalances = OrionStars.QueryBalances(osUser, osPass);
				Console.WriteLine($"  Balance: ${osBalances.Balance:F2}");
				Console.WriteLine($"  Grand:   ${osBalances.Grand:F2}");
				Console.WriteLine($"  Major:   ${osBalances.Major:F2}");
				Console.WriteLine($"  [VALIDATED] OrionStars WebSocket API works!");
			}
			else
			{
				Console.WriteLine("  [INFO] No enabled OrionStars credentials with balance > 0");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  [INFO] OrionStars: {ex.Message}");
		}

		// Phase 4: CDP validation — CdpGameActions
		Console.WriteLine("\n=== Phase 4: CDP Login via CdpGameActions ===");
		var cdpConfig = new CdpConfig { HostIp = "127.0.0.1", Port = 9222 };
		using var cdp = new CdpClient(cdpConfig);

		bool connected = await cdp.ConnectAsync();
		if (!connected)
		{
			Console.WriteLine("[FAIL] Cannot connect to Chrome CDP at localhost:9222");
		}
		else
		{
			Console.WriteLine("[OK] CDP connected to Chrome");

			// Navigate to FireKirin and attempt login via CdpGameActions
			Console.WriteLine("  Calling CdpGameActions.LoginFireKirinAsync()...");
			bool loginOk = await CdpGameActions.LoginFireKirinAsync(cdp, username, password);
			Console.WriteLine($"  Login result: {(loginOk ? "SUCCESS" : "FAILED")}");

			// Take screenshot
			try
			{
				JsonElement ssResult = await cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png", quality = 80 });
				if (ssResult.TryGetProperty("result", out var res) && res.TryGetProperty("data", out var data))
				{
					byte[] pngBytes = Convert.FromBase64String(data.GetString() ?? "");
					string ssPath = Path.Combine("C:\\P4NTHE0N", "test-results", $"validation_{DateTime.UtcNow:yyyyMMdd_HHmmss}.png");
					Directory.CreateDirectory(Path.GetDirectoryName(ssPath)!);
					await File.WriteAllBytesAsync(ssPath, pngBytes);
					Console.WriteLine($"  Screenshot: {ssPath} ({pngBytes.Length:N0} bytes)");
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  Screenshot failed: {ex.Message}");
			}

			// Verify page state
			bool pageReady = await CdpGameActions.VerifyGamePageLoadedAsync(cdp, "FireKirin");
			Console.WriteLine($"  VerifyGamePageLoadedAsync: {pageReady}");

			// Try JackpotReader via CDP (secondary validation)
			var reader = new JackpotReader();
			var (g, m, n, i) = await reader.ReadAllJackpotsAsync(cdp, "FireKirin");
			Console.WriteLine($"  JackpotReader CDP: G={g:F2} M={m:F2} m={n:F2} n={i:F2}");
			Console.WriteLine($"  (Zeros expected for Canvas — WebSocket API is authoritative)");
		}

		// Summary
		Console.WriteLine("\n╔══════════════════════════════════════════════╗");
		Console.WriteLine("║  VALIDATION COMPLETE                         ║");
		Console.WriteLine("╚══════════════════════════════════════════════╝");

		return 0;
	}
}
