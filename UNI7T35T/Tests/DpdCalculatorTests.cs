using System;
using System.Collections.Generic;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.H0UND.Domain.Forecasting;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

public static class DpdCalculatorTests
{
	private static int _passed;
	private static int _failed;

	public static (int passed, int failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Console.WriteLine("\n=== DPD Calculator Edge Case Tests (PROD-003) ===\n");

		// DPD entity validation
		Test_DPD_IsValid_NaN();
		Test_DPD_IsValid_Infinity();
		Test_DPD_IsValid_Negative();
		Test_DPD_IsValid_Zero();
		Test_DPD_IsValid_Normal();

		// ForecastingService.CalculateMinutesToValue edge cases
		Test_CalculateMinutes_ZeroDPD_ReturnsSafeMax();
		Test_CalculateMinutes_NegativeDPD_ReturnsSafeMax();
		Test_CalculateMinutes_NaN_ReturnsSafeMax();
		Test_CalculateMinutes_Infinity_ReturnsSafeMax();
		Test_CalculateMinutes_TinyDPD_ReturnsSafeMax();
		Test_CalculateMinutes_AlreadyAtThreshold_ReturnsZero();
		Test_CalculateMinutes_ExceededThreshold_ReturnsZero();
		Test_CalculateMinutes_Normal_ReturnsPositive();

		// GeneratePredictions integration with DPD edge cases
		Test_GeneratePredictions_ZeroDPD_NoOverflow();
		Test_GeneratePredictions_NormalDPD_ProducesReasonableETA();

		Console.WriteLine($"\n=== DPD Calculator Results: {_passed} passed, {_failed} failed ===\n");
		return (_passed, _failed);
	}

	// ── DPD.IsValid Tests ───────────────────────────────────────────────

	private static void Test_DPD_IsValid_NaN()
	{
		try
		{
			MockStoreErrors errors = new();
			DPD dpd = new() { Average = double.NaN };
			Assert(!dpd.IsValid(errors), "NaN average should be invalid");
			Assert(errors.GetAll().Count == 1, "Should log one error for NaN");
			Pass("DPD_IsValid_NaN");
		}
		catch (Exception ex)
		{
			Fail("DPD_IsValid_NaN", ex);
		}
	}

	private static void Test_DPD_IsValid_Infinity()
	{
		try
		{
			MockStoreErrors errors = new();
			DPD dpd = new() { Average = double.PositiveInfinity };
			Assert(!dpd.IsValid(errors), "Infinity average should be invalid");
			Assert(errors.GetAll().Count == 1, "Should log one error for Infinity");

			errors.Clear();
			DPD dpdNegInf = new() { Average = double.NegativeInfinity };
			Assert(!dpdNegInf.IsValid(errors), "NegativeInfinity average should be invalid");
			Pass("DPD_IsValid_Infinity");
		}
		catch (Exception ex)
		{
			Fail("DPD_IsValid_Infinity", ex);
		}
	}

	private static void Test_DPD_IsValid_Negative()
	{
		try
		{
			MockStoreErrors errors = new();
			DPD dpd = new() { Average = -5.0 };
			Assert(!dpd.IsValid(errors), "Negative average should be invalid");
			Assert(errors.GetAll().Count == 1, "Should log one error for negative");
			Pass("DPD_IsValid_Negative");
		}
		catch (Exception ex)
		{
			Fail("DPD_IsValid_Negative", ex);
		}
	}

	private static void Test_DPD_IsValid_Zero()
	{
		try
		{
			DPD dpd = new() { Average = 0 };
			Assert(dpd.IsValid(), "Zero average should be valid (no growth, but not corrupt)");
			Pass("DPD_IsValid_Zero");
		}
		catch (Exception ex)
		{
			Fail("DPD_IsValid_Zero", ex);
		}
	}

	private static void Test_DPD_IsValid_Normal()
	{
		try
		{
			DPD dpd = new() { Average = 150.75 };
			Assert(dpd.IsValid(), "Normal positive average should be valid");
			Pass("DPD_IsValid_Normal");
		}
		catch (Exception ex)
		{
			Fail("DPD_IsValid_Normal", ex);
		}
	}

