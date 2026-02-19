using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Services;

/// <summary>
/// FOUREYES-024: Exception interceptor middleware for automated bug detection.
/// Captures unhandled exceptions, categorizes them, and routes to auto-triage.
/// </summary>
public class ExceptionInterceptorMiddleware {
	private readonly ConcurrentQueue<BugReport> _bugQueue = new();
	private readonly ConcurrentDictionary<string, int> _exceptionCounts = new();
	private readonly int _maxQueueSize;

	public event Action<BugReport>? OnBugDetected;

	public ExceptionInterceptorMiddleware(int maxQueueSize = 1000) {
		_maxQueueSize = maxQueueSize;
	}

	/// <summary>
	/// Intercepts and logs an exception as a bug report.
	/// </summary>
	public BugReport Intercept(Exception ex, string component, string context = "") {
		StackTrace trace = new(ex, true);
		StackFrame? frame = trace.GetFrame(0);

		BugReport report = new() {
			ExceptionType = ex.GetType().Name,
			Message = ex.Message,
			Component = component,
			Context = context,
			StackTrace = ex.StackTrace ?? string.Empty,
			SourceFile = frame?.GetFileName() ?? string.Empty,
			SourceLine = frame?.GetFileLineNumber() ?? 0,
			Severity = ClassifySeverity(ex),
		};

		// Track exception frequency
		string key = $"{report.ExceptionType}:{report.Component}";
		int count = _exceptionCounts.AddOrUpdate(key, 1, (_, c) => c + 1);
		report.OccurrenceCount = count;

		if (count > 10)
			report.Severity = BugSeverity.Critical; // Frequent = critical

		_bugQueue.Enqueue(report);
		while (_bugQueue.Count > _maxQueueSize && _bugQueue.TryDequeue(out _)) { }

		Console.WriteLine($"[ExceptionInterceptor] [{report.Severity}] {report.ExceptionType} in {report.Component}: {report.Message}");
		OnBugDetected?.Invoke(report);

		return report;
	}

	/// <summary>
	/// Gets all pending bug reports for triage.
	/// </summary>
	public IReadOnlyList<BugReport> GetPendingReports(int limit = 50) {
		return _bugQueue.Take(limit).ToList();
	}

	/// <summary>
	/// Gets exception frequency stats.
	/// </summary>
	public IReadOnlyDictionary<string, int> GetExceptionStats() {
		return _exceptionCounts;
	}

	private static BugSeverity ClassifySeverity(Exception ex) {
		return ex switch {
			OutOfMemoryException => BugSeverity.Critical,
			StackOverflowException => BugSeverity.Critical,
			AccessViolationException => BugSeverity.Critical,
			TimeoutException => BugSeverity.High,
			HttpRequestException => BugSeverity.Medium,
			InvalidOperationException => BugSeverity.Medium,
			ArgumentException => BugSeverity.Low,
			FormatException => BugSeverity.Low,
			_ => BugSeverity.Medium,
		};
	}
}

public class BugReport {
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public string ExceptionType { get; set; } = string.Empty;
	public string Message { get; set; } = string.Empty;
	public string Component { get; set; } = string.Empty;
	public string Context { get; set; } = string.Empty;
	public string StackTrace { get; set; } = string.Empty;
	public string SourceFile { get; set; } = string.Empty;
	public int SourceLine { get; set; }
	public BugSeverity Severity { get; set; }
	public int OccurrenceCount { get; set; }
	public BugTriageStatus TriageStatus { get; set; } = BugTriageStatus.New;
}

public enum BugSeverity {
	Low,
	Medium,
	High,
	Critical,
}

public enum BugTriageStatus {
	New,
	Triaged,
	InProgress,
	Fixed,
	WontFix,
	Duplicate,
}
