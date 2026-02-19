using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace P4NTH30N.RAG;

/// <summary>
/// ERR0R sanitization pipeline for pre-ingestion data cleaning.
/// Oracle blocking condition #2: file paths→relative, line numbers→hash,
/// stack traces→exception type, credentials→REJECT, user IDs→SHA-256 hash.
/// Runs BEFORE ingestion, never at query time.
/// </summary>
public sealed class SanitizationPipeline
{
	private readonly SanitizationConfig _config;

	// Tracking
	private long _totalProcessed;
	private long _totalRejected;
	private long _totalSanitized;

	public long TotalProcessed => _totalProcessed;
	public long TotalRejected => _totalRejected;
	public long TotalSanitized => _totalSanitized;

	public SanitizationPipeline(SanitizationConfig? config = null)
	{
		_config = config ?? new SanitizationConfig();
	}

	/// <summary>
	/// Sanitizes content before ingestion into RAG.
	/// Returns null if content must be REJECTED (contains credentials).
	/// </summary>
	public SanitizationResult Sanitize(string content, string source)
	{
		Interlocked.Increment(ref _totalProcessed);

		// RULE: Credentials → REJECT entire document
		if (ContainsCredentials(content))
		{
			Interlocked.Increment(ref _totalRejected);
			return new SanitizationResult
			{
				Status = SanitizationStatus.Rejected,
				Reason = "Document contains credentials or secrets",
				Source = source,
			};
		}

		string sanitized = content;
		List<string> appliedRules = new();

		// RULE: File paths → relative
		(sanitized, bool pathsChanged) = SanitizeFilePaths(sanitized);
		if (pathsChanged)
			appliedRules.Add("file_paths_relativized");

		// RULE: Line numbers → hash or remove
		(sanitized, bool linesChanged) = SanitizeLineNumbers(sanitized);
		if (linesChanged)
			appliedRules.Add("line_numbers_hashed");

		// RULE: Stack traces → strip to exception type
		(sanitized, bool stacksChanged) = SanitizeStackTraces(sanitized);
		if (stacksChanged)
			appliedRules.Add("stack_traces_stripped");

		// RULE: User identifiers → SHA-256 hash
		(sanitized, bool usersChanged) = SanitizeUserIdentifiers(sanitized);
		if (usersChanged)
			appliedRules.Add("user_ids_hashed");

		// RULE: Exception messages → redact URLs/IPs
		(sanitized, bool urlsChanged) = SanitizeUrlsAndIps(sanitized);
		if (urlsChanged)
			appliedRules.Add("urls_ips_redacted");

		if (appliedRules.Count > 0)
		{
			Interlocked.Increment(ref _totalSanitized);
		}

		return new SanitizationResult
		{
			Status = SanitizationStatus.Sanitized,
			Content = sanitized,
			Source = source,
			AppliedRules = appliedRules,
		};
	}

	/// <summary>
	/// Batch sanitize multiple documents.
	/// </summary>
	public List<SanitizationResult> SanitizeBatch(IReadOnlyList<(string Content, string Source)> documents)
	{
		List<SanitizationResult> results = new(documents.Count);
		foreach ((string content, string source) in documents)
		{
			results.Add(Sanitize(content, source));
		}
		return results;
	}

	/// <summary>
	/// Detects credentials, passwords, API keys, secrets in content.
	/// </summary>
	private bool ContainsCredentials(string content)
	{
		foreach (Regex pattern in _credentialPatterns)
		{
			if (pattern.IsMatch(content))
			{
				return true;
			}
		}
		return false;
	}

	/// <summary>
	/// Replaces absolute file paths with relative paths.
	/// C:\P4NTH30N\C0MMON\... → C0MMON/...
	/// </summary>
	private (string Result, bool Changed) SanitizeFilePaths(string content)
	{
		bool changed = false;
		string result = content;

		// Windows absolute paths
		foreach (string root in _config.PathRoots)
		{
			if (result.Contains(root, StringComparison.OrdinalIgnoreCase))
			{
				result = result.Replace(root, "", StringComparison.OrdinalIgnoreCase);
				changed = true;
			}
		}

		// Replace backslashes with forward slashes in remaining paths
		Regex windowsPathPattern = new(@"[A-Z]:\\[^\s""']+", RegexOptions.Compiled);
		string pathResult = windowsPathPattern.Replace(
			result,
			match =>
			{
				changed = true;
				string path = match.Value;
				// Extract relative portion after last known root
				int lastSlash = path.LastIndexOf('\\');
				string filename = lastSlash >= 0 ? path[(lastSlash + 1)..] : path;
				return filename;
			}
		);

		if (pathResult != result)
		{
			result = pathResult;
		}

		// Normalize remaining backslashes in path-like strings
		result = Regex.Replace(result, @"\\(?=[A-Za-z0-9_\-.])", "/");

		return (result, changed);
	}

