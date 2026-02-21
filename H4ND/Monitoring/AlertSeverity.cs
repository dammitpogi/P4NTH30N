namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// MON-058: Three-tier alert severity for burn-in monitoring.
/// </summary>
public enum AlertSeverity
{
	/// <summary>Log only, no action needed.</summary>
	Info,

	/// <summary>Notify operator, continue burn-in.</summary>
	Warn,

	/// <summary>Halt burn-in immediately, alert operator.</summary>
	Critical,
}

/// <summary>
/// MON-058: A burn-in alert with severity, category, message, and timestamp.
/// </summary>
public sealed class BurnInAlert
{
	public AlertSeverity Severity { get; init; }
	public string Category { get; init; } = string.Empty;
	public string Message { get; init; } = string.Empty;
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;
	public double? MetricValue { get; init; }
	public double? ThresholdValue { get; init; }
	public bool RequiresHalt => Severity == AlertSeverity.Critical;

	public override string ToString() =>
		$"[{Severity}] {Category}: {Message}" +
		(MetricValue.HasValue ? $" (value={MetricValue:F2}, threshold={ThresholdValue:F2})" : "");

	public static BurnInAlert Info(string category, string message) =>
		new() { Severity = AlertSeverity.Info, Category = category, Message = message };

	public static BurnInAlert Warn(string category, string message, double? value = null, double? threshold = null) =>
		new() { Severity = AlertSeverity.Warn, Category = category, Message = message, MetricValue = value, ThresholdValue = threshold };

	public static BurnInAlert Critical(string category, string message, double? value = null, double? threshold = null) =>
		new() { Severity = AlertSeverity.Critical, Category = category, Message = message, MetricValue = value, ThresholdValue = threshold };
}
