namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// ARCH-055-006: Configuration POCO for burn-in validation mode.
/// Bound from appsettings.json P4NTHE0N:H4ND:BurnIn section.
/// </summary>
public sealed class BurnInConfig
{
	/// <summary>
	/// Total duration for burn-in test in hours. Default: 24.
	/// </summary>
	public double DurationHours { get; set; } = 24;

	/// <summary>
	/// Interval in seconds between metrics collection snapshots. Default: 60.
	/// </summary>
	public int MetricsIntervalSeconds { get; set; } = 60;

	/// <summary>
	/// If true, auto-generates signals when SIGN4L is empty. Default: true.
	/// </summary>
	public bool AutoGenerateSignals { get; set; } = true;

	/// <summary>
	/// Number of signals to auto-generate initially. Default: 50.
	/// </summary>
	public int AutoGenerateCount { get; set; } = 50;

	/// <summary>
	/// When pending signal count drops below this, auto-refill. Default: 5.
	/// </summary>
	public int RefillThreshold { get; set; } = 5;

	/// <summary>
	/// Number of signals to generate during refill. Default: 20.
	/// </summary>
	public int RefillCount { get; set; } = 20;

	/// <summary>
	/// Halt burn-in immediately if signal duplication is detected. Default: true.
	/// </summary>
	public bool HaltOnDuplication { get; set; } = true;

	/// <summary>
	/// Halt burn-in if error rate exceeds this percentage. Default: 10.
	/// Requires 3 consecutive checks above threshold.
	/// </summary>
	public double HaltOnErrorRatePercent { get; set; } = 10;

	/// <summary>
	/// Warn (but don't halt) if memory growth exceeds this many MB. Default: 100.
	/// </summary>
	public int WarnOnMemoryGrowthMB { get; set; } = 100;
}
