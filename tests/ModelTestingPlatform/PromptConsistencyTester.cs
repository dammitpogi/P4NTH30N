using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTH30N.ModelTestingPlatform;

/// <summary>
/// Tests prompt consistency by running the same test case N times and measuring variance.
/// Oracle mandate: n=10 runs, acceptance criteria: variance < 5% = production ready.
/// </summary>
public sealed class PromptConsistencyTester {
	private readonly ILlmBackend _backend;
	private readonly string _systemPrompt;
	private readonly int _runsPerTest;

	/// <summary>
	/// Default runs per test case (Oracle-mandated n=10).
	/// </summary>
	public const int DefaultRunCount = 10;

	/// <summary>
	/// Maximum acceptable variance for production readiness (5%).
	/// </summary>
	public const double MaxProductionVariance = 0.05;

	public PromptConsistencyTester(
		ILlmBackend backend,
		string? systemPrompt = null,
		int runsPerTest = DefaultRunCount) {
		_backend = backend;
		_systemPrompt = systemPrompt ?? P4NTH30N.DeployLogAnalyzer.FewShotPrompt.GetConfigValidationPrompt();
		_runsPerTest = runsPerTest;
	}

	/// <summary>
	/// Runs a single test case N times and measures consistency metrics.
	/// </summary>
	public async Task<ConsistencyResult> MeasureConsistencyAsync(
		TestCase testCase,
		InferenceParams? inferenceParams = null,
		CancellationToken cancellationToken = default) {
		InferenceParams p = inferenceParams ?? new InferenceParams();
		ModelTestHarness harness = new(_backend, _systemPrompt);

		List<TestCaseResult> runs = new();

		for (int i = 0; i < _runsPerTest; i++) {
			cancellationToken.ThrowIfCancellationRequested();
			TestCaseResult result = await harness.RunTestAsync(testCase, p, cancellationToken);
			runs.Add(result);
		}

		return CalculateConsistency(testCase, runs, p);
	}

	/// <summary>
	/// Runs all test cases N times each and produces a full consistency report.
	/// </summary>
	public async Task<ConsistencyReport> RunFullConsistencyTestAsync(
		IReadOnlyList<TestCase> testCases,
		InferenceParams? inferenceParams = null,
		CancellationToken cancellationToken = default) {
		List<ConsistencyResult> results = new();
		long totalStartMs = Environment.TickCount64;

		foreach (TestCase tc in testCases) {
			cancellationToken.ThrowIfCancellationRequested();
			ConsistencyResult result = await MeasureConsistencyAsync(tc, inferenceParams, cancellationToken);
			results.Add(result);
		}

		long totalDurationMs = Environment.TickCount64 - totalStartMs;

		return new ConsistencyReport {
			ModelId = _backend.ModelId,
			Params = inferenceParams ?? new InferenceParams(),
			RunsPerTest = _runsPerTest,
			TestResults = results,
			OverallAccuracy = results.Count > 0 ? results.Average(r => r.AccuracyRate) : 0.0,
			OverallVariance = results.Count > 0 ? results.Average(r => r.VarianceScore) : 0.0,
			OverallJsonValidRate = results.Count > 0 ? results.Average(r => r.JsonValidRate) : 0.0,
			MeanLatencyMs = results.Count > 0 ? results.Average(r => r.MeanLatencyMs) : 0.0,
			TotalDurationMs = totalDurationMs,
			IsProductionReady = results.Count > 0 && results.All(r => r.IsProductionReady),
			MeetsDecisionGate = results.Count > 0 &&
				results.Average(r => r.AccuracyRate) >= 0.70,
		};
	}

