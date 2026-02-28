namespace P4NTHE0N.C0MMON.Infrastructure.Configuration;

/// <summary>
/// Root strongly-typed options for the entire P4NTHE0N platform.
/// Binds to the "P4NTHE0N" section in appsettings.json.
/// </summary>
/// <remarks>
/// Configuration hierarchy (lowest to highest priority):
/// 1. appsettings.json (base defaults)
/// 2. appsettings.{Environment}.json (environment overrides)
/// 3. Environment variables (prefixed P4NTHE0N__)
/// 4. Local secrets file (encrypted, via INFRA-009 EncryptionService)
/// </remarks>
public sealed class P4NTHE0NOptions
{
	/// <summary>
	/// Configuration section key in appsettings.json.
	/// </summary>
	public const string SectionKey = "P4NTHE0N";

	/// <summary>
	/// MongoDB database connection settings.
	/// </summary>
	public DatabaseOptions Database { get; set; } = new();

	/// <summary>
	/// H0UND agent configuration (polling, analytics).
	/// </summary>
	public H0UNDOptions H0UND { get; set; } = new();

	/// <summary>
	/// H4ND agent configuration (Selenium, retry policy).
	/// </summary>
	public H4NDOptions H4ND { get; set; } = new();

	/// <summary>
	/// Feature flags for enabling/disabling capabilities.
	/// </summary>
	public FeatureOptions Features { get; set; } = new();

	/// <summary>
	/// Security and encryption settings.
	/// </summary>
	public SecurityOptions Security { get; set; } = new();

	/// <summary>
	/// RAG and LLM inference settings.
	/// </summary>
	public RagOptions RAG { get; set; } = new();

	/// <summary>
	/// Safety mechanisms and circuit breaker configuration.
	/// </summary>
	public SafetyOptions Safety { get; set; } = new();
}

/// <summary>
/// MongoDB connection and database settings.
/// </summary>
public sealed class DatabaseOptions
{
	/// <summary>
	/// MongoDB connection string. Sensitive — should be in secrets for production.
	/// </summary>
	public string ConnectionString { get; set; } = "mongodb://localhost:27017/P4NTHE0N";

	/// <summary>
	/// MongoDB database name.
	/// </summary>
	public string DatabaseName { get; set; } = "P4NTHE0N";

	/// <summary>
	/// Connection timeout in seconds.
	/// </summary>
	public int ConnectionTimeoutSeconds { get; set; } = 10;

	/// <summary>
	/// Maximum connection pool size.
	/// </summary>
	public int MaxPoolSize { get; set; } = 100;
}

/// <summary>
/// H0UND agent polling and analytics configuration.
/// </summary>
public sealed class H0UNDOptions
{
	/// <summary>
	/// Polling loop settings.
	/// </summary>
	public PollingOptions Polling { get; set; } = new();

	/// <summary>
	/// Analytics engine settings.
	/// </summary>
	public AnalyticsOptions Analytics { get; set; } = new();
}

/// <summary>
/// Polling loop configuration for H0UND.
/// </summary>
public sealed class PollingOptions
{
	/// <summary>
	/// Interval between polling cycles in seconds.
	/// </summary>
	public int IntervalSeconds { get; set; } = 60;

	/// <summary>
	/// Maximum concurrent polling operations.
	/// </summary>
	public int MaxConcurrent { get; set; } = 10;

	/// <summary>
	/// Individual polling operation timeout in seconds.
	/// </summary>
	public int TimeoutSeconds { get; set; } = 30;
}

/// <summary>
/// Analytics engine configuration for H0UND.
/// </summary>
public sealed class AnalyticsOptions
{
	/// <summary>
	/// Whether the analytics engine is enabled.
	/// </summary>
	public bool Enabled { get; set; } = true;

	/// <summary>
	/// Forecast look-ahead window in hours.
	/// </summary>
	public int ForecastWindowHours { get; set; } = 24;

	/// <summary>
	/// Minimum data points required for meaningful forecasts.
	/// </summary>
	public int MinDataPoints { get; set; } = 3;
}

/// <summary>
/// H4ND agent Selenium and retry configuration.
/// </summary>
public sealed class H4NDOptions
{
	/// <summary>
	/// Selenium WebDriver settings.
	/// </summary>
	public SeleniumOptions Selenium { get; set; } = new();

	/// <summary>
	/// Retry policy for failed operations.
	/// </summary>
	public RetryPolicyOptions RetryPolicy { get; set; } = new();
}

