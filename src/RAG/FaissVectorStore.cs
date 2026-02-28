using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.Json;

namespace P4NTHE0N.RAG;

/// <summary>
/// In-memory vector store implementing IndexFlatL2 (exact nearest-neighbor search).
/// Stores vectors in memory with metadata in MongoDB.
/// Migration path: upgrade to IVF at 50k vectors.
/// Persistence: binary file with atomic swap for reliability.
/// </summary>
public sealed class FaissVectorStore : IDisposable
{
	private readonly ConcurrentDictionary<string, VectorEntry> _vectors = new();
	private readonly FaissConfig _config;
	private readonly object _persistLock = new();
	private bool _disposed;

	// Performance tracking
	private long _totalSearches;
	private long _totalSearchLatencyMs;

	public int VectorCount => _vectors.Count;
	public int Dimension => _config.Dimension;
	public string IndexType => _vectors.Count < _config.IvfUpgradeThreshold ? "IndexFlatL2" : "IndexFlatL2 (IVF recommended)";
	public double AvgSearchLatencyMs => _totalSearches > 0 ? (double)_totalSearchLatencyMs / _totalSearches : 0.0;
	public long MemoryUsageBytes => (long)_vectors.Count * _config.Dimension * sizeof(float) + _vectors.Count * 256;

	public FaissVectorStore(FaissConfig? config = null)
	{
		_config = config ?? new FaissConfig();
	}

	/// <summary>
	/// Adds a vector with associated document metadata.
	/// </summary>
	public void Add(string documentId, float[] vector, DocumentMetadata metadata)
	{
		if (vector.Length != _config.Dimension)
		{
			throw new ArgumentException($"Vector dimension mismatch: expected {_config.Dimension}, got {vector.Length}");
		}

		VectorEntry entry = new()
		{
			DocumentId = documentId,
			Vector = vector,
			Metadata = metadata,
			AddedAt = DateTime.UtcNow,
		};

		_vectors.AddOrUpdate(documentId, entry, (_, _) => entry);
	}

	/// <summary>
	/// Adds a batch of vectors.
	/// </summary>
	public void AddBatch(IReadOnlyList<(string DocumentId, float[] Vector, DocumentMetadata Metadata)> batch)
	{
		foreach ((string documentId, float[] vector, DocumentMetadata metadata) in batch)
		{
			Add(documentId, vector, metadata);
		}
	}

	/// <summary>
	/// Searches for the top-K nearest neighbors using L2 (Euclidean) distance.
	/// Supports optional metadata filtering.
	/// </summary>
	public List<SearchResult> Search(float[] queryVector, int topK, Dictionary<string, object>? filter = null)
	{
		if (queryVector.Length != _config.Dimension)
		{
			throw new ArgumentException($"Query vector dimension mismatch: expected {_config.Dimension}, got {queryVector.Length}");
		}

		Stopwatch sw = Stopwatch.StartNew();

		// Filter candidates by metadata if provided
		IEnumerable<KeyValuePair<string, VectorEntry>> candidates = _vectors;
		if (filter != null && filter.Count > 0)
		{
			candidates = candidates.Where(kv => MatchesFilter(kv.Value.Metadata, filter));
		}

		// Compute distances and find top-K
		List<SearchResult> results = candidates
			.Select(kv => new SearchResult
			{
				DocumentId = kv.Key,
				Distance = ComputeL2Distance(queryVector, kv.Value.Vector),
				Score = 0.0f, // Will be computed below
				Metadata = kv.Value.Metadata,
			})
			.OrderBy(r => r.Distance)
			.Take(topK)
			.ToList();

		// Convert distance to similarity score (1 / (1 + distance))
		foreach (SearchResult result in results)
		{
			result.Score = 1.0f / (1.0f + result.Distance);
		}

		sw.Stop();
		Interlocked.Increment(ref _totalSearches);
		Interlocked.Add(ref _totalSearchLatencyMs, sw.ElapsedMilliseconds);

		return results;
	}

