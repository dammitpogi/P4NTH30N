using System.Diagnostics;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace P4NTHE0N.DeployLogAnalyzer;

/// <summary>
/// Business rules validator for credential configurations.
/// ARCH-003-PIVOT Stage 1: Cross-field validation, threshold ordering, platform-specific limits, DPD sanity.
/// Performance target: &lt;5ms per validation.
/// </summary>
public sealed class BusinessRulesValidator
{
	/// <summary>
	/// Platform-specific maximum Grand threshold values.
	/// </summary>
	private static readonly Dictionary<string, double> PlatformMaxThresholds = new(StringComparer.OrdinalIgnoreCase)
	{
		["firekirin"] = 50000,
		["orionstars"] = 75000,
		["gamereel"] = 100000,
		["vegasx"] = 25000,
		["pandamaster"] = 50000,
	};

	/// <summary>
	/// Known valid platform identifiers.
	/// </summary>
	private static readonly HashSet<string> ValidPlatforms = new(StringComparer.OrdinalIgnoreCase) { "firekirin", "orionstars", "gamereel", "vegasx", "pandamaster" };

	/// <summary>
	/// Patterns that indicate potential injection attacks.
	/// </summary>
	private static readonly Regex InjectionPattern = new(
		@"(<script|javascript:|on\w+=|&#|%3c|%3e|\$\{|{{|\}\}|DROP\s+TABLE|UNION\s+SELECT|--\s|;\s*DELETE)",
		RegexOptions.IgnoreCase | RegexOptions.Compiled
	);

