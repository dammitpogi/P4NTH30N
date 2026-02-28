using P4NTHE0N.C0MMON;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

namespace P4NTHE0N.H0UND;

public static class H0UNDEvidenceHooks
{
	public static void RecordCircuitOpenSkip(IErrorEvidence errors, Credential credential)
	{
		errors.CaptureWarning(
			"H0UND-CIRCUIT-OPEN-001",
			"API circuit open; poll iteration skipped",
			context: new Dictionary<string, object>
			{
				["game"] = credential.Game,
				["house"] = credential.House ?? "Unknown",
				["credentialId"] = credential._id.ToString(),
			});
	}

	public static void RecordMainLoopError(IErrorEvidence errors, Exception ex, string task)
	{
		errors.Capture(
			ex,
			"H0UND-MAIN-LOOP-ERR-001",
			"Unhandled exception in H0UND main loop",
			context: new Dictionary<string, object>
			{
				["task"] = task,
			});
	}
}
