using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text;
using System.Text.RegularExpressions;

namespace P4NTHE0N.RAG;

/// <summary>
/// Enhanced query pipeline: embed → hybrid search (BM25 + FAISS) → join → format with citations.
/// Supports agent-scoped filtering via QueryContext.
/// </summary>
public sealed class QueryPipeline
{
	private readonly EmbeddingService _embedder;
	private readonly FaissVectorStore _vectorStore;
	private readonly Bm25Index _bm25;
	private readonly ContextBuilder _contextBuilder;

	// Performance tracking
	private long _totalQueries;
	private long _totalLatencyMs;

	public long TotalQueries => _totalQueries;
	public double AvgLatencyMs => _totalQueries > 0 ? (double)_totalLatencyMs / _totalQueries : 0.0;

	public QueryPipeline(EmbeddingService embedder, FaissVectorStore vectorStore, Bm25Index bm25, ContextBuilder contextBuilder)
	{
		_embedder = embedder;
		_vectorStore = vectorStore;
		_bm25 = bm25;
		_contextBuilder = contextBuilder;
	}

	/// <summary>
	/// Executes a hybrid query: BM25 keyword + FAISS vector, merged via reciprocal rank fusion.
	/// </summary>
	public async Task<QueryResult> QueryAsync(QueryContext context, CancellationToken cancellationToken = default)
	{
		Stopwatch sw = Stopwatch.StartNew();

		// Build metadata filter from agent context
		Dictionary<string, object>? filter = BuildFilter(context);

		// Run BM25 and FAISS in parallel
		Task<List<ScoredDoc>> bm25Task = Task.Run(() => _bm25.Search(context.Query, context.TopK * 2, filter), cancellationToken);
		Task<List<SearchResult>> faissTask = Task.Run(
			async () =>
			{
				float[] embedding = await _embedder.GenerateEmbeddingAsync(context.Query, cancellationToken);
				return _vectorStore.Search(embedding, context.TopK * 2, filter);
			},
			cancellationToken
		);

		await Task.WhenAll(bm25Task, faissTask);

		List<ScoredDoc> bm25Results = bm25Task.Result;
		List<SearchResult> faissResults = faissTask.Result;

		// Reciprocal Rank Fusion (RRF) to merge results
		List<RagResult> merged = ReciprocalRankFusion(bm25Results, faissResults, context.TopK);

		// Format citations if requested
		if (context.IncludeCitations)
		{
			foreach (RagResult result in merged)
			{
				result.Citation = FormatCitation(result);
			}
		}

		sw.Stop();
		Interlocked.Increment(ref _totalQueries);
		Interlocked.Add(ref _totalLatencyMs, sw.ElapsedMilliseconds);

		return new QueryResult
		{
			Query = context.Query,
			Agent = context.Agent,
			Results = merged,
			TotalLatencyMs = sw.ElapsedMilliseconds,
			Bm25Hits = bm25Results.Count,
			FaissHits = faissResults.Count,
		};
	}

	/// <summary>
	/// Builds a context string from query results, respecting token budget.
	/// </summary>
	public async Task<string> GetContextStringAsync(QueryContext context, CancellationToken cancellationToken = default)
	{
		QueryResult result = await QueryAsync(context, cancellationToken);
		return _contextBuilder.BuildContext(result.Results, context.Query);
	}

	/// <summary>
	/// Merges BM25 and FAISS results using Reciprocal Rank Fusion.
	/// RRF score = sum(1 / (k + rank)) across all lists where doc appears.
	/// k = 60 is standard.
	/// </summary>
	private static List<RagResult> ReciprocalRankFusion(List<ScoredDoc> bm25, List<SearchResult> faiss, int topK)
	{
		const int k = 60;
		Dictionary<string, RrfEntry> scores = new();

		// Score BM25 results
		for (int i = 0; i < bm25.Count; i++)
		{
			ScoredDoc doc = bm25[i];
			if (!scores.TryGetValue(doc.DocumentId, out RrfEntry? entry))
			{
				entry = new RrfEntry
				{
					DocumentId = doc.DocumentId,
					Content = doc.Content,
					Source = doc.Source,
					Metadata = doc.Metadata,
				};
				scores[doc.DocumentId] = entry;
			}
			entry.RrfScore += 1.0 / (k + i + 1);
			entry.Bm25Score = doc.Score;
		}

		// Score FAISS results
		for (int i = 0; i < faiss.Count; i++)
		{
			SearchResult sr = faiss[i];
			if (!scores.TryGetValue(sr.DocumentId, out RrfEntry? entry))
			{
				entry = new RrfEntry
				{
					DocumentId = sr.DocumentId,
					Content = sr.Metadata.Content,
					Source = sr.Metadata.Source,
					Metadata = sr.Metadata,
				};
				scores[sr.DocumentId] = entry;
			}
			entry.RrfScore += 1.0 / (k + i + 1);
			entry.FaissScore = sr.Score;
		}

		// Sort by RRF score and take topK
		return scores
			.Values.OrderByDescending(e => e.RrfScore)
			.Take(topK)
			.Select(e => new RagResult
			{
				DocumentId = e.DocumentId,
				Content = e.Content,
				Source = e.Source,
				Score = (float)e.RrfScore,
				Metadata = e.Metadata,
			})
			.ToList();
	}

