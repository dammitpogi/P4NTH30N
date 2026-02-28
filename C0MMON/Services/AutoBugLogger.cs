using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Services;

/// <summary>
/// FOUREYES-024: Automatic bug logger service.
/// Subscribes to ExceptionInterceptorMiddleware and persists bug reports.
/// Deduplicates by exception type + component fingerprint.
/// </summary>
public class AutoBugLogger
{
	private readonly ExceptionInterceptorMiddleware _interceptor;
	private readonly ConcurrentDictionary<string, BugReport> _knownBugs = new();
	private readonly ConcurrentQueue<BugReport> _newBugQueue = new();

	public AutoBugLogger(ExceptionInterceptorMiddleware interceptor)
	{
		_interceptor = interceptor;
		_interceptor.OnBugDetected += HandleBugDetected;
	}

	private void HandleBugDetected(BugReport report)
	{
		string fingerprint = $"{report.ExceptionType}:{report.Component}:{report.SourceFile}:{report.SourceLine}";

		if (_knownBugs.TryGetValue(fingerprint, out BugReport? existing))
		{
			existing.OccurrenceCount = report.OccurrenceCount;
			if (report.Severity > existing.Severity)
				existing.Severity = report.Severity;
			return;
		}

		_knownBugs[fingerprint] = report;
		_newBugQueue.Enqueue(report);
		Console.WriteLine($"[AutoBugLogger] New bug logged: {report.ExceptionType} in {report.Component} at {report.SourceFile}:{report.SourceLine}");
	}

	/// <summary>
	/// Gets new (untriaged) bug reports.
	/// </summary>
	public IReadOnlyList<BugReport> GetNewBugs()
	{
		return _newBugQueue.ToList();
	}

	/// <summary>
	/// Gets all known bugs, deduplicated by fingerprint.
	/// </summary>
	public IReadOnlyList<BugReport> GetAllKnownBugs()
	{
		return _knownBugs.Values.OrderByDescending(b => b.Severity).ThenByDescending(b => b.OccurrenceCount).ToList();
	}

	/// <summary>
	/// Gets bugs filtered by severity.
	/// </summary>
	public IReadOnlyList<BugReport> GetBugsBySeverity(BugSeverity severity)
	{
		return _knownBugs.Values.Where(b => b.Severity == severity).ToList();
	}

	/// <summary>
	/// Marks a bug as triaged with the given status.
	/// </summary>
	public bool UpdateTriageStatus(string bugId, BugTriageStatus status)
	{
		BugReport? bug = _knownBugs.Values.FirstOrDefault(b => b.Id == bugId);
		if (bug == null)
			return false;

		bug.TriageStatus = status;
		Console.WriteLine($"[AutoBugLogger] Bug {bugId} status updated to {status}");
		return true;
	}
}
