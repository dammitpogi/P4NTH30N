namespace P4NTH30N.H4ND.Navigation.Strategies;

/// <summary>
/// ARCH-098: Executes a navigate action — loads a URL via CDP Page.navigate.
/// Also injects the Canvas input interceptor before navigation (ARCH-081).
/// </summary>
public sealed class NavigateStepStrategy : IStepStrategy
{
	public string ActionType => "navigate";

	public async Task ExecuteAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		string url = step.Url ?? string.Empty;
		if (string.IsNullOrEmpty(url))
		{
			throw new ArgumentException(
				$"Step {step.StepId}: Navigate action requires a URL. Check step configuration. Comment={step.Comment}");
		}

		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Navigate to {url} — step {step.StepId}: {step.Comment}");

		// ARCH-081: Inject MutationObserver BEFORE navigating so it catches ephemeral inputs
		await Infrastructure.CdpGameActions.InjectCanvasInputInterceptorAsync(context.CdpClient, ct);

		await context.CdpClient.NavigateAsync(url, ct);
	}
}
