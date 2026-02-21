using P4NTH30N.C0MMON;
using P4NTH30N.H4ND.Parallel;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// MON-058: Evaluates burn-in metrics against configurable thresholds.
/// Returns alerts at INFO/WARN/CRITICAL severity levels.
/// CRITICAL alerts trigger immediate halt.
/// </summary>
public sealed class BurnInAlertEvaluator
{
	private readonly BurnInAlertConfig _config;
	private readonly IUnitOfWork _uow;
	private int _consecutiveHighErrorChecks;
	private long _initialMemoryBytes;
	private DateTime _startedAt;
	private readonly List<BurnInAlert> _alertHistory = [];

	public IReadOnlyList<BurnInAlert> AlertHistory => _alertHistory;

	public BurnInAlertEvaluator(BurnInAlertConfig config, IUnitOfWork uow)
	{
		_config = config;
		_uow = uow;
		_initialMemoryBytes = GC.GetTotalMemory(false);
		_startedAt = DateTime.UtcNow;
	}

	/// <summary>
	/// Evaluates current metrics and returns all triggered alerts.
	/// If any alert is CRITICAL, the caller should halt the burn-in.
	/// </summary>
	public List<BurnInAlert> Evaluate(ParallelMetrics metrics, BurnInMetricsSnapshot snapshot)
	{
		List<BurnInAlert> alerts = [];

		// --- CRITICAL checks ---

		// Signal duplication
		if (_config.HaltOnDuplication)
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
					alerts.Add(BurnInAlert.Critical("Duplication",
						$"Signal duplication detected: {dupes.Count} duplicate groups (e.g. {dupes[0].Key} x{dupes[0].Count()})"));
				}
			}
			catch { /* non-fatal query error */ }
		}

		// Error rate critical (sustained)
		if (metrics.SpinsAttempted > 10)
		{
			double errorRateFraction = metrics.ErrorRate / 100.0; // ErrorRate is in %
			if (errorRateFraction > _config.ErrorRateCriticalThreshold)
			{
				_consecutiveHighErrorChecks++;
				if (_consecutiveHighErrorChecks >= _config.ErrorRateWarnConsecutiveChecks)
				{
					alerts.Add(BurnInAlert.Critical("ErrorRate",
						$"Error rate {errorRateFraction:P1} exceeded {_config.ErrorRateCriticalThreshold:P0} for {_consecutiveHighErrorChecks} consecutive checks",
						errorRateFraction, _config.ErrorRateCriticalThreshold));
				}
			}
			else
			{
				_consecutiveHighErrorChecks = 0;
			}
		}

		// Memory critical
		long currentMem = GC.GetTotalMemory(false);
		double currentMemMB = currentMem / (1024.0 * 1024.0);
		if (currentMemMB > _config.MemoryCriticalThresholdMB)
		{
			alerts.Add(BurnInAlert.Critical("Memory",
				$"Memory usage {currentMemMB:F0}MB exceeds {_config.MemoryCriticalThresholdMB}MB threshold",
				currentMemMB, _config.MemoryCriticalThresholdMB));
		}

		// Chrome restart critical
		if (metrics.WorkerRestarts > _config.ChromeRestartCriticalCount)
		{
			alerts.Add(BurnInAlert.Critical("ChromeRestarts",
				$"Chrome/worker restarts {metrics.WorkerRestarts} exceeded {_config.ChromeRestartCriticalCount} threshold",
				metrics.WorkerRestarts, _config.ChromeRestartCriticalCount));
		}

		// Worker deadlock detection
		if (_config.HaltOnWorkerDeadlock)
		{
			var workerStats = metrics.GetWorkerStats();
			bool allStale = workerStats.Count > 0 && workerStats.Values.All(w =>
				w.LastSpinAt.HasValue && (DateTime.UtcNow - w.LastSpinAt.Value).TotalMinutes > _config.WorkerDeadlockMinutes);
			if (allStale && metrics.SpinsAttempted > 0)
			{
				alerts.Add(BurnInAlert.Critical("WorkerDeadlock",
					$"All workers stale for >{_config.WorkerDeadlockMinutes} minutes — potential deadlock"));
			}
		}

		// --- WARN checks ---

		// Error rate warn (not yet critical)
		if (metrics.SpinsAttempted > 10 && alerts.All(a => a.Category != "ErrorRate"))
		{
			double errorRateFraction = metrics.ErrorRate / 100.0;
			if (errorRateFraction > _config.ErrorRateWarnThreshold)
			{
				alerts.Add(BurnInAlert.Warn("ErrorRate",
					$"Error rate {errorRateFraction:P1} above {_config.ErrorRateWarnThreshold:P0} warn threshold",
					errorRateFraction, _config.ErrorRateWarnThreshold));
			}
		}

		// Memory growth warn
		double elapsedHours = (DateTime.UtcNow - _startedAt).TotalHours;
		if (elapsedHours > 0)
		{
			double growthMB = (currentMem - _initialMemoryBytes) / (1024.0 * 1024.0);
			double growthPerHour = growthMB / elapsedHours;
			if (growthPerHour > _config.MemoryGrowthWarnMBPerHour)
			{
				alerts.Add(BurnInAlert.Warn("MemoryGrowth",
					$"Memory growing at {growthPerHour:F1}MB/hr (threshold: {_config.MemoryGrowthWarnMBPerHour}MB/hr)",
					growthPerHour, _config.MemoryGrowthWarnMBPerHour));
			}
		}

		// Chrome restart warn
		if (metrics.WorkerRestarts >= _config.ChromeRestartWarnCount && metrics.WorkerRestarts <= _config.ChromeRestartCriticalCount)
		{
			alerts.Add(BurnInAlert.Warn("ChromeRestarts",
				$"Chrome/worker restarts at {metrics.WorkerRestarts} (warn threshold: {_config.ChromeRestartWarnCount})",
				metrics.WorkerRestarts, _config.ChromeRestartWarnCount));
		}

		// Signal backlog warn
		if (snapshot.PendingSignals > _config.SignalBacklogWarnCount)
		{
			alerts.Add(BurnInAlert.Warn("SignalBacklog",
				$"Signal backlog {snapshot.PendingSignals} > {_config.SignalBacklogWarnCount} threshold",
				snapshot.PendingSignals, _config.SignalBacklogWarnCount));
		}

		// --- INFO checks ---

		// Renewal success
		if (metrics.RenewalSuccesses > 0)
		{
			alerts.Add(BurnInAlert.Info("Renewal", $"Session renewal successes: {metrics.RenewalSuccesses}"));
		}

		// Selector fallback
		if (metrics.SelectorFallbacks > 0)
		{
			alerts.Add(BurnInAlert.Info("SelectorFallback", $"Selector fallbacks used: {metrics.SelectorFallbacks}"));
		}

		// Store in history
		_alertHistory.AddRange(alerts.Where(a => a.Severity != AlertSeverity.Info));

		return alerts;
	}

	/// <summary>
	/// Checks if any alert in the list requires an immediate halt.
	/// </summary>
	public static bool RequiresHalt(List<BurnInAlert> alerts) =>
		alerts.Any(a => a.RequiresHalt);

	/// <summary>
	/// Gets the halt reason from critical alerts, or null if no halt needed.
	/// </summary>
	public static string? GetHaltReason(List<BurnInAlert> alerts)
	{
		var critical = alerts.Where(a => a.RequiresHalt).ToList();
		if (critical.Count == 0) return null;
		return string.Join("; ", critical.Select(a => a.Message));
	}

	/// <summary>
	/// MON-058: Generates recommendations based on alert patterns.
	/// </summary>
	public List<string> GenerateRecommendations(List<BurnInAlert> alerts, ParallelMetrics metrics)
	{
		List<string> recs = [];

		if (alerts.Any(a => a.Category == "ErrorRate" && a.Severity == AlertSeverity.Critical))
		{
			recs.Add("Investigate platform stability — high error rate sustained");
			if (metrics.GetWorkerStats().Count > 3)
				recs.Add($"Consider reducing worker count from {metrics.GetWorkerStats().Count} to {Math.Max(2, metrics.GetWorkerStats().Count / 2)}");
		}

		if (alerts.Any(a => a.Category == "Memory"))
		{
			recs.Add("Memory threshold exceeded — check for resource leaks in CDP connections");
			recs.Add("Consider restarting with fewer workers or shorter burn-in duration");
		}

		if (alerts.Any(a => a.Category == "ChromeRestarts"))
		{
			recs.Add("Chrome instability detected — verify Chrome version and available memory");
			recs.Add("Check CDP lifecycle configuration (CdpLifecycle:MaxAutoRestarts)");
		}

		if (alerts.Any(a => a.Category == "Duplication"))
		{
			recs.Add("Signal duplication is critical — review atomic claim logic in Repositories.cs");
			recs.Add("Check for stale claims that were not properly released");
		}

		if (alerts.Any(a => a.Category == "WorkerDeadlock"))
		{
			recs.Add("All workers appear stalled — check platform connectivity and credential availability");
			recs.Add("Verify MongoDB connection is responsive");
		}

		if (alerts.Any(a => a.Category == "SignalBacklog"))
		{
			recs.Add("Processing is slower than signal generation — consider increasing worker count");
		}

		if (recs.Count == 0)
			recs.Add("No specific recommendations — burn-in is operating within thresholds");

		return recs;
	}
}
