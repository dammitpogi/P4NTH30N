using System.Text.Json.Serialization;

namespace P4NTH30N.H4ND.SmokeTest;

/// <summary>
/// ARCH-099: Result data model for smoke test execution.
/// </summary>
public sealed class SmokeTestResult
{
	[JsonPropertyName("outcome")]
	public SmokeTestOutcome Outcome { get; init; }

	[JsonPropertyName("exitCode")]
	public int ExitCode { get; init; }

	[JsonPropertyName("platform")]
	public string Platform { get; init; } = string.Empty;

	[JsonPropertyName("profile")]
	public string Profile { get; init; } = string.Empty;

	[JsonPropertyName("port")]
	public int Port { get; init; }

	[JsonPropertyName("duration")]
	public TimeSpan Duration { get; init; }

	[JsonPropertyName("durationSeconds")]
	public double DurationSeconds => Math.Round(Duration.TotalSeconds, 1);

	[JsonPropertyName("phases")]
	public List<PhaseReport> Phases { get; init; } = [];

	[JsonPropertyName("failedPhase")]
	public string? FailedPhase { get; init; }

	[JsonPropertyName("errorMessage")]
	public string? ErrorMessage { get; init; }

	[JsonPropertyName("gateDecision")]
	public string GateDecision => Outcome == SmokeTestOutcome.Pass ? "OPEN - Burn-in approved" : "CLOSED - Fix required";

	[JsonPropertyName("balance")]
	public double Balance { get; init; }

	[JsonPropertyName("canvasBounds")]
	public string? CanvasBounds { get; init; }

	[JsonPropertyName("timestamp")]
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;

	public static SmokeTestResult Pass(SmokeTestConfig config, TimeSpan duration, List<PhaseReport> phases, double balance, string? canvasBounds) => new()
	{
		Outcome = SmokeTestOutcome.Pass,
		ExitCode = 0,
		Platform = config.Platform,
		Profile = $"Profile-{config.Profile}",
		Port = config.Port,
		Duration = duration,
		Phases = phases,
		Balance = balance,
		CanvasBounds = canvasBounds,
	};

	public static SmokeTestResult Fail(SmokeTestConfig config, TimeSpan duration, List<PhaseReport> phases, string failedPhase, string error, int exitCode) => new()
	{
		Outcome = SmokeTestOutcome.Fail,
		ExitCode = exitCode,
		Platform = config.Platform,
		Profile = $"Profile-{config.Profile}",
		Port = config.Port,
		Duration = duration,
		Phases = phases,
		FailedPhase = failedPhase,
		ErrorMessage = error,
	};

	public static SmokeTestResult Fatal(SmokeTestConfig config, string error) => new()
	{
		Outcome = SmokeTestOutcome.Fatal,
		ExitCode = 99,
		Platform = config.Platform,
		Profile = $"Profile-{config.Profile}",
		Port = config.Port,
		ErrorMessage = error,
	};
}

public enum SmokeTestOutcome
{
	Pass,
	Fail,
	Fatal,
}

/// <summary>
/// Report for a single phase execution.
/// </summary>
public sealed class PhaseReport
{
	[JsonPropertyName("name")]
	public string Name { get; init; } = string.Empty;

	[JsonPropertyName("success")]
	public bool Success { get; init; }

	[JsonPropertyName("durationSeconds")]
	public double DurationSeconds { get; init; }

	[JsonPropertyName("detail")]
	public string Detail { get; init; } = string.Empty;

	[JsonPropertyName("errorMessage")]
	public string? ErrorMessage { get; init; }
}
