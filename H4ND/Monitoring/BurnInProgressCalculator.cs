using P4NTHE0N.H4ND.Parallel;

namespace P4NTHE0N.H4ND.Monitoring;

/// <summary>
/// MON-057-006: Calculates burn-in progress percentage, ETA, and throughput.
/// </summary>
public sealed class BurnInProgressCalculator
{
	private readonly double _totalHours;
	private readonly DateTime _startedAt;

	public BurnInProgressCalculator(double totalHours)
	{
		_totalHours = totalHours;
		_startedAt = DateTime.UtcNow;
	}

	public double ElapsedHours => (DateTime.UtcNow - _startedAt).TotalHours;

	public double PercentComplete
	{
		get
		{
			if (_totalHours <= 0) return 100;
			double pct = ElapsedHours / _totalHours * 100.0;
			return Math.Min(100, Math.Max(0, pct));
		}
	}

	public DateTime? Eta
	{
		get
		{
			double remaining = _totalHours - ElapsedHours;
			if (remaining <= 0) return null;
			return DateTime.UtcNow.AddHours(remaining);
		}
	}

	public double ThroughputPerHour(long signalsProcessed)
	{
		double hours = ElapsedHours;
		return hours > 0 ? signalsProcessed / hours : 0;
	}

	public bool IsComplete => ElapsedHours >= _totalHours;

	public bool IsWithinTolerance(double tolerancePercent = 5.0)
	{
		double lowerBound = _totalHours * (1.0 - tolerancePercent / 100.0);
		double upperBound = _totalHours * (1.0 + tolerancePercent / 100.0);
		return ElapsedHours >= lowerBound && ElapsedHours <= upperBound;
	}
}
