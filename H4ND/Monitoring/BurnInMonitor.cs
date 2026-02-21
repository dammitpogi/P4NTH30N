using System.Collections.Concurrent;
using System.Text.Json;
using P4NTH30N.C0MMON;
using P4NTH30N.H4ND.Monitoring.Models;
using P4NTH30N.H4ND.Parallel;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// MON-057-001: Core monitoring service that collects burn-in metrics every 60 seconds.
/// Exposes current status, stores snapshots, and pushes alerts to connected clients.
/// </summary>
public sealed class BurnInMonitor : IDisposable
{
	private readonly IUnitOfWork _uow;
	private readonly BurnInConfig _burnInConfig;
	private readonly BurnInProgressCalculator _progress;
	private readonly ConcurrentQueue<BurnInMetricsSnapshot> _snapshots = new();
	private readonly ConcurrentQueue<BurnInRecentError> _recentErrors = new();
	private readonly string _sessionId;
	private ParallelMetrics? _metrics;
	private ICdpLifecycleManager? _cdpLifecycle;
	private string _status = "Initializing";
	private long _signalsGenerated;
	private Task? _collectionTask;
	private CancellationTokenSource? _cts;
	private bool _disposed;

	// MON-057-003: Alert subscribers
	private readonly ConcurrentBag<Action<string>> _alertSubscribers = [];

	public string SessionId => _sessionId;
	public string Status => _status;
	public IReadOnlyCollection<BurnInMetricsSnapshot> Snapshots => _snapshots.ToArray();

	public BurnInMonitor(IUnitOfWork uow, BurnInConfig burnInConfig)
	{
		_uow = uow;
		_burnInConfig = burnInConfig;
		_sessionId = $"burnin-{DateTime.UtcNow:yyyyMMdd-HHmmss}";
		_progress = new BurnInProgressCalculator(burnInConfig.DurationHours);
	}

	/// <summary>
	/// Binds the monitor to a running parallel engine's metrics.
	/// </summary>
	public void AttachEngine(ParallelMetrics metrics, ICdpLifecycleManager? cdpLifecycle = null)
	{
		_metrics = metrics;
		_cdpLifecycle = cdpLifecycle;
	}

	/// <summary>
	/// Starts background metrics collection loop.
	/// </summary>
	public void Start()
	{
		if (_collectionTask != null) return;
		_status = "Running";
		_cts = new CancellationTokenSource();
		_collectionTask = Task.Run(() => CollectionLoopAsync(_cts.Token));
		Console.WriteLine($"[BurnInMonitor] Started — session {_sessionId}");
	}

	/// <summary>
	/// Stops background collection.
	/// </summary>
	public void Stop(string reason = "Completed")
	{
		_status = reason;
		_cts?.Cancel();
	}

	/// <summary>
	/// Records a signal generation event for tracking.
	/// </summary>
	public void RecordSignalsGenerated(int count) =>
		Interlocked.Add(ref _signalsGenerated, count);

	/// <summary>
	/// Records an error for the recent errors list.
	/// </summary>
	public void RecordError(string type, bool recovered)
	{
		var err = new BurnInRecentError { Time = DateTime.UtcNow, Type = type, Recovered = recovered };
		_recentErrors.Enqueue(err);
		while (_recentErrors.Count > 50)
			_recentErrors.TryDequeue(out _);
	}

	/// <summary>
	/// MON-057-003: Subscribe to alert notifications.
	/// </summary>
	public void OnAlert(Action<string> handler) => _alertSubscribers.Add(handler);

	/// <summary>
	/// Pushes an alert message to all subscribers.
	/// </summary>
	public void PushAlert(string message)
	{
		foreach (var sub in _alertSubscribers)
		{
			try { sub(message); }
			catch { /* subscriber error is non-fatal */ }
		}
	}

