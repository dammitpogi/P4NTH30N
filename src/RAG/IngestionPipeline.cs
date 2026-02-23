using System.Collections.Concurrent;
using System.Diagnostics;

namespace P4NTH30N.RAG;

/// <summary>
/// Ingestion pipeline: chunk → sanitize → embed → store.
/// Supports direct content ingestion, file ingestion, and scheduled rebuilds.
/// Chunking: 512 tokens with 15% overlap (77 tokens) per Oracle adjustment.
/// </summary>
public sealed class IngestionPipeline
{
	private readonly EmbeddingService _embedder;
	private readonly FaissVectorStore _vectorStore;
	private readonly SanitizationPipeline _sanitizer;
	private readonly IngestionConfig _config;
	private readonly ConcurrentQueue<RebuildJob> _rebuildQueue = new();

	// Tracking
	private long _totalIngested;
	private long _totalChunks;
	private long _totalRejected;
	private DateTime _lastIngestion;

	public long TotalIngested => _totalIngested;
	public long TotalChunks => _totalChunks;
	public long TotalRejected => _totalRejected;
	public DateTime LastIngestion => _lastIngestion;
	public int PendingRebuilds => _rebuildQueue.Count;

	public IngestionPipeline(EmbeddingService embedder, FaissVectorStore vectorStore, SanitizationPipeline sanitizer, IngestionConfig? config = null)
	{
		_embedder = embedder;
		_vectorStore = vectorStore;
		_sanitizer = sanitizer;
		_config = config ?? new IngestionConfig();
	}

	/// <summary>
	/// Ingests content into the RAG vector store.
	/// Pipeline: sanitize → chunk → embed → store.
	/// </summary>
	public async Task<IngestionResult> IngestAsync(
		string content,
		string source,
		Dictionary<string, object>? metadata = null,
		CancellationToken cancellationToken = default
	)
	{
		Stopwatch sw = Stopwatch.StartNew();

		// Step 1: Sanitize
		SanitizationResult sanitized = _sanitizer.Sanitize(content, source);

		if (sanitized.Status == SanitizationStatus.Rejected)
		{
			Interlocked.Increment(ref _totalRejected);
			return new IngestionResult
			{
				DocumentId = string.Empty,
				Status = IngestionStatus.Rejected,
				Reason = sanitized.Reason ?? "Content rejected by sanitization pipeline",
				DurationMs = sw.ElapsedMilliseconds,
			};
		}

		string cleanContent = sanitized.Content ?? content;

		// Step 2: Chunk
		List<ContentChunk> chunks = ChunkContent(cleanContent, source);

		if (chunks.Count == 0)
		{
			return new IngestionResult
			{
				DocumentId = string.Empty,
				Status = IngestionStatus.Empty,
				Reason = "No content to ingest after chunking",
				DurationMs = sw.ElapsedMilliseconds,
			};
		}

		// Step 3: Embed all chunks
		List<string> chunkTexts = chunks.Select(c => c.Text).ToList();
		List<float[]> embeddings = await _embedder.GenerateBatchEmbeddingsAsync(chunkTexts, cancellationToken);

		// Step 4: Store in vector store
		string documentId = GenerateDocumentId(source);

		// Extract metadata fields
		string? agent = metadata?.GetValueOrDefault("agent")?.ToString();
		string? type = metadata?.GetValueOrDefault("type")?.ToString();
		string? platform = metadata?.GetValueOrDefault("platform")?.ToString();
		string? category = metadata?.GetValueOrDefault("category")?.ToString();

		List<(string DocumentId, float[] Vector, DocumentMetadata Metadata)> batch = new();

		for (int i = 0; i < chunks.Count; i++)
		{
			string chunkId = $"{documentId}_chunk{i:D4}";

			DocumentMetadata docMeta = new()
			{
				Source = source,
				Content = chunks[i].Text,
				Agent = agent,
				Type = type ?? InferType(source),
				Platform = platform,
				Category = category,
			};

			batch.Add((chunkId, embeddings[i], docMeta));
		}

		_vectorStore.AddBatch(batch);

		sw.Stop();
		Interlocked.Increment(ref _totalIngested);
		Interlocked.Add(ref _totalChunks, chunks.Count);
		_lastIngestion = DateTime.UtcNow;

		return new IngestionResult
		{
			DocumentId = documentId,
			Status = IngestionStatus.Ingested,
			ChunkCount = chunks.Count,
			DurationMs = sw.ElapsedMilliseconds,
			SanitizationRules = sanitized.AppliedRules,
		};
	}

