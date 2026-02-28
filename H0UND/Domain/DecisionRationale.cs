using System.Collections.Generic;

namespace P4NTHE0N.H0UND.Domain;

public class DecisionRationale
{
	public string Summary { get; set; } = string.Empty;
	public List<string> Factors { get; set; } = new();
	public double ThresholdProximity { get; set; }
	public double EstimatedMinutesToPop { get; set; }
	public double DPDAverage { get; set; }
	public string TriggeredBy { get; set; } = string.Empty;
}
