using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTH30N.RAG;

/// <summary>
/// MCP Server exposing RAG as 6 discoverable tools for all P4NTH30N agents.
/// Tools: rag_query, rag_ingest, rag_ingest_file, rag_status, rag_rebuild_index, rag_search_similar
/// </summary>
public sealed class RagMcpServer
{
	private readonly RagService _ragService;
	private readonly IngestionPipeline _ingestion;
	private readonly HealthMonitor _health;

	private static readonly JsonSerializerOptions _jsonOptions = new()
	{
		WriteIndented = true,
		PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
		Converters = { new JsonStringEnumConverter() },
	};

	/// <summary>
	/// Allowed metadata filter fields (Oracle security condition: query whitelist).
	/// </summary>
	private static readonly HashSet<string> _allowedFilterFields = new(StringComparer.OrdinalIgnoreCase) { "agent", "type", "source", "platform", "category", "status" };

	public RagMcpServer(RagService ragService, IngestionPipeline ingestion, HealthMonitor health)
	{
		_ragService = ragService;
		_ingestion = ingestion;
		_health = health;
	}

	/// <summary>
	/// rag_query: Search RAG for relevant context with metadata filtering.
	/// </summary>
	public async Task<McpToolResult> QueryAsync(McpToolParameters parameters, CancellationToken cancellationToken = default)
	{
		string query = parameters.GetRequired<string>("query");
		int topK = parameters.GetOptional("topK", 5);
		Dictionary<string, object>? filter = parameters.GetOptional<Dictionary<string, object>?>("filter", null);
		bool includeMetadata = parameters.GetOptional("includeMetadata", true);

		// SECURITY: Server-side filter validation (Oracle blocking condition #1)
		if (filter != null)
		{
			string? filterError = ValidateFilter(filter);
			if (filterError != null)
			{
				await AuditLogAsync(
					"rag_query",
					"FILTER_REJECTED",
					new
					{
						query,
						filter,
						reason = filterError,
					}
				);
				return McpToolResult.Error($"Invalid filter: {filterError}");
			}
		}

		// Clamp topK to safe range
		topK = Math.Clamp(topK, 1, 20);

		// Audit log the query
		await AuditLogAsync(
			"rag_query",
			"QUERY",
			new
			{
				query,
				topK,
				filter,
			}
		);

		List<RagResult> results = await _ragService.QueryAsync(query, topK, filter, cancellationToken);

		return McpToolResult.Success(
			new
			{
				query,
				results = results.Select(r => new
				{
					content = r.Content,
					source = r.Source,
					score = r.Score,
					metadata = includeMetadata ? r.Metadata : null,
				}),
				totalResults = results.Count,
				latencyMs = results.Sum(r => r.LatencyMs),
			}
		);
	}

	/// <summary>
	/// rag_ingest: Ingest content directly into RAG.
	/// </summary>
	public async Task<McpToolResult> IngestAsync(McpToolParameters parameters, CancellationToken cancellationToken = default)
	{
		string content = parameters.GetRequired<string>("content");
		string source = parameters.GetRequired<string>("source");
		Dictionary<string, object>? metadata = parameters.GetOptional<Dictionary<string, object>?>("metadata", null);

		await AuditLogAsync("rag_ingest", "INGEST", new { source, contentLength = content.Length });

		IngestionResult result = await _ingestion.IngestAsync(content, source, metadata, cancellationToken);

		return McpToolResult.Success(
			new
			{
				documentId = result.DocumentId,
				source,
				status = result.Status.ToString(),
				chunks = result.ChunkCount,
			}
		);
	}

	/// <summary>
	/// rag_ingest_file: Ingest a file into RAG.
	/// </summary>
	public async Task<McpToolResult> IngestFileAsync(McpToolParameters parameters, CancellationToken cancellationToken = default)
	{
		string filePath = parameters.GetRequired<string>("filePath");
		Dictionary<string, object>? metadata = parameters.GetOptional<Dictionary<string, object>?>("metadata", null);

		if (!File.Exists(filePath))
		{
			return McpToolResult.Error($"File not found: {filePath}");
		}

		await AuditLogAsync("rag_ingest_file", "INGEST_FILE", new { filePath });

		string content = await File.ReadAllTextAsync(filePath, cancellationToken);
		IngestionResult result = await _ingestion.IngestAsync(content, filePath, metadata, cancellationToken);

		return McpToolResult.Success(
			new
			{
				documentId = result.DocumentId,
				filePath,
				status = result.Status.ToString(),
				fileSize = content.Length,
				chunks = result.ChunkCount,
			}
		);
	}