	/// <summary>
	/// Finds documents similar to the given document ID.
	/// </summary>
	public List<SearchResult> FindSimilar(string documentId, int topK)
	{
		if (!_vectors.TryGetValue(documentId, out VectorEntry? entry))
		{
			return new List<SearchResult>();
		}

		// Search excluding the source document
		List<SearchResult> results = _vectors
			.Where(kv => kv.Key != documentId)
			.Select(kv => new SearchResult
			{
				DocumentId = kv.Key,
				Distance = ComputeL2Distance(entry.Vector, kv.Value.Vector),
				Metadata = kv.Value.Metadata,
			})
			.OrderBy(r => r.Distance)
			.Take(topK)
			.ToList();

		foreach (SearchResult result in results)
		{
			result.Score = 1.0f / (1.0f + result.Distance);
		}

		return results;
	}

	/// <summary>
	/// Removes a vector by document ID.
	/// </summary>
	public bool Remove(string documentId)
	{
		return _vectors.TryRemove(documentId, out _);
	}

	/// <summary>
	/// Removes all vectors matching a filter.
	/// </summary>
	public int RemoveByFilter(Dictionary<string, object> filter)
	{
		List<string> toRemove = _vectors.Where(kv => MatchesFilter(kv.Value.Metadata, filter)).Select(kv => kv.Key).ToList();

		int removed = 0;
		foreach (string id in toRemove)
		{
			if (_vectors.TryRemove(id, out _))
			{
				removed++;
			}
		}
		return removed;
	}

	/// <summary>
	/// Clears all vectors from the store.
	/// </summary>
	public void Clear()
	{
		_vectors.Clear();
	}

	/// <summary>
	/// Persists the index to disk using atomic swap pattern.
	/// Writes to temp file first, then atomically replaces the target.
	/// </summary>
	public async Task SaveAsync(CancellationToken cancellationToken = default)
	{
		string indexPath = _config.IndexPath;
		string tempPath = indexPath + ".tmp";
		string backupPath = indexPath + ".bak";

		lock (_persistLock)
		{
			string? dir = Path.GetDirectoryName(indexPath);
			if (dir != null && !Directory.Exists(dir))
			{
				Directory.CreateDirectory(dir);
			}
		}

		// Serialize to temp file
		List<SerializedVectorEntry> entries = _vectors
			.Values.Select(v => new SerializedVectorEntry
			{
				DocumentId = v.DocumentId,
				Vector = v.Vector,
				Source = v.Metadata.Source,
				Content = v.Metadata.Content,
				Agent = v.Metadata.Agent,
				Type = v.Metadata.Type,
				Platform = v.Metadata.Platform,
				Category = v.Metadata.Category,
				AddedAt = v.AddedAt,
			})
			.ToList();

		string json = JsonSerializer.Serialize(entries, new JsonSerializerOptions { WriteIndented = false });
		await File.WriteAllTextAsync(tempPath, json, cancellationToken);

		lock (_persistLock)
		{
			// Atomic swap: backup → replace → cleanup
			if (File.Exists(indexPath))
			{
				File.Copy(indexPath, backupPath, overwrite: true);
			}
			File.Move(tempPath, indexPath, overwrite: true);
		}
	}

	/// <summary>
	/// Loads the index from disk.
	/// </summary>
	public async Task LoadAsync(CancellationToken cancellationToken = default)
	{
		string indexPath = _config.IndexPath;

		if (!File.Exists(indexPath))
		{
			return;
		}

		try
		{
			string json = await File.ReadAllTextAsync(indexPath, cancellationToken);
			List<SerializedVectorEntry>? entries = JsonSerializer.Deserialize<List<SerializedVectorEntry>>(json);

			if (entries == null)
				return;

			_vectors.Clear();
			foreach (SerializedVectorEntry entry in entries)
			{
				VectorEntry vectorEntry = new()
				{
					DocumentId = entry.DocumentId,
					Vector = entry.Vector,
					Metadata = new DocumentMetadata
					{
						Source = entry.Source,
						Content = entry.Content,
						Agent = entry.Agent,
						Type = entry.Type,
						Platform = entry.Platform,
						Category = entry.Category,
					},
					AddedAt = entry.AddedAt,
				};
				_vectors.TryAdd(entry.DocumentId, vectorEntry);
			}

			Console.WriteLine($"[FaissVectorStore] Loaded {_vectors.Count} vectors from {indexPath}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[FaissVectorStore] Failed to load index: {ex.Message}");

			// Try backup
			string backupPath = indexPath + ".bak";
			if (File.Exists(backupPath))
			{
				Console.WriteLine("[FaissVectorStore] Attempting backup recovery...");
				File.Copy(backupPath, indexPath, overwrite: true);
			}
		}
	}

