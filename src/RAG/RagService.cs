using System.Diagnostics;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.RAG;

/// <summary>
/// Core RAG service coordinating embedding, vector search, and context assembly.
/// Provides query and similarity search with metadata filtering and audit logging.
/// </summary>
public sealed class RagService
{
	private readonly EmbeddingService _embedder;
	private readonly FaissVectorStore _vectorStore;
	private readonly ContextBuilder _contextBuilder;
	private readonly IMongoDatabase? _database;
	private readonly RagServiceConfig _config;

	// Performance tracking
	private long _totalQueries;
	private long _totalQueryLatencyMs;

	public long TotalQueries => _totalQueries;
	public double AvgQueryLatencyMs => _totalQueries > 0 ? (double)_totalQueryLatencyMs / _totalQueries : 0.0;

	public RagService(
		EmbeddingService embedder,
		FaissVectorStore vectorStore,
		ContextBuilder contextBuilder,
		IMongoDatabase? database = null,
		RagServiceConfig? config = null
	)
	{
		_embedder = embedder;
		_vectorStore = vectorStore;
		_contextBuilder = contextBuilder;
		_database = database;
		_config = config ?? new RagServiceConfig();
	}

	/// <summary>
	/// Queries RAG for relevant context matching the query string.
	/// </summary>
	public async Task<List<RagResult>> QueryAsync(string query, int topK = 5, Dictionary<string, object>? filter = null, CancellationToken cancellationToken = default)
	{
		Stopwatch sw = Stopwatch.StartNew();

		// Step 1: Generate query embedding
		float[] queryEmbedding = await _embedder.GenerateEmbeddingAsync(query, cancellationToken);

		// Step 2: Vector search with optional metadata filter
		List<SearchResult> searchResults = _vectorStore.Search(queryEmbedding, topK, filter);

		// Step 3: Convert to RagResults
		List<RagResult> results = searchResults
			.Select(sr => new RagResult
			{
				DocumentId = sr.DocumentId,
				Content = sr.Metadata.Content,
				Source = sr.Metadata.Source,
				Score = sr.Score,
				Metadata = sr.Metadata,
				LatencyMs = sw.ElapsedMilliseconds,
			})
			.ToList();

		sw.Stop();
		Interlocked.Increment(ref _totalQueries);
		Interlocked.Add(ref _totalQueryLatencyMs, sw.ElapsedMilliseconds);

		return results;
	}

	/// <summary>
	/// Finds documents similar to the given document ID.
	/// </summary>
	public async Task<List<RagResult>> FindSimilarAsync(string documentId, int topK = 5, CancellationToken cancellationToken = default)
	{
		await Task.CompletedTask; // Async for consistency with interface

		List<SearchResult> searchResults = _vectorStore.FindSimilar(documentId, topK);

		List<RagResult> results = searchResults
			.Select(sr => new RagResult
			{
				DocumentId = sr.DocumentId,
				Content = sr.Metadata.Content,
				Source = sr.Metadata.Source,
				Score = sr.Score,
				Metadata = sr.Metadata,
			})
			.ToList();

		return results;
	}

	/// <summary>
	/// Builds a formatted context string from a query.
	/// Convenience method combining query + context assembly.
	/// </summary>
	public async Task<string> GetContextAsync(string query, int topK = 5, Dictionary<string, object>? filter = null, CancellationToken cancellationToken = default)
	{
		List<RagResult> results = await QueryAsync(query, topK, filter, cancellationToken);
		return _contextBuilder.BuildContext(results, query);
	}

	/// <summary>
	/// Builds a full prompt with RAG context for LLM consumption.
	/// </summary>
	public async Task<string> BuildPromptAsync(string userQuery, int topK = 5, Dictionary<string, object>? filter = null, CancellationToken cancellationToken = default)
	{
		List<RagResult> results = await QueryAsync(userQuery, topK, filter, cancellationToken);
		return _contextBuilder.BuildPrompt(userQuery, results);
	}

	/// <summary>
	/// Audit logging to EV3NT MongoDB collection (Oracle blocking condition #1).
	/// </summary>
	public async Task AuditLogAsync(string tool, string action, object details)
	{
		if (_database == null)
			return;

		try
		{
			IMongoCollection<BsonDocument> collection = _database.GetCollection<BsonDocument>("EV3NT");

			BsonDocument logEntry = new()
			{
				{ "timestamp", DateTime.UtcNow },
				{ "system", "RAG" },
				{ "tool", tool },
				{ "action", action },
				{ "details", details.ToBsonDocument() },
			};

			await collection.InsertOneAsync(logEntry);
		}
		catch
		{
			// Audit failure must not break RAG operations
		}
	}

	/// <summary>
	/// Gets current RAG health status.
	/// </summary>
	public RagHealthStatus GetHealthStatus()
	{
		return new RagHealthStatus
		{
			IsHealthy = _embedder.IsAvailable,
			EmbeddingServiceUp = _embedder.IsAvailable,
			VectorStoreUp = true,
			IndexType = _vectorStore.IndexType,
			VectorCount = _vectorStore.VectorCount,
			Dimension = _vectorStore.Dimension,
			MemoryUsageMB = _vectorStore.MemoryUsageBytes / (1024.0 * 1024.0),
			AvgQueryLatencyMs = AvgQueryLatencyMs,
			AvgEmbeddingLatencyMs = _embedder.AvgLatencyMs,
			QueriesLastHour = _totalQueries,
			LastHealthCheck = DateTime.UtcNow,
			TotalDocuments = _vectorStore.VectorCount,
			PendingDocuments = 0,
		};
	}
}

/// <summary>
/// A single RAG query result with content, source, and relevance score.
/// </summary>
public sealed class RagResult
{
	public string DocumentId { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string Source { get; init; } = string.Empty;
	public float Score { get; init; }
	public DocumentMetadata? Metadata { get; init; }
	public long LatencyMs { get; init; }
	public string? Citation { get; set; }
}

/// <summary>
/// Configuration for the RAG service.
/// </summary>
public sealed class RagServiceConfig
{
	/// <summary>
	/// Default top-K results to return.
	/// </summary>
	public int DefaultTopK { get; init; } = 5;

	/// <summary>
	/// MongoDB database name.
	/// </summary>
	public string DatabaseName { get; init; } = "P4NTH30N";

	/// <summary>
	/// Audit log collection name.
	/// </summary>
	public string AuditCollection { get; init; } = "EV3NT";
}
