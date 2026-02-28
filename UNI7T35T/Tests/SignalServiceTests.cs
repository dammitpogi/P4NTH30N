using System;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Signals;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

public static class SignalServiceTests
{
	private static int _passed;
	private static int _failed;

	public static (int passed, int failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Console.WriteLine("\n=== SignalService Generation Tests (PROD-003) ===\n");

		// Signal generation logic
		Test_GenerateSignals_DueJackpot_ProducesSignals();
		Test_GenerateSignals_NotDue_ProducesNoSignals();
		Test_GenerateSignals_DisabledCredentials_Excluded();
		Test_GenerateSignals_BannedCredentials_Excluded();
		Test_GenerateSignals_CashedOutCredentials_Excluded();
		Test_GenerateSignals_LowBalance_NotQualified();
		Test_GenerateSignals_MultipleGames_IndependentSignals();

		// UpsertSignalIfHigherPriority
		Test_Upsert_NewSignal_Inserted();
		Test_Upsert_HigherPriority_Replaces();
		Test_Upsert_LowerPriority_Ignored();
		Test_Upsert_PreservesAcknowledgedState();

		// CleanupStaleSignals
		Test_Cleanup_RemovesStale();
		Test_Cleanup_KeepsQualified();

		Console.WriteLine($"\n=== SignalService Results: {_passed} passed, {_failed} failed ===\n");
		return (_passed, _failed);
	}

	// ── Signal Generation Tests ─────────────────────────────────────────

	private static void Test_GenerateSignals_DueJackpot_ProducesSignals()
	{
		try
		{
			MockUnitOfWork uow = new();
			(List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots) = CreateDueScenario(uow);
			List<Signal> existing = new();

			List<Signal> result = SignalService.GenerateSignals(uow, groups, jackpots, existing);

			Assert(result.Count > 0, $"Should produce signals for due jackpot, got {result.Count}");
			Assert(result.All(s => s.House == "MIDAS"), "All signals should have correct House");
			Assert(result.All(s => s.Game == "FireKirin"), "All signals should have correct Game");
			Assert(result.All(s => s.Priority == 4), "All signals should inherit jackpot priority");
			Pass("GenerateSignals_DueJackpot_ProducesSignals");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_DueJackpot_ProducesSignals", ex);
		}
	}

	private static void Test_GenerateSignals_NotDue_ProducesNoSignals()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateCred("MIDAS", "FireKirin", "user1", 10);
			((MockRepoCredentials)uow.Credentials).Add(cred);

			List<Credential> creds = new() { cred };
			List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

