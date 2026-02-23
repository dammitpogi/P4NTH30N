using System.Collections.Concurrent;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// ARCH-047: Thread-safe metrics collection for parallel signal processing.
/// Tracks claims, spins, errors, and worker health across all workers.
/// </summary>
public sealed class ParallelMetrics
{
	private long _claimsSucceeded;
	private long _claimsFailed;
	private long _spinsAttempted;
	private long _spinsSucceeded;
	private long _spinsFailed;
	private long _distributorErrors;
	private long _workerRestarts;
	// ARCH-055: Self-healing metrics
	private long _renewalAttempts;
	private long _renewalSuccesses;
	private long _renewalFailures;
	private long _staleClaims;
	private long _criticalFailures;
	private long _selectorFallbacks;
	private readonly ConcurrentDictionary<string, long> _failureMatrix = new(StringComparer.OrdinalIgnoreCase);
	private readonly ConcurrentDictionary<string, WorkerStats> _workerStats = new();
	private readonly ConcurrentQueue<SpinTimingRecord> _recentSpins = new();
	private readonly DateTime _startedAt = DateTime.UtcNow;

	public long ClaimsSucceeded => Interlocked.Read(ref _claimsSucceeded);
	public long ClaimsFailed => Interlocked.Read(ref _claimsFailed);
	public long SpinsAttempted => Interlocked.Read(ref _spinsAttempted);
	public long SpinsSucceeded => Interlocked.Read(ref _spinsSucceeded);
	public long SpinsFailed => Interlocked.Read(ref _spinsFailed);
	public long DistributorErrors => Interlocked.Read(ref _distributorErrors);
	public long WorkerRestarts => Interlocked.Read(ref _workerRestarts);
	// ARCH-055: Self-healing metric accessors
	public long RenewalAttempts => Interlocked.Read(ref _renewalAttempts);
	public long RenewalSuccesses => Interlocked.Read(ref _renewalSuccesses);
	public long RenewalFailures => Interlocked.Read(ref _renewalFailures);
	public long StaleClaims => Interlocked.Read(ref _staleClaims);
	public long CriticalFailures => Interlocked.Read(ref _criticalFailures);
	public long SelectorFallbacks => Interlocked.Read(ref _selectorFallbacks);
	public TimeSpan Uptime => DateTime.UtcNow - _startedAt;

	public double SuccessRate =>
		SpinsAttempted > 0 ? (double)SpinsSucceeded / SpinsAttempted * 100.0 : 0;

	public double SpinsPerMinute =>
		Uptime.TotalMinutes > 0 ? SpinsSucceeded / Uptime.TotalMinutes : 0;

	public double P95SpinLatencyMs
	{
		get
		{
			var values = _recentSpins.ToArray().Select(x => x.ElapsedMs).OrderBy(x => x).ToArray();
			if (values.Length == 0)
			{
				return 0;
			}

			var index = (int)Math.Ceiling(values.Length * 0.95) - 1;
			index = Math.Clamp(index, 0, values.Length - 1);
			return values[index];
		}
	}

	public void RecordClaimSuccess() => Interlocked.Increment(ref _claimsSucceeded);

	public void RecordClaimFailure(string reason)
	{
		Interlocked.Increment(ref _claimsFailed);
	}

	public void RecordDistributorError(string message)
	{
		Interlocked.Increment(ref _distributorErrors);
	}

	public void RecordSpinResult(string workerId, bool success, TimeSpan elapsed, string? error = null)
	{
		Interlocked.Increment(ref _spinsAttempted);
		if (success)
			Interlocked.Increment(ref _spinsSucceeded);
		else
			Interlocked.Increment(ref _spinsFailed);

		var stats = _workerStats.GetOrAdd(workerId, _ => new WorkerStats());
		stats.RecordSpin(success, DateTime.UtcNow, error);

		if (!success)
		{
			var reason = ClassifyFailure(error);
			_failureMatrix.AddOrUpdate(reason, 1, (_, current) => current + 1);
		}

		_recentSpins.Enqueue(new SpinTimingRecord
		{
			WorkerId = workerId,
			Success = success,
			ElapsedMs = elapsed.TotalMilliseconds,
			Timestamp = DateTime.UtcNow,
		});

		// Keep only last 1000 records
		while (_recentSpins.Count > 1000)
			_recentSpins.TryDequeue(out _);
	}

	public void RecordWorkerError(string workerId, string message)
	{
		var stats = _workerStats.GetOrAdd(workerId, _ => new WorkerStats());
		stats.RecordError(message);
	}

	public void RecordWorkerRestart(string workerId)
	{
		Interlocked.Increment(ref _workerRestarts);
		var stats = _workerStats.GetOrAdd(workerId, _ => new WorkerStats());
		stats.RecordRestart();
	}

