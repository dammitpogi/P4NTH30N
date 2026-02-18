namespace P4NTH30N.W4TCHD0G.Agent;

/// <summary>
/// Polls MongoDB SIGN4L collection for pending signals from H0UND.
/// Bridges the database-driven signal system with FourEyes automation.
/// </summary>
/// <remarks>
/// ACT-001: Signal-to-Action Automation Pipeline.
/// Signal types: SPIN, BET, LOGIN, LOGOUT.
/// Polls every 5-10 seconds via injected async function.
/// </remarks>
public sealed class SignalPoller
{
	private readonly Func<CancellationToken, Task<PendingSignal?>> _pollFunc;
	private readonly Func<string, CancellationToken, Task> _completeFunc;
	private readonly TimeSpan _pollInterval;
	private long _totalPolled;
	private long _totalProcessed;

	/// <summary>Total signals polled.</summary>
	public long TotalPolled => Interlocked.Read(ref _totalPolled);

	/// <summary>Total signals successfully processed.</summary>
	public long TotalProcessed => Interlocked.Read(ref _totalProcessed);

	/// <summary>Event raised when a new signal is available.</summary>
	public event Action<PendingSignal>? OnSignalReceived;

	/// <summary>
	/// Creates a SignalPoller.
	/// </summary>
	/// <param name="pollFunc">Async function that checks for pending signals in MongoDB.</param>
	/// <param name="completeFunc">Async function that marks a signal as completed.</param>
	/// <param name="pollIntervalSeconds">Seconds between polls. Default: 5.</param>
	public SignalPoller(
		Func<CancellationToken, Task<PendingSignal?>> pollFunc,
		Func<string, CancellationToken, Task> completeFunc,
		int pollIntervalSeconds = 5)
	{
		_pollFunc = pollFunc;
		_completeFunc = completeFunc;
		_pollInterval = TimeSpan.FromSeconds(pollIntervalSeconds);
	}

	/// <summary>
	/// Polls once for a pending signal.
	/// </summary>
	/// <returns>The pending signal, or null if none available.</returns>
	public async Task<PendingSignal?> PollOnceAsync(CancellationToken ct = default)
	{
		try
		{
			PendingSignal? signal = await _pollFunc(ct);
			Interlocked.Increment(ref _totalPolled);

			if (signal is not null)
			{
				Console.WriteLine($"[SignalPoller] Signal received: {signal.Type} for {signal.Username} ({signal.Game})");
				OnSignalReceived?.Invoke(signal);
			}

			return signal;
		}
		catch (OperationCanceledException)
		{
			throw;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SignalPoller] Poll error: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Runs continuous polling until cancelled.
	/// </summary>
	public async Task RunAsync(Func<PendingSignal, CancellationToken, Task<bool>> handler, CancellationToken ct)
	{
		Console.WriteLine($"[SignalPoller] Starting continuous polling (interval: {_pollInterval.TotalSeconds}s)");

		while (!ct.IsCancellationRequested)
		{
			PendingSignal? signal = await PollOnceAsync(ct);

			if (signal is not null)
			{
				try
				{
					bool success = await handler(signal, ct);
					if (success)
					{
						await _completeFunc(signal.SignalId, ct);
						Interlocked.Increment(ref _totalProcessed);
						Console.WriteLine($"[SignalPoller] Signal {signal.SignalId} completed.");
					}
					else
					{
						Console.WriteLine($"[SignalPoller] Signal {signal.SignalId} handler returned false, skipping.");
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine($"[SignalPoller] Signal handler error: {ex.Message}");
				}
			}

			await Task.Delay(_pollInterval, ct);
		}
	}

	/// <summary>
	/// Marks a signal as completed.
	/// </summary>
	public async Task CompleteSignalAsync(string signalId, CancellationToken ct = default)
	{
		await _completeFunc(signalId, ct);
		Interlocked.Increment(ref _totalProcessed);
	}
}

/// <summary>
/// Represents a pending signal from the SIGN4L collection.
/// </summary>
public sealed class PendingSignal
{
	/// <summary>MongoDB document ID.</summary>
	public string SignalId { get; init; } = string.Empty;

	/// <summary>Signal type: SPIN, BET, LOGIN, LOGOUT.</summary>
	public string Type { get; init; } = string.Empty;

	/// <summary>Target credential username.</summary>
	public string Username { get; init; } = string.Empty;

	/// <summary>Target game.</summary>
	public string Game { get; init; } = string.Empty;

	/// <summary>Target house/casino.</summary>
	public string House { get; init; } = string.Empty;

	/// <summary>Optional bet amount (for BET signals).</summary>
	public decimal? BetAmount { get; init; }

	/// <summary>When the signal was created.</summary>
	public DateTime CreatedAt { get; init; } = DateTime.UtcNow;

	/// <summary>Signal timeout — skip if past this time.</summary>
	public DateTime? Timeout { get; init; }

	/// <summary>Whether this signal has expired.</summary>
	public bool IsExpired => Timeout.HasValue && DateTime.UtcNow > Timeout.Value;
}
