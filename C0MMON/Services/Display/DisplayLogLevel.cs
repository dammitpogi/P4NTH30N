namespace P4NTH30N.C0MMON.Services.Display;

/// <summary>
/// Progressive disclosure log levels for the display pipeline.
/// Ordered from least visible to most visible.
/// </summary>
public enum DisplayLogLevel
{
	/// <summary>Never shown in any view. Counted only.</summary>
	Silent = 0,

	/// <summary>Hidden by default. Visible in debug panel (toggle 'D').</summary>
	Debug = 1,

	/// <summary>Main dashboard content (polling results, analytics summaries).</summary>
	Detail = 2,

	/// <summary>Always visible in status bar (credential changes, major events).</summary>
	Status = 3,

	/// <summary>Highlighted with color (retries, circuit breaker state changes).</summary>
	Warning = 4,

	/// <summary>Prominent display, always visible, expansion option.</summary>
	Error = 5,
}
