using System;
using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// FOUREYES-015: Vision command entity for H4ND worker integration.
/// Represents a command issued by the vision system to H4ND for execution.
/// </summary>
public class VisionCommand
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public VisionCommandType CommandType { get; set; }
	public string TargetUsername { get; set; } = string.Empty;
	public string TargetGame { get; set; } = string.Empty;
	public string TargetHouse { get; set; } = string.Empty;
	public double Confidence { get; set; }
	public string Reason { get; set; } = string.Empty;
	public VisionCommandStatus Status { get; set; } = VisionCommandStatus.Pending;
	public Dictionary<string, object> Parameters { get; set; } = new();
	public DateTime? ExecutedAt { get; set; }
	public string? ErrorMessage { get; set; }
}

public enum VisionCommandType
{
	Spin,
	Stop,
	SwitchGame,
	AdjustBet,
	CaptureScreenshot,
	Escalate,
	Noop,
}

public enum VisionCommandStatus
{
	Pending,
	InProgress,
	Completed,
	Failed,
	Expired,
}
