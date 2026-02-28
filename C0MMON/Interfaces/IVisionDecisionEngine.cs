namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-011: Unbreakable contract for vision-based decision making.
/// Abstracts VisionDecisionEngine for testability and decoupling.
/// Uses object parameter to avoid circular dependency between C0MMON and W4TCHD0G.
/// </summary>
public interface IVisionDecisionEngine
{
	/// <summary>
	/// Evaluates a decision context with optional vision analysis data.
	/// </summary>
	object Evaluate(object context, object? visionAnalysis);
}
