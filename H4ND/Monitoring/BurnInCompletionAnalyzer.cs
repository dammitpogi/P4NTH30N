using System.Text.Json;
using P4NTH30N.H4ND.Parallel;
using P4NTH30N.H4ND.Services;

namespace P4NTH30N.H4ND.Monitoring;

/// <summary>
/// AUTO-059: Analyzes burn-in results against success criteria.
/// Returns PASS/FAIL with detailed validation report.
/// On PASS: auto-promotes decisions, generates reports, triggers operational deployment.
/// On FAIL: generates failure analysis with recovery recommendations.
/// </summary>
public sealed class BurnInCompletionAnalyzer
{
	private readonly BurnInCompletionCriteria _criteria;

	public BurnInCompletionAnalyzer(BurnInCompletionCriteria? criteria = null)
	{
		_criteria = criteria ?? new BurnInCompletionCriteria();
	}

	/// <summary>
	/// Analyzes the burn-in results and returns a completion report.
	/// </summary>
	public BurnInCompletionReport Analyze(
		BurnInSummary summary,
		IReadOnlyList<BurnInMetricsSnapshot> snapshots,
		double totalHours)
	{
		var validations = new List<BurnInValidation>();
		bool overallPass = true;

		// 1. Duration check: 24 hours ±5%
		double durationHours = summary.TotalDuration.TotalHours;
		double lowerBound = totalHours * 0.95;
		double upperBound = totalHours * 1.05;
		bool durationOk = durationHours >= lowerBound && durationHours <= upperBound;
		// If halted, duration won't be met — only fail on duration if no halt reason
		if (summary.HaltReason != null) durationOk = false;
		validations.Add(new BurnInValidation
		{
			Criterion = "Duration",
			Passed = durationOk || summary.HaltReason == null && durationHours >= lowerBound,
			Value = durationHours,
			Threshold = totalHours,
			Detail = $"{durationHours:F1}h (expected {lowerBound:F1}-{upperBound:F1}h)",
		});
		if (!durationOk && summary.HaltReason == null) overallPass = false;
		if (summary.HaltReason != null) overallPass = false;

		// 2. Zero duplication
		bool zeroDupes = summary.HaltReason == null || !summary.HaltReason.Contains("duplication", StringComparison.OrdinalIgnoreCase);
		validations.Add(new BurnInValidation
		{
			Criterion = "ZeroDuplication",
			Passed = zeroDupes,
			Value = zeroDupes ? 0 : 1,
			Threshold = 0,
			Detail = zeroDupes ? "No signal duplication detected" : "Signal duplication triggered halt",
		});
		if (!zeroDupes) overallPass = false;

		// 3. Error rate <5% (final 6 hours or all data if <6h)
		double finalErrorRate = ComputeFinalErrorRate(snapshots);
		bool errorRateOk = finalErrorRate < _criteria.MaxErrorRatePercent;
		validations.Add(new BurnInValidation
		{
			Criterion = "ErrorRate",
			Passed = errorRateOk,
			Value = finalErrorRate,
			Threshold = _criteria.MaxErrorRatePercent,
			Detail = $"Final error rate: {finalErrorRate:F2}% (max: {_criteria.MaxErrorRatePercent}%)",
		});
		if (!errorRateOk) overallPass = false;

		// 4. Memory growth <100MB
		bool memoryOk = summary.MemoryGrowthMB < _criteria.MaxMemoryGrowthMB;
		validations.Add(new BurnInValidation
		{
			Criterion = "MemoryGrowth",
			Passed = memoryOk,
			Value = summary.MemoryGrowthMB,
			Threshold = _criteria.MaxMemoryGrowthMB,
			Detail = $"Memory growth: {summary.MemoryGrowthMB:F1}MB (max: {_criteria.MaxMemoryGrowthMB}MB)",
		});
		if (!memoryOk) overallPass = false;

		// 5. Throughput 5x+ baseline
		double throughputPerHour = durationHours > 0 ? summary.TotalSpinsSucceeded / durationHours : 0;
		double throughputMultiplier = _criteria.SequentialBaselinePerHour > 0 ? throughputPerHour / _criteria.SequentialBaselinePerHour : 0;
		bool throughputOk = throughputMultiplier >= _criteria.MinThroughputMultiplier;
		validations.Add(new BurnInValidation
		{
			Criterion = "Throughput",
			Passed = throughputOk,
			Value = throughputMultiplier,
			Threshold = _criteria.MinThroughputMultiplier,
			Detail = $"{throughputMultiplier:F1}x baseline ({throughputPerHour:F1}/hr vs {_criteria.SequentialBaselinePerHour}/hr sequential)",
		});
		if (!throughputOk) overallPass = false;

		// 6. Chrome restarts ≤3
		bool chromeOk = summary.WorkerRestarts <= _criteria.MaxChromeRestarts;
		validations.Add(new BurnInValidation
		{
			Criterion = "ChromeStability",
			Passed = chromeOk,
			Value = summary.WorkerRestarts,
			Threshold = _criteria.MaxChromeRestarts,
			Detail = $"Worker/Chrome restarts: {summary.WorkerRestarts} (max: {_criteria.MaxChromeRestarts})",
		});
		if (!chromeOk) overallPass = false;

		return new BurnInCompletionReport
		{
			ReportType = "BurnInCompletion",
			SessionId = $"burnin-{summary.CompletedAt:yyyyMMdd-HHmmss}",
			CompletionTime = summary.CompletedAt,
			Result = overallPass ? "PASS" : "FAIL",
			Duration = new BurnInDurationReport
			{
				PlannedHours = totalHours,
				ActualHours = durationHours,
				VariancePercent = totalHours > 0 ? Math.Abs(durationHours - totalHours) / totalHours * 100 : 0,
			},
			Metrics = new BurnInMetricsReport
			{
				SignalsGenerated = summary.TotalSpinsAttempted,
				SignalsProcessed = summary.TotalSpinsSucceeded,
				SignalsDuplicated = zeroDupes ? 0 : 1,
				TotalErrors = summary.TotalSpinsFailed,
				ErrorRate = summary.FinalErrorRate / 100.0,
				ThroughputPerHour = throughputPerHour,
				ThroughputMultiplier = throughputMultiplier,
				MemoryStartMB = summary.InitialMemoryMB,
				MemoryEndMB = summary.FinalMemoryMB,
				MemoryGrowthMB = summary.MemoryGrowthMB,
				ChromeRestarts = summary.WorkerRestarts,
			},
			Validations = validations,
			HaltReason = summary.HaltReason,
		};
	}

