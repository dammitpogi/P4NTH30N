namespace P4NTH30N.C0MMON.LLM;

/// <summary>
/// Contract for LLM inference providers. Abstracts over OpenAI API, local LM Studio,
/// or any compatible chat completion endpoint.
/// </summary>
/// <remarks>
/// FEAT-001: LLM Inference Strategy for RAG Context Assembly.
/// Bootstrap: OpenAI API for speed to market.
/// Post-revenue: Local LLM (Pleias-RAG-1B or similar) for zero recurring cost.
/// </remarks>
public interface ILlmClient : IDisposable
{
	/// <summary>
	/// Sends a chat completion request and returns the generated text.
	/// </summary>
	/// <param name="prompt">System + user prompt for the LLM.</param>
	/// <param name="maxTokens">Maximum tokens in the response.</param>
	/// <param name="temperature">Sampling temperature (0.0 = deterministic, 1.0 = creative).</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>The generated completion text.</returns>
	Task<string> CompleteAsync(
		string prompt,
		int maxTokens = 512,
		double temperature = 0.3,
		CancellationToken cancellationToken = default);

	/// <summary>
	/// Sends a chat completion request with separate system and user messages.
	/// </summary>
	/// <param name="systemPrompt">System-level instructions.</param>
	/// <param name="userMessage">User query or context.</param>
	/// <param name="maxTokens">Maximum tokens in the response.</param>
	/// <param name="temperature">Sampling temperature.</param>
	/// <param name="cancellationToken">Cancellation token.</param>
	/// <returns>The generated completion text.</returns>
	Task<string> ChatAsync(
		string systemPrompt,
		string userMessage,
		int maxTokens = 512,
		double temperature = 0.3,
		CancellationToken cancellationToken = default);

	/// <summary>
	/// Whether the LLM client is ready to accept requests.
	/// </summary>
	bool IsReady { get; }

	/// <summary>
	/// The model identifier being used (e.g., "gpt-4o-mini", "pleias-rag-1b").
	/// </summary>
	string ModelId { get; }
}
