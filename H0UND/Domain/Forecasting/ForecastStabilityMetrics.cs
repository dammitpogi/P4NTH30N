using System;
using System.Collections.Generic;
using System.Linq;

namespace P4NTH30N.H0UND.Domain.Forecasting;

// DECISION_085: Forecast stability metrics based on Klee & Xia (2025) research
// CV = σ/μ, target CV < 5% for stable forecasts
public readonly record struct ForecastStabilityMetrics
{
	public double CoefficientOfVariation { get; init; }
	public double StandardDeviation { get; init; }
	public double Mean { get; init; }
	public bool IsStable { get; init; }

	// DECISION_085: CV threshold from Klee & Xia (2025) - stable if < 5%
	public const double StabilityThreshold = 0.05;

	public static ForecastStabilityMetrics Calculate(List<double> values)
	{
		if (values == null || values.Count < 2)
			return new ForecastStabilityMetrics { IsStable = false };

		double mean = values.Average();
		if (Math.Abs(mean) < 1e-9)
			return new ForecastStabilityMetrics { Mean = 0, IsStable = true };

		double variance = values.Sum(v => Math.Pow(v - mean, 2)) / (values.Count - 1);
		double stdDev = Math.Sqrt(variance);
		double cv = stdDev / Math.Abs(mean);

		return new ForecastStabilityMetrics
		{
			Mean = mean,
			StandardDeviation = stdDev,
			CoefficientOfVariation = cv,
			IsStable = cv < StabilityThreshold,
		};
	}
}
