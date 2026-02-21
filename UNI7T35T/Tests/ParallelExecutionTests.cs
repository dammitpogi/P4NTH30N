using P4NTH30N.C0MMON;
using P4NTH30N.H4ND.EntryPoint;
using P4NTH30N.H4ND.Parallel;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// ARCH-047: Unit tests for parallel execution components.
/// Tests atomic claiming, metrics, work items, config, and unified entry point.
/// </summary>
public static class ParallelExecutionTests
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

		Run("Test_ClaimNext_ReturnsUnclaimedSignal", Test_ClaimNext_ReturnsUnclaimedSignal);
		Run("Test_ClaimNext_SkipsAcknowledgedSignals", Test_ClaimNext_SkipsAcknowledgedSignals);
		Run("Test_ClaimNext_SkipsAlreadyClaimedSignals", Test_ClaimNext_SkipsAlreadyClaimedSignals);
		Run("Test_ClaimNext_ReturnsNullWhenEmpty", Test_ClaimNext_ReturnsNullWhenEmpty);
		Run("Test_ClaimNext_SetsClaimedByAndClaimedAt", Test_ClaimNext_SetsClaimedByAndClaimedAt);
		Run("Test_ReleaseClaim_ClearsClaimFields", Test_ReleaseClaim_ClearsClaimFields);
		Run("Test_TwoConcurrentClaims_ReturnDifferentSignals", Test_TwoConcurrentClaims_ReturnDifferentSignals);
		Run("Test_SignalWorkItem_CanRetry", Test_SignalWorkItem_CanRetry);
		Run("Test_SignalClaimResult_Factories", Test_SignalClaimResult_Factories);
		Run("Test_ParallelMetrics_RecordsCorrectly", Test_ParallelMetrics_RecordsCorrectly);
		Run("Test_ParallelMetrics_SuccessRate", Test_ParallelMetrics_SuccessRate);
		Run("Test_ParallelConfig_Defaults", Test_ParallelConfig_Defaults);
		Run("Test_UnifiedEntryPoint_ParseMode", Test_UnifiedEntryPoint_ParseMode);
		Run("Test_SignalClone_IncludesClaimFields", Test_SignalClone_IncludesClaimFields);

		return (passed, failed);
	}

	private static Signal MakeSignal(string username, string house = "TestHouse", string game = "FireKirin", float priority = 3)
	{
		return new Signal
		{
			Username = username,
			House = house,
			Game = game,
			Priority = priority,
			Acknowledged = false,
		};
	}

	private static Credential MakeCredential(string username, string house = "TestHouse", string game = "FireKirin")
	{
		return new Credential
		{
			Username = username,
			House = house,
			Game = game,
			Password = "test123",
		};
	}

	// --- Atomic Claim Tests ---

	static bool Test_ClaimNext_ReturnsUnclaimedSignal()
	{
		var repo = new MockRepoSignals();
		var signal = MakeSignal("user1");
		repo.Add(signal);

		var claimed = repo.ClaimNext("worker-1");
		return claimed != null && claimed.Username == "user1";
	}

	static bool Test_ClaimNext_SkipsAcknowledgedSignals()
	{
		var repo = new MockRepoSignals();
		var s1 = MakeSignal("user1");
		s1.Acknowledged = true;
		repo.Add(s1);

		var s2 = MakeSignal("user2");
		repo.Add(s2);

		var claimed = repo.ClaimNext("worker-1");
		return claimed != null && claimed.Username == "user2";
	}

	static bool Test_ClaimNext_SkipsAlreadyClaimedSignals()
	{
		var repo = new MockRepoSignals();
		var s1 = MakeSignal("user1");
		s1.ClaimedBy = "other-worker";
		s1.ClaimedAt = DateTime.UtcNow;
		repo.Add(s1);

		var claimed = repo.ClaimNext("worker-1");
		return claimed == null; // Only one signal, already claimed
	}

	static bool Test_ClaimNext_ReturnsNullWhenEmpty()
	{
		var repo = new MockRepoSignals();
		var claimed = repo.ClaimNext("worker-1");
		return claimed == null;
	}

	static bool Test_ClaimNext_SetsClaimedByAndClaimedAt()
	{
		var repo = new MockRepoSignals();
		repo.Add(MakeSignal("user1"));

		var claimed = repo.ClaimNext("worker-42");
		return claimed != null
			&& claimed.ClaimedBy == "worker-42"
			&& claimed.ClaimedAt != null
			&& (DateTime.UtcNow - claimed.ClaimedAt.Value).TotalSeconds < 5;
	}

	static bool Test_ReleaseClaim_ClearsClaimFields()
	{
		var repo = new MockRepoSignals();
		var signal = MakeSignal("user1");
		repo.Add(signal);

		repo.ClaimNext("worker-1");
		repo.ReleaseClaim(signal);

		return signal.ClaimedBy == null && signal.ClaimedAt == null;
	}

	static bool Test_TwoConcurrentClaims_ReturnDifferentSignals()
	{
		var repo = new MockRepoSignals();
		repo.Add(MakeSignal("user1", priority: 4));
		repo.Add(MakeSignal("user2", priority: 3));

		var claim1 = repo.ClaimNext("worker-1");
		var claim2 = repo.ClaimNext("worker-2");

		// Both should succeed with different signals
		return claim1 != null
			&& claim2 != null
			&& claim1.Username != claim2.Username;
	}

	// --- DTO Tests ---

	static bool Test_SignalWorkItem_CanRetry()
	{
		var item = new SignalWorkItem
		{
			Signal = MakeSignal("u1"),
			Credential = MakeCredential("u1"),
			WorkerId = "W00",
		};

		bool canRetryInitially = item.CanRetry; // true, RetryCount=0
		item.RetryCount = SignalWorkItem.MaxRetries;
		bool canRetryAtMax = item.CanRetry; // false

		return canRetryInitially && !canRetryAtMax;
	}

	static bool Test_SignalClaimResult_Factories()
	{
		var signal = MakeSignal("u1");

		var ok = SignalClaimResult.Claimed(signal, "w1");
		var none = SignalClaimResult.NoneAvailable("w2");
		var fail = SignalClaimResult.Failed("w3", "timeout");

		return ok.Success && ok.Signal == signal && ok.WorkerId == "w1"
			&& !none.Success && none.Signal == null
			&& !fail.Success && fail.ErrorMessage == "timeout";
	}

	// --- Metrics Tests ---

	static bool Test_ParallelMetrics_RecordsCorrectly()
	{
		var m = new ParallelMetrics();
		m.RecordClaimSuccess();
		m.RecordClaimSuccess();
		m.RecordClaimFailure("test");
		m.RecordSpinResult("W00", true, TimeSpan.FromMilliseconds(500));
		m.RecordSpinResult("W01", false, TimeSpan.FromMilliseconds(1000), "error");
		m.RecordWorkerRestart("W00");

		return m.ClaimsSucceeded == 2
			&& m.ClaimsFailed == 1
			&& m.SpinsAttempted == 2
			&& m.SpinsSucceeded == 1
			&& m.SpinsFailed == 1
			&& m.WorkerRestarts == 1;
	}

	static bool Test_ParallelMetrics_SuccessRate()
	{
		var m = new ParallelMetrics();
		m.RecordSpinResult("W00", true, TimeSpan.FromMilliseconds(100));
		m.RecordSpinResult("W00", true, TimeSpan.FromMilliseconds(200));
		m.RecordSpinResult("W00", false, TimeSpan.FromMilliseconds(300), "err");

		// 2 of 3 = 66.7%
		return m.SuccessRate > 66 && m.SuccessRate < 67;
	}

	// --- Config Tests ---

	static bool Test_ParallelConfig_Defaults()
	{
		var config = new ParallelConfig();
		return config.WorkerCount == 5
			&& config.ChannelCapacity == 10
			&& config.MaxSignalsPerWorker == 100
			&& config.PollIntervalSeconds == 1.0
			&& config.ShadowMode == false;
	}

	static bool Test_UnifiedEntryPoint_ParseMode()
	{
		return UnifiedEntryPoint.ParseMode(["H4ND"]) == RunMode.Sequential
			&& UnifiedEntryPoint.ParseMode(["H0UND"]) == RunMode.Hound
			&& UnifiedEntryPoint.ParseMode(["FIRSTSPIN"]) == RunMode.FirstSpin
			&& UnifiedEntryPoint.ParseMode(["PARALLEL"]) == RunMode.Parallel
			&& UnifiedEntryPoint.ParseMode(["GARBAGE"]) == RunMode.Unknown
			&& UnifiedEntryPoint.ParseMode([]) == RunMode.Sequential;
	}

	static bool Test_SignalClone_IncludesClaimFields()
	{
		var signal = MakeSignal("u1");
		signal.ClaimedBy = "worker-99";
		signal.ClaimedAt = new DateTime(2026, 2, 20, 15, 0, 0, DateTimeKind.Utc);

		var clone = (Signal)signal.Clone();
		return clone.ClaimedBy == "worker-99"
			&& clone.ClaimedAt == signal.ClaimedAt;
	}
}
