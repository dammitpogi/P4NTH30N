namespace P4NTHE0N.H4ND.SmokeTest.Reporting;

/// <summary>
/// ARCH-099: Interface for reporting smoke test progress and results.
/// </summary>
public interface ISmokeTestReporter
{
	/// <summary>
	/// Report test start with config summary.
	/// </summary>
	void ReportStart(SmokeTestConfig config);

	/// <summary>
	/// Report a phase starting execution.
	/// </summary>
	void ReportPhaseRunning(string phaseName, int phaseNumber, int totalPhases);

	/// <summary>
	/// Report a phase completed (pass or fail).
	/// </summary>
	void ReportPhaseComplete(PhaseReport report, int phaseNumber, int totalPhases);

	/// <summary>
	/// Report final result.
	/// </summary>
	void ReportResult(SmokeTestResult result);
}
