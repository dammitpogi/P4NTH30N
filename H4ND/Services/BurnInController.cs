using System.Diagnostics;
using System.Text.Json;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Monitoring;
using P4NTH30N.H4ND.Parallel;

namespace P4NTH30N.H4ND.Services;

/// <summary>
/// ARCH-055-006: 24-hour automated burn-in validation orchestrator.
/// Manages the full lifecycle: pre-flight → signal generation → parallel engine → metrics → summary.
/// Halts on critical failures (duplication, error rate spikes).
/// </summary>
public sealed class BurnInController
{
	private readonly IUnitOfWork _uow;
	private readonly CdpConfig _cdpConfig;
	private readonly ParallelConfig _parallelConfig;
	private readonly BurnInConfig _burnInConfig;
	private readonly SessionRenewalService _renewalService;
	private readonly GameSelectorConfig _selectorConfig;
	private readonly ICdpLifecycleManager? _cdpLifecycle;
	private readonly BurnInAlertConfig _alertConfig;
	private readonly List<BurnInMetricsSnapshot> _snapshots = [];
	private long _initialMemoryBytes;
	private int _consecutiveHighErrorChecks;

	// MON-057/058/059: Monitoring, alerting, and completion automation
	private BurnInMonitor? _monitor;
	private BurnInAlertEvaluator? _alertEvaluator;
	private AlertNotificationDispatcher? _alertDispatcher;
	private BurnInDashboardServer? _dashboardServer;

	public IReadOnlyList<BurnInMetricsSnapshot> Snapshots => _snapshots;
	public BurnInMonitor? Monitor => _monitor;

	public BurnInController(
		IUnitOfWork uow,
		CdpConfig cdpConfig,
		ParallelConfig parallelConfig,
		BurnInConfig burnInConfig,
		SessionRenewalService renewalService,
		GameSelectorConfig selectorConfig,
		ICdpLifecycleManager? cdpLifecycle = null,
		BurnInAlertConfig? alertConfig = null)
	{
		_uow = uow;
		_cdpConfig = cdpConfig;
		_parallelConfig = parallelConfig;
		_burnInConfig = burnInConfig;
		_renewalService = renewalService;
		_selectorConfig = selectorConfig;
		_cdpLifecycle = cdpLifecycle;
		_alertConfig = alertConfig ?? new BurnInAlertConfig();
	}