	/// <summary>
	/// Ingests a file from disk.
	/// </summary>
	public async Task<IngestionResult> IngestFileAsync(string filePath, Dictionary<string, object>? metadata = null, CancellationToken cancellationToken = default)
	{
		if (!File.Exists(filePath))
		{
			return new IngestionResult
			{
				DocumentId = string.Empty,
				Status = IngestionStatus.Error,
				Reason = $"File not found: {filePath}",
			};
		}

		string content = await File.ReadAllTextAsync(filePath, cancellationToken);
		return await IngestAsync(content, filePath, metadata, cancellationToken);
	}

	/// <summary>
	/// Ingests all files in a directory matching the given patterns.
	/// </summary>
	public async Task<List<IngestionResult>> IngestDirectoryAsync(
		string directory,
		string searchPattern = "*.md",
		Dictionary<string, object>? metadata = null,
		CancellationToken cancellationToken = default
	)
	{
		List<IngestionResult> results = new();

		if (!Directory.Exists(directory))
			return results;

		string[] files = Directory.GetFiles(directory, searchPattern, SearchOption.AllDirectories);

		foreach (string file in files)
		{
			cancellationToken.ThrowIfCancellationRequested();
			IngestionResult result = await IngestFileAsync(file, metadata, cancellationToken);
			results.Add(result);
		}

		return results;
	}

	/// <summary>
	/// Batch ingests multiple files with parallel chunking and embedding (max 4 concurrent).
	/// Target: 100 docs in &lt;30s.
	/// </summary>
	public async Task<BatchIngestionResult> IngestBatchAsync(
		IReadOnlyList<string> filePaths,
		Dictionary<string, object>? metadata = null,
		int maxConcurrency = 4,
		CancellationToken cancellationToken = default
	)
	{
		Stopwatch sw = Stopwatch.StartNew();
		SemaphoreSlim semaphore = new(maxConcurrency);
		List<IngestionResult> results = new();
		object resultsLock = new();

		// Phase 1: Parallel read + sanitize + chunk
		List<Task> tasks = new();
		foreach (string filePath in filePaths)
		{
			cancellationToken.ThrowIfCancellationRequested();
			tasks.Add(
				Task.Run(
					async () =>
					{
						await semaphore.WaitAsync(cancellationToken);
						try
						{
							IngestionResult result = await IngestAsync(await File.ReadAllTextAsync(filePath, cancellationToken), filePath, metadata, cancellationToken);
							lock (resultsLock)
							{
								results.Add(result);
							}
						}
						catch (Exception ex)
						{
							lock (resultsLock)
							{
								results.Add(
									new IngestionResult
									{
										DocumentId = string.Empty,
										Status = IngestionStatus.Error,
										Reason = $"{filePath}: {ex.Message}",
									}
								);
							}
						}
						finally
						{
							semaphore.Release();
						}
					},
					cancellationToken
				)
			);
		}

		await Task.WhenAll(tasks);
		sw.Stop();

		int ingested = results.Count(r => r.Status == IngestionStatus.Ingested);
		int rejected = results.Count(r => r.Status == IngestionStatus.Rejected);
		int errors = results.Count(r => r.Status == IngestionStatus.Error);
		int totalChunks = results.Sum(r => r.ChunkCount);

		return new BatchIngestionResult
		{
			TotalFiles = filePaths.Count,
			Ingested = ingested,
			Rejected = rejected,
			Errors = errors,
			TotalChunks = totalChunks,
			DurationMs = sw.ElapsedMilliseconds,
			DocsPerSecond = sw.ElapsedMilliseconds > 0 ? ingested * 1000.0 / sw.ElapsedMilliseconds : 0,
			Results = results,
		};
	}

