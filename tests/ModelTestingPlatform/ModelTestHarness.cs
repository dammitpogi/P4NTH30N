using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTHE0N.ModelTestingPlatform;

/// <summary>
/// Configurable inference parameters for LLM backend calls.
/// </summary>
public sealed class InferenceParams
{
	public double Temperature { get; init; } = 0.1;
	public double TopP { get; init; } = 0.9;
	public int TopK { get; init; } = 40;
	public bool DoSample { get; init; } = true;
	public int MaxTokens { get; init; } = 512;

	/// <summary>
	/// Deterministic config for reproducibility testing (temp=0.0, no sampling).
	/// </summary>
	public static InferenceParams Deterministic =>
		new()
		{
			Temperature = 0.0,
			TopP = 1.0,
			TopK = 1,
			DoSample = false,
			MaxTokens = 512,
		};

	/// <summary>
	/// Default creative params (temp=0.7, standard sampling).
	/// </summary>
	public static InferenceParams Creative =>
		new()
		{
			Temperature = 0.7,
			TopP = 0.9,
			TopK = 40,
			DoSample = true,
			MaxTokens = 512,
		};

	public override string ToString() => $"temp={Temperature:F2} top_p={TopP:F2} top_k={TopK} sample={DoSample} max={MaxTokens}";
}

/// <summary>
/// Result of a single LLM inference call with timing and metadata.
/// </summary>
public sealed class InferenceResult
{
	public string Response { get; init; } = string.Empty;
	public long LatencyMs { get; init; }
	public string ModelId { get; init; } = string.Empty;
	public InferenceParams Params { get; init; } = new();
	public bool Success { get; init; }
	public string? Error { get; init; }
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	/// <summary>
	/// Attempts to parse the response as JSON. Returns null if invalid.
	/// </summary>
	public JsonDocument? TryParseJson()
	{
		try
		{
			string json = ExtractJsonBlock(Response);
			return JsonDocument.Parse(json);
		}
		catch
		{
			return null;
		}
	}

	/// <summary>
	/// Whether the response contains valid JSON.
	/// </summary>
	public bool IsValidJson => TryParseJson() != null;

	private static string ExtractJsonBlock(string text)
	{
		int start = text.IndexOf('{');
		int end = text.LastIndexOf('}');
		if (start >= 0 && end > start)
		{
			return text[start..(end + 1)];
		}
		return text;
	}
}

/// <summary>
/// Backend interface for LLM inference. Implementations can target LM Studio,
/// Ollama, OpenAI-compatible APIs, or mock backends for testing.
/// </summary>
public interface ILlmBackend : IDisposable
{
	/// <summary>
	/// Unique identifier for this backend (e.g., "lmstudio", "ollama", "mock").
	/// </summary>
	string BackendId { get; }

	/// <summary>
	/// The model currently loaded/targeted.
	/// </summary>
	string ModelId { get; }

	/// <summary>
	/// Verifies connectivity to the backend.
	/// </summary>
	Task<bool> IsAvailableAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Lists available models on the backend.
	/// </summary>
	Task<IReadOnlyList<string>> ListModelsAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Sends a chat completion request with configurable inference parameters.
	/// </summary>
	Task<InferenceResult> ChatAsync(string systemPrompt, string userMessage, InferenceParams? inferenceParams = null, CancellationToken cancellationToken = default);
}

/// <summary>
/// LM Studio backend implementation targeting localhost:1234 OpenAI-compatible API.
/// Supports configurable temperature, top_p, top_k, do_sample, and max_tokens.
/// </summary>
public sealed class LmStudioBackend : ILlmBackend
{
	private readonly HttpClient _httpClient;
	private readonly string _baseUrl;
	private bool _disposed;

	public string BackendId => "lmstudio";
	public string ModelId { get; }

	public LmStudioBackend(string baseUrl = "http://localhost:1234", string modelId = "smollm2-1.7b-instruct", string? apiKey = null, int timeoutSeconds = 120)
	{
		_baseUrl = baseUrl.TrimEnd('/');
		ModelId = modelId;

		_httpClient = new HttpClient { BaseAddress = new Uri(_baseUrl), Timeout = TimeSpan.FromSeconds(timeoutSeconds) };

		_httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

		if (!string.IsNullOrWhiteSpace(apiKey))
		{
			_httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
		}
	}

