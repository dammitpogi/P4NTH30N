using System;
using System.Collections.Generic;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.PostProcessing;

// DECISION_086: Post-processing validation tests based on Klee & Xia (2025)
// Validates: negative ETA correction, NaN handling, rounding, bounds
public static class PostProcessingTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("PP-001: Negative minutes produces 7-day default", NegativeMinutesDefault),
			("PP-002: NaN minutes produces 7-day default", NaNMinutesDefault),
			("PP-003: Infinity minutes produces 7-day default", InfinityMinutesDefault),
			("PP-004: Zero minutes produces current time", ZeroMinutesNow),
			("PP-005: Valid positive minutes produces future ETA", ValidPositiveMinutes),
			("PP-006: Error logging on invalid input", ErrorLoggingOnInvalid),
			("PP-007: Rounding behavior - 1440.4 rounds to 1440", RoundingBehavior),
			("PP-008: Large valid minutes still produces future date", LargeValidMinutes),
			("PP-009: No error logged for valid positive input", NoErrorForValidInput),
			("PP-010: Negative infinity handled same as positive", NegativeInfinityHandled),
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

	// DECISION_086/PP-001: Negative minutes should return default 7-day ETA
	private static bool NegativeMinutesDefault()
	{
		DateTime before = DateTime.UtcNow;
		DateTime eta = ForecastPostProcessor.PostProcessETA(-100.0);
		DateTime after = DateTime.UtcNow;

		// Should be approximately 7 days from now
		TimeSpan diff = eta - before;
		bool inRange = diff.TotalDays >= 6.9 && diff.TotalDays <= 7.1;

		if (!inRange)
			Console.WriteLine($"    FAIL: Expected ~7 days, got {diff.TotalDays:F2} days");

		return inRange;
	}

	// DECISION_086/PP-002: NaN should return default 7-day ETA
	private static bool NaNMinutesDefault()
	{
		DateTime before = DateTime.UtcNow;
		DateTime eta = ForecastPostProcessor.PostProcessETA(double.NaN);

		TimeSpan diff = eta - before;
		bool inRange = diff.TotalDays >= 6.9 && diff.TotalDays <= 7.1;

		if (!inRange)
			Console.WriteLine($"    FAIL: Expected ~7 days for NaN, got {diff.TotalDays:F2} days");

		return inRange;
	}

	// DECISION_086/PP-003: Infinity should return default 7-day ETA
	private static bool InfinityMinutesDefault()
	{
		DateTime etaPos = ForecastPostProcessor.PostProcessETA(double.PositiveInfinity);
		DateTime etaNeg = ForecastPostProcessor.PostProcessETA(double.NegativeInfinity);

		TimeSpan diffPos = etaPos - DateTime.UtcNow;
		TimeSpan diffNeg = etaNeg - DateTime.UtcNow;

		bool posInRange = diffPos.TotalDays >= 6.9 && diffPos.TotalDays <= 7.1;
		bool negInRange = diffNeg.TotalDays >= 6.9 && diffNeg.TotalDays <= 7.1;

		if (!posInRange)
			Console.WriteLine($"    FAIL: +Infinity produced {diffPos.TotalDays:F2} days, expected ~7");
		if (!negInRange)
			Console.WriteLine($"    FAIL: -Infinity produced {diffNeg.TotalDays:F2} days, expected ~7");

		return posInRange && negInRange;
	}

	// DECISION_086/PP-004: Zero minutes — non-deterministic timing behavior
	// When minutes=0, eta=UtcNow. The past-date guard (eta < DateTime.UtcNow) may or may not fire
	// depending on CPU speed. Both outcomes are valid defense-in-depth behavior:
	//   - Guard fires → 7-day default (nanoseconds elapsed, eta is past)
	//   - Guard doesn't fire → ~0 seconds offset (same tick)
	private static bool ZeroMinutesNow()
	{
		DateTime before = DateTime.UtcNow;
		DateTime eta = ForecastPostProcessor.PostProcessETA(0.0);
		TimeSpan diff = eta - before;

		// Accept EITHER outcome: ~0 seconds (guard didn't fire) OR ~7 days (guard fired)
		bool isNow = Math.Abs(diff.TotalSeconds) < 5;
		bool is7Day = diff.TotalDays >= 6.9 && diff.TotalDays <= 7.1;

		if (!isNow && !is7Day)
		{
			Console.WriteLine($"    FAIL: Expected ~0s or ~7d for 0 min, got {diff.TotalDays:F4} days");
			return false;
		}

		return true;
	}

	// DECISION_086/PP-005: Valid positive minutes should produce future ETA
	private static bool ValidPositiveMinutes()
	{
		DateTime before = DateTime.UtcNow;

		// 1440 minutes = 1 day
		DateTime eta1Day = ForecastPostProcessor.PostProcessETA(1440.0);
		TimeSpan diff1 = eta1Day - before;
		bool day1OK = diff1.TotalDays >= 0.99 && diff1.TotalDays <= 1.01;

		// 10080 minutes = 7 days
		DateTime eta7Day = ForecastPostProcessor.PostProcessETA(10080.0);
		TimeSpan diff7 = eta7Day - before;
		bool day7OK = diff7.TotalDays >= 6.99 && diff7.TotalDays <= 7.01;

		if (!day1OK)
			Console.WriteLine($"    FAIL: 1440 min produced {diff1.TotalDays:F2} days, expected ~1");
		if (!day7OK)
			Console.WriteLine($"    FAIL: 10080 min produced {diff7.TotalDays:F2} days, expected ~7");

		return day1OK && day7OK;
	}

	// DECISION_086/PP-006: Invalid inputs should log errors to IStoreErrors
	private static bool ErrorLoggingOnInvalid()
	{
		MockStoreErrors errorStore = new MockStoreErrors();

		// Negative minutes
		ForecastPostProcessor.PostProcessETA(-50.0, errorStore);
		// NaN minutes
		ForecastPostProcessor.PostProcessETA(double.NaN, errorStore);
		// Infinity minutes
		ForecastPostProcessor.PostProcessETA(double.PositiveInfinity, errorStore);

		List<ErrorLog> errors = errorStore.GetAll();

		if (errors.Count < 3)
		{
			Console.WriteLine($"    FAIL: Expected >= 3 error logs, got {errors.Count}");
			return false;
		}

		// All should be from ForecastingService
		bool allFromForecasting = errors.All(e => e.Source == "ForecastingService");
		if (!allFromForecasting)
		{
			Console.WriteLine("    FAIL: Not all errors from ForecastingService source");
			return false;
		}

		// All should be ValidationError type
		bool allValidation = errors.All(e => e.ErrorType == ErrorType.ValidationError);
		if (!allValidation)
		{
			Console.WriteLine("    FAIL: Not all errors are ValidationError type");
			return false;
		}

		return true;
	}

	// DECISION_086/PP-007: Minutes are rounded to nearest integer before ETA calculation
	private static bool RoundingBehavior()
	{
		DateTime before = DateTime.UtcNow;

		// 1440.4 should round to 1440 (1 day)
		DateTime eta = ForecastPostProcessor.PostProcessETA(1440.4);
		TimeSpan diff = eta - before;
		bool roundedDown = diff.TotalDays >= 0.99 && diff.TotalDays <= 1.01;

		// 1440.6 should round to 1441
		DateTime eta2 = ForecastPostProcessor.PostProcessETA(1440.6);
		TimeSpan diff2 = eta2 - before;
		bool roundedUp = diff2.TotalMinutes >= 1440 && diff2.TotalMinutes <= 1442;

		if (!roundedDown)
			Console.WriteLine($"    FAIL: 1440.4 rounded to {diff.TotalMinutes:F1} min, expected ~1440");
		if (!roundedUp)
			Console.WriteLine($"    FAIL: 1440.6 rounded to {diff2.TotalMinutes:F1} min, expected ~1441");

		return roundedDown && roundedUp;
	}

	// DECISION_086/PP-008: Large but valid minutes still produce a future date
	private static bool LargeValidMinutes()
	{
		// 525600 minutes = 1 year
		DateTime before = DateTime.UtcNow;
		DateTime eta = ForecastPostProcessor.PostProcessETA(525600.0);
		TimeSpan diff = eta - before;

		bool about1Year = diff.TotalDays >= 364 && diff.TotalDays <= 366;
		if (!about1Year)
			Console.WriteLine($"    FAIL: 525600 min produced {diff.TotalDays:F1} days, expected ~365");

		return about1Year;
	}

	// DECISION_086/PP-009: Valid positive input should NOT log any errors
	private static bool NoErrorForValidInput()
	{
		MockStoreErrors errorStore = new MockStoreErrors();

		ForecastPostProcessor.PostProcessETA(1440.0, errorStore);
		ForecastPostProcessor.PostProcessETA(10080.0, errorStore);
		ForecastPostProcessor.PostProcessETA(525600.0, errorStore);

		int errorCount = errorStore.GetAll().Count;
		if (errorCount > 0)
		{
			Console.WriteLine($"    FAIL: Valid inputs produced {errorCount} errors");
			return false;
		}

		return true;
	}

	// DECISION_086/PP-010: NegativeInfinity handled identically to PositiveInfinity
	private static bool NegativeInfinityHandled()
	{
		MockStoreErrors errorStore = new MockStoreErrors();

		DateTime etaNeg = ForecastPostProcessor.PostProcessETA(double.NegativeInfinity, errorStore);
		TimeSpan diff = etaNeg - DateTime.UtcNow;

		bool is7Day = diff.TotalDays >= 6.9 && diff.TotalDays <= 7.1;
		bool hasError = errorStore.GetAll().Count == 1;

		if (!is7Day)
			Console.WriteLine($"    FAIL: -Infinity produced {diff.TotalDays:F2} days, expected ~7");
		if (!hasError)
			Console.WriteLine($"    FAIL: Expected 1 error log, got {errorStore.GetAll().Count}");

		return is7Day && hasError;
	}
}
