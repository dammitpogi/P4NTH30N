using System;

namespace P4NTH30N.C0MMON.Entities;

/// <summary>
/// FOUREYES-010: Cerberus Protocol healing action entity.
/// Records an OBS self-healing action taken by the system.
/// </summary>
public class HealingAction
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public HealingActionType ActionType { get; set; }
	public string TargetComponent { get; set; } = string.Empty;
	public string Reason { get; set; } = string.Empty;
	public bool Success { get; set; }
	public string ErrorMessage { get; set; } = string.Empty;
	public int AttemptNumber { get; set; }
	public long DurationMs { get; set; }
}

public enum HealingActionType
{
	Reconnect,
	RestartStream,
	SwitchSource,
	ResetEncoder,
	RestartOBS,
	Escalate,
}
