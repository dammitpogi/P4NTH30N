using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Monitoring.ValueObjects;

public sealed record HealthMetric
{
	public string Name { get; init; }
	public double Value { get; init; }
	public double Threshold { get; init; }
	public DateTime ObservedAtUtc { get; init; }

	public bool IsBreached => Value > Threshold;

	public HealthMetric(string name, double value, double threshold, DateTime observedAtUtc)
	{
		Name = Guard.MaxLength(name, 128);
		Value = value;
		Threshold = threshold;
		ObservedAtUtc = Guard.NotMinValue(observedAtUtc);
	}
}
