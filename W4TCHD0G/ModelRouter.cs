using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G;

public class ModelRouter
{
	private readonly Dictionary<string, List<ModelAssignment>> _taskModels = new();
	private readonly ConcurrentDictionary<string, ModelPerformance> _performance = new();

	public ModelRouter()
	{
		RegisterDefaults();
	}

	private void RegisterDefaults()
	{
		Register(
			"frame_analysis",
			new ModelAssignment
			{
				TaskName = "frame_analysis",
				ModelId = "llava-v1.6-mistral-7b",
				Provider = "LMStudio",
				MaxLatencyMs = 5000,
				Device = "gpu",
			}
		);

		Register(
			"ocr_extraction",
			new ModelAssignment
			{
				TaskName = "ocr_extraction",
				ModelId = "llava-phi-3-mini",
				Provider = "LMStudio",
				MaxLatencyMs = 2000,
				Device = "gpu",
			}
		);

		Register(
			"state_detection",
			new ModelAssignment
			{
				TaskName = "state_detection",
				ModelId = "moondream2",
				Provider = "LMStudio",
				MaxLatencyMs = 1000,
				Device = "gpu",
			}
		);
	}

	public void Register(string taskName, ModelAssignment assignment)
	{
		if (!_taskModels.ContainsKey(taskName))
			_taskModels[taskName] = new List<ModelAssignment>();
		_taskModels[taskName].Add(assignment);
	}

	public string GetModelForTask(string taskName)
	{
		if (!_taskModels.TryGetValue(taskName, out List<ModelAssignment>? assignments) || assignments.Count == 0)
			return string.Empty;

		ModelAssignment? best = assignments
			.Select(a => new { Assignment = a, Performance = _performance.GetValueOrDefault($"{a.ModelId}:{taskName}") })
			.OrderByDescending(x => x.Performance?.AccuracyPercent ?? 50)
			.ThenBy(x => x.Performance?.AverageLatencyMs ?? x.Assignment.MaxLatencyMs)
			.Select(x => x.Assignment)
			.FirstOrDefault();

		return best?.ModelId ?? string.Empty;
	}

	public void RecordPerformance(string modelId, string taskName, bool success, long latencyMs)
	{
		string key = $"{modelId}:{taskName}";
		ModelPerformance perf = _performance.GetOrAdd(key, _ => new ModelPerformance { ModelId = modelId, TaskName = taskName });
		perf.RecordInference(success, latencyMs);
	}

	public IReadOnlyDictionary<string, ModelPerformance> GetAllPerformance()
	{
		return _performance;
	}
}
