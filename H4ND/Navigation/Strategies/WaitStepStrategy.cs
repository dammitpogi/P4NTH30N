namespace P4NTH30N.H4ND.Navigation.Strategies;

/// <summary>
/// ARCH-098: Executes a wait action — delays for the specified duration.
/// Used for loading screens, login verification polling, game load waits.
/// </summary>
public sealed class WaitStepStrategy : IStepStrategy
{
	public string ActionType => "wait";

	public async Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		int delayMs = step.DelayMs > 0 ? step.DelayMs : 1000;
		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Wait {delayMs}ms — step {step.StepId}: {step.Comment}");
		await Task.Delay(delayMs, ct);
	}
}
