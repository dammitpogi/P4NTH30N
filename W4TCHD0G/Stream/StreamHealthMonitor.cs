using System.Diagnostics;

namespace P4NTH30N.W4TCHD0G.Stream;

/// <summary>
/// Monitors RTMP stream health metrics: latency, frame rate, drop rate, and connection status.
/// Raises alerts when metrics exceed configured thresholds.
/// </summary>
/// <remarks>
/// PERFORMANCE TARGETS (FOUR-005):
/// - Latency: &lt;300ms (alert at 500ms, critical at 1000ms)
/// - Frame drop rate: &lt;1% (alert at 2%, critical at 5%)
/// - Minimum FPS: 25 (alert at 20, critical at 10)
/// </remarks>
public sealed class StreamHealthMonitor : IDisposable
{
	/// <summary>
	/// The stream receiver being monitored.
	/// </summary>
	private readonly IStreamReceiver _receiver;

	/// <summary>
	/// Monitoring interval timer.
	/// </summary>
	private Timer? _monitorTimer;

	/// <summary>
	/// Stopwatch for FPS calculation.
	/// </summary>
	private readonly Stopwatch _fpsStopwatch = new();

	/// <summary>
	/// Frame count at the start of the current FPS measurement window.
	/// </summary>
	private long _fpsWindowStartFrames;

	/// <summary>
	/// Current calculated frames per second.
	/// </summary>
	private double _currentFps;

	/// <summary>
	/// Whether the monitor has been disposed.
	/// </summary>
	private bool _disposed;

	// ── Thresholds ────────────────────────────────────────────────────

	/// <summary>
	/// Latency threshold for warning alerts (milliseconds).
	/// </summary>
	public long LatencyWarningMs { get; set; } = 500;

	/// <summary>
	/// Latency threshold for critical alerts (milliseconds).
	/// </summary>
	public long LatencyCriticalMs { get; set; } = 1000;

	/// <summary>
	/// Frame drop rate threshold for warning alerts (percentage).
	/// </summary>
	public double DropRateWarningPct { get; set; } = 2.0;

	/// <summary>
	/// Frame drop rate threshold for critical alerts (percentage).
	/// </summary>
	public double DropRateCriticalPct { get; set; } = 5.0;

	/// <summary>
	/// Minimum acceptable FPS before warning.
	/// </summary>
	public double MinFpsWarning { get; set; } = 20.0;

	/// <summary>
	/// Minimum acceptable FPS before critical alert.
	/// </summary>
	public double MinFpsCritical { get; set; } = 10.0;

	// ── Current Metrics ──────────────────────────────────────────────

	/// <summary>
	/// Current measured FPS.
	/// </summary>
	public double CurrentFps => _currentFps;

	/// <summary>
	/// Overall health status of the stream.
	/// </summary>
	public StreamHealth CurrentHealth { get; private set; } = StreamHealth.Unknown;

	/// <summary>
	/// Event raised when health status changes.
	/// </summary>
	public event Action<StreamHealth, string>? OnHealthChanged;

	/// <summary>
	/// Creates a StreamHealthMonitor for the given receiver.
	/// </summary>
	/// <param name="receiver">The stream receiver to monitor.</param>
	public StreamHealthMonitor(IStreamReceiver receiver)
	{
		_receiver = receiver ?? throw new ArgumentNullException(nameof(receiver));
	}

	/// <summary>
	/// Starts periodic health monitoring at the specified interval.
	/// </summary>
	/// <param name="intervalMs">Monitoring interval in milliseconds. Default: 5000 (5 seconds).</param>
	public void Start(int intervalMs = 5000)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		_fpsStopwatch.Restart();
		_fpsWindowStartFrames = _receiver.TotalFramesReceived;

		_monitorTimer = new Timer(
			callback: _ => CheckHealth(),
			state: null,
			dueTime: intervalMs,
			period: intervalMs
		);

