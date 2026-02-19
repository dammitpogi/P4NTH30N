using System.Text.Json;
using System.Text.RegularExpressions;

namespace P4NTH30N.DeployLogAnalyzer;

/// <summary>
/// Deployment log analysis and classification engine.
/// Parses build logs, classifies errors by severity, and extracts error patterns.
/// Supports both rule-based and LLM-augmented classification.
/// </summary>
public sealed class LogClassifier
{
	private readonly LmStudioClient? _lmClient;

	/// <summary>
	/// Known error patterns for rule-based classification.
	/// </summary>
	private static readonly List<LogPattern> KnownPatterns = new()
	{
		new("CS\\d{4}", LogSeverity.Critical, "build_error", "C# compiler error"),
		new("error MSB\\d{4}", LogSeverity.Critical, "msbuild_error", "MSBuild error"),
		new("Unhandled exception", LogSeverity.Critical, "runtime_error", "Unhandled exception"),
		new("NullReferenceException", LogSeverity.Critical, "null_reference", "Null reference"),
		new("OutOfMemoryException", LogSeverity.Critical, "resource_exhaustion", "Out of memory"),
		new("StackOverflowException", LogSeverity.Critical, "stack_overflow", "Stack overflow"),
		new("TimeoutException", LogSeverity.Warning, "timeout", "Operation timed out"),
		new("connection pool exhausted", LogSeverity.Warning, "connection_pool", "Connection pool exhausted"),
		new("warn(ing)?:", LogSeverity.Warning, "general_warning", "General warning"),
		new("deprecated", LogSeverity.Warning, "deprecation", "Deprecated API usage"),
		new("retry attempt", LogSeverity.Warning, "retry", "Retry attempt"),
		new("Build succeeded", LogSeverity.Info, "build_success", "Build succeeded"),
		new("0 Error\\(s\\)", LogSeverity.Info, "clean_build", "Clean build"),
		new("info:", LogSeverity.Info, "general_info", "Informational message"),
	};

	public LogClassifier(LmStudioClient? lmClient = null)
	{
		_lmClient = lmClient;
	}

	/// <summary>
	/// Classifies a single log line using rule-based matching first, then LLM fallback.
	/// </summary>
	public async Task<LogClassification> ClassifyAsync(string logLine, bool useLlmFallback = true, CancellationToken cancellationToken = default)
	{
		// Rule-based classification first (fast path)
		LogClassification? ruleResult = ClassifyByRules(logLine);
		if (ruleResult != null)
		{
			return ruleResult;
		}

		// LLM-augmented classification (slow path)
		if (useLlmFallback && _lmClient != null)
		{
			return await ClassifyByLlmAsync(logLine, cancellationToken);
		}

		return new LogClassification
		{
			Severity = LogSeverity.Info,
			Category = "unclassified",
			Pattern = "unknown",
			Message = logLine,
			ActionRequired = false,
			Source = ClassificationSource.Default,
		};
	}

	/// <summary>
	/// Classifies multiple log lines and returns a summary report.
	/// </summary>
	public async Task<LogAnalysisReport> AnalyzeBuildLogAsync(IEnumerable<string> logLines, CancellationToken cancellationToken = default)
	{
		LogAnalysisReport report = new() { Timestamp = DateTime.UtcNow };

		foreach (string line in logLines)
		{
			if (string.IsNullOrWhiteSpace(line))
				continue;

			LogClassification classification = await ClassifyAsync(line, cancellationToken: cancellationToken);
			report.Classifications.Add(classification);

			switch (classification.Severity)
			{
				case LogSeverity.Critical:
					report.CriticalCount++;
					break;
				case LogSeverity.Warning:
					report.WarningCount++;
					break;
				case LogSeverity.Info:
					report.InfoCount++;
					break;
			}
		}

		report.TotalLines = report.Classifications.Count;

		// Extract unique error patterns
		report.ErrorPatterns = report.Classifications.Where(c => c.Severity == LogSeverity.Critical).Select(c => c.Pattern).Distinct().ToList();

		return report;
	}

	/// <summary>
	/// Rule-based classification using known patterns.
	/// </summary>
	public static LogClassification? ClassifyByRules(string logLine)
	{
		foreach (LogPattern pattern in KnownPatterns)
		{
			if (Regex.IsMatch(logLine, pattern.Regex, RegexOptions.IgnoreCase))
			{
				return new LogClassification
				{
					Severity = pattern.Severity,
					Category = pattern.Category,
					Pattern = pattern.PatternName,
					Message = logLine.Length > 200 ? logLine[..200] + "..." : logLine,
					ActionRequired = pattern.Severity == LogSeverity.Critical,
					Source = ClassificationSource.RuleBased,
				};
			}
		}
		return null;
	}

	/// <summary>
	/// LLM-augmented classification for unknown patterns.
	/// </summary>
	private async Task<LogClassification> ClassifyByLlmAsync(string logLine, CancellationToken cancellationToken)
	{
		try
		{
			string systemPrompt = FewShotPrompt.GetLogClassificationPrompt();
			string response = await _lmClient!.ChatWithRetryAsync(systemPrompt, $"Log: \"{logLine}\"", cancellationToken);

			string jsonStr = LmStudioClient.ExtractJson(response);
			using JsonDocument doc = JsonDocument.Parse(jsonStr);
			JsonElement root = doc.RootElement;

			string severityStr = root.TryGetProperty("severity", out JsonElement sev) ? sev.GetString() ?? "INFO" : "INFO";

			LogSeverity severity = severityStr.ToUpperInvariant() switch
			{
				"CRITICAL" => LogSeverity.Critical,
				"WARNING" => LogSeverity.Warning,
				_ => LogSeverity.Info,
			};

			return new LogClassification
			{
				Severity = severity,
				Category = root.TryGetProperty("category", out JsonElement cat) ? cat.GetString() ?? "unknown" : "unknown",
				Pattern = root.TryGetProperty("pattern", out JsonElement pat) ? pat.GetString() ?? "llm_classified" : "llm_classified",
				Message = root.TryGetProperty("message", out JsonElement msg) ? msg.GetString() ?? logLine : logLine,
				ActionRequired = root.TryGetProperty("actionRequired", out JsonElement act) && act.GetBoolean(),
				Source = ClassificationSource.LlmAugmented,
			};
		}
		catch
		{
			return new LogClassification
			{
				Severity = LogSeverity.Info,
				Category = "llm_error",
				Pattern = "classification_failed",
				Message = logLine,
				ActionRequired = false,
				Source = ClassificationSource.Default,
			};
		}
	}
}

/// <summary>
/// Classification result for a single log entry.
/// </summary>
public sealed class LogClassification
{
	public LogSeverity Severity { get; init; }
	public string Category { get; init; } = string.Empty;
	public string Pattern { get; init; } = string.Empty;
	public string Message { get; init; } = string.Empty;
	public bool ActionRequired { get; init; }
	public ClassificationSource Source { get; init; }
}

/// <summary>
/// Analysis report for a complete build log.
/// </summary>
public sealed class LogAnalysisReport
{
	public DateTime Timestamp { get; init; }
	public int TotalLines { get; set; }
	public int CriticalCount { get; set; }
	public int WarningCount { get; set; }
	public int InfoCount { get; set; }
	public List<LogClassification> Classifications { get; init; } = new();
	public List<string> ErrorPatterns { get; set; } = new();
}

public enum LogSeverity
{
	Info,
	Warning,
	Critical,
}

public enum ClassificationSource
{
	RuleBased,
	LlmAugmented,
	Default,
}

internal sealed record LogPattern(string Regex, LogSeverity Severity, string Category, string PatternName);
