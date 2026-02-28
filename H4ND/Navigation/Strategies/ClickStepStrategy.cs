namespace P4NTHE0N.H4ND.Navigation.Strategies;

/// <summary>
/// ARCH-098: Executes a click action at coordinates resolved from the navigation step.
/// Uses relative coordinates (rx/ry) with canvas bounds, falling back to absolute (x/y).
/// </summary>
public sealed class ClickStepStrategy : IStepStrategy
{
	public string ActionType => "click";

	public async Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		var (x, y) = context.ResolveCoordinates(step);
		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Click ({x},{y}) — step {step.StepId}: {step.Comment}");
		await context.CdpClient.ClickAtAsync(x, y, ct);
	}
}
