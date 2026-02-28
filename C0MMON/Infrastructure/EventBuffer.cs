using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Infrastructure;

/// <summary>
/// FOUREYES-007: Temporal event buffer with time-windowed retrieval.
/// Thread-safe, supports configurable max capacity and auto-purge.
/// </summary>
public class EventBuffer<T> : IEventBuffer<T>
	where T : class
{
	private readonly ConcurrentQueue<TimestampedItem<T>> _buffer = new();
	private readonly int _maxCapacity;
	private readonly Func<T, DateTime> _timestampExtractor;
	private int _count;

	public EventBuffer(int maxCapacity = 10_000, Func<T, DateTime>? timestampExtractor = null)
	{
		_maxCapacity = maxCapacity;
		_timestampExtractor = timestampExtractor ?? (_ => DateTime.UtcNow);
	}

	public int Count => _count;

	public Task AddAsync(T item, CancellationToken cancellationToken = default)
	{
		DateTime timestamp = _timestampExtractor(item);
		_buffer.Enqueue(new TimestampedItem<T>(item, timestamp));
		Interlocked.Increment(ref _count);

		// Auto-evict oldest if over capacity
		while (_count > _maxCapacity && _buffer.TryDequeue(out _))
		{
			Interlocked.Decrement(ref _count);
		}

		return Task.CompletedTask;
	}

	public Task<IReadOnlyList<T>> GetWindowAsync(TimeSpan window, CancellationToken cancellationToken = default)
	{
		DateTime cutoff = DateTime.UtcNow - window;
		List<T> results = _buffer.Where(item => item.Timestamp >= cutoff).Select(item => item.Value).ToList();

		return Task.FromResult<IReadOnlyList<T>>(results);
	}

	public Task ClearAsync(CancellationToken cancellationToken = default)
	{
		while (_buffer.TryDequeue(out _)) { }
		Interlocked.Exchange(ref _count, 0);
		return Task.CompletedTask;
	}

	public Task<int> PurgeOlderThanAsync(TimeSpan age, CancellationToken cancellationToken = default)
	{
		DateTime cutoff = DateTime.UtcNow - age;
		int purged = 0;

		while (_buffer.TryPeek(out TimestampedItem<T>? oldest) && oldest.Timestamp < cutoff)
		{
			if (_buffer.TryDequeue(out _))
			{
				Interlocked.Decrement(ref _count);
				purged++;
			}
		}

		return Task.FromResult(purged);
	}
}

internal record TimestampedItem<T>(T Value, DateTime Timestamp);
