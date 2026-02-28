using System.Threading.Channels;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Navigation;
using P4NTHE0N.H4ND.Navigation.Strategies;
using P4NTHE0N.H4ND.Navigation.Verification;
using P4NTHE0N.H4ND;
using P4NTHE0N.H4ND.Parallel;
using P4NTHE0N.H4ND.Services;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// CRIT-103: Tychon Protocol chaos tests.
/// Every fix gets a test that FORCES the failure mode and verifies the system crashes correctly.
/// </summary>
public static class TychonChaosTests
{
	private static int _passed;
	private static int _failed;

	public static (int Passed, int Failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Console.WriteLine("── CRIT-103: Tychon Chaos Tests ──\n");

		// Phase 1: Stop the Bleeding
		TC001_WorkerId_InvalidFormat_Throws();
		TC002_WorkerId_ValidFormat_Parses();
		TC003_WorkerId_Null_Throws();

		// Phase 2: Stop False Success
		TC004_TypeStrategy_EmptyInput_Throws();
		TC005_NavigateStrategy_EmptyUrl_Throws();
		TC006_VerificationStrategy_UnknownGate_FailsClosed();
		TC007_VerificationStrategy_InformationalGate_Passes();
		TC008_VerificationStrategy_EmptyGate_Passes();

		// Phase 3: Stop Data Loss
		TC009_JackpotReader_AllSelectorsFail_ReturnsNull();
		TC010_JackpotReader_ValidSelector_ReturnsValue();

		// Phase 4: Infrastructure Hardening
		TC011_ParallelMetrics_ThreadSafe_Increments();
		TC012_VisionCommandListener_NoHandler_Fails();
		TC013_WorkerStats_Interlocked_NoLostUpdates();

		Console.WriteLine($"\n  Tychon Chaos: {_passed}/{_passed + _failed} passed\n");
		return (_passed, _failed);
	}

	// ── Phase 1: Worker ID Parsing ──────────────────────────────────

	private static void TC001_WorkerId_InvalidFormat_Throws()
	{
		try
		{
			var channel = Channel.CreateBounded<SignalWorkItem>(1);
			// "invalid" doesn't match "W00" format — must throw
			new ParallelSpinWorker("invalid", channel.Reader, null!, null!, new CdpConfig(), new ParallelMetrics());
			Fail("TC-001", "ParallelSpinWorker accepted invalid worker ID 'invalid'");
		}
		catch (ArgumentException ex) when (ex.Message.Contains("Invalid worker ID format"))
		{
			Pass("TC-001", "Invalid worker ID throws ArgumentException");
		}
		catch (Exception ex)
		{
			Fail("TC-001", $"Wrong exception type: {ex.GetType().Name}: {ex.Message}");
		}
	}

	private static void TC002_WorkerId_ValidFormat_Parses()
	{
		try
		{
			var channel = Channel.CreateBounded<SignalWorkItem>(1);
			var w0 = new ParallelSpinWorker("W00", channel.Reader, null!, null!, new CdpConfig(), new ParallelMetrics());
			var w1 = new ParallelSpinWorker("W01", channel.Reader, null!, null!, new CdpConfig(), new ParallelMetrics());
			var w5 = new ParallelSpinWorker("W05", channel.Reader, null!, null!, new CdpConfig(), new ParallelMetrics());

			// If we got here without exception, the IDs parsed correctly
			bool idsUnique = w0.WorkerId == "W00" && w1.WorkerId == "W01" && w5.WorkerId == "W05";
			if (idsUnique)
				Pass("TC-002", "Worker IDs W00, W01, W05 parsed without collision");
			else
				Fail("TC-002", "Worker IDs not preserved correctly");
		}
		catch (Exception ex)
		{
			Fail("TC-002", $"Valid worker IDs should not throw: {ex.Message}");
		}
	}

	private static void TC003_WorkerId_Null_Throws()
	{
		try
		{
			var channel = Channel.CreateBounded<SignalWorkItem>(1);
			new ParallelSpinWorker(null!, channel.Reader, null!, null!, new CdpConfig(), new ParallelMetrics());
			Fail("TC-003", "ParallelSpinWorker accepted null worker ID");
		}
		catch (ArgumentException)
		{
			Pass("TC-003", "Null worker ID throws ArgumentException");
		}
		catch (Exception ex)
		{
			Fail("TC-003", $"Wrong exception type: {ex.GetType().Name}: {ex.Message}");
		}
	}

	// ── Phase 2: Stop False Success ─────────────────────────────────

