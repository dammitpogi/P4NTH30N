using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace P4NTH30N.PROF3T;

public class ShadowModeManager
{
	private readonly ModelPerformanceTracker _tracker;
	private readonly ConcurrentDictionary<string, ShadowTest> _activeTests = new();

	public ShadowModeManager(ModelPerformanceTracker tracker)
	{
		_tracker = tracker;
	}

	public void StartShadowTest(string taskName, string productionModelId, string candidateModelId, int requiredInferences = 100)
	{
		string key = $"{taskName}:{candidateModelId}";
		_activeTests[key] = new ShadowTest
		{
			TaskName = taskName,
			ProductionModelId = productionModelId,
			CandidateModelId = candidateModelId,
			RequiredInferences = requiredInferences,
			StartedAt = DateTime.UtcNow,
		};
	}

	public ShadowTestResult? EvaluateShadowTest(string taskName, string candidateModelId)
	{
		string key = $"{taskName}:{candidateModelId}";
		if (!_activeTests.TryGetValue(key, out ShadowTest? test))
			return null;

		PerformanceRecord? prodRecord = _tracker.GetRecord(test.ProductionModelId, taskName);
		PerformanceRecord? candRecord = _tracker.GetRecord(candidateModelId, taskName);

		if (candRecord == null || candRecord.TotalInferences < test.RequiredInferences)
			return new ShadowTestResult { IsComplete = false, CanPromote = false };

		bool betterAccuracy = candRecord.AccuracyPercent >= (prodRecord?.AccuracyPercent ?? 0);
		bool betterLatency = candRecord.AverageLatencyMs <= (prodRecord?.AverageLatencyMs ?? double.MaxValue) * 1.1;

		return new ShadowTestResult
		{
			IsComplete = true,
			CanPromote = betterAccuracy && betterLatency,
			CandidateAccuracy = candRecord.AccuracyPercent,
			ProductionAccuracy = prodRecord?.AccuracyPercent ?? 0,
			CandidateLatency = candRecord.AverageLatencyMs,
			ProductionLatency = prodRecord?.AverageLatencyMs ?? 0,
		};
	}

	public void CompleteShadowTest(string taskName, string candidateModelId)
	{
		string key = $"{taskName}:{candidateModelId}";
		_activeTests.TryRemove(key, out _);
	}

	public IReadOnlyList<ShadowTest> GetActiveTests()
	{
		return _activeTests.Values.ToList();
	}
}

public class ShadowTest
{
	public string TaskName { get; set; } = string.Empty;
	public string ProductionModelId { get; set; } = string.Empty;
	public string CandidateModelId { get; set; } = string.Empty;
	public int RequiredInferences { get; set; }
	public DateTime StartedAt { get; set; }
}

public class ShadowTestResult
{
	public bool IsComplete { get; set; }
	public bool CanPromote { get; set; }
	public double CandidateAccuracy { get; set; }
	public double ProductionAccuracy { get; set; }
	public double CandidateLatency { get; set; }
	public double ProductionLatency { get; set; }
}