	private ConsistencyResult CalculateConsistency(
		TestCase testCase,
		List<TestCaseResult> runs,
		InferenceParams p) {
		int totalRuns = runs.Count;
		int correctRuns = runs.Count(r => r.Correct);
		int jsonValidRuns = runs.Count(r => r.JsonValid);
		int predictedTrueCount = runs.Count(r => r.PredictedValid);
		int predictedFalseCount = runs.Count(r => !r.PredictedValid);

		double accuracyRate = totalRuns > 0 ? (double)correctRuns / totalRuns : 0.0;
		double jsonValidRate = totalRuns > 0 ? (double)jsonValidRuns / totalRuns : 0.0;

		// Variance: measure how often the prediction flips between runs.
		// 0.0 = perfectly consistent (all same answer), 0.5 = max variance (50/50 split).
		double predictionVariance = CalculatePredictionVariance(runs);

		// Standard error of accuracy across runs (binary outcomes).
		double standardError = CalculateStandardError(runs);

		// Latency stats
		double meanLatency = runs.Count > 0 ? runs.Average(r => r.LatencyMs) : 0.0;
		double maxLatency = runs.Count > 0 ? runs.Max(r => r.LatencyMs) : 0.0;
		double minLatency = runs.Count > 0 ? runs.Min(r => r.LatencyMs) : 0.0;
		double stdDevLatency = CalculateStdDev(runs.Select(r => (double)r.LatencyMs));

		// Confidence stats
		double meanConfidence = runs.Where(r => r.JsonValid).Select(r => r.Confidence).DefaultIfEmpty(0.0).Average();
		double stdDevConfidence = CalculateStdDev(runs.Where(r => r.JsonValid).Select(r => r.Confidence));

		return new ConsistencyResult {
			TestName = testCase.Name,
			ExpectedValid = testCase.ExpectedValid,
			ModelId = _backend.ModelId,
			Params = p,
			TotalRuns = totalRuns,
			CorrectRuns = correctRuns,
			AccuracyRate = accuracyRate,
			JsonValidRuns = jsonValidRuns,
			JsonValidRate = jsonValidRate,
			PredictedTrueCount = predictedTrueCount,
			PredictedFalseCount = predictedFalseCount,
			VarianceScore = predictionVariance,
			StandardError = standardError,
			MeanLatencyMs = meanLatency,
			MaxLatencyMs = maxLatency,
			MinLatencyMs = minLatency,
			StdDevLatencyMs = stdDevLatency,
			MeanConfidence = meanConfidence,
			StdDevConfidence = stdDevConfidence,
			IsProductionReady = predictionVariance < MaxProductionVariance,
			Runs = runs,
		};
	}

	/// <summary>
	/// Calculates prediction variance as proportion of minority class.
	/// 0.0 = all predictions identical, 0.5 = maximum disagreement.
	/// </summary>
	private static double CalculatePredictionVariance(List<TestCaseResult> runs) {
		if (runs.Count == 0) return 0.0;

		int trueCount = runs.Count(r => r.PredictedValid);
		int falseCount = runs.Count - trueCount;
		int minority = Math.Min(trueCount, falseCount);

		return (double)minority / runs.Count;
	}

	/// <summary>
	/// Standard error for binary outcome (correct/incorrect).
	/// SE = sqrt(p * (1-p) / n)
	/// </summary>
	private static double CalculateStandardError(List<TestCaseResult> runs) {
		if (runs.Count <= 1) return 0.0;

		double p = (double)runs.Count(r => r.Correct) / runs.Count;
		return Math.Sqrt(p * (1.0 - p) / runs.Count);
	}

	/// <summary>
	/// Calculates standard deviation for a sequence of doubles.
	/// </summary>
	private static double CalculateStdDev(IEnumerable<double> values) {
		List<double> list = values.ToList();
		if (list.Count <= 1) return 0.0;

		double mean = list.Average();
		double sumSquaredDiffs = list.Sum(v => (v - mean) * (v - mean));
		return Math.Sqrt(sumSquaredDiffs / (list.Count - 1));
	}
}

