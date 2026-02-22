using System;
using System.Collections.Generic;
using P4NTH30N.C0MMON;
using P4NTH30N.H0UND.Domain.Forecasting;
using P4NTH30N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Quality;

// DECISION_086: Data quality validation tests based on Hu et al. (2025) FinTSB benchmark
// Validates DPD bounds checking and data quality gates
public static class DataQualityTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("DQ-001: DPD bounds constants are research-correct", DPDBoundsConstantsCorrect),
			("DQ-002: DPD within bounds validation", DPDWithinBoundsValidation),
			("DQ-003: ForecastPostProcessor.IsDpdWithinBounds boundary test", PostProcessorBoundsTest),
			("DQ-004: GeneratePredictions rejects out-of-bounds DPD", GeneratePredictionsRejectsBadDPD),
			("DQ-005: DPD.IsValid logs error for NaN average", DPDIsValidLogsNaN),
			("DQ-006: DPD.IsValid logs error for negative average", DPDIsValidLogsNegative),
			("DQ-007: StabilityThreshold constant is 0.05 (5%)", StabilityThresholdConstant),
			("DQ-008: DPD.IsWithinBounds false for NaN average", DPDIsWithinBoundsFalseForNaN),
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

	// DECISION_086/DQ-001: Verify DPD bounds constants match research values
	private static bool DPDBoundsConstantsCorrect()
	{
		bool minCorrect = Math.Abs(DPD.MinReasonableDPD - 0.01) < 1e-9;
		bool maxCorrect = Math.Abs(DPD.MaxReasonableDPD - 50000.0) < 1e-9;
		bool minDataCorrect = DPD.MinimumDataPointsForForecast == 4;

		if (!minCorrect)
			Console.WriteLine($"    FAIL: MinReasonableDPD = {DPD.MinReasonableDPD}, expected 0.01");
		if (!maxCorrect)
			Console.WriteLine($"    FAIL: MaxReasonableDPD = {DPD.MaxReasonableDPD}, expected 50000.0");
		if (!minDataCorrect)
			Console.WriteLine($"    FAIL: MinimumDataPointsForForecast = {DPD.MinimumDataPointsForForecast}, expected 4");

		// Also verify PostProcessor mirrors these
		bool ppMinCorrect = Math.Abs(ForecastPostProcessor.MinReasonableDPD - 0.01) < 1e-9;
		bool ppMaxCorrect = Math.Abs(ForecastPostProcessor.MaxReasonableDPD - 50000.0) < 1e-9;

		return minCorrect && maxCorrect && minDataCorrect && ppMinCorrect && ppMaxCorrect;
	}

	// DECISION_086/DQ-002: DPD.IsWithinBounds validates against research bounds
	private static bool DPDWithinBoundsValidation()
	{
		object[][] scenarios =
		[
			[-1.0, false, "Negative DPD"],
			[0.0, false, "Zero DPD"],
			[0.005, false, "Below minimum"],
			[0.01, true, "Exact minimum"],
			[100.0, true, "Normal DPD"],
			[725.69, true, "Observed real DPD"],
			[50000.0, true, "Exact maximum"],
			[50001.0, false, "Above maximum"],
			[100000.0, false, "Extreme high"],
		];

		foreach (object[] scenario in scenarios)
		{
			double dpdValue = (double)scenario[0];
			bool expectedValid = (bool)scenario[1];
			string desc = (string)scenario[2];

			DPD dpd = new DPD { Average = dpdValue };
			bool actualValid = dpd.IsWithinBounds;

			if (actualValid != expectedValid)
			{
				Console.WriteLine($"    FAIL: {desc} (DPD={dpdValue}) — expected {expectedValid}, got {actualValid}");
				return false;
			}
		}

		return true;
	}

	// DECISION_086/DQ-003: ForecastPostProcessor.IsDpdWithinBounds handles edge cases
	private static bool PostProcessorBoundsTest()
	{
		// Normal values
		if (!ForecastPostProcessor.IsDpdWithinBounds(100.0))
		{
			Console.WriteLine("    FAIL: 100.0 should be within bounds");
			return false;
		}

		// Edge cases
		if (ForecastPostProcessor.IsDpdWithinBounds(double.NaN))
		{
			Console.WriteLine("    FAIL: NaN should not be within bounds");
			return false;
		}

		if (ForecastPostProcessor.IsDpdWithinBounds(double.PositiveInfinity))
		{
			Console.WriteLine("    FAIL: Infinity should not be within bounds");
			return false;
		}

		if (ForecastPostProcessor.IsDpdWithinBounds(0.0))
		{
			Console.WriteLine("    FAIL: 0.0 should not be within bounds");
			return false;
		}

		if (ForecastPostProcessor.IsDpdWithinBounds(-5.0))
		{
			Console.WriteLine("    FAIL: -5.0 should not be within bounds");
			return false;
		}

		// Boundary exact values
		if (!ForecastPostProcessor.IsDpdWithinBounds(0.01))
		{
			Console.WriteLine("    FAIL: 0.01 (exact min) should be within bounds");
			return false;
		}

		if (!ForecastPostProcessor.IsDpdWithinBounds(50000.0))
		{
			Console.WriteLine("    FAIL: 50000.0 (exact max) should be within bounds");
			return false;
		}

		return true;
	}

	// DECISION_086/DQ-004: GeneratePredictions should use default when DPD is out of bounds
	private static bool GeneratePredictionsRejectsBadDPD()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Create jackpot with sufficient points but extreme DPD average
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 100000.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		existing.DPD.Average = 100000.0; // Out of bounds
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (result == null)
		{
			Console.WriteLine("    FAIL: No jackpot created");
			return false;
		}

		// ETA should be in the future (7-day default applied)
		bool inFuture = result.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);

		// Should have logged an error about out-of-bounds DPD
		List<ErrorLog> errors = ((MockStoreErrors)uow.Errors).GetAll();
		bool hasError = errors.Any(e => e.Message.Contains("out of bounds"));

		if (!inFuture)
			Console.WriteLine($"    FAIL: ETA {result.EstimatedDate:O} is in the past");
		if (!hasError)
			Console.WriteLine($"    FAIL: No error logged for out-of-bounds DPD (errors: {errors.Count})");

		return inFuture && hasError;
	}

	// DECISION_086/DQ-005: DPD.IsValid returns false and logs error for NaN average
	private static bool DPDIsValidLogsNaN()
	{
		MockStoreErrors errorStore = new MockStoreErrors();
		DPD dpd = new DPD { Average = double.NaN };

		bool isValid = dpd.IsValid(errorStore);

		if (isValid)
		{
			Console.WriteLine("    FAIL: NaN DPD average should be invalid");
			return false;
		}

		bool hasError = errorStore.GetAll().Any(e => e.Message.Contains("Invalid DPD average"));
		if (!hasError)
		{
			Console.WriteLine("    FAIL: No error logged for NaN DPD");
			return false;
		}

		return true;
	}

	// DECISION_086/DQ-006: DPD.IsValid returns false and logs error for negative average
	private static bool DPDIsValidLogsNegative()
	{
		MockStoreErrors errorStore = new MockStoreErrors();
		DPD dpd = new DPD { Average = -5.0 };

		bool isValid = dpd.IsValid(errorStore);

		if (isValid)
		{
			Console.WriteLine("    FAIL: Negative DPD average should be invalid");
			return false;
		}

		bool hasError = errorStore.GetAll().Any(e => e.Message.Contains("Negative DPD average"));
		if (!hasError)
		{
			Console.WriteLine("    FAIL: No error logged for negative DPD");
			return false;
		}

		return true;
	}

	// DECISION_086/DQ-007: ForecastStabilityMetrics.StabilityThreshold is exactly 0.05
	private static bool StabilityThresholdConstant()
	{
		bool correct = Math.Abs(ForecastStabilityMetrics.StabilityThreshold - 0.05) < 1e-9;

		if (!correct)
			Console.WriteLine($"    FAIL: StabilityThreshold = {ForecastStabilityMetrics.StabilityThreshold}, expected 0.05");

		// Also verify StabilityMetrics test infrastructure uses same threshold
		bool infraCorrect = Math.Abs(StabilityMetrics.StableThreshold - 0.05) < 1e-9;
		if (!infraCorrect)
			Console.WriteLine($"    FAIL: StabilityMetrics.StableThreshold = {StabilityMetrics.StableThreshold}, expected 0.05");

		return correct && infraCorrect;
	}

	// DECISION_086/DQ-008: DPD.IsWithinBounds false for NaN average
	private static bool DPDIsWithinBoundsFalseForNaN()
	{
		DPD nanDpd = new DPD { Average = double.NaN };
		DPD infDpd = new DPD { Average = double.PositiveInfinity };
		DPD negInfDpd = new DPD { Average = double.NegativeInfinity };

		bool nanFalse = !nanDpd.IsWithinBounds;
		bool infFalse = !infDpd.IsWithinBounds;
		bool negInfFalse = !negInfDpd.IsWithinBounds;

		if (!nanFalse) Console.WriteLine("    FAIL: NaN should not be within bounds");
		if (!infFalse) Console.WriteLine("    FAIL: +Infinity should not be within bounds");
		if (!negInfFalse) Console.WriteLine("    FAIL: -Infinity should not be within bounds");

		return nanFalse && infFalse && negInfFalse;
	}
}
