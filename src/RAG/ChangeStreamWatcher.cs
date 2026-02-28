using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.Json;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTHE0N.RAG;

/// <summary>
/// Watches MongoDB change streams on EV3NT, ERR0R, G4ME, and decisions collections.
/// Batches up to 100 documents and flushes every 30 seconds.
/// </summary>
public sealed class ChangeStreamWatcher : IDisposable
{
	private readonly IMongoDatabase _database;
	private readonly IngestionPipeline _ingestion;
	private readonly SanitizationPipeline _sanitizer;
	private readonly ChangeStreamConfig _config;
	private readonly ConcurrentQueue<ChangeStreamDocument> _buffer = new();
	private readonly List<CancellationTokenSource> _watcherCts = new();
	private Timer? _flushTimer;
	private bool _disposed;

	// Tracking
	private long _totalReceived;
	private long _totalFlushed;
	private long _totalRejected;
	private DateTime _lastFlush;

	public long TotalReceived => _totalReceived;
	public long TotalFlushed => _totalFlushed;
	public long TotalRejected => _totalRejected;
	public DateTime LastFlush => _lastFlush;
	public int BufferCount => _buffer.Count;

	public ChangeStreamWatcher(IMongoDatabase database, IngestionPipeline ingestion, SanitizationPipeline sanitizer, ChangeStreamConfig? config = null)
	{
		_database = database;
		_ingestion = ingestion;
		_sanitizer = sanitizer;
		_config = config ?? new ChangeStreamConfig();
	}

	/// <summary>
	/// Starts watching all configured collections.
	/// </summary>
	public void Start()
	{
		foreach (string collection in _config.WatchCollections)
		{
			CancellationTokenSource cts = new();
			_watcherCts.Add(cts);

			_ = Task.Run(async () => await WatchCollectionAsync(collection, cts.Token));
			Console.WriteLine($"[ChangeStreamWatcher] Watching collection: {collection}");
		}

		// Start flush timer (30-second interval)
		_flushTimer = new Timer(OnFlushTimer, null, TimeSpan.FromSeconds(_config.FlushIntervalSeconds), TimeSpan.FromSeconds(_config.FlushIntervalSeconds));

		Console.WriteLine($"[ChangeStreamWatcher] Started. Flush every {_config.FlushIntervalSeconds}s, max batch {_config.MaxBatchSize}.");
	}

	/// <summary>
	/// Stops all watchers and flushes remaining buffer.
	/// </summary>
	public async Task StopAsync(CancellationToken cancellationToken = default)
	{
		_flushTimer?.Change(Timeout.Infinite, Timeout.Infinite);

		foreach (CancellationTokenSource cts in _watcherCts)
		{
			cts.Cancel();
		}

		// Flush remaining
		if (!_buffer.IsEmpty)
		{
			await FlushBufferAsync(cancellationToken);
		}

		Console.WriteLine("[ChangeStreamWatcher] Stopped.");
	}

	/// <summary>
	/// Forces an immediate buffer flush.
	/// </summary>
	public async Task FlushAsync(CancellationToken cancellationToken = default)
	{
		await FlushBufferAsync(cancellationToken);
	}

