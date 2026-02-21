namespace P4NTH30N.H4ND.Monitoring.Models;

/// <summary>
/// MON-057: Real-time burn-in status model served via HTTP dashboard.
/// Contains current progress, signal stats, worker health, errors, and platform reachability.
/// </summary>
public sealed class BurnInStatus
{
	public string SessionId { get; set; } = string.Empty;
	public string Status { get; set; } = "Unknown"; // Running, Paused, Halted, Completed
	public BurnInProgress Progress { get; set; } = new();
	public BurnInSignalStats Signals { get; set; } = new();
	public BurnInWorkerStats Workers { get; set; } = new();
	public BurnInErrorStats Errors { get; set; } = new();
	public BurnInChromeStats Chrome { get; set; } = new();
	public Dictionary<string, BurnInPlatformStats> Platforms { get; set; } = new();
	public double MemoryMB { get; set; }
	public double MemoryGrowthMB { get; set; }
	public DateTime CollectedAt { get; set; } = DateTime.UtcNow;
}

public sealed class BurnInProgress
{
	public double ElapsedHours { get; set; }
	public double TotalHours { get; set; } = 24;
	public double PercentComplete { get; set; }
	public DateTime? Eta { get; set; }
	public double ThroughputPerHour { get; set; }
}

public sealed class BurnInSignalStats
{
	public long Generated { get; set; }
	public long Processed { get; set; }
	public int Pending { get; set; }
	public long Claimed { get; set; }
	public long Acknowledged { get; set; }
	public double ThroughputPerHour { get; set; }
}

public sealed class BurnInWorkerStats
{
	public int Configured { get; set; }
	public int Active { get; set; }
	public List<string> Status { get; set; } = [];
}

public sealed class BurnInErrorStats
{
	public long Total { get; set; }
	public double Rate { get; set; }
	public List<BurnInRecentError> Recent { get; set; } = [];
}

public sealed class BurnInRecentError
{
	public DateTime Time { get; set; }
	public string Type { get; set; } = string.Empty;
	public bool Recovered { get; set; }
}

public sealed class BurnInChromeStats
{
	public string Status { get; set; } = "Unknown";
	public int? Pid { get; set; }
	public long RestartCount { get; set; }
}

public sealed class BurnInPlatformStats
{
	public bool Reachable { get; set; }
	public double AvgResponseMs { get; set; }
}
