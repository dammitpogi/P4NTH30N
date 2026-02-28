using System.Diagnostics;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTHE0N.DeployLogAnalyzer;

/// <summary>
/// Validation stage identifier for two-stage pipeline.
/// </summary>
public enum ValidationStage
{
	Schema,
	BusinessRules,
	RuleBased,
	LlmSemantic,
	Error,
}

/// <summary>
/// Two-stage validation pipeline implementing ARCH-003-PIVOT architecture.
/// Stage 1: Rule-based (JsonSchema + BusinessRules) — handles ~85% of cases in &lt;10ms.
/// Stage 2: LLM semantic analysis — handles ~15% UNCERTAIN cases in ~8s.
/// Safety: Input sanitization, circuit breaker, manual override flag support.
/// </summary>
public sealed class ValidationPipeline
{
	private readonly JsonSchemaValidator _schemaValidator;
	private readonly BusinessRulesValidator _businessValidator;
	private readonly LmStudioClient? _lmClient;
	private readonly bool _llmEnabled;
	private readonly double _circuitBreakerThreshold;

	// Circuit breaker state
	private int _llmCallCount;
	private int _llmFailureCount;
	private bool _circuitBreakerTripped;

	/// <summary>
	/// Maximum input length before rejection (10KB).
	/// </summary>
	private const int MaxInputLength = 10000;

	public ValidationPipeline(
		JsonSchemaValidator schemaValidator,
		BusinessRulesValidator businessValidator,
		LmStudioClient? lmClient = null,
		bool llmEnabled = false,
		double circuitBreakerThreshold = 0.10
	)
	{
		_schemaValidator = schemaValidator;
		_businessValidator = businessValidator;
		_lmClient = lmClient;
		_llmEnabled = llmEnabled && lmClient != null;
		_circuitBreakerThreshold = circuitBreakerThreshold;
	}

	/// <summary>
	/// Validates a configuration JSON through the two-stage pipeline.
	/// Stage 1 always runs. Stage 2 (LLM) only runs for UNCERTAIN cases if enabled.
	/// </summary>
	public async Task<TwoStageResult> ValidateAsync(string configJson, bool forceSemanticAnalysis = false, CancellationToken cancellationToken = default)
	{
		Stopwatch sw = Stopwatch.StartNew();

		// SAFETY: Input sanitization
		string? sanitizationError = SanitizeInput(configJson);
		if (sanitizationError != null)
		{
			sw.Stop();
			return new TwoStageResult
			{
				IsValid = false,
				Stage = ValidationStage.Error,
				Failures = new List<string> { sanitizationError },
				LatencyMs = sw.ElapsedMilliseconds,
				Confidence = 1.0,
			};
		}

		// SAFETY: Manual override check
		if (HasManualOverrideFlag(configJson))
		{
			sw.Stop();
			return new TwoStageResult
			{
				IsValid = false,
				Stage = ValidationStage.RuleBased,
				Failures = new List<string> { "manual_review_requested" },
				LatencyMs = sw.ElapsedMilliseconds,
				Confidence = 1.0,
				RequiresReview = true,
			};
		}

		// STAGE 1A: JSON Schema validation
		SchemaValidationOutput schemaResult = _schemaValidator.Validate(configJson);
		if (!schemaResult.IsValid)
		{
			sw.Stop();
			return new TwoStageResult
			{
				IsValid = false,
				Stage = ValidationStage.Schema,
				Failures = schemaResult.GetErrorMessages().ToList(),
				LatencyMs = sw.ElapsedMilliseconds,
				Confidence = 1.0,
				SchemaResult = schemaResult,
			};
		}

		// STAGE 1B: Business rules validation
		BusinessRulesOutput businessResult = _businessValidator.Validate(configJson);
		if (businessResult.HasErrors)
		{
			sw.Stop();
			return new TwoStageResult
			{
				IsValid = false,
				Stage = ValidationStage.BusinessRules,
				Failures = businessResult.GetErrorMessages().ToList(),
				LatencyMs = sw.ElapsedMilliseconds,
				Confidence = 1.0,
				BusinessResult = businessResult,
			};
		}

		// Check if UNCERTAIN (needs semantic analysis)
		bool isUncertain = forceSemanticAnalysis || IsUncertain(configJson);

		if (isUncertain && _llmEnabled && !_circuitBreakerTripped)
		{
			// STAGE 2: LLM semantic analysis
			TwoStageResult llmResult = await RunLlmValidationAsync(configJson, sw, cancellationToken);
			llmResult.BusinessResult = businessResult;
			llmResult.SchemaResult = schemaResult;
			return llmResult;
		}

		// PASS: Rule-based only
		sw.Stop();
		return new TwoStageResult
		{
			IsValid = true,
			Stage = ValidationStage.RuleBased,
			Failures = new List<string>(),
			LatencyMs = sw.ElapsedMilliseconds,
			Confidence = 0.95,
			SchemaResult = schemaResult,
			BusinessResult = businessResult,
			Warnings = businessResult.HasWarnings
				? businessResult.Errors.Where(e => e.Severity == RuleSeverity.Warning).Select(e => e.Message).ToList()
				: new List<string>(),
		};
	}

