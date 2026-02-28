using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTHE0N.H4ND.SmokeTest.Reporting;

/// <summary>
/// ARCH-099: Machine-readable JSON output for CI/CD integration.
/// Writes the final result as a single JSON object to stdout.
/// </summary>
public sealed class JsonReporter : ISmokeTestReporter
{
	private static readonly JsonSerializerOptions _jsonOptions = new()
	{
		WriteIndented = true,
		PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
		Converters = { new JsonStringEnumConverter(JsonNamingPolicy.CamelCase) },
	};

	public void ReportStart(SmokeTestConfig config)
	{
		// JSON mode: silent until final result
	}

	public void ReportPhaseRunning(string phaseName, int phaseNumber, int totalPhases)
	{
		// JSON mode: silent until final result
	}

	public void ReportPhaseComplete(PhaseReport report, int phaseNumber, int totalPhases)
	{
		// JSON mode: silent until final result
	}

	public void ReportResult(SmokeTestResult result)
	{
		string json = JsonSerializer.Serialize(result, _jsonOptions);
		Console.WriteLine(json);
	}
}
