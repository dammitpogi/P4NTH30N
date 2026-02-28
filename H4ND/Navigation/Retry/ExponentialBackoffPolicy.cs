namespace P4NTHE0N.H4ND.Navigation.Retry;

/// <summary>
/// ARCH-098: Exponential backoff with jitter for retry delays.
/// 1s → 2s → 4s with ±10% jitter to prevent thundering herd.
/// </summary>
public sealed class ExponentialBackoffPolicy
{
	private static readonly Random _jitterRandom = new();

	public int MaxRetries { get; init; } = 3;
	public TimeSpan InitialDelay { get; init; } = TimeSpan.FromSeconds(1);
	public double JitterFraction { get; init; } = 0.10;

	public TimeSpan CalculateDelay(int attempt)
	{
		double baseMs = InitialDelay.TotalMilliseconds * Math.Pow(2, attempt - 1);
		double jitter = baseMs * JitterFraction * (2.0 * _jitterRandom.NextDouble() - 1.0);
		return TimeSpan.FromMilliseconds(Math.Max(100, baseMs + jitter));
	}
}