	/// <summary>
	/// Hashes or removes line numbers from error messages.
	/// [123] → [LN:a1b2c3] to protect code structure.
	/// </summary>
	private static (string Result, bool Changed) SanitizeLineNumbers(string content)
	{
		bool changed = false;

		// Pattern: [123] at start of lines or in error context
		string result = Regex.Replace(
			content,
			@"\[(\d{1,5})\]",
			match =>
			{
				changed = true;
				string lineNum = match.Groups[1].Value;
				string hash = ComputeShortHash(lineNum);
				return $"[LN:{hash}]";
			}
		);

		// Pattern: "line 123" or "Line: 123"
		result = Regex.Replace(
			result,
			@"(?i)line\s*:?\s*(\d{1,5})",
			match =>
			{
				changed = true;
				string lineNum = match.Groups[1].Value;
				string hash = ComputeShortHash(lineNum);
				return $"line:{hash}";
			}
		);

		return (result, changed);
	}

	/// <summary>
	/// Strips stack traces to exception type only.
	/// Full trace → "System.NullReferenceException"
	/// </summary>
	private static (string Result, bool Changed) SanitizeStackTraces(string content)
	{
		bool changed = false;

		// Pattern: "at Namespace.Class.Method(params) in file:line"
		string result = Regex.Replace(
			content,
			@"(?m)^\s+at\s+[\w.]+\(.*?\)(?:\s+in\s+.+?:\s*line\s+\d+)?$",
			match =>
			{
				changed = true;
				return "   at [REDACTED]";
			}
		);

		// Collapse multiple consecutive [REDACTED] lines
		result = Regex.Replace(result, @"(\s+at \[REDACTED\]\s*\n){2,}", "   at [REDACTED] (stack trace removed)\n");

		return (result, changed);
	}

	/// <summary>
	/// Hashes user identifiers with SHA-256.
	/// </summary>
	private static (string Result, bool Changed) SanitizeUserIdentifiers(string content)
	{
		bool changed = false;

		// Pattern: common user ID formats (email-like, specific ID patterns)
		string result = Regex.Replace(
			content,
			@"\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b",
			match =>
			{
				changed = true;
				string hash = ComputeSha256(match.Value);
				return $"user:{hash[..12]}";
			}
		);

		return (result, changed);
	}

	/// <summary>
	/// Redacts URLs and IP addresses from exception messages.
	/// </summary>
	private static (string Result, bool Changed) SanitizeUrlsAndIps(string content)
	{
		bool changed = false;

		// URLs (except localhost which is safe)
		string result = Regex.Replace(
			content,
			@"https?://(?!localhost)[^\s""'<>]+",
			match =>
			{
				changed = true;
				return "[URL_REDACTED]";
			}
		);

		// IP addresses (except 127.0.0.1 and localhost patterns)
		result = Regex.Replace(
			result,
			@"\b(?!127\.0\.0\.1)(?!0\.0\.0\.0)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b",
			match =>
			{
				changed = true;
				return "[IP_REDACTED]";
			}
		);

		return (result, changed);
	}

	/// <summary>
	/// Computes a short hash for line number obfuscation.
	/// </summary>
	private static string ComputeShortHash(string input)
	{
		byte[] bytes = SHA256.HashData(Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes)[..6].ToLowerInvariant();
	}

	/// <summary>
	/// Computes SHA-256 hash for PII protection.
	/// </summary>
	private static string ComputeSha256(string input)
	{
		byte[] bytes = SHA256.HashData(Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes).ToLowerInvariant();
	}

	/// <summary>
	/// Pre-compiled credential detection patterns.
	/// </summary>
	private static readonly Regex[] _credentialPatterns = new[]
	{
		new Regex(@"(?i)(password|passwd|pwd)\s*[=:]\s*[""']?.{3,}", RegexOptions.Compiled),
		new Regex(@"(?i)(api[_-]?key|apikey)\s*[=:]\s*[""']?\w{10,}", RegexOptions.Compiled),
		new Regex(@"(?i)(secret|token)\s*[=:]\s*[""']?\w{10,}", RegexOptions.Compiled),
		new Regex(@"(?i)(bearer)\s+[A-Za-z0-9\-._~+/]+=*", RegexOptions.Compiled),
		new Regex(@"(?i)(connection\s*string)\s*[=:]\s*[""']?.{20,}", RegexOptions.Compiled),
		new Regex(@"-----BEGIN\s+(RSA\s+)?PRIVATE\s+KEY-----", RegexOptions.Compiled),
		new Regex(@"(?i)(aws_access_key_id|aws_secret_access_key)\s*[=:]\s*\w+", RegexOptions.Compiled),
	};
}

/// <summary>
/// Configuration for the sanitization pipeline.
/// </summary>
public sealed class SanitizationConfig
{
	/// <summary>
	/// Root paths to strip from absolute file paths.
	/// </summary>
	public List<string> PathRoots { get; init; } = new() { @"C:\P4NTH30N\", @"C:/P4NTH30N/", @"c:\P4NTH30N\", @"c:/P4NTH30N/" };
}

/// <summary>
/// Result of sanitization processing.
/// </summary>
public sealed class SanitizationResult
{
	public SanitizationStatus Status { get; init; }
	public string? Content { get; init; }
	public string Source { get; init; } = string.Empty;
	public string? Reason { get; init; }
	public List<string> AppliedRules { get; init; } = new();
}

/// <summary>
/// Sanitization outcome status.
/// </summary>
public enum SanitizationStatus
{
	/// <summary>Content was sanitized and is safe for ingestion.</summary>
	Sanitized,

	/// <summary>Content was rejected (contains credentials/secrets).</summary>
	Rejected,
}