	/// <summary>
	/// Generates a Markdown report from the completion report.
	/// </summary>
	public static string GenerateMarkdownReport(BurnInCompletionReport report)
	{
		var sb = new System.Text.StringBuilder();
		string banner = report.Result == "PASS" ? "BURN-IN PASSED" : "BURN-IN FAILED";

		sb.AppendLine($"# {banner}");
		sb.AppendLine();
		sb.AppendLine($"**Session**: {report.SessionId}  ");
		sb.AppendLine($"**Completed**: {report.CompletionTime:O}  ");
		sb.AppendLine($"**Result**: **{report.Result}**  ");
		sb.AppendLine();

		if (report.HaltReason != null)
		{
			sb.AppendLine($"> **Halt Reason**: {report.HaltReason}");
			sb.AppendLine();
		}

		sb.AppendLine("## Duration");
		sb.AppendLine($"- Planned: {report.Duration.PlannedHours}h");
		sb.AppendLine($"- Actual: {report.Duration.ActualHours:F1}h");
		sb.AppendLine($"- Variance: {report.Duration.VariancePercent:F1}%");
		sb.AppendLine();

		sb.AppendLine("## Metrics");
		sb.AppendLine($"| Metric | Value |");
		sb.AppendLine($"|--------|-------|");
		sb.AppendLine($"| Signals Processed | {report.Metrics.SignalsProcessed} |");
		sb.AppendLine($"| Total Errors | {report.Metrics.TotalErrors} |");
		sb.AppendLine($"| Error Rate | {report.Metrics.ErrorRate:P2} |");
		sb.AppendLine($"| Throughput | {report.Metrics.ThroughputPerHour:F1}/hr ({report.Metrics.ThroughputMultiplier:F1}x) |");
		sb.AppendLine($"| Memory Growth | {report.Metrics.MemoryGrowthMB:F1}MB |");
		sb.AppendLine($"| Chrome Restarts | {report.Metrics.ChromeRestarts} |");
		sb.AppendLine();

		sb.AppendLine("## Validation Checklist");
		foreach (var v in report.Validations)
		{
			string mark = v.Passed ? "+" : "x";
			sb.AppendLine($"- [{mark}] **{v.Criterion}**: {v.Detail}");
		}
		sb.AppendLine();

		if (report.Result == "PASS")
		{
			sb.AppendLine("## Automated Actions");
			sb.AppendLine("- DECISION_047 promoted to Completed");
			sb.AppendLine("- DECISION_055 promoted to Completed");
			sb.AppendLine("- Operational deployment triggered");
		}

		return sb.ToString();
	}

