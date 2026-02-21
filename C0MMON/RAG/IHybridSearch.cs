namespace P4NTH30N.C0MMON.RAG;

/// <summary>
/// Contract for hybrid search combining vector similarity (FAISS) with keyword matching (BM25).
/// Uses reciprocal rank fusion to merge results from both pipelines.
/// </summary>
/// <remarks>
/// Hybrid search solves the "grand jackpot" vs "grand win" problem:
/// - Vector search captures semantic similarity (meaning)
/// - Keyword search captures exact term matches (precision)
/// - Reciprocal rank fusion balances both signals into a single ranked list
/// </remarks>
public interface IHybridSearch
{
	/// <summary>
	/// Performs a hybrid search combining vector similarity and keyword matching.
	/// </summary>
	/// <param name="query">Natural language query text.</param>
	/// <param name="topK">Maximum number of results to return after fusion.</param>
	/// <param name="collection">Optional collection/namespace filter.</param>
	/// <param name="vectorWeight">Weight for vector results in fusion (0.0–1.0). Default 0.6.</param>
	/// <returns>Fused and re-ranked search results.</returns>
	Task<IReadOnlyList<SearchResult>> SearchAsync(string query, int topK = 5, string? collection = null, float vectorWeight = 0.6f);

	/// <summary>
	/// Performs keyword-only search using MongoDB text indexes.
	/// Falls back to this when embedding service is unavailable.
	/// </summary>
	/// <param name="query">Keyword search query.</param>
	/// <param name="topK">Maximum number of results.</param>
	/// <param name="collection">Optional collection filter.</param>
	/// <returns>Keyword-matched results ranked by BM25 score.</returns>
	Task<IReadOnlyList<SearchResult>> KeywordSearchAsync(string query, int topK = 5, string? collection = null);
}