	private static void TC004_TypeStrategy_EmptyInput_Throws()
	{
		try
		{
			var strategy = new TypeStepStrategy();
			var step = new NavigationStep
			{
				StepId = 1,
				Action = "type",
				Phase = "Login",
				Comment = "Type username",
				Input = "", // Empty — should throw
				Verification = new StepVerification(),
			};
			var context = new StepExecutionContext
			{
				CdpClient = new MockCdpClient(),
				Platform = "FireKirin",
				WorkerId = "test",
				Username = "", // Also empty
				Password = "",
			};

			strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();
			Fail("TC-004", "TypeStepStrategy accepted empty input without throwing");
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("empty input"))
		{
			Pass("TC-004", "Empty type input throws InvalidOperationException");
		}
		catch (Exception ex)
		{
			Fail("TC-004", $"Wrong exception: {ex.GetType().Name}: {ex.Message}");
		}
	}

	private static void TC005_NavigateStrategy_EmptyUrl_Throws()
	{
		try
		{
			var strategy = new NavigateStepStrategy();
			var step = new NavigationStep
			{
				StepId = 1,
				Action = "navigate",
				Phase = "Login",
				Comment = "Navigate to game",
				Url = "", // Empty — should throw
				Verification = new StepVerification(),
			};
			var context = new StepExecutionContext
			{
				CdpClient = new MockCdpClient(),
				Platform = "FireKirin",
				WorkerId = "test",
			};

			strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();
			Fail("TC-005", "NavigateStepStrategy accepted empty URL without throwing");
		}
		catch (ArgumentException ex) when (ex.Message.Contains("requires a URL"))
		{
			Pass("TC-005", "Empty URL throws ArgumentException");
		}
		catch (Exception ex)
		{
			Fail("TC-005", $"Wrong exception: {ex.GetType().Name}: {ex.Message}");
		}
	}

	private static void TC006_VerificationStrategy_UnknownGate_FailsClosed()
	{
		try
		{
			var strategy = new JavaScriptVerificationStrategy();
			var context = new StepExecutionContext
			{
				CdpClient = new MockCdpClient(),
				Platform = "FireKirin",
				WorkerId = "test",
			};

			bool result = strategy.VerifyAsync("some_unknown_gate_xyz_123", context, CancellationToken.None)
				.GetAwaiter().GetResult();

			if (!result)
				Pass("TC-006", "Unknown gate returns false (fail closed)");
			else
				Fail("TC-006", "Unknown gate returned true (fail OPEN — the old lie)");
		}
		catch (Exception ex)
		{
			Fail("TC-006", $"Exception: {ex.Message}");
		}
	}

	private static void TC007_VerificationStrategy_InformationalGate_Passes()
	{
		try
		{
			var strategy = new JavaScriptVerificationStrategy();
			var context = new StepExecutionContext
			{
				CdpClient = new MockCdpClient(),
				Platform = "FireKirin",
				WorkerId = "test",
			};

			bool result = strategy.VerifyAsync("Login page visible", context, CancellationToken.None)
				.GetAwaiter().GetResult();

			if (result)
				Pass("TC-007", "Informational gate 'Login page visible' passes");
			else
				Fail("TC-007", "Informational gate should pass but returned false");
		}
		catch (Exception ex)
		{
			Fail("TC-007", $"Exception: {ex.Message}");
		}
	}

	private static void TC008_VerificationStrategy_EmptyGate_Passes()
	{
		try
		{
			var strategy = new JavaScriptVerificationStrategy();
			var context = new StepExecutionContext
			{
				CdpClient = new MockCdpClient(),
				Platform = "FireKirin",
				WorkerId = "test",
			};

			bool result = strategy.VerifyAsync("", context, CancellationToken.None)
				.GetAwaiter().GetResult();

			if (result)
				Pass("TC-008", "Empty gate passes (many recorder steps have no verification)");
			else
				Fail("TC-008", "Empty gate should pass but returned false");
		}
		catch (Exception ex)
		{
			Fail("TC-008", $"Exception: {ex.Message}");
		}
	}

	// ── Phase 3: Stop Data Loss ─────────────────────────────────────

	private static void TC009_JackpotReader_AllSelectorsFail_ReturnsNull()
	{
		try
		{
			MockCdpClient cdp = new();
			JackpotReader reader = new();
			double? grand = reader.ReadJackpotAsync(cdp, "FireKirin", "Grand").GetAwaiter().GetResult();

			if (grand == null)
				Pass("TC-009", "All selectors fail → null (not 0)");
			else
				Fail("TC-009", $"Expected null but got {grand}");
		}
		catch (Exception ex)
		{
			Fail("TC-009", $"Exception: {ex.Message}");
		}
	}

