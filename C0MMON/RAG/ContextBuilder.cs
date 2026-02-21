using System.Text;

namespace P4NTH30N.C0MMON.RAG;

/// <summary>
/// Assembles LLM context from RAG search results with token budget management.
/// Formats retrieved documents into structured prompts with source attribution,
/// deduplication, and graceful truncation when exceeding token limits.
/// </summary>
/// <remarks>
/// Token estimation uses a simple ~4 chars/token heuristic for English text.
/// For production LLM-specific tokenizers, replace <see cref="EstimateTokens"/>.
/// </remarks>
public sealed class ContextBuilder : IContextBuilder
{
	/// <summary>
	/// Approximate characters per token for English text (word-piece tokenizer estimate).
	/// GPT-family models average ~4 chars/token. Adjust for other tokenizers.
	/// </summary>
	private const float CharsPerToken = 4.0f;

	/// <summary>
	/// Separator between individual context documents in the assembled prompt.
	/// </summary>
	private const string DocumentSeparator = "\n---\n";

	/// <summary>
	/// Maximum content length per document before truncation (characters).
	/// Prevents a single huge document from consuming the entire token budget.
	/// </summary>
	private const int MaxDocumentChars = 2000;

	/// <inheritdoc />
	public string BuildContext(string query, IReadOnlyList<SearchResult> results, int maxTokens = 2048)
	{
		if (results.Count == 0)
			return string.Empty;

		int maxChars = (int)(maxTokens * CharsPerToken);
		StringBuilder context = new();
		HashSet<string> seenContent = new(StringComparer.OrdinalIgnoreCase);
		int currentChars = 0;

		// Header for the RAG context block
		string header = $"[Retrieved context for query: \"{Truncate(query, 100)}\"]\n\n";
		context.Append(header);
		currentChars += header.Length;

		int docIndex = 0;
		foreach (SearchResult result in results)
		{
			// Deduplication: skip documents with identical content
			string contentKey = result.Document.Content.Trim();
			if (string.IsNullOrWhiteSpace(contentKey) || !seenContent.Add(contentKey))
				continue;

			// Format the document entry with source attribution
			string entry = FormatDocumentEntry(result, ++docIndex);

			// Check if adding this entry exceeds the budget
			if (currentChars + entry.Length > maxChars)
			{
				// Try to fit a truncated version
				int remaining = maxChars - currentChars - DocumentSeparator.Length - 50;
				if (remaining > 200)
				{
					context.Append(DocumentSeparator);
					context.Append(Truncate(entry, remaining));
					context.Append("\n[truncated]");
				}
				break;
			}

			if (docIndex > 1)
				context.Append(DocumentSeparator);

			context.Append(entry);
			currentChars += entry.Length + DocumentSeparator.Length;
		}

		return context.ToString();
	}

	/// <inheritdoc />
	public string BuildPrompt(string systemPrompt, string query, IReadOnlyList<SearchResult> results, int maxContextTokens = 2048)
	{
		string ragContext = BuildContext(query, results, maxContextTokens);

		StringBuilder prompt = new();

		// System section
		if (!string.IsNullOrWhiteSpace(systemPrompt))
		{
			prompt.AppendLine("[SYSTEM]");
			prompt.AppendLine(systemPrompt);
			prompt.AppendLine();
		}

		// RAG context section (if any results)
		if (!string.IsNullOrWhiteSpace(ragContext))
		{
			prompt.AppendLine("[CONTEXT]");
			prompt.AppendLine(ragContext);
			prompt.AppendLine();
		}

		// User query section
		prompt.AppendLine("[QUERY]");
		prompt.AppendLine(query);

		return prompt.ToString();
	}

	/// <inheritdoc />
	public int EstimateTokens(string text)
	{
		if (string.IsNullOrEmpty(text))
			return 0;

		// Heuristic: ~4 characters per token for English text with word-piece tokenization.
		// This is a rough estimate. For precise counts, use the actual LLM tokenizer.
		return (int)Math.Ceiling(text.Length / CharsPerToken);
	}

	/// <summary>
	/// Formats a single search result as a numbered context entry with metadata.
	/// </summary>
	private static string FormatDocumentEntry(SearchResult result, int index)
	{
		RagDocument doc = result.Document;
		StringBuilder entry = new();

		// Header: index, source, and score
		entry.AppendLine($"[{index}] Source: {doc.Source} | Collection: {doc.Collection} | Score: {result.Score:F3} ({result.Method})");

		// Metadata tags if present
		if (doc.Metadata.Count > 0)
		{
			string tags = string.Join(", ", doc.Metadata.Select(kv => $"{kv.Key}={kv.Value}"));
			entry.AppendLine($"    Tags: {tags}");
		}

		// Content (truncated if too long)
		string content = doc.Content.Length > MaxDocumentChars ? Truncate(doc.Content, MaxDocumentChars) + " [truncated]" : doc.Content;
		entry.AppendLine($"    {content}");

		return entry.ToString();
	}

	/// <summary>
	/// Truncates a string to the specified maximum length, appending "..." if trimmed.
	/// </summary>
	private static string Truncate(string text, int maxLength)
	{
		if (string.IsNullOrEmpty(text) || text.Length <= maxLength)
			return text;

		return text[..(maxLength - 3)] + "...";
	}
}
