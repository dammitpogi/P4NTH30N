using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Infrastructure.Resilience;

namespace P4NTH30N.UNI7T35T.Tests;

public static class CircuitBreakerTests
{
	private static int _passed;
	private static int _failed;

	public static (int passed, int failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Console.WriteLine("\n=== CircuitBreaker State Transition Tests (PROD-003) ===\n");

		Test_ClosedToOpen_AfterFailureThreshold();
		Test_OpenToHalfOpen_AfterRecoveryTimeout();
		Test_HalfOpenToClosed_OnSuccess();
		Test_HalfOpenToOpen_OnFailure();

		Console.WriteLine($"\n=== CircuitBreaker Results: {_passed} passed, {_failed} failed ===\n");
		return (_passed, _failed);
	}

	// ── Test 1: Closed → Open after threshold failures ──────────────────
	private static void Test_ClosedToOpen_AfterFailureThreshold()
	{
		try
		{
			int threshold = 3;
			CircuitBreaker cb = new(failureThreshold: threshold, recoveryTimeout: TimeSpan.FromMinutes(5));
			Assert(cb.State == CircuitState.Closed, $"Initial state should be Closed, got {cb.State}");

			// Trip it with exactly threshold failures
			for (int i = 0; i < threshold; i++)
			{
				Assert(cb.State == CircuitState.Closed, $"Should stay Closed until threshold reached (iteration {i})");
				try
				{
					cb.ExecuteAsync<int>(async () =>
						{
							await Task.CompletedTask;
							throw new InvalidOperationException($"failure {i + 1}");
						})
						.GetAwaiter()
						.GetResult();
				}
				catch (InvalidOperationException) { }
			}

			Assert(cb.State == CircuitState.Open, $"Should be Open after {threshold} failures, got {cb.State}");
			Assert(cb.FailureCount == threshold, $"FailureCount should be {threshold}, got {cb.FailureCount}");

			// Next call should throw CircuitBreakerOpenException
			bool threwOpen = false;
			try
			{
				cb.ExecuteAsync<int>(async () =>
					{
						await Task.CompletedTask;
						return 1;
					})
					.GetAwaiter()
					.GetResult();
			}
			catch (CircuitBreakerOpenException)
			{
				threwOpen = true;
			}
			Assert(threwOpen, "Should throw CircuitBreakerOpenException when Open");

			Pass("ClosedToOpen_AfterFailureThreshold");
		}
		catch (Exception ex)
		{
			Fail("ClosedToOpen_AfterFailureThreshold", ex);
		}
	}

	// ── Test 2: Open → HalfOpen after recovery timeout ──────────────────
	private static void Test_OpenToHalfOpen_AfterRecoveryTimeout()
	{
		try
		{
			// Use a very short recovery timeout so we can test the transition
			TimeSpan recoveryTimeout = TimeSpan.FromMilliseconds(100);
			CircuitBreaker cb = new(failureThreshold: 1, recoveryTimeout: recoveryTimeout);

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
			catch (Exception) when (!(cb.State == CircuitState.Closed)) { }
			catch { }

			Assert(cb.State == CircuitState.Open, $"Should be Open after trip, got {cb.State}");

			// Wait for recovery timeout to elapse
			Thread.Sleep(150);

			// State property should now report HalfOpen (the getter handles transition)
			Assert(cb.State == CircuitState.HalfOpen, $"Should transition to HalfOpen after timeout, got {cb.State}");

			Pass("OpenToHalfOpen_AfterRecoveryTimeout");
		}
		catch (Exception ex)
		{
			Fail("OpenToHalfOpen_AfterRecoveryTimeout", ex);
		}
	}

	// ── Test 3: HalfOpen → Closed on successful execution ───────────────
	private static void Test_HalfOpenToClosed_OnSuccess()
	{
		try
		{
			TimeSpan recoveryTimeout = TimeSpan.FromMilliseconds(50);
			CircuitBreaker cb = new(failureThreshold: 1, recoveryTimeout: recoveryTimeout);

			// Trip it to Open
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

			Assert(cb.State == CircuitState.Open, $"Should be Open, got {cb.State}");

			// Wait for recovery → HalfOpen
			Thread.Sleep(100);
			Assert(cb.State == CircuitState.HalfOpen, $"Should be HalfOpen, got {cb.State}");

			// Execute a successful operation → should transition to Closed
			int result = cb.ExecuteAsync(async () =>
				{
					await Task.CompletedTask;
					return 42;
				})
				.GetAwaiter()
				.GetResult();

			Assert(result == 42, $"Expected result 42, got {result}");
			Assert(cb.State == CircuitState.Closed, $"Should be Closed after success in HalfOpen, got {cb.State}");
			Assert(cb.FailureCount == 0, $"FailureCount should reset to 0, got {cb.FailureCount}");

			Pass("HalfOpenToClosed_OnSuccess");
		}
		catch (Exception ex)
		{
			Fail("HalfOpenToClosed_OnSuccess", ex);
		}
	}

	// ── Test 4: HalfOpen → Open on failure ──────────────────────────────
	private static void Test_HalfOpenToOpen_OnFailure()
	{
		try
		{
			TimeSpan recoveryTimeout = TimeSpan.FromMilliseconds(50);
			CircuitBreaker cb = new(failureThreshold: 1, recoveryTimeout: recoveryTimeout);

			// Trip it to Open
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

			Assert(cb.State == CircuitState.Open, $"Should be Open, got {cb.State}");

			// Wait for recovery → HalfOpen
			Thread.Sleep(100);
			Assert(cb.State == CircuitState.HalfOpen, $"Should be HalfOpen, got {cb.State}");

			// Execute a failing operation → should go back to Open
			try
			{
				cb.ExecuteAsync<int>(async () =>
					{
						await Task.CompletedTask;
						throw new Exception("fail again");
					})
					.GetAwaiter()
					.GetResult();
			}
			catch (Exception ex) when (ex is not CircuitBreakerOpenException) { }

			Assert(cb.State == CircuitState.Open, $"Should be Open after HalfOpen failure, got {cb.State}");

			// Verify it rejects calls now
			bool threwOpen = false;
			try
			{
				cb.ExecuteAsync<int>(async () =>
					{
						await Task.CompletedTask;
						return 1;
					})
					.GetAwaiter()
					.GetResult();
			}
			catch (CircuitBreakerOpenException)
			{
				threwOpen = true;
			}
			Assert(threwOpen, "Should throw CircuitBreakerOpenException after HalfOpen→Open");

			Pass("HalfOpenToOpen_OnFailure");
		}
		catch (Exception ex)
		{
			Fail("HalfOpenToOpen_OnFailure", ex);
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
