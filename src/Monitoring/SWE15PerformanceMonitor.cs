using System.Collections.Concurrent;
using System.Diagnostics;

namespace P4NTH30N.SWE.Monitoring;

/// <summary>
/// Performance monitoring for SWE-1.5 workflows.
/// Tracks response times, context sizes, error patterns, and triggers alerts.
/// </summary>
public sealed class SWE15PerformanceMonitor {
	private readonly PerformanceConfig _config;
	private readonly ConcurrentQueue<PerformanceMetric> _metrics = new();
	private readonly List<PerformanceAlert> _alerts = new();
	private int _currentTurn;
	private long _estimatedContextTokens;

	/// <summary>
	/// Whether performance has degraded beyond acceptable thresholds.
	/// </summary>
	public bool IsDegraded { get; private set; }

	/// <summary>
	/// Current alert count.
	/// </summary>
	public int ActiveAlertCount => _alerts.Count(a => !a.Resolved);

	public SWE15PerformanceMonitor(PerformanceConfig? config = null) {
		_config = config ?? new PerformanceConfig();
	}

	/// <summary>
	/// Records a response time metric.
	/// </summary>
	public void RecordResponseTime(string operation, long elapsedMs) {
		PerformanceMetric metric = new() {
			Timestamp = DateTime.UtcNow,
			Operation = operation,
			DurationMs = elapsedMs,
			TurnNumber = _currentTurn,
			ContextTokens = _estimatedContextTokens,
		};

		_metrics.Enqueue(metric);

		// Check thresholds
		MetricType type = ClassifyOperation(operation);
		long threshold = type switch {
			MetricType.Analysis => _config.AnalysisMaxMs,
			MetricType.Generation => _config.GenerationMaxMs,
			_ => _config.DefaultMaxMs,
		};

		if (elapsedMs > threshold) {
			RaiseAlert(AlertSeverity.Warning,
				$"Response time {elapsedMs}ms exceeds {threshold}ms threshold for {operation}");
		}

		// Trim old metrics (keep last 1000)
		while (_metrics.Count > 1000) {
			_metrics.TryDequeue(out _);
		}
	}

	/// <summary>
	/// Updates the context size estimate and checks capacity.
	/// </summary>
	public ContextStatus UpdateContextSize(long estimatedTokens) {
		_estimatedContextTokens = estimatedTokens;

		double usage = _config.MaxContextTokens > 0
			? (double)estimatedTokens / _config.MaxContextTokens
			: 0.0;

		if (usage >= 0.95) {
			RaiseAlert(AlertSeverity.Critical,
				$"Context at {usage:P0} capacity ({estimatedTokens} tokens). Session reset required.");
			return ContextStatus.MustReset;
		}

		if (usage >= 0.90) {
			RaiseAlert(AlertSeverity.Warning,
				$"Context at {usage:P0} capacity ({estimatedTokens} tokens). Compress recommended.");
			return ContextStatus.CompressNeeded;
		}

		if (usage >= 0.75) {
			return ContextStatus.Elevated;
		}

		return ContextStatus.Normal;
	}

	/// <summary>
	/// Advances the turn counter and checks session limits.
	/// </summary>
	public TurnStatus AdvanceTurn() {
		_currentTurn++;

		if (_currentTurn >= _config.HardResetTurns) {
			RaiseAlert(AlertSeverity.Critical,
				$"Turn {_currentTurn} exceeds hard limit ({_config.HardResetTurns}). Session reset required.");
			return TurnStatus.MustReset;
		}

		if (_currentTurn >= _config.SoftResetTurns) {
			RaiseAlert(AlertSeverity.Warning,
				$"Turn {_currentTurn} approaching limit ({_config.HardResetTurns}). Plan for reset.");
			return TurnStatus.ResetSoon;
		}

		return TurnStatus.Normal;
	}

	/// <summary>
	/// Records an error and checks for error pattern escalation.
	/// </summary>
	public void RecordError(string operation, string errorMessage) {
		PerformanceMetric metric = new() {
			Timestamp = DateTime.UtcNow,
			Operation = operation,
			IsError = true,
			ErrorMessage = errorMessage,
			TurnNumber = _currentTurn,
		};

		_metrics.Enqueue(metric);

		// Check for error patterns (3+ errors in last 5 turns)
		int recentErrors = _metrics
			.Where(m => m.IsError && m.TurnNumber >= _currentTurn - 5)
			.Count();

		if (recentErrors >= 3) {
			IsDegraded = true;
			RaiseAlert(AlertSeverity.Critical,
				$"Error pattern detected: {recentErrors} errors in last 5 turns");
		}
	}

