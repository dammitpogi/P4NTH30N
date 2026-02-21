using System.Diagnostics;
using System.Text;

namespace P4NTH30N.C0MMON.Infrastructure.Configuration;

/// <summary>
/// Validates P4NTH30N configuration at startup and fails fast with clear error messages
/// when required settings are missing or invalid. Prevents silent misconfigurations
/// from causing runtime failures deep in the pipeline.
/// </summary>
/// <remarks>
/// DESIGN: Validation is exhaustive — every required field is checked before any agent starts.
/// All errors are collected and reported together (not fail-on-first) so operators can
/// fix all issues in a single pass.
/// </remarks>
public static class ConfigurationValidator
{
	/// <summary>
	/// Validates the entire P4NTH30N configuration tree.
	/// Returns a list of validation errors. Empty list = valid.
	/// </summary>
	/// <param name="options">The fully-bound configuration options.</param>
	/// <returns>List of validation error messages. Empty if configuration is valid.</returns>
	public static List<string> Validate(P4NTH30NOptions options)
	{
		List<string> errors = new();

		if (options is null)
		{
			errors.Add("P4NTH30N configuration section is missing entirely.");
			return errors;
		}

		ValidateDatabase(options.Database, errors);
		ValidateH0UND(options.H0UND, errors);
		ValidateH4ND(options.H4ND, errors);
		ValidateSecurity(options.Security, errors);
		ValidateRAG(options.RAG, errors);
		ValidateSafety(options.Safety, errors);

		return errors;
	}

	/// <summary>
	/// Validates configuration and throws if invalid.
	/// Call this at startup to fail fast.
	/// </summary>
	/// <param name="options">The configuration to validate.</param>
	/// <exception cref="InvalidOperationException">When configuration is invalid.</exception>
	public static void ValidateAndThrow(P4NTH30NOptions options)
	{
		List<string> errors = Validate(options);

		if (errors.Count > 0)
		{
			StringBuilder message = new();
			message.AppendLine($"P4NTH30N configuration validation failed with {errors.Count} error(s):");
			message.AppendLine();
			for (int i = 0; i < errors.Count; i++)
			{
				message.AppendLine($"  [{i + 1}] {errors[i]}");
			}
			message.AppendLine();
			message.AppendLine("Fix these issues in appsettings.json or environment variables before starting.");

			throw new InvalidOperationException(message.ToString());
		}

		Console.WriteLine("[ConfigurationValidator] All configuration checks passed.");
	}

	/// <summary>
	/// Validates database connection settings.
	/// </summary>
	private static void ValidateDatabase(DatabaseOptions db, List<string> errors)
	{
		if (db is null)
		{
			errors.Add("P4NTH30N:Database section is missing.");
			return;
		}

		if (string.IsNullOrWhiteSpace(db.ConnectionString))
			errors.Add("P4NTH30N:Database:ConnectionString is required.");

		if (string.IsNullOrWhiteSpace(db.DatabaseName))
			errors.Add("P4NTH30N:Database:DatabaseName is required.");

		if (db.ConnectionTimeoutSeconds <= 0)
			errors.Add("P4NTH30N:Database:ConnectionTimeoutSeconds must be positive.");

		if (db.MaxPoolSize <= 0 || db.MaxPoolSize > 1000)
			errors.Add("P4NTH30N:Database:MaxPoolSize must be between 1 and 1000.");

		// Validate connection string format
		if (!string.IsNullOrWhiteSpace(db.ConnectionString) && !db.ConnectionString.StartsWith("mongodb://") && !db.ConnectionString.StartsWith("mongodb+srv://"))
		{
			errors.Add("P4NTH30N:Database:ConnectionString must start with 'mongodb://' or 'mongodb+srv://'.");
		}
	}

	/// <summary>
	/// Validates H0UND agent settings.
	/// </summary>
	private static void ValidateH0UND(H0UNDOptions h0und, List<string> errors)
	{
		if (h0und is null)
			return; // H0UND config is optional (agent may not be running)

		if (h0und.Polling.IntervalSeconds < 1)
			errors.Add("P4NTH30N:H0UND:Polling:IntervalSeconds must be at least 1.");

		if (h0und.Polling.MaxConcurrent < 1)
			errors.Add("P4NTH30N:H0UND:Polling:MaxConcurrent must be at least 1.");

		if (h0und.Polling.TimeoutSeconds < 1)
			errors.Add("P4NTH30N:H0UND:Polling:TimeoutSeconds must be at least 1.");

		if (h0und.Analytics.ForecastWindowHours < 1)
			errors.Add("P4NTH30N:H0UND:Analytics:ForecastWindowHours must be at least 1.");

		if (h0und.Analytics.MinDataPoints < 1)
			errors.Add("P4NTH30N:H0UND:Analytics:MinDataPoints must be at least 1.");
	}

	/// <summary>
	/// Validates H4ND agent settings.
	/// </summary>
	private static void ValidateH4ND(H4NDOptions h4nd, List<string> errors)
	{
		if (h4nd is null)
			return; // H4ND config is optional

		if (h4nd.Selenium.ImplicitWaitSeconds < 0)
			errors.Add("P4NTH30N:H4ND:Selenium:ImplicitWaitSeconds cannot be negative.");

		if (h4nd.Selenium.PageLoadTimeoutSeconds < 1)
			errors.Add("P4NTH30N:H4ND:Selenium:PageLoadTimeoutSeconds must be at least 1.");

		if (h4nd.Selenium.ScriptTimeoutSeconds < 1)
			errors.Add("P4NTH30N:H4ND:Selenium:ScriptTimeoutSeconds must be at least 1.");

		if (h4nd.RetryPolicy.MaxAttempts < 1)
			errors.Add("P4NTH30N:H4ND:RetryPolicy:MaxAttempts must be at least 1.");

		if (h4nd.RetryPolicy.BackoffSeconds < 0)
			errors.Add("P4NTH30N:H4ND:RetryPolicy:BackoffSeconds cannot be negative.");
	}

	/// <summary>
	/// Validates security settings.
	/// </summary>
	private static void ValidateSecurity(SecurityOptions security, List<string> errors)
	{
		if (security is null)
			return; // Security is optional during early development

		if (string.IsNullOrWhiteSpace(security.MasterKeyPath))
			errors.Add("P4NTH30N:Security:MasterKeyPath is required when security section is configured.");

		if (security.Pbkdf2Iterations < 100_000)
			errors.Add("P4NTH30N:Security:Pbkdf2Iterations must be at least 100,000 (OWASP minimum).");
	}

	/// <summary>
	/// Validates RAG configuration.
	/// </summary>
	private static void ValidateRAG(RagOptions rag, List<string> errors)
	{
		if (rag is null)
			return; // RAG is optional

		if (rag.EmbeddingDimensions <= 0)
			errors.Add("P4NTH30N:RAG:EmbeddingDimensions must be positive.");
	}

	/// <summary>
	/// Validates safety mechanism settings.
	/// </summary>
	private static void ValidateSafety(SafetyOptions safety, List<string> errors)
	{
		if (safety is null)
			return; // Safety is optional during development

		if (safety.DailyLossLimit <= 0)
			errors.Add("P4NTH30N:Safety:DailyLossLimit must be positive.");

		if (safety.MaxConsecutiveLosses < 1)
			errors.Add("P4NTH30N:Safety:MaxConsecutiveLosses must be at least 1.");

		if (safety.BalanceAlertThreshold <= 0 || safety.BalanceAlertThreshold > 1.0m)
			errors.Add("P4NTH30N:Safety:BalanceAlertThreshold must be between 0 and 1.0 (percentage).");
	}
}
