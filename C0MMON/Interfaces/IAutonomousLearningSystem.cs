using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-014: C0MMON-side contract for autonomous learning and model self-improvement.
/// Evaluates shadow test results and promotes better-performing models.
/// </summary>
public interface IAutonomousLearningSystem
{
	/// <summary>
	/// Evaluates all active shadow tests and promotes qualifying candidates.
	/// </summary>
	List<object> EvaluateAndPromote();

	/// <summary>
	/// Generates a report of learning system status.
	/// </summary>
	object GenerateReport();

	/// <summary>
	/// Gets the history of model promotions.
	/// </summary>
	IReadOnlyList<object> GetPromotionHistory();
}