	/// <summary>
	/// Runs the LLM semantic validation (Stage 2).
	/// </summary>
	private async Task<TwoStageResult> RunLlmValidationAsync(string configJson, Stopwatch sw, CancellationToken cancellationToken)
	{
		_llmCallCount++;

		try
		{
			ValidationResult llmResult = await _lmClient!.ValidateConfigAsync(configJson, cancellationToken);
			sw.Stop();

			return new TwoStageResult
			{
				IsValid = llmResult.IsValid,
				Stage = ValidationStage.LlmSemantic,
				Failures = llmResult.Failures,
				LatencyMs = sw.ElapsedMilliseconds,
				Confidence = llmResult.Confidence,
				LlmRawResponse = llmResult.RawResponse,
			};
		}
		catch (Exception ex)
		{
			_llmFailureCount++;
			sw.Stop();

			// SAFETY: Circuit breaker check
			if (_llmCallCount > 0 && (double)_llmFailureCount / _llmCallCount > _circuitBreakerThreshold)
			{
				_circuitBreakerTripped = true;
			}

			// Fail open: if LLM fails, pass with review flag
			return new TwoStageResult
			{
				IsValid = true,
				Stage = ValidationStage.Error,
				Failures = new List<string> { $"llm_error:{ex.Message}" },
				LatencyMs = sw.ElapsedMilliseconds,
				Confidence = 0.5,
				RequiresReview = true,
				LlmError = ex.Message,
			};
		}
	}

	/// <summary>
	/// Determines if a config needs semantic (LLM) analysis.
	/// Configs with unknown fields, experimental flags, or edge cases are UNCERTAIN.
	/// </summary>
	private static bool IsUncertain(string configJson)
	{
		try
		{
			using JsonDocument doc = JsonDocument.Parse(configJson);
			JsonElement root = doc.RootElement;

			// Manual uncertainty markers
			if (root.TryGetProperty("_uncertain", out _))
				return true;
			if (root.TryGetProperty("experimental", out _))
				return true;
			if (root.TryGetProperty("_requires_review", out _))
				return true;

			return false;
		}
		catch
		{
			return false;
		}
	}

	/// <summary>
	/// Checks if config contains a manual override flag requesting human review.
	/// </summary>
	private static bool HasManualOverrideFlag(string configJson)
	{
		try
		{
			using JsonDocument doc = JsonDocument.Parse(configJson);
			JsonElement root = doc.RootElement;

			if (root.TryGetProperty("_requires_review", out JsonElement val) && val.ValueKind == JsonValueKind.True)
			{
				return true;
			}

			return false;
		}
		catch
		{
			return false;
		}
	}

	/// <summary>
	/// SAFETY: Input sanitization. Returns error message if input is unsafe, null if safe.
	/// </summary>
	private static string? SanitizeInput(string input)
	{
		if (string.IsNullOrWhiteSpace(input))
		{
			return "empty_input";
		}

		if (input.Length > MaxInputLength)
		{
			return $"input_too_large:length={input.Length},max={MaxInputLength}";
		}

		return null;
	}

	/// <summary>
	/// Resets the circuit breaker state (manual override).
	/// </summary>
	public void ResetCircuitBreaker()
	{
		_circuitBreakerTripped = false;
		_llmCallCount = 0;
		_llmFailureCount = 0;
	}

	/// <summary>
	/// Whether the LLM circuit breaker has been triggered.
	/// </summary>
	public bool IsCircuitBreakerTripped => _circuitBreakerTripped;

	/// <summary>
	/// Current LLM failure rate.
	/// </summary>
	public double LlmFailureRate => _llmCallCount > 0 ? (double)_llmFailureCount / _llmCallCount : 0.0;

