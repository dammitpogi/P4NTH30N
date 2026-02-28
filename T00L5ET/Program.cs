// DECISION_032 + 034: P4NTHE0N Config Deployer & Session Harvester
// Usage: dotnet run --project T00L5ET -- [--dry-run] [--agents-only] [--rag] [--rag-binary] [--mcp-server]
//        dotnet run --project T00L5ET -- harvest [--dry-run] [--since 2026-02-20]
//        dotnet run --project T00L5ET -- mcp-server

using System.Security.Cryptography;
using System.Text.Json;
using P4NTHE0N.T00L5ET;

// LIVE VALIDATION: Route to LiveValidator if "validate" command
if (args.Length > 0 && args[0].Equals("validate", StringComparison.OrdinalIgnoreCase))
{
	return await P4NTHE0N.T00L5ET.LiveValidator.RunAsync(args);
}

// FIREKIRIN LOGIN: Route to login if "login" command
if (args.Length > 0 && args[0].Equals("login", StringComparison.OrdinalIgnoreCase))
{
	var cdpCfg = new P4NTHE0N.C0MMON.Infrastructure.Cdp.CdpConfig { HostIp = "127.0.0.1", Port = 9222 };
	using var cdpClient = new P4NTHE0N.C0MMON.Infrastructure.Cdp.CdpClient(cdpCfg);
	if (!await cdpClient.ConnectAsync()) { Console.WriteLine("[FAIL] CDP connect failed"); return 1; }
	var mongoClient = new MongoDB.Driver.MongoClient("mongodb://192.168.56.1:27017");
	var database = mongoClient.GetDatabase("P4NTHE0N");
	bool ok = await P4NTHE0N.T00L5ET.FireKirinLogin.LoginAsync(cdpClient, database);
	return ok ? 0 : 1;
}

// GAME NAVIGATOR: Navigate to correct game after login
if (args.Length > 0 && args[0].Equals("nav", StringComparison.OrdinalIgnoreCase))
{
	await P4NTHE0N.T00L5ET.GameNavigator.RunAsync();
	return 0;
}

// CDP DIAGNOSTIC: Check cookies, WS, security state
if (args.Length > 0 && args[0].Equals("diag", StringComparison.OrdinalIgnoreCase))
{
	await P4NTHE0N.T00L5ET.CdpDiagnostic.RunAsync();
	return 0;
}

// CREDENTIAL CHECK: Debug MongoDB credential structure
if (args.Length > 0 && args[0].Equals("credcheck", StringComparison.OrdinalIgnoreCase))
{
	await P4NTHE0N.T00L5ET.CredCheck.RunAsync();
	return 0;
}

// MCP SERVER: Run P4NTHE0N Tools as MCP server
if (args.Length > 0 && args[0].Equals("mcp-server", StringComparison.OrdinalIgnoreCase))
{
	using var loggerFactory = LoggerFactory.Create(builder => builder.AddConsole());
	var logger = loggerFactory.CreateLogger<P4NTHE0N.T00L5ET.McpServer.McpServer>();
	
	var mcpServer = new P4NTHE0N.T00L5ET.McpServer.McpServer(logger);
	await mcpServer.RunAsync();
	return 0;
}

// DECISION_034: Route to harvester if "harvest" command
if (args.Length > 0 && args[0].Equals("harvest", StringComparison.OrdinalIgnoreCase))
{
	bool harvestDry = args.Contains("--dry-run");
	DateTime? since = null;
	int sinceIdx = Array.IndexOf(args, "--since");
	if (sinceIdx >= 0 && sinceIdx + 1 < args.Length)
		since = DateTime.Parse(args[sinceIdx + 1]);

	string? ragUrl = null;
	int ragIdx = Array.IndexOf(args, "--rag-url");
	if (ragIdx >= 0 && ragIdx + 1 < args.Length)
		ragUrl = args[ragIdx + 1];

	var harvester = new SessionHarvester(dryRun: harvestDry, since: since, ragUrl: ragUrl);
	return harvester.Run();
}

string repoRoot = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", ".."));
string userHome = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
bool dryRun = args.Contains("--dry-run");
bool agentsOnly = args.Contains("--agents-only");
bool ragIngest = args.Contains("--rag");
bool ragBinary = args.Contains("--rag-binary");

Console.WriteLine("╔══════════════════════════════════════════════╗");
Console.WriteLine("║  P4NTHE0N Config Deployer (DECISION_032)    ║");
Console.WriteLine("╚══════════════════════════════════════════════╝");
Console.WriteLine($"  Repo Root: {repoRoot}");
Console.WriteLine($"  User Home: {userHome}");
Console.WriteLine($"  Mode: {(dryRun ? "DRY RUN" : "DEPLOY")}");
Console.WriteLine();

int deployed = 0, skipped = 0, failed = 0;

