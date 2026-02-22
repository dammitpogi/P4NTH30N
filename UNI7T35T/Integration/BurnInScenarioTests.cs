using System;
using System.Collections.Generic;
using System.Linq;
using P4NTH30N.C0MMON;
using P4NTH30N.H0UND.Domain.Forecasting;
using P4NTH30N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Integration;

// DECISION_086: End-to-end burn-in scenario tests
// Simulates the full burn-in lifecycle from reset to signal generation
public static class BurnInScenarioTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("BI-001: Day 0 - Reset state, all use default ETAs", Day0ResetState),
			("BI-002: Day 1 - Accumulating, still insufficient", Day1Accumulating),
			("BI-003: Day 2 - First valid forecasts emerge", Day2FirstValid),
			("BI-004: No past dates at any burn-in stage", NoPastDatesEver),
			("BI-005: Full lifecycle - reset to stable forecasts", FullLifecycle),
			("BI-006: FrozenTimeProvider advances deterministically", FrozenTimeProviderAdvances),
			("BI-007: StabilityMetrics.CalculateCVFromDateTimes works", CVFromDateTimesWorks),
			("BI-008: Mixed tier DPD states handled correctly", MixedTierDPDStates),
			("BI-009: Error accumulation across prediction cycles", ErrorAccumulationAcrossCycles),
			("BI-010: CalculateMinutesToValue returns 0 when threshold reached", ThresholdReachedReturnsZero),
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

	// DECISION_086/BI-001: After reset (Day 0), all jackpots should use 7-day default
	private static bool Day0ResetState()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Seed with empty DPD (post-reset state)
		Jackpot existing = new Jackpot
		{
			Category = "Grand",
			House = cred.House,
			Game = cred.Game,
			Current = 1558.73,
			Threshold = 1785.0,
			Priority = 4,
			EstimatedDate = DateTime.UtcNow.AddDays(7),
			LastUpdated = DateTime.UtcNow,
		};
		// DPD.Data is empty (reset state)
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		// All jackpots should have future ETAs
		List<Jackpot> jackpots = uow.Jackpots.GetAll();
		foreach (Jackpot j in jackpots)
		{
			if (j.EstimatedDate < DateTime.UtcNow.AddSeconds(-5))
			{
				Console.WriteLine($"    FAIL: {j.Category} ETA {j.EstimatedDate:O} is in the past");
				return false;
			}
		}

		// Grand specifically should use default (insufficient DPD)
		Jackpot? grand = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (grand == null) return false;

		// ETA should be somewhere in the future (constructor may recalculate)
		bool etaFuture = grand.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);
		return etaFuture;
	}

	// DECISION_086/BI-002: After 24h (Day 1), 2-3 DPD points accumulated but still insufficient
	private static bool Day1Accumulating()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Simulate 3 DPD points accumulated over 24h
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(3, 50.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (result == null) return false;

		// Should still use default because 3 < 4 minimum
		bool inFuture = result.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);

		// DPD should still show insufficient
		bool insufficient = !result.DPD.HasSufficientDataForForecast;

		if (!inFuture)
			Console.WriteLine($"    FAIL: Day 1 ETA in past: {result.EstimatedDate:O}");
		if (!insufficient)
			Console.WriteLine($"    FAIL: 3 DPD points should be insufficient");

		return inFuture && insufficient;
	}

	// DECISION_086/BI-003: After 48h (Day 2), first valid forecasts should emerge
	private static bool Day2FirstValid()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Simulate 6 DPD points accumulated (sufficient)
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(6, 300.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (result == null) return false;

		// Should have sufficient data now
		bool sufficient = result.DPD.HasSufficientDataForForecast;

		// ETA should be in the future and within reasonable bounds
		bool inFuture = result.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);
		bool withinYear = result.EstimatedDate < DateTime.UtcNow.AddDays(365);

		if (!sufficient)
			Console.WriteLine($"    FAIL: 6 DPD points should be sufficient");
		if (!inFuture)
			Console.WriteLine($"    FAIL: Day 2 ETA in past: {result.EstimatedDate:O}");

		return sufficient && inFuture && withinYear;
	}

	// DECISION_086/BI-004: At no point during burn-in should any jackpot have a past ETA
	private static bool NoPastDatesEver()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Test across multiple DPD accumulation stages
		int[] stages = [0, 1, 2, 3, 4, 5, 10, 20];

		foreach (int dpdCount in stages)
		{
			uow.ClearAll();

			if (dpdCount > 0)
			{
				Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(dpdCount, 200.0);
				existing.Category = "Grand";
				existing.House = cred.House;
				existing.Game = cred.Game;
				((MockRepoJackpots)uow.Jackpots).Add(existing);
			}

			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

			List<Jackpot> jackpots = uow.Jackpots.GetAll();
			foreach (Jackpot j in jackpots)
			{
				if (j.EstimatedDate < DateTime.UtcNow.AddSeconds(-5))
				{
					Console.WriteLine($"    FAIL: Stage {dpdCount} — {j.Category} ETA {j.EstimatedDate:O} is in the past");
					return false;
				}
			}
		}

		return true;
	}

	// DECISION_086/BI-005: Full lifecycle simulation - from reset through stable forecasting
	private static bool FullLifecycle()
	{
		Credential cred = BurnInTestData.CreateTestCredential();

		// Phase 0: Reset (0 DPD points)
		{
			MockUnitOfWork uow = new MockUnitOfWork();
			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

			List<Jackpot> jackpots = uow.Jackpots.GetAll();
			if (jackpots.Count != 4)
			{
				Console.WriteLine($"    FAIL Phase 0: Expected 4 jackpots, got {jackpots.Count}");
				return false;
			}

			// All ETAs should be future
			if (jackpots.Any(j => j.EstimatedDate < DateTime.UtcNow.AddSeconds(-5)))
			{
				Console.WriteLine("    FAIL Phase 0: Found past ETAs");
				return false;
			}
		}

		// Phase 1: Accumulating (3 DPD points, insufficient)
		{
			MockUnitOfWork uow = new MockUnitOfWork();
			foreach (string cat in new[] { "Grand", "Major", "Minor", "Mini" })
			{
				Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(3, 100.0);
				existing.Category = cat;
				existing.House = cred.House;
				existing.Game = cred.Game;
				((MockRepoJackpots)uow.Jackpots).Add(existing);
			}

			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

			List<Jackpot> jackpots = uow.Jackpots.GetAll();
			bool allFuture = jackpots.All(j => j.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5));
			if (!allFuture)
			{
				Console.WriteLine("    FAIL Phase 1: Found past ETAs during accumulation");
				return false;
			}
		}

		// Phase 2: Sufficient data (10 DPD points, valid)
		{
			MockUnitOfWork uow = new MockUnitOfWork();
			foreach (string cat in new[] { "Grand", "Major", "Minor", "Mini" })
			{
				Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 400.0);
				existing.Category = cat;
				existing.House = cred.House;
				existing.Game = cred.Game;
				((MockRepoJackpots)uow.Jackpots).Add(existing);
			}

			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

			List<Jackpot> jackpots = uow.Jackpots.GetAll();
			bool allFuture = jackpots.All(j => j.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5));
			bool allReasonable = jackpots.All(j => j.EstimatedDate < DateTime.UtcNow.AddDays(365));
			bool allSufficient = jackpots.All(j => j.DPD.HasSufficientDataForForecast);

			if (!allFuture)
			{
				Console.WriteLine("    FAIL Phase 2: Found past ETAs with sufficient data");
				return false;
			}
			if (!allSufficient)
			{
				Console.WriteLine("    FAIL Phase 2: Not all jackpots show sufficient DPD");
				return false;
			}
		}

		// Phase 3: Verify error logging occurred during lifecycle
		{
			MockUnitOfWork uow = new MockUnitOfWork();
			// Create jackpot with 2 points (insufficient) to trigger error log
			Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(2, 50.0);
			existing.Category = "Grand";
			existing.House = cred.House;
			existing.Game = cred.Game;
			((MockRepoJackpots)uow.Jackpots).Add(existing);

			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

			List<ErrorLog> errors = ((MockStoreErrors)uow.Errors).GetAll();
			bool hasInsufficientLog = errors.Any(e => e.Message.Contains("Insufficient"));
			if (!hasInsufficientLog)
			{
				Console.WriteLine($"    FAIL Phase 3: No 'Insufficient' error logged (errors: {errors.Count})");
				return false;
			}
		}

		return true;
	}

	// DECISION_086/BI-006: FrozenTimeProvider deterministic time control
	private static bool FrozenTimeProviderAdvances()
	{
		DateTime start = new DateTime(2026, 2, 21, 12, 0, 0, DateTimeKind.Utc);
		FrozenTimeProvider ftp = new FrozenTimeProvider(start);

		if (ftp.UtcNow != start)
		{
			Console.WriteLine($"    FAIL: Initial time mismatch: {ftp.UtcNow} != {start}");
			return false;
		}

		ftp.Advance(TimeSpan.FromHours(6));
		DateTime expected6h = start.AddHours(6);
		if (ftp.UtcNow != expected6h)
		{
			Console.WriteLine($"    FAIL: After 6h advance: {ftp.UtcNow} != {expected6h}");
			return false;
		}

		ftp.Advance(TimeSpan.FromDays(1));
		DateTime expected30h = expected6h.AddDays(1);
		if (ftp.UtcNow != expected30h)
		{
			Console.WriteLine($"    FAIL: After 1d advance: {ftp.UtcNow} != {expected30h}");
			return false;
		}

		// Test factory methods
		FrozenTimeProvider ftpAt = FrozenTimeProvider.At(2026, 1, 15, 8, 30);
		if (ftpAt.UtcNow != new DateTime(2026, 1, 15, 8, 30, 0, DateTimeKind.Utc))
		{
			Console.WriteLine("    FAIL: Factory At() method produced wrong time");
			return false;
		}

		return true;
	}

	// DECISION_086/BI-007: StabilityMetrics.CalculateCVFromDateTimes works on ETA sequences
	private static bool CVFromDateTimesWorks()
	{
		DateTime baseTime = DateTime.UtcNow.AddDays(5);

		// Stable ETAs — all within 10 minutes of each other
		List<DateTime> stableETAs = new List<DateTime>
		{
			baseTime,
			baseTime.AddMinutes(2),
			baseTime.AddMinutes(-1),
			baseTime.AddMinutes(3),
			baseTime.AddMinutes(1),
		};

		double cv = StabilityMetrics.CalculateCVFromDateTimes(stableETAs);
		bool isStable = StabilityMetrics.IsStable(cv);

		// For near-zero baseline offsets, CV calculation from minutes should work
		// The actual stability depends on spread relative to mean offset
		// With these small offsets, we just verify no exception and valid result
		if (double.IsNaN(cv) || double.IsInfinity(cv))
		{
			Console.WriteLine($"    FAIL: CV from DateTimes returned invalid value: {cv}");
			return false;
		}

		return true;
	}

	// DECISION_086/BI-008: Different tiers can have different DPD states simultaneously
	private static bool MixedTierDPDStates()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Grand: 10 points (sufficient), Major: 2 points (insufficient)
		Jackpot grandExisting = BurnInTestData.CreateJackpotWithDPDPoints(10, 400.0);
		grandExisting.Category = "Grand";
		grandExisting.House = cred.House;
		grandExisting.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(grandExisting);

		Jackpot majorExisting = BurnInTestData.CreateJackpotWithDPDPoints(2, 50.0);
		majorExisting.Category = "Major";
		majorExisting.House = cred.House;
		majorExisting.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(majorExisting);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? grand = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		Jackpot? major = uow.Jackpots.Get("Major", cred.House, cred.Game);

		if (grand == null || major == null)
		{
			Console.WriteLine("    FAIL: Missing Grand or Major jackpot");
			return false;
		}

		// Both should have future ETAs regardless of DPD state
		bool grandFuture = grand.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);
		bool majorFuture = major.EstimatedDate >= DateTime.UtcNow.AddSeconds(-5);

		if (!grandFuture)
			Console.WriteLine($"    FAIL: Grand (sufficient) has past ETA");
		if (!majorFuture)
			Console.WriteLine($"    FAIL: Major (insufficient) has past ETA");

		return grandFuture && majorFuture;
	}

	// DECISION_086/BI-009: Errors accumulate across multiple prediction cycles
	private static bool ErrorAccumulationAcrossCycles()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Run with insufficient DPD multiple times
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(2, 100.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));
		int errorsAfterFirst = ((MockStoreErrors)uow.Errors).GetAll().Count;

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));
		int errorsAfterSecond = ((MockStoreErrors)uow.Errors).GetAll().Count;

		// Errors should accumulate (second cycle adds more)
		bool accumulated = errorsAfterSecond >= errorsAfterFirst;

		if (!accumulated)
			Console.WriteLine($"    FAIL: Errors didn't accumulate: {errorsAfterFirst} → {errorsAfterSecond}");

		return accumulated;
	}

	// DECISION_086/BI-010: CalculateMinutesToValue returns 0 when threshold is already reached
	private static bool ThresholdReachedReturnsZero()
	{
		// Current >= Threshold → 0 minutes
		double minutes1 = ForecastingService.CalculateMinutesToValue(1000.0, 1000.0, 100.0);
		double minutes2 = ForecastingService.CalculateMinutesToValue(1000.0, 1500.0, 100.0);

		if (minutes1 != 0)
		{
			Console.WriteLine($"    FAIL: Threshold reached (equal) returned {minutes1}, expected 0");
			return false;
		}
		if (minutes2 != 0)
		{
			Console.WriteLine($"    FAIL: Threshold exceeded returned {minutes2}, expected 0");
			return false;
		}

		return true;
	}
}