	/// <summary>
	/// Batch ingests an entire directory with parallel processing.
	/// </summary>
	public async Task<BatchIngestionResult> IngestDirectoryBatchAsync(
		string directory,
		string searchPattern = "*.*",
		Dictionary<string, object>? metadata = null,
		int maxConcurrency = 4,
		CancellationToken cancellationToken = default
	)
	{
		if (!Directory.Exists(directory))
		{
			return new BatchIngestionResult { TotalFiles = 0 };
		}

		List<string> files = Directory
			.GetFiles(directory, searchPattern, SearchOption.AllDirectories)
			.Where(f =>
			{
				string ext = Path.GetExtension(f);
				return _config.IncludeExtensions.Contains(ext);
			})
			.Where(f =>
			{
				// Exclude configured directories
				string? dir = Path.GetDirectoryName(f);
				if (dir == null)
					return true;
				return !_config.ExcludeDirectories.Any(ex => dir.Contains(ex, StringComparison.OrdinalIgnoreCase));
			})
			.ToList();

		return await IngestBatchAsync(files, metadata, maxConcurrency, cancellationToken);
	}

	/// <summary>
	/// Schedules a full or partial index rebuild.
	/// </summary>
	public Task<string> ScheduleRebuildAsync(bool fullRebuild, List<string>? sources = null, CancellationToken cancellationToken = default)
	{
		string jobId = $"rebuild_{DateTime.UtcNow:yyyyMMdd_HHmmss}";

		RebuildJob job = new()
		{
			JobId = jobId,
			FullRebuild = fullRebuild,
			Sources = sources,
			ScheduledAt = DateTime.UtcNow,
		};

		_rebuildQueue.Enqueue(job);

		return Task.FromResult(jobId);
	}

	/// <summary>
	/// Processes pending rebuild jobs.
	/// </summary>
	public async Task ProcessRebuildsAsync(CancellationToken cancellationToken = default)
	{
		while (_rebuildQueue.TryDequeue(out RebuildJob? job))
		{
			cancellationToken.ThrowIfCancellationRequested();

			if (job.FullRebuild)
			{
				_vectorStore.Clear();
			}
			else if (job.Sources != null)
			{
				foreach (string source in job.Sources)
				{
					_vectorStore.RemoveByFilter(new Dictionary<string, object> { { "source", source } });
				}
			}

			// Re-ingest from configured sources would happen here
			// For now, this clears and prepares for re-ingestion
		}

		await _vectorStore.SaveAsync(cancellationToken);
	}

