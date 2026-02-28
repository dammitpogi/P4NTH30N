namespace P4NTHE0N.C0MMON.RAG;

/// <summary>
/// Contract for generating vector embeddings from text.
/// Embeddings are dense float arrays that capture semantic meaning,
/// enabling similarity search across jackpot patterns and signal history.
/// </summary>
/// <remarks>
/// Default implementation uses a local ONNX model (all-MiniLM-L6-v2)
/// to avoid API costs. The model produces 384-dimensional embeddings.
/// </remarks>
public interface IEmbeddingService
{
	/// <summary>
	/// Generates a vector embedding for a single text input.
	/// </summary>
	/// <param name="text">The text to embed (e.g., signal description, jackpot pattern).</param>
	/// <returns>A float array representing the semantic embedding (384 dimensions for MiniLM).</returns>
	/// <exception cref="ArgumentException">When text is null or empty.</exception>
	/// <exception cref="InvalidOperationException">When the embedding model is not loaded.</exception>
	Task<float[]> EmbedAsync(string text);

	/// <summary>
	/// Generates vector embeddings for multiple texts in a single batch.
	/// More efficient than calling <see cref="EmbedAsync"/> in a loop.
	/// </summary>
	/// <param name="texts">Collection of texts to embed.</param>
	/// <returns>Array of float arrays, one embedding per input text.</returns>
	Task<float[][]> EmbedBatchAsync(IReadOnlyList<string> texts);

	/// <summary>
	/// Returns the dimensionality of the embedding vectors produced by this service.
	/// For all-MiniLM-L6-v2, this is 384.
	/// </summary>
	int Dimensions { get; }

	/// <summary>
	/// Returns true if the embedding model is loaded and ready.
	/// </summary>
	bool IsReady { get; }

	/// <summary>
	/// Loads the embedding model into memory. Must be called before generating embeddings.
	/// </summary>
	Task InitializeAsync();
}
