using System;
using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// FOUREYES-017: Metric record entity for production monitoring.
/// Stores time-series metric data points for dashboards and alerting.
/// </summary>
public class MetricRecord
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public string MetricName { get; set; } = string.Empty;
	public double Value { get; set; }
	public string Unit { get; set; } = string.Empty;
	public MetricCategory Category { get; set; }
	public Dictionary<string, string> Tags { get; set; } = new();
	public string Source { get; set; } = string.Empty;
}

public enum MetricCategory
{
	System,
	Vision,
	Automation,
	Model,
	Database,
	Network,
	Custom,
}
