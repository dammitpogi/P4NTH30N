using System;

namespace P4NTH30N.W4TCHD0G.Models;

public class ModelPerformance
{
	public string ModelId { get; set; } = string.Empty;
	public string TaskName { get; set; } = string.Empty;
	public int TotalInferences { get; set; }
	public int SuccessCount { get; set; }
	public double AverageLatencyMs { get; set; }
	public double AccuracyPercent => TotalInferences > 0 ? (double)SuccessCount / TotalInferences * 100 : 0;
	public DateTime LastUsed { get; set; } = DateTime.UtcNow;
	public DateTime TrackingSince { get; set; } = DateTime.UtcNow;

	public void RecordInference(bool success, long latencyMs)
	{
		TotalInferences++;
		if (success)
			SuccessCount++;
		AverageLatencyMs = ((AverageLatencyMs * (TotalInferences - 1)) + latencyMs) / TotalInferences;
		LastUsed = DateTime.UtcNow;
	}
}
