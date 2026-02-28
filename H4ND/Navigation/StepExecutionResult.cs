using System.Diagnostics;

namespace P4NTHE0N.H4ND.Navigation;

/// <summary>
/// ARCH-098: Result of executing a single navigation step or an entire phase.
/// Captures success/failure, timing, and diagnostic information.
/// </summary>
public sealed class StepExecutionResult
{
	public bool Success { get; init; }
	public int StepId { get; init; }
	public string? ErrorMessage { get; init; }
	public TimeSpan Duration { get; init; }
	public int AttemptCount { get; init; } = 1;
	public string? RecoveryAction { get; init; }
	public int? GotoStepId { get; init; }

	public static StepExecutionResult Succeeded(int stepId, TimeSpan duration, int attempts = 1) => new()
	{
		Success = true,
		StepId = stepId,
		Duration = duration,
		AttemptCount = attempts,
	};

	public static StepExecutionResult Failed(int stepId, string error, TimeSpan duration, int attempts = 1) => new()
	{
		Success = false,
		StepId = stepId,
		ErrorMessage = error,
		Duration = duration,
		AttemptCount = attempts,
	};

	public static StepExecutionResult Goto(int stepId, int gotoStepId, TimeSpan duration) => new()
	{
		Success = true,
		StepId = stepId,
		Duration = duration,
		RecoveryAction = "goto",
		GotoStepId = gotoStepId,
	};
}

/// <summary>
/// Result of executing an entire navigation phase (Login, GameSelection, Spin, Logout).
/// </summary>
public sealed class PhaseExecutionResult
{
	public bool Success { get; init; }
	public string Phase { get; init; } = string.Empty;
	public IReadOnlyList<StepExecutionResult> StepResults { get; init; } = Array.Empty<StepExecutionResult>();
	public TimeSpan TotalDuration { get; init; }
	public string? ErrorMessage { get; init; }

	public static PhaseExecutionResult Succeeded(string phase, List<StepExecutionResult> steps, TimeSpan duration) => new()
	{
		Success = true,
		Phase = phase,
		StepResults = steps,
		TotalDuration = duration,
	};

	public static PhaseExecutionResult Failed(string phase, List<StepExecutionResult> steps, TimeSpan duration, string error) => new()
	{
		Success = false,
		Phase = phase,
		StepResults = steps,
		TotalDuration = duration,
		ErrorMessage = error,
	};
}