		Console.WriteLine($"[StreamHealthMonitor] Started (interval: {intervalMs}ms)");
	}

	/// <summary>
	/// Stops health monitoring.
	/// </summary>
	public void Stop()
	{
		_monitorTimer?.Dispose();
		_monitorTimer = null;
		_fpsStopwatch.Stop();
		Console.WriteLine("[StreamHealthMonitor] Stopped.");
	}

	/// <summary>
	/// Performs a single health check and updates status.
	/// </summary>
	private void CheckHealth()
	{
		if (_disposed)
			return;

		StreamHealth worstHealth = StreamHealth.Healthy;
		List<string> issues = new();

		// ── Connection Check ─────────────────────────────────────────
		if (!_receiver.IsReceiving)
		{
			worstHealth = StreamHealth.Critical;
			issues.Add("Stream disconnected");
		}

		// ── FPS Calculation ──────────────────────────────────────────
		long currentFrames = _receiver.TotalFramesReceived;
		double elapsedSeconds = _fpsStopwatch.Elapsed.TotalSeconds;

		if (elapsedSeconds > 0)
		{
			_currentFps = (currentFrames - _fpsWindowStartFrames) / elapsedSeconds;
			_fpsWindowStartFrames = currentFrames;
			_fpsStopwatch.Restart();

			if (_currentFps < MinFpsCritical)
			{
				worstHealth = MaxSeverity(worstHealth, StreamHealth.Critical);
				issues.Add($"FPS critically low: {_currentFps:F1}");
			}
			else if (_currentFps < MinFpsWarning)
			{
				worstHealth = MaxSeverity(worstHealth, StreamHealth.Warning);
				issues.Add($"FPS below warning threshold: {_currentFps:F1}");
			}
		}

		// ── Latency Check ────────────────────────────────────────────
		long latency = _receiver.LatencyMs;
		if (latency > LatencyCriticalMs)
		{
			worstHealth = MaxSeverity(worstHealth, StreamHealth.Critical);
			issues.Add($"Latency critical: {latency}ms");
		}
		else if (latency > LatencyWarningMs)
		{
			worstHealth = MaxSeverity(worstHealth, StreamHealth.Warning);
			issues.Add($"Latency high: {latency}ms");
		}

		// ── Drop Rate Check ──────────────────────────────────────────
		long totalReceived = _receiver.TotalFramesReceived;
		long totalDropped = _receiver.TotalFramesDropped;
		double dropRate = (totalReceived + totalDropped) == 0
			? 0.0
			: (totalDropped * 100.0) / (totalReceived + totalDropped);

		if (dropRate > DropRateCriticalPct)
		{
			worstHealth = MaxSeverity(worstHealth, StreamHealth.Critical);
			issues.Add($"Drop rate critical: {dropRate:F1}%");
		}
		else if (dropRate > DropRateWarningPct)
		{
			worstHealth = MaxSeverity(worstHealth, StreamHealth.Warning);
			issues.Add($"Drop rate high: {dropRate:F1}%");
		}

		// ── Update Status ────────────────────────────────────────────
		if (worstHealth != CurrentHealth)
		{
			StreamHealth previousHealth = CurrentHealth;
			CurrentHealth = worstHealth;

			string summary = issues.Count > 0
				? string.Join("; ", issues)
				: "All metrics nominal";

			Console.WriteLine($"[StreamHealthMonitor] {previousHealth} → {worstHealth}: {summary}");
			OnHealthChanged?.Invoke(worstHealth, summary);
		}
	}

	/// <summary>
	/// Returns the more severe of two health statuses.
	/// </summary>
	private static StreamHealth MaxSeverity(StreamHealth a, StreamHealth b)
	{
		return (StreamHealth)Math.Max((int)a, (int)b);
	}

	/// <summary>
	/// Disposes the health monitor.
	/// </summary>
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_monitorTimer?.Dispose();
			_fpsStopwatch.Stop();
		}
	}
}

/// <summary>
/// Stream health status levels.
/// </summary>
public enum StreamHealth
{
	/// <summary>
	/// Health status has not been determined yet.
	/// </summary>
	Unknown = 0,

	/// <summary>
	/// All metrics within acceptable ranges.
	/// </summary>
	Healthy = 1,

	/// <summary>
	/// One or more metrics approaching limits but still operational.
	/// </summary>
	Warning = 2,

	/// <summary>
	/// One or more metrics exceeded critical thresholds. Intervention needed.
	/// </summary>
	Critical = 3,
}
