using P4NTHE0N.H4ND.SmokeTest;
using P4NTHE0N.H4ND.SmokeTest.Reporting;

namespace P4NTHE0N.H4ND.SmokeTest;

// ARCH-099: FireKirin Login Smoke Test — Pre-Burn-In Validation Gate
// Usage: H4ND.SmokeTest.exe --platform firekirin [--profile W0] [--port 9222] [--output console|json]
//        H4ND.SmokeTest.exe --username <user> --password <pass>
//        H4ND.SmokeTest.exe --help

internal static class SmokeTestProgram
{
	public static int Main(string[] args)
	{
		return RunAsync(args).GetAwaiter().GetResult();
	}

	private static async Task<int> RunAsync(string[] args)
	{
		var config = new SmokeTestConfig();

		// Parse CLI arguments
		for (int i = 0; i < args.Length; i++)
		{
			switch (args[i].ToLowerInvariant())
			{
				case "--help" or "-h":
					PrintHelp();
					return 0;

				case "--platform":
					if (i + 1 < args.Length) config.Platform = args[++i];
					break;

				case "--profile":
					if (i + 1 < args.Length) config.Profile = args[++i];
					break;

				case "--port":
					if (i + 1 < args.Length && int.TryParse(args[++i], out int port)) config.Port = port;
					break;

				case "--output":
					if (i + 1 < args.Length) config.OutputFormat = args[++i];
					break;

				case "--username":
					if (i + 1 < args.Length) config.Username = args[++i];
					break;

				case "--password":
					if (i + 1 < args.Length) config.Password = args[++i];
					break;

				case "--mongo":
					if (i + 1 < args.Length) config.MongoConnectionString = args[++i];
					break;
			}
		}

		// If no credentials provided via CLI, try MongoDB
		if (string.IsNullOrEmpty(config.Username) || string.IsNullOrEmpty(config.Password))
		{
			await LoadCredentialsFromMongoAsync(config);
		}

		// Select reporter
		ISmokeTestReporter reporter = config.OutputFormat.ToLowerInvariant() switch
		{
			"json" => new JsonReporter(),
			_ => new ConsoleReporter(),
		};

		// Execute smoke test
		using var cts = new CancellationTokenSource();
		Console.CancelKeyPress += (_, e) =>
		{
			e.Cancel = true;
			cts.Cancel();
		};

		using var engine = new SmokeTestEngine(config, reporter);
		var result = await engine.ExecuteAsync(cts.Token);
		return result.ExitCode;
	}

	private static void PrintHelp()
	{
		Console.WriteLine(@"
P4NTHE0N SMOKE TEST - FireKirin Login Validation Gate
Usage: H4ND.SmokeTest.exe [options]

Options:
  --platform <name>    Platform to test (default: firekirin)
  --profile <id>       Chrome profile (default: W0)
  --port <number>      CDP port (default: 9222)
  --output <format>    Output format: console|json (default: console)
  --username <user>    Override username (default: from MongoDB)
  --password <pass>    Override password (default: from MongoDB)
  --mongo <connstr>    MongoDB connection string (default: mongodb://192.168.56.1:27017)
  --help, -h           Show this help

Exit Codes:
  0   PASS - Burn-in approved
  1   Chrome launch failed
  2   Page load timeout
  3   Canvas bounds invalid
  4   Login step failed
  5   Balance = 0 (auth failed)
  99  Unhandled exception
");
	}

	private static async Task LoadCredentialsFromMongoAsync(SmokeTestConfig config)
	{
		try
		{
			Console.WriteLine("[SmokeTest] Loading credentials from MongoDB...");

			var mongoClient = new MongoDB.Driver.MongoClient(config.MongoConnectionString);
			var database = mongoClient.GetDatabase(config.MongoDatabaseName);
			var collection = database.GetCollection<MongoDB.Bson.BsonDocument>(config.MongoCredentialCollection);

			// Find first enabled, unlocked, unbanned credential for the platform
			var filterBuilder = MongoDB.Driver.Builders<MongoDB.Bson.BsonDocument>.Filter;
			var filter = filterBuilder.Eq("Enabled", true)
				& filterBuilder.Eq("Unlocked", true)
				& filterBuilder.Ne("Banned", true)
				& filterBuilder.Regex("Game", new MongoDB.Bson.BsonRegularExpression(config.Platform, "i"));

			using var cursor = await collection.FindAsync(filter, new MongoDB.Driver.FindOptions<MongoDB.Bson.BsonDocument>
			{
				Limit = 1,
			});
			MongoDB.Bson.BsonDocument? credential = null;
			if (await cursor.MoveNextAsync())
			{
				credential = cursor.Current.FirstOrDefault();
			}

			if (credential != null)
			{
				config.Username = credential.GetValue("Username", "").AsString;
				config.Password = credential.GetValue("Password", "").AsString;
				string house = credential.GetValue("House", "unknown").AsString;
				Console.WriteLine($"[SmokeTest] Loaded credential: {config.Username} from {house}");
			}
			else
			{
				Console.WriteLine("[SmokeTest] WARNING: No enabled/unlocked credentials found in MongoDB");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SmokeTest] WARNING: MongoDB credential lookup failed: {ex.Message}");
			Console.WriteLine("[SmokeTest] Use --username and --password to provide credentials manually");
		}
	}
}
