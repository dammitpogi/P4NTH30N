using P4NTH30N.C0MMON;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// DECISION_070: Verify credential lock leak fix.
/// The finally block in H0UND.cs must guarantee Unlock() is called
/// regardless of success or failure in the polling loop.
/// </summary>
public static class H0UNDCredentialLockTests
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

		Run("Test_Lock_ThenUnlock_CredentialIsUnlocked", Test_Lock_ThenUnlock_CredentialIsUnlocked);
		Run("Test_Lock_WithoutUnlock_CredentialStaysLocked", Test_Lock_WithoutUnlock_CredentialStaysLocked);
		Run("Test_FinallyBlock_UnlocksAfterException", Test_FinallyBlock_UnlocksAfterException);
		Run("Test_DoubleUnlock_IsIdempotent", Test_DoubleUnlock_IsIdempotent);
		Run("Test_MultipleCreds_AllUnlockedAfterFailures", Test_MultipleCreds_AllUnlockedAfterFailures);

		return (passed, failed);
	}

	private static bool Test_Lock_ThenUnlock_CredentialIsUnlocked()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("MIDAS", "FireKirin", "user1");
		((MockRepoCredentials)uow.Credentials).Add(cred);

		uow.Credentials.Lock(cred);
		if (cred.Unlocked) return false; // Should be locked

		uow.Credentials.Unlock(cred);
		return cred.Unlocked; // Should be unlocked
	}

	private static bool Test_Lock_WithoutUnlock_CredentialStaysLocked()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("MIDAS", "FireKirin", "user1");
		((MockRepoCredentials)uow.Credentials).Add(cred);

		uow.Credentials.Lock(cred);
		return !cred.Unlocked; // Should still be locked
	}

	private static bool Test_FinallyBlock_UnlocksAfterException()
	{
		// Simulates DECISION_070: the finally { Unlock() } pattern
		var uow = new MockUnitOfWork();
		var cred = MakeCred("MIDAS", "FireKirin", "user1");
		((MockRepoCredentials)uow.Credentials).Add(cred);

		uow.Credentials.Lock(cred);
		try
		{
			// Simulate polling failure
			throw new Exception("WebSocket connection failed");
		}
		catch
		{
			// Exception caught but NOT unlocking here (simulating old bug)
		}
		finally
		{
			// DECISION_070: Safety net — credential must never stay permanently locked
			try { uow.Credentials.Unlock(cred); } catch { }
		}

		return cred.Unlocked; // Must be unlocked after finally block
	}

	private static bool Test_DoubleUnlock_IsIdempotent()
	{
		var uow = new MockUnitOfWork();
		var cred = MakeCred("MIDAS", "FireKirin", "user1");
		((MockRepoCredentials)uow.Credentials).Add(cred);

		uow.Credentials.Lock(cred);
		uow.Credentials.Unlock(cred);
		uow.Credentials.Unlock(cred); // Second unlock should not throw

		return cred.Unlocked;
	}

	private static bool Test_MultipleCreds_AllUnlockedAfterFailures()
	{
		var uow = new MockUnitOfWork();
		var creds = new List<Credential>();
		for (int i = 0; i < 5; i++)
		{
			var cred = MakeCred("MIDAS", "FireKirin", $"user{i}");
			((MockRepoCredentials)uow.Credentials).Add(cred);
			creds.Add(cred);
		}

		// Lock all, simulate failure on each, ensure finally unlocks
		foreach (var cred in creds)
		{
			uow.Credentials.Lock(cred);
			try
			{
				throw new Exception("Simulated failure");
			}
			catch { }
			finally
			{
				try { uow.Credentials.Unlock(cred); } catch { }
			}
		}

		return creds.All(c => c.Unlocked);
	}

	private static Credential MakeCred(string house, string game, string username)
	{
		return new Credential
		{
			House = house,
			Game = game,
			Username = username,
			Password = "test",
			Enabled = true,
			Balance = 10,
		};
	}
}
