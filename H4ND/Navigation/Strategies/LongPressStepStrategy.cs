namespace P4NTHE0N.H4ND.Navigation.Strategies;

/// <summary>
/// ARCH-098: Executes a long-press action via CDP Input.dispatchMouseEvent.
/// Used for "HOLD FOR AUTO" spin buttons in Cocos2d-x Canvas games.
/// </summary>
public sealed class LongPressStepStrategy : IStepStrategy
{
	public string ActionType => "longpress";

	public async Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		var (x, y) = context.ResolveCoordinates(step);
		int holdMs = step.HoldMs > 0 ? step.HoldMs : 2000;

		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] LongPress ({x},{y}) hold {holdMs}ms — step {step.StepId}: {step.Comment}");

		await context.CdpClient.SendCommandAsync("Input.dispatchMouseEvent",
			new { type = "mousePressed", x, y, button = "left", clickCount = 1 }, ct);
		await Task.Delay(holdMs, ct);
		await context.CdpClient.SendCommandAsync("Input.dispatchMouseEvent",
			new { type = "mouseReleased", x, y, button = "left", clickCount = 1 }, ct);
	}
}
