using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Monitoring.Events;

public sealed record HealthDegradedEvent : DomainEventBase
{
	public string ComponentName { get; init; }
	public string MetricName { get; init; }
	public double Value { get; init; }
	public double Threshold { get; init; }

	public override string AggregateId => ComponentName;

	public HealthDegradedEvent(string componentName, string metricName, double value, double threshold)
	{
		ComponentName = Guard.MaxLength(componentName, 128);
		MetricName = Guard.MaxLength(metricName, 128);
		Value = value;
		Threshold = threshold;
	}
}

public sealed record HealthRecoveredEvent : DomainEventBase
{
	public string ComponentName { get; init; }
	public string MetricName { get; init; }
	public double Value { get; init; }

	public override string AggregateId => ComponentName;

	public HealthRecoveredEvent(string componentName, string metricName, double value)
	{
		ComponentName = Guard.MaxLength(componentName, 128);
		MetricName = Guard.MaxLength(metricName, 128);
		Value = value;
	}
}