	/// <summary>
	/// Validates business rules on a parsed configuration JSON.
	/// </summary>
	public BusinessRulesOutput Validate(string configJson)
	{
		Stopwatch sw = Stopwatch.StartNew();
		List<BusinessRuleError> errors = new();

		try
		{
			using JsonDocument doc = JsonDocument.Parse(configJson);
			JsonElement root = doc.RootElement;

			ValidateThresholdOrdering(root, errors);
			ValidatePlatformLimits(root, errors);
			ValidateDpdSanity(root, errors);
			ValidateInjectionPatterns(root, errors);
			ValidateFieldSemantics(root, errors);
		}
		catch (JsonException ex)
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "json_parse",
					Message = $"Failed to parse config JSON: {ex.Message}",
					Severity = RuleSeverity.Error,
				}
			);
		}

		sw.Stop();

		return new BusinessRulesOutput
		{
			IsValid = !errors.Any(e => e.Severity == RuleSeverity.Error),
			Errors = errors,
			LatencyMs = sw.ElapsedMilliseconds,
		};
	}

	/// <summary>
	/// Rule 1: Threshold ordering must be Grand > Major > Minor > Mini.
	/// </summary>
	private static void ValidateThresholdOrdering(JsonElement root, List<BusinessRuleError> errors)
	{
		if (!root.TryGetProperty("thresholds", out JsonElement thresholds))
			return;
		if (thresholds.ValueKind != JsonValueKind.Object)
			return;

		bool hasGrand = thresholds.TryGetProperty("Grand", out JsonElement grand) && grand.ValueKind == JsonValueKind.Number;
		bool hasMajor = thresholds.TryGetProperty("Major", out JsonElement major) && major.ValueKind == JsonValueKind.Number;
		bool hasMinor = thresholds.TryGetProperty("Minor", out JsonElement minor) && minor.ValueKind == JsonValueKind.Number;
		bool hasMini = thresholds.TryGetProperty("Mini", out JsonElement mini) && mini.ValueKind == JsonValueKind.Number;

		if (!hasGrand || !hasMajor || !hasMinor || !hasMini)
			return;

		double grandVal = grand.GetDouble();
		double majorVal = major.GetDouble();
		double minorVal = minor.GetDouble();
		double miniVal = mini.GetDouble();

		if (grandVal <= majorVal)
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "threshold_ordering",
					Message = $"Grand ({grandVal}) must exceed Major ({majorVal})",
					Severity = RuleSeverity.Error,
				}
			);
		}

		if (majorVal <= minorVal)
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "threshold_ordering",
					Message = $"Major ({majorVal}) must exceed Minor ({minorVal})",
					Severity = RuleSeverity.Error,
				}
			);
		}

		if (minorVal <= miniVal)
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "threshold_ordering",
					Message = $"Minor ({minorVal}) must exceed Mini ({miniVal})",
					Severity = RuleSeverity.Error,
				}
			);
		}
	}

	/// <summary>
	/// Rule 2: Platform-specific threshold limits.
	/// </summary>
	private static void ValidatePlatformLimits(JsonElement root, List<BusinessRuleError> errors)
	{
		if (!root.TryGetProperty("platform", out JsonElement platform))
			return;
		if (platform.ValueKind != JsonValueKind.String)
			return;

		string? platformName = platform.GetString();
		if (string.IsNullOrEmpty(platformName))
			return;

		if (!ValidPlatforms.Contains(platformName))
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "unknown_platform",
					Message = $"Unknown platform: '{platformName}'. Valid platforms: {string.Join(", ", ValidPlatforms)}",
					Severity = RuleSeverity.Warning,
				}
			);
			return;
		}

		if (!root.TryGetProperty("thresholds", out JsonElement thresholds))
			return;
		if (!thresholds.TryGetProperty("Grand", out JsonElement grand))
			return;
		if (grand.ValueKind != JsonValueKind.Number)
			return;

		double grandVal = grand.GetDouble();

		if (PlatformMaxThresholds.TryGetValue(platformName, out double maxThreshold) && grandVal > maxThreshold)
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "platform_threshold_limit",
					Message = $"Platform '{platformName}' has maximum Grand threshold of {maxThreshold}, got {grandVal}",
					Severity = RuleSeverity.Error,
				}
			);
		}
	}

	/// <summary>
	/// Rule 3: DPD sanity checks.
	/// </summary>
	private static void ValidateDpdSanity(JsonElement root, List<BusinessRuleError> errors)
	{
		if (!root.TryGetProperty("dpd", out JsonElement dpd))
			return;
		if (dpd.ValueKind != JsonValueKind.Object)
			return;

		bool hasWindow = dpd.TryGetProperty("WindowHours", out JsonElement windowHours) && windowHours.ValueKind == JsonValueKind.Number;
		bool hasMinSamples = dpd.TryGetProperty("MinSamples", out JsonElement minSamples) && minSamples.ValueKind == JsonValueKind.Number;

		if (hasWindow && hasMinSamples)
		{
			double windowVal = windowHours.GetDouble();
			int samplesVal = minSamples.GetInt32();

			if (windowVal > 24 && samplesVal < 10)
			{
				errors.Add(
					new BusinessRuleError
					{
						Rule = "dpd_sanity",
						Message = $"WindowHours > 24 ({windowVal}) requires MinSamples >= 10 (got {samplesVal}) for statistical significance",
						Severity = RuleSeverity.Warning,
					}
				);
			}
		}
	}

	/// <summary>
	/// Rule 4: Detect potential injection patterns in string fields.
	/// </summary>
	private static void ValidateInjectionPatterns(JsonElement root, List<BusinessRuleError> errors)
	{
		CheckFieldForInjection(root, "username", errors);
		CheckFieldForInjection(root, "house", errors);
		CheckFieldForInjection(root, "platform", errors);
	}

	/// <summary>
	/// Rule 5: Validate field semantic constraints.
	/// </summary>
	private static void ValidateFieldSemantics(JsonElement root, List<BusinessRuleError> errors)
	{
		// timeoutSeconds range
		if (root.TryGetProperty("timeoutSeconds", out JsonElement timeout) && timeout.ValueKind == JsonValueKind.Number)
		{
			int val = timeout.GetInt32();
			if (val < 1 || val > 300)
			{
				errors.Add(
					new BusinessRuleError
					{
						Rule = "timeout_range",
						Message = $"timeoutSeconds must be between 1 and 300, got {val}",
						Severity = RuleSeverity.Error,
					}
				);
			}
		}

		// maxRetries range
		if (root.TryGetProperty("maxRetries", out JsonElement retries) && retries.ValueKind == JsonValueKind.Number)
		{
			int val = retries.GetInt32();
			if (val < 0 || val > 10)
			{
				errors.Add(
					new BusinessRuleError
					{
						Rule = "max_retries_range",
						Message = $"maxRetries must be between 0 and 10, got {val}",
						Severity = RuleSeverity.Error,
					}
				);
			}
		}

		// balanceMinimum non-negative
		if (root.TryGetProperty("balanceMinimum", out JsonElement balance) && balance.ValueKind == JsonValueKind.Number)
		{
			double val = balance.GetDouble();
			if (val < 0)
			{
				errors.Add(
					new BusinessRuleError
					{
						Rule = "balance_minimum",
						Message = $"balanceMinimum must be >= 0, got {val}",
						Severity = RuleSeverity.Error,
					}
				);
			}
		}
	}

	private static void CheckFieldForInjection(JsonElement root, string fieldName, List<BusinessRuleError> errors)
	{
		if (!root.TryGetProperty(fieldName, out JsonElement field))
			return;
		if (field.ValueKind != JsonValueKind.String)
			return;

		string? value = field.GetString();
		if (string.IsNullOrEmpty(value))
			return;

		if (InjectionPattern.IsMatch(value))
		{
			errors.Add(
				new BusinessRuleError
				{
					Rule = "injection_detected",
					Message = $"Potential injection pattern detected in '{fieldName}'",
					Severity = RuleSeverity.Error,
				}
			);
		}
	}
}

/// <summary>
/// Result of business rules validation.
/// </summary>
public sealed class BusinessRulesOutput
{
	public bool IsValid { get; init; }
	public List<BusinessRuleError> Errors { get; init; } = new();
	public long LatencyMs { get; init; }

	/// <summary>
	/// Whether any errors (not warnings) were found.
	/// </summary>
	public bool HasErrors => Errors.Any(e => e.Severity == RuleSeverity.Error);

	/// <summary>
	/// Whether any warnings were found.
	/// </summary>
	public bool HasWarnings => Errors.Any(e => e.Severity == RuleSeverity.Warning);

	/// <summary>
	/// Returns a flat list of error messages for logging.
	/// </summary>
	public IReadOnlyList<string> GetErrorMessages() => Errors.Select(e => $"[{e.Severity}] {e.Rule}: {e.Message}").ToList().AsReadOnly();
}

/// <summary>
/// Individual business rule validation error.
/// </summary>
public sealed class BusinessRuleError
{
	public string Rule { get; init; } = string.Empty;
	public string Message { get; init; } = string.Empty;
	public RuleSeverity Severity { get; init; }
}

/// <summary>
/// Severity level for business rule violations.
/// </summary>
public enum RuleSeverity
{
	Warning,
	Error,
}
