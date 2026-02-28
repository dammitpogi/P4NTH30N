using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-011: Unbreakable contract for temporal event buffering.
/// Stores vision and game events with time-windowed retrieval.
/// </summary>
public interface IEventBuffer<T>
{
	/// <summary>
	/// Adds an event to the buffer.
	/// </summary>
	Task AddAsync(T item, CancellationToken cancellationToken = default);

	/// <summary>
	/// Retrieves events within the specified time window.
	/// </summary>
	Task<IReadOnlyList<T>> GetWindowAsync(TimeSpan window, CancellationToken cancellationToken = default);

	/// <summary>
	/// Gets the current buffer count.
	/// </summary>
	int Count { get; }

	/// <summary>
	/// Clears all events from the buffer.
	/// </summary>
	Task ClearAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Purges events older than the specified duration.
	/// </summary>
	Task<int> PurgeOlderThanAsync(TimeSpan age, CancellationToken cancellationToken = default);
}