	/// <summary>
	/// Computes L2 (Euclidean) distance between two vectors.
	/// </summary>
	private static float ComputeL2Distance(float[] a, float[] b)
	{
		float sum = 0.0f;
		int length = Math.Min(a.Length, b.Length);

		for (int i = 0; i < length; i++)
		{
			float diff = a[i] - b[i];
			sum += diff * diff;
		}

		return MathF.Sqrt(sum);
	}

	/// <summary>
	/// Checks if metadata matches the given filter criteria.
	/// </summary>
	private static bool MatchesFilter(DocumentMetadata metadata, Dictionary<string, object> filter)
	{
		foreach (KeyValuePair<string, object> kvp in filter)
		{
			string? value = kvp.Key.ToLowerInvariant() switch
			{
				"agent" => metadata.Agent,
				"type" => metadata.Type,
				"source" => metadata.Source,
				"platform" => metadata.Platform,
				"category" => metadata.Category,
				"status" => metadata.Status,
				_ => null,
			};

			string filterValue = kvp.Value?.ToString() ?? string.Empty;

			if (value == null || !value.Equals(filterValue, StringComparison.OrdinalIgnoreCase))
			{
				return false;
			}
		}
		return true;
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_vectors.Clear();
		}
	}
}

/// <summary>
/// A stored vector with its metadata.
/// </summary>
internal sealed class VectorEntry
{
	public string DocumentId { get; init; } = string.Empty;
	public float[] Vector { get; init; } = Array.Empty<float>();
	public DocumentMetadata Metadata { get; init; } = new();
	public DateTime AddedAt { get; init; }
}

/// <summary>
/// Serializable vector entry for persistence.
/// </summary>
internal sealed class SerializedVectorEntry
{
	public string DocumentId { get; init; } = string.Empty;
	public float[] Vector { get; init; } = Array.Empty<float>();
	public string Source { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string? Agent { get; init; }
	public string? Type { get; init; }
	public string? Platform { get; init; }
	public string? Category { get; init; }
	public DateTime AddedAt { get; init; }
}

/// <summary>
/// Result of a vector search operation.
/// </summary>
public sealed class SearchResult
{
	public string DocumentId { get; init; } = string.Empty;
	public float Distance { get; init; }
	public float Score { get; set; }
	public DocumentMetadata Metadata { get; init; } = new();
}

/// <summary>
/// Document metadata stored alongside vectors.
/// </summary>
public sealed class DocumentMetadata
{
	public string Source { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string? Agent { get; init; }
	public string? Type { get; init; }
	public string? Platform { get; init; }
	public string? Category { get; init; }
	public string? Status { get; init; }
	public DateTime IngestedAt { get; init; } = DateTime.UtcNow;
}

/// <summary>
/// Configuration for FAISS vector store.
/// </summary>
public sealed class FaissConfig
{
	/// <summary>
	/// Path to persist the FAISS index.
	/// </summary>
	public string IndexPath { get; init; } = Path.Combine("rag", "faiss.index");

	/// <summary>
	/// Vector dimension. Must match embedding model output.
	/// </summary>
	public int Dimension { get; init; } = 384;

	/// <summary>
	/// Threshold to recommend IVF upgrade.
	/// </summary>
	public int IvfUpgradeThreshold { get; init; } = 50000;
}
