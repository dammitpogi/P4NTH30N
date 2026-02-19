using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace P4NTH30N.C0MMON.Services.BugHandling;

/// <summary>
/// FOUREYES-024-B: Human triage workflow for bug handling.
/// Manages the lifecycle of bug reports through human review stages.
/// </summary>
public class TriageWorkflow {
	private readonly ConcurrentDictionary<string, TriageItem> _queue = new();

	/// <summary>
	/// Adds a bug report to the triage queue.
	/// </summary>
	public TriageItem Enqueue(BugReport bug, string assignedTo = "") {
		TriageItem item = new() {
			BugReport = bug,
			AssignedTo = assignedTo,
			Stage = TriageStage.Queued,
			QueuedAt = DateTime.UtcNow,
		};

		_queue[bug.Id] = item;
		Console.WriteLine($"[TriageWorkflow] Queued bug {bug.Id} ({bug.Severity}): {bug.Message}");
		return item;
	}

	/// <summary>
	/// Assigns a triage item to a human reviewer.
	/// </summary>
	public bool Assign(string bugId, string assignee) {
		if (!_queue.TryGetValue(bugId, out TriageItem? item))
			return false;

		item.AssignedTo = assignee;
		item.Stage = TriageStage.Assigned;
		item.AssignedAt = DateTime.UtcNow;
		Console.WriteLine($"[TriageWorkflow] Bug {bugId} assigned to {assignee}");
		return true;
	}

	/// <summary>
	/// Starts review of a triage item.
	/// </summary>
	public bool StartReview(string bugId) {
		if (!_queue.TryGetValue(bugId, out TriageItem? item))
			return false;

		item.Stage = TriageStage.InReview;
		item.ReviewStartedAt = DateTime.UtcNow;
		return true;
	}

	/// <summary>
	/// Completes review with a resolution.
	/// </summary>
	public bool CompleteReview(string bugId, TriageResolution resolution, string notes = "") {
		if (!_queue.TryGetValue(bugId, out TriageItem? item))
			return false;

		item.Stage = TriageStage.Resolved;
		item.Resolution = resolution;
		item.ResolutionNotes = notes;
		item.ResolvedAt = DateTime.UtcNow;
		Console.WriteLine($"[TriageWorkflow] Bug {bugId} resolved: {resolution} - {notes}");
		return true;
	}

	/// <summary>
	/// Gets items at a specific stage.
	/// </summary>
	public IReadOnlyList<TriageItem> GetByStage(TriageStage stage) {
		return _queue.Values.Where(i => i.Stage == stage)
			.OrderByDescending(i => i.BugReport.Severity)
			.ThenBy(i => i.QueuedAt)
			.ToList();
	}

	/// <summary>
	/// Gets items assigned to a specific person.
	/// </summary>
	public IReadOnlyList<TriageItem> GetByAssignee(string assignee) {
		return _queue.Values.Where(i => i.AssignedTo == assignee && i.Stage != TriageStage.Resolved)
			.OrderByDescending(i => i.BugReport.Severity)
			.ToList();
	}

	/// <summary>
	/// Gets queue summary statistics.
	/// </summary>
	public TriageQueueStats GetStats() {
		List<TriageItem> all = _queue.Values.ToList();
		return new TriageQueueStats {
			TotalItems = all.Count,
			Queued = all.Count(i => i.Stage == TriageStage.Queued),
			Assigned = all.Count(i => i.Stage == TriageStage.Assigned),
			InReview = all.Count(i => i.Stage == TriageStage.InReview),
			Resolved = all.Count(i => i.Stage == TriageStage.Resolved),
			CriticalPending = all.Count(i => i.BugReport.Severity == BugSeverity.Critical && i.Stage != TriageStage.Resolved),
			HighPending = all.Count(i => i.BugReport.Severity == BugSeverity.High && i.Stage != TriageStage.Resolved),
		};
	}
}

public class TriageItem {
	public BugReport BugReport { get; set; } = new();
	public string AssignedTo { get; set; } = string.Empty;
	public TriageStage Stage { get; set; }
	public TriageResolution Resolution { get; set; }
	public string ResolutionNotes { get; set; } = string.Empty;
	public DateTime QueuedAt { get; set; }
	public DateTime? AssignedAt { get; set; }
	public DateTime? ReviewStartedAt { get; set; }
	public DateTime? ResolvedAt { get; set; }
}

public enum TriageStage {
	Queued,
	Assigned,
	InReview,
	Resolved,
}

public enum TriageResolution {
	None,
	Fixed,
	WontFix,
	Duplicate,
	CannotReproduce,
	DeferredToNextRelease,
	Workaround,
}

public class TriageQueueStats {
	public int TotalItems { get; set; }
	public int Queued { get; set; }
	public int Assigned { get; set; }
	public int InReview { get; set; }
	public int Resolved { get; set; }
	public int CriticalPending { get; set; }
	public int HighPending { get; set; }
}