/// <summary>
/// Consistency measurement for a single test case across N runs.
/// </summary>
public sealed class ConsistencyResult {
	public string TestName { get; init; } = string.Empty;
	public bool ExpectedValid { get; init; }
	public string ModelId { get; init; } = string.Empty;
	public InferenceParams Params { get; init; } = new();
	public int TotalRuns { get; init; }
	public int CorrectRuns { get; init; }
	public double AccuracyRate { get; init; }
	public int JsonValidRuns { get; init; }
	public double JsonValidRate { get; init; }
	public int PredictedTrueCount { get; init; }
	public int PredictedFalseCount { get; init; }

	/// <summary>
	/// Prediction variance: 0.0 = perfectly consistent, 0.5 = max disagreement.
	/// </summary>
	public double VarianceScore { get; init; }

	/// <summary>
	/// Standard error of accuracy: sqrt(p*(1-p)/n).
	/// </summary>
	public double StandardError { get; init; }

	public double MeanLatencyMs { get; init; }
	public double MaxLatencyMs { get; init; }
	public double MinLatencyMs { get; init; }
	public double StdDevLatencyMs { get; init; }
	public double MeanConfidence { get; init; }
	public double StdDevConfidence { get; init; }

	/// <summary>
	/// Production ready: variance below 5% threshold.
	/// </summary>
	public bool IsProductionReady { get; init; }

	/// <summary>
	/// Individual run results (for detailed analysis).
	/// </summary>
	[JsonIgnore]
	public List<TestCaseResult> Runs { get; init; } = new();

	public override string ToString() {
		string status = IsProductionReady ? "PROD-READY" : "UNSTABLE";
		return $"[{TestName}] Accuracy: {AccuracyRate:P0} | Variance: {VarianceScore:P1} | " +
			$"SE: {StandardError:F4} | Latency: {MeanLatencyMs:F0}ms +/- {StdDevLatencyMs:F0}ms | {status}";
	}
}

/// <summary>
/// Full consistency report across all test cases.
/// </summary>
public sealed class ConsistencyReport {
	public string ModelId { get; init; } = string.Empty;
	public InferenceParams Params { get; init; } = new();
	public int RunsPerTest { get; init; }
	public double OverallAccuracy { get; init; }
	public double OverallVariance { get; init; }
	public double OverallJsonValidRate { get; init; }
	public double MeanLatencyMs { get; init; }
	public long TotalDurationMs { get; init; }
	public bool IsProductionReady { get; init; }
	public bool MeetsDecisionGate { get; init; }
	public List<ConsistencyResult> TestResults { get; init; } = new();
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	/// <summary>
	/// Human-readable summary.
	/// </summary>
	public override string ToString() {
		string gate = MeetsDecisionGate ? "PASS (>=70%)" : "FAIL (<70%)";
		string prod = IsProductionReady ? "YES" : "NO";
		return $"""
			=== Consistency Report: {ModelId} ===
			Params: {Params}
			Runs per test: {RunsPerTest}
			Overall Accuracy: {OverallAccuracy:P1}
			Overall Variance: {OverallVariance:P2}
			JSON Valid Rate: {OverallJsonValidRate:P1}
			Mean Latency: {MeanLatencyMs:F0}ms
			Total Duration: {TotalDurationMs}ms
			Decision Gate: {gate}
			Production Ready: {prod}
			--- Per-Test ---
			{string.Join("\n", TestResults.Select(r => r.ToString()))}
			""";
	}

	/// <summary>
	/// Serializes to JSON for persistence.
	/// </summary>
	public string ToJson() {
		JsonSerializerOptions options = new() {
			WriteIndented = true,
			Converters = { new JsonStringEnumConverter() },
		};
		return JsonSerializer.Serialize(this, options);
	}

	/// <summary>
	/// Saves report to disk.
	/// </summary>
	public async Task SaveAsync(string path, CancellationToken cancellationToken = default) {
		string? dir = Path.GetDirectoryName(path);
		if (dir != null && !Directory.Exists(dir)) {
			Directory.CreateDirectory(dir);
		}
		await File.WriteAllTextAsync(path, ToJson(), cancellationToken);
	}
}