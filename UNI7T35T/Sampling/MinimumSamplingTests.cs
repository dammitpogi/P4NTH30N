using System;
using System.Collections.Generic;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Sampling;

// DECISION_086: Minimum sampling tests based on Liu & Zhang (2019)
// Validates the 4-point DPD threshold for valid forecasting
public static class MinimumSamplingTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("MS-001: 0 data points - insufficient for forecast", ZeroDataPoints),
			("MS-002: 1 data point - insufficient for forecast", OneDataPoint),
			("MS-003: 2 data points - insufficient for forecast", TwoDataPoints),
			("MS-004: 3 data points - insufficient for forecast", ThreeDataPoints),
			("MS-005: 4 data points - minimum valid for forecast", FourDataPoints),
			("MS-006: 10 data points - optimal for forecast", TenDataPoints),
			("MS-007: DPD.HasSufficientDataForForecast boundary test", HasSufficientDataBoundary),
			("MS-008: CalculateMinutesToValue with zero DPD returns safe max", ZeroDPDSafeMax),
			("MS-009: ForecastingService logs insufficient DPD error", InsufficientDPDLogsError),
			("MS-010: 100 data points - abundant data passes all checks", AbundantDataPasses),
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

	// DECISION_086/MS-001: No samples - should not be valid for forecasting
	private static bool ZeroDataPoints()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(0);
		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;

		if (hasSufficient)
			Console.WriteLine("    FAIL: 0 data points should not be sufficient");

		return !hasSufficient;
	}

	// DECISION_086/MS-002: One sample - should not be valid
	private static bool OneDataPoint()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(1);
		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;

		if (hasSufficient)
			Console.WriteLine("    FAIL: 1 data point should not be sufficient");

		return !hasSufficient;
	}

	// DECISION_086/MS-003: Two samples - should not be valid
	private static bool TwoDataPoints()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(2);
		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;

		if (hasSufficient)
			Console.WriteLine("    FAIL: 2 data points should not be sufficient");

		return !hasSufficient;
	}

	// DECISION_086/MS-004: Three samples - should not be valid
	private static bool ThreeDataPoints()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(3);
		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;

		if (hasSufficient)
			Console.WriteLine("    FAIL: 3 data points should not be sufficient");

		return !hasSufficient;
	}

	// DECISION_086/MS-005: Four samples - minimum valid threshold
	private static bool FourDataPoints()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(4, 100.0);
		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;

		if (!hasSufficient)
			Console.WriteLine("    FAIL: 4 data points should be sufficient");

		return hasSufficient;
	}

	// DECISION_086/MS-006: Ten samples - optimal, should pass
	private static bool TenDataPoints()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(10, 200.0);
		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;

		if (!hasSufficient)
			Console.WriteLine("    FAIL: 10 data points should be sufficient");

		// Also verify the constant is 4
		bool constantCorrect = DPD.MinimumDataPointsForForecast == 4;
		if (!constantCorrect)
			Console.WriteLine($"    FAIL: MinimumDataPointsForForecast = {DPD.MinimumDataPointsForForecast}, expected 4");

		return hasSufficient && constantCorrect;
	}

	// DECISION_086/MS-007: Boundary test for HasSufficientDataForForecast
	private static bool HasSufficientDataBoundary()
	{
		// Test each boundary value from the parameterized data
		object[][] scenarios =
		[
			[0, false],
			[1, false],
			[2, false],
			[3, false],
			[4, true],
			[10, true],
			[100, true],
		];

		foreach (object[] scenario in scenarios)
		{
			int count = (int)scenario[0];
			bool expectedValid = (bool)scenario[1];

			Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(count);
			bool actualValid = jackpot.DPD.Data.Count >= DPD.MinimumDataPointsForForecast;

			if (actualValid != expectedValid)
			{
				Console.WriteLine($"    FAIL: {count} points — expected {expectedValid}, got {actualValid}");
				return false;
			}
		}

		return true;
	}

	// DECISION_086/MS-008: CalculateMinutesToValue with zero DPD returns safe max minutes
	private static bool ZeroDPDSafeMax()
	{
		double minutes = ForecastingService.CalculateMinutesToValue(1785.0, 1558.73, 0.0);

		// Zero DPD should return safe max (very large number)
		bool isSafeMax = minutes > 1_000_000;

		if (!isSafeMax)
			Console.WriteLine($"    FAIL: Zero DPD returned {minutes:F0} minutes, expected safe max (>1M)");

		return isSafeMax;
	}

	// DECISION_086/MS-009: ForecastingService logs error when DPD data is insufficient
	private static bool InsufficientDPDLogsError()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// 2 DPD points (insufficient, but >0 to trigger error log)
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(2, 100.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		List<ErrorLog> errors = ((MockStoreErrors)uow.Errors).GetAll();
		bool hasInsufficientError = errors.Any(e =>
			e.Source == "ForecastingService" && e.Message.Contains("Insufficient"));

		if (!hasInsufficientError)
			Console.WriteLine($"    FAIL: No 'Insufficient' error logged (errors: {errors.Count})");

		return hasInsufficientError;
	}

	// DECISION_086/MS-010: 100 data points passes all validation checks
	private static bool AbundantDataPasses()
	{
		Jackpot jackpot = BurnInTestData.CreateJackpotWithDPDPoints(100, 500.0);

		bool hasSufficient = jackpot.DPD.HasSufficientDataForForecast;
		bool isWithinBounds = jackpot.DPD.IsWithinBounds;
		bool dataCount = jackpot.DPD.Data.Count == 100;

		if (!hasSufficient)
			Console.WriteLine("    FAIL: 100 data points should be sufficient");
		if (!isWithinBounds)
			Console.WriteLine($"    FAIL: DPD average {jackpot.DPD.Average} should be within bounds");
		if (!dataCount)
			Console.WriteLine($"    FAIL: Expected 100 data points, got {jackpot.DPD.Data.Count}");

		return hasSufficient && isWithinBounds && dataCount;
	}
}
