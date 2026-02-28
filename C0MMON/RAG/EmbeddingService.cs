using System.Diagnostics;
using System.Text;
using System.Text.Json;

namespace P4NTHE0N.C0MMON.RAG;

/// <summary>
/// Generates text embeddings using a local ONNX model (all-MiniLM-L6-v2) via Python bridge.
/// Zero API cost — runs entirely on local hardware (CPU or GPU).
/// </summary>
/// <remarks>
/// DECISION: Using Python subprocess for ONNX inference rather than OnnxRuntime C# bindings because:
/// 1. sentence-transformers Python library handles tokenization + pooling automatically
/// 2. Avoids complex ONNX Runtime C# setup with custom tokenizers
/// 3. The same Python process can serve both embedding and FAISS operations
///
/// The embedding model all-MiniLM-L6-v2 produces 384-dimensional vectors.
/// It's optimized for semantic similarity and runs fast on CPU (~5ms per sentence).
/// </remarks>
public sealed class EmbeddingService : IEmbeddingService, IDisposable
{
	/// <summary>
	/// Dimensionality of all-MiniLM-L6-v2 embeddings.
	/// </summary>
	private const int MiniLmDimensions = 384;

	/// <summary>
	/// Path to the Python embedding bridge script.
	/// </summary>
	private readonly string _bridgeScriptPath;

	/// <summary>
	/// The running Python embedding process.
	/// </summary>
	private Process? _bridgeProcess;

	/// <summary>
	/// Lock for serializing bridge communication.
	/// </summary>
	private readonly SemaphoreSlim _bridgeLock = new(1, 1);

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <inheritdoc />
	public int Dimensions => MiniLmDimensions;

	/// <inheritdoc />
	public bool IsReady => _bridgeProcess is not null && !_bridgeProcess.HasExited;

	/// <summary>
	/// Creates an EmbeddingService instance.
	/// </summary>
	/// <param name="bridgeScriptPath">Path to scripts/rag/embedding-bridge.py</param>
	public EmbeddingService(string bridgeScriptPath)
	{
		if (string.IsNullOrWhiteSpace(bridgeScriptPath))
			throw new ArgumentException("Bridge script path required.", nameof(bridgeScriptPath));

		_bridgeScriptPath = bridgeScriptPath;
	}

	/// <inheritdoc />
	public async Task InitializeAsync()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (IsReady)
			return;

		if (!File.Exists(_bridgeScriptPath))
		{
			throw new FileNotFoundException(
				$"Embedding bridge script not found at: {_bridgeScriptPath}. " + "Ensure scripts/rag/embedding-bridge.py exists.",
				_bridgeScriptPath
			);
		}

		ProcessStartInfo startInfo = new()
		{
			FileName = "python",
			Arguments = $"\"{_bridgeScriptPath}\"",
			UseShellExecute = false,
			RedirectStandardInput = true,
			RedirectStandardOutput = true,
			RedirectStandardError = true,
			CreateNoWindow = true,
			StandardOutputEncoding = Encoding.UTF8,
			StandardInputEncoding = Encoding.UTF8,
		};

		_bridgeProcess = Process.Start(startInfo);
		if (_bridgeProcess is null || _bridgeProcess.HasExited)
		{
			throw new InvalidOperationException("Failed to start Python embedding bridge. " + "Ensure Python 3.8+ with sentence-transformers is installed.");
		}

		// Send init command and wait for model load
		JsonDocument response = await SendCommandAsync(new { command = "init", model = "all-MiniLM-L6-v2" });

		string status = response.RootElement.GetProperty("status").GetString() ?? "unknown";
		if (status != "ok")
		{
			string error = response.RootElement.TryGetProperty("error", out JsonElement errEl) ? errEl.GetString() ?? "unknown" : "unknown";
			throw new InvalidOperationException($"Embedding bridge init failed: {error}");
		}

		int dims = response.RootElement.TryGetProperty("dimensions", out JsonElement dimEl) ? dimEl.GetInt32() : 0;