	private async Task WatchCollectionAsync(string collectionName, CancellationToken cancellationToken)
	{
		IMongoCollection<BsonDocument> collection = _database.GetCollection<BsonDocument>(collectionName);

		// Watch for insert and update operations
		PipelineDefinition<ChangeStreamDocument<BsonDocument>, ChangeStreamDocument<BsonDocument>> pipeline = new EmptyPipelineDefinition<
			ChangeStreamDocument<BsonDocument>
		>().Match(change =>
			change.OperationType == ChangeStreamOperationType.Insert
			|| change.OperationType == ChangeStreamOperationType.Update
			|| change.OperationType == ChangeStreamOperationType.Replace
		);

		ChangeStreamOptions options = new() { FullDocument = ChangeStreamFullDocumentOption.UpdateLookup };

		while (!cancellationToken.IsCancellationRequested)
		{
			try
			{
				using IChangeStreamCursor<ChangeStreamDocument<BsonDocument>> cursor = await collection.WatchAsync(pipeline, options, cancellationToken);

				await cursor.ForEachAsync(
					change =>
					{
						Interlocked.Increment(ref _totalReceived);

						string content = change.FullDocument?.ToJson() ?? string.Empty;
						if (string.IsNullOrWhiteSpace(content))
							return;

						string docId = change.DocumentKey?.GetValue("_id")?.ToString() ?? Guid.NewGuid().ToString("N");

						_buffer.Enqueue(
							new ChangeStreamDocument
							{
								DocumentId = $"mongo_{collectionName}_{docId}",
								Collection = collectionName,
								Content = content,
								OperationType = change.OperationType.ToString(),
								Timestamp = DateTime.UtcNow,
							}
						);

						// Auto-flush if buffer exceeds max batch size
						if (_buffer.Count >= _config.MaxBatchSize)
						{
							_ = Task.Run(async () =>
							{
								try
								{
									await FlushBufferAsync(CancellationToken.None);
								}
								catch (Exception ex)
								{
									Console.Error.WriteLine($"[ChangeStreamWatcher] Auto-flush error: {ex.Message}");
								}
							});
						}
					},
					cancellationToken
				);
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine($"[ChangeStreamWatcher] Error watching {collectionName}: {ex.Message}");
				// Retry after delay
				try
				{
					await Task.Delay(5000, cancellationToken);
				}
				catch (OperationCanceledException)
				{
					break;
				}
			}
		}
	}

	private void OnFlushTimer(object? state)
	{
		if (_buffer.IsEmpty)
			return;

		_ = Task.Run(async () =>
		{
			try
			{
				await FlushBufferAsync(CancellationToken.None);
			}
			catch (Exception ex)
			{
				Console.Error.WriteLine($"[ChangeStreamWatcher] Timer flush error: {ex.Message}");
			}
		});
	}

	private async Task FlushBufferAsync(CancellationToken cancellationToken)
	{
		// Drain buffer up to max batch size
		List<ChangeStreamDocument> batch = new();
		while (batch.Count < _config.MaxBatchSize && _buffer.TryDequeue(out ChangeStreamDocument? doc))
		{
			batch.Add(doc);
		}

		if (batch.Count == 0)
			return;

		Console.WriteLine($"[ChangeStreamWatcher] Flushing {batch.Count} documents...");

		int ingested = 0;
		int rejected = 0;

		foreach (ChangeStreamDocument doc in batch)
		{
			cancellationToken.ThrowIfCancellationRequested();

			Dictionary<string, object> metadata = new()
			{
				["type"] = "mongodb_change",
				["source"] = doc.Collection,
				["category"] = doc.Collection,
			};

			IngestionResult result = await _ingestion.IngestAsync(doc.Content, $"mongodb://{doc.Collection}/{doc.DocumentId}", metadata, cancellationToken);

			if (result.Status == IngestionStatus.Ingested)
				ingested++;
			else if (result.Status == IngestionStatus.Rejected)
				rejected++;
		}

		Interlocked.Add(ref _totalFlushed, ingested);
		Interlocked.Add(ref _totalRejected, rejected);
		_lastFlush = DateTime.UtcNow;

		Console.WriteLine($"[ChangeStreamWatcher] Flush complete: {ingested} ingested, {rejected} rejected.");
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_flushTimer?.Dispose();
			foreach (CancellationTokenSource cts in _watcherCts)
			{
				cts.Cancel();
				cts.Dispose();
			}
			_watcherCts.Clear();
		}
	}
}

/// <summary>
/// A document received from a MongoDB change stream.
/// </summary>
internal sealed class ChangeStreamDocument
{
	public string DocumentId { get; init; } = string.Empty;
	public string Collection { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string OperationType { get; init; } = string.Empty;
	public DateTime Timestamp { get; init; }
}

/// <summary>
/// Configuration for the change stream watcher.
/// </summary>
public sealed class ChangeStreamConfig
{
	/// <summary>
	/// Collections to watch for changes.
	/// </summary>
	public List<string> WatchCollections { get; init; } = new() { "EV3NT", "ERR0R", "G4ME" };

	/// <summary>
	/// Maximum documents to batch before flushing.
	/// </summary>
	public int MaxBatchSize { get; init; } = 100;

	/// <summary>
	/// Flush interval in seconds.
	/// </summary>
	public int FlushIntervalSeconds { get; init; } = 30;
}