	private static void TC010_JackpotReader_ValidSelector_ReturnsValue()
	{
		try
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("window.parent.Grand", 25000.0);
			JackpotReader reader = new();
			double? grand = reader.ReadJackpotAsync(cdp, "FireKirin", "Grand").GetAwaiter().GetResult();

			if (grand == 250.0)
				Pass("TC-010", $"Valid selector returns {grand} (25000/100)");
			else
				Fail("TC-010", $"Expected 250.0 but got {grand}");
		}
		catch (Exception ex)
		{
			Fail("TC-010", $"Exception: {ex.Message}");
		}
	}

	// ── Phase 4: Infrastructure Hardening ────────────────────────────

	private static void TC011_ParallelMetrics_ThreadSafe_Increments()
	{
		try
		{
			var metrics = new ParallelMetrics();

			// Simulate 100 concurrent spin recordings from 5 workers
			var tasks = new List<Task>();
			for (int w = 0; w < 5; w++)
			{
				string workerId = $"W{w:D2}";
				tasks.Add(Task.Run(() =>
				{
					for (int i = 0; i < 20; i++)
					{
						metrics.RecordSpinResult(workerId, i % 2 == 0, TimeSpan.FromMilliseconds(100));
					}
				}));
			}
			Task.WaitAll(tasks.ToArray());

			// 5 workers × 20 spins = 100 total
			bool totalCorrect = metrics.SpinsAttempted == 100;
			// 5 workers × 10 successes = 50
			bool successCorrect = metrics.SpinsSucceeded == 50;

			if (totalCorrect && successCorrect)
				Pass("TC-011", $"Thread-safe: {metrics.SpinsAttempted} attempted, {metrics.SpinsSucceeded} succeeded");
			else
				Fail("TC-011", $"Race condition: expected 100/50, got {metrics.SpinsAttempted}/{metrics.SpinsSucceeded}");
		}
		catch (Exception ex)
		{
			Fail("TC-011", $"Exception: {ex.Message}");
		}
	}

	private static void TC012_VisionCommandListener_NoHandler_Fails()
	{
		try
		{
			var listener = new VisionCommandListener();
			var command = new VisionCommand
			{
				CommandType = VisionCommandType.Spin,
				TargetUsername = "test",
				TargetGame = "FireKirin",
			};

			// No handler registered — should fail, not succeed
			bool result = listener.ProcessCommandAsync(command, CancellationToken.None)
				.GetAwaiter().GetResult();

			if (!result && command.Status == VisionCommandStatus.Failed)
				Pass("TC-012", "No handler → command FAILED (not silently completed)");
			else
				Fail("TC-012", $"Expected failure but got result={result}, status={command.Status}");
		}
		catch (Exception ex)
		{
			Fail("TC-012", $"Exception: {ex.Message}");
		}
	}

	private static void TC013_WorkerStats_Interlocked_NoLostUpdates()
	{
		try
		{
			var stats = new WorkerStats();

			// Hammer from 10 threads
			var tasks = new List<Task>();
			for (int t = 0; t < 10; t++)
			{
				tasks.Add(Task.Run(() =>
				{
					for (int i = 0; i < 1000; i++)
					{
						stats.IncrementTotalSpins();
						if (i % 3 == 0) stats.IncrementSuccessfulSpins();
					}
				}));
			}
			Task.WaitAll(tasks.ToArray());

			// 10 threads × 1000 = 10000 total
			bool totalCorrect = stats.TotalSpins == 10000;
			// 10 threads × 334 (1000/3 rounded) = ~3340
			int expectedSuccessful = 10 * 334; // floor(1000/3) + 1 = 334 per thread
			bool successClose = Math.Abs(stats.SuccessfulSpins - expectedSuccessful) <= 10;

			if (totalCorrect && successClose)
				Pass("TC-013", $"WorkerStats thread-safe: {stats.TotalSpins} total, {stats.SuccessfulSpins} successful");
			else
				Fail("TC-013", $"Lost updates: expected ~10000/{expectedSuccessful}, got {stats.TotalSpins}/{stats.SuccessfulSpins}");
		}
		catch (Exception ex)
		{
			Fail("TC-013", $"Exception: {ex.Message}");
		}
	}

	// ── Helpers ──────────────────────────────────────────────────────

	private static void Pass(string id, string message)
	{
		_passed++;
		Console.WriteLine($"  [{id}] PASS: {message}");
	}

	private static void Fail(string id, string message)
	{
		_failed++;
		Console.WriteLine($"  [{id}] FAIL: {message}");
	}
}
