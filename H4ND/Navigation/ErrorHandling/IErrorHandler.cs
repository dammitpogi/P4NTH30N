namespace P4NTHE0N.H4ND.Navigation.ErrorHandling;

/// <summary>
/// ARCH-098: Error handler interface for step execution failures.
/// Handlers form a chain — each can handle or pass to the next.
/// </summary>
public interface IErrorHandler
{
	Task<ErrorHandlerResult> HandleAsync(NavigationStep step, StepExecutionContext context, Exception exception, CancellationToken ct);
}

/// <summary>
/// Result of error handling — determines what happens next.
/// </summary>
public sealed class ErrorHandlerResult
{
	public ErrorAction Action { get; init; }
	public int? GotoStepId { get; init; }
	public string Message { get; init; } = string.Empty;

	public static ErrorHandlerResult Retry(string message) => new() { Action = ErrorAction.Retry, Message = message };
	public static ErrorHandlerResult Abort(string message) => new() { Action = ErrorAction.Abort, Message = message };
	public static ErrorHandlerResult GotoStep(int stepId, string message) => new() { Action = ErrorAction.Goto, GotoStepId = stepId, Message = message };
}

public enum ErrorAction
{
	Retry,
	Abort,
	Goto,
}
