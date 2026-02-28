namespace P4NTHE0N.H4ND.SmokeTest.Phases;

/// <summary>
/// ARCH-099: Interface for a smoke test phase.
/// Each phase returns a PhaseReport with success/failure and detail.
/// </summary>
public interface ISmokeTestPhase
{
	/// <summary>
	/// Human-readable phase name (e.g., "Bootstrap", "Navigation", "Login", "Verification").
	/// </summary>
	string Name { get; }

	/// <summary>
	/// 1-based phase number for display.
	/// </summary>
	int PhaseNumber { get; }

	/// <summary>
	/// Exit code to return if this phase fails.
	/// </summary>
	int FailureExitCode { get; }

	/// <summary>
	/// Execute the phase. Returns a PhaseReport with success/failure and diagnostics.
	/// </summary>
	Task<PhaseReport> ExecuteAsync(CancellationToken ct);
}
