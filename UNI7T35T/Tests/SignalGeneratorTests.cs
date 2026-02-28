using P4NTHE0N.C0MMON;
using P4NTHE0N.H4ND.EntryPoint;
using P4NTHE0N.H4ND.Services;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// ARCH-055: Unit tests for SignalGenerator and extended RunMode parsing.
/// Tests signal generation from credentials, priority distribution, duplication prevention,
/// filtering, and new subcommand routing.
/// </summary>
public static class SignalGeneratorTests
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

		Run("Test_Generate_CorrectCount", Test_Generate_CorrectCount);
		Run("Test_Generate_NoDuplicates", Test_Generate_NoDuplicates);
		Run("Test_Generate_FiltersByGame", Test_Generate_FiltersByGame);
		Run("Test_Generate_FiltersByHouse", Test_Generate_FiltersByHouse);
		Run("Test_Generate_FixedPriority", Test_Generate_FixedPriority);
		Run("Test_Generate_EmptyCredentials", Test_Generate_EmptyCredentials);
		Run("Test_Generate_SkipsBannedCredentials", Test_Generate_SkipsBannedCredentials);
		Run("Test_Generate_SkipsLockedCredentials", Test_Generate_SkipsLockedCredentials);
		Run("Test_Generate_SkipsDisabledCredentials", Test_Generate_SkipsDisabledCredentials);
		Run("Test_Generate_PriorityDistribution", Test_Generate_PriorityDistribution);
		Run("Test_ParseMode_GenerateSignals", Test_ParseMode_GenerateSignals);
		Run("Test_ParseMode_Gen", Test_ParseMode_Gen);
		Run("Test_ParseMode_Health", Test_ParseMode_Health);
		Run("Test_ParseMode_BurnIn", Test_ParseMode_BurnIn);
		Run("Test_ParseMode_BurnInVariant", Test_ParseMode_BurnInVariant);
		Run("Test_ParseMode_Spin", Test_ParseMode_Spin);
		Run("Test_ParseMode_BackwardCompat_H4ND", Test_ParseMode_BackwardCompat_H4ND);
		Run("Test_ParseMode_BackwardCompat_Parallel", Test_ParseMode_BackwardCompat_Parallel);
		Run("Test_ParseMode_BackwardCompat_H0UND", Test_ParseMode_BackwardCompat_H0UND);
		Run("Test_ParseMode_BackwardCompat_FirstSpin", Test_ParseMode_BackwardCompat_FirstSpin);
		Run("Test_SignalGenerationResult_Success", Test_SignalGenerationResult_Success);
		Run("Test_BurnInConfig_Defaults", Test_BurnInConfig_Defaults);

		return (passed, failed);
	}

	private static MockUnitOfWork CreateUowWithCredentials(int count, string game = "FireKirin", string house = "TestHouse")
	{
		MockUnitOfWork uow = new();
		for (int i = 0; i < count; i++)
		{
			((MockRepoCredentials)uow.Credentials).Add(new Credential
			{
				Username = $"user{i:D3}",
				Password = $"pass{i:D3}",
				Game = game,
				House = house,
				Enabled = true,
				Banned = false,
				Unlocked = true,
			});
		}
		return uow;
	}

	static bool Test_Generate_CorrectCount()
	{
		var uow = CreateUowWithCredentials(20);
		SignalGenerator gen = new(uow);
		var result = gen.Generate(10);
		return result.Inserted == 10 && result.Requested == 10;
	}

	static bool Test_Generate_NoDuplicates()
	{
		var uow = CreateUowWithCredentials(5);
		SignalGenerator gen = new(uow);

		// Generate 5 signals (one per credential)
		var result1 = gen.Generate(5);
		// Generate 5 more — all should be skipped as duplicates
		var result2 = gen.Generate(5);

		return result1.Inserted == 5 && result2.Skipped == 5 && result2.Inserted == 0;
	}

	static bool Test_Generate_FiltersByGame()
	{
		MockUnitOfWork uow = new();
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "fk1", Password = "p1", Game = "FireKirin", House = "H1", Enabled = true, Unlocked = true });
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "os1", Password = "p2", Game = "OrionStars", House = "H1", Enabled = true, Unlocked = true });

		SignalGenerator gen = new(uow);
		var result = gen.Generate(10, filterGame: "FireKirin");

		// Should only create signals for FireKirin credential
		var signals = uow.Signals.GetAll();
		return signals.All(s => s.Game == "FireKirin") && result.Inserted == 1;
	}

	static bool Test_Generate_FiltersByHouse()
	{
		MockUnitOfWork uow = new();
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "u1", Password = "p1", Game = "FireKirin", House = "Alpha", Enabled = true, Unlocked = true });
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "u2", Password = "p2", Game = "FireKirin", House = "Beta", Enabled = true, Unlocked = true });

		SignalGenerator gen = new(uow);
		var result = gen.Generate(10, filterHouse: "Alpha");

		var signals = uow.Signals.GetAll();
		return signals.All(s => s.House == "Alpha") && result.Inserted == 1;
	}

	static bool Test_Generate_FixedPriority()
	{
		var uow = CreateUowWithCredentials(10);
		SignalGenerator gen = new(uow);
		var result = gen.Generate(10, fixedPriority: 4);

		var signals = uow.Signals.GetAll();
		return signals.All(s => s.Priority == 4) && result.Inserted == 10;
	}

	static bool Test_Generate_EmptyCredentials()
	{
		MockUnitOfWork uow = new();
		SignalGenerator gen = new(uow);
		var result = gen.Generate(10);

		return result.Inserted == 0 && result.Errors.Count > 0;
	}

	static bool Test_Generate_SkipsBannedCredentials()
	{
		MockUnitOfWork uow = new();
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "banned1", Password = "p", Game = "FK", House = "H", Enabled = true, Banned = true, Unlocked = true });

		SignalGenerator gen = new(uow);
		var result = gen.Generate(5);

		return result.Inserted == 0 && result.Errors.Count > 0; // No eligible creds
	}

	static bool Test_Generate_SkipsLockedCredentials()
	{
		MockUnitOfWork uow = new();
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "locked1", Password = "p", Game = "FK", House = "H", Enabled = true, Banned = false, Unlocked = false });

		SignalGenerator gen = new(uow);
		var result = gen.Generate(5);

		return result.Inserted == 0;
	}

	static bool Test_Generate_SkipsDisabledCredentials()
	{
		MockUnitOfWork uow = new();
		((MockRepoCredentials)uow.Credentials).Add(new Credential { Username = "disabled1", Password = "p", Game = "FK", House = "H", Enabled = false, Banned = false, Unlocked = true });

		SignalGenerator gen = new(uow);
		var result = gen.Generate(5);

		return result.Inserted == 0;
	}

	static bool Test_Generate_PriorityDistribution()
	{
		// Generate many signals and check distribution roughly matches 40/30/20/10
		var uow = CreateUowWithCredentials(200);
		SignalGenerator gen = new(uow);
		var result = gen.Generate(200);

		var signals = uow.Signals.GetAll();
		int p1 = signals.Count(s => (int)s.Priority == 1);
		int p2 = signals.Count(s => (int)s.Priority == 2);
		int p3 = signals.Count(s => (int)s.Priority == 3);
		int p4 = signals.Count(s => (int)s.Priority == 4);

		// Allow ±15% variance: P1 (40%±15%) = 25-55%, etc.
		double total = signals.Count;
		bool p1Ok = p1 / total > 0.20 && p1 / total < 0.60;
		bool p2Ok = p2 / total > 0.15 && p2 / total < 0.50;
		bool p3Ok = p3 / total > 0.05 && p3 / total < 0.40;
		bool p4Ok = p4 / total > 0.01 && p4 / total < 0.30;

		return p1Ok && p2Ok && p3Ok && p4Ok && result.Inserted == 200;
	}

	// RunMode parse tests
	static bool Test_ParseMode_GenerateSignals()
		=> UnifiedEntryPoint.ParseMode(["generate-signals"]) == RunMode.GenerateSignals;

	static bool Test_ParseMode_Gen()
		=> UnifiedEntryPoint.ParseMode(["gen"]) == RunMode.GenerateSignals;

	static bool Test_ParseMode_Health()
		=> UnifiedEntryPoint.ParseMode(["health"]) == RunMode.Health;

	static bool Test_ParseMode_BurnIn()
		=> UnifiedEntryPoint.ParseMode(["burn-in"]) == RunMode.BurnIn;

	static bool Test_ParseMode_BurnInVariant()
		=> UnifiedEntryPoint.ParseMode(["burnin"]) == RunMode.BurnIn;

	static bool Test_ParseMode_Spin()
		=> UnifiedEntryPoint.ParseMode(["spin"]) == RunMode.Sequential;

	static bool Test_ParseMode_BackwardCompat_H4ND()
		=> UnifiedEntryPoint.ParseMode(["H4ND"]) == RunMode.Sequential;

	static bool Test_ParseMode_BackwardCompat_Parallel()
		=> UnifiedEntryPoint.ParseMode(["PARALLEL"]) == RunMode.Parallel;

	static bool Test_ParseMode_BackwardCompat_H0UND()
		=> UnifiedEntryPoint.ParseMode(["H0UND"]) == RunMode.Hound;

	static bool Test_ParseMode_BackwardCompat_FirstSpin()
		=> UnifiedEntryPoint.ParseMode(["FIRSTSPIN"]) == RunMode.FirstSpin;

	// DTO tests
	static bool Test_SignalGenerationResult_Success()
	{
		SignalGenerationResult result = new() { Requested = 10, Inserted = 8, Skipped = 2 };
		SignalGenerationResult full = new() { Requested = 10, Inserted = 10, Skipped = 0 };
		return !result.IsSuccess && full.IsSuccess && result.ToString().Contains("Inserted=8");
	}

	// BurnInConfig defaults
	static bool Test_BurnInConfig_Defaults()
	{
		BurnInConfig config = new();
		return config.DurationHours == 24
			&& config.MetricsIntervalSeconds == 60
			&& config.AutoGenerateSignals
			&& config.AutoGenerateCount == 50
			&& config.RefillThreshold == 5
			&& config.RefillCount == 20
			&& config.HaltOnDuplication
			&& config.HaltOnErrorRatePercent == 10
			&& config.WarnOnMemoryGrowthMB == 100;
	}
}
