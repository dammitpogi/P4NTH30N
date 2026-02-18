using System.Collections.Concurrent;

namespace P4NTH30N.W4TCHD0G.Input;

/// <summary>
/// Thread-safe FIFO queue for sequentially executing input actions on the VM.
/// Actions are enqueued by the vision analysis pipeline and executed by the Synergy client.
/// </summary>
/// <remarks>
/// DESIGN:
/// - Lock-free ConcurrentQueue for thread safety
/// - Actions executed sequentially with configurable inter-action delays
/// - Per-action timeout (default 2s per Oracle requirement)
/// - Execution can be cancelled mid-sequence
/// </remarks>
public sealed class ActionQueue
{
	/// <summary>
	/// Internal concurrent queue of pending actions.
	/// </summary>
	private readonly ConcurrentQueue<InputAction> _queue = new();

	/// <summary>
	/// Number of actions currently in the queue.
	/// </summary>
	public int Count => _queue.Count;

	/// <summary>
	/// Total actions enqueued since creation.
	/// </summary>
	private long _totalEnqueued;

	/// <summary>
	/// Total actions successfully executed.
	/// </summary>
	private long _totalExecuted;

	/// <summary>
	/// Total actions that failed or timed out.
	/// </summary>
	private long _totalFailed;

	/// <summary>
	/// Total actions enqueued since creation.
	/// </summary>
	public long TotalEnqueued => Interlocked.Read(ref _totalEnqueued);

	/// <summary>
	/// Total actions successfully executed.
	/// </summary>
	public long TotalExecuted => Interlocked.Read(ref _totalExecuted);

	/// <summary>
	/// Total actions that failed or timed out.
	/// </summary>
	public long TotalFailed => Interlocked.Read(ref _totalFailed);

	/// <summary>
	/// Enqueues an action for later execution.
	/// </summary>
	/// <param name="action">The input action to queue.</param>
	public void Enqueue(InputAction action)
	{
		ArgumentNullException.ThrowIfNull(action, nameof(action));
		_queue.Enqueue(action);
		Interlocked.Increment(ref _totalEnqueued);
	}

	/// <summary>
	/// Enqueues multiple actions in order.
	/// </summary>
	/// <param name="actions">Actions to queue.</param>
	public void EnqueueRange(IEnumerable<InputAction> actions)
	{
		foreach (InputAction action in actions)
		{
			Enqueue(action);
		}
	}

	/// <summary>
	/// Dequeues the next action, or returns null if the queue is empty.
	/// </summary>
	public InputAction? Dequeue()
	{
		return _queue.TryDequeue(out InputAction? action) ? action : null;
	}

	/// <summary>
	/// Peeks at the next action without removing it.
	/// </summary>
	public InputAction? Peek()
	{
		return _queue.TryPeek(out InputAction? action) ? action : null;
	}

	/// <summary>
	/// Executes all queued actions sequentially using the provided executor function.
	/// Each action is executed with its configured timeout and post-action delay.
	/// </summary>
	/// <param name="executor">Async function that executes a single InputAction.</param>
	/// <param name="cancellationToken">Token to cancel mid-sequence.</param>
	/// <returns>Number of actions successfully executed.</returns>
	public async Task<int> ExecuteAllAsync(
		Func<InputAction, CancellationToken, Task> executor,
		CancellationToken cancellationToken = default)
	{
		int executed = 0;

		while (_queue.TryDequeue(out InputAction? action) && !cancellationToken.IsCancellationRequested)
		{
			try
			{
				// Apply per-action timeout
				using CancellationTokenSource timeoutCts = new(action.TimeoutMs);
				using CancellationTokenSource linkedCts = CancellationTokenSource.CreateLinkedTokenSource(
					cancellationToken, timeoutCts.Token);

				await executor(action, linkedCts.Token);
				Interlocked.Increment(ref _totalExecuted);
				executed++;

				// Post-action delay (human-like pacing)
				if (action.DelayAfterMs > 0 && !cancellationToken.IsCancellationRequested)
				{
					await Task.Delay(action.DelayAfterMs, cancellationToken);
				}
			}
			catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
			{
				// Queue execution cancelled — stop processing
				Interlocked.Increment(ref _totalFailed);
				break;
			}
			catch (OperationCanceledException)
			{
				// Individual action timed out — log and continue
				Interlocked.Increment(ref _totalFailed);
				Console.WriteLine($"[ActionQueue] Action timed out after {action.TimeoutMs}ms: {action.Type}");
			}
			catch (Exception ex)
			{
				Interlocked.Increment(ref _totalFailed);
				Console.WriteLine($"[ActionQueue] Action failed: {action.Type} — {ex.Message}");
			}
		}

		return executed;
	}

	/// <summary>
	/// Clears all pending actions from the queue.
	/// </summary>
	public void Clear()
	{
		while (_queue.TryDequeue(out _)) { }
	}
}
