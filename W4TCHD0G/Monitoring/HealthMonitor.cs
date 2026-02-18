namespace P4NTH30N.W4TCHD0G.Monitoring;

/// <summary>
/// Comprehensive health monitoring for FourEyes subsystems.
/// Detects stream drops, VM freezes, Synergy disconnects, and vision mismatches.
/// </summary>
/// <remarks>
/// FOUR-003: Failure Recovery and Health Monitoring System.
/// Monitors all critical subsystems and triggers recovery actions.
/// </remarks>
public sealed class HealthMonitor : IDisposable
{
	private readonly TimeSpan _streamTimeout;
	private readonly TimeSpan _freezeTimeout;
	private readonly double _maxMismatchRate;

	private DateTime _lastFrameReceived = DateTime.UtcNow;
	private byte[]? _lastFrameHash;
	private DateTime _lastUniqueFrame = DateTime.UtcNow;
	private int _totalAnalyses;
	private int _mismatchCount;
	private bool _synergyConnected;
	private bool _streamHealthy = true;
	private bool _disposed;

	/// <summary>Event raised when a subsystem health issue is detected.</summary>
	public event Action<HealthIssue>? OnHealthIssue;

	/// <summary>Event raised when recovery action is needed.</summary>
	public event Action<RecoveryAction>? OnRecoveryNeeded;

	/// <summary>
	/// Creates a HealthMonitor.
	/// </summary>
	/// <param name="streamTimeoutSeconds">Seconds without a frame before stream is considered down. Default: 5.</param>
	/// <param name="freezeTimeoutSeconds">Seconds of unchanged frames before VM is considered frozen. Default: 30.</param>
	/// <param name="maxMismatchRate">Maximum vision mismatch rate before alert. Default: 0.10 (10%).</param>
	public HealthMonitor(
		int streamTimeoutSeconds = 5,
		int freezeTimeoutSeconds = 30,
		double maxMismatchRate = 0.10)
	{
		_streamTimeout = TimeSpan.FromSeconds(streamTimeoutSeconds);
		_freezeTimeout = TimeSpan.FromSeconds(freezeTimeoutSeconds);
		_maxMismatchRate = maxMismatchRate;
	}

	/// <summary>
	/// Records that a frame was received from the stream.
	/// </summary>
	/// <param name="frameHash">Simple hash of frame data for freeze detection.</param>
	public void RecordFrameReceived(byte[]? frameHash = null)
	{
		_lastFrameReceived = DateTime.UtcNow;

		if (frameHash is not null)
		{
			if (_lastFrameHash is null || !frameHash.SequenceEqual(_lastFrameHash))
			{
				_lastUniqueFrame = DateTime.UtcNow;
				_lastFrameHash = frameHash;
			}
		}
		else
		{
			_lastUniqueFrame = DateTime.UtcNow;
		}
	}

	/// <summary>
	/// Records Synergy connection state.
	/// </summary>
	public void RecordSynergyState(bool connected)
	{
		if (_synergyConnected && !connected)
		{
			RaiseIssue(SubSystem.Synergy, "Synergy disconnected");
			RaiseRecovery(RecoveryType.ReconnectSynergy);
		}
		_synergyConnected = connected;
	}

	/// <summary>
	/// Records a vision analysis result for mismatch tracking.
	/// </summary>
	/// <param name="matched">Whether the vision analysis matched expected state.</param>
	public void RecordAnalysisResult(bool matched)
	{
		_totalAnalyses++;
		if (!matched) _mismatchCount++;

		if (_totalAnalyses >= 10)
		{
			double rate = (double)_mismatchCount / _totalAnalyses;
			if (rate > _maxMismatchRate)
			{
				RaiseIssue(SubSystem.Vision, $"Vision mismatch rate {rate:P0} exceeds {_maxMismatchRate:P0}");
				// Reset counters after alert
				_totalAnalyses = 0;
				_mismatchCount = 0;
			}
		}
	}

	/// <summary>
	/// Runs a full health check cycle. Call this periodically (every 1-2 seconds).
	/// </summary>
	/// <returns>Current health status.</returns>
	public SystemHealth Check()
	{
		DateTime now = DateTime.UtcNow;
		bool streamOk = (now - _lastFrameReceived) < _streamTimeout;
		bool vmOk = (now - _lastUniqueFrame) < _freezeTimeout;
		bool synergyOk = _synergyConnected;
		double mismatchRate = _totalAnalyses > 0 ? (double)_mismatchCount / _totalAnalyses : 0;

		// Stream health transitions
		if (_streamHealthy && !streamOk)
		{
			_streamHealthy = false;
			RaiseIssue(SubSystem.Stream, $"No frames for {(now - _lastFrameReceived).TotalSeconds:F1}s");
			RaiseRecovery(RecoveryType.ReconnectStream);
		}
		else if (!_streamHealthy && streamOk)
		{
			_streamHealthy = true;
			Console.WriteLine("[HealthMonitor] Stream recovered.");
		}

		// VM freeze detection
		if (!vmOk && streamOk) // Getting frames but they're identical
		{
			RaiseIssue(SubSystem.VM, $"VM appears frozen ({(now - _lastUniqueFrame).TotalSeconds:F0}s unchanged)");
			RaiseRecovery(RecoveryType.RestartChrome);
		}

		return new SystemHealth
		{
			StreamHealthy = streamOk,
			VMResponsive = vmOk,
			SynergyConnected = synergyOk,
			VisionMismatchRate = mismatchRate,
			LastFrameAge = now - _lastFrameReceived,
			LastUniqueFrameAge = now - _lastUniqueFrame,
			OverallHealthy = streamOk && vmOk && synergyOk && mismatchRate <= _maxMismatchRate,
		};
	}

	private void RaiseIssue(SubSystem system, string description)
	{
		HealthIssue issue = new()
		{
			System = system,
			Description = description,
			Timestamp = DateTime.UtcNow,
		};
		Console.WriteLine($"[HealthMonitor] [{system}] {description}");
		OnHealthIssue?.Invoke(issue);
	}

	private void RaiseRecovery(RecoveryType type)
	{
		RecoveryAction action = new()
		{
			Type = type,
			Timestamp = DateTime.UtcNow,
		};
		Console.WriteLine($"[HealthMonitor] Recovery needed: {type}");
		OnRecoveryNeeded?.Invoke(action);
	}

	public void Dispose()
	{
		_disposed = true;
	}
}

/// <summary>System health snapshot.</summary>
public sealed class SystemHealth
{
	public bool StreamHealthy { get; init; }
	public bool VMResponsive { get; init; }
	public bool SynergyConnected { get; init; }
	public double VisionMismatchRate { get; init; }
	public TimeSpan LastFrameAge { get; init; }
	public TimeSpan LastUniqueFrameAge { get; init; }
	public bool OverallHealthy { get; init; }
}

/// <summary>Health issue details.</summary>
public sealed class HealthIssue
{
	public SubSystem System { get; init; }
	public string Description { get; init; } = string.Empty;
	public DateTime Timestamp { get; init; }
}

/// <summary>Recovery action request.</summary>
public sealed class RecoveryAction
{
	public RecoveryType Type { get; init; }
	public DateTime Timestamp { get; init; }
}

/// <summary>Monitored subsystems.</summary>
public enum SubSystem { Stream, VM, Synergy, Vision }

/// <summary>Types of recovery actions.</summary>
public enum RecoveryType { ReconnectStream, ReconnectSynergy, RestartChrome, RebootVM }
