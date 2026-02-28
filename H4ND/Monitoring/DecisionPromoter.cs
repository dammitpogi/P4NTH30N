using System.Text.RegularExpressions;

namespace P4NTHE0N.H4ND.Monitoring;

/// <summary>
/// AUTO-059: Updates decision file statuses and moves them between directories.
/// Handles: promote to Completed, add burn-in report reference, move to completed/.
/// </summary>
public sealed partial class DecisionPromoter
{
	private readonly string _decisionsRoot;
	private readonly string _completionsDir;

	public DecisionPromoter(string? decisionsRoot = null)
	{
		_decisionsRoot = decisionsRoot ?? Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "STR4TEG15T", "decisions");
		_completionsDir = Path.Combine(_decisionsRoot, "completed");
		Directory.CreateDirectory(_completionsDir);
	}

	/// <summary>
	/// Promotes a decision to Completed status.
	/// Updates the status line in the file and optionally moves to completed/ directory.
	/// Returns true if promotion succeeded.
	/// </summary>
	public bool Promote(string decisionId, string reason, bool moveFile = true)
	{
		string activeDir = Path.Combine(_decisionsRoot, "active");
		string fileName = $"DECISION_{decisionId}.md";
		string activePath = Path.Combine(activeDir, fileName);

		if (!File.Exists(activePath))
		{
			Console.WriteLine($"[DecisionPromoter] File not found: {activePath}");
			return false;
		}

		try
		{
			string content = File.ReadAllText(activePath);

			// Update status line
			content = StatusRegex().Replace(content, $"**Status**: Completed");

			// Add completion note
			string completionNote = $"\n\n---\n\n## Completion\n\n" +
				$"- **Completed At**: {DateTime.UtcNow:O}\n" +
				$"- **Reason**: {reason}\n" +
				$"- **Promoted By**: BurnInCompletionAnalyzer (AUTO-059)\n";
			content += completionNote;

			if (moveFile)
			{
				string completedPath = Path.Combine(_completionsDir, fileName);
				File.WriteAllText(completedPath, content);
				File.Delete(activePath);
				Console.WriteLine($"[DecisionPromoter] {decisionId}: Promoted + moved to completed/");
			}
			else
			{
				File.WriteAllText(activePath, content);
				Console.WriteLine($"[DecisionPromoter] {decisionId}: Status updated to Completed (in-place)");
			}

			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[DecisionPromoter] Failed to promote {decisionId}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Adds a failure note to a decision file without changing its status.
	/// </summary>
	public bool AddFailureNote(string decisionId, string failureReason)
	{
		string activeDir = Path.Combine(_decisionsRoot, "active");
		string fileName = $"DECISION_{decisionId}.md";
		string activePath = Path.Combine(activeDir, fileName);

		if (!File.Exists(activePath))
		{
			Console.WriteLine($"[DecisionPromoter] File not found for failure note: {activePath}");
			return false;
		}

		try
		{
			string failureNote = $"\n\n---\n\n## Burn-In Failure ({DateTime.UtcNow:yyyy-MM-dd})\n\n" +
				$"- **Failed At**: {DateTime.UtcNow:O}\n" +
				$"- **Reason**: {failureReason}\n" +
				$"- **Status**: Remains in active/ — pending retry\n";

			File.AppendAllText(activePath, failureNote);
			Console.WriteLine($"[DecisionPromoter] {decisionId}: Failure note added");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[DecisionPromoter] Failed to add failure note to {decisionId}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// AUTO-059: Executes the full promotion workflow on burn-in PASS.
	/// Promotes DECISION_047, DECISION_055, DECISION_056.
	/// </summary>
	public PromotionResult PromoteOnPass(BurnInCompletionReport report)
	{
		var result = new PromotionResult { SessionId = report.SessionId, OverallResult = report.Result };

		if (report.Result != "PASS")
		{
			// On FAIL: add failure notes
			AddFailureNote("047", report.HaltReason ?? "Burn-in did not pass validation criteria");
			result.Actions.Add("DECISION_047: Failure note added (remains in active/)");
			return result;
		}

		// Promote decisions
		string reason = $"24hr burn-in passed — session {report.SessionId}";

		if (Promote("047", reason))
			result.Actions.Add("DECISION_047: Promoted to Completed");
		else
			result.Actions.Add("DECISION_047: Promotion failed (file may not exist)");

		if (Promote("055", reason))
			result.Actions.Add("DECISION_055: Promoted to Completed");
		else
			result.Actions.Add("DECISION_055: Promotion failed (file may not exist)");

		if (Promote("056", reason, moveFile: false))
			result.Actions.Add("DECISION_056: Status updated to Completed");
		else
			result.Actions.Add("DECISION_056: Update failed (may already be completed)");

		result.CompletionReportPath = $"logs/burnin-completion-{report.SessionId}.json";
		return result;
	}

	[GeneratedRegex(@"\*\*Status\*\*:\s*\w+")]
	private static partial Regex StatusRegex();
}

public sealed class PromotionResult
{
	public string SessionId { get; set; } = string.Empty;
	public string OverallResult { get; set; } = "Unknown";
	public List<string> Actions { get; set; } = [];
	public string? CompletionReportPath { get; set; }

	public override string ToString()
	{
		var sb = new System.Text.StringBuilder();
		sb.AppendLine($"[DecisionPromoter] Result: {OverallResult}");
		foreach (var action in Actions)
			sb.AppendLine($"  - {action}");
		if (CompletionReportPath != null)
			sb.AppendLine($"  Report: {CompletionReportPath}");
		return sb.ToString();
	}
}
