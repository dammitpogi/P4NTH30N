using System.Diagnostics;

namespace P4NTHE0N.RAG;

/// <summary>
/// Health monitoring for RAG system components.
/// Integration with existing /health endpoint (Oracle blocking condition #4).
/// Tracks embedding service, vector store, and ingestion pipeline health.
/// </summary>
public sealed class HealthMonitor
{
	private readonly EmbeddingService _embedder;
	private readonly FaissVectorStore _vectorStore;
	private readonly IngestionPipeline _ingestion;
	private readonly SanitizationPipeline _sanitizer;
	private readonly HealthMonitorConfig _config;

	private DateTime _lastHealthCheck;
	private RagHealthStatus _cachedStatus;
	private readonly object _statusLock = new();

	public HealthMonitor(
		EmbeddingService embedder,
		FaissVectorStore vectorStore,
		IngestionPipeline ingestion,
		SanitizationPipeline sanitizer,
		HealthMonitorConfig? config = null
	)
	{
		_embedder = embedder;
		_vectorStore = vectorStore;
		_ingestion = ingestion;
		_sanitizer = sanitizer;
		_config = config ?? new HealthMonitorConfig();
		_cachedStatus = BuildStatus();
		_lastHealthCheck = DateTime.UtcNow;
	}

	/// <summary>
	/// Gets current RAG health status.
	/// Caches result for configured interval to avoid expensive checks.
	/// </summary>
	public RagHealthStatus GetStatus()
	{
		lock (_statusLock)
		{
			if (DateTime.UtcNow - _lastHealthCheck > TimeSpan.FromSeconds(_config.CacheIntervalSeconds))
			{
				_cachedStatus = BuildStatus();
				_lastHealthCheck = DateTime.UtcNow;
			}
			return _cachedStatus;
		}
	}

	/// <summary>
	/// Runs a deep health check, including embedding latency test.
	/// </summary>
	public async Task<RagHealthStatus> DeepHealthCheckAsync(CancellationToken cancellationToken = default)
	{
		RagHealthStatus status = BuildStatus();

		// Test embedding latency with a sample text
		try
		{
			Stopwatch sw = Stopwatch.StartNew();
			float[] testEmbedding = await _embedder.GenerateEmbeddingAsync("health check test", cancellationToken);
			sw.Stop();

			status.EmbeddingServiceUp = testEmbedding.Length == _embedder.Dimension;
			status.LastEmbeddingLatencyMs = sw.ElapsedMilliseconds;

			// Alert if embedding latency exceeds threshold
			if (sw.ElapsedMilliseconds > _config.EmbeddingLatencyAlertMs)
			{
				status.Alerts.Add($"Embedding latency {sw.ElapsedMilliseconds}ms exceeds threshold {_config.EmbeddingLatencyAlertMs}ms");
			}
		}
		catch (Exception ex)
		{
			status.EmbeddingServiceUp = false;
			status.Alerts.Add($"Embedding service error: {ex.Message}");
		}

		// Check vector store health
		status.VectorStoreUp = _vectorStore.VectorCount >= 0;

		// Alert on index size
		double indexSizeMB = _vectorStore.MemoryUsageBytes / (1024.0 * 1024.0);
		if (indexSizeMB > _config.IndexSizeAlertMB)
		{
			status.Alerts.Add($"Index size {indexSizeMB:F1}MB exceeds alert threshold {_config.IndexSizeAlertMB}MB");
		}

		// Alert on query latency
		if (status.AvgQueryLatencyMs > _config.QueryLatencyAlertMs)
		{
			status.Alerts.Add($"Avg query latency {status.AvgQueryLatencyMs:F1}ms exceeds threshold {_config.QueryLatencyAlertMs}ms");
		}

		// Overall health
		status.IsHealthy = status.EmbeddingServiceUp && status.VectorStoreUp && status.Alerts.Count == 0;
		status.LastHealthCheck = DateTime.UtcNow;

		lock (_statusLock)
		{
			_cachedStatus = status;
			_lastHealthCheck = DateTime.UtcNow;
		}

		return status;
	}

	/// <summary>
	/// Builds health status from current component states.
	/// </summary>
	private RagHealthStatus BuildStatus()
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
			AvgQueryLatencyMs = _vectorStore.AvgSearchLatencyMs,
			AvgEmbeddingLatencyMs = _embedder.AvgLatencyMs,
			QueriesLastHour = 0,
			TotalDocuments = _vectorStore.VectorCount,
			PendingDocuments = _ingestion.PendingRebuilds,
			LastIngestion = _ingestion.LastIngestion,
			TotalIngested = _ingestion.TotalIngested,
			TotalRejected = _sanitizer.TotalRejected,
			LastHealthCheck = DateTime.UtcNow,
		};
	}
}

/// <summary>
/// RAG system health status.
/// </summary>
public sealed class RagHealthStatus
{
	public bool IsHealthy { get; set; }
	public bool EmbeddingServiceUp { get; set; }
	public bool VectorStoreUp { get; set; }
	public string IndexType { get; set; } = string.Empty;
	public int VectorCount { get; set; }
	public int Dimension { get; set; }
	public double MemoryUsageMB { get; set; }
	public double AvgQueryLatencyMs { get; set; }
	public double AvgEmbeddingLatencyMs { get; set; }
	public long QueriesLastHour { get; set; }
	public int TotalDocuments { get; set; }
	public int PendingDocuments { get; set; }
	public DateTime LastIngestion { get; set; }
	public long TotalIngested { get; set; }
	public long TotalRejected { get; set; }
	public DateTime LastHealthCheck { get; set; }
	public long LastEmbeddingLatencyMs { get; set; }
	public List<string> Alerts { get; init; } = new();
}

/// <summary>
/// Configuration for health monitoring.
/// </summary>
public sealed class HealthMonitorConfig
{
	/// <summary>
	/// Seconds to cache health status before recalculating.
	/// </summary>
	public int CacheIntervalSeconds { get; init; } = 30;

	/// <summary>
	/// Embedding latency threshold for alerts (ms).
	/// </summary>
	public long EmbeddingLatencyAlertMs { get; init; } = 100;

	/// <summary>
	/// Query latency threshold for alerts (ms).
	/// </summary>
	public double QueryLatencyAlertMs { get; init; } = 150;

	/// <summary>
	/// Index size threshold for alerts (MB).
	/// </summary>
	public double IndexSizeAlertMB { get; init; } = 1024;
}
