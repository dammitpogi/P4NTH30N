using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.H4ND.Vision;

/// <summary>
/// FEAT-036: Tracks vision command execution lifecycle.
/// Monitors pending, in-progress, completed, and failed commands.
/// Provides metrics for the developer dashboard.
/// </summary>
public sealed class VisionExecutionTracker
{
	private readonly ConcurrentDictionary<string, TrackedCommand> _commands = new();
	private long _totalSubmitted;
	private long _totalCompleted;
	private long _totalFailed;

	public long TotalSubmitted => Interlocked.Read(ref _totalSubmitted);
	public long TotalCompleted => Interlocked.Read(ref _totalCompleted);
	public long TotalFailed => Interlocked.Read(ref _totalFailed);

	/// <summary>
	/// Records a command submission.
	/// </summary>
	public void TrackSubmitted(VisionCommand command)
	{
		TrackedCommand tracked = new()
		{
			Command = command,
			SubmittedAt = DateTime.UtcNow,
			Status = VisionCommandStatus.Pending,
		};

		_commands[command.Id] = tracked;
		Interlocked.Increment(ref _totalSubmitted);
	}

	/// <summary>
	/// Records a command starting execution.
	/// </summary>
	public void TrackStarted(string commandId)
	{
		if (_commands.TryGetValue(commandId, out TrackedCommand? tracked))
		{
			tracked.StartedAt = DateTime.UtcNow;
			tracked.Status = VisionCommandStatus.InProgress;
		}
	}

	/// <summary>
	/// Records a command completion.
	/// </summary>
	public void TrackCompleted(string commandId, bool success)
	{
		if (_commands.TryGetValue(commandId, out TrackedCommand? tracked))
		{
			tracked.CompletedAt = DateTime.UtcNow;
			tracked.Status = success ? VisionCommandStatus.Completed : VisionCommandStatus.Failed;

			if (success)
				Interlocked.Increment(ref _totalCompleted);
			else
				Interlocked.Increment(ref _totalFailed);
		}
	}

	/// <summary>
	/// Gets execution metrics.
	/// </summary>
	public VisionExecutionMetrics GetMetrics()
	{
		List<TrackedCommand> all = _commands.Values.ToList();
		List<TrackedCommand> completed = all.Where(c => c.CompletedAt.HasValue && c.StartedAt.HasValue).ToList();

		double avgExecutionMs = 0;
		if (completed.Count > 0)
			avgExecutionMs = completed.Average(c => (c.CompletedAt!.Value - c.StartedAt!.Value).TotalMilliseconds);

		return new VisionExecutionMetrics
		{
			TotalSubmitted = TotalSubmitted,
			TotalCompleted = TotalCompleted,
			TotalFailed = TotalFailed,
			Pending = all.Count(c => c.Status == VisionCommandStatus.Pending),
			InProgress = all.Count(c => c.Status == VisionCommandStatus.InProgress),
			AverageExecutionMs = avgExecutionMs,
			SuccessRate = TotalSubmitted > 0 ? (double)TotalCompleted / TotalSubmitted : 0,
		};
	}

	/// <summary>
	/// Cleans up completed commands older than the specified age.
	/// </summary>
	public int Cleanup(TimeSpan maxAge)
	{
		DateTime cutoff = DateTime.UtcNow - maxAge;
		int removed = 0;

		foreach (var kv in _commands)
		{
			if (kv.Value.CompletedAt.HasValue && kv.Value.CompletedAt.Value < cutoff)
			{
				if (_commands.TryRemove(kv.Key, out _))
					removed++;
			}
		}

		return removed;
	}
}

/// <summary>
/// A tracked vision command with lifecycle timestamps.
/// </summary>
internal sealed class TrackedCommand
{
	public VisionCommand Command { get; set; } = new();
	public DateTime SubmittedAt { get; set; }
	public DateTime? StartedAt { get; set; }
	public DateTime? CompletedAt { get; set; }
	public VisionCommandStatus Status { get; set; }
}

/// <summary>
/// Vision command execution metrics.
/// </summary>
public sealed class VisionExecutionMetrics
{
	public long TotalSubmitted { get; set; }
	public long TotalCompleted { get; set; }
	public long TotalFailed { get; set; }
	public int Pending { get; set; }
	public int InProgress { get; set; }
	public double AverageExecutionMs { get; set; }
	public double SuccessRate { get; set; }
}
