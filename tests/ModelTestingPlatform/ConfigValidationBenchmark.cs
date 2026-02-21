using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTH30N.ModelTestingPlatform;

/// <summary>
/// ARCH-003 task benchmark: validates model ability to classify P4NTH30N credential configs.
/// 20 test configs: 10 valid, 10 invalid with various failure modes.
/// Metrics: precision, recall, F1, accuracy, latency.
/// </summary>
public sealed class ConfigValidationBenchmark
{
	private readonly ILlmBackend _backend;
	private readonly string _systemPrompt;

	public ConfigValidationBenchmark(ILlmBackend backend, string? systemPrompt = null)
	{
		_backend = backend;
		_systemPrompt = systemPrompt ?? P4NTH30N.DeployLogAnalyzer.FewShotPrompt.GetConfigValidationPrompt();
	}

	/// <summary>
	/// Runs the full 20-config benchmark and returns detailed metrics.
	/// </summary>
	public async Task<BenchmarkReport> RunBenchmarkAsync(InferenceParams? inferenceParams = null, CancellationToken cancellationToken = default)
	{
		List<TestCase> testCases = GenerateTestCases();
		ModelTestHarness harness = new(_backend, _systemPrompt);

		BatchTestResult batch = await harness.RunBatchAsync(testCases, inferenceParams, cancellationToken);

		// Calculate precision, recall, F1
		int tp = 0,
			fp = 0,
			tn = 0,
			fn = 0;
		foreach (TestCaseResult result in batch.Results)
		{
			if (result.ExpectedValid && result.PredictedValid)
				tp++;
			else if (!result.ExpectedValid && result.PredictedValid)
				fp++;
			else if (!result.ExpectedValid && !result.PredictedValid)
				tn++;
			else if (result.ExpectedValid && !result.PredictedValid)
				fn++;
		}

		double precision = (tp + fp) > 0 ? (double)tp / (tp + fp) : 0.0;
		double recall = (tp + fn) > 0 ? (double)tp / (tp + fn) : 0.0;
		double f1 = (precision + recall) > 0 ? 2.0 * precision * recall / (precision + recall) : 0.0;

		return new BenchmarkReport
		{
			BenchmarkName = "ConfigValidation",
			ModelId = _backend.ModelId,
			Params = inferenceParams ?? new InferenceParams(),
			TotalTests = testCases.Count,
			Accuracy = batch.Accuracy,
			Precision = precision,
			Recall = recall,
			F1Score = f1,
			TruePositives = tp,
			FalsePositives = fp,
			TrueNegatives = tn,
			FalseNegatives = fn,
			MeanLatencyMs = batch.MeanLatencyMs,
			MaxLatencyMs = batch.MaxLatencyMs,
			JsonValidRate = batch.JsonValidRate,
			TotalDurationMs = batch.TotalDurationMs,
			Results = batch.Results,
			MeetsDecisionGate = batch.MeetsDecisionGate(),
		};
	}