	/// <summary>
	/// Performs bulk ingestion from RagActivationConfig.BulkIngestion configuration.
	/// Ingests all configured directories and root documents.
	/// </summary>
	public async Task<BulkIngestionResult> IngestFromConfigAsync(
		RagActivationConfig config,
		CancellationToken cancellationToken = default
	)
	{
		if (!config.BulkIngestion.Enabled)
		{
			Console.WriteLine("[IngestionPipeline] Bulk ingestion disabled in config");
			return new BulkIngestionResult { TotalFiles = 0, Ingested = 0 };
		}

		Console.WriteLine($"[IngestionPipeline] Starting bulk ingestion from {config.BulkIngestion.Directories.Count} directories");

		var allResults = new List<BatchIngestionResult>();
		int rootDocsIngested = 0;

		// Ingest each configured directory
		foreach (var dir in config.BulkIngestion.Directories)
		{
			if (string.IsNullOrWhiteSpace(dir.Path) || !Directory.Exists(dir.Path))
			{
				Console.WriteLine($"[IngestionPipeline] Skipping non-existent directory: {dir.Path}");
				continue;
			}

			Console.WriteLine($"[IngestionPipeline] Ingesting directory: {dir.Path} (tag: {dir.Tag}, priority: {dir.Priority})");

			var metadata = new Dictionary<string, object>
			{
				{ "agent", "bulk-ingestion" },
				{ "type", "bulk" },
				{ "category", dir.Tag },
			};

			BatchIngestionResult dirResult = await IngestDirectoryBatchAsync(
				dir.Path,
				"*.*",
				metadata,
				4,
				cancellationToken
			);

			allResults.Add(dirResult);
			Console.WriteLine($"[IngestionPipeline] Ingested {dirResult.Ingested}/{dirResult.TotalFiles} from {dir.Path}");
		}

		// Ingest individual root documents
		foreach (var docPath in config.BulkIngestion.RootDocuments)
		{
			if (!File.Exists(docPath))
			{
				Console.WriteLine($"[IngestionPipeline] Skipping non-existent root document: {docPath}");
				continue;
			}

			Console.WriteLine($"[IngestionPipeline] Ingesting root document: {docPath}");

			var metadata = new Dictionary<string, object>
			{
				{ "agent", "bulk-ingestion" },
				{ "type", "root-document" },
			};

			IngestionResult docResult = await IngestFileAsync(docPath, metadata, cancellationToken);
			rootDocsIngested++;

			if (docResult.Status == IngestionStatus.Ingested)
			{
				Console.WriteLine($"[IngestionPipeline] Ingested root document: {Path.GetFileName(docPath)} ({docResult.ChunkCount} chunks)");
			}
			else
			{
				Console.WriteLine($"[IngestionPipeline] Failed to ingest {Path.GetFileName(docPath)}: {docResult.Reason}");
			}
		}

		// Aggregate results
		int totalFiles = allResults.Sum(r => r.TotalFiles);
		int ingested = allResults.Sum(r => r.Ingested);
		int rejected = allResults.Sum(r => r.Rejected);
		int errors = allResults.Sum(r => r.Errors);
		int totalChunks = allResults.Sum(r => r.TotalChunks);
		long durationMs = allResults.Sum(r => r.DurationMs);

		var result = new BulkIngestionResult
		{
			TotalFiles = totalFiles,
			Ingested = ingested,
			Rejected = rejected,
			Errors = errors,
			TotalChunks = totalChunks,
			RootDocumentsIngested = rootDocsIngested,
			DurationMs = durationMs,
		};

		Console.WriteLine($"[IngestionPipeline] Bulk ingestion complete: {result.Ingested}/{result.TotalFiles} files ingested");

		return result;
	}

	/// <summary>
	/// Gets the chunk count for a document.
	/// </summary>
	public int GetChunkCount(string documentId)
	{
		// Count vectors with matching document ID prefix
		return _vectorStore.VectorCount; // Simplified; real implementation would filter by prefix
	}

	/// <summary>
	/// Chunks content into overlapping segments.
	/// Strategy: 512 tokens (~2048 chars) with 15% overlap (77 tokens ~308 chars).
	/// Uses section-aware chunking for markdown, simple sliding window otherwise.
	/// </summary>
	internal List<ContentChunk> ChunkContent(string content, string source)
	{
		List<ContentChunk> chunks = new();

		if (string.IsNullOrWhiteSpace(content))
			return chunks;

		// Determine chunking strategy based on source type
		bool isMarkdown = source.EndsWith(".md", StringComparison.OrdinalIgnoreCase);
		bool isCode = source.EndsWith(".cs", StringComparison.OrdinalIgnoreCase) || source.EndsWith(".json", StringComparison.OrdinalIgnoreCase);

		if (isMarkdown)
		{
			chunks = ChunkMarkdown(content);
		}
		else if (isCode)
		{
			chunks = ChunkCode(content);
		}
		else
		{
			chunks = ChunkSlidingWindow(content);
		}

		return chunks;
	}