	public async Task<bool> IsAvailableAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			HttpResponseMessage response = await _httpClient.GetAsync("/v1/models", cancellationToken);
			return response.IsSuccessStatusCode;
		}
		catch
		{
			return false;
		}
	}

	public async Task<IReadOnlyList<string>> ListModelsAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			HttpResponseMessage response = await _httpClient.GetAsync("/v1/models", cancellationToken);
			string json = await response.Content.ReadAsStringAsync(cancellationToken);

			using JsonDocument doc = JsonDocument.Parse(json);
			List<string> models = new();

			if (doc.RootElement.TryGetProperty("data", out JsonElement data) && data.ValueKind == JsonValueKind.Array)
			{
				foreach (JsonElement model in data.EnumerateArray())
				{
					if (model.TryGetProperty("id", out JsonElement id))
					{
						string? modelId = id.GetString();
						if (modelId != null)
							models.Add(modelId);
					}
				}
			}

			return models.AsReadOnly();
		}
		catch
		{
			return Array.Empty<string>();
		}
	}

	public async Task<InferenceResult> ChatAsync(
		string systemPrompt,
		string userMessage,
		InferenceParams? inferenceParams = null,
		CancellationToken cancellationToken = default
	)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		InferenceParams p = inferenceParams ?? new InferenceParams();
		Stopwatch sw = Stopwatch.StartNew();

		try
		{
			object requestBody = new
			{
				model = ModelId,
				messages = new[] { new { role = "system", content = systemPrompt }, new { role = "user", content = userMessage } },
				max_tokens = p.MaxTokens,
				temperature = p.Temperature,
				top_p = p.TopP,
				top_k = p.TopK,
				stream = false,
			};

			string json = JsonSerializer.Serialize(requestBody);
			using StringContent content = new(json, Encoding.UTF8, "application/json");

			HttpResponseMessage response = await _httpClient.PostAsync("/v1/chat/completions", content, cancellationToken);

			string responseJson = await response.Content.ReadAsStringAsync(cancellationToken);
			sw.Stop();

			if (!response.IsSuccessStatusCode)
			{
				return new InferenceResult
				{
					Response = responseJson,
					LatencyMs = sw.ElapsedMilliseconds,
					ModelId = ModelId,
					Params = p,
					Success = false,
					Error = $"HTTP {(int)response.StatusCode}: {response.ReasonPhrase}",
				};
			}

			using JsonDocument doc = JsonDocument.Parse(responseJson);
			string? completionText = doc.RootElement.GetProperty("choices")[0].GetProperty("message").GetProperty("content").GetString();

			return new InferenceResult
			{
				Response = completionText ?? string.Empty,
				LatencyMs = sw.ElapsedMilliseconds,
				ModelId = ModelId,
				Params = p,
				Success = true,
			};
		}
		catch (Exception ex)
		{
			sw.Stop();
			return new InferenceResult
			{
				Response = string.Empty,
				LatencyMs = sw.ElapsedMilliseconds,
				ModelId = ModelId,
				Params = p,
				Success = false,
				Error = ex.Message,
			};
		}
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_httpClient.Dispose();
		}
	}
}

/// <summary>
/// Mock backend for unit testing without LM Studio dependency.
/// Returns configurable responses for deterministic test scenarios.
/// </summary>
public sealed class MockLlmBackend : ILlmBackend
{
	private readonly Queue<string> _responses = new();
	private readonly int _latencyMs;
	private readonly bool _available;

	public string BackendId => "mock";
	public string ModelId { get; }
	public int CallCount { get; private set; }

	public MockLlmBackend(string modelId = "mock-model", int latencyMs = 10, bool available = true)
	{
		ModelId = modelId;
		_latencyMs = latencyMs;
		_available = available;
	}

	/// <summary>
	/// Enqueues a response to be returned on the next ChatAsync call.
	/// </summary>
	public void EnqueueResponse(string response)
	{
		_responses.Enqueue(response);
	}

	/// <summary>
	/// Enqueues multiple responses.
	/// </summary>
	public void EnqueueResponses(params string[] responses)
	{
		foreach (string r in responses)
		{
			_responses.Enqueue(r);
		}
	}

	public Task<bool> IsAvailableAsync(CancellationToken cancellationToken = default)
	{
		return Task.FromResult(_available);
	}

	public Task<IReadOnlyList<string>> ListModelsAsync(CancellationToken cancellationToken = default)
	{
		IReadOnlyList<string> models = new List<string> { ModelId }.AsReadOnly();
		return Task.FromResult(models);
	}

	public async Task<InferenceResult> ChatAsync(
		string systemPrompt,
		string userMessage,
		InferenceParams? inferenceParams = null,
		CancellationToken cancellationToken = default
	)
	{
		CallCount++;

		if (_latencyMs > 0)
		{
			await Task.Delay(_latencyMs, cancellationToken);
		}

		string response = _responses.Count > 0 ? _responses.Dequeue() : "{\"valid\": true, \"confidence\": 0.5, \"failures\": []}";

		return new InferenceResult
		{
			Response = response,
			LatencyMs = _latencyMs,
			ModelId = ModelId,
			Params = inferenceParams ?? new InferenceParams(),
			Success = true,
		};
	}

	public void Dispose() { }
}

