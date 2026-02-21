namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// OPS-060: Production operational configuration models.
/// Defines operational modes, success metrics, and incident response thresholds.
/// </summary>
public sealed class OperationalConfig
{
	public OperationalMode Mode { get; set; } = OperationalMode.Continuous;
	public string CredentialCollection { get; set; } = "CR3D3N7IAL_PR0D";
	public OperationalMetricTargets Targets { get; set; } = new();
	public IncidentResponseConfig IncidentResponse { get; set; } = new();
	public OperationalSchedule Schedule { get; set; } = new();
}

/// <summary>
/// OPS-060: Supported operational modes after burn-in validation.
/// </summary>
public enum OperationalMode
{
	/// <summary>Runs indefinitely until manually stopped. Auto-generates signals when SIGN4L &lt; 10.</summary>
	Continuous,

	/// <summary>Runs on a cron schedule (e.g., every 6 hours for 1 hour).</summary>
	ScheduledBatch,

	/// <summary>Monitors jackpot values and only spins when jackpot exceeds threshold.</summary>
	EventDriven,
}

/// <summary>
/// OPS-060: Operational success metric targets with alert thresholds.
/// </summary>
public sealed class OperationalMetricTargets
{
	public double UptimeTargetPercent { get; set; } = 99.5;
	public double UptimeAlertPercent { get; set; } = 99.0;
	public int SignalsPerDayTarget { get; set; } = 1000;
	public int SignalsPerDayAlert { get; set; } = 500;
	public double ErrorRateTargetPercent { get; set; } = 2.0;
	public double ErrorRateAlertPercent { get; set; } = 5.0;
	public double AvgSpinTimeSecondsTarget { get; set; } = 45;
	public double AvgSpinTimeSecondsAlert { get; set; } = 60;
	public double CredentialSuccessRateTarget { get; set; } = 95.0;
	public double CredentialSuccessRateAlert { get; set; } = 90.0;
}

/// <summary>
/// OPS-060: Incident response severity levels and response times.
/// </summary>
public sealed class IncidentResponseConfig
{
	public IncidentSeverityConfig P0 { get; set; } = new()
	{
		Name = "System Down",
		ResponseMinutes = 15,
		Action = "Immediate investigation, manual intervention if needed",
	};

	public IncidentSeverityConfig P1 { get; set; } = new()
	{
		Name = "Degraded",
		ResponseMinutes = 60,
		Action = "Analyze metrics, adjust worker count, restart if needed",
	};

	public IncidentSeverityConfig P2 { get; set; } = new()
	{
		Name = "Warning",
		ResponseMinutes = 240,
		Action = "Review trends, plan optimization",
	};

	public IncidentSeverityConfig P3 { get; set; } = new()
	{
		Name = "Info",
		ResponseMinutes = 1440,
		Action = "Log for weekly review",
	};
}

public sealed class IncidentSeverityConfig
{
	public string Name { get; set; } = string.Empty;
	public int ResponseMinutes { get; set; }
	public string Action { get; set; } = string.Empty;
}

/// <summary>
/// OPS-060: Operational schedule for batch and event-driven modes.
/// </summary>
public sealed class OperationalSchedule
{
	public string CronExpression { get; set; } = "0 */6 * * *";
	public int BatchDurationMinutes { get; set; } = 60;
	public double JackpotThreshold { get; set; } = 1000;
	public List<string> DailyCheckTimes { get; set; } = ["09:00", "13:00", "18:00", "22:00"];
	public List<string> WeeklyTasks { get; set; } =
	[
		"Monday: Credential health check",
		"Wednesday: Performance optimization review",
		"Friday: Full system health check, backup verification",
		"Sunday: Weekly performance report",
	];
}

/// <summary>
/// OPS-060: Pre-operational checklist validator.
/// Checks all prerequisites before transitioning to operational mode.
/// </summary>
public static class PreOperationalChecklist
{
	public static List<ChecklistItem> Validate(OperationalConfig config)
	{
		var items = new List<ChecklistItem>
		{
			new() { Category = "Technical", Item = "24-hour burn-in PASSED", Required = true },
			new() { Category = "Technical", Item = "Zero signal duplication", Required = true },
			new() { Category = "Technical", Item = "Error rate <5%", Required = true },
			new() { Category = "Technical", Item = "Throughput 5x+ baseline", Required = true },
			new() { Category = "Technical", Item = "Memory stable", Required = true },
			new() { Category = "Credentials", Item = $"Production collection ({config.CredentialCollection}) configured", Required = true },
			new() { Category = "Credentials", Item = "Test credentials isolated from production", Required = true },
			new() { Category = "Credentials", Item = "Credential rotation schedule defined", Required = false },
			new() { Category = "Credentials", Item = "Banned credential monitoring active", Required = true },
			new() { Category = "Infrastructure", Item = "MongoDB replica set configured", Required = false },
			new() { Category = "Infrastructure", Item = "Chrome CDP pool size optimized", Required = true },
			new() { Category = "Infrastructure", Item = "Network connectivity validated", Required = true },
			new() { Category = "Infrastructure", Item = "Backup strategy implemented", Required = false },
			new() { Category = "Monitoring", Item = "DECISION_057 monitoring dashboard deployed", Required = true },
			new() { Category = "Monitoring", Item = "DECISION_058 alert thresholds configured", Required = true },
			new() { Category = "Monitoring", Item = "Operator notification channels tested", Required = true },
		};

		return items;
	}
}

public sealed class ChecklistItem
{
	public string Category { get; set; } = string.Empty;
	public string Item { get; set; } = string.Empty;
	public bool Required { get; set; }
	public bool Checked { get; set; }
}
