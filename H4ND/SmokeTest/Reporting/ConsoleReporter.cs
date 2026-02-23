namespace P4NTH30N.H4ND.SmokeTest.Reporting;

/// <summary>
/// ARCH-099: Human-readable console output with progress indicators.
/// Matches the specification format from DECISION_099.
/// </summary>
public sealed class ConsoleReporter : ISmokeTestReporter
{
	private const string Bar = "═══════════════════════════════════════════════════════════════════";
	private const int TotalPhases = 4;

	public void ReportStart(SmokeTestConfig config)
	{
		Console.WriteLine();
		Console.WriteLine(Bar);
		Console.WriteLine("  P4NTH30N SMOKE TEST - FireKirin Login Validation");
		Console.WriteLine(Bar);
		Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] TEST STARTED");
		Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] Target: {config.Platform}");
		Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] Profile: Profile-{config.Profile} on port {config.Port}");
	}

	public void ReportPhaseRunning(string phaseName, int phaseNumber, int totalPhases)
	{
		string label = $"Phase {phaseNumber}/{totalPhases}: {phaseName}";
		string dots = new('.', Math.Max(1, 49 - label.Length));
		Console.Write($"[{DateTime.Now:HH:mm:ss}] {label} {dots} RUNNING");
	}

	public void ReportPhaseComplete(PhaseReport report, int phaseNumber, int totalPhases)
	{
		// Overwrite the RUNNING line
		Console.Write('\r');
		string label = $"Phase {phaseNumber}/{totalPhases}: {report.Name}";
		string dots = new('.', Math.Max(1, 49 - label.Length));
		string status = report.Success ? "PASS" : "FAIL";
		string color = report.Success ? "\u001b[32m" : "\u001b[31m";
		string reset = "\u001b[0m";

		Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] {label} {dots} {color}{status}{reset} ({report.DurationSeconds}s)");

		if (report.Success && !string.IsNullOrEmpty(report.Detail))
		{
			Console.WriteLine($"           {report.Detail}");
		}

		if (!report.Success && !string.IsNullOrEmpty(report.ErrorMessage))
		{
			Console.WriteLine($"           ERROR: {report.ErrorMessage}");
		}
	}

	public void ReportResult(SmokeTestResult result)
	{
		Console.WriteLine(Bar);

		string color = result.Outcome == SmokeTestOutcome.Pass ? "\u001b[32m" : "\u001b[31m";
		string reset = "\u001b[0m";

		Console.WriteLine($"  RESULT: {color}{result.Outcome.ToString().ToUpperInvariant()}{reset}");
		Console.WriteLine($"  Duration: {result.DurationSeconds} seconds");

		if (result.Balance > 0)
			Console.WriteLine($"  Balance: ${result.Balance:F2}");

		if (!string.IsNullOrEmpty(result.ErrorMessage))
			Console.WriteLine($"  Error: {result.ErrorMessage}");

		Console.WriteLine($"  Gate: {result.GateDecision}");
		Console.WriteLine(Bar);
		Console.WriteLine();
	}
}
