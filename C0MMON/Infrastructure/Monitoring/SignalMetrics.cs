using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;

namespace P4NTH30N.C0MMON.Infrastructure.Monitoring;

public sealed class SignalMetrics
{
	private long _signalsGenerated;
	private long _signalsDeduplicated;
	private long _locksAcquired;
	private long _lockContentions;
	private long _deadLettered;
	private long _retries;
	private long _circuitBreakerTrips;

	private readonly ConcurrentQueue<double> _latencies = new();
	private readonly int _maxLatencyEntries;
	private readonly Action<string>? _logger;
	private DateTime _lastReportUtc = DateTime.UtcNow;
	private readonly TimeSpan _reportInterval;

	public long SignalsGenerated => Interlocked.Read(ref _signalsGenerated);
	public long SignalsDeduplicated => Interlocked.Read(ref _signalsDeduplicated);
	public long LocksAcquired => Interlocked.Read(ref _locksAcquired);
	public long LockContentions => Interlocked.Read(ref _lockContentions);
	public long DeadLettered => Interlocked.Read(ref _deadLettered);
	public long Retries => Interlocked.Read(ref _retries);
	public long CircuitBreakerTrips => Interlocked.Read(ref _circuitBreakerTrips);

	public SignalMetrics(Action<string>? logger = null, TimeSpan? reportInterval = null, int maxLatencyEntries = 1000)
	{
		_logger = logger;
		_reportInterval = reportInterval ?? TimeSpan.FromSeconds(60);
		_maxLatencyEntries = maxLatencyEntries;
	}

	public void RecordSignalGenerated(int count = 1)
	{
		Interlocked.Add(ref _signalsGenerated, count);
	}

	public void RecordDeduplicated()
	{
		Interlocked.Increment(ref _signalsDeduplicated);
	}

	public void RecordLockAcquired()
	{
		Interlocked.Increment(ref _locksAcquired);
	}

	public void RecordLockContention()
	{
		Interlocked.Increment(ref _lockContentions);
	}

	public void RecordDeadLettered()
	{
		Interlocked.Increment(ref _deadLettered);
	}

	public void RecordRetry()
	{
		Interlocked.Increment(ref _retries);
	}

	public void RecordCircuitBreakerTrip()
	{
		Interlocked.Increment(ref _circuitBreakerTrips);
	}

	public void RecordLatency(double milliseconds)
	{
		_latencies.Enqueue(milliseconds);
		// Trim to max size
		while (_latencies.Count > _maxLatencyEntries)
		{
			_latencies.TryDequeue(out _);
		}
	}

	public LatencyStats GetLatencyStats()
	{
		double[] values = _latencies.ToArray();
		if (values.Length == 0)
		{
			return new LatencyStats(0, 0, 0, 0, 0);
		}

		Array.Sort(values);
		return new LatencyStats(
			Min: values[0],
			Max: values[^1],
			Mean: values.Average(),
			P50: Percentile(values, 50),
			P99: Percentile(values, 99)
		);
	}

	public SignalMetricsSnapshot GetSnapshot()
	{
		return new SignalMetricsSnapshot(
			SignalsGenerated: SignalsGenerated,
			SignalsDeduplicated: SignalsDeduplicated,
			LocksAcquired: LocksAcquired,
			LockContentions: LockContentions,
			DeadLettered: DeadLettered,
			Retries: Retries,
			CircuitBreakerTrips: CircuitBreakerTrips,
			Latency: GetLatencyStats()
		);
	}

	public void ReportIfDue()
	{
		if ((DateTime.UtcNow - _lastReportUtc) < _reportInterval)
			return;

		_lastReportUtc = DateTime.UtcNow;
		SignalMetricsSnapshot snapshot = GetSnapshot();
		LatencyStats latency = snapshot.Latency;

		_logger?.Invoke(
			$"[SignalMetrics] Generated={snapshot.SignalsGenerated} Deduped={snapshot.SignalsDeduplicated} " +
			$"Locks={snapshot.LocksAcquired} Contention={snapshot.LockContentions} " +
			$"DeadLetter={snapshot.DeadLettered} Retries={snapshot.Retries} " +
			$"CBTrips={snapshot.CircuitBreakerTrips} " +
			$"Latency(ms) P50={latency.P50:F1} P99={latency.P99:F1} Max={latency.Max:F1}"
		);
	}

	public IDisposable MeasureLatency()
	{
		return new LatencyMeasurement(this);
	}

	private static double Percentile(double[] sorted, int percentile)
	{
		if (sorted.Length == 0) return 0;
		double index = (percentile / 100.0) * (sorted.Length - 1);
		int lower = (int)Math.Floor(index);
		int upper = (int)Math.Ceiling(index);
		if (lower == upper) return sorted[lower];
		double fraction = index - lower;
		return sorted[lower] * (1 - fraction) + sorted[upper] * fraction;
	}

	private sealed class LatencyMeasurement : IDisposable
	{
		private readonly SignalMetrics _metrics;
		private readonly Stopwatch _stopwatch;

		public LatencyMeasurement(SignalMetrics metrics)
		{
			_metrics = metrics;
			_stopwatch = Stopwatch.StartNew();
		}

		public void Dispose()
		{
			_stopwatch.Stop();
			_metrics.RecordLatency(_stopwatch.Elapsed.TotalMilliseconds);
		}
	}
}

public record LatencyStats(double Min, double Max, double Mean, double P50, double P99);

public record SignalMetricsSnapshot(
	long SignalsGenerated,
	long SignalsDeduplicated,
	long LocksAcquired,
	long LockContentions,
	long DeadLettered,
	long Retries,
	long CircuitBreakerTrips,
	LatencyStats Latency
);