	// ──────────────────────────────────────────────
	// Legacy batch validation support
	// ──────────────────────────────────────────────

	/// <summary>
	/// Runs the full validation pipeline on a set of test samples.
	/// Returns detailed metrics including accuracy, precision, recall, and per-sample results.
	/// </summary>
	public async Task<PipelineResult> RunValidationAsync(IReadOnlyList<ValidationSample> samples, CancellationToken cancellationToken = default)
	{
		PipelineResult result = new()
		{
			Timestamp = DateTime.UtcNow,
			TotalSamples = samples.Count,
			AccuracyThreshold = 0.95,
			MaxLatencyMs = 50.0,
		};

		Stopwatch totalSw = Stopwatch.StartNew();
		int truePositives = 0;
		int trueNegatives = 0;
		int falsePositives = 0;
		int falseNegatives = 0;

		foreach (ValidationSample sample in samples)
		{
			cancellationToken.ThrowIfCancellationRequested();

			TwoStageResult twoStage = await ValidateAsync(sample.ConfigJson, cancellationToken: cancellationToken);

			SampleResult sampleResult = new()
			{
				SampleName = sample.Name,
				PredictedValid = twoStage.IsValid,
				ExpectedValid = sample.ExpectedValid,
				Confidence = twoStage.Confidence,
				LatencyMs = twoStage.LatencyMs,
				PredictedFailures = twoStage.Failures,
				ExpectedFailures = sample.ExpectedFailures,
				RawResponse = twoStage.LlmRawResponse ?? $"Stage:{twoStage.Stage}",
			};

			// Track accuracy metrics
			if (sampleResult.PredictedValid == sample.ExpectedValid)
			{
				sampleResult.Correct = true;
				if (sample.ExpectedValid)
					truePositives++;
				else
					trueNegatives++;
			}
			else
			{
				sampleResult.Correct = false;
				if (sampleResult.PredictedValid)
					falsePositives++;
				else
					falseNegatives++;
			}

			result.SampleResults.Add(sampleResult);
		}

		totalSw.Stop();

		// Calculate metrics
		result.CorrectCount = truePositives + trueNegatives;
		result.Accuracy = samples.Count > 0 ? (double)result.CorrectCount / samples.Count : 0.0;

		int totalPositivePredictions = truePositives + falsePositives;
		result.Precision = totalPositivePredictions > 0 ? (double)truePositives / totalPositivePredictions : 0.0;

		int totalActualPositives = truePositives + falseNegatives;
		result.Recall = totalActualPositives > 0 ? (double)truePositives / totalActualPositives : 0.0;

		result.F1Score = (result.Precision + result.Recall) > 0 ? 2.0 * (result.Precision * result.Recall) / (result.Precision + result.Recall) : 0.0;

		result.AverageLatencyMs = result.SampleResults.Count > 0 ? result.SampleResults.Average(s => s.LatencyMs) : 0.0;

		result.MaxObservedLatencyMs = result.SampleResults.Count > 0 ? result.SampleResults.Max(s => s.LatencyMs) : 0.0;

		result.TotalDurationMs = totalSw.ElapsedMilliseconds;

		// Pass/fail determination
		result.AccuracyPassed = result.Accuracy >= result.AccuracyThreshold;
		result.LatencyPassed = result.AverageLatencyMs <= result.MaxLatencyMs;
		result.OverallPassed = result.AccuracyPassed && result.LatencyPassed;

		result.TruePositives = truePositives;
		result.TrueNegatives = trueNegatives;
		result.FalsePositives = falsePositives;
		result.FalseNegatives = falseNegatives;

		return result;
	}

	/// <summary>
	/// Loads validation samples from a JSON file or directory of JSON files.
	/// </summary>
	public static async Task<List<ValidationSample>> LoadSamplesAsync(string path, CancellationToken cancellationToken = default)
	{
		List<ValidationSample> samples = new();

		if (File.Exists(path))
		{
			string json = await File.ReadAllTextAsync(path, cancellationToken);
			ValidationSample? sample = ParseSampleFile(json, Path.GetFileNameWithoutExtension(path));
			if (sample != null)
				samples.Add(sample);
		}
		else if (Directory.Exists(path))
		{
			foreach (string file in Directory.GetFiles(path, "*.json").OrderBy(f => f))
			{
				string json = await File.ReadAllTextAsync(file, cancellationToken);
				ValidationSample? sample = ParseSampleFile(json, Path.GetFileNameWithoutExtension(file));
				if (sample != null)
					samples.Add(sample);
			}
		}

		return samples;
	}