			// Jackpot is far in the future and not at threshold
			Jackpot jackpot = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Category = "Grand",
				Priority = 4,
				Current = 500,
				Threshold = 1785,
				EstimatedDate = DateTime.UtcNow.AddDays(30),
			};
			List<Jackpot> jackpots = new() { jackpot };

			List<Signal> result = SignalService.GenerateSignals(uow, groups, jackpots, new List<Signal>());
			Assert(result.Count == 0, $"Should produce no signals for non-due jackpot, got {result.Count}");
			Pass("GenerateSignals_NotDue_ProducesNoSignals");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_NotDue_ProducesNoSignals", ex);
		}
	}

	private static void Test_GenerateSignals_DisabledCredentials_Excluded()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential enabled = CreateCred("MIDAS", "FireKirin", "enabled_user", 10);
			Credential disabled = CreateCred("MIDAS", "FireKirin", "disabled_user", 10);
			disabled.Enabled = false;

			((MockRepoCredentials)uow.Credentials).Add(enabled);
			((MockRepoCredentials)uow.Credentials).Add(disabled);

			List<Credential> creds = new() { enabled, disabled };
			List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

			Jackpot jackpot = CreateDueJackpot("MIDAS", "FireKirin");
			List<Signal> result = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());

			Assert(!result.Any(s => s.Username == "disabled_user"), "Disabled credential should not get a signal");
			Pass("GenerateSignals_DisabledCredentials_Excluded");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_DisabledCredentials_Excluded", ex);
		}
	}

	private static void Test_GenerateSignals_BannedCredentials_Excluded()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential normal = CreateCred("MIDAS", "FireKirin", "normal", 10);
			Credential banned = CreateCred("MIDAS", "FireKirin", "banned", 10);
			banned.Banned = true;

			((MockRepoCredentials)uow.Credentials).Add(normal);
			((MockRepoCredentials)uow.Credentials).Add(banned);

			List<Credential> creds = new() { normal, banned };
			List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

			Jackpot jackpot = CreateDueJackpot("MIDAS", "FireKirin");
			List<Signal> result = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());

			Assert(!result.Any(s => s.Username == "banned"), "Banned credential should not get a signal");
			Pass("GenerateSignals_BannedCredentials_Excluded");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_BannedCredentials_Excluded", ex);
		}
	}

	private static void Test_GenerateSignals_CashedOutCredentials_Excluded()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential active = CreateCred("MIDAS", "FireKirin", "active", 10);
			Credential cashedOut = CreateCred("MIDAS", "FireKirin", "cashedout", 10);
			cashedOut.CashedOut = true;

			((MockRepoCredentials)uow.Credentials).Add(active);
			((MockRepoCredentials)uow.Credentials).Add(cashedOut);

			List<Credential> creds = new() { active, cashedOut };
			List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

			Jackpot jackpot = CreateDueJackpot("MIDAS", "FireKirin");
			List<Signal> result = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());

			Assert(!result.Any(s => s.Username == "cashedout"), "CashedOut credential should not get a signal");
			Pass("GenerateSignals_CashedOutCredentials_Excluded");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_CashedOutCredentials_Excluded", ex);
		}
	}

	private static void Test_GenerateSignals_LowBalance_NotQualified()
	{
		try
		{
			MockUnitOfWork uow = new();
			// All creds have balance < 4, and jackpot priority >= 2 with ETA in 5 hours
			// The 6h window requires avgBalance >= 6, 4h requires >= 4
			// So with balance 2 and ETA 5h out, none of those windows match
			Credential cred = CreateCred("MIDAS", "FireKirin", "broke", 2);
			((MockRepoCredentials)uow.Credentials).Add(cred);

			List<Credential> creds = new() { cred };
			List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

			// Due jackpot with threshold met, but ETA ~5 hours from now
			Jackpot jackpot = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Category = "Grand",
				Priority = 4,
				Current = 1785,
				Threshold = 1785,
				EstimatedDate = DateTime.UtcNow.AddHours(5),
			};

			List<Signal> result = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());
			Assert(result.Count == 0, $"Low balance should not qualify for 6h window, got {result.Count}");
			Pass("GenerateSignals_LowBalance_NotQualified");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_LowBalance_NotQualified", ex);
		}
	}

	private static void Test_GenerateSignals_MultipleGames_IndependentSignals()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred1 = CreateCred("MIDAS", "FireKirin", "user1", 10);
			Credential cred2 = CreateCred("MIDAS", "OrionStars", "user2", 10);

			((MockRepoCredentials)uow.Credentials).Add(cred1);
			((MockRepoCredentials)uow.Credentials).Add(cred2);

			List<Credential> creds = new() { cred1, cred2 };
			List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

			Jackpot j1 = CreateDueJackpot("MIDAS", "FireKirin");
			Jackpot j2 = CreateDueJackpot("MIDAS", "OrionStars");

			List<Signal> result = SignalService.GenerateSignals(uow, groups, new List<Jackpot> { j1, j2 }, new List<Signal>());

			bool hasFireKirin = result.Any(s => s.Game == "FireKirin");
			bool hasOrionStars = result.Any(s => s.Game == "OrionStars");
			Assert(hasFireKirin, "Should have signal for FireKirin");
			Assert(hasOrionStars, "Should have signal for OrionStars");
			Pass("GenerateSignals_MultipleGames_IndependentSignals");
		}
		catch (Exception ex)
		{
			Fail("GenerateSignals_MultipleGames_IndependentSignals", ex);
		}
	}

	// ── UpsertSignalIfHigherPriority Tests ──────────────────────────────

	private static void Test_Upsert_NewSignal_Inserted()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateCred("MIDAS", "FireKirin", "user1", 10);
			Signal sig = new Signal(4, cred);
			List<Signal> existing = new();

			SignalService.UpsertSignalIfHigherPriority(uow, existing, sig, cred);

			Assert(uow.Signals.GetAll().Count == 1, "New signal should be inserted");
			Pass("Upsert_NewSignal_Inserted");
		}
		catch (Exception ex)
		{
			Fail("Upsert_NewSignal_Inserted", ex);
		}
	}

	private static void Test_Upsert_HigherPriority_Replaces()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateCred("MIDAS", "FireKirin", "user1", 10);
			Signal low = new Signal(2, cred);
			Signal high = new Signal(4, cred);

			List<Signal> existing = new() { low };

			SignalService.UpsertSignalIfHigherPriority(uow, existing, high, cred);

			List<Signal> all = uow.Signals.GetAll();
			Assert(all.Count == 1, "Should have upserted");
			Assert(all[0].Priority == 4, $"Priority should be 4, got {all[0].Priority}");
			Pass("Upsert_HigherPriority_Replaces");
		}
		catch (Exception ex)
		{
			Fail("Upsert_HigherPriority_Replaces", ex);
		}
	}

	private static void Test_Upsert_LowerPriority_Ignored()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateCred("MIDAS", "FireKirin", "user1", 10);
			Signal high = new Signal(4, cred);
			Signal low = new Signal(2, cred);

			List<Signal> existing = new() { high };

			SignalService.UpsertSignalIfHigherPriority(uow, existing, low, cred);

			List<Signal> all = uow.Signals.GetAll();
			Assert(all.Count == 0, "Lower priority should not be upserted when higher exists");
			Pass("Upsert_LowerPriority_Ignored");
		}
		catch (Exception ex)
		{
			Fail("Upsert_LowerPriority_Ignored", ex);
		}
	}

	private static void Test_Upsert_PreservesAcknowledgedState()
	{
		try
		{
			MockUnitOfWork uow = new();
			Credential cred = CreateCred("MIDAS", "FireKirin", "user1", 10);
			Signal existing = new Signal(2, cred) { Acknowledged = true };
			Signal higher = new Signal(4, cred);

			List<Signal> existingList = new() { existing };
			SignalService.UpsertSignalIfHigherPriority(uow, existingList, higher, cred);

			List<Signal> all = uow.Signals.GetAll();
			Assert(all.Count == 1, "Should upsert");
			Assert(all[0].Acknowledged, "Should preserve Acknowledged=true from existing signal");
			Pass("Upsert_PreservesAcknowledgedState");
		}
		catch (Exception ex)
		{
			Fail("Upsert_PreservesAcknowledgedState", ex);
		}
	}

	// ── CleanupStaleSignals Tests ───────────────────────────────────────

	private static void Test_Cleanup_RemovesStale()
	{
		try
		{
			MockUnitOfWork uow = new();
			Signal stale = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Username = "stale_user",
			};
			((MockRepoSignals)uow.Signals).Add(stale);

			List<Signal> allSignals = new() { stale };
			List<Signal> qualified = new(); // empty — no qualified signals

			SignalService.CleanupStaleSignals(uow, allSignals, qualified);

			Assert(uow.Signals.GetAll().Count == 0, "Stale signal should be removed");
			Pass("Cleanup_RemovesStale");
		}
		catch (Exception ex)
		{
			Fail("Cleanup_RemovesStale", ex);
		}
	}

	private static void Test_Cleanup_KeepsQualified()
	{
		try
		{
			MockUnitOfWork uow = new();
			Signal active = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Username = "active_user",
			};
			((MockRepoSignals)uow.Signals).Add(active);

			List<Signal> allSignals = new() { active };
			List<Signal> qualified = new()
			{
				new Signal
				{
					House = "MIDAS",
					Game = "FireKirin",
					Username = "active_user",
				},
			};

			SignalService.CleanupStaleSignals(uow, allSignals, qualified);

			Assert(uow.Signals.GetAll().Count == 1, "Active signal should be kept");
			Pass("Cleanup_KeepsQualified");
		}
		catch (Exception ex)
		{
			Fail("Cleanup_KeepsQualified", ex);
		}
	}

	// ── Helpers ──────────────────────────────────────────────────────────

	private static Credential CreateCred(string house, string game, string username, double balance)
	{
		return new Credential()
		{
			House = house,
			Game = game,
			Username = username,
			Password = "pass",
			Enabled = true,
			Banned = false,
			CashedOut = false,
			Balance = balance,
			LastUpdated = DateTime.UtcNow,
		};
	}

	private static Jackpot CreateDueJackpot(string house, string game)
	{
		return new Jackpot()
		{
			House = house,
			Game = game,
			Category = "Grand",
			Priority = 4,
			Current = 1785,
			Threshold = 1785,
			EstimatedDate = DateTime.UtcNow.AddHours(-1), // past due
		};
	}

	private static (List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots) CreateDueScenario(MockUnitOfWork uow)
	{
		Credential cred1 = CreateCred("MIDAS", "FireKirin", "user1", 10);
		Credential cred2 = CreateCred("MIDAS", "FireKirin", "user2", 15);

		((MockRepoCredentials)uow.Credentials).Add(cred1);
		((MockRepoCredentials)uow.Credentials).Add(cred2);

		List<Credential> creds = new() { cred1, cred2 };
		List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

		Jackpot jackpot = CreateDueJackpot("MIDAS", "FireKirin");
		((MockRepoJackpots)uow.Jackpots).Add(jackpot);

		return (groups, new List<Jackpot> { jackpot });
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
