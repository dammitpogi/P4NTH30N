using System.Diagnostics;
using System.Text.Json;

namespace P4NTH30N.RAG;

/// <summary>
/// HTTP client for the Python embedding bridge service.
/// Communicates with embedding_bridge.py (FastAPI on port 5000).
/// Implements retry logic with exponential backoff.
/// Oracle condition #3: C# → Python → ONNX bridge.
/// </summary>
public sealed class PythonEmbeddingClient : IDisposable
{
	private readonly HttpClient _httpClient;
	private readonly string _baseUrl;
	private readonly int _maxRetries;
	private readonly TimeSpan _baseRetryDelay;
	private bool _disposed;

	private static readonly JsonSerializerOptions _jsonOptions = new() { PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower };

	public PythonEmbeddingClient(string baseUrl = "http://127.0.0.1:5000", int maxRetries = 3, int timeoutSeconds = 30)
	{
		_baseUrl = baseUrl.TrimEnd('/');
		_maxRetries = maxRetries;
		_baseRetryDelay = TimeSpan.FromSeconds(2);

		_httpClient = new HttpClient { Timeout = TimeSpan.FromSeconds(timeoutSeconds) };
	}

	/// <summary>
	/// Checks if the Python bridge is healthy and ready to serve requests.
	/// </summary>
	public async Task<bool> IsHealthyAsync(CancellationToken cancellationToken = default)
	{
		try
		{
			HttpResponseMessage response = await _httpClient.GetAsync($"{_baseUrl}/health", cancellationToken);
			return response.IsSuccessStatusCode;
		}
		catch
		{
			return false;
		}
	}

	/// <summary>
	/// Generates embeddings for a batch of texts via the Python bridge.
	/// Includes retry logic with exponential backoff.
	/// </summary>
	public async Task<PythonEmbeddingResult> GenerateEmbeddingsAsync(List<string> texts, int batchSize = 32, CancellationToken cancellationToken = default)
	{
		object request = new { texts, batch_size = batchSize };

		StringContent content = new(JsonSerializer.Serialize(request), System.Text.Encoding.UTF8, "application/json");

		for (int attempt = 0; attempt < _maxRetries; attempt++)
		{
			try
			{
				HttpResponseMessage response = await _httpClient.PostAsync($"{_baseUrl}/embed", content, cancellationToken);

				response.EnsureSuccessStatusCode();

				string json = await response.Content.ReadAsStringAsync(cancellationToken);
				PythonEmbeddingResult? result = JsonSerializer.Deserialize<PythonEmbeddingResult>(json, _jsonOptions);

				if (result != null)
				{
					return result;
				}
			}
			catch (Exception ex) when (attempt < _maxRetries - 1)
			{
				Console.WriteLine($"[PythonEmbeddingClient] Attempt {attempt + 1}/{_maxRetries} failed: {ex.Message}");
				TimeSpan delay = _baseRetryDelay * Math.Pow(2, attempt);
				await Task.Delay(delay, cancellationToken);

				// Recreate content for retry (stream may have been consumed)
				content = new(JsonSerializer.Serialize(request), System.Text.Encoding.UTF8, "application/json");
			}
		}

		throw new InvalidOperationException($"Failed to generate embeddings after {_maxRetries} retries");
	}

	/// <summary>
	/// Gets model information from the Python bridge.
	/// </summary>
	public async Task<PythonModelInfo> GetModelInfoAsync(CancellationToken cancellationToken = default)
	{
		HttpResponseMessage response = await _httpClient.GetAsync($"{_baseUrl}/model-info", cancellationToken);

		response.EnsureSuccessStatusCode();

		string json = await response.Content.ReadAsStringAsync(cancellationToken);
		return JsonSerializer.Deserialize<PythonModelInfo>(json, _jsonOptions) ?? throw new InvalidOperationException("Failed to deserialize model info");
	}

	/// <summary>
	/// Starts the Python bridge process if not already running.
	/// Returns true if the bridge becomes healthy within the timeout.
	/// </summary>
	public static async Task<Process?> StartBridgeAsync(
		string pythonPath = "python",
		string bridgeScript = @"C:\P4NTH30N\src\RAG\PythonBridge\embedding_bridge.py",
		int healthCheckTimeoutSeconds = 30,
		CancellationToken cancellationToken = default
	)
	{
		ProcessStartInfo startInfo = new()
		{
			FileName = pythonPath,
			Arguments = bridgeScript,
			UseShellExecute = false,
			CreateNoWindow = true,
			RedirectStandardOutput = true,
			RedirectStandardError = true,
		};

		Process? process = Process.Start(startInfo);

		if (process == null)
		{
			Console.WriteLine("[PythonEmbeddingClient] Failed to start Python bridge process");
			return null;
		}

		Console.WriteLine($"[PythonEmbeddingClient] Started bridge process (PID: {process.Id})");

		// Wait for bridge to become healthy
		using PythonEmbeddingClient healthCheck = new();
		DateTime deadline = DateTime.UtcNow.AddSeconds(healthCheckTimeoutSeconds);

		while (DateTime.UtcNow < deadline)
		{
			cancellationToken.ThrowIfCancellationRequested();

			if (await healthCheck.IsHealthyAsync(cancellationToken))
			{
				Console.WriteLine("[PythonEmbeddingClient] Bridge is healthy");
				return process;
			}

			await Task.Delay(1000, cancellationToken);
		}

		Console.WriteLine("[PythonEmbeddingClient] Bridge did not become healthy within timeout");
		process.Kill();
		return null;
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_httpClient?.Dispose();
		}
	}
}

/// <summary>
/// Result from the Python embedding bridge /embed endpoint.
/// </summary>
public sealed class PythonEmbeddingResult
{
	public List<List<float>> Embeddings { get; set; } = new();
	public int Dimensions { get; set; }
	public string ModelName { get; set; } = string.Empty;
	public float ProcessingTimeMs { get; set; }
}

/// <summary>
/// Model information from the Python embedding bridge /model-info endpoint.
/// </summary>
public sealed class PythonModelInfo
{
	public string ModelName { get; set; } = string.Empty;
	public string OnnxVersion { get; set; } = string.Empty;
	public List<string> InputNames { get; set; } = new();
	public List<string> InputShapes { get; set; } = new();
	public List<string> OutputNames { get; set; } = new();
	public List<string> OutputShapes { get; set; } = new();
	public List<string> Providers { get; set; } = new();
}
