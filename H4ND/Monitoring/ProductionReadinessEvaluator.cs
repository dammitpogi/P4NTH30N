using P4NTH30N.H4ND.Parallel;

namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// Phase 8: Evaluates burn-in/performance readiness and emits go/no-go verdict.
/// </summary>
public static class ProductionReadinessEvaluator
{
	public static ProductionReadinessReport Evaluate(ParallelMetrics metrics, ParallelConfig config, TimeSpan soakDuration)
	{
		ArgumentNullException.ThrowIfNull(metrics);
		ArgumentNullException.ThrowIfNull(config);

		if (soakDuration <= TimeSpan.Zero)
		{
			throw new ArgumentOutOfRangeException(nameof(soakDuration), soakDuration, "Soak duration must be positive.");
		}

		var failures = new List<string>();
		if (metrics.P95SpinLatencyMs > config.TargetP95LatencyMs)
		{
			failures.Add($"p95 latency {metrics.P95SpinLatencyMs:F0}ms > target {config.TargetP95LatencyMs:F0}ms");
		}

		if (metrics.SpinsPerMinute < config.TargetThroughputPerMinute)
		{
			failures.Add($"throughput {metrics.SpinsPerMinute:F2}/min < target {config.TargetThroughputPerMinute:F2}/min");
		}

		if (metrics.CriticalFailures > 0)
		{
			failures.Add($"critical failures detected: {metrics.CriticalFailures}");
		}

		if (soakDuration < TimeSpan.FromHours(24))
		{
			failures.Add($"soak duration {soakDuration} < required 24:00:00");
		}

		return new ProductionReadinessReport
		{
			IsGo = failures.Count == 0,
			P95LatencyMs = metrics.P95SpinLatencyMs,
			TargetP95LatencyMs = config.TargetP95LatencyMs,
			ThroughputPerMinute = metrics.SpinsPerMinute,
			TargetThroughputPerMinute = config.TargetThroughputPerMinute,
			FailureMatrix = metrics.GetFailureMatrix(),
			FailedChecks = failures,
		};
	}
}

public sealed class ProductionReadinessReport
{
	public bool IsGo { get; init; }
	public double P95LatencyMs { get; init; }
	public double TargetP95LatencyMs { get; init; }
	public double ThroughputPerMinute { get; init; }
	public double TargetThroughputPerMinute { get; init; }
	public IReadOnlyDictionary<string, long> FailureMatrix { get; init; } = new Dictionary<string, long>();
	public IReadOnlyList<string> FailedChecks { get; init; } = Array.Empty<string>();
}
