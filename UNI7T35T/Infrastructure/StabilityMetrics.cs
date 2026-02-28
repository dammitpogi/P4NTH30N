using System;
using System.Collections.Generic;
using System.Linq;

namespace P4NTHE0N.UNI7T35T.Infrastructure;

// DECISION_086: Coefficient of Variation (CV) calculator for forecast stability testing
// Based on Klee & Xia (2025) - CV = σ/μ, stable if CV < 0.05
public static class StabilityMetrics
{
	public const double StableThreshold = 0.05;

	public static double CalculateCV(IEnumerable<double> values)
	{
		List<double> list = values.ToList();
		if (list.Count < 2)
			throw new ArgumentException("At least 2 values required for CV calculation");

		double mean = list.Average();
		if (Math.Abs(mean) < double.Epsilon)
			return 0.0; // Per Klee & Xia: CV = 0 for constant-zero

		double variance = list.Select(v => Math.Pow(v - mean, 2)).Sum() / (list.Count - 1);
		double stdDev = Math.Sqrt(variance);

		return stdDev / Math.Abs(mean);
	}

	public static double CalculateCVFromDateTimes(IEnumerable<DateTime> etas)
	{
		List<DateTime> etaList = etas.ToList();
		if (etaList.Count < 2)
			throw new ArgumentException("At least 2 ETA values required");

		DateTime baseline = etaList.Min();
		List<double> minuteValues = etaList.Select(e => (e - baseline).TotalMinutes).ToList();

		return CalculateCV(minuteValues);
	}

	public static bool IsStable(double cv) => cv < StableThreshold;
}
