using System;
using System.Collections.Generic;

namespace P4NTH30N.C0MMON.Entities;

/// <summary>
/// FOUREYES-009: Shadow Gauntlet validation result.
/// Records the outcome of a shadow test comparing candidate vs production model.
/// </summary>
public class ShadowValidationResult
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public string TaskName { get; set; } = string.Empty;
	public string ProductionModelId { get; set; } = string.Empty;
	public string CandidateModelId { get; set; } = string.Empty;
	public bool IsComplete { get; set; }
	public bool CanPromote { get; set; }
	public double CandidateAccuracy { get; set; }
	public double ProductionAccuracy { get; set; }
	public double CandidateLatencyMs { get; set; }
	public double ProductionLatencyMs { get; set; }
	public int TotalInferences { get; set; }
	public int RequiredInferences { get; set; }
	public DateTime StartedAt { get; set; }
	public DateTime? CompletedAt { get; set; }
	public ValidationVerdict Verdict { get; set; } = ValidationVerdict.Pending;
	public List<string> Notes { get; set; } = new();
}

public enum ValidationVerdict
{
	Pending,
	Promoted,
	Rejected,
	InsufficientData,
	TimedOut,
}
