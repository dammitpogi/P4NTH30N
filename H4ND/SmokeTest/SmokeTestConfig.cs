namespace P4NTH30N.H4ND.SmokeTest;

/// <summary>
/// ARCH-099: Configuration for the smoke test execution.
/// Populated from CLI arguments with sensible defaults.
/// </summary>
public sealed class SmokeTestConfig
{
	public string Platform { get; set; } = "firekirin";
	public string Profile { get; set; } = "W0";
	public int Port { get; set; } = 9222;
	public string OutputFormat { get; set; } = "console";
	public string? Username { get; set; }
	public string? Password { get; set; }
	public int PageLoadTimeoutSeconds { get; set; } = 30;
	public int LoginTimeoutSeconds { get; set; } = 60;
	public int BalanceRetryCount { get; set; } = 3;
	public int BalanceRetryDelayMs { get; set; } = 2000;

	/// <summary>
	/// MongoDB connection string for credential lookup.
	/// </summary>
	public string MongoConnectionString { get; set; } = "mongodb://192.168.56.1:27017";

	/// <summary>
	/// MongoDB database name.
	/// </summary>
	public string MongoDatabaseName { get; set; } = "P4NTH30N";

	/// <summary>
	/// MongoDB credential collection name.
	/// </summary>
	public string MongoCredentialCollection { get; set; } = "CRED3N7IAL";

	/// <summary>
	/// Worker ID for Chrome profile (parsed from Profile string).
	/// </summary>
	public int WorkerId => int.TryParse(Profile.Replace("W", ""), out int id) ? id : 0;

	/// <summary>
	/// FireKirin URL for navigation.
	/// </summary>
	public string GetPlatformUrl() => Platform.ToLowerInvariant() switch
	{
		"firekirin" => "http://play.firekirin.in/web_mobile/firekirin/",
		"orionstars" => "http://web.orionstars.org/hot_play/orionstars/",
		_ => throw new ArgumentException($"Unknown platform: {Platform}"),
	};
}