	/// <summary>
	/// Section-aware chunking for markdown documents.
	/// Splits on headings, respects section boundaries.
	/// </summary>
	private List<ContentChunk> ChunkMarkdown(string content)
	{
		List<ContentChunk> chunks = new();
		string[] lines = content.Split('\n');

		List<string> currentSection = new();
		int currentLength = 0;

		foreach (string line in lines)
		{
			bool isHeading = line.TrimStart().StartsWith('#');

			// If heading and current section is non-empty, flush
			if (isHeading && currentSection.Count > 0 && currentLength > _config.MinChunkChars)
			{
				string sectionText = string.Join('\n', currentSection);
				AddChunksFromText(chunks, sectionText);
				currentSection.Clear();
				currentLength = 0;
			}

			currentSection.Add(line);
			currentLength += line.Length;
		}

		// Flush remaining
		if (currentSection.Count > 0)
		{
			string sectionText = string.Join('\n', currentSection);
			AddChunksFromText(chunks, sectionText);
		}

		return chunks;
	}

	/// <summary>
	/// AST-aware chunking for code files.
	/// Splits on class/method boundaries.
	/// </summary>
	private List<ContentChunk> ChunkCode(string content)
	{
		// Simple approach: split on class/method declarations
		List<ContentChunk> chunks = new();
		string[] lines = content.Split('\n');

		List<string> currentBlock = new();
		int currentLength = 0;

		foreach (string line in lines)
		{
			string trimmed = line.TrimStart();
			bool isDeclaration =
				trimmed.StartsWith("public ")
				|| trimmed.StartsWith("private ")
				|| trimmed.StartsWith("internal ")
				|| trimmed.StartsWith("protected ")
				|| trimmed.StartsWith("namespace ")
				|| trimmed.StartsWith("class ")
				|| trimmed.StartsWith("interface ");

			if (isDeclaration && currentBlock.Count > 0 && currentLength > _config.MinChunkChars)
			{
				string blockText = string.Join('\n', currentBlock);
				AddChunksFromText(chunks, blockText);
				currentBlock.Clear();
				currentLength = 0;
			}

			currentBlock.Add(line);
			currentLength += line.Length;
		}

		if (currentBlock.Count > 0)
		{
			string blockText = string.Join('\n', currentBlock);
			AddChunksFromText(chunks, blockText);
		}

		return chunks;
	}

	/// <summary>
	/// Sliding window chunking with overlap.
	/// </summary>
	private List<ContentChunk> ChunkSlidingWindow(string content)
	{
		List<ContentChunk> chunks = new();
		AddChunksFromText(chunks, content);
		return chunks;
	}

	/// <summary>
	/// Splits text into overlapping chunks of configured size.
	/// </summary>
	private void AddChunksFromText(List<ContentChunk> chunks, string text)
	{
		if (text.Length <= _config.MaxChunkChars)
		{
			if (text.Length >= _config.MinChunkChars)
			{
				chunks.Add(new ContentChunk { Text = text.Trim(), Index = chunks.Count });
			}
			return;
		}

		int position = 0;
		while (position < text.Length)
		{
			int length = Math.Min(_config.MaxChunkChars, text.Length - position);
			string chunk = text.Substring(position, length).Trim();

			if (chunk.Length >= _config.MinChunkChars)
			{
				chunks.Add(new ContentChunk { Text = chunk, Index = chunks.Count });
			}

			// Advance by chunk size minus overlap
			position += _config.MaxChunkChars - _config.OverlapChars;
		}
	}

	/// <summary>
	/// Generates a deterministic document ID from source.
	/// </summary>
	private static string GenerateDocumentId(string source)
	{
		int hash = source.GetHashCode(StringComparison.Ordinal);
		return $"doc_{Math.Abs(hash):X8}";
	}

