namespace P4NTHE0N.H4ND.Navigation.Retry;

/// <summary>
/// ARCH-098: Abstraction for step execution — enables Decorator pattern for retry.
/// Both StepExecutor and RetryStepDecorator implement this interface.
/// </summary>
public interface IStepExecutor
{
	Task<StepExecutionResult> ExecuteStepAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct);
	Task<PhaseExecutionResult> ExecutePhaseAsync(NavigationMap map, string phase, StepExecutionContext context, CancellationToken ct);
}