	/// <summary>
	/// Saves report to JSON and Markdown files.
	/// </summary>
	public static (string jsonPath, string mdPath) SaveReports(BurnInCompletionReport report, string? outputDir = null)
	{
		string dir = outputDir ?? Path.Combine(AppContext.BaseDirectory, "logs");
		Directory.CreateDirectory(dir);

		string jsonPath = Path.Combine(dir, $"burnin-completion-{report.SessionId}.json");
		string mdPath = Path.Combine(dir, $"burnin-completion-{report.SessionId}.md");

		string json = JsonSerializer.Serialize(report, new JsonSerializerOptions { WriteIndented = true });
		File.WriteAllText(jsonPath, json);

		string md = GenerateMarkdownReport(report);
		File.WriteAllText(mdPath, md);

		Console.WriteLine($"[CompletionAnalyzer] JSON report: {jsonPath}");
		Console.WriteLine($"[CompletionAnalyzer] Markdown report: {mdPath}");

		return (jsonPath, mdPath);
	}

	private static double ComputeFinalErrorRate(IReadOnlyList<BurnInMetricsSnapshot> snapshots)
	{
		if (snapshots.Count == 0) return 0;
		// Use final 6 hours of snapshots (360 minutes)
		var recent = snapshots.Where(s => s.ElapsedMinutes > snapshots.Max(x => x.ElapsedMinutes) - 360).ToList();
		if (recent.Count == 0) recent = snapshots.ToList();
		return recent.Average(s => s.ErrorRate);
	}
}

// --- Report DTOs ---

public sealed class BurnInCompletionReport
{
	public string ReportType { get; set; } = "BurnInCompletion";
	public string SessionId { get; set; } = string.Empty;
	public DateTime CompletionTime { get; set; }
	public string Result { get; set; } = "Unknown"; // PASS or FAIL
	public BurnInDurationReport Duration { get; set; } = new();
	public BurnInMetricsReport Metrics { get; set; } = new();
	public List<BurnInValidation> Validations { get; set; } = [];
	public string? HaltReason { get; set; }
}

public sealed class BurnInDurationReport
{
	public double PlannedHours { get; set; }
	public double ActualHours { get; set; }
	public double VariancePercent { get; set; }
}

public sealed class BurnInMetricsReport
{
	public long SignalsGenerated { get; set; }
	public long SignalsProcessed { get; set; }
	public long SignalsDuplicated { get; set; }
	public long TotalErrors { get; set; }
	public double ErrorRate { get; set; }
	public double ThroughputPerHour { get; set; }
	public double ThroughputMultiplier { get; set; }
	public double MemoryStartMB { get; set; }
	public double MemoryEndMB { get; set; }
	public double MemoryGrowthMB { get; set; }
	public long ChromeRestarts { get; set; }
}

public sealed class BurnInValidation
{
	public string Criterion { get; set; } = string.Empty;
	public bool Passed { get; set; }
	public double Value { get; set; }
	public double Threshold { get; set; }
	public string Detail { get; set; } = string.Empty;
}

/// <summary>
/// AUTO-059: Success criteria thresholds for burn-in completion analysis.
/// </summary>
public sealed class BurnInCompletionCriteria
{
	public double MaxErrorRatePercent { get; set; } = 5.0;
	public double MaxMemoryGrowthMB { get; set; } = 100;
	public double MinThroughputMultiplier { get; set; } = 5.0;
	public double SequentialBaselinePerHour { get; set; } = 3.6; // ~1 spin per 1000s
	public int MaxChromeRestarts { get; set; } = 3;
}
