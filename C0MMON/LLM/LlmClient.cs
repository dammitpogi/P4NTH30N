using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace P4NTHE0N.C0MMON.LLM;

/// <summary>
/// LLM client supporting OpenAI-compatible chat completion APIs.
/// Works with OpenAI, LM Studio, vLLM, or any endpoint implementing
/// the /v1/chat/completions contract.
/// </summary>
/// <remarks>
/// FEAT-001: Dual-mode operation:
/// - OpenAI API mode: baseUrl = "https://api.openai.com", requires API key
/// - Local LM Studio mode: baseUrl = "http://localhost:1234", no API key needed
///
/// TECH-002: CPU-only config for local models:
/// - Pleias-RAG-1B: 20-40 tok/sec on Ryzen 9 3900X
/// - Context: 4K-8K tokens feasible
/// </remarks>
public sealed class LlmClient : ILlmClient
{
	/// <summary>
	/// HTTP client for API requests.
	/// </summary>
	private readonly HttpClient _httpClient;

	/// <summary>
	/// Base URL for the API endpoint.
	/// </summary>
	private readonly string _baseUrl;

	/// <summary>
	/// Whether this instance owns the HttpClient (for disposal).
	/// </summary>
	private readonly bool _ownsHttpClient;

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <inheritdoc />
	public string ModelId { get; }

	/// <inheritdoc />
	public bool IsReady => !_disposed;

	/// <summary>
	/// Creates an LlmClient targeting an OpenAI-compatible API.
	/// </summary>
	/// <param name="baseUrl">API base URL. Default: http://localhost:1234 (LM Studio).</param>
	/// <param name="modelId">Model identifier. Default: "local-model".</param>
	/// <param name="apiKey">API key (required for OpenAI, optional for local).</param>
	/// <param name="timeoutSeconds">Request timeout. Default: 120 for CPU inference.</param>
	public LlmClient(string baseUrl = "http://localhost:1234", string modelId = "local-model", string? apiKey = null, int timeoutSeconds = 120)
	{
		_baseUrl = baseUrl.TrimEnd('/');
		ModelId = modelId;
		_ownsHttpClient = true;

		_httpClient = new HttpClient { BaseAddress = new Uri(_baseUrl), Timeout = TimeSpan.FromSeconds(timeoutSeconds) };

		_httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

		if (!string.IsNullOrWhiteSpace(apiKey))
		{
			_httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
		}
	}

	/// <inheritdoc />
	public async Task<string> CompleteAsync(string prompt, int maxTokens = 512, double temperature = 0.3, CancellationToken cancellationToken = default)
	{
		return await ChatAsync("You are a helpful assistant.", prompt, maxTokens, temperature, cancellationToken);
	}

	/// <inheritdoc />
	public async Task<string> ChatAsync(
		string systemPrompt,
		string userMessage,
		int maxTokens = 512,
		double temperature = 0.3,
		CancellationToken cancellationToken = default
	)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		object requestBody = new
		{
			model = ModelId,
			messages = new[] { new { role = "system", content = systemPrompt }, new { role = "user", content = userMessage } },
			max_tokens = maxTokens,
			temperature,
			stream = false,
		};

		string json = JsonSerializer.Serialize(requestBody);
		using StringContent content = new(json, Encoding.UTF8, "application/json");

		Stopwatch sw = Stopwatch.StartNew();

		try
		{
			HttpResponseMessage response = await _httpClient.PostAsync("/v1/chat/completions", content, cancellationToken);

			sw.Stop();
			string responseJson = await response.Content.ReadAsStringAsync(cancellationToken);

			if (!response.IsSuccessStatusCode)
			{
				Console.WriteLine($"[LlmClient] API error ({response.StatusCode}): {responseJson}");
				throw new HttpRequestException($"LLM API returned {response.StatusCode}: {responseJson}");
			}

			// Parse the chat completion response
			using JsonDocument doc = JsonDocument.Parse(responseJson);
			string? completionText = doc.RootElement.GetProperty("choices")[0].GetProperty("message").GetProperty("content").GetString();

			Console.WriteLine($"[LlmClient] Completion in {sw.ElapsedMilliseconds}ms ({ModelId})");
			return completionText ?? string.Empty;
		}
		catch (TaskCanceledException) when (cancellationToken.IsCancellationRequested)
		{
			throw;
		}
		catch (TaskCanceledException)
		{
			sw.Stop();
			Console.WriteLine($"[LlmClient] Request timed out after {sw.ElapsedMilliseconds}ms");
			throw new TimeoutException($"LLM request timed out after {sw.ElapsedMilliseconds}ms");
		}
		catch (Exception ex) when (ex is not HttpRequestException and not TimeoutException)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [LlmClient] Error: {ex.Message}");
			throw;
		}
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			if (_ownsHttpClient)
				_httpClient.Dispose();
		}
	}
}
