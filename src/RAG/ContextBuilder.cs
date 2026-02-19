using System.Text;

namespace P4NTH30N.RAG;

/// <summary>
/// Structured context assembly for RAG query results.
/// Builds prompts with source attribution, relevance scores, and token budget.
/// Designer rating: 95/100.
/// </summary>
public sealed class ContextBuilder
{
	private readonly ContextBuilderConfig _config;

	public ContextBuilder(ContextBuilderConfig? config = null)
	{
		_config = config ?? new ContextBuilderConfig();
	}

	/// <summary>
	/// Builds a structured context string from RAG results.
	/// Respects token budget by truncating lower-relevance results.
	/// </summary>
	public string BuildContext(IReadOnlyList<RagResult> results, string? query = null)
	{
		if (results.Count == 0)
		{
			return _config.NoResultsMessage;
		}

		StringBuilder sb = new();
		int estimatedTokens = 0;

		if (_config.IncludeHeader)
		{
			string header = $"=== RETRIEVED CONTEXT ({results.Count} results) ===\n";
			sb.Append(header);
			estimatedTokens += EstimateTokens(header);
		}

		// Sort by score descending (highest relevance first)
		List<RagResult> sorted = results.OrderByDescending(r => r.Score).ToList();

		int includedCount = 0;

		foreach (RagResult result in sorted)
		{
			string entry = FormatEntry(result, includedCount + 1);
			int entryTokens = EstimateTokens(entry);

			// Check token budget
			if (estimatedTokens + entryTokens > _config.MaxTokenBudget)
			{
				if (includedCount == 0)
				{
					// Always include at least one result, truncated
					string truncated = TruncateToTokenBudget(entry, _config.MaxTokenBudget - estimatedTokens);
					sb.Append(truncated);
					includedCount++;
				}
				break;
			}

			sb.Append(entry);
			estimatedTokens += entryTokens;
			includedCount++;
		}

		if (_config.IncludeFooter)
		{
			int omitted = results.Count - includedCount;
			if (omitted > 0)
			{
				sb.Append($"\n[{omitted} additional result(s) omitted due to token budget]\n");
			}
		}

		return sb.ToString();
	}

	/// <summary>
	/// Builds a full prompt with system instructions, context, and user query.
	/// </summary>
	public string BuildPrompt(string userQuery, IReadOnlyList<RagResult> results)
	{
		StringBuilder sb = new();

		sb.AppendLine(_config.SystemInstruction);
		sb.AppendLine();
		sb.AppendLine(BuildContext(results, userQuery));
		sb.AppendLine();
		sb.AppendLine("=== USER QUESTION ===");
		sb.AppendLine(userQuery);
		sb.AppendLine();
		sb.AppendLine("=== YOUR ANSWER ===");

		return sb.ToString();
	}

	/// <summary>
	/// Formats a single RAG result entry with source attribution.
	/// </summary>
	private string FormatEntry(RagResult result, int index)
	{
		StringBuilder sb = new();

		sb.AppendLine($"--- Result {index} (score: {result.Score:F3}) ---");
		sb.AppendLine($"Source: {result.Source}");

		if (result.Metadata != null)
		{
			List<string> metaParts = new();
			if (!string.IsNullOrEmpty(result.Metadata.Agent))
				metaParts.Add($"Agent: {result.Metadata.Agent}");
			if (!string.IsNullOrEmpty(result.Metadata.Type))
				metaParts.Add($"Type: {result.Metadata.Type}");
			if (!string.IsNullOrEmpty(result.Metadata.Platform))
				metaParts.Add($"Platform: {result.Metadata.Platform}");
			if (metaParts.Count > 0)
			{
				sb.AppendLine(string.Join(" | ", metaParts));
			}
		}

		sb.AppendLine(result.Content);
		sb.AppendLine();

		return sb.ToString();
	}

	/// <summary>
	/// Estimates token count using ~4 chars per token heuristic.
	/// </summary>
	private static int EstimateTokens(string text)
	{
		return (int)Math.Ceiling(text.Length / 4.0);
	}

	/// <summary>
	/// Truncates text to fit within a token budget.
	/// </summary>
	private static string TruncateToTokenBudget(string text, int maxTokens)
	{
		int maxChars = maxTokens * 4;
		if (text.Length <= maxChars)
			return text;
		return text[..maxChars] + "\n[TRUNCATED]\n";
	}
}

/// <summary>
/// Configuration for context building.
/// </summary>
public sealed class ContextBuilderConfig
{
	/// <summary>
	/// Maximum token budget for assembled context. Default: 2000.
	/// </summary>
	public int MaxTokenBudget { get; init; } = 2000;

	/// <summary>
	/// System instruction for RAG prompts.
	/// </summary>
	public string SystemInstruction { get; init; } =
		"You are an assistant for P4NTH30N, a casino automation platform. "
		+ "Use the following retrieved context to answer the question. "
		+ "If the context doesn't contain the answer, say so. "
		+ "Always cite your sources.";

	/// <summary>
	/// Message when no results are found.
	/// </summary>
	public string NoResultsMessage { get; init; } = "[No relevant context found in knowledge base]";

	/// <summary>
	/// Include header in context output.
	/// </summary>
	public bool IncludeHeader { get; init; } = true;

	/// <summary>
	/// Include footer with omitted count.
	/// </summary>
	public bool IncludeFooter { get; init; } = true;
}
