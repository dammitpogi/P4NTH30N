using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Services;

namespace P4NTHE0N.PROF3T;

/// <summary>
/// FOUREYES-024: Forgewright auto-triage trigger service.
/// Monitors AutoBugLogger and triggers automated triage based on severity and frequency.
/// </summary>
public class ForgewrightTriggerService
{
	private readonly AutoBugLogger _bugLogger;
	private readonly ForgewrightConfig _config;

	public event Action<BugReport, TriageDecision>? OnTriageDecision;

	public ForgewrightTriggerService(AutoBugLogger bugLogger, ForgewrightConfig? config = null)
	{
		_bugLogger = bugLogger;
		_config = config ?? new ForgewrightConfig();
	}

	/// <summary>
	/// Evaluates all new bugs and makes triage decisions.
	/// </summary>
	public List<TriageDecision> EvaluateAndTriage()
	{
		List<TriageDecision> decisions = new();
		IReadOnlyList<BugReport> newBugs = _bugLogger.GetNewBugs();

		foreach (BugReport bug in newBugs.Where(b => b.TriageStatus == BugTriageStatus.New))
		{
			TriageDecision decision = MakeTriageDecision(bug);
			decisions.Add(decision);

			_bugLogger.UpdateTriageStatus(bug.Id, BugTriageStatus.Triaged);
			OnTriageDecision?.Invoke(bug, decision);

			Console.WriteLine($"[Forgewright] Triaged {bug.Id}: {decision.Action} (reason: {decision.Reason})");
		}

		return decisions;
	}

	private TriageDecision MakeTriageDecision(BugReport bug)
	{
		// Critical + frequent = immediate escalation
		if (bug.Severity == BugSeverity.Critical && bug.OccurrenceCount >= _config.CriticalEscalationThreshold)
		{
			return new TriageDecision
			{
				BugId = bug.Id,
				Action = TriageAction.Escalate,
				Reason = $"Critical bug with {bug.OccurrenceCount} occurrences",
				Priority = 1,
			};
		}

		// Critical = auto-fix attempt
		if (bug.Severity == BugSeverity.Critical)
		{
			return new TriageDecision
			{
				BugId = bug.Id,
				Action = TriageAction.AutoFix,
				Reason = "Critical severity - attempting automated fix",
				Priority = 2,
			};
		}

		// High + frequent = queue for human review
		if (bug.Severity == BugSeverity.High && bug.OccurrenceCount >= _config.HighFrequencyThreshold)
		{
			return new TriageDecision
			{
				BugId = bug.Id,
				Action = TriageAction.HumanReview,
				Reason = $"High severity bug occurring {bug.OccurrenceCount} times",
				Priority = 3,
			};
		}

		// High = auto-fix attempt
		if (bug.Severity == BugSeverity.High)
		{
			return new TriageDecision
			{
				BugId = bug.Id,
				Action = TriageAction.AutoFix,
				Reason = "High severity - attempting automated fix",
				Priority = 4,
			};
		}

		// Medium = log and monitor
		if (bug.Severity == BugSeverity.Medium)
		{
			return new TriageDecision
			{
				BugId = bug.Id,
				Action = TriageAction.Monitor,
				Reason = "Medium severity - monitoring for escalation",
				Priority = 5,
			};
		}

		// Low = log only
		return new TriageDecision
		{
			BugId = bug.Id,
			Action = TriageAction.LogOnly,
			Reason = "Low severity - logged for reference",
			Priority = 6,
		};
	}
}

public class ForgewrightConfig
{
	public int CriticalEscalationThreshold { get; set; } = 5;
	public int HighFrequencyThreshold { get; set; } = 10;
	public int AutoFixMaxAttempts { get; set; } = 3;
}

public class TriageDecision
{
	public string BugId { get; set; } = string.Empty;
	public TriageAction Action { get; set; }
	public string Reason { get; set; } = string.Empty;
	public int Priority { get; set; }
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}

public enum TriageAction
{
	LogOnly,
	Monitor,
	AutoFix,
	HumanReview,
	Escalate,
}
