using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Services;
using UNI7T35T.Mocks;

namespace UNI7T35T.Tests;

/// <summary>
/// SPIN-044: Tests for FirstSpinController components.
/// Tests checklist, abort conditions, and result formatting.
/// Note: Full E2E spin requires live infrastructure — these test the controller logic.
/// </summary>
public static class FirstSpinControllerTests
{
	public static (int Passed, int Failed) RunAll()
	{
		Console.WriteLine("[FirstSpinControllerTests] Running...");
		int passed = 0;
		int failed = 0;

		void Assert(bool condition, string name)
		{
			if (condition)
			{
				passed++;
				Console.WriteLine($"  PASS {name}");
			}
			else
			{
				failed++;
				Console.WriteLine($"  FAIL {name}");
			}
		}

		// Test 1: FirstSpinConfig defaults are safe
		{
			FirstSpinConfig config = new();
			Assert(config.MaxBetAmount == 0.10, "Config: Default MaxBetAmount is $0.10");
			Assert(config.RequireConfirmation, "Config: Default RequireConfirmation is true");
			Assert(config.ConfirmationTimeoutSec == 60, "Config: Default ConfirmationTimeoutSec is 60");
			Assert(config.SpinTimeoutSec == 30, "Config: Default SpinTimeoutSec is 30");
			Assert(config.MinBalance == 1.00, "Config: Default MinBalance is $1.00");
			Assert(config.CaptureScreenshots, "Config: Default CaptureScreenshots is true");
			Assert(config.SaveToMongoDB, "Config: Default SaveToMongoDB is true");
		}

		// Test 2: FirstSpinResult formatting
		{
			FirstSpinResult result = new()
			{
				Success = true,
				Username = "testuser",
				Game = "FireKirin",
				House = "TestHouse",
				BalanceBefore = 10.50,
				BalanceAfter = 10.40,
				SpinDurationMs = 2500,
				TotalDurationMs = 15000,
			};
			result.Checks["MongoDB"] = true;
			result.Checks["CDP"] = true;
			result.Checks["Balance"] = true;

			string str = result.ToString();
			Assert(str.Contains("SUCCESS"), "Result: ToString contains SUCCESS");
			Assert(str.Contains("testuser"), "Result: ToString contains username");
			Assert(str.Contains("3/3"), "Result: ToString shows correct check count");
		}

		// Test 3: FirstSpinResult aborted formatting
		{
			FirstSpinResult result = new()
			{
				Success = false,
				AbortReason = "Balance too low",
				BalanceBefore = 0.05,
				TotalDurationMs = 500,
			};
			result.Checks["MongoDB"] = true;
			result.Checks["Balance"] = false;

			string str = result.ToString();
			Assert(str.Contains("ABORTED"), "Result: Aborted ToString contains ABORTED");
			Assert(str.Contains("Balance too low"), "Result: Aborted ToString contains reason");
		}

		// Test 4: FirstSpinResult balance change calculation
		{
			FirstSpinResult result = new()
			{
				BalanceBefore = 10.50,
				BalanceAfter = 10.40,
			};
			Assert(Math.Abs(result.BalanceChange - (-0.10)) < 0.001, $"Result: BalanceChange = {result.BalanceChange} (expected -0.10)");
		}

		// Test 5: FirstSpinConfig safety — MaxBet cannot exceed $0.10 in default
		{
			FirstSpinConfig config = new();
			bool safe = config.MaxBetAmount <= 0.10;
			Assert(safe, "Config: Default MaxBetAmount does not exceed $0.10 safety limit");
		}

		// Test 6: SpinMetrics records first spin attempt
		{
			SpinMetrics metrics = new();
			metrics.RecordSpin(new SpinRecord
			{
				Success = true,
				LatencyMs = 2500,
				Game = "FireKirin",
				House = "TestHouse",
				Username = "testuser",
				BalanceBefore = 10.50,
				BalanceAfter = 10.40,
				SignalPriority = 4,
			});

			SpinSummary summary = metrics.GetSummary(hours: 1);
			Assert(summary.TotalSpins == 1, "Metrics: Recorded 1 spin");
			Assert(summary.Successes == 1, "Metrics: 1 success");
			Assert(summary.SuccessRate == 100.0, "Metrics: 100% success rate");
		}

		Console.WriteLine($"[FirstSpinControllerTests] Done: {passed} passed, {failed} failed");
		return (passed, failed);
	}
}