	// ARCH-055: Self-healing metric recording
	public void IncrementRenewalAttempts() => Interlocked.Increment(ref _renewalAttempts);
	public void IncrementRenewalSuccesses() => Interlocked.Increment(ref _renewalSuccesses);
	public void IncrementRenewalFailures() => Interlocked.Increment(ref _renewalFailures);
	public void IncrementStaleClaims() => Interlocked.Increment(ref _staleClaims);
	public void IncrementCriticalFailures() => Interlocked.Increment(ref _criticalFailures);
	public void IncrementSelectorFallbacks() => Interlocked.Increment(ref _selectorFallbacks);

	public IReadOnlyDictionary<string, WorkerStats> GetWorkerStats() =>
		new Dictionary<string, WorkerStats>(_workerStats);

	public IReadOnlyDictionary<string, long> GetFailureMatrix() =>
		new Dictionary<string, long>(_failureMatrix);

	/// <summary>
	/// Average spin latency from last 100 spins (ms).
	/// </summary>
	public double AverageSpinLatencyMs
	{
		get
		{
			var recent = _recentSpins.ToArray().TakeLast(100).ToArray();
			return recent.Length > 0 ? recent.Average(r => r.ElapsedMs) : 0;
		}
	}

	/// <summary>
	/// ARCH-055: Error rate as percentage of total spins attempted.
	/// </summary>
	public double ErrorRate =>
		SpinsAttempted > 0 ? (double)SpinsFailed / SpinsAttempted * 100.0 : 0;

	public string GetSummary()
	{
		return $"[ParallelMetrics] Uptime={Uptime:hh\\:mm\\:ss} " +
			$"Claims={ClaimsSucceeded}/{ClaimsSucceeded + ClaimsFailed} " +
			$"Spins={SpinsSucceeded}/{SpinsAttempted} ({SuccessRate:F1}%) " +
			$"Rate={SpinsPerMinute:F1}/min " +
			$"AvgLatency={AverageSpinLatencyMs:F0}ms P95={P95SpinLatencyMs:F0}ms " +
			$"Restarts={WorkerRestarts} DistErrors={DistributorErrors} " +
			$"Renewals={RenewalSuccesses}/{RenewalAttempts} " +
			$"StaleClaims={StaleClaims} Critical={CriticalFailures}";
	}

	private static string ClassifyFailure(string? error)
	{
		if (string.IsNullOrWhiteSpace(error))
		{
			return "unknown";
		}

		var normalized = error.Trim().ToLowerInvariant();
		if (normalized.Contains("login")) return "login_failed";
		if (normalized.Contains("auth") || normalized.Contains("401") || normalized.Contains("403")) return "auth_failure";
		if (normalized.Contains("timeout")) return "timeout";
		if (normalized.Contains("spin")) return "spin_failed";
		if (normalized.Contains("cdp")) return "cdp_failure";
		return "other";
	}
}

public sealed class WorkerStats
{
	private int _totalSpins;
	private int _successfulSpins;
	private int _errors;
	private int _restarts;
	private long _lastSpinAtTicks;
	private string? _lastError;

	public int TotalSpins => Interlocked.CompareExchange(ref _totalSpins, 0, 0);
	public int SuccessfulSpins => Interlocked.CompareExchange(ref _successfulSpins, 0, 0);
	public int Errors => Interlocked.CompareExchange(ref _errors, 0, 0);
	public int Restarts => Interlocked.CompareExchange(ref _restarts, 0, 0);
	public DateTime? LastSpinAt
	{
		get
		{
			long ticks = Interlocked.Read(ref _lastSpinAtTicks);
			return ticks == 0 ? null : new DateTime(ticks, DateTimeKind.Utc);
		}
	}
	public string? LastError => Volatile.Read(ref _lastError);

	public void IncrementTotalSpins() => Interlocked.Increment(ref _totalSpins);
	public void IncrementSuccessfulSpins() => Interlocked.Increment(ref _successfulSpins);

	public void RecordSpin(bool success, DateTime spinAtUtc, string? error)
	{
		Interlocked.Increment(ref _totalSpins);
		if (success)
		{
			Interlocked.Increment(ref _successfulSpins);
		}

		Interlocked.Exchange(ref _lastSpinAtTicks, spinAtUtc.Ticks);
		Volatile.Write(ref _lastError, error);
	}

	public void RecordError(string message)
	{
		Interlocked.Increment(ref _errors);
		Volatile.Write(ref _lastError, message);
	}

	public void RecordRestart()
	{
		Interlocked.Increment(ref _restarts);
	}
}

public sealed class SpinTimingRecord
{
	public string WorkerId { get; init; } = string.Empty;
	public bool Success { get; init; }
	public double ElapsedMs { get; init; }
	public DateTime Timestamp { get; init; }
}
