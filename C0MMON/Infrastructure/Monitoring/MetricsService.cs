using System.Collections.Concurrent;
using System.Diagnostics;

namespace P4NTH30N.C0MMON.Infrastructure.Monitoring;

/// <summary>
/// Lightweight metrics collection for KPIs: counters, gauges, histograms.
/// No external dependencies — stores in-memory with periodic console/log output.
/// </summary>
/// <remarks>
/// INFRA-004: Monitoring and Observability Stack.
/// Tracks signal processing time, jackpot query latency, error rates, etc.
/// </remarks>
public sealed class MetricsService
{
	private readonly ConcurrentDictionary<string, long> _counters = new();
	private readonly ConcurrentDictionary<string, double> _gauges = new();
	private readonly ConcurrentDictionary<string, HistogramBucket> _histograms = new();

	/// <summary>
	/// Increments a counter by the specified amount.
	/// </summary>
	public void IncrementCounter(string name, long amount = 1)
	{
		_counters.AddOrUpdate(name, amount, (_, existing) => existing + amount);
	}

	/// <summary>
	/// Sets a gauge to a specific value.
	/// </summary>
	public void SetGauge(string name, double value)
	{
		_gauges[name] = value;
	}

	/// <summary>
	/// Records a value in a histogram (for latency tracking, etc.).
	/// </summary>
	public void RecordHistogram(string name, double value)
	{
		_histograms.AddOrUpdate(name,
			_ =>
			{
				HistogramBucket bucket = new();
				bucket.Record(value);
				return bucket;
			},
			(_, existing) =>
			{
				existing.Record(value);
				return existing;
			});
	}

	/// <summary>
	/// Times an action and records the elapsed milliseconds in a histogram.
	/// </summary>
	public T Time<T>(string name, Func<T> action)
	{
		Stopwatch sw = Stopwatch.StartNew();
		T result = action();
		sw.Stop();
		RecordHistogram(name, sw.ElapsedMilliseconds);
		return result;
	}

	/// <summary>
	/// Times an async action and records the elapsed milliseconds.
	/// </summary>
	public async Task<T> TimeAsync<T>(string name, Func<Task<T>> action)
	{
		Stopwatch sw = Stopwatch.StartNew();
		T result = await action();
		sw.Stop();
		RecordHistogram(name, sw.ElapsedMilliseconds);
		return result;
	}

	/// <summary>
	/// Gets the current value of a counter.
	/// </summary>
	public long GetCounter(string name) => _counters.GetValueOrDefault(name, 0);

	/// <summary>
	/// Gets the current value of a gauge.
	/// </summary>
	public double GetGauge(string name) => _gauges.GetValueOrDefault(name, 0);

	/// <summary>
	/// Gets histogram statistics for a metric.
	/// </summary>
	public HistogramStats? GetHistogramStats(string name)
	{
		if (_histograms.TryGetValue(name, out HistogramBucket? bucket))
			return bucket.GetStats();
		return null;
	}

	/// <summary>
	/// Returns a snapshot of all metrics.
	/// </summary>
	public MetricsSnapshot GetSnapshot()
	{
		return new MetricsSnapshot
		{
			Counters = new Dictionary<string, long>(_counters),
			Gauges = new Dictionary<string, double>(_gauges),
			Histograms = _histograms.ToDictionary(kv => kv.Key, kv => kv.Value.GetStats()),
			Timestamp = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Dumps all metrics to console.
	/// </summary>
	public void DumpToConsole()
	{
		MetricsSnapshot snapshot = GetSnapshot();
		Console.WriteLine($"\n[Metrics] Snapshot at {snapshot.Timestamp:HH:mm:ss}");

		foreach (KeyValuePair<string, long> kv in snapshot.Counters)
			Console.WriteLine($"  [Counter] {kv.Key} = {kv.Value}");

		foreach (KeyValuePair<string, double> kv in snapshot.Gauges)
			Console.WriteLine($"  [Gauge] {kv.Key} = {kv.Value:F2}");

		foreach (KeyValuePair<string, HistogramStats> kv in snapshot.Histograms)
			Console.WriteLine($"  [Histogram] {kv.Key} = avg:{kv.Value.Average:F1}ms p50:{kv.Value.P50:F1}ms p99:{kv.Value.P99:F1}ms (n={kv.Value.Count})");
	}
}

/// <summary>
/// In-memory histogram bucket for tracking value distributions.
/// </summary>
public sealed class HistogramBucket
{
	private readonly List<double> _values = new();
	private readonly object _lock = new();

	public void Record(double value)
	{
		lock (_lock)
		{
			_values.Add(value);
			// Keep last 10000 values to prevent unbounded growth
			if (_values.Count > 10000)
				_values.RemoveRange(0, _values.Count - 10000);
		}
	}

	public HistogramStats GetStats()
	{
		lock (_lock)
		{
			if (_values.Count == 0)
				return new HistogramStats();

			List<double> sorted = _values.OrderBy(v => v).ToList();
			return new HistogramStats
			{
				Count = sorted.Count,
				Min = sorted[0],
				Max = sorted[^1],
				Average = sorted.Average(),
				P50 = Percentile(sorted, 0.50),
				P95 = Percentile(sorted, 0.95),
				P99 = Percentile(sorted, 0.99),
			};
		}
	}

	private static double Percentile(List<double> sorted, double p)
	{
		int index = (int)Math.Ceiling(p * sorted.Count) - 1;
		return sorted[Math.Max(0, Math.Min(index, sorted.Count - 1))];
	}
}

/// <summary>
/// Histogram statistics summary.
/// </summary>
public sealed class HistogramStats
{
	public int Count { get; init; }
	public double Min { get; init; }
	public double Max { get; init; }
	public double Average { get; init; }
	public double P50 { get; init; }
	public double P95 { get; init; }
	public double P99 { get; init; }
}

/// <summary>
/// Point-in-time snapshot of all metrics.
/// </summary>
public sealed class MetricsSnapshot
{
	public Dictionary<string, long> Counters { get; init; } = new();
	public Dictionary<string, double> Gauges { get; init; } = new();
	public Dictionary<string, HistogramStats> Histograms { get; init; } = new();
	public DateTime Timestamp { get; init; }
}
