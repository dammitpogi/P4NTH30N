namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// MON-058: Configurable alert thresholds for burn-in monitoring.
/// Bound from appsettings.json P4NTH30N:H4ND:BurnInAlerts section.
/// </summary>
public sealed class BurnInAlertConfig
{
	// WARN thresholds
	public double ErrorRateWarnThreshold { get; set; } = 0.05;
	public int ErrorRateWarnConsecutiveChecks { get; set; } = 3;
	public double MemoryGrowthWarnMBPerHour { get; set; } = 50;
	public int ChromeRestartWarnCount { get; set; } = 2;
	public double PlatformResponseWarnMs { get; set; } = 500;
	public int SignalBacklogWarnCount { get; set; } = 20;

	// CRITICAL thresholds
	public double ErrorRateCriticalThreshold { get; set; } = 0.10;
	public int MemoryCriticalThresholdMB { get; set; } = 500;
	public int ChromeRestartCriticalCount { get; set; } = 5;

	// Notification channels
	public List<string> NotificationChannels { get; set; } = ["Console", "WebSocket", "File"];

	// Halt behavior
	public bool HaltOnDuplication { get; set; } = true;
	public bool HaltOnWorkerDeadlock { get; set; } = true;
	public int WorkerDeadlockMinutes { get; set; } = 10;
}
