using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-017: Contract for production metrics collection and querying.
/// </summary>
public interface IMetrics
{
	/// <summary>
	/// Records a metric data point.
	/// </summary>
	Task RecordAsync(string metricName, double value, MetricCategory category, string unit = "", Dictionary<string, string>? tags = null, CancellationToken cancellationToken = default);

	/// <summary>
	/// Queries metrics by name within a time window.
	/// </summary>
	Task<IReadOnlyList<MetricRecord>> QueryAsync(string metricName, TimeSpan window, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets the latest value for a metric.
	/// </summary>
	Task<MetricRecord?> GetLatestAsync(string metricName, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets all metric names being tracked.
	/// </summary>
	IReadOnlyList<string> GetMetricNames();
}
