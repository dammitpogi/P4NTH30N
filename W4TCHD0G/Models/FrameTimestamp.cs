namespace P4NTH30N.W4TCHD0G.Models;

/// <summary>
/// Timestamp correlation data for a single video frame.
/// Enables latency measurement across the pipeline.
/// </summary>
/// <remarks>
/// FOUR-008: Frame Timestamp Correlation for Action Synchronization.
/// Uses host-relative timestamps (no VM clock sync required).
/// </remarks>
public sealed class FrameTimestamp
{
	/// <summary>Frame sequence number.</summary>
	public long FrameNumber { get; set; }

	/// <summary>When the host received the frame from RTMP.</summary>
	public DateTime HostReceiveTime { get; set; }

	/// <summary>When vision analysis started on this frame.</summary>
	public DateTime AnalysisStartTime { get; set; }

	/// <summary>When vision analysis completed.</summary>
	public DateTime AnalysisEndTime { get; set; }

	/// <summary>Stream latency estimate (receive - expected interval).</summary>
	public TimeSpan StreamLatency => HostReceiveTime - AnalysisStartTime;

	/// <summary>Analysis processing time.</summary>
	public TimeSpan AnalysisLatency => AnalysisEndTime - AnalysisStartTime;

	/// <summary>Total pipeline latency from receive to analysis complete.</summary>
	public TimeSpan TotalLatency => AnalysisEndTime - HostReceiveTime;
}

/// <summary>
/// Correlates an action with the frame that triggered it and the frame that confirmed it.
/// </summary>
public sealed class ActionCorrelation
{
	/// <summary>Unique action identifier.</summary>
	public string ActionId { get; init; } = Guid.NewGuid().ToString();

	/// <summary>When the action was sent to Synergy.</summary>
	public DateTime ActionSentTime { get; init; } = DateTime.UtcNow;

	/// <summary>When visual confirmation was detected (null if not yet confirmed).</summary>
	public DateTime? VisualConfirmationTime { get; set; }

	/// <summary>Frame number that triggered this action.</summary>
	public long? TriggerFrameNumber { get; init; }

	/// <summary>Frame number that showed visual confirmation.</summary>
	public long? ConfirmationFrameNumber { get; set; }

	/// <summary>Time from action sent to visual confirmation.</summary>
	public TimeSpan? ActionLatency => VisualConfirmationTime - ActionSentTime;

	/// <summary>Whether the action has been visually confirmed.</summary>
	public bool IsConfirmed => VisualConfirmationTime is not null;

	/// <summary>Whether the action has timed out (>2s without confirmation).</summary>
	public bool IsTimedOut(DateTime now) => !IsConfirmed && (now - ActionSentTime) > TimeSpan.FromSeconds(2);
}

/// <summary>
/// Tracks action-to-frame correlations and computes latency metrics.
/// </summary>
public sealed class TimestampCorrelationService
{
	private readonly Dictionary<string, ActionCorrelation> _pending = new();
	private readonly List<ActionCorrelation> _completed = new();
	private readonly object _lock = new();

	/// <summary>
	/// Records that an action was sent, returning a correlation ID.
	/// </summary>
	public string RecordActionSent(long triggerFrameNumber)
	{
		ActionCorrelation correlation = new() { TriggerFrameNumber = triggerFrameNumber };

		lock (_lock)
		{
			_pending[correlation.ActionId] = correlation;
		}

		return correlation.ActionId;
	}

	/// <summary>
	/// Records visual confirmation for a pending action.
	/// </summary>
	public void RecordConfirmation(string actionId, long confirmationFrameNumber)
	{
		lock (_lock)
		{
			if (_pending.TryGetValue(actionId, out ActionCorrelation? correlation))
			{
				correlation.VisualConfirmationTime = DateTime.UtcNow;
				correlation.ConfirmationFrameNumber = confirmationFrameNumber;
				_pending.Remove(actionId);
				_completed.Add(correlation);

				Console.WriteLine($"[Correlation] Action {actionId} confirmed in {correlation.ActionLatency?.TotalMilliseconds:F0}ms");

				// Keep last 1000 completed
				if (_completed.Count > 1000)
					_completed.RemoveRange(0, _completed.Count - 1000);
			}
		}
	}

	/// <summary>
	/// Checks for timed-out actions and cleans them up.
	/// </summary>
	public List<ActionCorrelation> CheckTimeouts()
	{
		DateTime now = DateTime.UtcNow;
		List<ActionCorrelation> timedOut = new();

		lock (_lock)
		{
			List<string> toRemove = new();
			foreach (KeyValuePair<string, ActionCorrelation> kv in _pending)
			{
				if (kv.Value.IsTimedOut(now))
				{
					timedOut.Add(kv.Value);
					toRemove.Add(kv.Key);
					Console.WriteLine($"[Correlation] Action {kv.Key} timed out");
				}
			}

			foreach (string key in toRemove)
				_pending.Remove(key);
		}

		return timedOut;
	}

	/// <summary>
	/// Gets latency metrics from completed correlations.
	/// </summary>
	public LatencyMetrics GetMetrics()
	{
		lock (_lock)
		{
			List<ActionCorrelation> confirmed = _completed.Where(a => a.IsConfirmed).ToList();

			return new LatencyMetrics
			{
				TotalActions = _completed.Count + _pending.Count,
				ConfirmedActions = confirmed.Count,
				PendingActions = _pending.Count,
				AverageActionLatencyMs = confirmed.Count > 0 ? confirmed.Average(a => a.ActionLatency!.Value.TotalMilliseconds) : 0,
				MaxActionLatencyMs = confirmed.Count > 0 ? confirmed.Max(a => a.ActionLatency!.Value.TotalMilliseconds) : 0,
				TimeoutRate = (_completed.Count + _pending.Count) > 0 ? (double)_completed.Count(a => !a.IsConfirmed) / (_completed.Count + _pending.Count) : 0,
			};
		}
	}
}

/// <summary>
/// Latency metrics summary.
/// </summary>
public sealed class LatencyMetrics
{
	public int TotalActions { get; init; }
	public int ConfirmedActions { get; init; }
	public int PendingActions { get; init; }
	public double AverageActionLatencyMs { get; init; }
	public double MaxActionLatencyMs { get; init; }
	public double TimeoutRate { get; init; }
}
