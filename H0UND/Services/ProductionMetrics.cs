using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.H0UND.Services;

/// <summary>
/// FOUREYES-017: Production metrics collection service.
/// In-memory metric storage with time-windowed queries for dashboards.
/// </summary>
public class ProductionMetrics : IMetrics
{
	private readonly ConcurrentDictionary<string, ConcurrentQueue<MetricRecord>> _metrics = new();
	private readonly int _maxRecordsPerMetric;

	public ProductionMetrics(int maxRecordsPerMetric = 10_000)
	{
		_maxRecordsPerMetric = maxRecordsPerMetric;
	}

	public Task RecordAsync(
		string metricName,
		double value,
		MetricCategory category,
		string unit = "",
		Dictionary<string, string>? tags = null,
		CancellationToken cancellationToken = default
	)
	{
		MetricRecord record = new()
		{
			MetricName = metricName,
			Value = value,
			Category = category,
			Unit = unit,
			Tags = tags ?? new Dictionary<string, string>(),
			Source = "H0UND",
		};

		ConcurrentQueue<MetricRecord> queue = _metrics.GetOrAdd(metricName, _ => new ConcurrentQueue<MetricRecord>());
		queue.Enqueue(record);

		// Evict oldest if over capacity
		while (queue.Count > _maxRecordsPerMetric && queue.TryDequeue(out _)) { }

		return Task.CompletedTask;
	}

	public Task<IReadOnlyList<MetricRecord>> QueryAsync(string metricName, TimeSpan window, CancellationToken cancellationToken = default)
	{
		if (!_metrics.TryGetValue(metricName, out ConcurrentQueue<MetricRecord>? queue))
			return Task.FromResult<IReadOnlyList<MetricRecord>>(Array.Empty<MetricRecord>());

		DateTime cutoff = DateTime.UtcNow - window;
		List<MetricRecord> results = queue.Where(r => r.Timestamp >= cutoff).ToList();
		return Task.FromResult<IReadOnlyList<MetricRecord>>(results);
	}

	public Task<MetricRecord?> GetLatestAsync(string metricName, CancellationToken cancellationToken = default)
	{
		if (!_metrics.TryGetValue(metricName, out ConcurrentQueue<MetricRecord>? queue))
			return Task.FromResult<MetricRecord?>(null);

		MetricRecord? latest = queue.LastOrDefault();
		return Task.FromResult(latest);
	}

	public IReadOnlyList<string> GetMetricNames()
	{
		return _metrics.Keys.ToList();
	}

	/// <summary>
	/// Records standard system metrics snapshot.
	/// </summary>
	public async Task RecordSystemSnapshotAsync(CancellationToken cancellationToken = default)
	{
		long memoryBytes = GC.GetTotalMemory(forceFullCollection: false);
		await RecordAsync("system.memory_bytes", memoryBytes, MetricCategory.System, "bytes", cancellationToken: cancellationToken);
		await RecordAsync("system.gc_gen0", GC.CollectionCount(0), MetricCategory.System, "count", cancellationToken: cancellationToken);
		await RecordAsync("system.gc_gen1", GC.CollectionCount(1), MetricCategory.System, "count", cancellationToken: cancellationToken);
		await RecordAsync("system.gc_gen2", GC.CollectionCount(2), MetricCategory.System, "count", cancellationToken: cancellationToken);
		await RecordAsync("system.thread_count", Environment.ProcessorCount, MetricCategory.System, "count", cancellationToken: cancellationToken);
	}
}
