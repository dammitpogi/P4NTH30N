using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;

namespace P4NTHE0N.H4ND.Navigation;

/// <summary>
/// ARCH-098: Per-execution mutable state. Created fresh for each worker execution.
/// NOT shared between workers — each worker creates its own context.
/// </summary>
public sealed class StepExecutionContext
{
	public required ICdpClient CdpClient { get; init; }
	public required string Platform { get; init; }
	public string Username { get; set; } = string.Empty;
	public string Password { get; set; } = string.Empty;
	public Dictionary<string, string> Variables { get; init; } = new();
	public CanvasBounds CanvasBounds { get; set; } = CanvasBounds.Empty;
	public string WorkerId { get; init; } = "0";
	public List<byte[]> CapturedScreenshots { get; } = new();

	/// <summary>
	/// Resolve the input text for a type step, substituting variables.
	/// The step-config.json contains hardcoded credentials — at runtime we replace with actual credential values.
	/// </summary>
	public string ResolveInput(NavigationStep step)
	{
		string? input = step.Input;
		if (string.IsNullOrEmpty(input))
			return string.Empty;

		// Replace known variable placeholders
		if (Variables.TryGetValue("username", out string? username) && input == Variables.GetValueOrDefault("template_username", input))
			return username;
		if (Variables.TryGetValue("password", out string? password) && input == Variables.GetValueOrDefault("template_password", input))
			return password;

		return input;
	}

	/// <summary>
	/// Refresh canvas bounds from the live page via CDP.
	/// Called at the start of each phase to handle viewport changes.
	/// </summary>
	public async Task RefreshCanvasBoundsAsync(CancellationToken ct = default)
	{
		CanvasBounds = await CdpGameActions.GetCanvasBoundsAsync(CdpClient, ct);
	}

	/// <summary>
	/// Transform step coordinates to absolute viewport coordinates using current canvas bounds.
	/// Uses relative coords (rx/ry) when available, falls back to absolute (x/y).
	/// </summary>
	public (int X, int Y) ResolveCoordinates(NavigationStep step)
	{
		if (step.Coordinates.HasRelative)
		{
			return CdpGameActions.TransformRelativeCoordinates(
				step.Coordinates.Rx, step.Coordinates.Ry,
				CanvasBounds,
				step.Coordinates.X, step.Coordinates.Y);
		}
		return (step.Coordinates.X, step.Coordinates.Y);
	}
}