/// <summary>
/// Test case definition for model validation testing.
/// Links a config JSON input to expected validation output.
/// </summary>
public sealed class TestCase
{
	public string Name { get; init; } = string.Empty;
	public string ConfigJson { get; init; } = string.Empty;
	public bool ExpectedValid { get; init; }
	public List<string> ExpectedFailures { get; init; } = new();
	public string SystemPrompt { get; init; } = string.Empty;
	public string UserPromptTemplate { get; init; } = "Validate this configuration:\n{0}";

	/// <summary>
	/// Builds the user message from the template and config.
	/// </summary>
	public string BuildUserMessage() => string.Format(UserPromptTemplate, ConfigJson);
}

/// <summary>
/// Result of evaluating a single test case against a model response.
/// </summary>
public sealed class TestCaseResult
{
	public string TestName { get; init; } = string.Empty;
	public string ModelId { get; init; } = string.Empty;
	public InferenceParams Params { get; init; } = new();
	public bool ExpectedValid { get; init; }
	public bool PredictedValid { get; init; }
	public bool Correct { get; init; }
	public double Confidence { get; init; }
	public long LatencyMs { get; init; }
	public bool JsonValid { get; init; }
	public List<string> PredictedFailures { get; init; } = new();
	public string RawResponse { get; init; } = string.Empty;
	public string? Error { get; init; }
}

/// <summary>
/// Harness for running test cases against LLM backends with configurable parameters.
/// Supports single runs, batch evaluation, and result aggregation.
/// </summary>
public sealed class ModelTestHarness
{
	private readonly ILlmBackend _backend;
	private readonly string _defaultSystemPrompt;

	public ModelTestHarness(ILlmBackend backend, string? systemPrompt = null)
	{
		_backend = backend;
		_defaultSystemPrompt = systemPrompt ?? P4NTHE0N.DeployLogAnalyzer.FewShotPrompt.GetConfigValidationPrompt();
	}

	/// <summary>
	/// Runs a single test case with specified inference params.
	/// </summary>
	public async Task<TestCaseResult> RunTestAsync(TestCase testCase, InferenceParams? inferenceParams = null, CancellationToken cancellationToken = default)
	{
		InferenceParams p = inferenceParams ?? new InferenceParams();
		string systemPrompt = string.IsNullOrEmpty(testCase.SystemPrompt) ? _defaultSystemPrompt : testCase.SystemPrompt;

		InferenceResult inference = await _backend.ChatAsync(systemPrompt, testCase.BuildUserMessage(), p, cancellationToken);

		if (!inference.Success)
		{
			return new TestCaseResult
			{
				TestName = testCase.Name,
				ModelId = _backend.ModelId,
				Params = p,
				ExpectedValid = testCase.ExpectedValid,
				PredictedValid = false,
				Correct = false,
				Confidence = 0.0,
				LatencyMs = inference.LatencyMs,
				JsonValid = false,
				RawResponse = inference.Response,
				Error = inference.Error,
			};
		}

		return ParseTestResult(testCase, inference, p);
	}

	/// <summary>
	/// Runs all test cases and returns aggregated results.
	/// </summary>
	public async Task<BatchTestResult> RunBatchAsync(
		IReadOnlyList<TestCase> testCases,
		InferenceParams? inferenceParams = null,
		CancellationToken cancellationToken = default
	)
	{
		List<TestCaseResult> results = new();
		Stopwatch sw = Stopwatch.StartNew();

		foreach (TestCase tc in testCases)
		{
			cancellationToken.ThrowIfCancellationRequested();
			TestCaseResult result = await RunTestAsync(tc, inferenceParams, cancellationToken);
			results.Add(result);
		}

		sw.Stop();
		return BatchTestResult.FromResults(results, _backend.ModelId, inferenceParams ?? new InferenceParams(), sw.ElapsedMilliseconds);
	}

	/// <summary>
	/// Loads test cases from the pre-validation test-configs directory.
	/// Compatible with the existing test config format.
	/// </summary>
	public static async Task<List<TestCase>> LoadTestCasesAsync(string directory, CancellationToken cancellationToken = default)
	{
		List<TestCase> cases = new();

		if (!Directory.Exists(directory))
			return cases;

		foreach (string file in Directory.GetFiles(directory, "*.json").OrderBy(f => f))
		{
			string json = await File.ReadAllTextAsync(file, cancellationToken);
			try
			{
				using JsonDocument doc = JsonDocument.Parse(json);
				JsonElement root = doc.RootElement;

				string name = root.TryGetProperty("name", out JsonElement n)
					? n.GetString() ?? Path.GetFileNameWithoutExtension(file)
					: Path.GetFileNameWithoutExtension(file);

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

				cases.Add(
					new TestCase
					{
						Name = name,
						ConfigJson = configJson,
						ExpectedValid = expectedValid,
						ExpectedFailures = expectedFailures,
					}
				);
			}
			catch
			{
				// Skip malformed test files
			}
		}

		return cases;
	}

