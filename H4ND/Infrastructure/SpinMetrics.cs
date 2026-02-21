using System.Collections.Concurrent;

namespace P4NTH30N.H4ND.Infrastructure;

/// <summary>
/// OPS-JP-001: Operational monitoring for spin execution.
/// Thread-safe collection of spin records with hourly summary aggregation.
/// </summary>
public sealed class SpinMetrics
{
	private readonly ConcurrentQueue<SpinRecord> _records = new();
	private readonly int _maxRecords;

	public SpinMetrics(int maxRecords = 10000)
	{
		_maxRecords = maxRecords;
	}

	/// <summary>
	/// Records a spin attempt (success or failure).
	/// </summary>
	public void RecordSpin(SpinRecord record)
	{
		_records.Enqueue(record);

		// Evict oldest if over capacity
		while (_records.Count > _maxRecords && _records.TryDequeue(out _)) { }
	}

	/// <summary>
	/// Returns an hourly summary of spin metrics for the last N hours.
	/// </summary>
	public SpinSummary GetSummary(int hours = 1)
	{
		DateTime cutoff = DateTime.UtcNow.AddHours(-hours);
		List<SpinRecord> recent = _records.Where(r => r.Timestamp >= cutoff).ToList();

		if (recent.Count == 0)
		{
			return new SpinSummary { PeriodStart = cutoff, PeriodEnd = DateTime.UtcNow };
		}

		int successes = recent.Count(r => r.Success);
		int failures = recent.Count(r => !r.Success);
		double avgLatencyMs = recent.Average(r => r.LatencyMs);
		double p95LatencyMs = Percentile(recent.Select(r => r.LatencyMs).OrderBy(x => x).ToList(), 0.95);
		double totalBalanceChange = recent.Sum(r => r.BalanceChange);

		return new SpinSummary
		{
			PeriodStart = cutoff,
			PeriodEnd = DateTime.UtcNow,
			TotalSpins = recent.Count,
			Successes = successes,
			Failures = failures,
			SuccessRate = recent.Count > 0 ? (double)successes / recent.Count * 100 : 0,
			AvgLatencyMs = avgLatencyMs,
			P95LatencyMs = p95LatencyMs,
			TotalBalanceChange = totalBalanceChange,
			SpinsPerGame = recent.GroupBy(r => r.Game).ToDictionary(g => g.Key, g => g.Count()),
			SpinsPerHouse = recent.GroupBy(r => r.House).ToDictionary(g => g.Key, g => g.Count()),
			ErrorBreakdown = recent.Where(r => !r.Success && r.ErrorMessage != null).GroupBy(r => r.ErrorMessage!).ToDictionary(g => g.Key, g => g.Count()),
		};
	}

	/// <summary>
	/// Returns all raw records (for diagnostics).
	/// </summary>
	public IReadOnlyList<SpinRecord> GetRawRecords()
	{
		return _records.ToList();
	}

	private static double Percentile(List<double> sortedValues, double percentile)
	{
		if (sortedValues.Count == 0)
			return 0;
		if (sortedValues.Count == 1)
			return sortedValues[0];

		double index = percentile * (sortedValues.Count - 1);
		int lower = (int)Math.Floor(index);
		int upper = lower + 1;
		if (upper >= sortedValues.Count)
			return sortedValues[lower];

		double weight = index - lower;
		return sortedValues[lower] * (1 - weight) + sortedValues[upper] * weight;
	}
}

/// <summary>
/// OPS-JP-001: Individual spin record.
/// </summary>
public sealed class SpinRecord
{
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public bool Success { get; set; }
	public double LatencyMs { get; set; }
	public string Game { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public double BalanceBefore { get; set; }
	public double BalanceAfter { get; set; }
	public double BalanceChange => BalanceAfter - BalanceBefore;
	public int SignalPriority { get; set; }
	public string? ErrorMessage { get; set; }
}

/// <summary>
/// OPS-JP-001: Aggregated spin summary for a time period.
/// </summary>
public sealed class SpinSummary
{
	public DateTime PeriodStart { get; set; }
	public DateTime PeriodEnd { get; set; }
	public int TotalSpins { get; set; }
	public int Successes { get; set; }
	public int Failures { get; set; }
	public double SuccessRate { get; set; }
	public double AvgLatencyMs { get; set; }
	public double P95LatencyMs { get; set; }
	public double TotalBalanceChange { get; set; }
	public Dictionary<string, int> SpinsPerGame { get; set; } = new();
	public Dictionary<string, int> SpinsPerHouse { get; set; } = new();
	public Dictionary<string, int> ErrorBreakdown { get; set; } = new();

	public override string ToString()
	{
		string games = string.Join(", ", SpinsPerGame.Select(kv => $"{kv.Key}:{kv.Value}"));
		string errors = ErrorBreakdown.Count > 0 ? string.Join(", ", ErrorBreakdown.Select(kv => $"{kv.Key}:{kv.Value}")) : "none";

		return $"[SpinMetrics] {PeriodStart:HH:mm}-{PeriodEnd:HH:mm} UTC | "
			+ $"Spins: {TotalSpins} (OK:{Successes} FAIL:{Failures}) | "
			+ $"Rate: {SuccessRate:F1}% | "
			+ $"Latency: avg={AvgLatencyMs:F0}ms p95={P95LatencyMs:F0}ms | "
			+ $"Balance: {TotalBalanceChange:+0.00;-0.00;0.00} | "
			+ $"Games: [{games}] | "
			+ $"Errors: [{errors}]";
	}
}
