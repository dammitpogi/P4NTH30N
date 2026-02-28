using System;

namespace P4NTHE0N.PROF3T;

public enum ModelState
{
	Unloaded,
	Loading,
	Ready,
	Busy,
	Error,
}

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
