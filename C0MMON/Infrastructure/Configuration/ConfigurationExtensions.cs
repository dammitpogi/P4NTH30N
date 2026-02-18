using System.Text.Json;

namespace P4NTH30N.C0MMON.Infrastructure.Configuration;

/// <summary>
/// Extension methods for loading and binding P4NTH30N configuration from JSON files
/// and environment variables. Provides a unified configuration loading pipeline
/// without depending on Microsoft.Extensions.Configuration (keeping C0MMON lightweight).
/// </summary>
/// <remarks>
/// DECISION: Using manual JSON loading rather than Microsoft.Extensions.Configuration
/// because C0MMON targets net10.0-windows7.0 without ASP.NET Core hosting.
/// The agents (H0UND, H4ND) are console apps, not web apps.
/// This approach avoids pulling in the entire Microsoft.Extensions.Configuration stack.
/// </remarks>
public static class ConfigurationExtensions
{
	/// <summary>
	/// Loads P4NTH30N configuration from JSON files with environment-specific overrides.
	/// Resolution order (highest priority last):
	/// 1. appsettings.json
	/// 2. appsettings.{environment}.json
	/// 3. Environment variables (prefixed P4NTH30N__)
	/// </summary>
	/// <param name="basePath">Directory containing appsettings.json files.</param>
	/// <param name="environment">Environment name: Development, Staging, or Production.</param>
	/// <returns>Fully resolved <see cref="P4NTH30NOptions"/>.</returns>
	public static P4NTH30NOptions LoadConfiguration(string? basePath = null, string? environment = null)
	{
		basePath ??= AppContext.BaseDirectory;
		environment ??= ResolveEnvironment();

		// Step 1: Load base appsettings.json
		P4NTH30NOptions options = new();
		string basefile = Path.Combine(basePath, "appsettings.json");
		if (File.Exists(basefile))
		{
			P4NTH30NOptions? baseOptions = LoadFromJsonFile(basefile);
			if (baseOptions is not null)
				options = baseOptions;
		}

		// Step 2: Load environment-specific overrides
		string envFile = Path.Combine(basePath, $"appsettings.{environment}.json");
		if (File.Exists(envFile))
		{
			P4NTH30NOptions? envOptions = LoadFromJsonFile(envFile);
			if (envOptions is not null)
				MergeOptions(options, envOptions);
		}

		// Step 3: Apply environment variable overrides
		ApplyEnvironmentVariables(options);

		Console.WriteLine($"[Configuration] Loaded for environment: {environment}");
		return options;
	}

	/// <summary>
	/// Resolves the current environment from the P4NTH30N_ENVIRONMENT variable.
	/// Defaults to "Development" if not set.
	/// </summary>
	public static string ResolveEnvironment()
	{
		string? env = Environment.GetEnvironmentVariable("P4NTH30N_ENVIRONMENT")
			?? Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT")
			?? Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

		return string.IsNullOrWhiteSpace(env) ? "Development" : env;
	}

	/// <summary>
	/// Loads and deserializes the P4NTH30N section from a JSON settings file.
	/// </summary>
	private static P4NTH30NOptions? LoadFromJsonFile(string filePath)
	{
		try
		{
			string json = File.ReadAllText(filePath);
			using JsonDocument doc = JsonDocument.Parse(json, new JsonDocumentOptions
			{
				CommentHandling = JsonCommentHandling.Skip,
				AllowTrailingCommas = true,
			});

			if (doc.RootElement.TryGetProperty("P4NTH30N", out JsonElement p4Section))
			{
				string sectionJson = p4Section.GetRawText();
				JsonSerializerOptions jsonOptions = new()
				{
					PropertyNameCaseInsensitive = true,
					ReadCommentHandling = JsonCommentHandling.Skip,
					AllowTrailingCommas = true,
				};
				return JsonSerializer.Deserialize<P4NTH30NOptions>(sectionJson, jsonOptions);
			}

			return null;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[Configuration] WARNING: Failed to load {filePath}: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Merges non-null/non-default values from source into target.
	/// Source values take precedence (environment overrides base).
	/// </summary>
	private static void MergeOptions(P4NTH30NOptions target, P4NTH30NOptions source)
	{
		// Database overrides
		if (!string.IsNullOrWhiteSpace(source.Database.ConnectionString) &&
			source.Database.ConnectionString != new DatabaseOptions().ConnectionString)
		{
			target.Database.ConnectionString = source.Database.ConnectionString;
		}
		if (!string.IsNullOrWhiteSpace(source.Database.DatabaseName) &&
			source.Database.DatabaseName != new DatabaseOptions().DatabaseName)
		{
			target.Database.DatabaseName = source.Database.DatabaseName;
		}

		// H4ND Selenium overrides
		if (source.H4ND.Selenium.Headless != new SeleniumOptions().Headless)
			target.H4ND.Selenium.Headless = source.H4ND.Selenium.Headless;

		// Feature flag overrides — always take environment-specific values
		target.Features.VectorSearch = source.Features.VectorSearch;
		target.Features.DebugLogging = source.Features.DebugLogging;
		target.Features.SignalThrottling = source.Features.SignalThrottling;
		target.Features.AutoRetry = source.Features.AutoRetry;
	}

	/// <summary>
	/// Applies environment variable overrides. Variables follow the pattern:
	/// P4NTH30N__Section__Key (double underscore = nesting separator).
	/// </summary>
	private static void ApplyEnvironmentVariables(P4NTH30NOptions options)
	{
		// Database
		string? connStr = Environment.GetEnvironmentVariable("P4NTH30N__Database__ConnectionString")
			?? Environment.GetEnvironmentVariable("P4NTH30N_MONGODB_URI");
		if (!string.IsNullOrWhiteSpace(connStr))
			options.Database.ConnectionString = connStr;

		string? dbName = Environment.GetEnvironmentVariable("P4NTH30N__Database__DatabaseName")
			?? Environment.GetEnvironmentVariable("P4NTH30N_MONGODB_DB");
		if (!string.IsNullOrWhiteSpace(dbName))
			options.Database.DatabaseName = dbName;

		// Security
		string? masterKeyPath = Environment.GetEnvironmentVariable("P4NTH30N__Security__MasterKeyPath");
		if (!string.IsNullOrWhiteSpace(masterKeyPath))
			options.Security.MasterKeyPath = masterKeyPath;

		// Safety
		string? dailyLimit = Environment.GetEnvironmentVariable("P4NTH30N__Safety__DailyLossLimit");
		if (!string.IsNullOrWhiteSpace(dailyLimit) && decimal.TryParse(dailyLimit, out decimal limit))
			options.Safety.DailyLossLimit = limit;

		// H0UND polling
		string? pollInterval = Environment.GetEnvironmentVariable("P4NTH30N__H0UND__Polling__IntervalSeconds");
		if (!string.IsNullOrWhiteSpace(pollInterval) && int.TryParse(pollInterval, out int interval))
			options.H0UND.Polling.IntervalSeconds = interval;

		// H4ND headless
		string? headless = Environment.GetEnvironmentVariable("P4NTH30N__H4ND__Selenium__Headless");
		if (!string.IsNullOrWhiteSpace(headless) && bool.TryParse(headless, out bool isHeadless))
			options.H4ND.Selenium.Headless = isHeadless;
	}
}