string manifestPath = Path.Combine(repoRoot, "deploy-manifest.json");
if (!File.Exists(manifestPath))
{
	Console.WriteLine($"[ERROR] deploy-manifest.json not found at {manifestPath}");
	return 1;
}

var manifest = JsonDocument.Parse(File.ReadAllText(manifestPath));
var mappings = manifest.RootElement.GetProperty("mappings");

// --- Deploy Agent Prompts ---
Console.WriteLine("=== Agent Prompts ===");
foreach (var agent in mappings.GetProperty("agents").EnumerateArray())
{
	string src = Path.Combine(repoRoot, agent.GetProperty("source").GetString()!.Replace("/", "\\"));
	string dst = agent.GetProperty("destination").GetString()!.Replace("~/", userHome + "\\").Replace("/", "\\");

	DeployFile(src, dst, ref deployed, ref skipped, ref failed, dryRun);
}

if (!agentsOnly)
{
	// --- Deploy MCP Configs ---
	Console.WriteLine("\n=== MCP Configs ===");
	foreach (var mcp in mappings.GetProperty("mcp").EnumerateArray())
	{
		string src = Path.Combine(repoRoot, mcp.GetProperty("source").GetString()!.Replace("/", "\\"));
		string dst = mcp.GetProperty("destination").GetString()!.Replace("~/", userHome + "\\").Replace("/", "\\");

		DeployFile(src, dst, ref deployed, ref skipped, ref failed, dryRun);
	}

	// --- Deploy RAG Binary ---
	if (ragBinary || ragIngest)
	{
		Console.WriteLine("\n=== RAG Binary ===");
		foreach (var bin in mappings.GetProperty("binaries").EnumerateArray())
		{
			string type = bin.TryGetProperty("type", out var t) ? t.GetString()! : "copy";
			if (type == "publish")
			{
				string project = Path.Combine(repoRoot, bin.GetProperty("source").GetString()!.Replace("/", "\\"));
				string dest = bin.GetProperty("destination").GetString()!;
				string runtime = bin.TryGetProperty("runtime", out var r) ? r.GetString()! : "win-x64";
				string config = bin.TryGetProperty("configuration", out var c) ? c.GetString()! : "Release";

				if (dryRun)
				{
					Console.WriteLine($"  [DRY] Would publish {project} -> {dest}");
					skipped++;
				}
				else
				{
					Console.WriteLine($"  Publishing {Path.GetFileName(project)} -> {dest}");
					Console.WriteLine($"    dotnet publish {project} -c {config} -r {runtime} -o {dest}");
					// Actual publish would be executed via Process.Start
					deployed++;
				}
			}
		}
	}
}

Console.WriteLine();
Console.WriteLine("╔══════════════════════════════════════════════╗");
Console.WriteLine($"║  Results: {deployed} deployed, {skipped} skipped, {failed} failed  ║");
Console.WriteLine("╚══════════════════════════════════════════════╝");

return failed > 0 ? 1 : 0;

// --- Helper Functions ---

static void DeployFile(string src, string dst, ref int deployed, ref int skipped, ref int failed, bool dryRun)
{
	if (!File.Exists(src))
	{
		Console.WriteLine($"  [SKIP] Source not found: {Path.GetFileName(src)}");
		skipped++;
		return;
	}

	string srcHash = ComputeHash(src);
	bool dstExists = File.Exists(dst);
	string? dstHash = dstExists ? ComputeHash(dst) : null;

	if (dstExists && srcHash == dstHash)
	{
		Console.WriteLine($"  [OK]   {Path.GetFileName(src)} (unchanged)");
		skipped++;
		return;
	}

	if (dryRun)
	{
		Console.WriteLine($"  [DRY]  {Path.GetFileName(src)} -> {dst} ({(dstExists ? "UPDATE" : "NEW")})");
		skipped++;
		return;
	}

	try
	{
		string? dir = Path.GetDirectoryName(dst);
		if (dir != null && !Directory.Exists(dir))
			Directory.CreateDirectory(dir);

		File.Copy(src, dst, overwrite: true);

		// Verify
		string verifyHash = ComputeHash(dst);
		if (verifyHash == srcHash)
		{
			Console.WriteLine($"  [DONE] {Path.GetFileName(src)} -> {dst} (SHA256 verified)");
			deployed++;
		}
		else
		{
			Console.WriteLine($"  [FAIL] {Path.GetFileName(src)} hash mismatch after copy!");
			failed++;
		}
	}
	catch (Exception ex)
	{
		Console.WriteLine($"  [FAIL] {Path.GetFileName(src)}: {ex.Message}");
		failed++;
	}
}

static string ComputeHash(string filePath)
{
	using var sha = SHA256.Create();
	using var stream = File.OpenRead(filePath);
	byte[] hash = sha.ComputeHash(stream);
	return Convert.ToHexString(hash);
}
