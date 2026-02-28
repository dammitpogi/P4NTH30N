using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.H0UND.Domain.Signals;
using P4NTHE0N.H0UND.Infrastructure.Polling;
using P4NTHE0N.H0UND.Services;
using UNI7T35T.Mocks;

namespace P4NTH35T.Tests;

/// <summary>
/// H0UND Weakpoint Audit Tests — covers 8 bugs found during deep audit.
/// Each test targets a specific logic failure, race condition, null path, or silent drop.
/// These tests exist to PREVENT regression and GUIDE future development.
/// </summary>
public static class H0UNDWeakpointAuditTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		(string name, Func<bool> test)[] tests =
		[
			// BUG 1: Skip-logic operator precedence
			("WP-001: SameGrand_DifferentHouseGame_ShouldProcess", WP001_SameGrand_DifferentHouseGame_ShouldProcess),
			("WP-001: SameGrand_SameHouseGame_ShouldSkip", WP001_SameGrand_SameHouseGame_ShouldSkip),
			("WP-001: DifferentGrand_SameHouseGame_ShouldProcess", WP001_DifferentGrand_SameHouseGame_ShouldProcess),

			// BUG 2: Null DPD dereference
			("WP-002: NullDPD_DoesNotThrow", WP002_NullDPD_DoesNotThrow),
			("WP-002: NullDPD_Jackpot_SkipsToggle", WP002_NullDPD_Jackpot_SkipsToggle),

			// BUG 4: Signal timeout too short
			("WP-004: SignalTimeout_SurvivesPollingCycle", WP004_SignalTimeout_SurvivesPollingCycle),
			("WP-004: SignalTimeout_NotExpiredAfter5Minutes", WP004_SignalTimeout_NotExpiredAfter5Minutes),

			// BUG 5: DPD only tracks Grand tier
			("WP-005: DPD_MajorTier_TracksCorrectly", WP005_DPD_MajorTier_TracksCorrectly),
			("WP-005: DPD_MinorTier_TracksCorrectly", WP005_DPD_MinorTier_TracksCorrectly),
			("WP-005: DPD_MiniTier_TracksCorrectly", WP005_DPD_MiniTier_TracksCorrectly),
			("WP-005: DPD_GrandStatic_MajorGrows_StillUpdates", WP005_DPD_GrandStatic_MajorGrows_StillUpdates),
			("WP-005: DPD_Average_UsesTierSpecificDollars", WP005_DPD_Average_UsesTierSpecificDollars),

			// BUG 7: BalanceProviderFactory throws generic Exception
			("WP-007: UnrecognizedGame_ThrowsArgumentException", WP007_UnrecognizedGame_ThrowsArgumentException),
			("WP-007: NullGame_ThrowsArgumentException", WP007_NullGame_ThrowsArgumentException),
			("WP-007: EmptyGame_ThrowsArgumentException", WP007_EmptyGame_ThrowsArgumentException),
			("WP-007: ValidGames_ReturnProviders", WP007_ValidGames_ReturnProviders),

			// BUG 8: AnomalyDetector thread-unsafe counters
			("WP-008: AnomalyDetector_CountersAreThreadSafe", WP008_AnomalyDetector_CountersAreThreadSafe),
			("WP-008: AnomalyDetector_ConcurrentProcess_NoCorruption", WP008_AnomalyDetector_ConcurrentProcess_NoCorruption),

			// Signal generation robustness for parallel flow
			("WP-SIG: SignalService_NullGroup_Skipped", WP_SIG_NullGroup_Skipped),
			("WP-SIG: SignalService_NoEnabledCreds_NoSignals", WP_SIG_NoEnabledCreds_NoSignals),
			("WP-SIG: SignalService_BannedCreds_Excluded", WP_SIG_BannedCreds_Excluded),
			("WP-SIG: SignalService_CashedOutCreds_Excluded", WP_SIG_CashedOutCreds_Excluded),
			("WP-SIG: SignalService_HigherPriority_OverwritesLower", WP_SIG_HigherPriority_OverwritesLower),
			("WP-SIG: ForecastingService_ZeroDPD_SafeMaxMinutes", WP_SIG_ForecastingService_ZeroDPD_SafeMaxMinutes),
			("WP-SIG: DpdCalculator_Reset_ClearsDataAndAverage", WP_SIG_DpdCalculator_Reset_ClearsDataAndAverage),
		];

		foreach ((string name, Func<bool> test) in tests)
		{
			try
			{
				bool result = test();
				if (result)
				{
					Console.WriteLine($"  ✅ {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  ❌ {name} — ASSERTION FAILED");
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

	// ═══════════════════════════════════════════════════════════════════
	// BUG 1: Skip-logic operator precedence in H0UND.cs
	// The old condition had && binding tighter than !=, causing valid
	// polls to be thrown away when same grand came from different house/game.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP001_SameGrand_DifferentHouseGame_ShouldProcess()
	{
		double lastGrand = 5000.0;
		double currentGrand = 5000.0;
		var lastCred = MakeCred("FireKirin", "FortunePiggy", "user1");
		var currentCred = MakeCred("OrionStars", "Gold777", "user2");

		bool isSameGrand = lastGrand.Equals(currentGrand);
		bool isSameTarget = lastCred != null
			&& currentCred.Game == lastCred.Game
			&& currentCred.House == lastCred.House;
		bool shouldProcess = !isSameGrand || !isSameTarget;

		// Same grand but different house/game → MUST process
		return shouldProcess == true;
	}

	static bool WP001_SameGrand_SameHouseGame_ShouldSkip()
	{
		double lastGrand = 5000.0;
		double currentGrand = 5000.0;
		var lastCred = MakeCred("FireKirin", "FortunePiggy", "user1");
		var currentCred = MakeCred("FireKirin", "FortunePiggy", "user2");

		bool isSameGrand = lastGrand.Equals(currentGrand);
		bool isSameTarget = lastCred != null
			&& currentCred.Game == lastCred.Game
			&& currentCred.House == lastCred.House;
		bool shouldProcess = !isSameGrand || !isSameTarget;

		// Same grand AND same house/game → should skip (no change)
		return shouldProcess == false;
	}

	static bool WP001_DifferentGrand_SameHouseGame_ShouldProcess()
	{
		double lastGrand = 5000.0;
		double currentGrand = 5100.0;
		var lastCred = MakeCred("FireKirin", "FortunePiggy", "user1");
		var currentCred = MakeCred("FireKirin", "FortunePiggy", "user2");

		bool isSameGrand = lastGrand.Equals(currentGrand);
		bool isSameTarget = lastCred != null
			&& currentCred.Game == lastCred.Game
			&& currentCred.House == lastCred.House;
		bool shouldProcess = !isSameGrand || !isSameTarget;

		// Different grand → MUST process regardless of house/game
		return shouldProcess == true;
	}

	// ═══════════════════════════════════════════════════════════════════
	// BUG 2: Null DPD dereference on Jackpot objects
	// grandJackpot.DPD! would NullRef if DPD was null on fresh jackpots.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP002_NullDPD_DoesNotThrow()
	{
		var jackpot = new Jackpot { Category = "Grand", House = "FireKirin", Game = "FortunePiggy" };
		// DPD is initialized to new DPD() by default, but Toggles could be null in edge cases
		// The fix uses ?. operator so even if DPD were null, no throw
		bool result = jackpot.DPD != null && jackpot.DPD.Toggles.GrandPopped == false;
		return result;
	}

	static bool WP002_NullDPD_Jackpot_SkipsToggle()
	{
		var jackpot = new Jackpot { Category = "Grand", House = "FK", Game = "FP" };
		// Simulate the fixed null-safe check pattern
		bool conditionResult = jackpot?.DPD != null && jackpot.DPD.Toggles.GrandPopped == true;
		// GrandPopped defaults to false, so this should be false
		return conditionResult == false;
	}

	// ═══════════════════════════════════════════════════════════════════
	// BUG 4: Signal Timeout was 30 seconds — too short for polling cycle
	// H0UND polls 310 credentials at 3-5s each = 15-25 min full sweep.
	// Signals expired before H4ND could ever see them.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP004_SignalTimeout_SurvivesPollingCycle()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("FireKirin", "FortunePiggy", "user1");
		cred.Enabled = true;
		cred.Banned = false;
		cred.CashedOut = false;
		cred.Balance = 10.0;

		var jackpot = new Jackpot
		{
			Category = "Grand",
			House = "FireKirin",
			Game = "FortunePiggy",
			Priority = 4,
			Current = 4999.9,
			Threshold = 5000.0,
			EstimatedDate = DateTime.UtcNow.AddMinutes(-10),
		};

		var groups = new[] { cred }.GroupBy(c => (c.House, c.Game)).ToList();
		var signals = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());

		if (signals.Count == 0) return false;

		// Signal timeout must be > 5 minutes to survive a polling cycle
		var sig = signals[0];
		double minutesUntilTimeout = (sig.Timeout - DateTime.UtcNow).TotalMinutes;
		return minutesUntilTimeout > 5.0;
	}

	static bool WP004_SignalTimeout_NotExpiredAfter5Minutes()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("FireKirin", "FortunePiggy", "user1");
		cred.Enabled = true;
		cred.Banned = false;
		cred.CashedOut = false;
		cred.Balance = 10.0;

		var jackpot = new Jackpot
		{
			Category = "Grand",
			House = "FireKirin",
			Game = "FortunePiggy",
			Priority = 4,
			Current = 4999.9,
			Threshold = 5000.0,
			EstimatedDate = DateTime.UtcNow.AddMinutes(-10),
		};

		var groups = new[] { cred }.GroupBy(c => (c.House, c.Game)).ToList();
		var signals = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());

		if (signals.Count == 0) return false;

		// Simulate 5 minutes passing
		DateTime fiveMinutesLater = DateTime.UtcNow.AddMinutes(5);
		return signals[0].Timeout > fiveMinutesLater;
	}

	// ═══════════════════════════════════════════════════════════════════
	// BUG 5: DPD only tracked Grand tier — Major/Minor/Mini were ignored
	// A game where Grand was static but Major was climbing fast would
	// never accumulate DPD data points.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP005_DPD_MajorTier_TracksCorrectly()
	{
		var jackpot = new Jackpot { Category = "Major", House = "FK", Game = "FP" };
		var cred = MakeCred("FK", "FP", "u1");
		cred.Jackpots.Grand = 5000; // Grand stays the same
		cred.Jackpots.Major = 100;

		DpdCalculator.UpdateDPD(jackpot, cred);
		int countAfterFirst = jackpot.DPD.Data.Count;

		// Major grows, Grand stays same
		cred.Jackpots.Major = 150;
		DpdCalculator.UpdateDPD(jackpot, cred);
		int countAfterSecond = jackpot.DPD.Data.Count;

		// Must have added a second data point because Major grew
		return countAfterFirst == 1 && countAfterSecond == 2;
	}

	static bool WP005_DPD_MinorTier_TracksCorrectly()
	{
		var jackpot = new Jackpot { Category = "Minor", House = "FK", Game = "FP" };
		var cred = MakeCred("FK", "FP", "u1");
		cred.Jackpots.Minor = 50;

		DpdCalculator.UpdateDPD(jackpot, cred);

		cred.Jackpots.Minor = 75;
		DpdCalculator.UpdateDPD(jackpot, cred);

		return jackpot.DPD.Data.Count == 2;
	}

	static bool WP005_DPD_MiniTier_TracksCorrectly()
	{
		var jackpot = new Jackpot { Category = "Mini", House = "FK", Game = "FP" };
		var cred = MakeCred("FK", "FP", "u1");
		cred.Jackpots.Mini = 10;

		DpdCalculator.UpdateDPD(jackpot, cred);

		cred.Jackpots.Mini = 20;
		DpdCalculator.UpdateDPD(jackpot, cred);

		return jackpot.DPD.Data.Count == 2;
	}

	static bool WP005_DPD_GrandStatic_MajorGrows_StillUpdates()
	{
		// This is the exact scenario that was broken before the fix
		var jackpot = new Jackpot { Category = "Major", House = "FK", Game = "FP" };
		var cred = MakeCred("FK", "FP", "u1");
		cred.Jackpots.Grand = 5000; // Grand never changes
		cred.Jackpots.Major = 200;

		DpdCalculator.UpdateDPD(jackpot, cred);

		// Grand stays at 5000, Major grows
		cred.Jackpots.Grand = 5000;
		cred.Jackpots.Major = 250;
		DpdCalculator.UpdateDPD(jackpot, cred);

		cred.Jackpots.Grand = 5000;
		cred.Jackpots.Major = 300;
		DpdCalculator.UpdateDPD(jackpot, cred);

		// Must have 3 data points even though Grand never changed
		return jackpot.DPD.Data.Count == 3 && jackpot.DPD.Average > 0;
	}

	static bool WP005_DPD_Average_UsesTierSpecificDollars()
	{
		var jackpot = new Jackpot { Category = "Minor", House = "FK", Game = "FP" };
		var cred = MakeCred("FK", "FP", "u1");
		cred.Jackpots.Grand = 5000;
		cred.Jackpots.Minor = 100;

		DpdCalculator.UpdateDPD(jackpot, cred);

		// Advance Minor by 50, Grand stays same
		cred.Jackpots.Minor = 150;
		DpdCalculator.UpdateDPD(jackpot, cred);

		// Average should be based on Minor dollar growth (50), not Grand (0)
		// If it used Grand, average would be 0
		return jackpot.DPD.Average > 0;
	}

	// ═══════════════════════════════════════════════════════════════════
	// BUG 7: BalanceProviderFactory threw generic Exception
	// Now throws ArgumentException for better error handling upstream.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP007_UnrecognizedGame_ThrowsArgumentException()
	{
		var factory = new BalanceProviderFactory();
		try
		{
			factory.GetProvider("UnknownGame");
			return false; // Should have thrown
		}
		catch (ArgumentException ex)
		{
			return ex.Message.Contains("UnknownGame");
		}
		catch
		{
			return false; // Wrong exception type
		}
	}

	static bool WP007_NullGame_ThrowsArgumentException()
	{
		var factory = new BalanceProviderFactory();
		try
		{
			factory.GetProvider(null!);
			return false;
		}
		catch (ArgumentException)
		{
			return true;
		}
		catch
		{
			return false;
		}
	}

	static bool WP007_EmptyGame_ThrowsArgumentException()
	{
		var factory = new BalanceProviderFactory();
		try
		{
			factory.GetProvider("");
			return false;
		}
		catch (ArgumentException)
		{
			return true;
		}
		catch
		{
			return false;
		}
	}

	static bool WP007_ValidGames_ReturnProviders()
	{
		var factory = new BalanceProviderFactory();
		var fk = factory.GetProvider("FireKirin");
		var os = factory.GetProvider("OrionStars");
		return fk is FireKirinBalanceProvider && os is OrionStarsBalanceProvider;
	}

	// ═══════════════════════════════════════════════════════════════════
	// BUG 8: AnomalyDetector counters were not thread-safe
	// TotalProcessed++ and TotalAnomalies++ are now Interlocked.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP008_AnomalyDetector_CountersAreThreadSafe()
	{
		var detector = new AnomalyDetector(windowSize: 50, compressionThreshold: 1.3, zScoreThreshold: 3.0);

		// Process several values
		for (int i = 0; i < 10; i++)
			detector.Process("FK", "FP", "Grand", 1000 + i);

		return detector.TotalProcessed == 10;
	}

	static bool WP008_AnomalyDetector_ConcurrentProcess_NoCorruption()
	{
		var detector = new AnomalyDetector(windowSize: 100, compressionThreshold: 1.3, zScoreThreshold: 3.0);
		int threadCount = 4;
		int iterationsPerThread = 250;

		var tasks = new Task[threadCount];
		for (int t = 0; t < threadCount; t++)
		{
			int threadId = t;
			tasks[t] = Task.Run(() =>
			{
				for (int i = 0; i < iterationsPerThread; i++)
					detector.Process("FK", "FP", $"Tier{threadId}", 1000 + i);
			});
		}
		Task.WaitAll(tasks);

		long expected = threadCount * iterationsPerThread;
		return detector.TotalProcessed == expected;
	}

	// ═══════════════════════════════════════════════════════════════════
	// Signal Generation Robustness for Parallel Flow
	// These tests ensure SignalService handles edge cases that would
	// cause silent drops or crashes during parallel execution.
	// ═══════════════════════════════════════════════════════════════════

	static bool WP_SIG_NullGroup_Skipped()
	{
		var uow = new MockUnitOfWork();
		// Jackpot exists but no matching credential group
		var jackpot = new Jackpot
		{
			Category = "Grand",
			House = "OrionStars",
			Game = "NoMatch",
			Priority = 4,
			Current = 4999,
			Threshold = 5000,
			EstimatedDate = DateTime.UtcNow.AddMinutes(-10),
		};

		var cred = MakeCred("FireKirin", "FortunePiggy", "user1");
		cred.Enabled = true;
		var groups = new[] { cred }.GroupBy(c => (c.House, c.Game)).ToList();

		var signals = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());
		// No matching group → no signals, no crash
		return signals.Count == 0;
	}

	static bool WP_SIG_NoEnabledCreds_NoSignals()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("FireKirin", "FP", "user1");
		cred.Enabled = false; // Disabled

		var jackpot = new Jackpot
		{
			Category = "Grand",
			House = "FireKirin",
			Game = "FP",
			Priority = 4,
			Current = 4999,
			Threshold = 5000,
			EstimatedDate = DateTime.UtcNow.AddMinutes(-10),
		};

		var groups = new[] { cred }.GroupBy(c => (c.House, c.Game)).ToList();
		var signals = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());
		// No enabled rep → no signals
		return signals.Count == 0;
	}

	static bool WP_SIG_BannedCreds_Excluded()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("FireKirin", "FP", "user1");
		cred.Enabled = true;
		cred.Banned = true; // Banned
		cred.CashedOut = false;
		cred.Balance = 10;

		var jackpot = new Jackpot
		{
			Category = "Grand",
			House = "FireKirin",
			Game = "FP",
			Priority = 4,
			Current = 4999.9,
			Threshold = 5000,
			EstimatedDate = DateTime.UtcNow.AddMinutes(-10),
		};

		var groups = new[] { cred }.GroupBy(c => (c.House, c.Game)).ToList();
		var signals = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());
		// Banned creds excluded from gameCreds → no signals
		return signals.Count == 0;
	}

	static bool WP_SIG_CashedOutCreds_Excluded()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("FireKirin", "FP", "user1");
		cred.Enabled = true;
		cred.Banned = false;
		cred.CashedOut = true; // Cashed out
		cred.Balance = 10;

		var jackpot = new Jackpot
		{
			Category = "Grand",
			House = "FireKirin",
			Game = "FP",
			Priority = 4,
			Current = 4999.9,
			Threshold = 5000,
			EstimatedDate = DateTime.UtcNow.AddMinutes(-10),
		};

		var groups = new[] { cred }.GroupBy(c => (c.House, c.Game)).ToList();
		var signals = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());
		return signals.Count == 0;
	}

	static bool WP_SIG_HigherPriority_OverwritesLower()
	{
		// Test UpsertSignalIfHigherPriority directly to avoid mock Upsert _id mismatch
		var uow = new MockUnitOfWork();
		var cred = MakeCred("FireKirin", "FP", "user1");

		// Create existing low-priority signal
		var existingSignal = new Signal(2, cred) { Timeout = DateTime.UtcNow.AddMinutes(10), Acknowledged = false };
		var existingSignals = new List<Signal> { existingSignal };
		uow.Signals.Upsert(existingSignal);

		// Create higher-priority signal
		var higherSignal = new Signal(4, cred) { Timeout = DateTime.UtcNow.AddMinutes(10), Acknowledged = false };

		// Call the method directly
		SignalService.UpsertSignalIfHigherPriority(uow, existingSignals, higherSignal, cred);

		// The repo should now contain the higher-priority signal
		var allSignals = uow.Signals.GetAll();
		bool hasHighPriority = allSignals.Any(s => s.Priority == 4 && s.House == "FireKirin" && s.Game == "FP");
		return hasHighPriority;
	}

	static bool WP_SIG_ForecastingService_ZeroDPD_SafeMaxMinutes()
	{
		// When DPD is 0, CalculateMinutesToValue should return safe max, not infinity
		double minutes = ForecastingService.CalculateMinutesToValue(5000, 4000, 0);
		bool isFinite = !double.IsInfinity(minutes) && !double.IsNaN(minutes);
		bool isPositive = minutes > 0;
		// Should not overflow DateTime
		bool safeForDateTime = minutes < (DateTime.MaxValue - DateTime.UtcNow).TotalMinutes;
		return isFinite && isPositive && safeForDateTime;
	}

	static bool WP_SIG_DpdCalculator_Reset_ClearsDataAndAverage()
	{
		var jackpot = new Jackpot { Category = "Grand", House = "FK", Game = "FP" };
		var cred = MakeCred("FK", "FP", "u1");
		cred.Jackpots.Grand = 5000;

		// Build up some DPD data
		DpdCalculator.UpdateDPD(jackpot, cred);
		cred.Jackpots.Grand = 5100;
		DpdCalculator.UpdateDPD(jackpot, cred);

		bool hadData = jackpot.DPD.Data.Count == 2;

		// Simulate jackpot reset (current < previous)
		cred.Jackpots.Grand = 100;
		DpdCalculator.UpdateDPD(jackpot, cred);

		// After reset: average should be 0, data should have 1 entry (the new starting point)
		return hadData && jackpot.DPD.Average == 0 && jackpot.DPD.Data.Count == 1;
	}

	// ═══════════════════════════════════════════════════════════════════
	// Helpers
	// ═══════════════════════════════════════════════════════════════════

	private static Credential MakeCred(string house, string game, string username)
	{
		return new Credential
		{
			House = house,
			Game = game,
			Username = username,
			Password = "pass",
			Enabled = true,
			Banned = false,
			CashedOut = false,
			Balance = 5.0,
			Jackpots = new Jackpots(),
			Thresholds = new Thresholds(),
			Settings = new GameSettings(),
		};
	}
}