	/// <summary>
	/// MON-057-002: Gets current dashboard status as JSON-serializable object.
	/// </summary>
	public BurnInStatus GetCurrentStatus()
	{
		var metrics = _metrics;
		int pending = 0;
		try { pending = _uow.Signals.GetAll().Count(s => !s.Acknowledged && s.ClaimedBy == null); }
		catch { /* non-fatal */ }

		long currentMem = GC.GetTotalMemory(false);
		var workerStats = metrics?.GetWorkerStats();

		return new BurnInStatus
		{
			SessionId = _sessionId,
			Status = _status,
			Progress = new BurnInProgress
			{
				ElapsedHours = _progress.ElapsedHours,
				TotalHours = _burnInConfig.DurationHours,
				PercentComplete = _progress.PercentComplete,
				Eta = _progress.Eta,
				ThroughputPerHour = _progress.ThroughputPerHour(metrics?.SpinsSucceeded ?? 0),
			},
			Signals = new BurnInSignalStats
			{
				Generated = Interlocked.Read(ref _signalsGenerated),
				Processed = metrics?.SpinsSucceeded ?? 0,
				Pending = pending,
				Claimed = metrics?.ClaimsSucceeded ?? 0,
				Acknowledged = metrics?.SpinsSucceeded ?? 0,
				ThroughputPerHour = _progress.ThroughputPerHour(metrics?.SpinsSucceeded ?? 0),
			},
			Workers = new BurnInWorkerStats
			{
				Configured = workerStats?.Count ?? 0,
				Active = workerStats?.Values.Count(w => w.LastSpinAt.HasValue && (DateTime.UtcNow - w.LastSpinAt.Value).TotalMinutes < 5) ?? 0,
				Status = workerStats?.Select(kv =>
					kv.Value.LastError != null ? $"Error: {kv.Value.LastError[..Math.Min(50, kv.Value.LastError.Length)]}" :
					kv.Value.LastSpinAt.HasValue ? "Healthy" : "Idle").ToList() ?? [],
			},
			Errors = new BurnInErrorStats
			{
				Total = metrics?.SpinsFailed ?? 0,
				Rate = metrics?.ErrorRate ?? 0,
				Recent = _recentErrors.ToArray().TakeLast(10).ToList(),
			},
			Chrome = new BurnInChromeStats
			{
				Status = _cdpLifecycle != null ? _cdpLifecycle.GetLifecycleStatus().ToString() : "Unknown",
				RestartCount = metrics?.WorkerRestarts ?? 0,
			},
			MemoryMB = currentMem / (1024.0 * 1024.0),
			MemoryGrowthMB = 0, // Caller can compute from initial
			CollectedAt = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Gets current status as JSON string.
	/// </summary>
	public string GetStatusJson()
	{
		var status = GetCurrentStatus();
		return JsonSerializer.Serialize(status, new JsonSerializerOptions { WriteIndented = true });
	}

	/// <summary>
	/// MON-057-005: Renders a CLI-friendly dashboard to console.
	/// </summary>
	public void RenderConsole()
	{
		var s = GetCurrentStatus();
		Console.Clear();
		Console.WriteLine("╔══════════════════════════════════════════════════════════════════╗");
		Console.WriteLine($"║  BURN-IN MONITOR — {s.SessionId,-44} ║");
		Console.WriteLine($"║  Status: {s.Status,-10}  Progress: {s.Progress.PercentComplete:F1}%  ETA: {s.Progress.Eta?.ToString("HH:mm") ?? "N/A",-8} ║");
		Console.WriteLine("╠══════════════════════════════════════════════════════════════════╣");
		Console.WriteLine($"║  Signals: processed={s.Signals.Processed} pending={s.Signals.Pending} rate={s.Signals.ThroughputPerHour:F1}/hr");
		Console.WriteLine($"║  Workers: {s.Workers.Active}/{s.Workers.Configured} active  Errors: {s.Errors.Total} ({s.Errors.Rate:F1}%)");
		Console.WriteLine($"║  Memory:  {s.MemoryMB:F0}MB  Chrome: {s.Chrome.Status} (restarts: {s.Chrome.RestartCount})");
		Console.WriteLine("╚══════════════════════════════════════════════════════════════════╝");
	}

	private async Task CollectionLoopAsync(CancellationToken ct)
	{
		while (!ct.IsCancellationRequested)
		{
			try
			{
				await Task.Delay(TimeSpan.FromSeconds(_burnInConfig.MetricsIntervalSeconds), ct);

				if (_metrics == null) continue;

				var snapshot = new BurnInMetricsSnapshot
				{
					ElapsedMinutes = _progress.ElapsedHours * 60,
					SpinsAttempted = _metrics.SpinsAttempted,
					SpinsSucceeded = _metrics.SpinsSucceeded,
					SpinsFailed = _metrics.SpinsFailed,
					SuccessRate = _metrics.SuccessRate,
					ErrorRate = _metrics.ErrorRate,
					ClaimsSucceeded = _metrics.ClaimsSucceeded,
					RenewalAttempts = _metrics.RenewalAttempts,
					RenewalSuccesses = _metrics.RenewalSuccesses,
					StaleClaims = _metrics.StaleClaims,
					CriticalFailures = _metrics.CriticalFailures,
					MemoryMB = GC.GetTotalMemory(false) / (1024.0 * 1024.0),
					MemoryGrowthMB = 0,
					PendingSignals = 0,
					CollectedAt = DateTime.UtcNow,
				};

				_snapshots.Enqueue(snapshot);

				// Keep last 2000 snapshots (>24h at 60s intervals = 1440)
				while (_snapshots.Count > 2000)
					_snapshots.TryDequeue(out _);
			}
			catch (OperationCanceledException) { break; }
			catch (Exception ex)
			{
				Console.WriteLine($"[BurnInMonitor] Collection error: {ex.Message}");
			}
		}
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;
		_cts?.Cancel();
		_cts?.Dispose();
	}
}