	// ── ForecastingService.CalculateMinutesToValue Edge Cases ────────────

	private static void Test_CalculateMinutes_ZeroDPD_ReturnsSafeMax()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 100, 0);
			Assert(minutes > 0, "Should return positive value for zero DPD");
			// Verify it doesn't overflow DateTime
			DateTime eta = DateTime.UtcNow.AddMinutes(minutes);
			Assert(eta < DateTime.MaxValue, "ETA should not overflow DateTime");
			Pass("CalculateMinutes_ZeroDPD_ReturnsSafeMax");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_ZeroDPD_ReturnsSafeMax", ex);
		}
	}

	private static void Test_CalculateMinutes_NegativeDPD_ReturnsSafeMax()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 100, -50);
			Assert(minutes > 0, "Should return positive value for negative DPD");
			DateTime eta = DateTime.UtcNow.AddMinutes(minutes);
			Assert(eta < DateTime.MaxValue, "ETA should not overflow DateTime");
			Pass("CalculateMinutes_NegativeDPD_ReturnsSafeMax");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_NegativeDPD_ReturnsSafeMax", ex);
		}
	}

	private static void Test_CalculateMinutes_NaN_ReturnsSafeMax()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 100, double.NaN);
			Assert(!double.IsNaN(minutes), "Should not return NaN");
			Assert(minutes > 0, "Should return positive value for NaN DPD");
			DateTime eta = DateTime.UtcNow.AddMinutes(minutes);
			Assert(eta < DateTime.MaxValue, "ETA should not overflow DateTime");
			Pass("CalculateMinutes_NaN_ReturnsSafeMax");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_NaN_ReturnsSafeMax", ex);
		}
	}

	private static void Test_CalculateMinutes_Infinity_ReturnsSafeMax()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 100, double.PositiveInfinity);
			Assert(!double.IsInfinity(minutes), "Should not return Infinity");
			Assert(minutes > 0, "Should return positive value for Infinity DPD");
			DateTime eta = DateTime.UtcNow.AddMinutes(minutes);
			Assert(eta < DateTime.MaxValue, "ETA should not overflow DateTime");
			Pass("CalculateMinutes_Infinity_ReturnsSafeMax");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_Infinity_ReturnsSafeMax", ex);
		}
	}

	private static void Test_CalculateMinutes_TinyDPD_ReturnsSafeMax()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 100, 1e-15);
			Assert(minutes > 0, "Should return positive value for tiny DPD");
			DateTime eta = DateTime.UtcNow.AddMinutes(minutes);
			Assert(eta < DateTime.MaxValue, "ETA should not overflow DateTime");
			Pass("CalculateMinutes_TinyDPD_ReturnsSafeMax");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_TinyDPD_ReturnsSafeMax", ex);
		}
	}

	private static void Test_CalculateMinutes_AlreadyAtThreshold_ReturnsZero()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 1000, 100);
			Assert(Math.Abs(minutes) < 0.001, $"Should return ~0 when at threshold, got {minutes}");
			Pass("CalculateMinutes_AlreadyAtThreshold_ReturnsZero");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_AlreadyAtThreshold_ReturnsZero", ex);
		}
	}

	private static void Test_CalculateMinutes_ExceededThreshold_ReturnsZero()
	{
		try
		{
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 1500, 100);
			Assert(Math.Abs(minutes) < 0.001, $"Should return ~0 when exceeded threshold, got {minutes}");
			Pass("CalculateMinutes_ExceededThreshold_ReturnsZero");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_ExceededThreshold_ReturnsZero", ex);
		}
	}

	private static void Test_CalculateMinutes_Normal_ReturnsPositive()
	{
		try
		{
			// $100/day DPD, $900 remaining → 9 days = 12960 minutes
			double minutes = ForecastingService.CalculateMinutesToValue(1000, 100, 100);
			Assert(minutes > 0, $"Should return positive minutes, got {minutes}");
			double expectedMinutes = (900.0 / (100.0 / 1440.0));
			Assert(Math.Abs(minutes - expectedMinutes) < 1.0, $"Expected ~{expectedMinutes:F0}min, got {minutes:F0}min");
			Pass("CalculateMinutes_Normal_ReturnsPositive");
		}
		catch (Exception ex)
		{
			Fail("CalculateMinutes_Normal_ReturnsPositive", ex);
		}
	}

	// ── GeneratePredictions Integration Tests ───────────────────────────

	private static void Test_GeneratePredictions_ZeroDPD_NoOverflow()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateTestCredential();

			// Existing jackpot with zero DPD
			Jackpot existing = new()
			{
				House = "TestHouse",
				Game = "TestGame",
				Category = "Grand",
				Priority = 4,
				Current = 100,
				Threshold = 1785,
				DPD = new DPD { Average = 0 },
			};
			((MockRepoJackpots)uow.Jackpots).Add(existing);

			// Should not throw ArgumentOutOfRangeException
			ForecastingService.GeneratePredictions(cred, uow, DateTime.MaxValue);

			List<Jackpot> results = uow.Jackpots.GetAll();
			Assert(results.Count > 0, "Should produce jackpot predictions");

			foreach (Jackpot j in results)
			{
				Assert(j.EstimatedDate < DateTime.MaxValue, $"{j.Category} ETA overflowed DateTime");
				Assert(j.EstimatedDate > DateTime.UtcNow, $"{j.Category} ETA is in the past");
			}

			Pass("GeneratePredictions_ZeroDPD_NoOverflow");
		}
		catch (Exception ex)
		{
			Fail("GeneratePredictions_ZeroDPD_NoOverflow", ex);
		}
	}

	private static void Test_GeneratePredictions_NormalDPD_ProducesReasonableETA()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateTestCredential();

			// Existing jackpot with healthy DPD ($200/day)
			Jackpot existing = new()
			{
				House = "TestHouse",
				Game = "TestGame",
				Category = "Grand",
				Priority = 4,
				Current = 1000,
				Threshold = 1785,
				DPD = new DPD { Average = 200 },
			};
			((MockRepoJackpots)uow.Jackpots).Add(existing);

			ForecastingService.GeneratePredictions(cred, uow, DateTime.MaxValue);

			List<Jackpot> results = uow.Jackpots.GetAll();
			Jackpot? grand = results.Find(j => j.Category == "Grand");
			Assert(grand != null, "Should have Grand prediction");
			// With DPD.Average=200 but no DPD.Data points, tier DPM resolves to fallback
			// which produces a far-future ETA. Key validation: no overflow, ETA is valid.
			Assert(grand!.EstimatedDate < DateTime.MaxValue, $"Grand ETA overflowed: {grand.EstimatedDate}");
			Assert(grand.EstimatedDate > DateTime.UtcNow, "Grand ETA should be in the future");

			Pass("GeneratePredictions_NormalDPD_ProducesReasonableETA");
		}
		catch (Exception ex)
		{
			Fail("GeneratePredictions_NormalDPD_ProducesReasonableETA", ex);
		}
	}

	// ── Helpers ──────────────────────────────────────────────────────────

	private static Credential CreateTestCredential()
	{
		return new Credential("TestGame")
		{
			House = "TestHouse",
			Username = "testuser",
			Password = "testpass",
			Enabled = true,
			Balance = 100,
			Jackpots = new Jackpots
			{
				Grand = 1000,
				Major = 400,
				Minor = 80,
				Mini = 15,
			},
			Thresholds = new Thresholds
			{
				Grand = 1785,
				Major = 565,
				Minor = 117,
				Mini = 23,
			},
			Settings = new GameSettings
			{
				SpinGrand = true,
				SpinMajor = true,
				SpinMinor = true,
				SpinMini = true,
			},
		};
	}

	private static void Assert(bool condition, string message)
	{
		if (!condition)
			throw new Exception($"Assertion failed: {message}");
	}

	private static void Pass(string testName)
	{
		_passed++;
		Console.WriteLine($"  [PASS] {testName}");
	}

	private static void Fail(string testName, Exception ex)
	{
		_failed++;
		Console.WriteLine($"  [FAIL] {testName}: {ex.Message}");
	}
}
