using System.Diagnostics;
using System.Text;

namespace P4NTH30N.ModelTestingPlatform;

/// <summary>
/// Binary search discovery for model context window limits.
/// Tests input-only, output-only, and total context capacity.
/// Critical for understanding model behavior at boundary conditions.
/// </summary>
public sealed class ContextWindowDiscovery {
	private readonly ILlmBackend _backend;
	private readonly int _maxSearchTokens;
	private readonly int _stepSize;

	public ContextWindowDiscovery(
		ILlmBackend backend,
		int maxSearchTokens = 8192,
		int stepSize = 256) {
		_backend = backend;
		_maxSearchTokens = maxSearchTokens;
		_stepSize = stepSize;
	}

	/// <summary>
	/// Discovers the maximum input context the model can handle.
	/// Uses binary search: doubles input until failure, then bisects.
	/// </summary>
	public async Task<ContextWindowResult> DiscoverInputLimitAsync(
		CancellationToken cancellationToken = default) {
		int low = _stepSize;
		int high = _maxSearchTokens;
		int lastSuccess = 0;
		long lastSuccessLatencyMs = 0;
		List<ContextProbe> probes = new();

		// Binary search for input limit
		while (low <= high) {
			cancellationToken.ThrowIfCancellationRequested();

			int mid = (low + high) / 2;
			string input = GenerateTokenizedInput(mid);

			ContextProbe probe = await ProbeAsync(input, "Summarize the above in one sentence.", mid, cancellationToken);
			probes.Add(probe);

			if (probe.Success) {
				lastSuccess = mid;
				lastSuccessLatencyMs = probe.LatencyMs;
				low = mid + _stepSize;
			}
			else {
				high = mid - _stepSize;
			}
		}

		return new ContextWindowResult {
			TestType = "InputLimit",
			ModelId = _backend.ModelId,
			MaxTokens = lastSuccess,
			LatencyAtMaxMs = lastSuccessLatencyMs,
			Probes = probes,
		};
	}

	/// <summary>
	/// Discovers the maximum output the model can generate.
	/// Requests increasingly longer outputs until truncation or failure.
	/// </summary>
	public async Task<ContextWindowResult> DiscoverOutputLimitAsync(
		CancellationToken cancellationToken = default) {
		int lastSuccess = 0;
		long lastSuccessLatencyMs = 0;
		List<ContextProbe> probes = new();

		int[] outputSizes = { 64, 128, 256, 512, 1024, 2048, 4096 };

		foreach (int size in outputSizes) {
			cancellationToken.ThrowIfCancellationRequested();

			string prompt = $"Generate exactly {size} words of placeholder text about software engineering. " +
				"Do not stop early. Fill the entire requested length.";

			InferenceParams p = new() {
				Temperature = 0.7,
				MaxTokens = size,
			};

			Stopwatch sw = Stopwatch.StartNew();
			InferenceResult result = await _backend.ChatAsync(
				"You are a helpful assistant.", prompt, p, cancellationToken);
			sw.Stop();

			int actualTokens = EstimateTokens(result.Response);

			ContextProbe probe = new() {
				RequestedTokens = size,
				ActualTokens = actualTokens,
				Success = result.Success && actualTokens >= size * 0.5,
				LatencyMs = sw.ElapsedMilliseconds,
				Error = result.Error,
			};
			probes.Add(probe);

			if (probe.Success) {
				lastSuccess = size;
				lastSuccessLatencyMs = sw.ElapsedMilliseconds;
			}
			else {
				break;
			}
		}

		return new ContextWindowResult {
			TestType = "OutputLimit",
			ModelId = _backend.ModelId,
			MaxTokens = lastSuccess,
			LatencyAtMaxMs = lastSuccessLatencyMs,
			Probes = probes,
		};
	}

	/// <summary>
	/// Discovers total context window (input + output combined).
	/// </summary>
	public async Task<ContextWindowResult> DiscoverTotalContextAsync(
		CancellationToken cancellationToken = default) {
		int lastSuccess = 0;
		long lastSuccessLatencyMs = 0;
		List<ContextProbe> probes = new();

		// Test with increasing input sizes while requesting fixed output
		int fixedOutputTokens = 256;

		for (int inputTokens = _stepSize; inputTokens <= _maxSearchTokens; inputTokens += _stepSize) {
			cancellationToken.ThrowIfCancellationRequested();

			string input = GenerateTokenizedInput(inputTokens);

			InferenceParams p = new() {
				Temperature = 0.0,
				MaxTokens = fixedOutputTokens,
			};

			Stopwatch sw = Stopwatch.StartNew();
			InferenceResult result = await _backend.ChatAsync(
				"You are a helpful assistant. Summarize the input.",
				input,
				p,
				cancellationToken);
			sw.Stop();

			ContextProbe probe = new() {
				RequestedTokens = inputTokens + fixedOutputTokens,
				ActualTokens = inputTokens + EstimateTokens(result.Response),
				Success = result.Success && !string.IsNullOrEmpty(result.Response),
				LatencyMs = sw.ElapsedMilliseconds,
				Error = result.Error,
			};
			probes.Add(probe);

			if (probe.Success) {
				lastSuccess = inputTokens + fixedOutputTokens;
				lastSuccessLatencyMs = sw.ElapsedMilliseconds;
			}
			else {
				break;
			}
		}

		return new ContextWindowResult {
			TestType = "TotalContext",
			ModelId = _backend.ModelId,
			MaxTokens = lastSuccess,
			LatencyAtMaxMs = lastSuccessLatencyMs,
			Probes = probes,
		};
	}