		Console.WriteLine($"[EmbeddingService] Model loaded. Dimensions: {dims}");
	}

	/// <inheritdoc />
	public async Task<float[]> EmbedAsync(string text)
	{
		if (string.IsNullOrEmpty(text))
			throw new ArgumentException("Text cannot be null or empty.", nameof(text));

		EnsureReady();

		await _bridgeLock.WaitAsync();
		try
		{
			JsonDocument response = await SendCommandAsync(new { command = "embed", text });

			ValidateResponse(response, "embed");

			JsonElement embeddingEl = response.RootElement.GetProperty("embedding");
			float[] embedding = new float[embeddingEl.GetArrayLength()];
			for (int i = 0; i < embedding.Length; i++)
			{
				embedding[i] = embeddingEl[i].GetSingle();
			}

			return embedding;
		}
		finally
		{
			_bridgeLock.Release();
		}
	}

	/// <inheritdoc />
	public async Task<float[][]> EmbedBatchAsync(IReadOnlyList<string> texts)
	{
		ArgumentNullException.ThrowIfNull(texts, nameof(texts));
		if (texts.Count == 0)
			return Array.Empty<float[]>();

		EnsureReady();

		await _bridgeLock.WaitAsync();
		try
		{
			JsonDocument response = await SendCommandAsync(new { command = "embed_batch", texts });

			ValidateResponse(response, "embed_batch");

			JsonElement embeddingsEl = response.RootElement.GetProperty("embeddings");
			float[][] embeddings = new float[embeddingsEl.GetArrayLength()][];

			for (int i = 0; i < embeddings.Length; i++)
			{
				JsonElement row = embeddingsEl[i];
				embeddings[i] = new float[row.GetArrayLength()];
				for (int j = 0; j < embeddings[i].Length; j++)
				{
					embeddings[i][j] = row[j].GetSingle();
				}
			}

			return embeddings;
		}
		finally
		{
			_bridgeLock.Release();
		}
	}

	/// <summary>
	/// Sends a JSON command to the Python bridge and reads the response.
	/// </summary>
	private async Task<JsonDocument> SendCommandAsync(object command)
	{
		if (_bridgeProcess is null || _bridgeProcess.HasExited)
			throw new InvalidOperationException("Embedding bridge process is not running.");

		string json = JsonSerializer.Serialize(command);
		await _bridgeProcess.StandardInput.WriteLineAsync(json);
		await _bridgeProcess.StandardInput.FlushAsync();

		string? responseLine = await _bridgeProcess.StandardOutput.ReadLineAsync();
		if (string.IsNullOrEmpty(responseLine))
			throw new InvalidOperationException("Embedding bridge returned empty response.");

		return JsonDocument.Parse(responseLine);
	}

	/// <summary>
	/// Validates that a bridge response has status "ok".
	/// </summary>
	private static void ValidateResponse(JsonDocument response, string operation)
	{
		string status = response.RootElement.GetProperty("status").GetString() ?? "unknown";
		if (status != "ok")
		{
			string error = response.RootElement.TryGetProperty("error", out JsonElement errEl) ? errEl.GetString() ?? "unknown error" : "unknown error";
			throw new InvalidOperationException($"Embedding bridge '{operation}' failed: {error}");
		}
	}

	/// <summary>
	/// Ensures the bridge process is running.
	/// </summary>
	private void EnsureReady()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (!IsReady)
		{
			throw new InvalidOperationException("Embedding service not ready. Call InitializeAsync() first.");
		}
	}

	/// <summary>
	/// Disposes the embedding service, shutting down the Python bridge.
	/// </summary>
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_bridgeLock.Dispose();

			if (_bridgeProcess is not null && !_bridgeProcess.HasExited)
			{
				try
				{
					_bridgeProcess.StandardInput.WriteLine("{\"command\":\"shutdown\"}");
					_bridgeProcess.StandardInput.Flush();
					_bridgeProcess.WaitForExit(5000);
				}
				catch
				{
					// Best-effort shutdown
				}
				finally
				{
					if (!_bridgeProcess.HasExited)
						_bridgeProcess.Kill();
					_bridgeProcess.Dispose();
				}
			}
		}
	}
}