	private TestCaseResult ParseTestResult(TestCase testCase, InferenceResult inference, InferenceParams p)
	{
		bool predictedValid = false;
		double confidence = 0.0;
		bool jsonValid = false;
		List<string> predictedFailures = new();

		using JsonDocument? doc = inference.TryParseJson();
		if (doc != null)
		{
			jsonValid = true;
			JsonElement root = doc.RootElement;

			if (root.TryGetProperty("valid", out JsonElement v))
			{
				predictedValid = v.GetBoolean();
			}
			if (root.TryGetProperty("confidence", out JsonElement c))
			{
				confidence = c.GetDouble();
			}
			if (root.TryGetProperty("failures", out JsonElement f) && f.ValueKind == JsonValueKind.Array)
			{
				foreach (JsonElement item in f.EnumerateArray())
				{
					string? s = item.GetString();
					if (s != null)
						predictedFailures.Add(s);
				}
			}
		}

		bool correct = predictedValid == testCase.ExpectedValid;

		return new TestCaseResult
		{
			TestName = testCase.Name,
			ModelId = _backend.ModelId,
			Params = p,
			ExpectedValid = testCase.ExpectedValid,
			PredictedValid = predictedValid,
			Correct = correct,
			Confidence = confidence,
			LatencyMs = inference.LatencyMs,
			JsonValid = jsonValid,
			PredictedFailures = predictedFailures,
			RawResponse = inference.Response,
		};
	}
}

/// <summary>
/// Aggregated results from running a batch of test cases.
/// </summary>
public sealed class BatchTestResult
{
	public string ModelId { get; init; } = string.Empty;
	public InferenceParams Params { get; init; } = new();
	public int TotalTests { get; init; }
	public int CorrectCount { get; init; }
	public double Accuracy { get; init; }
	public int JsonValidCount { get; init; }
	public double JsonValidRate { get; init; }
	public double MeanLatencyMs { get; init; }
	public double MaxLatencyMs { get; init; }
	public double MinLatencyMs { get; init; }
	public long TotalDurationMs { get; init; }
	public List<TestCaseResult> Results { get; init; } = new();
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	public static BatchTestResult FromResults(List<TestCaseResult> results, string modelId, InferenceParams inferenceParams, long totalDurationMs)
	{
		int total = results.Count;
		int correct = results.Count(r => r.Correct);
		int jsonValid = results.Count(r => r.JsonValid);

		return new BatchTestResult
		{
			ModelId = modelId,
			Params = inferenceParams,
			TotalTests = total,
			CorrectCount = correct,
			Accuracy = total > 0 ? (double)correct / total : 0.0,
			JsonValidCount = jsonValid,
			JsonValidRate = total > 0 ? (double)jsonValid / total : 0.0,
			MeanLatencyMs = results.Count > 0 ? results.Average(r => r.LatencyMs) : 0.0,
			MaxLatencyMs = results.Count > 0 ? results.Max(r => r.LatencyMs) : 0.0,
			MinLatencyMs = results.Count > 0 ? results.Min(r => r.LatencyMs) : 0.0,
			TotalDurationMs = totalDurationMs,
			Results = results,
		};
	}

	/// <summary>
	/// Checks if accuracy meets the Oracle-mandated decision gate threshold.
	/// </summary>
	public bool MeetsDecisionGate(double threshold = 0.70) => Accuracy >= threshold;

	/// <summary>
	/// Human-readable summary for console output.
	/// </summary>
	public override string ToString()
	{
		string gate = MeetsDecisionGate() ? "PASS" : "FAIL";
		return $"[{ModelId}] {Params} | Accuracy: {Accuracy:P1} ({CorrectCount}/{TotalTests}) | "
			+ $"JSON Valid: {JsonValidRate:P1} | Mean Latency: {MeanLatencyMs:F0}ms | Gate: {gate}";
	}
}

/// <summary>
/// Serializable report combining multiple batch results for comparison.
/// </summary>
public sealed class ModelComparisonReport
{
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;
	public string DecisionGateThreshold { get; init; } = "70%";
	public List<BatchTestResult> BatchResults { get; init; } = new();

	/// <summary>
	/// Returns the best-performing batch result by accuracy.
	/// </summary>
	public BatchTestResult? GetBestResult() => BatchResults.OrderByDescending(b => b.Accuracy).ThenBy(b => b.MeanLatencyMs).FirstOrDefault();

	/// <summary>
	/// Serializes the report to JSON.
	/// </summary>
	public string ToJson()
	{
		JsonSerializerOptions options = new() { WriteIndented = true, Converters = { new JsonStringEnumConverter() } };
		return JsonSerializer.Serialize(this, options);
	}

	/// <summary>
	/// Saves report to disk.
	/// </summary>
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
