namespace P4NTH30N.H4ND.Navigation.Verification;

/// <summary>
/// ARCH-098: Captures a screenshot via CDP for steps marked with takeScreenshot=true.
/// Screenshots are stored in the execution context for diagnostic review.
/// </summary>
public sealed class ScreenshotVerificationStrategy
{
	public static async Task CaptureIfRequiredAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		if (!step.TakeScreenshot)
			return;

		try
		{
			var result = await context.CdpClient.SendCommandAsync(
				"Page.captureScreenshot",
				new { format = "png", quality = 80 }, ct);

			if (result.TryGetProperty("result", out var resultProp)
				&& resultProp.TryGetProperty("data", out var dataProp))
			{
				string base64 = dataProp.GetString() ?? string.Empty;
				if (!string.IsNullOrEmpty(base64))
				{
					byte[] bytes = Convert.FromBase64String(base64);
					context.CapturedScreenshots.Add(bytes);
					Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Screenshot captured at step {step.StepId} ({bytes.Length:N0} bytes): {step.ScreenshotReason}");
				}
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Screenshot capture failed at step {step.StepId}: {ex.Message}");
		}
	}
}
