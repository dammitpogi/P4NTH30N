namespace P4NTHE0N.C0MMON.Services.Display;

/// <summary>
/// Immutable display event routed through the display pipeline.
/// </summary>
public sealed record DisplayEvent(
	DateTime Timestamp,
	DisplayLogLevel Level,
	string Source,
	string Message,
	string Style = "white",
	Dictionary<string, string>? Metadata = null
)
{
	public static DisplayEvent Silent(string source, string message) =>
		new(DateTime.UtcNow, DisplayLogLevel.Silent, source, message, "grey");

	public static DisplayEvent Debug(string source, string message) =>
		new(DateTime.UtcNow, DisplayLogLevel.Debug, source, message, "grey");

	public static DisplayEvent Detail(string source, string message, string style = "white") =>
		new(DateTime.UtcNow, DisplayLogLevel.Detail, source, message, style);

	public static DisplayEvent Status(string source, string message, string style = "cyan") =>
		new(DateTime.UtcNow, DisplayLogLevel.Status, source, message, style);

	public static DisplayEvent Warn(string source, string message) =>
		new(DateTime.UtcNow, DisplayLogLevel.Warning, source, message, "yellow");

	public static DisplayEvent Error(string source, string message) =>
		new(DateTime.UtcNow, DisplayLogLevel.Error, source, message, "red");
}
