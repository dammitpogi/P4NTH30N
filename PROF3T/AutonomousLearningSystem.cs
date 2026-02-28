using System;
using System.Collections.Generic;
using System.Linq;

namespace P4NTHE0N.PROF3T;

public class AutonomousLearningSystem
{
	private readonly ModelPerformanceTracker _tracker;
	private readonly ShadowModeManager _shadowManager;
	private readonly IModelManager _modelManager;
	private readonly List<PromotionEvent> _promotionHistory = new();

	public AutonomousLearningSystem(ModelPerformanceTracker tracker, ShadowModeManager shadowManager, IModelManager modelManager)
	{
		_tracker = tracker;
		_shadowManager = shadowManager;
		_modelManager = modelManager;
	}

	public List<PromotionEvent> EvaluateAndPromote()
	{
		List<PromotionEvent> promotions = new List<PromotionEvent>();

		foreach (ShadowTest test in _shadowManager.GetActiveTests())
		{
			ShadowTestResult? result = _shadowManager.EvaluateShadowTest(test.TaskName, test.CandidateModelId);
			if (result == null || !result.IsComplete)
				continue;

			if (result.CanPromote)
			{
				PromotionEvent promotion = new PromotionEvent
				{
					TaskName = test.TaskName,
					OldModelId = test.ProductionModelId,
					NewModelId = test.CandidateModelId,
					AccuracyImprovement = result.CandidateAccuracy - result.ProductionAccuracy,
					LatencyChange = result.CandidateLatency - result.ProductionLatency,
					PromotedAt = DateTime.UtcNow,
				};

				_promotionHistory.Add(promotion);
				promotions.Add(promotion);
				Console.WriteLine(
					$"[LearningSystem] Promoting {test.CandidateModelId} for {test.TaskName} (accuracy: {result.CandidateAccuracy:F1}% vs {result.ProductionAccuracy:F1}%)"
				);
			}

			_shadowManager.CompleteShadowTest(test.TaskName, test.CandidateModelId);
		}

		return promotions;
	}

	public LearningReport GenerateReport()
	{
		IReadOnlyDictionary<string, PerformanceRecord> allRecords = _tracker.GetAllRecords();
		IReadOnlyList<ShadowTest> activeTests = _shadowManager.GetActiveTests();

		return new LearningReport
		{
			TotalModelsTracked = allRecords.Values.Select(r => r.ModelId).Distinct().Count(),
			TotalInferencesTracked = allRecords.Values.Sum(r => r.TotalInferences),
			ActiveShadowTests = activeTests.Count,
			TotalPromotions = _promotionHistory.Count,
			RecentPromotions = _promotionHistory.TakeLast(10).ToList(),
			GeneratedAt = DateTime.UtcNow,
		};
	}

	public IReadOnlyList<PromotionEvent> GetPromotionHistory()
	{
		return _promotionHistory;
	}
}

public class PromotionEvent
{
	public string TaskName { get; set; } = string.Empty;
	public string OldModelId { get; set; } = string.Empty;
	public string NewModelId { get; set; } = string.Empty;
	public double AccuracyImprovement { get; set; }
	public double LatencyChange { get; set; }
	public DateTime PromotedAt { get; set; }
}

public class LearningReport
{
	public int TotalModelsTracked { get; set; }
	public int TotalInferencesTracked { get; set; }
	public int ActiveShadowTests { get; set; }
	public int TotalPromotions { get; set; }
	public List<PromotionEvent> RecentPromotions { get; set; } = new();
	public DateTime GeneratedAt { get; set; }
}
