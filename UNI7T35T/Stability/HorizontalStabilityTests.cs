using System;
using System.Collections.Generic;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.UNI7T35T.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Stability;

// DECISION_086: Horizontal stability tests based on Godahewa et al. (2023)
// Validates consistency across forecast cycles - similar inputs produce similar ETAs
public static class HorizontalStabilityTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string Name, Func<bool> Test)[] tests =
		[
			("HS-001: Repeated predictions with same data produce consistent ETAs", RepeatedPredictionsConsistent),
			("HS-002: All four tiers get processed independently", AllTiersProcessedIndependently),
			("HS-003: Multiple credentials produce independent estimates", MultipleCredentialsIndependent),
			("HS-004: Existing jackpot DPD data preserved after prediction", DPDDataPreservedAfterPrediction),
			("HS-005: Upsert overwrites existing jackpot by _id", UpsertOverwritesExisting),
			("HS-006: Error store receives entries only for invalid DPD", ErrorStoreIsolation),
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

	// DECISION_086/HS-001: Running GeneratePredictions twice with same data should produce similar ETAs
	private static bool RepeatedPredictionsConsistent()
	{
		Credential cred = BurnInTestData.CreateTestCredential();

		List<DateTime> grandETAs = new List<DateTime>();

		for (int run = 0; run < 5; run++)
		{
			MockUnitOfWork uow = new MockUnitOfWork();

			// Seed with identical DPD data each run
			Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 300.0);
			existing.Category = "Grand";
			existing.House = cred.House;
			existing.Game = cred.Game;
			((MockRepoJackpots)uow.Jackpots).Add(existing);

			ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

			Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
			if (result == null) return false;

			grandETAs.Add(result.EstimatedDate);
		}

		// All ETAs should be within 2 minutes of each other (accounting for DateTime.UtcNow drift during test)
		DateTime minETA = grandETAs.Min();
		DateTime maxETA = grandETAs.Max();
		double spreadMinutes = (maxETA - minETA).TotalMinutes;

		if (spreadMinutes > 2.0)
		{
			Console.WriteLine($"    FAIL: ETA spread is {spreadMinutes:F2} minutes (max 2 min allowed)");
			return false;
		}

		return true;
	}

	// DECISION_086/HS-002: All 4 tiers (Grand, Major, Minor, Mini) should get independent jackpot entries
	private static bool AllTiersProcessedIndependently()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		List<Jackpot> jackpots = uow.Jackpots.GetAll();

		// Should have 4 jackpots (one per tier)
		if (jackpots.Count != 4)
		{
			Console.WriteLine($"    FAIL: Expected 4 jackpots, got {jackpots.Count}");
			return false;
		}

		// Each category should be unique
		HashSet<string> categories = new HashSet<string>(jackpots.Select(j => j.Category));
		if (categories.Count != 4)
		{
			Console.WriteLine($"    FAIL: Expected 4 unique categories, got {categories.Count}");
			return false;
		}

		bool hasGrand = categories.Contains("Grand");
		bool hasMajor = categories.Contains("Major");
		bool hasMinor = categories.Contains("Minor");
		bool hasMini = categories.Contains("Mini");

		return hasGrand && hasMajor && hasMinor && hasMini;
	}

	// DECISION_086/HS-003: Different credentials should produce independent estimates
	private static bool MultipleCredentialsIndependent()
	{
		MockUnitOfWork uow = new MockUnitOfWork();

		Credential cred1 = BurnInTestData.CreateTestCredential("House A", "FireKirin");
		Credential cred2 = BurnInTestData.CreateTestCredential("House B", "FireKirin");

		ForecastingService.GeneratePredictions(cred1, uow, DateTime.UtcNow.AddDays(30));
		ForecastingService.GeneratePredictions(cred2, uow, DateTime.UtcNow.AddDays(30));

		List<Jackpot> jackpots = uow.Jackpots.GetAll();

		// Should have 8 jackpots (4 per credential)
		if (jackpots.Count != 8)
		{
			Console.WriteLine($"    FAIL: Expected 8 jackpots for 2 credentials, got {jackpots.Count}");
			return false;
		}

		int houseACount = jackpots.Count(j => j.House == "House A");
		int houseBCount = jackpots.Count(j => j.House == "House B");

		return houseACount == 4 && houseBCount == 4;
	}

	// DECISION_086/HS-004: DPD data from existing jackpot is preserved after re-prediction
	private static bool DPDDataPreservedAfterPrediction()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 250.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		int originalDPDCount = existing.DPD.Data.Count;

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		Jackpot? result = uow.Jackpots.Get("Grand", cred.House, cred.Game);
		if (result == null) return false;

		bool dpdPreserved = result.DPD.Data.Count == originalDPDCount;
		if (!dpdPreserved)
			Console.WriteLine($"    FAIL: DPD data count changed from {originalDPDCount} to {result.DPD.Data.Count}");

		return dpdPreserved;
	}

	// DECISION_086/HS-005: Upsert correctly overwrites existing jackpot by matching _id
	private static bool UpsertOverwritesExisting()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(6, 200.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		// Run predictions twice
		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));
		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		// Should still have only 4 jackpots, not 8 (upsert, not insert)
		List<Jackpot> jackpots = uow.Jackpots.GetAll();
		int grandCount = jackpots.Count(j => j.Category == "Grand" && j.House == cred.House);

		if (grandCount != 1)
		{
			Console.WriteLine($"    FAIL: Expected 1 Grand jackpot after upsert, got {grandCount}");
			return false;
		}

		return true;
	}

	// DECISION_086/HS-006: Error store only receives entries for invalid DPD scenarios
	private static bool ErrorStoreIsolation()
	{
		MockUnitOfWork uow = new MockUnitOfWork();
		Credential cred = BurnInTestData.CreateTestCredential();

		// Valid DPD data - should NOT produce error logs
		Jackpot existing = BurnInTestData.CreateJackpotWithDPDPoints(10, 300.0);
		existing.Category = "Grand";
		existing.House = cred.House;
		existing.Game = cred.Game;
		((MockRepoJackpots)uow.Jackpots).Add(existing);

		ForecastingService.GeneratePredictions(cred, uow, DateTime.UtcNow.AddDays(30));

		List<ErrorLog> errors = ((MockStoreErrors)uow.Errors).GetAll();
		// Valid DPD should not produce ForecastingService errors
		int forecastErrors = errors.Count(e => e.Source == "ForecastingService");

		if (forecastErrors > 0)
		{
			Console.WriteLine($"    FAIL: Valid DPD produced {forecastErrors} ForecastingService errors");
			return false;
		}

		return true;
	}
}