	/// <summary>
	/// Builds a metadata filter dictionary from the query context.
	/// </summary>
	private static Dictionary<string, object>? BuildFilter(QueryContext context)
	{
		Dictionary<string, object> filter = new();

		if (!string.IsNullOrEmpty(context.Agent))
			filter["agent"] = context.Agent;
		if (!string.IsNullOrEmpty(context.Type))
			filter["type"] = context.Type;
		if (!string.IsNullOrEmpty(context.Platform))
			filter["platform"] = context.Platform;

		return filter.Count > 0 ? filter : null;
	}

	/// <summary>
	/// Formats a citation reference for a result.
	/// Format: [source:line_hint] (score: X.XXX)
	/// </summary>
	private static string FormatCitation(RagResult result)
	{
		string source = result.Source;
		// Normalize path separators
		source = source.Replace('\\', '/');
		// Strip common prefixes
		if (source.StartsWith("C:/P4NTHE0N/", StringComparison.OrdinalIgnoreCase))
			source = source["C:/P4NTHE0N/".Length..];

		return $"[{source}] (score: {result.Score:F3})";
	}
}

/// <summary>
/// Query context with agent-scoped filtering and configuration.
/// </summary>
public sealed class QueryContext
{
	/// <summary>
	/// The search query text.
	/// </summary>
	public string Query { get; init; } = string.Empty;

	/// <summary>
	/// Requesting agent ID for metadata filtering (e.g., "H0UND", "H4ND").
	/// </summary>
	public string? Agent { get; init; }

	/// <summary>
	/// Filter by document type (e.g., "documentation", "code", "error").
	/// </summary>
	public string? Type { get; init; }

	/// <summary>
	/// Filter by platform (e.g., "firekirin", "orionstars").
	/// </summary>
	public string? Platform { get; init; }

	/// <summary>
	/// Number of results to return.
	/// </summary>
	public int TopK { get; init; } = 5;

	/// <summary>
	/// Whether to include formatted citations in results.
	/// </summary>
	public bool IncludeCitations { get; init; } = true;
}

/// <summary>
/// Result of a hybrid query pipeline execution.
/// </summary>
public sealed class QueryResult
{
	public string Query { get; init; } = string.Empty;
	public string? Agent { get; init; }
	public List<RagResult> Results { get; init; } = new();
	public long TotalLatencyMs { get; init; }
	public int Bm25Hits { get; init; }
	public int FaissHits { get; init; }
}

/// <summary>
/// Internal RRF merge entry.
/// </summary>
internal sealed class RrfEntry
{
	public string DocumentId { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string Source { get; init; } = string.Empty;
	public DocumentMetadata? Metadata { get; init; }
	public double RrfScore { get; set; }
	public double Bm25Score { get; set; }
	public float FaissScore { get; set; }
}

/// <summary>
/// BM25 (Best Matching 25) keyword search index.
/// In-memory inverted index with TF-IDF scoring for hybrid search.
/// </summary>
public sealed class Bm25Index
{
	private readonly ConcurrentDictionary<string, Bm25Document> _documents = new();
	private readonly ConcurrentDictionary<string, HashSet<string>> _invertedIndex = new();
	private readonly double _k1;
	private readonly double _b;
	private double _avgDocLength;

	public int DocumentCount => _documents.Count;

	public Bm25Index(double k1 = 1.5, double b = 0.75)
	{
		_k1 = k1;
		_b = b;
	}

	/// <summary>
	/// Indexes a document for BM25 search.
	/// </summary>
	public void AddDocument(string documentId, string content, string source, DocumentMetadata? metadata = null)
	{
		string[] tokens = Tokenize(content);
		Dictionary<string, int> termFreqs = new();

		foreach (string token in tokens)
		{
			termFreqs.TryGetValue(token, out int count);
			termFreqs[token] = count + 1;
		}

		Bm25Document doc = new()
		{
			DocumentId = documentId,
			Content = content,
			Source = source,
			Metadata = metadata,
			TermFrequencies = termFreqs,
			Length = tokens.Length,
		};

		_documents.AddOrUpdate(documentId, doc, (_, _) => doc);

		// Update inverted index
		foreach (string term in termFreqs.Keys)
		{
			_invertedIndex.AddOrUpdate(
				term,
				_ => new HashSet<string> { documentId },
				(_, set) =>
				{
					lock (set)
					{
						set.Add(documentId);
					}
					return set;
				}
			);
		}

		// Update average document length
		UpdateAvgDocLength();
	}