	/// <summary>
	/// Runs the full burn-in validation cycle.
	/// </summary>
	public async Task RunAsync(CancellationToken ct)
	{
		Stopwatch totalSw = Stopwatch.StartNew();
		TimeSpan duration = TimeSpan.FromHours(_burnInConfig.DurationHours);
		_initialMemoryBytes = GC.GetTotalMemory(false);

		Console.WriteLine("╔══════════════════════════════════════════════════════════╗");
		Console.WriteLine("║          BURN-IN VALIDATION — ARCH-055-006              ║");
		Console.WriteLine($"║  Duration: {_burnInConfig.DurationHours}h | Workers: {_parallelConfig.WorkerCount} | Interval: {_burnInConfig.MetricsIntervalSeconds}s  ║");
		Console.WriteLine("╚══════════════════════════════════════════════════════════╝\n");

		// Phase 1: Pre-flight checks
		Console.WriteLine("[BurnIn] Phase 1: Pre-flight checks...");
		if (!await RunPreflightChecksAsync(ct))
		{
			Console.WriteLine("[BurnIn] FAILED — Pre-flight checks did not pass. Aborting.");
			return;
		}
		Console.WriteLine("[BurnIn] Pre-flight: PASS\n");

		// Phase 2: Ensure signals exist
		Console.WriteLine("[BurnIn] Phase 2: Checking SIGN4L population...");
		EnsureSignalsPopulated();
		Console.WriteLine();

		// MON-057: Initialize monitoring services
		Console.WriteLine("[BurnIn] Phase 2b: Starting monitoring services...");
		_monitor = new BurnInMonitor(_uow, _burnInConfig);
		_alertEvaluator = new BurnInAlertEvaluator(_alertConfig, _uow);
		_alertDispatcher = new AlertNotificationDispatcher(_alertConfig, _monitor);
		_dashboardServer = new BurnInDashboardServer(_monitor, 5002);

		try { _dashboardServer.Start(); }
		catch (Exception ex) { Console.WriteLine($"[BurnIn] Dashboard server failed to start: {ex.Message}"); }

		// Phase 3: Start parallel engine
		Console.WriteLine("[BurnIn] Phase 3: Starting parallel engine...");
		using var engine = new ParallelH4NDEngine(_uow, _cdpConfig, _parallelConfig, _renewalService, _selectorConfig, _cdpLifecycle);

		// MON-057: Attach monitor to engine metrics
		_monitor.AttachEngine(engine.Metrics, _cdpLifecycle);
		_monitor.Start();

		var engineTask = Task.Run(() => engine.RunAsync(ct), ct);

		// Phase 4: Metrics collection loop
		Console.WriteLine("[BurnIn] Phase 4: Entering metrics collection loop...\n");
		string? haltReason = null;

		try
		{
			while (!ct.IsCancellationRequested && totalSw.Elapsed < duration)
			{
				await Task.Delay(TimeSpan.FromSeconds(_burnInConfig.MetricsIntervalSeconds), ct);

				// Collect metrics snapshot
				var snapshot = CollectSnapshot(engine.Metrics, totalSw.Elapsed);
				_snapshots.Add(snapshot);

				Console.WriteLine($"[BurnIn] Snapshot #{_snapshots.Count}: {snapshot}");

				// MON-058: Evaluate alerts against configurable thresholds
				if (_alertEvaluator != null && _alertDispatcher != null)
				{
					var alerts = _alertEvaluator.Evaluate(engine.Metrics, snapshot);
					_alertDispatcher.Dispatch(alerts);

					foreach (var alert in alerts.Where(a => a.Severity != AlertSeverity.Info))
						_monitor?.RecordError(alert.Category, alert.Severity != AlertSeverity.Critical);

					if (BurnInAlertEvaluator.RequiresHalt(alerts))
					{
						haltReason = BurnInAlertEvaluator.GetHaltReason(alerts);
						Console.WriteLine($"\n[BurnIn] CRITICAL HALT: {haltReason}");

						// MON-058: Diagnostic dump + recommendations
						var recommendations = _alertEvaluator.GenerateRecommendations(alerts, engine.Metrics);
						var diagnostics = new BurnInHaltDiagnostics(_uow);
						var dump = diagnostics.Capture(_monitor!.SessionId, haltReason!, engine.Metrics, snapshot, alerts, recommendations, totalSw.Elapsed);
						diagnostics.SaveToFile(dump);
						break;
					}
				}

				// Legacy halt conditions (fallback)
				haltReason = CheckHaltConditions(snapshot, engine.Metrics);
				if (haltReason != null)
				{
					Console.WriteLine($"\n[BurnIn] HALT CONDITION TRIGGERED: {haltReason}");
					break;
				}

				// Auto-refill signals if needed
				int pendingSignals = _uow.Signals.GetAll().Count(s => !s.Acknowledged && s.ClaimedBy == null);
				if (_burnInConfig.AutoGenerateSignals && pendingSignals < _burnInConfig.RefillThreshold)
				{
					Console.WriteLine($"[BurnIn] Signal refill: {pendingSignals} pending < {_burnInConfig.RefillThreshold} threshold");
					SignalGenerator gen = new(_uow);
					var refillResult = gen.Generate(_burnInConfig.RefillCount);
					Console.WriteLine($"[BurnIn] Refilled: {refillResult.Inserted} signals");
				}
			}
		}
		catch (OperationCanceledException)
		{
			Console.WriteLine("[BurnIn] Cancelled by user");
		}

		// Phase 5: Shutdown and report
		Console.WriteLine("\n[BurnIn] Phase 5: Shutting down engine...");
		engine.Stop();

		try
		{
			await Task.WhenAny(engineTask, Task.Delay(TimeSpan.FromSeconds(30), CancellationToken.None));
		}
		catch { /* Shutdown timeout is non-fatal */ }

		totalSw.Stop();

		// Stop monitoring services
		_monitor?.Stop(haltReason != null ? "Halted" : "Completed");
		_dashboardServer?.Stop();

		// Generate summary
		BurnInSummary summary = GenerateSummary(engine.Metrics, totalSw.Elapsed, haltReason);
		OutputSummary(summary);

		// AUTO-059: Post-burn-in completion analysis and decision promotion
		Console.WriteLine("\n[BurnIn] Phase 6: Post-burn-in analysis (AUTO-059)...");
		try
		{
			var analyzer = new BurnInCompletionAnalyzer();
			var completionReport = analyzer.Analyze(summary, _snapshots, _burnInConfig.DurationHours);

			// Save JSON + Markdown reports
			BurnInCompletionAnalyzer.SaveReports(completionReport);

			// Promote decisions on PASS
			var promoter = new DecisionPromoter();
			var promotionResult = promoter.PromoteOnPass(completionReport);
			Console.WriteLine(promotionResult.ToString());

			Console.WriteLine($"[BurnIn] Completion result: {completionReport.Result}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[BurnIn] AUTO-059 completion analysis failed (non-fatal): {ex.Message}");
		}
	}

