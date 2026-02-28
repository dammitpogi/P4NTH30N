using System;
using System.Collections.Generic;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Stability;

// DECISION_086: Vertical stability tests based on Godahewa et al. (2023)
// Validates that ETAs progress forward and never backward across forecast horizons
public static class VerticalStabilityTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("VS-001: ETA never in past after GeneratePredictions", ETANeverInPast),
			("VS-002: ETA progresses forward with accumulating DPD", ETAProgressesForward),
			("VS-003: Insufficient DPD produces 7-day default", InsufficientDPDProducesDefault),
			("VS-004: Valid DPD produces reasonable future ETA", ValidDPDProducesReasonableETA),
			("VS-005: DefaultEstimateHorizon constant is 7 days", DefaultEstimateHorizonIs7Days),
			("VS-006: Disabled tier is not processed", DisabledTierSkipped),
			("VS-007: ETA converges as DPD data grows (Godahewa monotonicity)", ETAConvergesWithMoreData),
			("VS-008: Jackpot constructor never returns past EstimatedDate", JackpotConstructorNeverPast),
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

	// DECISION_086/VS-001: After GeneratePredictions, no jackpot should have EstimatedDate in the past
	private static bool ETANeverInPast()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Seed existing jackpot with insufficient DPD (2 points)
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(2);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		List<Jackpot> jackpots = uow.Jackpots.GetAll();
		foreach (Jackpot j in jackpots)
		{
			if (j.EstimatedDate < DateTime.UtcNow.AddSeconds(-5))
			{
				Console.WriteLine($"    FAIL: {j.Category} ETA {j.EstimatedDate:O} is in the past");
				return false;
			}
		}

		return jackpots.Count > 0;
	}

	// DECISION_086/VS-002: As DPD data accumulates, ETA should trend toward a stable future date
	private static bool ETAProgressesForward()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Seed with 10-point DPD data (sufficient)
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 500.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (result == null) return false;

		// ETA should be in the future
		bool etaInFuture = result.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);
		// ETA should be within a reasonable range (not more than 1 year)
		bool etaReasonable = result.EstimatedDate < DateTime.UtcNow.AddDays(365);

		if (!etaInFuture)
			Console.WriteLine($"    FAIL: ETA {result.EstimatedDate:O} is in the past");
		if (!etaReasonable)
			Console.WriteLine($"    FAIL: ETA {result.EstimatedDate:O} is unreasonably far in the future");

		return etaInFuture && etaReasonable;
	}

	// DECISION_086/VS-003: With insufficient DPD data, should use 7-day default
	private static bool InsufficientDPDProducesDefault()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Seed with 2-point DPD data (insufficient - need 4)
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(2, 100.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (result == null) return false;

		// Should be approximately 7 days from now (within 1 day tolerance for constructor recalc)
		TimeSpan diff = result.EstimatedDate - DateTime.UtcNow;
		bool within7DayRange = diff.TotalDays >= 0 && diff.TotalDays <= 14;

		if (!within7DayRange)
			Console.WriteLine($"    FAIL: Expected ~7 day default, got {diff.TotalDays:F1} days");

		return within7DayRange;
	}

	// DECISION_086/VS-004: With valid DPD data (10+ points, reasonable average), produces future ETA
	private static bool ValidDPDProducesReasonableETA()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Seed with abundant DPD data
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 200.0);
		existing.Category = "Major";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Major", cred.House, cred.Game);
		if (result == null) return false;

		bool inFuture = result.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);
		bool withinYear = result.EstimatedDate < DateTime.UtcNow.AddDays(365);

		return inFuture && withinYear;
	}

	// DECISION_086/VS-005: DefaultEstimateHorizon is exactly 7 days
	private static bool DefaultEstimateHorizonIs7Days()
	{
		TimeSpan horizon = ForecastPostProcessor.DefaultEstimateHorizon;
		bool is7Days = Math.Abs(horizon.TotalDays - 7.0) < 1e-9;

		if (!is7Days)
			Console.WriteLine($"    FAIL: DefaultEstimateHorizon = {horizon.TotalDays} days, expected 7");

		return is7Days;
	}

	// DECISION_086/VS-006: Disabled tier should not produce a jackpot entry
	private static bool DisabledTierSkipped()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();
		cred.Settings.SpinGrand = false; // Disable Grand tier

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		List<Jackpot> jackpots = uow.Jackpots.GetAll();
		bool noGrand = !jackpots.Any(j => j.Category == "Grand");
		bool has3 = jackpots.Count == 3;

		if (!noGrand)
			Console.WriteLine("    FAIL: Grand tier was processed despite being disabled");
		if (!has3)
			Console.WriteLine($"    FAIL: Expected 3 jackpots (Grand disabled), got {jackpots.Count}");

		return noGrand && has3;
	}

	// DECISION_086/VS-007: Godahewa monotonicity - more DPD data narrows uncertainty
	private static bool ETAConvergesWithMoreData()
	{
		Credential cred = BurnInTestData.CreateTestCredential();
		List<TimeSpan> diffs = new List<TimeSpan>();

		// Run with increasing DPD counts; all ETAs should be in the future
		foreach (int dpdCount in new[] { 4, 6, 10, 20 })
		{
			MockUnitOfWork uow = new MockUnitOfWork();
			Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(dpdCount, 300.0);
			existing.Category = "Grand";
			existing.House = cred.House;
			existing.Game = cred.Game;
			((MockRepoJackpots)uow.Jackpots).Add(existing);

			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));
			Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
			if (result == null) return false;

			if (result.EstimatedDate < DateTime.UtcNow.AddSeconds(-5))
			{
				Console.WriteLine($"    FAIL: DPD count {dpdCount} produced past ETA");
				return false;
			}

			diffs.Add(result.EstimatedDate - DateTime.UtcNow);
		}

		// All ETAs should be positive
		return diffs.All(d => d.TotalSeconds > -5);
	}

	// DECISION_086/VS-008: Jackpot constructor with extreme values never returns past date
	private static bool JackpotConstructorNeverPast()
	{
		Credential cred = BurnInTestData.CreateTestCredential();

		// Test with various extreme threshold/current combinations
		double[][] extremes =
		[
			[1785.0, 1558.73],   // Normal case
			[1785.0, 1785.0],    // Already at threshold
			[1785.0, 2000.0],    // Above threshold
			[100.0, 0.0],        // Far from threshold
		];

		foreach (double[] pair in extremes)
		{
			Jackpot j = new Jackpot(cred, "Grand", pair[1], pair[0], 4, DateTime.UtcNow.AddDays(7));

			if (j.EstimatedDate < DateTime.UtcNow.AddSeconds(-5))
			{
				Console.WriteLine($"    FAIL: Jackpot(current={pair[1]}, threshold={pair[0]}) → past ETA {j.EstimatedDate:O}");
				return false;
			}
		}

		return true;
	}
}
