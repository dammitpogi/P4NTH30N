using System;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// FOUREYES-014: Model performance tracking entity.
/// Records inference metrics for model comparison and promotion decisions.
/// </summary>
public class ModelPerformance
{
	public string Id { get; set; } = Guid.NewGuid().ToString("N");
	public string ModelId { get; set; } = string.Empty;
	public string TaskName { get; set; } = string.Empty;
	public int TotalInferences { get; set; }
	public int SuccessCount { get; set; }
	public double AverageLatencyMs { get; set; }
	public double AccuracyPercent => TotalInferences > 0 ? (double)SuccessCount / TotalInferences * 100 : 0;
	public DateTime FirstUsed { get; set; } = DateTime.UtcNow;
	public DateTime LastUsed { get; set; } = DateTime.UtcNow;
	public string Device { get; set; } = "cpu";
	public long PeakMemoryBytes { get; set; }
}
