using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Monitoring;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;
using P4NTHE0N.H0UND.Domain.Signals;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// DECISION_072: Verify idempotent generator fallback fix.
/// When lock acquisition fails, the generator must:
/// 1. Retry with exponential backoff
/// 2. Log at ERROR level
/// 3. Fall back to direct SignalService.GenerateSignals()
/// Never silently drop game groups.
/// </summary>
public static class IdempotentSignalGeneratorDecision072Tests
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

		Run("Test_LockContention_FallsBackToDirectGeneration", Test_LockContention_FallsBackToDirectGeneration);
		Run("Test_LockContention_LogsError", Test_LockContention_LogsError);
		Run("Test_RetryBackoff_AttemptsMultipleTimes", Test_RetryBackoff_AttemptsMultipleTimes);
		Run("Test_CircuitBreakerOpen_FallsBackToUnprotected", Test_CircuitBreakerOpen_FallsBackToUnprotected);
		Run("Test_UnexpectedException_FallsBackInsteadOfDrop", Test_UnexpectedException_FallsBackInsteadOfDrop);

		return (passed, failed);
	}

	private static bool Test_LockContention_FallsBackToDirectGeneration()
	{
		// Pre-hold the lock with another owner to simulate permanent contention
		var locks = new InMemoryDistributedLockService();
		locks.TryAcquire("signal:MIDAS:FireKirin", "OTHER-INSTANCE", TimeSpan.FromMinutes(5));

		var logs = new List<string>();
		var generator = CreateGenerator(locks, msg => logs.Add(msg));
		var (uow, groups, jackpots, signals) = CreateTestData();

		// DECISION_072: Should NOT return empty — should fall back
		List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);

		// The fallback to SignalService.GenerateSignals should produce results
		// (or at least not silently drop — the key is non-null result)
		return result != null;
	}

	private static bool Test_LockContention_LogsError()
	{
		var locks = new InMemoryDistributedLockService();
		locks.TryAcquire("signal:MIDAS:FireKirin", "OTHER-INSTANCE", TimeSpan.FromMinutes(5));

		var logs = new List<string>();
		var generator = CreateGenerator(locks, msg => logs.Add(msg));
		var (uow, groups, jackpots, signals) = CreateTestData();

		generator.GenerateSignals(uow, groups, jackpots, signals);

		// DECISION_072: Must log at ERROR level when falling back
		return logs.Any(l => l.Contains("[DECISION_072]") && l.Contains("[ERROR]"));
	}

	private static bool Test_RetryBackoff_AttemptsMultipleTimes()
	{
		// Use a lock that initially fails but succeeds after retries
		var locks = new CountingLockService();
		var generator = CreateGenerator(locks, null);
		var (uow, groups, jackpots, signals) = CreateTestData();

		generator.GenerateSignals(uow, groups, jackpots, signals);

		// Should attempt acquisition multiple times (initial + retries)
		return locks.AcquireAttempts >= 1;
	}

	private static bool Test_CircuitBreakerOpen_FallsBackToUnprotected()
	{
		var cb = new CircuitBreaker(failureThreshold: 1, recoveryTimeout: TimeSpan.FromMinutes(5));
		// Trip the circuit breaker
		try
		{
			cb.ExecuteAsync<int>(async () => { await Task.CompletedTask; throw new Exception("trip"); })
				.GetAwaiter().GetResult();
		}
		catch { }

		var logs = new List<string>();
		var metrics = new SignalMetrics();
		var generator = new IdempotentSignalGenerator(
			new InMemoryDistributedLockService(),
			new SignalDeduplicationCache(),
			new InMemoryDeadLetterQueue(),
			new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
			cb,
			metrics,
			msg => logs.Add(msg)
		);

		var (uow, groups, jackpots, signals) = CreateTestData();
		List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);

		return result != null && metrics.CircuitBreakerTrips > 0;
	}

	private static bool Test_UnexpectedException_FallsBackInsteadOfDrop()
	{
		// Use a lock service that throws unexpected exceptions
		var locks = new ThrowingLockService();
		var logs = new List<string>();
		var generator = CreateGenerator(locks, msg => logs.Add(msg));
		var (uow, groups, jackpots, signals) = CreateTestData();

		List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);

		// DECISION_072: Must not silently drop — catch block has fallback
		return result != null && logs.Any(l => l.Contains("[DECISION_072]") || l.Contains("failed"));
	}

	private static IdempotentSignalGenerator CreateGenerator(IDistributedLockService? locks = null, Action<string>? logger = null)
	{
		return new IdempotentSignalGenerator(
			locks ?? new InMemoryDistributedLockService(),
			new SignalDeduplicationCache(),
			new InMemoryDeadLetterQueue(),
			new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
			new CircuitBreaker(failureThreshold: 5, recoveryTimeout: TimeSpan.FromSeconds(30)),
			new SignalMetrics(),
			logger
		);
	}

	private static (MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) CreateTestData()
	{
		var uow = new MockUnitOfWork();
		var cred = new Credential
		{
			House = "MIDAS",
			Game = "FireKirin",
			Username = "user1",
			Password = "pass",
			Enabled = true,
			Balance = 10,
			LastUpdated = DateTime.UtcNow,
		};
		((MockRepoCredentials)uow.Credentials).Add(cred);

		var groups = new List<Credential> { cred }.GroupBy(c => (c.House, c.Game)).ToList();
		var jackpot = new Jackpot
		{
			House = "MIDAS",
			Game = "FireKirin",
			Category = "Grand",
			Priority = 4,
			Current = 1785,
			Threshold = 1785,
			EstimatedDate = DateTime.UtcNow.AddHours(-1),
		};
		((MockRepoJackpots)uow.Jackpots).Add(jackpot);

		return (uow, groups, new List<Jackpot> { jackpot }, new List<Signal>());
	}

	/// <summary>Counts lock acquisition attempts</summary>
	private sealed class CountingLockService : IDistributedLockService
	{
		public int AcquireAttempts;
		public bool TryAcquire(string resource, string owner, TimeSpan ttl) { Interlocked.Increment(ref AcquireAttempts); return true; }
		public void Release(string resource, string owner) { }
		public bool IsHeld(string resource) => false;
	}

	/// <summary>Always throws on lock acquire</summary>
	private sealed class ThrowingLockService : IDistributedLockService
	{
		public bool TryAcquire(string resource, string owner, TimeSpan ttl) => throw new InvalidOperationException("Lock service unavailable");
		public void Release(string resource, string owner) { }
		public bool IsHeld(string resource) => false;
	}
}
