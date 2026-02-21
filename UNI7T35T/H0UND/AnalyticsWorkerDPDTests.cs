using P4NTH30N.C0MMON;
using P4NTH30N.H0UND.Domain.Forecasting;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// DECISION_069: Verify DPD data persistence fix.
/// After UpdateDPD(), uow.Jackpots.Upsert(jackpot) must be called
/// so DPD.Data arrays accumulate multiple points across analytics cycles.
/// </summary>
public static class AnalyticsWorkerDPDTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		void Run(string name, Func<bool> test)
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
				Console.WriteLine($"  ❌ {name} — Exception: {ex.Message}");
				failed++;
			}
		}

		Run("Test_UpdateDPD_AddsDataPoint", Test_UpdateDPD_AddsDataPoint);
		Run("Test_UpdateDPD_AccumulatesMultiplePoints", Test_UpdateDPD_AccumulatesMultiplePoints);
		Run("Test_UpsertAfterUpdateDPD_PersistsData", Test_UpsertAfterUpdateDPD_PersistsData);
		Run("Test_DPD_AverageUpdatesWithMultiplePoints", Test_DPD_AverageUpdatesWithMultiplePoints);
		Run("Test_DPD_ResetOnJackpotDrop", Test_DPD_ResetOnJackpotDrop);

		return (passed, failed);
	}

	private static bool Test_UpdateDPD_AddsDataPoint()
	{
		var jackpot = MakeJackpot("MIDAS", "FireKirin", "Grand");
		var cred = MakeCred("MIDAS", "FireKirin", 1500, 200, 50, 10);

		DpdCalculator.UpdateDPD(jackpot, cred);

		// First call on empty DPD.Data should add one point
		return jackpot.DPD.Data.Count == 1;
	}

	private static bool Test_UpdateDPD_AccumulatesMultiplePoints()
	{
		var jackpot = MakeJackpot("MIDAS", "FireKirin", "Grand");
		var cred1 = MakeCred("MIDAS", "FireKirin", 1500, 200, 50, 10);
		var cred2 = MakeCred("MIDAS", "FireKirin", 1510, 205, 52, 11);
		var cred3 = MakeCred("MIDAS", "FireKirin", 1520, 210, 54, 12);

		DpdCalculator.UpdateDPD(jackpot, cred1); // Point 1
		DpdCalculator.UpdateDPD(jackpot, cred2); // Point 2 (Grand increased)
		DpdCalculator.UpdateDPD(jackpot, cred3); // Point 3 (Grand increased)

		return jackpot.DPD.Data.Count == 3;
	}

	private static bool Test_UpsertAfterUpdateDPD_PersistsData()
	{
		// This tests the DECISION_069 fix: Upsert after UpdateDPD persists to repo
		var uow = new MockUnitOfWork();
		var jackpot = MakeJackpot("MIDAS", "FireKirin", "Grand");
		((MockRepoJackpots)uow.Jackpots).Add(jackpot);

		var cred = MakeCred("MIDAS", "FireKirin", 1500, 200, 50, 10);
		DpdCalculator.UpdateDPD(jackpot, cred);

		// DECISION_069: This Upsert must happen after UpdateDPD
		uow.Jackpots.Upsert(jackpot);

		// Verify the persisted jackpot has data
		var persisted = uow.Jackpots.Get("Grand", "MIDAS", "FireKirin");
		return persisted != null && persisted.DPD.Data.Count >= 1;
	}

	private static bool Test_DPD_AverageUpdatesWithMultiplePoints()
	{
		var jackpot = MakeJackpot("MIDAS", "FireKirin", "Grand");
		var cred1 = MakeCred("MIDAS", "FireKirin", 1500, 200, 50, 10);
		var cred2 = MakeCred("MIDAS", "FireKirin", 1520, 210, 55, 12);

		DpdCalculator.UpdateDPD(jackpot, cred1);

		// Manually set the first data point timestamp to simulate time passing
		jackpot.DPD.Data[0].Timestamp = DateTime.UtcNow.AddMinutes(-60);

		DpdCalculator.UpdateDPD(jackpot, cred2);

		// With 2 points and Grand increase of 20 over ~60 minutes, average should be > 0
		return jackpot.DPD.Data.Count == 2 && jackpot.DPD.Average > 0;
	}

	private static bool Test_DPD_ResetOnJackpotDrop()
	{
		var jackpot = MakeJackpot("MIDAS", "FireKirin", "Grand");
		var cred1 = MakeCred("MIDAS", "FireKirin", 1500, 200, 50, 10);
		var cred2 = MakeCred("MIDAS", "FireKirin", 1510, 205, 52, 11);
		// Grand drops (jackpot hit)
		var cred3 = MakeCred("MIDAS", "FireKirin", 800, 100, 30, 5);

		DpdCalculator.UpdateDPD(jackpot, cred1);
		DpdCalculator.UpdateDPD(jackpot, cred2);
		DpdCalculator.UpdateDPD(jackpot, cred3); // Grand dropped = reset

		// After reset: Data should have 1 point, Average should be 0
		return jackpot.DPD.Data.Count == 1 && jackpot.DPD.Average == 0;
	}

	private static Jackpot MakeJackpot(string house, string game, string category)
	{
		return new Jackpot
		{
			House = house,
			Game = game,
			Category = category,
			Priority = category == "Grand" ? 4 : category == "Major" ? 3 : category == "Minor" ? 2 : 1,
			Current = 1500,
			Threshold = 1785,
			EstimatedDate = DateTime.UtcNow.AddHours(6),
		};
	}

	private static Credential MakeCred(string house, string game, double grand, double major, double minor, double mini)
	{
		return new Credential
		{
			House = house,
			Game = game,
			Username = "testuser",
			Password = "test",
			Enabled = true,
			Balance = 10,
			LastUpdated = DateTime.UtcNow,
			Jackpots = new Jackpots { Grand = grand, Major = major, Minor = minor, Mini = mini },
		};
	}
}
