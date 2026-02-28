namespace P4NTHE0N.C0MMON.RAG;

/// <summary>
/// Contract for assembling LLM context from RAG search results.
/// Builds structured prompts by combining retrieved documents with
/// system instructions, user queries, and formatting constraints.
/// </summary>
/// <remarks>
/// The context builder is the bridge between the RAG pipeline and the LLM inference layer.
/// It manages token budgets, deduplication, and source attribution.
/// </remarks>
public interface IContextBuilder
{
	/// <summary>
	/// Builds an LLM context string from search results and a user query.
	/// Respects the token budget by truncating or omitting lower-ranked results.
	/// </summary>
	/// <param name="query">The original user/system query.</param>
	/// <param name="results">Ranked search results from hybrid search.</param>
	/// <param name="maxTokens">Maximum token budget for the assembled context.</param>
	/// <returns>A formatted context string ready for LLM prompt injection.</returns>
	string BuildContext(string query, IReadOnlyList<SearchResult> results, int maxTokens = 2048);

	/// <summary>
	/// Builds a complete LLM prompt with system instructions, RAG context, and user query.
	/// </summary>
	/// <param name="systemPrompt">Base system instructions for the LLM.</param>
	/// <param name="query">The user/system query.</param>
	/// <param name="results">Ranked search results from hybrid search.</param>
	/// <param name="maxContextTokens">Token budget for the RAG context portion.</param>
	/// <returns>A complete prompt ready for LLM inference.</returns>
	string BuildPrompt(string systemPrompt, string query, IReadOnlyList<SearchResult> results, int maxContextTokens = 2048);

	/// <summary>
	/// Estimates the token count of a string using a simple tokenizer approximation.
	/// Uses word-piece estimation: ~4 characters per token for English text.
	/// </summary>
	/// <param name="text">The text to estimate tokens for.</param>
	/// <returns>Estimated token count.</returns>
	int EstimateTokens(string text);
}
