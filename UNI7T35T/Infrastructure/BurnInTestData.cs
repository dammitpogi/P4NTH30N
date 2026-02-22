using System;
using System.Collections.Generic;
using P4NTH30N.C0MMON;

namespace P4NTH30N.UNI7T35T.Infrastructure;

// DECISION_086: Parameterized test data for burn-in validation
// Organized by research dimension (Liu & Zhang 2019 sampling, Hu et al. 2025 data quality)
public static class BurnInTestData
{
	// Liu & Zhang (2019): Minimum sampling boundary conditions
	public static IEnumerable<object[]> DpdDataPointScenarios()
	{
		yield return new object[] { 0, false, "No samples" };
		yield return new object[] { 1, false, "One sample" };
		yield return new object[] { 2, false, "Two samples" };
		yield return new object[] { 3, false, "Three samples" };
		yield return new object[] { 4, true, "Four samples - minimum valid" };
		yield return new object[] { 10, true, "Ten samples - optimal" };
		yield return new object[] { 100, true, "Hundred samples - abundant" };
	}

	// Hu et al. (2025): DPD bounds validation scenarios
	public static IEnumerable<object[]> DpdBoundsScenarios()
	{
		yield return new object[] { -1.0, false, "Negative DPD" };
		yield return new object[] { 0.0, false, "Zero DPD" };
		yield return new object[] { 0.005, false, "Below minimum (0.01)" };
		yield return new object[] { 0.01, true, "Exact minimum" };
		yield return new object[] { 100.0, true, "Normal DPD" };
		yield return new object[] { 725.69, true, "Observed real DPD" };
		yield return new object[] { 50000.0, true, "Exact maximum" };
		yield return new object[] { 50001.0, false, "Above maximum" };
		yield return new object[] { 100000.0, false, "Extreme high DPD" };
		yield return new object[] { double.NaN, false, "NaN DPD" };
		yield return new object[] { double.PositiveInfinity, false, "Infinity DPD" };
	}

	// Klee & Xia (2025): CV stability scenarios
	public static IEnumerable<object[]> CVStabilityScenarios()
	{
		yield return new object[] { new double[] { 100.0, 102, 101, 99, 100 }, true, "Stable (CV ~2%)" };
		yield return new object[] { new double[] { 100.0, 150, 50, 200, 25 }, false, "Unstable (CV >50%)" };
		yield return new object[] { new double[] { 500.0, 500, 500, 500, 500 }, true, "Constant values (CV = 0)" };
		yield return new object[] { new double[] { 100.0, 103, 97, 101, 99 }, true, "Slightly variable (CV ~3%)" };
		yield return new object[] { new double[] { 100.0, 110, 90, 120, 80 }, false, "High variance (CV ~15%)" };
	}

	// Godahewa et al. (2023): ETA progression scenarios for vertical stability
	public static IEnumerable<object[]> ETAProgressionScenarios()
	{
		yield return new object[] { new double[] { 10080, 9000, 8000, 7000 }, true, "Monotonically decreasing minutes" };
		yield return new object[] { new double[] { 10080, 10080, 10080, 10080 }, true, "Constant estimates" };
		yield return new object[] { new double[] { 5000, 4500, 5200, 4800 }, true, "Minor fluctuations around trend" };
	}

	// Post-processing rule scenarios (Klee & Xia 2025)
	public static IEnumerable<object[]> PostProcessingScenarios()
	{
		yield return new object[] { 1440.0, true, "Normal: 1 day" };
		yield return new object[] { 10080.0, true, "Normal: 7 days" };
		yield return new object[] { 0.0, true, "Zero minutes - now" };
		yield return new object[] { -100.0, false, "Negative minutes" };
		yield return new object[] { double.NaN, false, "NaN minutes" };
		yield return new object[] { double.PositiveInfinity, false, "Infinity minutes" };
		yield return new object[] { double.NegativeInfinity, false, "Negative infinity" };
	}

	// Helper: Create a Jackpot with specified number of DPD data points
	public static Jackpot CreateJackpotWithDPDPoints(int dataPointCount, double dpdAverage = 100.0)
	{
		Jackpot jackpot = new Jackpot
		{
			_id = MongoDB.Bson.ObjectId.GenerateNewId(),
			Category = "Grand",
			House = "Test House",
			Game = "FireKirin",
			Current = 500.0,
			Threshold = 1000.0,
			Priority = 4,
			EstimatedDate = DateTime.UtcNow.AddDays(7),
			LastUpdated = DateTime.UtcNow,
		};

		jackpot.DPD.Average = dataPointCount >= 2 ? dpdAverage : 0;

		for (int i = 0; i < dataPointCount; i++)
		{
			jackpot.DPD.Data.Add(new DPD_Data(
				500.0 + (i * 10),
				200.0 + (i * 5),
				100.0 + (i * 2),
				50.0 + i
			)
			{
				Timestamp = DateTime.UtcNow.AddHours(-dataPointCount + i),
			});
		}

		return jackpot;
	}

	// Helper: Create a Credential for testing
	public static Credential CreateTestCredential(
		string house = "Test House",
		string game = "FireKirin",
		DateTime? lastUpdated = null)
	{
		return new Credential
		{
			House = house,
			Game = game,
			Username = "testuser",
			Password = "testpass",
			Balance = 100.0,
			LastUpdated = lastUpdated ?? DateTime.UtcNow,
			Enabled = true,
			Unlocked = true,
			Thresholds = new Thresholds
			{
				Grand = 1785.0,
				Major = 565.0,
				Minor = 165.0,
				Mini = 56.5,
			},
			Jackpots = new Jackpots
			{
				Grand = 1558.73,
				Major = 549.75,
				Minor = 150.0,
				Mini = 50.0,
			},
		};
	}
}