	/// <summary>
	/// Pre-flight: verify CDP, MongoDB, and at least one platform.
	/// </summary>
	private async Task<bool> RunPreflightChecksAsync(CancellationToken ct)
	{
		bool allOk = true;

		// AUTO-056: Ensure Chrome CDP is available (auto-start if needed)
		if (_cdpLifecycle != null)
		{
			try
			{
				bool cdpReady = await _cdpLifecycle.EnsureAvailableAsync(ct);
				Console.WriteLine($"  CDP Lifecycle: {(cdpReady ? "OK" : "FAILED")} — {_cdpLifecycle.GetLifecycleStatus()}");
				if (!cdpReady) allOk = false;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  CDP Lifecycle: FAILED — {ex.Message}");
				allOk = false;
			}
		}

		// CDP check
		try
		{
			CdpHealthCheck cdpCheck = new(_cdpConfig);
			var status = await cdpCheck.CheckHealthAsync(ct);
			Console.WriteLine($"  CDP: {(status.IsHealthy ? "OK" : "FAILED")} — {status.Summary}");
			if (!status.IsHealthy) allOk = false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  CDP: FAILED — {ex.Message}");
			allOk = false;
		}

		// MongoDB check
		try
		{
			int credCount = _uow.Credentials.GetAll().Count;
			Console.WriteLine($"  MongoDB: OK — {credCount} credentials found");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  MongoDB: FAILED — {ex.Message}");
			allOk = false;
		}

		// Platform checks
		try
		{
			var fk = await _renewalService.ProbePlatformAsync("FireKirin", ct);
			var os = await _renewalService.ProbePlatformAsync("OrionStars", ct);
			Console.WriteLine($"  FireKirin: {(fk.IsReachable ? "OK" : "UNREACHABLE")} (HTTP {fk.StatusCode})");
			Console.WriteLine($"  OrionStars: {(os.IsReachable ? "OK" : "UNREACHABLE")} (HTTP {os.StatusCode})");

			if (!fk.IsReachable && !os.IsReachable)
			{
				Console.WriteLine("  ⚠️ No platforms reachable — burn-in may fail");
				allOk = false;
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  Platform check: FAILED — {ex.Message}");
			allOk = false;
		}

		return allOk;
	}

	/// <summary>
	/// Ensures SIGN4L has signals; auto-generates if empty and configured.
	/// </summary>
	private void EnsureSignalsPopulated()
	{
		int signalCount = _uow.Signals.GetAll().Count(s => !s.Acknowledged);
		Console.WriteLine($"[BurnIn] Current SIGN4L: {signalCount} unacknowledged signals");

		if (signalCount == 0 && _burnInConfig.AutoGenerateSignals)
		{
			Console.WriteLine($"[BurnIn] Auto-generating {_burnInConfig.AutoGenerateCount} signals...");
			SignalGenerator gen = new(_uow);
			var result = gen.Generate(_burnInConfig.AutoGenerateCount);
			Console.WriteLine($"[BurnIn] Generated: {result}");
		}
		else if (signalCount == 0)
		{
			Console.WriteLine("[BurnIn] WARNING: SIGN4L is empty and auto-generation is disabled");
		}
	}

	/// <summary>
	/// Collects a metrics snapshot at the current point in time.
	/// </summary>
	private BurnInMetricsSnapshot CollectSnapshot(ParallelMetrics metrics, TimeSpan elapsed)
	{
		long currentMemory = GC.GetTotalMemory(false);
		int pendingSignals = 0;

		try
		{
			pendingSignals = _uow.Signals.GetAll().Count(s => !s.Acknowledged && s.ClaimedBy == null);
		}
		catch { /* MongoDB error is non-fatal for snapshot */ }

		return new BurnInMetricsSnapshot
		{
			ElapsedMinutes = elapsed.TotalMinutes,
			SpinsAttempted = metrics.SpinsAttempted,
			SpinsSucceeded = metrics.SpinsSucceeded,
			SpinsFailed = metrics.SpinsFailed,
			SuccessRate = metrics.SuccessRate,
			ErrorRate = metrics.ErrorRate,
			ClaimsSucceeded = metrics.ClaimsSucceeded,
			RenewalAttempts = metrics.RenewalAttempts,
			RenewalSuccesses = metrics.RenewalSuccesses,
			StaleClaims = metrics.StaleClaims,
			CriticalFailures = metrics.CriticalFailures,
			MemoryMB = currentMemory / (1024.0 * 1024.0),
			MemoryGrowthMB = (currentMemory - _initialMemoryBytes) / (1024.0 * 1024.0),
			PendingSignals = pendingSignals,
			CollectedAt = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Checks if any halt condition is triggered. Returns reason string or null.
	/// </summary>
	private string? CheckHaltConditions(BurnInMetricsSnapshot snapshot, ParallelMetrics metrics)
	{
		// Check: signal duplication (same credential has >1 unacknowledged signal)
		if (_burnInConfig.HaltOnDuplication)
		{
			try
			{
				var signals = _uow.Signals.GetAll().Where(s => !s.Acknowledged).ToList();
				var dupes = signals
					.GroupBy(s => $"{s.House}:{s.Game}:{s.Username}")
					.Where(g => g.Count() > 1)
					.ToList();

				if (dupes.Count > 0)
				{
					return $"Signal duplication detected: {dupes.Count} duplicate groups " +
						$"(e.g. {dupes.First().Key} x{dupes.First().Count()})";
				}
			}
			catch { /* Non-fatal */ }
		}

		// Check: error rate sustained above threshold (3 consecutive checks)
		if (metrics.SpinsAttempted > 10)
		{
			if (snapshot.ErrorRate > _burnInConfig.HaltOnErrorRatePercent)
			{
				_consecutiveHighErrorChecks++;
				Console.WriteLine($"[BurnIn] High error rate: {snapshot.ErrorRate:F1}% (check {_consecutiveHighErrorChecks}/3)");

				if (_consecutiveHighErrorChecks >= 3)
				{
					return $"Error rate sustained above {_burnInConfig.HaltOnErrorRatePercent}% for 3 consecutive checks ({snapshot.ErrorRate:F1}%)";
				}
			}
			else
			{
				_consecutiveHighErrorChecks = 0;
			}
		}

		// Warn: memory growth
		if (snapshot.MemoryGrowthMB > _burnInConfig.WarnOnMemoryGrowthMB)
		{
			Console.WriteLine($"[BurnIn] ⚠️ Memory growth: {snapshot.MemoryGrowthMB:F1}MB > {_burnInConfig.WarnOnMemoryGrowthMB}MB threshold");
		}

		// Warn: stranded credentials
		try
		{
			int stranded = _uow.Credentials.GetAll().Count(c => !c.Unlocked);
			if (stranded > 0)
			{
				Console.WriteLine($"[BurnIn] ⚠️ Stranded credentials: {stranded} — auto-unlocking...");
				foreach (var cred in _uow.Credentials.GetAll().Where(c => !c.Unlocked))
				{
					_uow.Credentials.Unlock(cred);
				}
			}
		}
		catch { /* Non-fatal */ }

		return null;
	}

	/// <summary>
	/// Generates the final burn-in summary report.
	/// </summary>
	private BurnInSummary GenerateSummary(ParallelMetrics metrics, TimeSpan totalElapsed, string? haltReason)
	{
		long finalMemory = GC.GetTotalMemory(false);

		return new BurnInSummary
		{
			Result = haltReason == null ? "PASS" : "FAIL",
			HaltReason = haltReason,
			TotalDuration = totalElapsed,
			SnapshotsCollected = _snapshots.Count,
			TotalSpinsAttempted = metrics.SpinsAttempted,
			TotalSpinsSucceeded = metrics.SpinsSucceeded,
			TotalSpinsFailed = metrics.SpinsFailed,
			FinalSuccessRate = metrics.SuccessRate,
			FinalErrorRate = metrics.ErrorRate,
			TotalRenewalAttempts = metrics.RenewalAttempts,
			TotalRenewalSuccesses = metrics.RenewalSuccesses,
			TotalStaleClaims = metrics.StaleClaims,
			TotalCriticalFailures = metrics.CriticalFailures,
			WorkerRestarts = metrics.WorkerRestarts,
			InitialMemoryMB = _initialMemoryBytes / (1024.0 * 1024.0),
			FinalMemoryMB = finalMemory / (1024.0 * 1024.0),
			MemoryGrowthMB = (finalMemory - _initialMemoryBytes) / (1024.0 * 1024.0),
			CompletedAt = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Outputs the summary to console.
	/// </summary>
	private static void OutputSummary(BurnInSummary summary)
	{
		Console.WriteLine("\n╔══════════════════════════════════════════════════════════╗");
		Console.WriteLine($"║          BURN-IN SUMMARY — {summary.Result,-30}  ║");
		Console.WriteLine("╠══════════════════════════════════════════════════════════╣");
		Console.WriteLine($"║  Duration:        {summary.TotalDuration:hh\\:mm\\:ss}");
		Console.WriteLine($"║  Snapshots:       {summary.SnapshotsCollected}");
		Console.WriteLine($"║  Spins:           {summary.TotalSpinsSucceeded}/{summary.TotalSpinsAttempted} ({summary.FinalSuccessRate:F1}%)");
		Console.WriteLine($"║  Error Rate:      {summary.FinalErrorRate:F1}%");
		Console.WriteLine($"║  Renewals:        {summary.TotalRenewalSuccesses}/{summary.TotalRenewalAttempts}");
		Console.WriteLine($"║  Stale Claims:    {summary.TotalStaleClaims}");
		Console.WriteLine($"║  Critical:        {summary.TotalCriticalFailures}");
		Console.WriteLine($"║  Worker Restarts: {summary.WorkerRestarts}");
		Console.WriteLine($"║  Memory Growth:   {summary.MemoryGrowthMB:F1}MB");

		if (summary.HaltReason != null)
		{
			Console.WriteLine($"║  Halt Reason:     {summary.HaltReason}");
		}

		Console.WriteLine("╚══════════════════════════════════════════════════════════╝");

		// Also output JSON
		string json = JsonSerializer.Serialize(summary, new JsonSerializerOptions { WriteIndented = true });
		Console.WriteLine($"\n{json}");
	}
}

/// <summary>
/// ARCH-055-006: Metrics snapshot taken during burn-in at each interval.
/// </summary>
public sealed class BurnInMetricsSnapshot
{
	public double ElapsedMinutes { get; init; }
	public long SpinsAttempted { get; init; }
	public long SpinsSucceeded { get; init; }
	public long SpinsFailed { get; init; }
	public double SuccessRate { get; init; }
	public double ErrorRate { get; init; }
	public long ClaimsSucceeded { get; init; }
	public long RenewalAttempts { get; init; }
	public long RenewalSuccesses { get; init; }
	public long StaleClaims { get; init; }
	public long CriticalFailures { get; init; }
	public double MemoryMB { get; init; }
	public double MemoryGrowthMB { get; init; }
	public int PendingSignals { get; init; }
	public DateTime CollectedAt { get; init; }

	public override string ToString() =>
		$"Elapsed={ElapsedMinutes:F1}m Spins={SpinsSucceeded}/{SpinsAttempted} " +
		$"Err={ErrorRate:F1}% Renewals={RenewalSuccesses}/{RenewalAttempts} " +
		$"Memory={MemoryMB:F0}MB (+{MemoryGrowthMB:F1}MB) Pending={PendingSignals}";
}

/// <summary>
/// ARCH-055-006: Final burn-in summary report.
/// </summary>
public sealed class BurnInSummary
{
	public string Result { get; init; } = "Unknown";
	public string? HaltReason { get; init; }
	public TimeSpan TotalDuration { get; init; }
	public int SnapshotsCollected { get; init; }
	public long TotalSpinsAttempted { get; init; }
	public long TotalSpinsSucceeded { get; init; }
	public long TotalSpinsFailed { get; init; }
	public double FinalSuccessRate { get; init; }
	public double FinalErrorRate { get; init; }
	public long TotalRenewalAttempts { get; init; }
	public long TotalRenewalSuccesses { get; init; }
	public long TotalStaleClaims { get; init; }
	public long TotalCriticalFailures { get; init; }
	public long WorkerRestarts { get; init; }
	public double InitialMemoryMB { get; init; }
	public double FinalMemoryMB { get; init; }
	public double MemoryGrowthMB { get; init; }
	public DateTime CompletedAt { get; init; }
}
