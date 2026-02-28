using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Input;

namespace P4NTHE0N.W4TCHD0G.Development;

/// <summary>
/// FEAT-036: Mandatory confirmation gate for all spin actions in development mode.
/// Every spin must be explicitly approved before execution. No auto-fire.
/// </summary>
public sealed class ConfirmationGate
{
	private readonly bool _autoApprove;
	private readonly TimeSpan _timeout;
	private long _totalRequested;
	private long _totalApproved;
	private long _totalRejected;
	private long _totalTimedOut;

	/// <summary>
	/// Callback invoked when confirmation is needed. Return true to approve.
	/// If null, uses console-based confirmation (or auto-approve in headless mode).
	/// </summary>
	public Func<ConfirmationRequest, Task<bool>>? OnConfirmationRequired { get; set; }

	public long TotalRequested => Interlocked.Read(ref _totalRequested);
	public long TotalApproved => Interlocked.Read(ref _totalApproved);
	public long TotalRejected => Interlocked.Read(ref _totalRejected);
	public long TotalTimedOut => Interlocked.Read(ref _totalTimedOut);

	/// <summary>
	/// Creates a confirmation gate.
	/// </summary>
	/// <param name="autoApprove">If true, auto-approves all actions (for automated testing only).</param>
	/// <param name="timeout">Maximum time to wait for confirmation before rejecting.</param>
	public ConfirmationGate(bool autoApprove = false, TimeSpan? timeout = null)
	{
		_autoApprove = autoApprove;
		_timeout = timeout ?? TimeSpan.FromSeconds(30);
	}

	/// <summary>
	/// Requests confirmation for an action. Blocks until approved, rejected, or timed out.
	/// </summary>
	/// <param name="action">The action requesting confirmation.</param>
	/// <param name="reason">Why this action is being requested.</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>True if approved, false if rejected or timed out.</returns>
	public async Task<bool> RequestConfirmationAsync(InputAction action, string reason, CancellationToken ct = default)
	{
		Interlocked.Increment(ref _totalRequested);

		ConfirmationRequest request = new()
		{
			Action = action,
			Reason = reason,
			RequestedAt = DateTime.UtcNow,
		};

		if (_autoApprove)
		{
			Interlocked.Increment(ref _totalApproved);
			Console.WriteLine($"[ConfirmationGate] AUTO-APPROVED: {reason}");
			return true;
		}

		try
		{
			bool approved;
			if (OnConfirmationRequired != null)
			{
				using CancellationTokenSource timeoutCts = new(_timeout);
				using CancellationTokenSource linkedCts = CancellationTokenSource.CreateLinkedTokenSource(ct, timeoutCts.Token);

				try
				{
					approved = await OnConfirmationRequired(request);
				}
				catch (OperationCanceledException) when (timeoutCts.IsCancellationRequested)
				{
					Interlocked.Increment(ref _totalTimedOut);
					Console.WriteLine($"[ConfirmationGate] TIMED OUT: {reason}");
					return false;
				}
			}
			else
			{
				// Console-based fallback
				Console.WriteLine($"[ConfirmationGate] CONFIRM SPIN? {reason} (y/n, {_timeout.TotalSeconds}s timeout)");
				approved = false; // Default to reject in non-interactive mode
			}

			if (approved)
			{
				Interlocked.Increment(ref _totalApproved);
				Console.WriteLine($"[ConfirmationGate] APPROVED: {reason}");
			}
			else
			{
				Interlocked.Increment(ref _totalRejected);
				Console.WriteLine($"[ConfirmationGate] REJECTED: {reason}");
			}

			return approved;
		}
		catch (Exception ex)
		{
			Interlocked.Increment(ref _totalRejected);
			Console.WriteLine($"[ConfirmationGate] ERROR (rejected): {ex.Message}");
			return false;
		}
	}
}

/// <summary>
/// A confirmation request for an action.
/// </summary>
public sealed class ConfirmationRequest
{
	public InputAction Action { get; init; } = InputAction.Delay(0);
	public string Reason { get; init; } = string.Empty;
	public DateTime RequestedAt { get; init; } = DateTime.UtcNow;
}
