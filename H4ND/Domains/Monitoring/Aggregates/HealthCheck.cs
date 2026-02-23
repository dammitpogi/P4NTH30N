using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Monitoring.Events;
using P4NTH30N.H4ND.Domains.Monitoring.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Monitoring.Aggregates;

public sealed class HealthCheck : AggregateRoot
{
	private readonly List<HealthMetric> _metrics;

	public string HealthCheckId { get; }
	public ComponentName Component { get; }
	public HealthStatus Status { get; private set; }

	public override string Id => HealthCheckId;
	public IReadOnlyCollection<HealthMetric> Metrics => _metrics.AsReadOnly();

	public HealthCheck(
		string healthCheckId,
		ComponentName component,
		HealthStatus status,
		IEnumerable<HealthMetric>? metrics = null,
		int version = 0)
	{
		HealthCheckId = Guard.MaxLength(healthCheckId, 128);
		Component = component;
		Status = status;
		_metrics = new List<HealthMetric>(metrics ?? Enumerable.Empty<HealthMetric>());
		Version = Guard.NonNegative(version);
	}

	public void RecordMetric(HealthMetric metric)
	{
		Guard.NotNull(metric);
		_metrics.Add(metric);

		if (metric.IsBreached && Status == HealthStatus.Healthy)
		{
			RaiseEvent(new HealthDegradedEvent(Component.Value, metric.Name, metric.Value, metric.Threshold));
		}
		else if (!metric.IsBreached && Status == HealthStatus.Degraded)
		{
			RaiseEvent(new HealthRecoveredEvent(Component.Value, metric.Name, metric.Value));
		}
	}

	protected override void Apply(IDomainEvent @event)
	{
		switch (@event)
		{
			case HealthDegradedEvent:
				Status = HealthStatus.Degraded;
				break;
			case HealthRecoveredEvent:
				Status = HealthStatus.Healthy;
				break;
		}
	}
}
