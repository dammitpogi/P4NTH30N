using System.Threading;

namespace P4NTHE0N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Thread-safe counters tracking telemetry data loss.
/// Incremented when buffer is full (backpressure) or sink write fails.
/// </summary>
public sealed class TelemetryLossCounters
{
	private long _droppedDueToBackpressure;
	private long _droppedDueToSinkFailure;
	private long _totalEnqueued;
	private long _totalFlushed;

	public long DroppedDueToBackpressure => Interlocked.Read(ref _droppedDueToBackpressure);
	public long DroppedDueToSinkFailure => Interlocked.Read(ref _droppedDueToSinkFailure);
	public long TotalEnqueued => Interlocked.Read(ref _totalEnqueued);
	public long TotalFlushed => Interlocked.Read(ref _totalFlushed);
	public long TotalDropped => DroppedDueToBackpressure + DroppedDueToSinkFailure;

	public void IncrementBackpressureDrop() => Interlocked.Increment(ref _droppedDueToBackpressure);
	public void IncrementSinkFailureDrop(int count = 1) => Interlocked.Add(ref _droppedDueToSinkFailure, count);
	public void IncrementEnqueued() => Interlocked.Increment(ref _totalEnqueued);
	public void IncrementFlushed(int count = 1) => Interlocked.Add(ref _totalFlushed, count);

	public void Reset()
	{
		Interlocked.Exchange(ref _droppedDueToBackpressure, 0);
		Interlocked.Exchange(ref _droppedDueToSinkFailure, 0);
		Interlocked.Exchange(ref _totalEnqueued, 0);
		Interlocked.Exchange(ref _totalFlushed, 0);
	}

	public override string ToString() =>
		$"Enqueued={TotalEnqueued} Flushed={TotalFlushed} DroppedBackpressure={DroppedDueToBackpressure} DroppedSinkFailure={DroppedDueToSinkFailure}";
}
