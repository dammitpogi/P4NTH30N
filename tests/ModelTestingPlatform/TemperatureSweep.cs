using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTH30N.ModelTestingPlatform;

/// <summary>
/// Sweeps temperature parameter across a range and measures model performance at each setting.
/// ARCH-003-PIVOT mandate: test temps 0.0, 0.1, 0.3, 0.5, 0.7, 1.0.
/// CRITICAL: Run SmolLM2-1.7B with temp=0.0 + improved prompts first.
/// </summary>
public sealed class TemperatureSweep {
	private readonly ILlmBackend _backend;
	private readonly string _systemPrompt;
	private readonly int _runsPerTemp;

	/// <summary>
	/// Default temperature values to sweep (ARCH-003-PIVOT specification).
	/// </summary>
	public static readonly double[] DefaultTemperatures = { 0.0, 0.1, 0.3, 0.5, 0.7, 1.0 };

	public TemperatureSweep(
		ILlmBackend backend,
		string? systemPrompt = null,
		int runsPerTemp = 3) {
		_backend = backend;
		_systemPrompt = systemPrompt ?? P4NTH30N.DeployLogAnalyzer.FewShotPrompt.GetConfigValidationPrompt();
		_runsPerTemp = runsPerTemp;
	}

	/// <summary>
	/// Runs a full temperature sweep across all test cases at each temperature.
	/// Returns results ordered by temperature for comparison.
	/// </summary>
	public async Task<TemperatureSweepReport> RunSweepAsync(
		IReadOnlyList<TestCase> testCases,
		double[]? temperatures = null,
		CancellationToken cancellationToken = default) {
		double[] temps = temperatures ?? DefaultTemperatures;
		List<TemperaturePoint> points = new();
		long totalStartMs = Environment.TickCount64;

		foreach (double temp in temps) {
			cancellationToken.ThrowIfCancellationRequested();

			TemperaturePoint point = await RunAtTemperatureAsync(
				testCases, temp, cancellationToken);
			points.Add(point);
		}

		long totalDurationMs = Environment.TickCount64 - totalStartMs;

		// Find optimal temperature (highest accuracy, lowest variance as tiebreaker)
		TemperaturePoint? optimal = points
			.OrderByDescending(p => p.Accuracy)
			.ThenBy(p => p.MeanVariance)
			.ThenBy(p => p.MeanLatencyMs)
			.FirstOrDefault();

		return new TemperatureSweepReport {
			ModelId = _backend.ModelId,
			TestCaseCount = testCases.Count,
			RunsPerTemperature = _runsPerTemp,
			Points = points,
			OptimalTemperature = optimal?.Temperature ?? 0.0,
			OptimalAccuracy = optimal?.Accuracy ?? 0.0,
			TotalDurationMs = totalDurationMs,
			MeetsDecisionGate = optimal?.MeetsDecisionGate ?? false,
		};
	}

	/// <summary>
	/// Runs all test cases at a single temperature setting, N times each.
	/// </summary>
	private async Task<TemperaturePoint> RunAtTemperatureAsync(
		IReadOnlyList<TestCase> testCases,
		double temperature,
		CancellationToken cancellationToken) {
		InferenceParams p = new() {
			Temperature = temperature,
			TopP = temperature == 0.0 ? 1.0 : 0.9,
			TopK = temperature == 0.0 ? 1 : 40,
			DoSample = temperature > 0.0,
			MaxTokens = 512,
		};

		PromptConsistencyTester tester = new(_backend, _systemPrompt, _runsPerTemp);
		ConsistencyReport report = await tester.RunFullConsistencyTestAsync(
			testCases, p, cancellationToken);

		return new TemperaturePoint {
			Temperature = temperature,
			Accuracy = report.OverallAccuracy,
			MeanVariance = report.OverallVariance,
			JsonValidRate = report.OverallJsonValidRate,
			MeanLatencyMs = report.MeanLatencyMs,
			IsProductionReady = report.IsProductionReady,
			MeetsDecisionGate = report.MeetsDecisionGate,
			TestResults = report.TestResults,
		};
	}

	/// <summary>
	/// Runs only the critical temp=0.0 test (fast path for decision gate evaluation).
	/// This is the first test to run per Oracle mandate.
	/// </summary>
	public async Task<TemperaturePoint> RunCriticalDeterministicTestAsync(
		IReadOnlyList<TestCase> testCases,
		CancellationToken cancellationToken = default) {
		return await RunAtTemperatureAsync(testCases, 0.0, cancellationToken);
	}
}

/// <summary>
/// Performance data for a single temperature setting.
/// </summary>
public sealed class TemperaturePoint {
	public double Temperature { get; init; }
	public double Accuracy { get; init; }
	public double MeanVariance { get; init; }
	public double JsonValidRate { get; init; }
	public double MeanLatencyMs { get; init; }
	public bool IsProductionReady { get; init; }
	public bool MeetsDecisionGate { get; init; }
	public List<ConsistencyResult> TestResults { get; init; } = new();

	public override string ToString() {
		string gate = MeetsDecisionGate ? "PASS" : "FAIL";
		string prod = IsProductionReady ? "PROD" : "UNSTABLE";
		return $"temp={Temperature:F1} | Accuracy: {Accuracy:P1} | Variance: {MeanVariance:P2} | " +
			$"JSON: {JsonValidRate:P1} | Latency: {MeanLatencyMs:F0}ms | Gate: {gate} | {prod}";
	}
}

/// <summary>
/// Full temperature sweep report with optimal temperature identification.
/// </summary>
public sealed class TemperatureSweepReport {
	public string ModelId { get; init; } = string.Empty;
	public int TestCaseCount { get; init; }
	public int RunsPerTemperature { get; init; }
	public double OptimalTemperature { get; init; }
	public double OptimalAccuracy { get; init; }
	public bool MeetsDecisionGate { get; init; }
	public long TotalDurationMs { get; init; }
	public List<TemperaturePoint> Points { get; init; } = new();
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	/// <summary>
	/// Human-readable sweep summary.
	/// </summary>
	public override string ToString() {
		string gate = MeetsDecisionGate ? "PASS (>=70%)" : "FAIL (<70%)";
		return $"""
			=== Temperature Sweep: {ModelId} ===
			Test Cases: {TestCaseCount}
			Runs per Temperature: {RunsPerTemperature}
			Optimal Temperature: {OptimalTemperature:F1}
			Optimal Accuracy: {OptimalAccuracy:P1}
			Decision Gate: {gate}
			Total Duration: {TotalDurationMs}ms
			--- Per-Temperature ---
			{string.Join("\n", Points.Select(p => p.ToString()))}
			""";
	}

	/// <summary>
	/// Generates the Oracle decision gate evaluation.
	/// </summary>
	public string EvaluateDecisionGate() {
		if (OptimalAccuracy >= 0.70) {
			return $"DECISION GATE: PASS - {ModelId} achieves {OptimalAccuracy:P1} at temp={OptimalTemperature:F1}. " +
				"Keep LLM as secondary validator in hybrid pipeline.";
		}
		if (OptimalAccuracy >= 0.60) {
			return $"DECISION GATE: REVIEW REQUIRED - {ModelId} achieves {OptimalAccuracy:P1} at temp={OptimalTemperature:F1}. " +
				"Between 60-70% threshold. Manual review needed before proceeding.";
		}
		return $"DECISION GATE: FAIL - {ModelId} peaks at {OptimalAccuracy:P1} (temp={OptimalTemperature:F1}). " +
			"Below 60% threshold. Pivot to pure rule-based validation.";
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