/// <summary>
/// Selenium WebDriver configuration.
/// </summary>
public sealed class SeleniumOptions
{
	/// <summary>
	/// Run Chrome in headless mode (no visible browser window).
	/// </summary>
	public bool Headless { get; set; } = false;

	/// <summary>
	/// Implicit wait timeout for element discovery in seconds.
	/// </summary>
	public int ImplicitWaitSeconds { get; set; } = 10;

	/// <summary>
	/// Page load timeout in seconds.
	/// </summary>
	public int PageLoadTimeoutSeconds { get; set; } = 30;

	/// <summary>
	/// JavaScript execution timeout in seconds.
	/// </summary>
	public int ScriptTimeoutSeconds { get; set; } = 30;
}

/// <summary>
/// Retry policy configuration for H4ND operations.
/// </summary>
public sealed class RetryPolicyOptions
{
	/// <summary>
	/// Maximum number of retry attempts before failing.
	/// </summary>
	public int MaxAttempts { get; set; } = 3;

	/// <summary>
	/// Base backoff delay between retries in seconds.
	/// </summary>
	public int BackoffSeconds { get; set; } = 5;
}

/// <summary>
/// Feature flags for runtime capability toggling.
/// </summary>
public sealed class FeatureOptions
{
	/// <summary>
	/// Enable FAISS vector search for RAG pipeline.
	/// </summary>
	public bool VectorSearch { get; set; } = false;

	/// <summary>
	/// Enable signal throttling to prevent rapid-fire signals.
	/// </summary>
	public bool SignalThrottling { get; set; } = true;

	/// <summary>
	/// Enable automatic retry on transient failures.
	/// </summary>
	public bool AutoRetry { get; set; } = true;

	/// <summary>
	/// Enable verbose debug logging (development only).
	/// </summary>
	public bool DebugLogging { get; set; } = false;
}

/// <summary>
/// Security and encryption configuration.
/// </summary>
public sealed class SecurityOptions
{
	/// <summary>
	/// Path to the master encryption key file.
	/// Default: C:\ProgramData\P4NTHE0N\master.key
	/// </summary>
	public string MasterKeyPath { get; set; } = @"C:\ProgramData\P4NTHE0N\master.key";

	/// <summary>
	/// Whether to enforce OS-level file permissions on the master key.
	/// Set to false for development/testing without Administrator elevation.
	/// </summary>
	public bool EnforceKeyPermissions { get; set; } = true;

	/// <summary>
	/// PBKDF2 iteration count for key derivation. Default: 600,000 (OWASP 2025).
	/// </summary>
	public int Pbkdf2Iterations { get; set; } = 600_000;
}

/// <summary>
/// RAG and LLM inference configuration.
/// </summary>
public sealed class RagOptions
{
	/// <summary>
	/// Path to the FAISS bridge Python script.
	/// </summary>
	public string FaissBridgePath { get; set; } = "scripts/rag/faiss-bridge.py";

	/// <summary>
	/// Path to the embedding bridge Python script.
	/// </summary>
	public string EmbeddingBridgePath { get; set; } = "scripts/rag/embedding-bridge.py";

	/// <summary>
	/// Directory for persisting FAISS index files.
	/// </summary>
	public string IndexDirectory { get; set; } = "data/faiss";

	/// <summary>
	/// Embedding model name. Default: all-MiniLM-L6-v2 (384 dimensions).
	/// </summary>
	public string EmbeddingModel { get; set; } = "all-MiniLM-L6-v2";

	/// <summary>
	/// Vector dimensions matching the embedding model output.
	/// </summary>
	public int EmbeddingDimensions { get; set; } = 384;
}

/// <summary>
/// Safety mechanisms and financial protection configuration.
/// </summary>
public sealed class SafetyOptions
{
	/// <summary>
	/// Maximum daily loss before automatic shutdown (USD).
	/// </summary>
	public decimal DailyLossLimit { get; set; } = 100m;

	/// <summary>
	/// Maximum consecutive losses before circuit breaker trips.
	/// </summary>
	public int MaxConsecutiveLosses { get; set; } = 10;

	/// <summary>
	/// Enable the manual kill switch mechanism.
	/// </summary>
	public bool KillSwitchEnabled { get; set; } = true;

	/// <summary>
	/// Balance change threshold (percentage) that triggers an alert.
	/// </summary>
	public decimal BalanceAlertThreshold { get; set; } = 0.20m;
}
