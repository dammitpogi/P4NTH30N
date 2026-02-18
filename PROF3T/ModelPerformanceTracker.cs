using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;

namespace P4NTH30N.PROF3T;

public class ModelPerformanceTracker
{
	private readonly ConcurrentDictionary<string, PerformanceRecord> _records = new();

	public void RecordInference(string modelId, string taskName, bool success, long latencyMs)
	{
		string key = $"{modelId}:{taskName}";
		PerformanceRecord record = _records.GetOrAdd(key, _ => new PerformanceRecord(modelId, taskName));
		record.Record(success, latencyMs);
	}

	public PerformanceRecord? GetRecord(string modelId, string taskName)
	{
		string key = $"{modelId}:{taskName}";
		return _records.TryGetValue(key, out PerformanceRecord? r) ? r : null;
	}

	public string GetBestModelForTask(string taskName, IEnumerable<string> candidates)
	{
		return candidates
				.Select(modelId => new { ModelId = modelId, Record = GetRecord(modelId, taskName) })
				.OrderByDescending(x => x.Record?.AccuracyPercent ?? 50)
				.ThenBy(x => x.Record?.AverageLatencyMs ?? double.MaxValue)
				.Select(x => x.ModelId)
				.FirstOrDefault()
			?? string.Empty;
	}

	public IReadOnlyDictionary<string, PerformanceRecord> GetAllRecords()
	{
		return _records;
	}
}

public class PerformanceRecord
{
	public string ModelId { get; }
	public string TaskName { get; }
	public int TotalInferences { get; private set; }
	public int SuccessCount { get; private set; }
	public double AverageLatencyMs { get; private set; }
	public double AccuracyPercent => TotalInferences > 0 ? (double)SuccessCount / TotalInferences * 100 : 0;
	public DateTime LastUsed { get; private set; } = DateTime.UtcNow;

	public PerformanceRecord(string modelId, string taskName)
	{
		ModelId = modelId;
		TaskName = taskName;
	}

	public void Record(bool success, long latencyMs)
	{
		TotalInferences++;
		if (success)
			SuccessCount++;
		AverageLatencyMs = ((AverageLatencyMs * (TotalInferences - 1)) + latencyMs) / TotalInferences;
		LastUsed = DateTime.UtcNow;
	}
}