	/// <summary>
	/// Runs all three discovery tests and returns a combined report.
	/// </summary>
	public async Task<ContextWindowReport> RunFullDiscoveryAsync(
		CancellationToken cancellationToken = default) {
		Stopwatch sw = Stopwatch.StartNew();

		ContextWindowResult inputResult = await DiscoverInputLimitAsync(cancellationToken);
		ContextWindowResult outputResult = await DiscoverOutputLimitAsync(cancellationToken);
		ContextWindowResult totalResult = await DiscoverTotalContextAsync(cancellationToken);

		sw.Stop();

		return new ContextWindowReport {
			ModelId = _backend.ModelId,
			InputLimit = inputResult,
			OutputLimit = outputResult,
			TotalContext = totalResult,
			TotalDurationMs = sw.ElapsedMilliseconds,
		};
	}

	private async Task<ContextProbe> ProbeAsync(
		string input, string instruction, int requestedTokens,
		CancellationToken cancellationToken) {
		InferenceParams p = InferenceParams.Deterministic;

		Stopwatch sw = Stopwatch.StartNew();
		InferenceResult result = await _backend.ChatAsync(
			"You are a helpful assistant.", $"{input}\n\n{instruction}", p, cancellationToken);
		sw.Stop();

		return new ContextProbe {
			RequestedTokens = requestedTokens,
			ActualTokens = EstimateTokens(result.Response),
			Success = result.Success && !string.IsNullOrEmpty(result.Response),
			LatencyMs = sw.ElapsedMilliseconds,
			Error = result.Error,
		};
	}

	/// <summary>
	/// Generates input text of approximately the specified token count.
	/// Uses ~4 chars per token heuristic.
	/// </summary>
	private static string GenerateTokenizedInput(int targetTokens) {
		int targetChars = targetTokens * 4;
		StringBuilder sb = new(targetChars);
		string[] words = {
			"the", "quick", "brown", "fox", "jumps", "over", "lazy", "dog",
			"system", "config", "threshold", "jackpot", "platform", "casino",
			"signal", "credential", "validation", "automation", "process", "monitor",
		};

		int wordIndex = 0;
		while (sb.Length < targetChars) {
			sb.Append(words[wordIndex % words.Length]);
			sb.Append(' ');
			wordIndex++;
		}

		return sb.ToString().TrimEnd();
	}

	private static int EstimateTokens(string text) =>
		string.IsNullOrEmpty(text) ? 0 : (int)Math.Ceiling(text.Length / 4.0);
}

/// <summary>
/// Result of a single context window probe.
/// </summary>
public sealed class ContextProbe {
	public int RequestedTokens { get; init; }
	public int ActualTokens { get; init; }
	public bool Success { get; init; }
	public long LatencyMs { get; init; }
	public string? Error { get; init; }
}

/// <summary>
/// Result of a context window discovery test.
/// </summary>
public sealed class ContextWindowResult {
	public string TestType { get; init; } = string.Empty;
	public string ModelId { get; init; } = string.Empty;
	public int MaxTokens { get; init; }
	public long LatencyAtMaxMs { get; init; }
	public List<ContextProbe> Probes { get; init; } = new();

	public override string ToString() =>
		$"[{TestType}] {ModelId}: max={MaxTokens} tokens, latency={LatencyAtMaxMs}ms ({Probes.Count} probes)";
}

/// <summary>
/// Combined report from all context window discovery tests.
/// </summary>
public sealed class ContextWindowReport {
	public string ModelId { get; init; } = string.Empty;
	public ContextWindowResult InputLimit { get; init; } = new();
	public ContextWindowResult OutputLimit { get; init; } = new();
	public ContextWindowResult TotalContext { get; init; } = new();
	public long TotalDurationMs { get; init; }
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	public override string ToString() =>
		$"""
		=== Context Window Discovery: {ModelId} ===
		Input Limit:  {InputLimit.MaxTokens} tokens
		Output Limit: {OutputLimit.MaxTokens} tokens
		Total Context: {TotalContext.MaxTokens} tokens
		Duration: {TotalDurationMs}ms
		""";
}
