using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Services;

namespace P4NTHE0N.H4ND.Agents;

/// <summary>
/// DECISION_027: H4ND monitor agent — tracks system health including
/// CDP connectivity, platform availability, spin metrics, and session status.
/// </summary>
public sealed class MonitorAgent : IMonitorAgent
{
	private readonly IUnitOfWork _uow;
	private readonly SpinMetrics _spinMetrics;
	private readonly SessionRenewalService? _renewalService;
	private bool _active = true;

	public string AgentId => "h4nd-monitor";
	public string Name => "H4ND Monitor";
	public AgentRole Role => AgentRole.Monitor;
	public IReadOnlyList<string> Capabilities => ["health_monitoring", "session_tracking", "spin_metrics", "platform_health"];
	public bool IsActive => _active;
	public int Priority => 2;

	public MonitorAgent(IUnitOfWork uow, SpinMetrics spinMetrics, SessionRenewalService? renewalService = null)
	{
		_uow = uow;
		_spinMetrics = spinMetrics;
		_renewalService = renewalService;
	}

	public Task HandleMessageAsync(AgentMessage message, CancellationToken ct = default)
	{
		switch (message.MessageType)
		{
			case "health_check":
				Console.WriteLine($"[MonitorAgent] Health check requested by {message.FromAgent}");
				break;
			case "status_query":
				var s = _spinMetrics.GetSummary(24);
				Console.WriteLine($"[MonitorAgent] Status: Active, monitoring {s.TotalSpins} spins");
				break;
			default:
				Console.WriteLine($"[MonitorAgent] Unhandled message type: {message.MessageType}");
				break;
		}
		return Task.CompletedTask;
	}

	public Task<MonitorReport> ReportAsync(CancellationToken ct = default)
	{
		var summary = _spinMetrics.GetSummary(24);

		var report = new MonitorReport
		{
			AgentId = AgentId,
			Timestamp = DateTime.UtcNow,
			OverallStatus = DetermineOverallStatus(summary),
			Metrics = new Dictionary<string, string>
			{
				["totalSpins"] = summary.TotalSpins.ToString(),
				["successfulSpins"] = summary.Successes.ToString(),
				["failedSpins"] = summary.Failures.ToString(),
				["successRate"] = summary.TotalSpins > 0
					? $"{summary.SuccessRate:F1}%"
					: "N/A",
				["avgLatencyMs"] = summary.AvgLatencyMs.ToString("F0"),
			},
		};

		// Add platform health if renewal service available
		if (_renewalService != null)
		{
			var healthStatus = _renewalService.GetHealthStatus();
			foreach (var (platform, health) in healthStatus)
			{
				report.Metrics[$"platform_{platform}_healthy"] = health.IsHealthy.ToString();
				report.Metrics[$"platform_{platform}_failures"] = health.ConsecutiveFailures.ToString();
			}
		}

		// Check for alerts
		if (summary.TotalSpins > 10)
		{
			double successRate = summary.SuccessRate / 100.0;
			if (successRate < 0.5)
				report.Alerts.Add($"CRITICAL: Spin success rate at {successRate:P0}");
			else if (successRate < 0.8)
				report.Alerts.Add($"WARNING: Spin success rate at {successRate:P0}");
		}

		if (summary.AvgLatencyMs > 30000)
			report.Alerts.Add($"WARNING: Average spin latency at {summary.AvgLatencyMs:F0}ms");

		return Task.FromResult(report);
	}

	private static string DetermineOverallStatus(SpinSummary summary)
	{
		if (summary.TotalSpins > 10)
		{
			double successRate = summary.SuccessRate / 100.0;
			if (successRate < 0.5) return "Critical";
			if (successRate < 0.8) return "Degraded";
		}
		return "Healthy";
	}

	public void Activate() => _active = true;
	public void Deactivate() => _active = false;
}
