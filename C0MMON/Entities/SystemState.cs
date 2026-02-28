using System;
using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// FOUREYES-018: System state snapshot for rollback recovery.
/// Captures the state of all running components at a point in time.
/// </summary>
public class SystemState
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime CapturedAt { get; set; } = DateTime.UtcNow;
	public string Version { get; set; } = string.Empty;
	public string CapturedBy { get; set; } = string.Empty;
	public SystemStateType StateType { get; set; }
	public Dictionary<string, string> ComponentVersions { get; set; } = new();
	public Dictionary<string, object> Configuration { get; set; } = new();
	public List<string> ActiveModels { get; set; } = new();
	public bool IsHealthy { get; set; }
	public string Notes { get; set; } = string.Empty;
}

public enum SystemStateType
{
	PreDeploy,
	PostDeploy,
	Manual,
	AutoCapture,
	PreRollback,
}
