namespace P4NTHE0N.C0MMON.RAG;

/// <summary>
/// Represents a single result from a vector similarity search.
/// Contains the matched document, similarity score, and ranking metadata.
/// </summary>
public sealed class SearchResult
{
	/// <summary>
	/// The matched document from the vector store.
	/// </summary>
	public RagDocument Document { get; init; }

	/// <summary>
	/// Similarity score between the query and this document.
	/// Range depends on the metric: cosine similarity [0,1], L2 distance [0,∞).
	/// Higher is better for cosine, lower is better for L2.
	/// </summary>
	public float Score { get; init; }

	/// <summary>
	/// Rank position in the result set (1-indexed).
	/// </summary>
	public int Rank { get; init; }

	/// <summary>
	/// The search method that produced this result.
	/// Used in hybrid search to track which pipeline contributed.
	/// </summary>
	public SearchMethod Method { get; init; } = SearchMethod.Vector;

	/// <summary>
	/// Constructs a SearchResult with the required document and score.
	/// </summary>
	public SearchResult(RagDocument document, float score, int rank = 0, SearchMethod method = SearchMethod.Vector)
	{
		Document = document ?? throw new ArgumentNullException(nameof(document));
		Score = score;
		Rank = rank;
		Method = method;
	}
}

/// <summary>
/// Identifies which search method produced a result.
/// Used for tracking and reciprocal rank fusion in hybrid search.
/// </summary>
public enum SearchMethod
{
	/// <summary>
	/// Result from FAISS vector similarity search.
	/// </summary>
	Vector,

	/// <summary>
	/// Result from MongoDB text/keyword (BM25-style) search.
	/// </summary>
	Keyword,

	/// <summary>
	/// Result from hybrid fusion of vector + keyword results.
	/// </summary>
	Hybrid,
}
