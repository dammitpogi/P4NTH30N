namespace P4NTHE0N.C0MMON.Infrastructure.Monitoring;

/// <summary>
/// Health check system for P4NTHE0N components.
/// Reports component health status for monitoring dashboards.
/// </summary>
/// <remarks>
/// INFRA-004: Monitoring and Observability Stack.
/// Provides /health, /health/ready, /health/live equivalent checks.
/// </remarks>
public sealed class HealthCheckService
{
	private readonly Dictionary<string, Func<HealthCheckResult>> _checks = new();
	private readonly object _lock = new();

	/// <summary>
	/// Registers a health check for a named component.
	/// </summary>
	public void Register(string name, Func<HealthCheckResult> check)
	{
		lock (_lock)
		{
			_checks[name] = check;
		}
	}

	/// <summary>
	/// Runs all registered health checks and returns aggregate status.
	/// </summary>
	public HealthReport Check()
	{
		Dictionary<string, HealthCheckResult> results = new();
		HealthStatus overall = HealthStatus.Healthy;

		lock (_lock)
		{
			foreach (KeyValuePair<string, Func<HealthCheckResult>> kv in _checks)
			{
				try
				{
					HealthCheckResult result = kv.Value();
					results[kv.Key] = result;

					if (result.Status == HealthStatus.Unhealthy)
						overall = HealthStatus.Unhealthy;
					else if (result.Status == HealthStatus.Degraded && overall != HealthStatus.Unhealthy)
						overall = HealthStatus.Degraded;
				}
				catch (Exception ex)
				{
					results[kv.Key] = new HealthCheckResult { Status = HealthStatus.Unhealthy, Description = $"Check threw exception: {ex.Message}" };
					overall = HealthStatus.Unhealthy;
				}
			}
		}

		return new HealthReport
		{
			Status = overall,
			Results = results,
			Timestamp = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Liveness check — is the process running?
	/// </summary>
	public bool IsLive() => true;

	/// <summary>
	/// Readiness check — are all dependencies healthy?
	/// </summary>
	public bool IsReady()
	{
		HealthReport report = Check();
		return report.Status != HealthStatus.Unhealthy;
	}
}

/// <summary>
/// Result of a single health check.
/// </summary>
public sealed class HealthCheckResult
{
	public HealthStatus Status { get; init; } = HealthStatus.Healthy;
	public string Description { get; init; } = string.Empty;
	public Dictionary<string, object> Data { get; init; } = new();
}

/// <summary>
/// Aggregate health report across all components.
/// </summary>
public sealed class HealthReport
{
	public HealthStatus Status { get; init; }
	public Dictionary<string, HealthCheckResult> Results { get; init; } = new();
	public DateTime Timestamp { get; init; }
}

/// <summary>
/// Component health status.
/// </summary>
public enum HealthStatus
{
	/// <summary>Component is fully operational.</summary>
	Healthy,

	/// <summary>Component is operational but with reduced performance or capacity.</summary>
	Degraded,

	/// <summary>Component is not operational.</summary>
	Unhealthy,
}
