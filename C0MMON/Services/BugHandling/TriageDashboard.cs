using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace P4NTHE0N.C0MMON.Services.BugHandling;

/// <summary>
/// FOUREYES-024-B: Triage dashboard for human review.
/// Provides formatted views of the triage queue for operators.
/// </summary>
public class TriageDashboard
{
	private readonly TriageWorkflow _workflow;
	private readonly AutoBugLogger _bugLogger;

	public TriageDashboard(TriageWorkflow workflow, AutoBugLogger bugLogger)
	{
		_workflow = workflow;
		_bugLogger = bugLogger;
	}

	/// <summary>
	/// Gets a formatted summary of the triage queue.
	/// </summary>
	public string GetQueueSummary()
	{
		TriageQueueStats stats = _workflow.GetStats();
		StringBuilder sb = new();

		sb.AppendLine("═══ TRIAGE DASHBOARD ═══");
		sb.AppendLine($"  Total: {stats.TotalItems} | Queued: {stats.Queued} | Assigned: {stats.Assigned} | In Review: {stats.InReview} | Resolved: {stats.Resolved}");
		sb.AppendLine($"  Critical Pending: {stats.CriticalPending} | High Pending: {stats.HighPending}");
		sb.AppendLine();

		IReadOnlyList<TriageItem> queued = _workflow.GetByStage(TriageStage.Queued);
		if (queued.Count > 0)
		{
			sb.AppendLine("── QUEUED (Awaiting Assignment) ──");
			foreach (TriageItem item in queued.Take(10))
			{
				sb.AppendLine(
					$"  [{item.BugReport.Severity}] {item.BugReport.Id}: {item.BugReport.ExceptionType} in {item.BugReport.Component} (x{item.BugReport.OccurrenceCount})"
				);
			}
			sb.AppendLine();
		}

		IReadOnlyList<TriageItem> inReview = _workflow.GetByStage(TriageStage.InReview);
		if (inReview.Count > 0)
		{
			sb.AppendLine("── IN REVIEW ──");
			foreach (TriageItem item in inReview)
			{
				TimeSpan elapsed = DateTime.UtcNow - (item.ReviewStartedAt ?? DateTime.UtcNow);
				sb.AppendLine($"  [{item.BugReport.Severity}] {item.BugReport.Id}: {item.AssignedTo} reviewing ({elapsed.TotalMinutes:F0}m)");
			}
			sb.AppendLine();
		}

		return sb.ToString();
	}

	/// <summary>
	/// Gets top bugs by severity and frequency for prioritization.
	/// </summary>
	public IReadOnlyList<BugReport> GetTopPriorityBugs(int count = 10)
	{
		return _bugLogger.GetAllKnownBugs().Where(b => b.TriageStatus == BugTriageStatus.New || b.TriageStatus == BugTriageStatus.Triaged).Take(count).ToList();
	}
}
