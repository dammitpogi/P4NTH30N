using System.Text.Json.Serialization;

namespace P4NTHE0N.H4ND.Navigation;

/// <summary>
/// ARCH-098: Immutable navigation map parsed from recorder step-config.json.
/// Thread-safe for concurrent readonly access by parallel workers.
/// </summary>
public sealed class NavigationMap
{
	[JsonPropertyName("platform")]
	public string Platform { get; init; } = string.Empty;

	[JsonPropertyName("decision")]
	public string Decision { get; init; } = string.Empty;

	[JsonPropertyName("sessionNotes")]
	public string SessionNotes { get; init; } = string.Empty;

	[JsonPropertyName("steps")]
	public IReadOnlyList<NavigationStep> Steps { get; init; } = Array.Empty<NavigationStep>();

	[JsonPropertyName("metadata")]
	public NavigationMetadata Metadata { get; init; } = new();

	public IEnumerable<NavigationStep> GetStepsForPhase(string phase) =>
		Steps.Where(s => s.Phase.Equals(phase, StringComparison.OrdinalIgnoreCase)
			&& s.Enabled);

	public NavigationStep? GetStepById(int stepId) =>
		Steps.FirstOrDefault(s => s.StepId == stepId);

	public IReadOnlyList<string> GetPhases() =>
		Steps.Where(s => s.Enabled).Select(s => s.Phase).Distinct(StringComparer.OrdinalIgnoreCase).ToList();
}

/// <summary>
/// A single step in the navigation map — click, type, wait, navigate, or longpress.
/// </summary>
public sealed class NavigationStep
{
	[JsonPropertyName("stepId")]
	public int StepId { get; init; }

	[JsonPropertyName("enabled")]
	public bool Enabled { get; init; } = true;

	[JsonPropertyName("phase")]
	public string Phase { get; init; } = string.Empty;

	[JsonPropertyName("takeScreenshot")]
	public bool TakeScreenshot { get; init; }

	[JsonPropertyName("screenshotReason")]
	public string ScreenshotReason { get; init; } = string.Empty;

	[JsonPropertyName("comment")]
	public string Comment { get; init; } = string.Empty;

	[JsonPropertyName("tool")]
	public string Tool { get; init; } = "none";

	[JsonPropertyName("action")]
	public string Action { get; init; } = string.Empty;

	[JsonPropertyName("coordinates")]
	public StepCoordinates Coordinates { get; init; } = new();

	[JsonPropertyName("delayMs")]
	public int DelayMs { get; init; }

	[JsonPropertyName("verification")]
	public StepVerification Verification { get; init; } = new();

	[JsonPropertyName("breakpoint")]
	public bool Breakpoint { get; init; }

	[JsonPropertyName("url")]
	public string? Url { get; init; }

	[JsonPropertyName("input")]
	public string? Input { get; init; }

	[JsonPropertyName("holdMs")]
	public int HoldMs { get; init; } = 2000;

	[JsonPropertyName("canvasBounds")]
	public StepCanvasBounds? CanvasBounds { get; init; }

	[JsonPropertyName("conditional")]
	public StepConditional? Conditional { get; init; }
}

/// <summary>
/// Coordinates with both relative (rx/ry) and absolute (x/y) fallback.
/// </summary>
public sealed class StepCoordinates
{
	[JsonPropertyName("rx")]
	public double Rx { get; init; }

	[JsonPropertyName("ry")]
	public double Ry { get; init; }

	[JsonPropertyName("x")]
	public int X { get; init; }

	[JsonPropertyName("y")]
	public int Y { get; init; }

	public bool HasRelative => Rx > 0 || Ry > 0;
}

/// <summary>
/// Verification gates for step entry/exit conditions.
/// </summary>
public sealed class StepVerification
{
	[JsonPropertyName("entryGate")]
	public string EntryGate { get; init; } = string.Empty;

	[JsonPropertyName("exitGate")]
	public string ExitGate { get; init; } = string.Empty;

	[JsonPropertyName("progressIndicators")]
	public List<string>? ProgressIndicators { get; init; }
}

/// <summary>
/// Canvas bounds recorded at step capture time.
/// </summary>
public sealed class StepCanvasBounds
{
	[JsonPropertyName("x")]
	public double X { get; init; }

	[JsonPropertyName("y")]
	public double Y { get; init; }

	[JsonPropertyName("width")]
	public double Width { get; init; }

	[JsonPropertyName("height")]
	public double Height { get; init; }
}

/// <summary>
/// Conditional branching for steps (e.g., retry on server error).
/// </summary>
public sealed class StepConditional
{
	[JsonPropertyName("condition")]
	public StepCondition Condition { get; init; } = new();

	[JsonPropertyName("onTrue")]
	public StepBranch OnTrue { get; init; } = new();

	[JsonPropertyName("onFalse")]
	public StepBranch OnFalse { get; init; } = new();
}

public sealed class StepCondition
{
	[JsonPropertyName("type")]
	public string Type { get; init; } = string.Empty;

	[JsonPropertyName("description")]
	public string Description { get; init; } = string.Empty;
}

public sealed class StepBranch
{
	[JsonPropertyName("action")]
	public string Action { get; init; } = "continue";

	[JsonPropertyName("gotoStep")]
	public int? GotoStep { get; init; }

	[JsonPropertyName("comment")]
	public string Comment { get; init; } = string.Empty;
}

/// <summary>
/// Metadata section of the navigation map — viewport, coordinates, credentials info.
/// </summary>
public sealed class NavigationMetadata
{
	[JsonPropertyName("created")]
	public string Created { get; init; } = string.Empty;

	[JsonPropertyName("modified")]
	public string Modified { get; init; } = string.Empty;

	[JsonPropertyName("designViewport")]
	public DesignViewport DesignViewport { get; init; } = new();

	[JsonPropertyName("coordinates")]
	public Dictionary<string, Dictionary<string, PlatformCoordinates>>? Coordinates { get; init; }

	[JsonPropertyName("credentials")]
	public Dictionary<string, PlatformCredentials>? Credentials { get; init; }
}

public sealed class DesignViewport
{
	[JsonPropertyName("width")]
	public int Width { get; init; } = 930;

	[JsonPropertyName("height")]
	public int Height { get; init; } = 865;

	[JsonPropertyName("calibratedDate")]
	public string CalibratedDate { get; init; } = string.Empty;

	[JsonPropertyName("note")]
	public string Note { get; init; } = string.Empty;
}

/// <summary>
/// Recorder-captured coordinate for a named UI position (e.g. "login", "spinButton").
/// rx/ry are relative (0-1), x/y are absolute pixel fallbacks.
/// </summary>
public sealed class PlatformCoordinates
{
	[JsonPropertyName("rx")]
	public double Rx { get; init; }

	[JsonPropertyName("ry")]
	public double Ry { get; init; }

	[JsonPropertyName("x")]
	public double X { get; init; }

	[JsonPropertyName("y")]
	public double Y { get; init; }
}

/// <summary>
/// Recorder-captured credentials for a platform login.
/// </summary>
public sealed class PlatformCredentials
{
	[JsonPropertyName("username")]
	public string Username { get; init; } = string.Empty;

	[JsonPropertyName("password")]
	public string Password { get; init; } = string.Empty;

	[JsonPropertyName("source")]
	public string Source { get; init; } = string.Empty;
}
