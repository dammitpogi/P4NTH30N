using System.Collections.Generic;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-011: Unbreakable contract for shadow mode model validation.
/// Runs candidate models in parallel with production for comparison.
/// </summary>
public interface IShadowModeManager
{
	/// <summary>
	/// Starts a shadow test comparing a candidate model against production.
	/// </summary>
	void StartShadowTest(string taskName, string productionModelId, string candidateModelId, int requiredInferences = 100);

	/// <summary>
	/// Evaluates a running shadow test and returns results.
	/// </summary>
	object? EvaluateShadowTest(string taskName, string candidateModelId);

	/// <summary>
	/// Completes and removes a shadow test.
	/// </summary>
	void CompleteShadowTest(string taskName, string candidateModelId);

	/// <summary>
	/// Gets all currently active shadow tests.
	/// </summary>
	IReadOnlyList<object> GetActiveTests();
}