	/// <summary>
	/// Removes a document from the BM25 index.
	/// </summary>
	public bool RemoveDocument(string documentId)
	{
		if (!_documents.TryRemove(documentId, out Bm25Document? doc))
			return false;

		foreach (string term in doc.TermFrequencies.Keys)
		{
			if (_invertedIndex.TryGetValue(term, out HashSet<string>? docSet))
			{
				lock (docSet)
				{
					docSet.Remove(documentId);
				}
			}
		}

		UpdateAvgDocLength();
		return true;
	}

	/// <summary>
	/// Clears the entire BM25 index.
	/// </summary>
	public void Clear()
	{
		_documents.Clear();
		_invertedIndex.Clear();
		_avgDocLength = 0;
	}

	/// <summary>
	/// Searches the BM25 index for documents matching the query.
	/// Supports optional metadata filtering.
	/// </summary>
	public List<ScoredDoc> Search(string query, int topK, Dictionary<string, object>? filter = null)
	{
		string[] queryTerms = Tokenize(query);
		int totalDocs = _documents.Count;
		if (totalDocs == 0 || queryTerms.Length == 0)
			return new List<ScoredDoc>();

		Dictionary<string, double> docScores = new();

		foreach (string term in queryTerms)
		{
			if (!_invertedIndex.TryGetValue(term, out HashSet<string>? postings))
				continue;

			int df;
			string[] postingsCopy;
			lock (postings)
			{
				df = postings.Count;
				postingsCopy = postings.ToArray();
			}

			// IDF = log((N - df + 0.5) / (df + 0.5) + 1)
			double idf = Math.Log((totalDocs - df + 0.5) / (df + 0.5) + 1.0);

			foreach (string docId in postingsCopy)
			{
				if (!_documents.TryGetValue(docId, out Bm25Document? doc))
					continue;

				if (!doc.TermFrequencies.TryGetValue(term, out int tf))
					continue;

				// BM25 score component
				double numerator = tf * (_k1 + 1);
				double denominator = tf + _k1 * (1 - _b + _b * doc.Length / Math.Max(_avgDocLength, 1.0));
				double score = idf * numerator / denominator;

				docScores.TryGetValue(docId, out double currentScore);
				docScores[docId] = currentScore + score;
			}
		}

		// Apply metadata filter and sort
		IEnumerable<KeyValuePair<string, double>> candidates = docScores;
		if (filter != null && filter.Count > 0)
		{
			candidates = candidates.Where(kv =>
			{
				if (!_documents.TryGetValue(kv.Key, out Bm25Document? doc) || doc.Metadata == null)
					return false;
				return MatchesFilter(doc.Metadata, filter);
			});
		}

		return candidates
			.OrderByDescending(kv => kv.Value)
			.Take(topK)
			.Select(kv =>
			{
				Bm25Document doc = _documents[kv.Key];
				return new ScoredDoc
				{
					DocumentId = kv.Key,
					Content = doc.Content,
					Source = doc.Source,
					Score = kv.Value,
					Metadata = doc.Metadata,
				};
			})
			.ToList();
	}

	/// <summary>
	/// Tokenizes text into lowercase terms, removing punctuation and stop words.
	/// </summary>
	private static string[] Tokenize(string text)
	{
		string lower = text.ToLowerInvariant();
		string[] raw = Regex.Split(lower, @"[^\w]+").Where(t => t.Length > 1 && !_stopWords.Contains(t)).ToArray();
		return raw;
	}

	private void UpdateAvgDocLength()
	{
		int count = _documents.Count;
		if (count == 0)
		{
			_avgDocLength = 0;
			return;
		}
		_avgDocLength = _documents.Values.Sum(d => (double)d.Length) / count;
	}

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
				return false;
		}
		return true;
	}

	private static readonly HashSet<string> _stopWords = new(StringComparer.OrdinalIgnoreCase)
	{
		"the",
		"is",
		"at",
		"which",
		"on",
		"a",
		"an",
		"and",
		"or",
		"but",
		"in",
		"with",
		"to",
		"for",
		"of",
		"not",
		"no",
		"can",
		"had",
		"has",
		"have",
		"was",
		"were",
		"been",
		"be",
		"do",
		"does",
		"did",
		"will",
		"would",
		"could",
		"should",
		"may",
		"might",
		"shall",
		"this",
		"that",
		"it",
		"its",
		"from",
		"by",
		"as",
		"are",
		"if",
		"then",
		"than",
		"so",
	};
}

/// <summary>
/// BM25-indexed document.
/// </summary>
internal sealed class Bm25Document
{
	public string DocumentId { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string Source { get; init; } = string.Empty;
	public DocumentMetadata? Metadata { get; init; }
	public Dictionary<string, int> TermFrequencies { get; init; } = new();
	public int Length { get; init; }
}

/// <summary>
/// BM25 search result with score.
/// </summary>
public sealed class ScoredDoc
{
	public string DocumentId { get; init; } = string.Empty;
	public string Content { get; init; } = string.Empty;
	public string Source { get; init; } = string.Empty;
	public double Score { get; init; }
	public DocumentMetadata? Metadata { get; init; }
}
