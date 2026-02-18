namespace P4NTH30N.C0MMON.RAG;

/// <summary>
/// Contract for vector similarity search operations.
/// Stores embeddings with associated metadata and supports nearest-neighbor queries.
/// </summary>
/// <remarks>
/// Default implementation uses FAISS via a Python bridge process.
/// Vectors are persisted to local disk as FAISS index files.
/// Metadata is stored in MongoDB for durability and queryability.
/// </remarks>
public interface IVectorStore
{
	/// <summary>
	/// Adds a document embedding to the vector store with associated metadata.
	/// </summary>
	/// <param name="document">The document to store, including its embedding and metadata.</param>
	/// <returns>The unique ID assigned to the stored document.</returns>
	Task<string> AddAsync(RagDocument document);

	/// <summary>
	/// Adds multiple document embeddings in a single batch operation.
	/// </summary>
	/// <param name="documents">Collection of documents to store.</param>
	/// <returns>List of unique IDs assigned to the stored documents.</returns>
	Task<IReadOnlyList<string>> AddBatchAsync(IReadOnlyList<RagDocument> documents);

	/// <summary>
	/// Searches for the most similar documents to the given query embedding.
	/// </summary>
	/// <param name="queryEmbedding">The query vector to search against.</param>
	/// <param name="topK">Maximum number of results to return.</param>
	/// <param name="collection">Optional collection/namespace filter.</param>
	/// <returns>Ranked list of search results with similarity scores.</returns>
	Task<IReadOnlyList<SearchResult>> SearchAsync(float[] queryEmbedding, int topK = 5, string? collection = null);

	/// <summary>
	/// Deletes a document from the vector store by its ID.
	/// </summary>
	/// <param name="documentId">The unique ID of the document to remove.</param>
	/// <returns>True if the document was found and removed.</returns>
	Task<bool> DeleteAsync(string documentId);

	/// <summary>
	/// Returns the total number of vectors stored across all collections.
	/// </summary>
	Task<long> CountAsync(string? collection = null);

	/// <summary>
	/// Persists the current FAISS index to disk.
	/// Called periodically and on graceful shutdown.
	/// </summary>
	Task SaveIndexAsync();

	/// <summary>
	/// Loads the FAISS index from disk into memory.
	/// </summary>
	Task LoadIndexAsync();
}
