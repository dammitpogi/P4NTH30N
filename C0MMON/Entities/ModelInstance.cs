using System;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// FOUREYES-013: C0MMON-side model instance entity for cross-project use.
/// Mirrors PROF3T.ModelInstance for decoupling from PROF3T project.
/// </summary>
public class ModelInstance
{
	public string ModelId { get; set; } = string.Empty;
	public string Provider { get; set; } = string.Empty;
	public string EndpointUrl { get; set; } = string.Empty;
	public ModelState State { get; set; } = ModelState.Unloaded;
	public long MemoryUsageBytes { get; set; }
	public DateTime LoadedAt { get; set; }
	public DateTime LastUsed { get; set; }
	public int ActiveRequests { get; set; }
	public string Device { get; set; } = "cpu";
}

public enum ModelState
{
	Unloaded,
	Loading,
	Ready,
	Busy,
	Error,
}
