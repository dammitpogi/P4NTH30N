using System.Diagnostics;
using System.Text;
using System.Text.Json;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON.RAG;

/// <summary>
/// FAISS-backed vector store that communicates with a Python bridge process
/// for vector indexing and similarity search operations.
/// </summary>
/// <remarks>
/// Architecture:
/// - C# manages metadata in MongoDB (RagDocument collection)
/// - Python process manages FAISS index (add, search, delete, save/load)
/// - Communication via stdin/stdout JSON protocol
///
/// The Python bridge is started as a subprocess and kept alive for the session.
/// Commands are sent as single-line JSON objects; responses are single-line JSON.
///
/// DECISION: Using process-based bridge over gRPC or REST because:
/// 1. Zero additional dependencies (no gRPC/REST packages needed)
/// 2. FAISS Python bindings are more mature than C# alternatives
/// 3. Process isolation prevents Python crashes from affecting C# agents
/// </remarks>
public sealed class FaissVectorStore : IVectorStore, IDisposable
{
	/// <summary>
	/// Path to the Python FAISS bridge script.
	/// </summary>
	private readonly string _bridgeScriptPath;

	/// <summary>
	/// Path where FAISS index files are persisted to disk.
	/// </summary>
	private readonly string _indexDirectory;

	/// <summary>
	/// Dimensionality of the vectors (must match embedding model output).
	/// </summary>
	private readonly int _dimensions;

	/// <summary>
	/// MongoDB collection for storing document metadata.
	/// </summary>
	private readonly IMongoCollection<RagDocument> _metadataCollection;

	/// <summary>
	/// The running Python bridge process.
	/// </summary>
	private Process? _bridgeProcess;

	/// <summary>
	/// Lock for serializing bridge communication.
	/// </summary>
	private readonly SemaphoreSlim _bridgeLock = new(1, 1);

	/// <summary>
	/// Auto-incrementing FAISS index counter.
	/// </summary>
	private long _nextFaissIndex;

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <summary>
	/// Creates a FaissVectorStore instance.
	/// </summary>
	/// <param name="bridgeScriptPath">Path to scripts/rag/faiss-bridge.py</param>
	/// <param name="indexDirectory">Directory for FAISS index persistence.</param>
	/// <param name="dimensions">Vector dimensionality (384 for MiniLM).</param>
	/// <param name="metadataCollection">MongoDB collection for RagDocument metadata.</param>
	public FaissVectorStore(
		string bridgeScriptPath,
		string indexDirectory,
		int dimensions,
		IMongoCollection<RagDocument> metadataCollection)
	{
		if (string.IsNullOrWhiteSpace(bridgeScriptPath))
			throw new ArgumentException("Bridge script path required.", nameof(bridgeScriptPath));
		if (string.IsNullOrWhiteSpace(indexDirectory))
			throw new ArgumentException("Index directory required.", nameof(indexDirectory));
		if (dimensions <= 0)
			throw new ArgumentOutOfRangeException(nameof(dimensions), "Dimensions must be positive.");

		_bridgeScriptPath = bridgeScriptPath;
		_indexDirectory = indexDirectory;
		_dimensions = dimensions;
		_metadataCollection = metadataCollection ?? throw new ArgumentNullException(nameof(metadataCollection));
	}

	/// <summary>
	/// Starts the Python FAISS bridge subprocess.
	/// Must be called before any vector operations.
	/// </summary>
	/// <exception cref="InvalidOperationException">When Python is not available or bridge fails to start.</exception>
	public async Task StartBridgeAsync()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (_bridgeProcess is not null && !_bridgeProcess.HasExited)
			return;

		if (!File.Exists(_bridgeScriptPath))
		{
			throw new FileNotFoundException(
				$"FAISS bridge script not found at: {_bridgeScriptPath}. " +
				"Ensure scripts/rag/faiss-bridge.py exists.",
				_bridgeScriptPath
			);
		}