	private static ValidationSample? ParseSampleFile(string json, string name)
	{
		try
		{
			using JsonDocument doc = JsonDocument.Parse(json);
			JsonElement root = doc.RootElement;

			string sampleName = root.TryGetProperty("name", out JsonElement n) ? n.GetString() ?? name : name;

			string configJson = root.TryGetProperty("config", out JsonElement cfg) ? cfg.GetRawText() : json;

			bool expectedValid = false;
			List<string> expectedFailures = new();

			if (root.TryGetProperty("expected", out JsonElement expected))
			{
				if (expected.TryGetProperty("valid", out JsonElement v))
				{
					expectedValid = v.GetBoolean();
				}
				if (expected.TryGetProperty("failures", out JsonElement f) && f.ValueKind == JsonValueKind.Array)
				{
					foreach (JsonElement item in f.EnumerateArray())
					{
						string? s = item.GetString();
						if (s != null)
							expectedFailures.Add(s);
					}
				}
			}

			return new ValidationSample
			{
				Name = sampleName,
				ConfigJson = configJson,
				ExpectedValid = expectedValid,
				ExpectedFailures = expectedFailures,
			};
		}
		catch
		{
			return null;
		}
	}

	/// <summary>
	/// Saves pipeline results to a JSON file.
	/// </summary>
	public static async Task SaveResultsAsync(PipelineResult result, string outputPath, CancellationToken cancellationToken = default)
	{
		JsonSerializerOptions options = new() { WriteIndented = true, Converters = { new JsonStringEnumConverter() } };

		string json = JsonSerializer.Serialize(result, options);
		string? dir = Path.GetDirectoryName(outputPath);
		if (dir != null && !Directory.Exists(dir))
		{
			Directory.CreateDirectory(dir);
		}
		await File.WriteAllTextAsync(outputPath, json, cancellationToken);
	}
}

/// <summary>
/// Result of two-stage validation pipeline.
/// </summary>
public sealed class TwoStageResult
{
	public bool IsValid { get; init; }
	public ValidationStage Stage { get; init; }
	public List<string> Failures { get; init; } = new();
	public long LatencyMs { get; init; }
	public double Confidence { get; init; }
	public bool RequiresReview { get; init; }
	public List<string> Warnings { get; init; } = new();
	public SchemaValidationOutput? SchemaResult { get; set; }
	public BusinessRulesOutput? BusinessResult { get; set; }
	public string? LlmRawResponse { get; init; }
	public string? LlmError { get; init; }
}

/// <summary>
/// A validation test sample with expected outcome.
/// </summary>
public sealed class ValidationSample
{
	public string Name { get; init; } = string.Empty;
	public string ConfigJson { get; init; } = string.Empty;
	public bool ExpectedValid { get; init; }
	public List<string> ExpectedFailures { get; init; } = new();
}

/// <summary>
/// Result for a single validation sample.
/// </summary>
public sealed class SampleResult
{
	public string SampleName { get; init; } = string.Empty;
	public bool PredictedValid { get; init; }
	public bool ExpectedValid { get; init; }
	public bool Correct { get; set; }
	public double Confidence { get; init; }
	public long LatencyMs { get; init; }
	public List<string> PredictedFailures { get; init; } = new();
	public List<string> ExpectedFailures { get; init; } = new();
	public string? Error { get; init; }
	public string RawResponse { get; init; } = string.Empty;
}

/// <summary>
/// Full pipeline validation result with accuracy, precision, recall, and F1.
/// </summary>
public sealed class PipelineResult
{
	public DateTime Timestamp { get; init; }
	public int TotalSamples { get; init; }
	public int CorrectCount { get; set; }
	public double Accuracy { get; set; }
	public double Precision { get; set; }
	public double Recall { get; set; }
	public double F1Score { get; set; }
	public double AverageLatencyMs { get; set; }
	public double MaxObservedLatencyMs { get; set; }
	public long TotalDurationMs { get; set; }
	public double AccuracyThreshold { get; init; }
	public double MaxLatencyMs { get; init; }
	public bool AccuracyPassed { get; set; }
	public bool LatencyPassed { get; set; }
	public bool OverallPassed { get; set; }
	public int TruePositives { get; set; }
	public int TrueNegatives { get; set; }
	public int FalsePositives { get; set; }
	public int FalseNegatives { get; set; }
	public List<SampleResult> SampleResults { get; init; } = new();
}
