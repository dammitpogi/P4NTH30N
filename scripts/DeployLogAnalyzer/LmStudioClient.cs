using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace P4NTH30N.DeployLogAnalyzer;

/// <summary>
/// LM Studio integration client for deployment log analysis.
/// Connects to a local LM Studio instance for config validation and log classification.
/// </summary>
public sealed class LmStudioClient : IDisposable
{
	private readonly HttpClient _httpClient;
	private readonly string _baseUrl;
	private readonly int _maxRetries;
	private bool _disposed;

	/// <summary>
	/// Whether the client is connected and ready.
	/// </summary>
	public bool IsConnected { get; private set; }

	/// <summary>
	/// Model identifier in use.
	/// </summary>
	public string ModelId { get; }

	public LmStudioClient(string baseUrl = "http://localhost:1234", string modelId = "maincoder-1b", string? apiKey = null, int timeoutSeconds = 120, int maxRetries = 3)
	{
		_baseUrl = baseUrl.TrimEnd('/');
		ModelId = modelId;
		_maxRetries = maxRetries;

		_httpClient = new HttpClient { BaseAddress = new Uri(_baseUrl), Timeout = TimeSpan.FromSeconds(timeoutSeconds) };

		_httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

		if (!string.IsNullOrWhiteSpace(apiKey))
		{
			_httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
		}
	}

	/// <summary>
	/// Verifies connectivity to LM Studio server.
	/// </summary>
	public async Task<bool> ConnectAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			HttpResponseMessage response = await _httpClient.GetAsync("/v1/models", cancellationToken);
			IsConnected = response.IsSuccessStatusCode;
			return IsConnected;
		}
		catch
		{
			IsConnected = false;
			return false;
		}
	}

	/// <summary>
	/// Validates a configuration JSON against LLM analysis.
	/// Returns validation result with confidence score.
	/// </summary>
	public async Task<ValidationResult> ValidateConfigAsync(string configJson, CancellationToken cancellationToken = default)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		string systemPrompt = FewShotPrompt.GetConfigValidationPrompt();
		string userMessage = $"Validate this configuration:\n{configJson}";

		Stopwatch sw = Stopwatch.StartNew();
		string response = await ChatWithRetryAsync(systemPrompt, userMessage, cancellationToken);
		sw.Stop();

		return ParseValidationResponse(response, sw.ElapsedMilliseconds);
	}

	/// <summary>
	/// Gets confidence score for a classification result.
	/// </summary>
	public async Task<double> GetConfidenceAsync(string input, string classification, CancellationToken cancellationToken = default)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		string systemPrompt = "Rate your confidence (0.0-1.0) in this classification. Respond with JSON: {\"confidence\": <value>}";
		string userMessage = $"Input: {input}\nClassification: {classification}";

		string response = await ChatWithRetryAsync(systemPrompt, userMessage, cancellationToken);

		try
		{
			using JsonDocument doc = JsonDocument.Parse(ExtractJson(response));
			if (doc.RootElement.TryGetProperty("confidence", out JsonElement conf))
			{
				return conf.GetDouble();
			}
		}
		catch { }

		return 0.5;
	}

	/// <summary>
	/// Sends a chat request with exponential backoff retry logic.
	/// </summary>
	public async Task<string> ChatWithRetryAsync(string systemPrompt, string userMessage, CancellationToken cancellationToken = default)
	{
		Exception? lastException = null;

		for (int attempt = 0; attempt < _maxRetries; attempt++)
		{
			try
			{
				return await SendChatRequestAsync(systemPrompt, userMessage, cancellationToken);
			}
			catch (Exception ex) when (attempt < _maxRetries - 1)
			{
				lastException = ex;
				int delayMs = (int)(Math.Pow(2, attempt) * 1000);
				await Task.Delay(delayMs, cancellationToken);
			}
			catch (Exception ex)
			{
				lastException = ex;
			}
		}

		throw new InvalidOperationException($"LM Studio request failed after {_maxRetries} attempts: {lastException?.Message}", lastException);
	}

	private async Task<string> SendChatRequestAsync(string systemPrompt, string userMessage, CancellationToken cancellationToken)
	{
		object requestBody = new
		{
			model = ModelId,
			messages = new[] { new { role = "system", content = systemPrompt }, new { role = "user", content = userMessage } },
			max_tokens = 512,
			temperature = 0.1,
			stream = false,
		};

		string json = JsonSerializer.Serialize(requestBody);
		using StringContent content = new(json, Encoding.UTF8, "application/json");

		HttpResponseMessage response = await _httpClient.PostAsync("/v1/chat/completions", content, cancellationToken);

		string responseJson = await response.Content.ReadAsStringAsync(cancellationToken);

		if (!response.IsSuccessStatusCode)
		{
			throw new HttpRequestException($"LM Studio returned {response.StatusCode}: {responseJson}");
		}

		using JsonDocument doc = JsonDocument.Parse(responseJson);
		string? completionText = doc.RootElement.GetProperty("choices")[0].GetProperty("message").GetProperty("content").GetString();

		return completionText ?? string.Empty;
	}

	private static ValidationResult ParseValidationResponse(string response, long latencyMs)
	{
		try
		{
			string jsonStr = ExtractJson(response);
			using JsonDocument doc = JsonDocument.Parse(jsonStr);
			JsonElement root = doc.RootElement;

			bool valid = root.TryGetProperty("valid", out JsonElement v) && v.GetBoolean();
			double confidence = root.TryGetProperty("confidence", out JsonElement c) ? c.GetDouble() : 0.5;

			List<string> failures = new();
			if (root.TryGetProperty("failures", out JsonElement f) && f.ValueKind == JsonValueKind.Array)
			{
				foreach (JsonElement item in f.EnumerateArray())
				{
					string? s = item.GetString();
					if (s != null)
						failures.Add(s);
				}
			}

			return new ValidationResult
			{
				IsValid = valid,
				Confidence = confidence,
				Failures = failures,
				LatencyMs = latencyMs,
				RawResponse = response,
			};
		}
		catch
		{
			return new ValidationResult
			{
				IsValid = false,
				Confidence = 0.0,
				Failures = new List<string> { "parse_error:invalid_json_response" },
				LatencyMs = latencyMs,
				RawResponse = response,
			};
		}
	}

	public static string ExtractJson(string text)
	{
		int start = text.IndexOf('{');
		int end = text.LastIndexOf('}');
		if (start >= 0 && end > start)
		{
			return text[start..(end + 1)];
		}
		return text;
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
/// Result of a configuration validation via LLM.
/// </summary>
public sealed class ValidationResult
{
	public bool IsValid { get; init; }
	public double Confidence { get; init; }
	public List<string> Failures { get; init; } = new();
	public long LatencyMs { get; init; }
	public string RawResponse { get; init; } = string.Empty;
}