	/// <summary>
	/// Gets performance summary for the current session.
	/// </summary>
	public PerformanceSummary GetSummary() {
		List<PerformanceMetric> allMetrics = _metrics.ToList();
		List<PerformanceMetric> responseMetrics = allMetrics.Where(m => !m.IsError && m.DurationMs > 0).ToList();

		return new PerformanceSummary {
			CurrentTurn = _currentTurn,
			EstimatedContextTokens = _estimatedContextTokens,
			ContextUsagePercent = _config.MaxContextTokens > 0
				? (double)_estimatedContextTokens / _config.MaxContextTokens * 100
				: 0.0,
			TotalMetrics = allMetrics.Count,
			ErrorCount = allMetrics.Count(m => m.IsError),
			AverageResponseMs = responseMetrics.Count > 0
				? responseMetrics.Average(m => m.DurationMs)
				: 0.0,
			P95ResponseMs = responseMetrics.Count > 0
				? Percentile(responseMetrics.Select(m => m.DurationMs).ToList(), 95)
				: 0.0,
			MaxResponseMs = responseMetrics.Count > 0
				? responseMetrics.Max(m => m.DurationMs)
				: 0,
			IsDegraded = IsDegraded,
			ActiveAlerts = _alerts.Where(a => !a.Resolved).ToList(),
		};
	}

	/// <summary>
	/// Estimates performance degradation based on context size.
	/// ~10-15% slower per 25K tokens above baseline.
	/// </summary>
	public double EstimateDegradation() {
		if (_estimatedContextTokens <= 50_000) return 0.0;

		long tokensAboveBaseline = _estimatedContextTokens - 50_000;
		double degradationPer25K = 0.125; // 12.5% per 25K tokens
		double degradation = (tokensAboveBaseline / 25_000.0) * degradationPer25K;

		return Math.Min(degradation, 0.5); // Cap at 50%
	}

	/// <summary>
	/// Raises a performance alert.
	/// </summary>
	private void RaiseAlert(AlertSeverity severity, string message) {
		_alerts.Add(new PerformanceAlert {
			Timestamp = DateTime.UtcNow,
			Severity = severity,
			Message = message,
			TurnNumber = _currentTurn,
		});
	}

	private static MetricType ClassifyOperation(string operation) {
		string lower = operation.ToLowerInvariant();
		if (lower.Contains("analysis") || lower.Contains("search") || lower.Contains("read")) {
			return MetricType.Analysis;
		}
		if (lower.Contains("generat") || lower.Contains("write") || lower.Contains("edit")) {
			return MetricType.Generation;
		}
		return MetricType.Other;
	}

	private static double Percentile(List<long> values, int percentile) {
		if (values.Count == 0) return 0;
		List<long> sorted = values.OrderBy(v => v).ToList();
		int index = (int)Math.Ceiling(percentile / 100.0 * sorted.Count) - 1;
		return sorted[Math.Max(0, Math.Min(index, sorted.Count - 1))];
	}
}

/// <summary>
/// Configuration for performance monitoring thresholds.
/// </summary>
public sealed class PerformanceConfig {
	public long AnalysisMaxMs { get; init; } = 5000;
	public long GenerationMaxMs { get; init; } = 15000;
	public long DefaultMaxMs { get; init; } = 10000;
	public long MaxContextTokens { get; init; } = 128_000;
	public int SoftResetTurns { get; init; } = 50;
	public int HardResetTurns { get; init; } = 60;
}

/// <summary>
/// A single performance metric recording.
/// </summary>
public sealed class PerformanceMetric {
	public DateTime Timestamp { get; init; }
	public string Operation { get; init; } = string.Empty;
	public long DurationMs { get; init; }
	public int TurnNumber { get; init; }
	public long ContextTokens { get; init; }
	public bool IsError { get; init; }
	public string? ErrorMessage { get; init; }
}

/// <summary>
/// Performance alert.
/// </summary>
public sealed class PerformanceAlert {
	public DateTime Timestamp { get; init; }
	public AlertSeverity Severity { get; init; }
	public string Message { get; init; } = string.Empty;
	public int TurnNumber { get; init; }
	public bool Resolved { get; set; }
}

/// <summary>
/// Performance summary for dashboard display.
/// </summary>
public sealed class PerformanceSummary {
	public int CurrentTurn { get; init; }
	public long EstimatedContextTokens { get; init; }
	public double ContextUsagePercent { get; init; }
	public int TotalMetrics { get; init; }
	public int ErrorCount { get; init; }
	public double AverageResponseMs { get; init; }
	public double P95ResponseMs { get; init; }
	public long MaxResponseMs { get; init; }
	public bool IsDegraded { get; init; }
	public List<PerformanceAlert> ActiveAlerts { get; init; } = new();
}

public enum ContextStatus { Normal, Elevated, CompressNeeded, MustReset }
public enum TurnStatus { Normal, ResetSoon, MustReset }
public enum AlertSeverity { Info, Warning, Critical }
public enum MetricType { Analysis, Generation, Other }
