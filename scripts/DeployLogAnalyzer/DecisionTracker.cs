using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTHE0N.DeployLogAnalyzer;

/// <summary>
/// Tracks deployment go/no-go decisions and implements rollback logic.
/// Uses a 2/3 consecutive NO-GO threshold to trigger automatic rollback.
/// </summary>
public sealed class DecisionTracker
{
	private readonly string _historyFilePath;
	private readonly int _rollbackThreshold;
	private readonly List<DeploymentDecision> _decisions = new();

	/// <summary>
	/// Number of consecutive NO-GO decisions.
	/// </summary>
	public int ConsecutiveNoGoCount { get; private set; }

	/// <summary>
	/// Whether automatic rollback has been triggered.
	/// </summary>
	public bool RollbackTriggered { get; private set; }

	/// <summary>
	/// Total decisions recorded.
	/// </summary>
	public int TotalDecisions => _decisions.Count;

	public DecisionTracker(string historyFilePath = "deployment-decisions.json", int rollbackThreshold = 2)
	{
		_historyFilePath = historyFilePath;
		_rollbackThreshold = rollbackThreshold;
	}

	/// <summary>
	/// Records a deployment decision and evaluates rollback conditions.
	/// </summary>
	/// <returns>True if rollback is triggered.</returns>
	public bool RecordDecision(DeploymentDecision decision)
	{
		_decisions.Add(decision);

		if (decision.Decision == DeployDecision.NoGo)
		{
			ConsecutiveNoGoCount++;
		}
		else
		{
			ConsecutiveNoGoCount = 0;
			RollbackTriggered = false;
		}

		// Check 2/3 threshold
		if (ConsecutiveNoGoCount >= _rollbackThreshold)
		{
			RollbackTriggered = true;
			decision.RollbackTriggered = true;
		}

		return RollbackTriggered;
	}

	/// <summary>
	/// Creates a decision from health report and log analysis.
	/// </summary>
	public DeploymentDecision CreateDecision(HealthReport healthReport, LogAnalysisReport logReport)
	{
		DeployDecision decision;
		double confidence;
		string rationale;
		List<string> risks = new();

		bool hasCriticalErrors = logReport.CriticalCount > 0;
		bool isHealthy = healthReport.IsHealthy;
		bool servicesUp = healthReport.Checks.All(c => c.Score > 0.0);

		if (!isHealthy)
		{
			decision = DeployDecision.NoGo;
			confidence = 0.95;
			rationale = $"Health score {healthReport.OverallScore:F2} below threshold (0.6)";
			risks.Add("System instability may cause deployment failures");
		}
		else if (hasCriticalErrors)
		{
			decision = DeployDecision.NoGo;
			confidence = 0.90;
			rationale = $"{logReport.CriticalCount} critical error(s) detected";
			risks.AddRange(logReport.ErrorPatterns.Select(p => $"Critical pattern: {p}"));
		}
		else if (!servicesUp)
		{
			decision = DeployDecision.NoGo;
			confidence = 0.85;
			rationale = "One or more required services unavailable";
			List<string> downServices = healthReport.Checks.Where(c => c.Score == 0.0).Select(c => c.Name).ToList();
			risks.Add($"Services down: {string.Join(", ", downServices)}");
		}
		else
		{
			decision = DeployDecision.Go;
			confidence = Math.Min(0.95, healthReport.OverallScore);
			rationale = "All systems healthy, no critical errors";
			if (logReport.WarningCount > 0)
			{
				risks.Add($"{logReport.WarningCount} warning(s) should be investigated post-deploy");
			}
		}

		return new DeploymentDecision
		{
			Timestamp = DateTime.UtcNow,
			Decision = decision,
			Confidence = confidence,
			Rationale = rationale,
			Risks = risks,
			HealthScore = healthReport.OverallScore,
			CriticalErrors = logReport.CriticalCount,
			Warnings = logReport.WarningCount,
		};
	}

	/// <summary>
	/// Gets the last N decisions from history.
	/// </summary>
	public IReadOnlyList<DeploymentDecision> GetRecentDecisions(int count = 10)
	{
		return _decisions.OrderByDescending(d => d.Timestamp).Take(count).ToList().AsReadOnly();
	}

	/// <summary>
	/// Resets consecutive NO-GO counter (manual override).
	/// </summary>
	public void ResetNoGoCounter()
	{
		ConsecutiveNoGoCount = 0;
		RollbackTriggered = false;
	}

	/// <summary>
	/// Persists decision history to JSON file.
	/// </summary>
	public async Task SaveHistoryAsync(CancellationToken cancellationToken = default)
	{
		JsonSerializerOptions options = new() { WriteIndented = true, Converters = { new JsonStringEnumConverter() } };

		string json = JsonSerializer.Serialize(_decisions, options);
		await File.WriteAllTextAsync(_historyFilePath, json, cancellationToken);
	}

	/// <summary>
	/// Loads decision history from JSON file.
	/// </summary>
	public async Task LoadHistoryAsync(CancellationToken cancellationToken = default)
	{
		if (!File.Exists(_historyFilePath))
			return;

		JsonSerializerOptions options = new() { Converters = { new JsonStringEnumConverter() } };

		string json = await File.ReadAllTextAsync(_historyFilePath, cancellationToken);
		List<DeploymentDecision>? loaded = JsonSerializer.Deserialize<List<DeploymentDecision>>(json, options);

		if (loaded != null)
		{
			_decisions.Clear();
			_decisions.AddRange(loaded);

			// Recalculate consecutive NO-GO count
			ConsecutiveNoGoCount = 0;
			foreach (DeploymentDecision d in _decisions.OrderBy(x => x.Timestamp))
			{
				if (d.Decision == DeployDecision.NoGo)
				{
					ConsecutiveNoGoCount++;
				}
				else
				{
					ConsecutiveNoGoCount = 0;
				}
			}

			RollbackTriggered = ConsecutiveNoGoCount >= _rollbackThreshold;
		}
	}
}

/// <summary>
/// A single deployment go/no-go decision.
/// </summary>
public sealed class DeploymentDecision
{
	public DateTime Timestamp { get; init; }
	public DeployDecision Decision { get; init; }
	public double Confidence { get; init; }
	public string Rationale { get; init; } = string.Empty;
	public List<string> Risks { get; init; } = new();
	public double HealthScore { get; init; }
	public int CriticalErrors { get; init; }
	public int Warnings { get; init; }
	public bool RollbackTriggered { get; set; }
}

public enum DeployDecision
{
	Go,
	NoGo,
}