	/// <summary>
	/// Infers document type from source path.
	/// </summary>
	private static string InferType(string source)
	{
		if (source.EndsWith(".md", StringComparison.OrdinalIgnoreCase))
			return "documentation";
		if (source.EndsWith(".cs", StringComparison.OrdinalIgnoreCase))
			return "code";
		if (source.EndsWith(".json", StringComparison.OrdinalIgnoreCase))
			return "config";
		if (source.Contains("ERR0R", StringComparison.OrdinalIgnoreCase))
			return "error";
		if (source.Contains("EV3NT", StringComparison.OrdinalIgnoreCase))
			return "event";
		if (source.Contains("CRED3N7IAL", StringComparison.OrdinalIgnoreCase))
			return "credential";
		return "unknown";
	}
}

/// <summary>
/// A content chunk produced during ingestion.
/// </summary>
internal sealed class ContentChunk
{
	public string Text { get; init; } = string.Empty;
	public int Index { get; init; }
}

/// <summary>
/// A pending rebuild job.
/// </summary>
internal sealed class RebuildJob
{
	public string JobId { get; init; } = string.Empty;
	public bool FullRebuild { get; init; }
	public List<string>? Sources { get; init; }
	public DateTime ScheduledAt { get; init; }
}

/// <summary>
/// Result of an ingestion operation.
/// </summary>
public sealed class IngestionResult
{
	public string DocumentId { get; init; } = string.Empty;
	public IngestionStatus Status { get; init; }
	public int ChunkCount { get; init; }
	public long DurationMs { get; init; }
	public string? Reason { get; init; }
	public List<string> SanitizationRules { get; init; } = new();
}

/// <summary>
/// Ingestion outcome status.
/// </summary>
public enum IngestionStatus
{
	Ingested,
	Rejected,
	Empty,
	Error,
}

/// <summary>
/// Result of a batch ingestion operation.
/// </summary>
public sealed class BatchIngestionResult
{
	public int TotalFiles { get; init; }
	public int Ingested { get; init; }
	public int Rejected { get; init; }
	public int Errors { get; init; }
	public int TotalChunks { get; init; }
	public long DurationMs { get; init; }
	public double DocsPerSecond { get; init; }
	public List<IngestionResult> Results { get; init; } = new();

	public override string ToString() =>
		$"Batch: {Ingested}/{TotalFiles} ingested, {Rejected} rejected, {Errors} errors, " + $"{TotalChunks} chunks, {DurationMs}ms ({DocsPerSecond:F1} docs/sec)";
}

/// <summary>
/// Configuration for the ingestion pipeline.
/// </summary>
public sealed class IngestionConfig
{
	/// <summary>
	/// Maximum chunk size in characters (~512 tokens * 4 chars/token).
	/// </summary>
	public int MaxChunkChars { get; init; } = 2048;

	/// <summary>
	/// Minimum chunk size in characters to avoid tiny fragments.
	/// </summary>
	public int MinChunkChars { get; init; } = 100;

	/// <summary>
	/// Overlap between chunks in characters (~77 tokens * 4 chars/token = 15% of 2048).
	/// </summary>
	public int OverlapChars { get; init; } = 308;

	/// <summary>
	/// File extensions to ingest.
	/// </summary>
	public HashSet<string> IncludeExtensions { get; init; } = new(StringComparer.OrdinalIgnoreCase) { ".md", ".cs", ".json", ".txt", ".yml", ".yaml" };

	/// <summary>
	/// Directories to exclude from ingestion.
	/// </summary>
	public HashSet<string> ExcludeDirectories { get; init; } = new(StringComparer.OrdinalIgnoreCase) { "bin", "obj", ".git", "node_modules", "Releases" };
}

/// <summary>
/// Result of a bulk ingestion operation from RagActivationConfig.
/// </summary>
public sealed class BulkIngestionResult
{
	public int TotalFiles { get; init; }
	public int Ingested { get; init; }
	public int Rejected { get; init; }
	public int Errors { get; init; }
	public int TotalChunks { get; init; }
	public int RootDocumentsIngested { get; init; }
	public long DurationMs { get; init; }

	public override string ToString() =>
		$"Bulk: {Ingested}/{TotalFiles} files, {Rejected} rejected, {Errors} errors, " +
		$"{TotalChunks} chunks, {RootDocumentsIngested} root docs, {DurationMs}ms";
}
