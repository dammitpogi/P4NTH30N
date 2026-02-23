using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Channels;
using System.Threading.Tasks;
using MongoDB.Driver;

namespace P4NTH30N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Buffered, backpressure-aware log writer.
/// Accepts log entries into a bounded Channel, flushes in batches to MongoDB.
/// When the buffer is full, entries are dropped and counted in TelemetryLossCounters.
/// Sink outages are tolerated: failed batches increment loss counters, writer keeps running.
/// </summary>
public sealed class BufferedLogWriter<T> : IAsyncDisposable where T : class
{
	private readonly Channel<T> _channel;
	private readonly IMongoCollection<T> _collection;
	private readonly TelemetryLossCounters _counters;
	private readonly Task _flushTask;
	private readonly CancellationTokenSource _cts;
	private readonly int _batchSize;
	private readonly TimeSpan _flushInterval;
	private readonly Action<string>? _errorLogger;

	public TelemetryLossCounters Counters => _counters;

	public BufferedLogWriter(
		IMongoCollection<T> collection,
		TelemetryLossCounters counters,
		int bufferCapacity = 4096,
		int batchSize = 64,
		TimeSpan? flushInterval = null,
		Action<string>? errorLogger = null)
	{
		_collection = collection ?? throw new ArgumentNullException(nameof(collection));
		_counters = counters ?? throw new ArgumentNullException(nameof(counters));
		_batchSize = batchSize > 0 ? batchSize : 64;
		_flushInterval = flushInterval ?? TimeSpan.FromSeconds(2);
		_errorLogger = errorLogger;

		_channel = Channel.CreateBounded<T>(new BoundedChannelOptions(bufferCapacity)
		{
			FullMode = BoundedChannelFullMode.DropWrite,
			SingleReader = true,
			SingleWriter = false,
		});

		_cts = new CancellationTokenSource();
		_flushTask = Task.Run(() => FlushLoopAsync(_cts.Token));
	}

	/// <summary>
	/// Enqueue a log entry. Returns false if backpressure caused a drop.
	/// </summary>
	public bool TryWrite(T entry)
	{
		if (_channel.Writer.TryWrite(entry))
		{
			_counters.IncrementEnqueued();
			return true;
		}

		_counters.IncrementBackpressureDrop();
		return false;
	}

	private async Task FlushLoopAsync(CancellationToken ct)
	{
		var batch = new List<T>(_batchSize);

		while (!ct.IsCancellationRequested)
		{
			try
			{
				batch.Clear();

				// Wait for at least one item or timeout
				if (await WaitForDataAsync(ct))
				{
					// Drain up to batchSize items
					while (batch.Count < _batchSize && _channel.Reader.TryRead(out var item))
					{
						batch.Add(item);
					}

					if (batch.Count > 0)
					{
						await FlushBatchAsync(batch, ct);
					}
				}
			}
			catch (OperationCanceledException) when (ct.IsCancellationRequested)
			{
				break;
			}
			catch (Exception ex)
			{
				_errorLogger?.Invoke($"[BufferedLogWriter] Flush loop error: {ex.Message}");
				await Task.Delay(TimeSpan.FromSeconds(1), ct).ConfigureAwait(false);
			}
		}

		// Final drain on shutdown
		batch.Clear();
		while (_channel.Reader.TryRead(out var remaining))
		{
			batch.Add(remaining);
			if (batch.Count >= _batchSize)
			{
				await FlushBatchAsync(batch, CancellationToken.None);
				batch.Clear();
			}
		}
		if (batch.Count > 0)
		{
			await FlushBatchAsync(batch, CancellationToken.None);
		}
	}

	private async Task<bool> WaitForDataAsync(CancellationToken ct)
	{
		using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
		timeoutCts.CancelAfter(_flushInterval);

		try
		{
			return await _channel.Reader.WaitToReadAsync(timeoutCts.Token);
		}
		catch (OperationCanceledException) when (!ct.IsCancellationRequested)
		{
			// Timeout — check if there's anything to flush anyway
			return _channel.Reader.TryPeek(out _);
		}
	}

	private async Task FlushBatchAsync(List<T> batch, CancellationToken ct)
	{
		try
		{
			await _collection.InsertManyAsync(batch, new InsertManyOptions { IsOrdered = false }, ct);
			_counters.IncrementFlushed(batch.Count);
		}
		catch (Exception ex)
		{
			_counters.IncrementSinkFailureDrop(batch.Count);
			_errorLogger?.Invoke($"[BufferedLogWriter] Sink failure ({batch.Count} entries lost): {ex.Message}");
		}
	}

	public async ValueTask DisposeAsync()
	{
		_channel.Writer.TryComplete();
		_cts.Cancel();

		try
		{
			await _flushTask.ConfigureAwait(false);
		}
		catch (OperationCanceledException) { }

		_cts.Dispose();
	}
}
