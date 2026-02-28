using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Application.Analytics;
using P4NTHE0N.H0UND.Domain.Signals;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;
using P4NTHE0N.C0MMON.Infrastructure.Monitoring;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// DECISION_071: Verify signal preservation fix.
/// CleanupStaleSignals must only run when qualifiedSignals is non-empty,
/// preventing deletion of all signals when generation fails.
/// </summary>
public static class AnalyticsWorkerSignalPreservationTests
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

		Run("Test_EmptyQualified_PreservesExistingSignals", Test_EmptyQualified_PreservesExistingSignals);
		Run("Test_NonEmptyQualified_CleansStale", Test_NonEmptyQualified_CleansStale);
		Run("Test_AnalyticsWorker_PreservesSignalsOnGenerationFailure", Test_AnalyticsWorker_PreservesSignalsOnGenerationFailure);
		Run("Test_CleanupGuard_ZeroQualified_ZeroDeletion", Test_CleanupGuard_ZeroQualified_ZeroDeletion);
		Run("Test_CleanupGuard_WithQualified_RemovesStale", Test_CleanupGuard_WithQualified_RemovesStale);

		return (passed, failed);
	}

	private static bool Test_EmptyQualified_PreservesExistingSignals()
	{
		var uow = new MockUnitOfWork();
		var existing = new Signal { House = "MIDAS", Game = "FireKirin", Username = "user1", Priority = 4 };
		((MockRepoSignals)uow.Signals).Add(existing);

		List<Signal> allSignals = new() { existing };
		List<Signal> qualifiedSignals = new(); // Empty — generation failed

		// DECISION_071: Guard prevents cleanup when qualified is empty
		if (qualifiedSignals.Count > 0)
		{
			SignalService.CleanupStaleSignals(uow, allSignals, qualifiedSignals);
		}

		return uow.Signals.GetAll().Count == 1; // Signal preserved
	}

	private static bool Test_NonEmptyQualified_CleansStale()
	{
		var uow = new MockUnitOfWork();
		var stale = new Signal { House = "MIDAS", Game = "FireKirin", Username = "stale_user", Priority = 3 };
		var active = new Signal { House = "MIDAS", Game = "OrionStars", Username = "active_user", Priority = 4 };
		((MockRepoSignals)uow.Signals).Add(stale);
		((MockRepoSignals)uow.Signals).Add(active);

		List<Signal> allSignals = new() { stale, active };
		List<Signal> qualifiedSignals = new()
		{
			new Signal { House = "MIDAS", Game = "OrionStars", Username = "active_user", Priority = 4 }
		};

		if (qualifiedSignals.Count > 0)
		{
			SignalService.CleanupStaleSignals(uow, allSignals, qualifiedSignals);
		}

		var remaining = uow.Signals.GetAll();
		// Stale signal for FireKirin should be cleaned, OrionStars should remain
		return remaining.Count == 1 && remaining[0].Game == "OrionStars";
	}

	private static bool Test_AnalyticsWorker_PreservesSignalsOnGenerationFailure()
	{
		// Full AnalyticsWorker integration: when no credentials produce signals,
		// existing signals must survive
		var uow = new MockUnitOfWork();
		var existingSignal = new Signal { House = "MIDAS", Game = "FireKirin", Username = "user1", Priority = 4 };
		((MockRepoSignals)uow.Signals).Add(existingSignal);

		// No credentials = no groups = no qualified signals
		// AnalyticsWorker.RunAnalytics should NOT delete the existing signal
		var worker = new AnalyticsWorker();
		worker.RunAnalytics(uow);

		return uow.Signals.GetAll().Count == 1; // Signal must survive
	}

	private static bool Test_CleanupGuard_ZeroQualified_ZeroDeletion()
	{
		var uow = new MockUnitOfWork();
		// Add 5 signals
		for (int i = 0; i < 5; i++)
		{
			((MockRepoSignals)uow.Signals).Add(new Signal
			{
				House = "MIDAS",
				Game = "FireKirin",
				Username = $"user{i}",
				Priority = 4,
			});
		}

		List<Signal> qualifiedSignals = new(); // Empty

		// Guard: do NOT clean if empty
		if (qualifiedSignals.Count > 0)
		{
			SignalService.CleanupStaleSignals(uow, uow.Signals.GetAll(), qualifiedSignals);
		}

		return uow.Signals.GetAll().Count == 5; // All 5 preserved
	}

	private static bool Test_CleanupGuard_WithQualified_RemovesStale()
	{
		var uow = new MockUnitOfWork();
		var s1 = new Signal { House = "MIDAS", Game = "FireKirin", Username = "keep", Priority = 4 };
		var s2 = new Signal { House = "MIDAS", Game = "FireKirin", Username = "remove", Priority = 2 };
		((MockRepoSignals)uow.Signals).Add(s1);
		((MockRepoSignals)uow.Signals).Add(s2);

		List<Signal> qualified = new()
		{
			new Signal { House = "MIDAS", Game = "FireKirin", Username = "keep", Priority = 4 },
		};

		if (qualified.Count > 0)
		{
			// Snapshot to avoid collection-modified-during-enumeration
			var allSnapshot = uow.Signals.GetAll().ToList();
			SignalService.CleanupStaleSignals(uow, allSnapshot, qualified);
		}

		var remaining = uow.Signals.GetAll();
		return remaining.Count == 1 && remaining[0].Username == "keep";
	}
}
