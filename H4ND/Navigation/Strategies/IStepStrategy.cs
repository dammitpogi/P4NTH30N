namespace P4NTHE0N.H4ND.Navigation.Strategies;

/// <summary>
/// ARCH-098: Strategy pattern interface for step action execution.
/// Each action type (click, type, wait, navigate, longpress) has its own implementation.
/// Implementations are stateless and thread-safe.
/// </summary>
public interface IStepStrategy
{
	string ActionType { get; }
	Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct);
}
