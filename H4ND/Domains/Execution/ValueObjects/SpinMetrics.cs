namespace P4NTHE0N.H4ND.Domains.Execution.ValueObjects;

public sealed record SpinMetrics
{
	public int TotalSpins { get; init; }
	public int SuccessfulSpins { get; init; }
	public int FailedSpins { get; init; }
	public double AverageLatencyMs { get; init; }
}
