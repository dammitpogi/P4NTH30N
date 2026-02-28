using P4NTHE0N.H4ND.Navigation.Verification;

namespace P4NTHE0N.H4ND.Navigation.ErrorHandling;

/// <summary>
/// ARCH-098: Chain of error handlers — captures screenshot, checks conditional goto, then aborts.
/// </summary>
public sealed class ErrorHandlerChain : IErrorHandler
{
	public async Task<ErrorHandlerResult> HandleAsync(NavigationStep step, StepExecutionContext context, Exception exception, CancellationToken ct)
	{
		// 1. Always capture a screenshot on failure for diagnostics
		var screenshotStep = new NavigationStep
		{
			StepId = step.StepId,
			Action = step.Action,
			TakeScreenshot = true,
			ScreenshotReason = $"Error capture: {exception.Message}",
		};
		await ScreenshotVerificationStrategy.CaptureIfRequiredAsync(screenshotStep, context, ct);

		// 2. Check if the step has a conditional goto (e.g., retry on server error)
		if (step.Conditional != null && step.Conditional.OnTrue.Action == "goto"
			&& step.Conditional.OnTrue.GotoStep.HasValue)
		{
			Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Step {step.StepId} has conditional goto → step {step.Conditional.OnTrue.GotoStep}");
			return ErrorHandlerResult.GotoStep(
				step.Conditional.OnTrue.GotoStep.Value,
				$"Conditional goto from step {step.StepId}: {step.Conditional.Condition.Description}");
		}

		// 3. Default: abort with error message
		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Step {step.StepId} failed: {exception.Message}");
		return ErrorHandlerResult.Abort($"Step {step.StepId} ({step.Action}) failed: {exception.Message}");
	}
}