		// Ensure index directory exists
		if (!Directory.Exists(_indexDirectory))
			Directory.CreateDirectory(_indexDirectory);

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
			throw new InvalidOperationException(
				"Failed to start Python FAISS bridge. Ensure Python 3.8+ is installed and accessible."
			);
		}

		// Initialize the FAISS index via the bridge
		JsonDocument response = await SendCommandAsync(new
		{
			command = "init",
			dimensions = _dimensions,
			index_path = Path.Combine(_indexDirectory, "vectors.faiss"),
		});

		string status = response.RootElement.GetProperty("status").GetString() ?? "unknown";
		if (status != "ok")
		{
			string error = response.RootElement.TryGetProperty("error", out JsonElement errEl) ? errEl.GetString() ?? "unknown" : "unknown";
			throw new InvalidOperationException($"FAISS bridge init failed: {error}");
		}

		// Get current index size to resume counter
		_nextFaissIndex = response.RootElement.TryGetProperty("count", out JsonElement countEl)
			? countEl.GetInt64()
			: 0;

		Console.WriteLine($"[FaissVectorStore] Bridge started. Index has {_nextFaissIndex} vectors.");
	}

	/// <inheritdoc />
	public async Task<string> AddAsync(RagDocument document)
	{
		ArgumentNullException.ThrowIfNull(document, nameof(document));
		if (document.Embedding is null || document.Embedding.Length != _dimensions)
		{
			throw new ArgumentException(
				$"Document embedding must be {_dimensions} dimensions, got {document.Embedding?.Length ?? 0}.",
				nameof(document)
			);
		}

		EnsureBridgeRunning();

		await _bridgeLock.WaitAsync();
		try
		{
			// Add vector to FAISS
			long faissIdx = _nextFaissIndex++;
			document.FaissIndex = faissIdx;
			document.EmbeddedAt = DateTime.UtcNow;

			JsonDocument response = await SendCommandAsync(new
			{
				command = "add",
				vectors = new[] { document.Embedding },
				ids = new[] { faissIdx },
			});

			ValidateResponse(response, "add");

			// Store metadata in MongoDB (without the embedding to save space)
			await _metadataCollection.InsertOneAsync(document);

			return document.Id;
		}
		finally
		{
			_bridgeLock.Release();
		}
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<string>> AddBatchAsync(IReadOnlyList<RagDocument> documents)
	{
		ArgumentNullException.ThrowIfNull(documents, nameof(documents));
		if (documents.Count == 0)
			return Array.Empty<string>();

		EnsureBridgeRunning();

		await _bridgeLock.WaitAsync();
		try
		{
			float[][] vectors = new float[documents.Count][];
			long[] ids = new long[documents.Count];

			for (int i = 0; i < documents.Count; i++)
			{
				RagDocument doc = documents[i];
				if (doc.Embedding is null || doc.Embedding.Length != _dimensions)
				{
					throw new ArgumentException(
						$"Document at index {i} has invalid embedding dimensions.",
						nameof(documents)
					);
				}

				long faissIdx = _nextFaissIndex++;
				doc.FaissIndex = faissIdx;
				doc.EmbeddedAt = DateTime.UtcNow;
				vectors[i] = doc.Embedding;
				ids[i] = faissIdx;
			}

			// Batch add to FAISS
			JsonDocument response = await SendCommandAsync(new
			{
				command = "add",
				vectors,
				ids,
			});

			ValidateResponse(response, "add batch");

			// Batch insert metadata into MongoDB
			await _metadataCollection.InsertManyAsync(documents);

			return documents.Select(d => d.Id).ToList();
		}
		finally
		{
			_bridgeLock.Release();
		}
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<SearchResult>> SearchAsync(float[] queryEmbedding, int topK = 5, string? collection = null)
	{
		ArgumentNullException.ThrowIfNull(queryEmbedding, nameof(queryEmbedding));
		if (queryEmbedding.Length != _dimensions)
		{
			throw new ArgumentException(
				$"Query embedding must be {_dimensions} dimensions, got {queryEmbedding.Length}.",
				nameof(queryEmbedding)
			);
		}

		EnsureBridgeRunning();

		await _bridgeLock.WaitAsync();
		try
		{
			// Search FAISS for nearest neighbors
			JsonDocument response = await SendCommandAsync(new
			{
				command = "search",
				vector = queryEmbedding,
				top_k = topK * 2, // Over-fetch to allow post-filtering by collection
			});

			ValidateResponse(response, "search");

			// Parse FAISS results: arrays of IDs and distances
			JsonElement idsElement = response.RootElement.GetProperty("ids");
			JsonElement distancesElement = response.RootElement.GetProperty("distances");

			List<(long faissIdx, float distance)> faissResults = new();
			for (int i = 0; i < idsElement.GetArrayLength(); i++)
			{
				long id = idsElement[i].GetInt64();
				float dist = distancesElement[i].GetSingle();
				if (id >= 0) // FAISS returns -1 for unfilled slots
					faissResults.Add((id, dist));
			}

			if (faissResults.Count == 0)
				return Array.Empty<SearchResult>();

			// Fetch metadata from MongoDB by FAISS index
			long[] faissIds = faissResults.Select(r => r.faissIdx).ToArray();
			FilterDefinition<RagDocument> filter = Builders<RagDocument>.Filter.In(d => d.FaissIndex, faissIds);

			if (!string.IsNullOrWhiteSpace(collection))
				filter &= Builders<RagDocument>.Filter.Eq(d => d.Collection, collection);

			List<RagDocument> documents = await _metadataCollection.Find(filter).ToListAsync();

			// Map FAISS index → document for fast lookup
			Dictionary<long, RagDocument> docMap = documents.ToDictionary(d => d.FaissIndex);

			// Build ranked results
			List<SearchResult> results = new();
			int rank = 0;
			foreach ((long faissIdx, float distance) in faissResults.OrderBy(r => r.distance))
			{
				if (docMap.TryGetValue(faissIdx, out RagDocument? doc))
				{
					// Convert L2 distance to similarity score: 1/(1+distance)
					float similarity = 1.0f / (1.0f + distance);
					results.Add(new SearchResult(doc, similarity, ++rank, SearchMethod.Vector));

					if (results.Count >= topK)
						break;
				}
			}

			return results;
		}
		finally
		{
			_bridgeLock.Release();
		}
	}

	/// <inheritdoc />
	public async Task<bool> DeleteAsync(string documentId)
	{
		// FAISS doesn't natively support deletion. Mark as deleted in MongoDB
		// and skip during search. Full cleanup happens during index rebuild.
		DeleteResult result = await _metadataCollection.DeleteOneAsync(
			Builders<RagDocument>.Filter.Eq(d => d.Id, documentId)
		);
		return result.DeletedCount > 0;
	}

	/// <inheritdoc />
	public async Task<long> CountAsync(string? collection = null)
	{
		FilterDefinition<RagDocument> filter = string.IsNullOrWhiteSpace(collection)
			? Builders<RagDocument>.Filter.Empty
			: Builders<RagDocument>.Filter.Eq(d => d.Collection, collection);

		return await _metadataCollection.CountDocumentsAsync(filter);
	}

	/// <inheritdoc />
	public async Task SaveIndexAsync()
	{
		EnsureBridgeRunning();

		await _bridgeLock.WaitAsync();
		try
		{
			JsonDocument response = await SendCommandAsync(new { command = "save" });
			ValidateResponse(response, "save");
			Console.WriteLine("[FaissVectorStore] Index saved to disk.");
		}
		finally
		{
			_bridgeLock.Release();
		}
	}

	/// <inheritdoc />
	public async Task LoadIndexAsync()
	{
		EnsureBridgeRunning();

		await _bridgeLock.WaitAsync();
		try
		{
			JsonDocument response = await SendCommandAsync(new { command = "load" });
			ValidateResponse(response, "load");

			_nextFaissIndex = response.RootElement.TryGetProperty("count", out JsonElement countEl)
				? countEl.GetInt64()
				: 0;

			Console.WriteLine($"[FaissVectorStore] Index loaded. {_nextFaissIndex} vectors.");
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
			throw new InvalidOperationException("FAISS bridge process is not running.");

		string json = JsonSerializer.Serialize(command);
		await _bridgeProcess.StandardInput.WriteLineAsync(json);
		await _bridgeProcess.StandardInput.FlushAsync();

		string? responseLine = await _bridgeProcess.StandardOutput.ReadLineAsync();
		if (string.IsNullOrEmpty(responseLine))
			throw new InvalidOperationException("FAISS bridge returned empty response.");

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
			string error = response.RootElement.TryGetProperty("error", out JsonElement errEl)
				? errEl.GetString() ?? "unknown error"
				: "unknown error";
			throw new InvalidOperationException($"FAISS bridge '{operation}' failed: {error}");
		}
	}

	/// <summary>
	/// Ensures the Python bridge process is running.
	/// </summary>
	private void EnsureBridgeRunning()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (_bridgeProcess is null || _bridgeProcess.HasExited)
		{
			throw new InvalidOperationException(
				"FAISS bridge is not running. Call StartBridgeAsync() first."
			);
		}
	}

	/// <summary>
	/// Disposes the vector store, shutting down the Python bridge process.
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
					// Send shutdown command
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