	/// <summary>
	/// rag_status: Get RAG system status and metrics.
	/// </summary>
	public Task<McpToolResult> StatusAsync(CancellationToken cancellationToken = default)
	{
		RagHealthStatus status = _health.GetStatus();

		McpToolResult result = McpToolResult.Success(
			new
			{
				vectorStore = new
				{
					indexType = status.IndexType,
					vectorCount = status.VectorCount,
					dimension = status.Dimension,
					memoryUsageMB = status.MemoryUsageMB,
				},
				ingestion = new
				{
					lastIngestion = status.LastIngestion,
					pendingDocuments = status.PendingDocuments,
					totalDocuments = status.TotalDocuments,
				},
				performance = new
				{
					avgQueryLatencyMs = status.AvgQueryLatencyMs,
					avgEmbeddingLatencyMs = status.AvgEmbeddingLatencyMs,
					queriesLastHour = status.QueriesLastHour,
				},
				health = new
				{
					isHealthy = status.IsHealthy,
					embeddingServiceUp = status.EmbeddingServiceUp,
					vectorStoreUp = status.VectorStoreUp,
					lastHealthCheck = status.LastHealthCheck,
				},
			}
		);

		return Task.FromResult(result);
	}

	/// <summary>
	/// rag_rebuild_index: Schedule a full or partial index rebuild.
	/// </summary>
	public async Task<McpToolResult> RebuildIndexAsync(McpToolParameters parameters, CancellationToken cancellationToken = default)
	{
		bool fullRebuild = parameters.GetOptional("fullRebuild", false);
		List<string>? sources = parameters.GetOptional<List<string>?>("sources", null);

		await AuditLogAsync("rag_rebuild_index", "REBUILD_SCHEDULED", new { fullRebuild, sources });

		string jobId = await _ingestion.ScheduleRebuildAsync(fullRebuild, sources, cancellationToken);

		return McpToolResult.Success(
			new
			{
				jobId,
				status = "scheduled",
				fullRebuild,
				estimatedTime = fullRebuild ? "30-60 minutes" : "5-10 minutes",
			}
		);
	}

	/// <summary>
	/// rag_search_similar: Find documents similar to a given document.
	/// </summary>
	public async Task<McpToolResult> SearchSimilarAsync(McpToolParameters parameters, CancellationToken cancellationToken = default)
	{
		string documentId = parameters.GetRequired<string>("documentId");
		int topK = parameters.GetOptional("topK", 5);

		topK = Math.Clamp(topK, 1, 20);

		await AuditLogAsync("rag_search_similar", "SEARCH_SIMILAR", new { documentId, topK });

		List<RagResult> similar = await _ragService.FindSimilarAsync(documentId, topK, cancellationToken);

		return McpToolResult.Success(
			new
			{
				sourceDocument = documentId,
				similarDocuments = similar.Select(s => new
				{
					documentId = s.DocumentId,
					source = s.Source,
					similarity = s.Score,
					preview = s.Content.Length > 200 ? s.Content[..200] : s.Content,
				}),
			}
		);
	}

	/// <summary>
	/// SECURITY: Validates filter fields against whitelist (Oracle blocking condition #1).
	/// Returns error message if invalid, null if valid.
	/// </summary>
	private static string? ValidateFilter(Dictionary<string, object> filter)
	{
		foreach (string key in filter.Keys)
		{
			if (!_allowedFilterFields.Contains(key))
			{
				return $"Field '{key}' is not in the allowed filter whitelist. Allowed: {string.Join(", ", _allowedFilterFields)}";
			}
		}
		return null;
	}

	/// <summary>
	/// SECURITY: Audit logging to EV3NT collection (Oracle blocking condition #1).
	/// </summary>
	private async Task AuditLogAsync(string tool, string action, object details)
	{
		try
		{
			await _ragService.AuditLogAsync(tool, action, details);
		}
		catch
		{
			// Audit failure must not break RAG functionality
		}
	}
}

/// <summary>
/// MCP tool result wrapper.
/// </summary>
public sealed class McpToolResult
{
	public bool IsSuccess { get; init; }
	public object? Data { get; init; }
	public string? ErrorMessage { get; init; }

	public static McpToolResult Success(object data) => new() { IsSuccess = true, Data = data };

	public static McpToolResult Error(string message) => new() { IsSuccess = false, ErrorMessage = message };
}

/// <summary>
/// MCP tool parameter accessor with type-safe getters.
/// </summary>
public sealed class McpToolParameters
{
	private readonly Dictionary<string, JsonElement> _parameters;

	public McpToolParameters(Dictionary<string, JsonElement> parameters)
	{
		_parameters = parameters;
	}

	public McpToolParameters(Dictionary<string, object> parameters)
	{
		_parameters = new Dictionary<string, JsonElement>();
		string json = JsonSerializer.Serialize(parameters);
		using JsonDocument doc = JsonDocument.Parse(json);
		foreach (JsonProperty prop in doc.RootElement.EnumerateObject())
		{
			_parameters[prop.Name] = prop.Value.Clone();
		}
	}

	public T GetRequired<T>(string name)
	{
		if (!_parameters.TryGetValue(name, out JsonElement element))
		{
			throw new ArgumentException($"Required parameter '{name}' is missing.");
		}
		T? value = element.Deserialize<T>();
		if (value == null)
		{
			throw new ArgumentException($"Required parameter '{name}' is null.");
		}
		return value;
	}

	public T GetOptional<T>(string name, T defaultValue)
	{
		if (!_parameters.TryGetValue(name, out JsonElement element))
		{
			return defaultValue;
		}
		T? value = element.Deserialize<T>();
		return value ?? defaultValue;
	}
}