	/// <summary>
	/// Generates the 20 standardized test configurations.
	/// 10 valid + 10 invalid covering all known failure modes.
	/// </summary>
	public static List<TestCase> GenerateTestCases()
	{
		List<TestCase> cases = new();

		// ── 10 VALID configs ──
		cases.Add(
			MakeCase(
				"valid-standard",
				true,
				new
				{
					username = "player1",
					password = "secure123",
					platform = "firekirin",
					house = "house-alpha",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-orionstars",
				true,
				new
				{
					username = "starplayer",
					password = "p@ss!",
					platform = "orionstars",
					house = "star-house",
					category = "slots",
					thresholdMinor = 300,
					thresholdMajor = 800,
					thresholdGrand = 1500,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-min-thresholds",
				true,
				new
				{
					username = "minplay",
					password = "min123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 1,
					thresholdMajor = 2,
					thresholdGrand = 3,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-high-thresholds",
				true,
				new
				{
					username = "whale",
					password = "bigbet999",
					platform = "orionstars",
					house = "vip-room",
					category = "slots",
					thresholdMinor = 5000,
					thresholdMajor = 10000,
					thresholdGrand = 50000,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-special-chars-name",
				true,
				new
				{
					username = "user_2024-v2",
					password = "complex!@#",
					platform = "firekirin",
					house = "house-1",
					category = "fish",
					thresholdMinor = 100,
					thresholdMajor = 500,
					thresholdGrand = 1000,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-equal-minor-major",
				true,
				new
				{
					username = "edgeuser",
					password = "edge123",
					platform = "firekirin",
					house = "h2",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 500,
					thresholdGrand = 1000,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-numeric-house",
				true,
				new
				{
					username = "numhouse",
					password = "num456",
					platform = "orionstars",
					house = "12345",
					category = "slots",
					thresholdMinor = 200,
					thresholdMajor = 600,
					thresholdGrand = 1200,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-long-password",
				true,
				new
				{
					username = "longpw",
					password = "thisIsAVeryLongPasswordThatShouldStillBeValid123!",
					platform = "firekirin",
					house = "h3",
					category = "fish",
					thresholdMinor = 400,
					thresholdMajor = 900,
					thresholdGrand = 1600,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-category-keno",
				true,
				new
				{
					username = "kenoplay",
					password = "keno789",
					platform = "orionstars",
					house = "keno-room",
					category = "keno",
					thresholdMinor = 150,
					thresholdMajor = 450,
					thresholdGrand = 900,
				}
			)
		);
		cases.Add(
			MakeCase(
				"valid-all-fields",
				true,
				new
				{
					username = "complete",
					password = "full123",
					platform = "firekirin",
					house = "complete-house",
					category = "fish",
					thresholdMinor = 250,
					thresholdMajor = 750,
					thresholdGrand = 1500,
					notes = "optional field",
					enabled = true,
				}
			)
		);

		// ── 10 INVALID configs ──
		cases.Add(
			MakeCase(
				"invalid-missing-username",
				false,
				new
				{
					password = "nouser123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				},
				new List<string> { "missing_required_field:username" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-missing-platform",
				false,
				new
				{
					username = "noplatform",
					password = "abc123",
					house = "h1",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				},
				new List<string> { "missing_required_field:platform" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-threshold-order",
				false,
				new
				{
					username = "badorder",
					password = "order123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 1000,
					thresholdMajor = 500,
					thresholdGrand = 1785,
				},
				new List<string> { "threshold_order_violation" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-empty-username",
				false,
				new
				{
					username = "",
					password = "empty123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				},
				new List<string> { "empty_required_field:username" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-negative-threshold",
				false,
				new
				{
					username = "negthresh",
					password = "neg123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = -100,
					thresholdMajor = 500,
					thresholdGrand = 1000,
				},
				new List<string> { "negative_threshold" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-xss-injection",
				false,
				new
				{
					username = "<script>alert('xss')</script>",
					password = "hack123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				},
				new List<string> { "injection_detected" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-sql-injection",
				false,
				new
				{
					username = "admin'; DROP TABLE users;--",
					password = "hack456",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				},
				new List<string> { "injection_detected" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-zero-thresholds",
				false,
				new
				{
					username = "zerothresh",
					password = "zero123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
					thresholdMinor = 0,
					thresholdMajor = 0,
					thresholdGrand = 0,
				},
				new List<string> { "zero_threshold" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-unknown-platform",
				false,
				new
				{
					username = "badplat",
					password = "plat123",
					platform = "nonexistent_casino",
					house = "h1",
					category = "fish",
					thresholdMinor = 500,
					thresholdMajor = 1000,
					thresholdGrand = 1785,
				},
				new List<string> { "unknown_platform" }
			)
		);

		cases.Add(
			MakeCase(
				"invalid-missing-all-thresholds",
				false,
				new
				{
					username = "nothresh",
					password = "thresh123",
					platform = "firekirin",
					house = "h1",
					category = "fish",
				},
				new List<string> { "missing_required_field:thresholdMinor", "missing_required_field:thresholdMajor", "missing_required_field:thresholdGrand" }
			)
		);

		return cases;
	}

	private static TestCase MakeCase(string name, bool expectedValid, object config, List<string>? expectedFailures = null)
	{
		string configJson = JsonSerializer.Serialize(config, new JsonSerializerOptions { WriteIndented = true });
		return new TestCase
		{
			Name = name,
			ConfigJson = configJson,
			ExpectedValid = expectedValid,
			ExpectedFailures = expectedFailures ?? new List<string>(),
		};
	}
}

/// <summary>
/// Benchmark result with precision, recall, F1, and confusion matrix.
/// </summary>
public sealed class BenchmarkReport
{
	public string BenchmarkName { get; init; } = string.Empty;
	public string ModelId { get; init; } = string.Empty;
	public InferenceParams Params { get; init; } = new();
	public int TotalTests { get; init; }
	public double Accuracy { get; init; }
	public double Precision { get; init; }
	public double Recall { get; init; }
	public double F1Score { get; init; }
	public int TruePositives { get; init; }
	public int FalsePositives { get; init; }
	public int TrueNegatives { get; init; }
	public int FalseNegatives { get; init; }
	public double MeanLatencyMs { get; init; }
	public double MaxLatencyMs { get; init; }
	public double JsonValidRate { get; init; }
	public long TotalDurationMs { get; init; }
	public bool MeetsDecisionGate { get; init; }
	public List<TestCaseResult> Results { get; init; } = new();
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	public override string ToString()
	{
		string gate = MeetsDecisionGate ? "PASS" : "FAIL";
		return $"""
			=== {BenchmarkName} Benchmark: {ModelId} ===
			Accuracy:  {Accuracy:P1} ({TruePositives + TrueNegatives}/{TotalTests})
			Precision: {Precision:P1}
			Recall:    {Recall:P1}
			F1 Score:  {F1Score:P3}
			Confusion Matrix: TP={TruePositives} FP={FalsePositives} TN={TrueNegatives} FN={FalseNegatives}
			JSON Valid: {JsonValidRate:P1}
			Latency:   {MeanLatencyMs:F0}ms mean, {MaxLatencyMs:F0}ms max
			Gate: {gate}
			""";
	}

	public string ToJson()
	{
		JsonSerializerOptions options = new() { WriteIndented = true, Converters = { new JsonStringEnumConverter() } };
		return JsonSerializer.Serialize(this, options);
	}

	public async Task SaveAsync(string path, CancellationToken cancellationToken = default)
	{
		string? dir = Path.GetDirectoryName(path);
		if (dir != null && !Directory.Exists(dir))
		{
			Directory.CreateDirectory(dir);
		}
		await File.WriteAllTextAsync(path, ToJson(), cancellationToken);
	}
}
