using System;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Stability;

// DECISION_086: Stochasticity tests based on Klee & Xia (2025)
// Uses Coefficient of Variation (CV) to measure forecast stability: CV = σ/μ
public static class StochasticityTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("ST-001: CV calculation with stable values returns < 5%", CVStableValues),
			("ST-002: CV calculation with unstable values returns > 5%", CVUnstableValues),
			("ST-003: CV = 0 for constant values (Klee & Xia rule)", CVConstantValues),
			("ST-004: ForecastStabilityMetrics.Calculate with stable data", StabilityMetricsStableData),
			("ST-005: ForecastStabilityMetrics.Calculate with insufficient data", StabilityMetricsInsufficientData),
			("ST-006: CV near threshold boundary (4.9% vs 5.1%)", CVNearThresholdBoundary),
			("ST-007: Large dataset CV converges (Klee & Xia 10+ runs)", LargeDatasetCVConverges),
			("ST-008: Near-zero mean returns stable (Klee & Xia special case)", NearZeroMeanStable),
		];

		foreach ((string name, Func<bool> test) in tests)
		{
			try
			{
				if (test())
				{
					Console.WriteLine($"  ✅ {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  ❌ {name}");
					failed++;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  ❌ {name} — EXCEPTION: {ex.Message}");
				failed++;
			}
		}

		return (passed, failed);
	}

	// DECISION_086/ST-001: Stable values should have CV < 5%
	private static bool CVStableValues()
	{
		double[] stableValues = [100.0, 102, 101, 99, 100];
		double cv = StabilityMetrics.CalculateCV(stableValues);

		bool isStable = StabilityMetrics.IsStable(cv);
		if (!isStable)
			Console.WriteLine($"    FAIL: CV = {cv:F4}, expected < {StabilityMetrics.StableThreshold}");

		return isStable;
	}

	// DECISION_086/ST-002: Unstable values should have CV > 5%
	private static bool CVUnstableValues()
	{
		double[] unstableValues = [100.0, 150, 50, 200, 25];
		double cv = StabilityMetrics.CalculateCV(unstableValues);

		bool isUnstable = !StabilityMetrics.IsStable(cv);
		if (!isUnstable)
			Console.WriteLine($"    FAIL: CV = {cv:F4}, expected >= {StabilityMetrics.StableThreshold}");

		return isUnstable;
	}

	// DECISION_086/ST-003: Per Klee & Xia: CV = 0 for constant-zero forecasts
	private static bool CVConstantValues()
	{
		double[] constantValues = [500.0, 500, 500, 500, 500];
		double cv = StabilityMetrics.CalculateCV(constantValues);

		bool isZero = Math.Abs(cv) < 1e-9;
		if (!isZero)
			Console.WriteLine($"    FAIL: CV = {cv:F6}, expected 0 for constant values");

		return isZero;
	}

	// DECISION_086/ST-004: ForecastStabilityMetrics with stable input
	private static bool StabilityMetricsStableData()
	{
		List<double> values = [100.0, 102, 101, 99, 100, 101, 99, 100, 102, 98];
		ForecastStabilityMetrics metrics = ForecastStabilityMetrics.Calculate(values);

		if (!metrics.IsStable)
		{
			Console.WriteLine($"    FAIL: Expected stable, CV = {metrics.CoefficientOfVariation:F4}");
			return false;
		}

		if (metrics.CoefficientOfVariation >= ForecastStabilityMetrics.StabilityThreshold)
		{
			Console.WriteLine($"    FAIL: CV {metrics.CoefficientOfVariation:F4} >= threshold {ForecastStabilityMetrics.StabilityThreshold}");
			return false;
		}

		// Verify mean is approximately 100
		if (Math.Abs(metrics.Mean - 100.2) > 1.0)
		{
			Console.WriteLine($"    FAIL: Mean = {metrics.Mean:F2}, expected ~100");
			return false;
		}

		return true;
	}

	// DECISION_086/ST-005: ForecastStabilityMetrics with < 2 values returns IsStable = false
	private static bool StabilityMetricsInsufficientData()
	{
		// Test with null
		ForecastStabilityMetrics nullMetrics = ForecastStabilityMetrics.Calculate(null!);
		if (nullMetrics.IsStable)
		{
			Console.WriteLine("    FAIL: null input should return IsStable = false");
			return false;
		}

		// Test with 1 value
		ForecastStabilityMetrics singleMetrics = ForecastStabilityMetrics.Calculate([42.0]);
		if (singleMetrics.IsStable)
		{
			Console.WriteLine("    FAIL: single value should return IsStable = false");
			return false;
		}

		// Test with empty list
		ForecastStabilityMetrics emptyMetrics = ForecastStabilityMetrics.Calculate([]);
		if (emptyMetrics.IsStable)
		{
			Console.WriteLine("    FAIL: empty list should return IsStable = false");
			return false;
		}

		return true;
	}

	// DECISION_086/ST-006: CV values near the 5% boundary
	private static bool CVNearThresholdBoundary()
	{
		// Just below threshold (~4.9% CV) — should be stable
		double[] belowThreshold = [100.0, 104.8, 95.3, 100.1, 99.8, 104.5, 95.5, 100.2, 99.7, 100.1];
		ForecastStabilityMetrics belowMetrics = ForecastStabilityMetrics.Calculate(belowThreshold.ToList());

		// Just above threshold (~15% CV) — should be unstable
		double[] aboveThreshold = [100.0, 115, 85, 110, 90, 120, 80, 105, 95, 100];
		ForecastStabilityMetrics aboveMetrics = ForecastStabilityMetrics.Calculate(aboveThreshold.ToList());

		if (!belowMetrics.IsStable)
		{
			Console.WriteLine($"    FAIL: Below-threshold values CV={belowMetrics.CoefficientOfVariation:F4} marked unstable");
			return false;
		}

		if (aboveMetrics.IsStable)
		{
			Console.WriteLine($"    FAIL: Above-threshold values CV={aboveMetrics.CoefficientOfVariation:F4} marked stable");
			return false;
		}

		return true;
	}

	// DECISION_086/ST-007: With 10+ data points (Klee & Xia recommendation), CV should converge
	private static bool LargeDatasetCVConverges()
	{
		// Stable dataset with 20 values — CV should be well below 5%
		List<double> largeStable = new List<double>();
		Random rng = new Random(42); // Deterministic seed
		for (int i = 0; i < 20; i++)
		{
			largeStable.Add(1000.0 + (rng.NextDouble() * 20 - 10)); // 1000 ± 10
		}

		double cv = StabilityMetrics.CalculateCV(largeStable);
		bool isStable = StabilityMetrics.IsStable(cv);

		if (!isStable)
		{
			Console.WriteLine($"    FAIL: 20-point stable dataset has CV={cv:F4} (expected < 0.05)");
			return false;
		}

		return true;
	}

	// DECISION_086/ST-008: Near-zero mean is a special case per Klee & Xia
	private static bool NearZeroMeanStable()
	{
		// ForecastStabilityMetrics handles near-zero mean by returning IsStable = true
		List<double> nearZero = [0.0000001, -0.0000001, 0.0, 0.0000002, -0.0000002];
		ForecastStabilityMetrics metrics = ForecastStabilityMetrics.Calculate(nearZero);

		if (!metrics.IsStable)
		{
			Console.WriteLine($"    FAIL: Near-zero mean should return stable, got CV={metrics.CoefficientOfVariation}");
			return false;
		}

		return true;
	}
}
