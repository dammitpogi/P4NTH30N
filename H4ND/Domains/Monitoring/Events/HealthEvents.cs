using System;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Monitoring.Events;

/// <summary>
/// DECISION_110 Phase 3: Component health degraded below threshold.
/// </summary>
public sealed record HealthDegraded : DomainEventBase
{
	public string ComponentName { get; init; }
	public string MetricName { get; init; }
	public double CurrentValue { get; init; }
	public double Threshold { get; init; }
	public string Severity { get; init; }
	public string? Details { get; init; }

	public override string AggregateId => ComponentName;

	public HealthDegraded(
		string componentName,
		string metricName,
		double currentValue,
		double threshold,
		string severity,
		string? details = null)
	{
		ComponentName = Guard.NotNullOrWhiteSpace(componentName);
		MetricName = Guard.NotNullOrWhiteSpace(metricName);
		CurrentValue = currentValue;
		Threshold = threshold;
		Severity = Guard.NotNullOrWhiteSpace(severity);
		Details = details;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Component health recovered to acceptable level.
/// </summary>
public sealed record HealthRecovered : DomainEventBase
{
	public string ComponentName { get; init; }
	public string MetricName { get; init; }
	public double CurrentValue { get; init; }
	public TimeSpan DegradedDuration { get; init; }
	public string? RecoveryAction { get; init; }

	public override string AggregateId => ComponentName;

	public HealthRecovered(
		string componentName,
		string metricName,
		double currentValue,
		TimeSpan degradedDuration,
		string? recoveryAction = null)
	{
		ComponentName = Guard.NotNullOrWhiteSpace(componentName);
		MetricName = Guard.NotNullOrWhiteSpace(metricName);
		CurrentValue = currentValue;
		DegradedDuration = degradedDuration;
		RecoveryAction = recoveryAction;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Periodic health check completed.
/// </summary>
public sealed record HealthCheckCompleted : DomainEventBase
{
	public string CheckId { get; init; }
	public string ComponentName { get; init; }
	public bool IsHealthy { get; init; }
	public double LatencyMs { get; init; }
	public string? ErrorMessage { get; init; }

	public override string AggregateId => CheckId;

	public HealthCheckCompleted(
		string checkId,
		string componentName,
		bool isHealthy,
		double latencyMs,
		string? errorMessage = null)
	{
		CheckId = Guard.NotNullOrWhiteSpace(checkId);
		ComponentName = Guard.NotNullOrWhiteSpace(componentName);
		IsHealthy = isHealthy;
		LatencyMs = latencyMs;
		ErrorMessage = errorMessage;
	}
}
