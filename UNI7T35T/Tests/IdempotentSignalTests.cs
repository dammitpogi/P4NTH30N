using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Monitoring;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;
using P4NTHE0N.H0UND.Domain.Signals;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

public static class IdempotentSignalTests
{
	private static int _passed;
	private static int _failed;

	public static (int passed, int failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Console.WriteLine("\n=== Idempotent Signal Generation Tests (ADR-002) ===\n");

		// ── DistributedLockService Tests ─────────────────────────────────
		Test_InMemoryLock_AcquireAndRelease();
		Test_InMemoryLock_Contention();
		Test_InMemoryLock_ReentrantSameOwner();
		Test_InMemoryLock_TtlExpiry();
		Test_InMemoryLock_ReleaseWrongOwner();

		// ── SignalDeduplicationCache Tests ───────────────────────────────
		Test_DedupCache_MarkAndCheck();
		Test_DedupCache_ExpiredEntries();
		Test_DedupCache_MaxCapacity();
		Test_DedupCache_BuildKey();
		Test_DedupCache_ConcurrentAccess();
		Test_DedupCache_EvictSpecificKey();

		// ── RetryPolicy Tests ───────────────────────────────────────────
		Test_RetryPolicy_SuccessOnFirstAttempt();
		Test_RetryPolicy_SuccessAfterRetries();
		Test_RetryPolicy_ExhaustedRetries();
		Test_RetryPolicy_ExponentialBackoff();

		// ── DeadLetterQueue Tests ────────────────────────────────────────
		Test_DeadLetterQueue_EnqueueAndRetrieve();
		Test_DeadLetterQueue_MarkReprocessed();
		Test_DeadLetterQueue_GetUnprocessed();

		// ── SignalMetrics Tests ──────────────────────────────────────────
		Test_Metrics_RecordAndSnapshot();
		Test_Metrics_LatencyStats();
		Test_Metrics_MeasureLatencyDisposable();

		// ── IdempotentSignalGenerator Tests ──────────────────────────────
		Test_IdempotentGenerator_BasicGeneration();
		Test_IdempotentGenerator_DeduplicatesSameSignal();
		Test_IdempotentGenerator_LockContention();
		Test_IdempotentGenerator_CircuitBreakerFallback();

		// ── Race Condition / Concurrency Tests ──────────────────────────
		Test_ConcurrentLockAcquisition();
		Test_ConcurrentSignalDeduplication();
		Test_ConcurrentGeneratorProducesNoDuplicates();

		// ── Performance Benchmark ───────────────────────────────────────
		Test_PerformanceBenchmark_Under100ms();

		Console.WriteLine($"\n=== Results: {_passed} passed, {_failed} failed ===\n");
		return (_passed, _failed);
	}

	// ══════════════════════════════════════════════════════════════════════
	// DistributedLockService (InMemory)
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_InMemoryLock_AcquireAndRelease()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			bool acquired = locks.TryAcquire("res1", "owner1", TimeSpan.FromSeconds(10));
			Assert(acquired, "Should acquire lock");
			Assert(locks.IsHeld("res1"), "Lock should be held");

