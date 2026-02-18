using MongoDB.Driver;

namespace P4NTH30N.C0MMON.RAG;

/// <summary>
/// Hybrid search combining FAISS vector similarity with MongoDB keyword matching.
/// Uses Reciprocal Rank Fusion (RRF) to merge results from both pipelines
/// into a single relevance-ranked list.
/// </summary>
/// <remarks>
/// RRF formula: score(d) = Σ 1/(k + rank_i(d)) for each retrieval method i
/// where k is a constant (default 60) that controls rank saturation.
/// This approach is robust and doesn't require score normalization across methods.
/// </remarks>
public sealed class HybridSearch : IHybridSearch
{
	/// <summary>
	/// RRF constant that controls rank influence saturation.
	/// k=60 is the standard value from the original Cormack et al. paper.
	/// Higher values reduce the impact of top-ranked results.
	/// </summary>
	private const float RrfK = 60.0f;

	private readonly IVectorStore _vectorStore;
	private readonly IEmbeddingService _embeddingService;
	private readonly IMongoCollection<RagDocument> _documentCollection;

	/// <summary>
	/// Creates a HybridSearch instance with the required dependencies.
	/// </summary>
	/// <param name="vectorStore">FAISS-backed vector store for semantic search.</param>
	/// <param name="embeddingService">Embedding generator for query vectorization.</param>
	/// <param name="documentCollection">MongoDB collection for keyword search and metadata.</param>
	public HybridSearch(
		IVectorStore vectorStore,
		IEmbeddingService embeddingService,
		IMongoCollection<RagDocument> documentCollection)
	{
		_vectorStore = vectorStore ?? throw new ArgumentNullException(nameof(vectorStore));
		_embeddingService = embeddingService ?? throw new ArgumentNullException(nameof(embeddingService));
		_documentCollection = documentCollection ?? throw new ArgumentNullException(nameof(documentCollection));
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<SearchResult>> SearchAsync(
		string query,
		int topK = 5,
		string? collection = null,
		float vectorWeight = 0.6f)
	{
		if (string.IsNullOrWhiteSpace(query))
			throw new ArgumentException("Query cannot be null or empty.", nameof(query));

		// Clamp weight to valid range
		vectorWeight = Math.Clamp(vectorWeight, 0.0f, 1.0f);
		float keywordWeight = 1.0f - vectorWeight;

		// Fetch more candidates than topK to allow fusion to re-rank
		int candidateCount = topK * 3;

		// Run vector and keyword searches in parallel
		Task<IReadOnlyList<SearchResult>> vectorTask = VectorSearchAsync(query, candidateCount, collection);
		Task<IReadOnlyList<SearchResult>> keywordTask = KeywordSearchAsync(query, candidateCount, collection);

		await Task.WhenAll(vectorTask, keywordTask);

		IReadOnlyList<SearchResult> vectorResults = vectorTask.Result;
		IReadOnlyList<SearchResult> keywordResults = keywordTask.Result;

		// Fuse results using Reciprocal Rank Fusion
		List<SearchResult> fused = ReciprocalRankFusion(
			vectorResults, keywordResults,
			vectorWeight, keywordWeight, topK
		);

		return fused;
	}

	/// <inheritdoc />
	public async Task<IReadOnlyList<SearchResult>> KeywordSearchAsync(
		string query,
		int topK = 5,
		string? collection = null)
	{
		if (string.IsNullOrWhiteSpace(query))
			return Array.Empty<SearchResult>();

		try
		{
			// Build MongoDB text search filter
			FilterDefinitionBuilder<RagDocument> builder = Builders<RagDocument>.Filter;
			FilterDefinition<RagDocument> filter = builder.Text(query);

			if (!string.IsNullOrWhiteSpace(collection))
				filter &= builder.Eq(d => d.Collection, collection);

			// Project text score for ranking
			ProjectionDefinition<RagDocument> projection = Builders<RagDocument>.Projection
				.MetaTextScore("textScore");

			SortDefinition<RagDocument> sort = Builders<RagDocument>.Sort
				.MetaTextScore("textScore");

			List<RagDocument> documents = await _documentCollection
				.Find(filter)
				.Project<RagDocument>(projection)
				.Sort(sort)
				.Limit(topK)
				.ToListAsync();

			// Convert to SearchResult with BM25-style ranking
			List<SearchResult> results = new(documents.Count);
			for (int i = 0; i < documents.Count; i++)
			{
				results.Add(new SearchResult(
					document: documents[i],
					score: 1.0f / (i + 1), // Normalized rank score
					rank: i + 1,
					method: SearchMethod.Keyword
				));
			}

			return results;
		}
		catch (Exception ex)
		{
			// SAFETY: Keyword search failure should not crash the pipeline.
			// Fall back gracefully — vector search results will be used alone.
			Console.WriteLine($"[HybridSearch] Keyword search failed: {ex.Message}");
			return Array.Empty<SearchResult>();
		}
	}

	/// <summary>
	/// Performs vector similarity search using FAISS via the embedding service.
	/// </summary>
	private async Task<IReadOnlyList<SearchResult>> VectorSearchAsync(
		string query,
		int topK,
		string? collection)
	{
		try
		{
			if (!_embeddingService.IsReady)
			{
				Console.WriteLine("[HybridSearch] Embedding service not ready — skipping vector search.");
				return Array.Empty<SearchResult>();
			}

			float[] queryEmbedding = await _embeddingService.EmbedAsync(query);
			IReadOnlyList<SearchResult> results = await _vectorStore.SearchAsync(queryEmbedding, topK, collection);
			return results;
		}
		catch (Exception ex)
		{
			// SAFETY: Vector search failure should not crash the pipeline.
			// Fall back gracefully — keyword search results will be used alone.
			Console.WriteLine($"[HybridSearch] Vector search failed: {ex.Message}");
			return Array.Empty<SearchResult>();
		}
	}

	/// <summary>
	/// Merges vector and keyword results using Reciprocal Rank Fusion.
	/// RRF is robust because it operates on ranks rather than raw scores,
	/// eliminating the need for cross-method score normalization.
	/// </summary>
	/// <param name="vectorResults">Results from FAISS vector search.</param>
	/// <param name="keywordResults">Results from MongoDB text search.</param>
	/// <param name="vectorWeight">Weight multiplier for vector RRF scores.</param>
	/// <param name="keywordWeight">Weight multiplier for keyword RRF scores.</param>
	/// <param name="topK">Maximum results to return after fusion.</param>
	/// <returns>Fused results sorted by combined RRF score (descending).</returns>
	private static List<SearchResult> ReciprocalRankFusion(
		IReadOnlyList<SearchResult> vectorResults,
		IReadOnlyList<SearchResult> keywordResults,
		float vectorWeight,
		float keywordWeight,
		int topK)
	{
		// Map document ID → accumulated RRF score + best document reference
		Dictionary<string, (float score, RagDocument doc)> fusedScores = new();

		// Accumulate vector RRF scores
		for (int i = 0; i < vectorResults.Count; i++)
		{
			string docId = vectorResults[i].Document.Id;
			float rrfScore = vectorWeight / (RrfK + i + 1);

			if (fusedScores.TryGetValue(docId, out (float score, RagDocument doc) existing))
				fusedScores[docId] = (existing.score + rrfScore, existing.doc);
			else
				fusedScores[docId] = (rrfScore, vectorResults[i].Document);
		}

		// Accumulate keyword RRF scores
		for (int i = 0; i < keywordResults.Count; i++)
		{
			string docId = keywordResults[i].Document.Id;
			float rrfScore = keywordWeight / (RrfK + i + 1);

			if (fusedScores.TryGetValue(docId, out (float score, RagDocument doc) existing))
				fusedScores[docId] = (existing.score + rrfScore, existing.doc);
			else
				fusedScores[docId] = (rrfScore, keywordResults[i].Document);
		}

		// Sort by fused score descending, take topK
		List<SearchResult> fused = fusedScores
			.OrderByDescending(kv => kv.Value.score)
			.Take(topK)
			.Select((kv, index) => new SearchResult(
				document: kv.Value.doc,
				score: kv.Value.score,
				rank: index + 1,
				method: SearchMethod.Hybrid
			))
			.ToList();

		return fused;
	}
}