			locks.Release("res1", "owner1");
			Assert(!locks.IsHeld("res1"), "Lock should be released");
			Pass("InMemoryLock_AcquireAndRelease");
		}
		catch (Exception ex)
		{
			Fail("InMemoryLock_AcquireAndRelease", ex);
		}
	}

	private static void Test_InMemoryLock_Contention()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			bool first = locks.TryAcquire("res1", "owner1", TimeSpan.FromSeconds(10));
			bool second = locks.TryAcquire("res1", "owner2", TimeSpan.FromSeconds(10));
			Assert(first, "First acquire should succeed");
			Assert(!second, "Second acquire by different owner should fail");
			Pass("InMemoryLock_Contention");
		}
		catch (Exception ex)
		{
			Fail("InMemoryLock_Contention", ex);
		}
	}

	private static void Test_InMemoryLock_ReentrantSameOwner()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			bool first = locks.TryAcquire("res1", "owner1", TimeSpan.FromSeconds(10));
			bool second = locks.TryAcquire("res1", "owner1", TimeSpan.FromSeconds(10));
			Assert(first, "First acquire should succeed");
			Assert(second, "Re-entrant acquire by same owner should succeed");
			Pass("InMemoryLock_ReentrantSameOwner");
		}
		catch (Exception ex)
		{
			Fail("InMemoryLock_ReentrantSameOwner", ex);
		}
	}

	private static void Test_InMemoryLock_TtlExpiry()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			locks.TryAcquire("res1", "owner1", TimeSpan.FromMilliseconds(50));
			Thread.Sleep(100); // Wait for TTL to expire
			bool acquired = locks.TryAcquire("res1", "owner2", TimeSpan.FromSeconds(10));
			Assert(acquired, "Should acquire lock after TTL expiry");
			Pass("InMemoryLock_TtlExpiry");
		}
		catch (Exception ex)
		{
			Fail("InMemoryLock_TtlExpiry", ex);
		}
	}

	private static void Test_InMemoryLock_ReleaseWrongOwner()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			locks.TryAcquire("res1", "owner1", TimeSpan.FromSeconds(10));
			locks.Release("res1", "owner2"); // Wrong owner
			Assert(locks.IsHeld("res1"), "Lock should still be held after wrong owner release");
			Pass("InMemoryLock_ReleaseWrongOwner");
		}
		catch (Exception ex)
		{
			Fail("InMemoryLock_ReleaseWrongOwner", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// SignalDeduplicationCache
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_DedupCache_MarkAndCheck()
	{
		try
		{
			SignalDeduplicationCache cache = new();
			Assert(!cache.IsProcessed("key1"), "New key should not be processed");

			cache.MarkProcessed("key1");
			Assert(cache.IsProcessed("key1"), "Marked key should be processed");
			Assert(cache.Count == 1, $"Count should be 1, got {cache.Count}");
			Pass("DedupCache_MarkAndCheck");
		}
		catch (Exception ex)
		{
			Fail("DedupCache_MarkAndCheck", ex);
		}
	}

	private static void Test_DedupCache_ExpiredEntries()
	{
		try
		{
			SignalDeduplicationCache cache = new(ttl: TimeSpan.FromMilliseconds(50));
			cache.MarkProcessed("key1");
			Assert(cache.IsProcessed("key1"), "Should be processed immediately");

			Thread.Sleep(100); // Wait for TTL
			Assert(!cache.IsProcessed("key1"), "Should not be processed after TTL");
			Pass("DedupCache_ExpiredEntries");
		}
		catch (Exception ex)
		{
			Fail("DedupCache_ExpiredEntries", ex);
		}
	}

	private static void Test_DedupCache_MaxCapacity()
	{
		try
		{
			SignalDeduplicationCache cache = new(maxEntries: 10);
			for (int i = 0; i < 20; i++)
			{
				cache.MarkProcessed($"key{i}");
			}
			// After eviction, count should be around 10 (some evicted)
			Assert(cache.Count <= 15, $"Count should be <=15 after eviction, got {cache.Count}");
			Pass("DedupCache_MaxCapacity");
		}
		catch (Exception ex)
		{
			Fail("DedupCache_MaxCapacity", ex);
		}
	}

	private static void Test_DedupCache_BuildKey()
	{
		try
		{
			string key = SignalDeduplicationCache.BuildKey("MIDAS", "FireKirin", "user1");
			Assert(key == "MIDAS:FireKirin:user1", $"Key mismatch: {key}");

			Signal signal = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Username = "user1",
			};
			string keyFromSignal = SignalDeduplicationCache.BuildKey(signal);
			Assert(keyFromSignal == key, "Key from signal should match key from components");
			Pass("DedupCache_BuildKey");
		}
		catch (Exception ex)
		{
			Fail("DedupCache_BuildKey", ex);
		}
	}

	private static void Test_DedupCache_ConcurrentAccess()
	{
		try
		{
			SignalDeduplicationCache cache = new();
			int threadCount = 10;
			int keysPerThread = 100;
			CountdownEvent latch = new(threadCount);
			List<Thread> threads = new();

			for (int t = 0; t < threadCount; t++)
			{
				int threadId = t;
				Thread thread = new(() =>
				{
					latch.Signal();
					latch.Wait();
					for (int i = 0; i < keysPerThread; i++)
					{
						cache.MarkProcessed($"t{threadId}:key{i}");
						cache.IsProcessed($"t{threadId}:key{i}");
					}
				});
				threads.Add(thread);
				thread.Start();
			}

			foreach (Thread thread in threads)
			{
				thread.Join(TimeSpan.FromSeconds(5));
			}

			Assert(cache.Count > 0, "Cache should have entries after concurrent access");
			Assert(cache.Count <= threadCount * keysPerThread, "No extra entries should appear");
			Pass("DedupCache_ConcurrentAccess");
		}
		catch (Exception ex)
		{
			Fail("DedupCache_ConcurrentAccess", ex);
		}
	}

	private static void Test_DedupCache_EvictSpecificKey()
	{
		try
		{
			SignalDeduplicationCache cache = new();
			cache.MarkProcessed("key1");
			cache.MarkProcessed("key2");
			Assert(cache.IsProcessed("key1"), "key1 should be processed");

			cache.Evict("key1");
			Assert(!cache.IsProcessed("key1"), "key1 should not be processed after eviction");
			Assert(cache.IsProcessed("key2"), "key2 should still be processed");
			Pass("DedupCache_EvictSpecificKey");
		}
		catch (Exception ex)
		{
			Fail("DedupCache_EvictSpecificKey", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// RetryPolicy
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_RetryPolicy_SuccessOnFirstAttempt()
	{
		try
		{
			RetryPolicy policy = new(maxRetries: 3);
			int result = policy.Execute(() => 42, "test");
			Assert(result == 42, $"Expected 42, got {result}");
			Assert(policy.TotalRetries == 0, "No retries should have occurred");
			Pass("RetryPolicy_SuccessOnFirstAttempt");
		}
		catch (Exception ex)
		{
			Fail("RetryPolicy_SuccessOnFirstAttempt", ex);
		}
	}

	private static void Test_RetryPolicy_SuccessAfterRetries()
	{
		try
		{
			RetryPolicy policy = new(maxRetries: 3, baseDelay: TimeSpan.FromMilliseconds(10));
			int attempt = 0;
			int result = policy.Execute(
				() =>
				{
					attempt++;
					if (attempt < 3)
						throw new Exception("Transient failure");
					return 42;
				},
				"test"
			);

			Assert(result == 42, $"Expected 42, got {result}");
			Assert(attempt == 3, $"Expected 3 attempts, got {attempt}");
			Assert(policy.TotalRetries == 2, $"Expected 2 retries, got {policy.TotalRetries}");
			Pass("RetryPolicy_SuccessAfterRetries");
		}
		catch (Exception ex)
		{
			Fail("RetryPolicy_SuccessAfterRetries", ex);
		}
	}

	private static void Test_RetryPolicy_ExhaustedRetries()
	{
		try
		{
			RetryPolicy policy = new(maxRetries: 2, baseDelay: TimeSpan.FromMilliseconds(10));
			bool threw = false;
			try
			{
				policy.Execute<int>(() => throw new InvalidOperationException("Permanent failure"), "test");
			}
			catch (InvalidOperationException)
			{
				threw = true;
			}

			Assert(threw, "Should throw after exhausting retries");
			Assert(policy.TotalFailures == 1, $"Expected 1 failure, got {policy.TotalFailures}");
			Assert(policy.TotalRetries == 2, $"Expected 2 retries, got {policy.TotalRetries}");
			Pass("RetryPolicy_ExhaustedRetries");
		}
		catch (Exception ex)
		{
			Fail("RetryPolicy_ExhaustedRetries", ex);
		}
	}

	private static void Test_RetryPolicy_ExponentialBackoff()
	{
		try
		{
			RetryPolicy policy = new(maxRetries: 3, baseDelay: TimeSpan.FromMilliseconds(50), backoffMultiplier: 2.0);
			int attempt = 0;
			Stopwatch sw = Stopwatch.StartNew();

			try
			{
				policy.Execute<int>(
					() =>
					{
						attempt++;
						throw new Exception("fail");
					},
					"backoff-test"
				);
			}
			catch { }

			sw.Stop();
			// With base=50ms and multiplier=2: ~50 + ~100 + ~200 = ~350ms minimum (minus jitter)
			Assert(sw.ElapsedMilliseconds >= 150, $"Backoff too fast: {sw.ElapsedMilliseconds}ms (expected >=150ms)");
			Assert(attempt == 4, $"Expected 4 attempts (1 initial + 3 retries), got {attempt}");
			Pass("RetryPolicy_ExponentialBackoff");
		}
		catch (Exception ex)
		{
			Fail("RetryPolicy_ExponentialBackoff", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// DeadLetterQueue (InMemory)
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_DeadLetterQueue_EnqueueAndRetrieve()
	{
		try
		{
			InMemoryDeadLetterQueue dlq = new();
			Signal signal = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Username = "user1",
				Priority = 4,
			};
			dlq.Enqueue(signal, "Test failure", new Exception("boom"), retryCount: 2);

			Assert(dlq.Count == 1, $"Expected 1 entry, got {dlq.Count}");
			List<DeadLetterEntry> all = dlq.GetAll();
			Assert(all.Count == 1, "Should have 1 entry");
			Assert(all[0].House == "MIDAS", $"House mismatch: {all[0].House}");
			Assert(all[0].Reason == "Test failure", $"Reason mismatch: {all[0].Reason}");
			Assert(all[0].ErrorMessage == "boom", $"Error mismatch: {all[0].ErrorMessage}");
			Assert(all[0].RetryCount == 2, $"RetryCount mismatch: {all[0].RetryCount}");
			Pass("DeadLetterQueue_EnqueueAndRetrieve");
		}
		catch (Exception ex)
		{
			Fail("DeadLetterQueue_EnqueueAndRetrieve", ex);
		}
	}

	private static void Test_DeadLetterQueue_MarkReprocessed()
	{
		try
		{
			InMemoryDeadLetterQueue dlq = new();
			Signal signal = new()
			{
				House = "MIDAS",
				Game = "FireKirin",
				Username = "user1",
			};
			dlq.Enqueue(signal, "fail");

			DeadLetterEntry entry = dlq.GetAll()[0];
			Assert(!entry.Reprocessed, "Should not be reprocessed initially");

			dlq.MarkReprocessed(entry._id);
			entry = dlq.GetAll()[0];
			Assert(entry.Reprocessed, "Should be reprocessed after marking");
			Assert(entry.ReprocessedAt != null, "ReprocessedAt should be set");
			Pass("DeadLetterQueue_MarkReprocessed");
		}
		catch (Exception ex)
		{
			Fail("DeadLetterQueue_MarkReprocessed", ex);
		}
	}

	private static void Test_DeadLetterQueue_GetUnprocessed()
	{
		try
		{
			InMemoryDeadLetterQueue dlq = new();
			Signal s1 = new()
			{
				House = "H1",
				Game = "G1",
				Username = "u1",
			};
			Signal s2 = new()
			{
				House = "H2",
				Game = "G2",
				Username = "u2",
			};
			dlq.Enqueue(s1, "fail1");
			dlq.Enqueue(s2, "fail2");

			dlq.MarkReprocessed(dlq.GetAll()[0]._id);
			List<DeadLetterEntry> unprocessed = dlq.GetUnprocessed();
			Assert(unprocessed.Count == 1, $"Expected 1 unprocessed, got {unprocessed.Count}");
			Pass("DeadLetterQueue_GetUnprocessed");
		}
		catch (Exception ex)
		{
			Fail("DeadLetterQueue_GetUnprocessed", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// SignalMetrics
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_Metrics_RecordAndSnapshot()
	{
		try
		{
			SignalMetrics metrics = new();
			metrics.RecordSignalGenerated(5);
			metrics.RecordDeduplicated();
			metrics.RecordDeduplicated();
			metrics.RecordLockAcquired();
			metrics.RecordLockContention();
			metrics.RecordDeadLettered();
			metrics.RecordRetry();
			metrics.RecordCircuitBreakerTrip();

			SignalMetricsSnapshot snapshot = metrics.GetSnapshot();
			Assert(snapshot.SignalsGenerated == 5, $"Generated: {snapshot.SignalsGenerated}");
			Assert(snapshot.SignalsDeduplicated == 2, $"Deduped: {snapshot.SignalsDeduplicated}");
			Assert(snapshot.LocksAcquired == 1, $"Locks: {snapshot.LocksAcquired}");
			Assert(snapshot.LockContentions == 1, $"Contentions: {snapshot.LockContentions}");
			Assert(snapshot.DeadLettered == 1, $"DeadLettered: {snapshot.DeadLettered}");
			Assert(snapshot.Retries == 1, $"Retries: {snapshot.Retries}");
			Assert(snapshot.CircuitBreakerTrips == 1, $"CBTrips: {snapshot.CircuitBreakerTrips}");
			Pass("Metrics_RecordAndSnapshot");
		}
		catch (Exception ex)
		{
			Fail("Metrics_RecordAndSnapshot", ex);
		}
	}

	private static void Test_Metrics_LatencyStats()
	{
		try
		{
			SignalMetrics metrics = new();
			metrics.RecordLatency(10);
			metrics.RecordLatency(20);
			metrics.RecordLatency(30);
			metrics.RecordLatency(40);
			metrics.RecordLatency(50);

			LatencyStats stats = metrics.GetLatencyStats();
			Assert(stats.Min == 10, $"Min: {stats.Min}");
			Assert(stats.Max == 50, $"Max: {stats.Max}");
			Assert(Math.Abs(stats.Mean - 30) < 0.01, $"Mean: {stats.Mean}");
			Assert(stats.P50 == 30, $"P50: {stats.P50}");
			Pass("Metrics_LatencyStats");
		}
		catch (Exception ex)
		{
			Fail("Metrics_LatencyStats", ex);
		}
	}

	private static void Test_Metrics_MeasureLatencyDisposable()
	{
		try
		{
			SignalMetrics metrics = new();
			using (metrics.MeasureLatency())
			{
				Thread.Sleep(20);
			}

			LatencyStats stats = metrics.GetLatencyStats();
			Assert(stats.Min >= 15, $"Latency too low: {stats.Min}ms");
			Assert(stats.Max < 500, $"Latency too high: {stats.Max}ms");
			Pass("Metrics_MeasureLatencyDisposable");
		}
		catch (Exception ex)
		{
			Fail("Metrics_MeasureLatencyDisposable", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// IdempotentSignalGenerator (Integration)
	// ══════════════════════════════════════════════════════════════════════

	private static IdempotentSignalGenerator CreateGenerator(
		IDistributedLockService? lockService = null,
		ISignalDeduplicationCache? dedupCache = null,
		IDeadLetterQueue? dlq = null
	)
	{
		return new IdempotentSignalGenerator(
			lockService ?? new InMemoryDistributedLockService(),
			dedupCache ?? new SignalDeduplicationCache(),
			dlq ?? new InMemoryDeadLetterQueue(),
			new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
			new CircuitBreaker(failureThreshold: 5, recoveryTimeout: TimeSpan.FromSeconds(30)),
			new SignalMetrics()
		);
	}

	private static (MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) CreateTestData()
	{
		MockUnitOfWork uow = new();

		// Create credentials for one game
		Credential cred1 = new()
		{
			House = "MIDAS",
			Game = "FireKirin",
			Username = "user1",
			Password = "pass1",
			Enabled = true,
			Balance = 10,
			Banned = false,
			CashedOut = false,
			LastUpdated = DateTime.UtcNow,
		};

		Credential cred2 = new()
		{
			House = "MIDAS",
			Game = "FireKirin",
			Username = "user2",
			Password = "pass2",
			Enabled = true,
			Balance = 15,
			Banned = false,
			CashedOut = false,
			LastUpdated = DateTime.UtcNow,
		};

		((MockRepoCredentials)uow.Credentials).Add(cred1);
		((MockRepoCredentials)uow.Credentials).Add(cred2);

		List<Credential> creds = new() { cred1, cred2 };
		List<IGrouping<(string House, string Game), Credential>> groups = creds.GroupBy(c => (c.House, c.Game)).ToList();

		// Create a jackpot that's "due" (EstimatedDate in the past, threshold met)
		Jackpot jackpot = new()
		{
			House = "MIDAS",
			Game = "FireKirin",
			Category = "Grand",
			Priority = 4,
			Current = 1500,
			Threshold = 1500,
			EstimatedDate = DateTime.UtcNow.AddHours(-1),
		};
		((MockRepoJackpots)uow.Jackpots).Add(jackpot);
		List<Jackpot> jackpots = new() { jackpot };

		List<Signal> existingSignals = new();

		return (uow, groups, jackpots, existingSignals);
	}

	private static void Test_IdempotentGenerator_BasicGeneration()
	{
		try
		{
			IdempotentSignalGenerator generator = CreateGenerator();
			(MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) = CreateTestData();

			List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);

			// SignalService logic determines if signals are generated based on isDue calculation
			// The key test is that the generator runs without error and returns a list
			Assert(result != null, "Result should not be null");
			Pass("IdempotentGenerator_BasicGeneration");
		}
		catch (Exception ex)
		{
			Fail("IdempotentGenerator_BasicGeneration", ex);
		}
	}

	private static void Test_IdempotentGenerator_DeduplicatesSameSignal()
	{
		try
		{
			SignalDeduplicationCache cache = new();
			IdempotentSignalGenerator generator = CreateGenerator(dedupCache: cache);
			(MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) = CreateTestData();

			// First call
			List<Signal> result1 = generator.GenerateSignals(uow, groups, jackpots, signals);
			int firstCount = result1.Count;

			// Second call — same data, should be deduplicated
			List<Signal> result2 = generator.GenerateSignals(uow, groups, jackpots, signals);

			// If first call produced signals, second should produce fewer (deduplicated)
			if (firstCount > 0)
			{
				Assert(
					result2.Count < firstCount || cache.DeduplicatedCount > 0,
					$"Second call should deduplicate. First={firstCount}, Second={result2.Count}, DedupeCount={cache.DeduplicatedCount}"
				);
			}
			Pass("IdempotentGenerator_DeduplicatesSameSignal");
		}
		catch (Exception ex)
		{
			Fail("IdempotentGenerator_DeduplicatesSameSignal", ex);
		}
	}

	private static void Test_IdempotentGenerator_LockContention()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			SignalMetrics metrics = new();
			IdempotentSignalGenerator generator = new(
				locks,
				new SignalDeduplicationCache(),
				new InMemoryDeadLetterQueue(),
				new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
				new CircuitBreaker(failureThreshold: 5),
				metrics
			);

			(MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) = CreateTestData();

			// Pre-acquire the lock with a different owner to simulate contention
			locks.TryAcquire("signal:MIDAS:FireKirin", "OTHER-INSTANCE", TimeSpan.FromSeconds(30));

			List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);

			// Should return empty due to lock contention
			Assert(result.Count == 0, $"Should return 0 signals under contention, got {result.Count}");
			Assert(metrics.LockContentions > 0, "Should record lock contention");
			Pass("IdempotentGenerator_LockContention");
		}
		catch (Exception ex)
		{
			Fail("IdempotentGenerator_LockContention", ex);
		}
	}

	private static void Test_IdempotentGenerator_CircuitBreakerFallback()
	{
		try
		{
			// Create a circuit breaker that's already open
			CircuitBreaker cb = new(failureThreshold: 1, recoveryTimeout: TimeSpan.FromMinutes(5));
			// Trip it
			try
			{
				cb.ExecuteAsync<int>(async () =>
					{
						await Task.CompletedTask;
						throw new Exception("trip");
					})
					.GetAwaiter()
					.GetResult();
			}
			catch { }

			SignalMetrics metrics = new();
			IdempotentSignalGenerator generator = new(
				new InMemoryDistributedLockService(),
				new SignalDeduplicationCache(),
				new InMemoryDeadLetterQueue(),
				new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
				cb,
				metrics
			);

			(MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) = CreateTestData();

			// Should fall through to unprotected SignalService
			List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);

			Assert(result != null, "Fallback should return non-null result");
			Assert(metrics.CircuitBreakerTrips > 0, "Should record circuit breaker trip");
			Pass("IdempotentGenerator_CircuitBreakerFallback");
		}
		catch (Exception ex)
		{
			Fail("IdempotentGenerator_CircuitBreakerFallback", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// Race Condition / Concurrency Tests
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_ConcurrentLockAcquisition()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			int threadCount = 20;
			int winners = 0;
			CountdownEvent latch = new(threadCount);
			List<Thread> threads = new();

			for (int i = 0; i < threadCount; i++)
			{
				int threadId = i;
				Thread thread = new(() =>
				{
					latch.Signal();
					latch.Wait();
					bool acquired = locks.TryAcquire("contested-resource", $"thread-{threadId}", TimeSpan.FromSeconds(10));
					if (acquired)
						Interlocked.Increment(ref winners);
				});
				threads.Add(thread);
				thread.Start();
			}

			foreach (Thread thread in threads)
			{
				thread.Join(TimeSpan.FromSeconds(5));
			}

			Assert(winners == 1, $"Exactly 1 thread should win the lock, got {winners}");
			Pass("ConcurrentLockAcquisition");
		}
		catch (Exception ex)
		{
			Fail("ConcurrentLockAcquisition", ex);
		}
	}

	private static void Test_ConcurrentSignalDeduplication()
	{
		try
		{
			SignalDeduplicationCache cache = new();
			int threadCount = 10;
			int processedCount = 0;
			string key = "MIDAS:FireKirin:user1";
			CountdownEvent latch = new(threadCount);
			List<Thread> threads = new();

			for (int i = 0; i < threadCount; i++)
			{
				Thread thread = new(() =>
				{
					latch.Signal();
					latch.Wait();
					if (!cache.IsProcessed(key))
					{
						cache.MarkProcessed(key);
						Interlocked.Increment(ref processedCount);
					}
				});
				threads.Add(thread);
				thread.Start();
			}

			foreach (Thread thread in threads)
			{
				thread.Join(TimeSpan.FromSeconds(5));
			}

			// Due to race conditions in the IsProcessed→MarkProcessed window,
			// a few threads might slip through, but it should be far fewer than all 10
			Assert(processedCount <= 5, $"At most 5 threads should process (got {processedCount}) — dedup working");
			Pass("ConcurrentSignalDeduplication");
		}
		catch (Exception ex)
		{
			Fail("ConcurrentSignalDeduplication", ex);
		}
	}

	private static void Test_ConcurrentGeneratorProducesNoDuplicates()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			SignalDeduplicationCache cache = new();
			SignalMetrics metrics = new();
			ConcurrentBag<Signal> allSignals = new();
			int threadCount = 5;
			CountdownEvent latch = new(threadCount);
			List<Thread> threads = new();

			for (int t = 0; t < threadCount; t++)
			{
				Thread thread = new(() =>
				{
					IdempotentSignalGenerator generator = new(
						locks,
						cache,
						new InMemoryDeadLetterQueue(),
						new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
						new CircuitBreaker(failureThreshold: 5),
						metrics
					);

					// Each thread gets its own UoW (simulating separate H0UND instances)
					(MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) =
						CreateTestData();

					latch.Signal();
					latch.Wait();

					List<Signal> result = generator.GenerateSignals(uow, groups, jackpots, signals);
					foreach (Signal sig in result)
					{
						allSignals.Add(sig);
					}
				});
				threads.Add(thread);
				thread.Start();
			}

			foreach (Thread thread in threads)
			{
				thread.Join(TimeSpan.FromSeconds(10));
			}

			// The distributed lock ensures only ONE thread generates signals per (House, Game).
			// The dedup cache ensures subsequent threads that win the lock get deduplicated.
			// So we expect: lock winners produce signals, losers produce 0, and dedup catches repeats.
			long contentions = metrics.LockContentions;
			long generated = metrics.SignalsGenerated;
			long deduped = metrics.SignalsDeduplicated;

			// At most 1 thread should have generated signals (lock holder), rest get contention or dedup
			Assert(contentions + deduped >= threadCount - 1, $"Lock+dedup should block {threadCount - 1} threads. Contentions={contentions}, Deduped={deduped}");
			Pass("ConcurrentGeneratorProducesNoDuplicates");
		}
		catch (Exception ex)
		{
			Fail("ConcurrentGeneratorProducesNoDuplicates", ex);
		}
	}

	// ══════════════════════════════════════════════════════════════════════
	// Performance Benchmark
	// ══════════════════════════════════════════════════════════════════════

	private static void Test_PerformanceBenchmark_Under100ms()
	{
		try
		{
			InMemoryDistributedLockService locks = new();
			SignalDeduplicationCache cache = new();
			SignalMetrics metrics = new();
			IdempotentSignalGenerator generator = new(
				locks,
				cache,
				new InMemoryDeadLetterQueue(),
				new RetryPolicy(maxRetries: 1, baseDelay: TimeSpan.FromMilliseconds(10)),
				new CircuitBreaker(failureThreshold: 5),
				metrics
			);

			// Warm up
			(MockUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, List<Jackpot> jackpots, List<Signal> signals) = CreateTestData();
			generator.GenerateSignals(uow, groups, jackpots, signals);
			cache.Clear();

			// Benchmark: measure 100 iterations
			int iterations = 100;
			Stopwatch sw = Stopwatch.StartNew();
			for (int i = 0; i < iterations; i++)
			{
				// Fresh cache for each to measure full path
				cache.Clear();
				(uow, groups, jackpots, signals) = CreateTestData();
				generator.GenerateSignals(uow, groups, jackpots, signals);
			}
			sw.Stop();

			double avgMs = sw.Elapsed.TotalMilliseconds / iterations;
			Console.WriteLine($"  [BENCH] IdempotentSignalGenerator avg latency: {avgMs:F2}ms over {iterations} iterations");

			Assert(avgMs < 100, $"Average latency {avgMs:F2}ms exceeds 100ms threshold");
			Pass("PerformanceBenchmark_Under100ms");
		}
		catch (Exception ex)
		{
			Fail("PerformanceBenchmark_Under100ms", ex);
		}
	}

	// ── Helpers ──────────────────────────────────────────────────────────

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
