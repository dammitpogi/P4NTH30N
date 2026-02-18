using P4NTH30N.W4TCHD0G.Agent;
using P4NTH30N.W4TCHD0G.Input;
using P4NTH30N.W4TCHD0G.Models;
using P4NTH30N.W4TCHD0G.Monitoring;
using P4NTH30N.W4TCHD0G.Safety;
using P4NTH30N.W4TCHD0G.Stream;
using P4NTH30N.W4TCHD0G.Vision;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// End-to-end integration tests for the full jackpot automation pipeline.
/// Validates signal → vision → decision → action flow using mock components.
/// </summary>
/// <remarks>
/// WIN-001: Integration Testing — Signal to Jackpot.
/// Tests run without real RTMP, OBS, or casino connections.
/// Mock implementations simulate the full pipeline.
/// </remarks>
public static class PipelineIntegrationTests
{
	private static int _passed;
	private static int _failed;

	public static (int passed, int failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Console.WriteLine("\n=== Pipeline Integration Tests (WIN-001) ===\n");

		Test_FrameBuffer_CircularOverflow();
		Test_FrameBuffer_LatestFrame();
		Test_ScreenMapper_FrameToVm();
		Test_ScreenMapper_VmToFrame_RoundTrip();
		Test_ActionQueue_ExecutionOrder();
		Test_DecisionEngine_SafetyLimits();
		Test_DecisionEngine_LossLimitPause();
		Test_DecisionEngine_IdleWithSignal();
		Test_DecisionEngine_BusyNoAction();
		Test_SafetyMonitor_DailySpendLimit();
		Test_SafetyMonitor_ConsecutiveLosses();
		Test_SafetyMonitor_KillSwitch();
		Test_SafetyMonitor_KillSwitchOverride();
		Test_WinDetector_BalanceIncrease();
		Test_WinDetector_NoWinOnLoss();
		Test_InputAction_FactoryMethods();

		Console.WriteLine($"\n=== Results: {_passed} passed, {_failed} failed ===\n");
		return (_passed, _failed);
	}

	// ── FrameBuffer Tests ────────────────────────────────────────────

	private static void Test_FrameBuffer_CircularOverflow()
	{
		try
		{
			using FrameBuffer buffer = new(3);
			for (int i = 0; i < 10; i++)
			{
				buffer.AddFrame(new VisionFrame { FrameNumber = i, Data = new byte[10] });
			}

			Assert(buffer.Count <= 3, "Buffer should not exceed max size");
			Assert(buffer.TotalAdded == 10, $"Total added should be 10, got {buffer.TotalAdded}");
			Assert(buffer.TotalDropped >= 7, $"Should have dropped at least 7, got {buffer.TotalDropped}");
			Pass("FrameBuffer_CircularOverflow");
		}
		catch (Exception ex) { Fail("FrameBuffer_CircularOverflow", ex); }
	}

	private static void Test_FrameBuffer_LatestFrame()
	{
		try
		{
			using FrameBuffer buffer = new(5);
			buffer.AddFrame(new VisionFrame { FrameNumber = 1 });
			buffer.AddFrame(new VisionFrame { FrameNumber = 2 });
			buffer.AddFrame(new VisionFrame { FrameNumber = 42 });

			VisionFrame? latest = buffer.GetLatest();
			Assert(latest is not null, "Latest frame should not be null");
			Assert(latest!.FrameNumber == 42, $"Latest frame should be 42, got {latest.FrameNumber}");
			Pass("FrameBuffer_LatestFrame");
		}
		catch (Exception ex) { Fail("FrameBuffer_LatestFrame", ex); }
	}

	// ── ScreenMapper Tests ───────────────────────────────────────────

	private static void Test_ScreenMapper_FrameToVm()
	{
		try
		{
			ScreenMapper mapper = new(1280, 720, 1920, 1080);
			(int vmX, int vmY) = mapper.FrameToVm(640, 360);
			Assert(vmX == 960, $"Expected vmX=960, got {vmX}");
			Assert(vmY == 540, $"Expected vmY=540, got {vmY}");
			Pass("ScreenMapper_FrameToVm");
		}
		catch (Exception ex) { Fail("ScreenMapper_FrameToVm", ex); }
	}

	private static void Test_ScreenMapper_VmToFrame_RoundTrip()
	{
		try
		{
			ScreenMapper mapper = new(1280, 720, 1920, 1080);
			(int vmX, int vmY) = mapper.FrameToVm(100, 200);
			(int frameX, int frameY) = mapper.VmToFrame(vmX, vmY);
			Assert(Math.Abs(frameX - 100) <= 1, $"Round-trip X should be ~100, got {frameX}");
			Assert(Math.Abs(frameY - 200) <= 1, $"Round-trip Y should be ~200, got {frameY}");
			Pass("ScreenMapper_VmToFrame_RoundTrip");
		}
		catch (Exception ex) { Fail("ScreenMapper_VmToFrame_RoundTrip", ex); }
	}

	// ── ActionQueue Tests ────────────────────────────────────────────

	private static void Test_ActionQueue_ExecutionOrder()
	{
		try
		{
			ActionQueue queue = new();
			List<int> executionOrder = new();

			queue.Enqueue(InputAction.Delay(0));
			queue.Enqueue(InputAction.Click(10, 20));
			queue.Enqueue(InputAction.TypeText("test"));

			int executed = queue.ExecuteAllAsync(async (action, ct) =>
			{
				executionOrder.Add(executionOrder.Count);
				await Task.CompletedTask;
			}).GetAwaiter().GetResult();

			Assert(executed == 3, $"Should have executed 3, got {executed}");
			Assert(queue.Count == 0, "Queue should be empty after execution");
			Assert(queue.TotalExecuted == 3, $"TotalExecuted should be 3, got {queue.TotalExecuted}");
			Pass("ActionQueue_ExecutionOrder");
		}
		catch (Exception ex) { Fail("ActionQueue_ExecutionOrder", ex); }
	}

	// ── DecisionEngine Tests ─────────────────────────────────────────

	private static void Test_DecisionEngine_SafetyLimits()
	{
		try
		{
			DecisionEngine engine = new(minBalance: 10m, dailyLossLimit: 50m);
			VisionAnalysis analysis = new() { GameState = AnimationState.Idle };

			// Low balance should pause
			DecisionResult result = engine.Evaluate(analysis, hasSignal: true, currentBalance: 5m);
			Assert(result.Type == DecisionType.Pause, $"Expected Pause, got {result.Type}");
			Pass("DecisionEngine_SafetyLimits");
		}
		catch (Exception ex) { Fail("DecisionEngine_SafetyLimits", ex); }
	}

	private static void Test_DecisionEngine_LossLimitPause()
	{
		try
		{
			DecisionEngine engine = new(minBalance: 1m, dailyLossLimit: 10m);
			VisionAnalysis analysis = new() { GameState = AnimationState.Idle };

			// Simulate losses exceeding daily limit
			engine.Evaluate(analysis, hasSignal: false, currentBalance: 100m);
			engine.Evaluate(analysis, hasSignal: false, currentBalance: 85m); // -15 loss

			DecisionResult result = engine.Evaluate(analysis, hasSignal: true, currentBalance: 85m);
			Assert(result.Type == DecisionType.Pause, $"Expected Pause after loss limit, got {result.Type}");
			Assert(engine.IsLossLimitReached, "Loss limit should be reached");
			Pass("DecisionEngine_LossLimitPause");
		}
		catch (Exception ex) { Fail("DecisionEngine_LossLimitPause", ex); }
	}

	private static void Test_DecisionEngine_IdleWithSignal()
	{
		try
		{
			DecisionEngine engine = new(minBalance: 1m, dailyLossLimit: 1000m);
			VisionAnalysis analysis = new() { GameState = AnimationState.Idle };

			DecisionResult result = engine.Evaluate(analysis, hasSignal: true, currentBalance: 100m);
			Assert(result.Type == DecisionType.Act, $"Expected Act, got {result.Type}");
			Assert(result.Actions.Count > 0, "Should have actions to execute");
			Pass("DecisionEngine_IdleWithSignal");
		}
		catch (Exception ex) { Fail("DecisionEngine_IdleWithSignal", ex); }
	}

	private static void Test_DecisionEngine_BusyNoAction()
	{
		try
		{
			DecisionEngine engine = new(minBalance: 1m, dailyLossLimit: 1000m);
			VisionAnalysis analysis = new() { GameState = AnimationState.Spinning };

			DecisionResult result = engine.Evaluate(analysis, hasSignal: true, currentBalance: 100m);
			Assert(result.Type == DecisionType.NoAction, $"Expected NoAction during spin, got {result.Type}");
			Pass("DecisionEngine_BusyNoAction");
		}
		catch (Exception ex) { Fail("DecisionEngine_BusyNoAction", ex); }
	}

	// ── SafetyMonitor Tests ──────────────────────────────────────────

	private static void Test_SafetyMonitor_DailySpendLimit()
	{
		try
		{
			using SafetyMonitor monitor = new(dailySpendLimit: 20m);
			bool alertFired = false;
			monitor.OnKillSwitchActivated += _ => alertFired = true;

			monitor.RecordSpin(10m);
			Assert(monitor.IsSafeToContinue(), "Should be safe after $10 spend");

			monitor.RecordSpin(10m);
			Assert(!monitor.IsSafeToContinue(), "Should NOT be safe after $20 spend");
			Assert(alertFired, "Kill switch should have fired");
			Pass("SafetyMonitor_DailySpendLimit");
		}
		catch (Exception ex) { Fail("SafetyMonitor_DailySpendLimit", ex); }
	}

	private static void Test_SafetyMonitor_ConsecutiveLosses()
	{
		try
		{
			using SafetyMonitor monitor = new(maxConsecutiveLosses: 3, dailyLossLimit: 1000m);

			monitor.RecordBalanceChange(100m, 95m);
			monitor.RecordBalanceChange(95m, 90m);
			Assert(monitor.IsSafeToContinue(), "Should be safe after 2 losses");

			monitor.RecordBalanceChange(90m, 85m);
			Assert(!monitor.IsSafeToContinue(), "Should NOT be safe after 3 consecutive losses");
			Pass("SafetyMonitor_ConsecutiveLosses");
		}
		catch (Exception ex) { Fail("SafetyMonitor_ConsecutiveLosses", ex); }
	}

	private static void Test_SafetyMonitor_KillSwitch()
	{
		try
		{
			using SafetyMonitor monitor = new();
			Assert(monitor.IsSafeToContinue(), "Should be safe initially");

			monitor.ActivateKillSwitch("Test emergency");
			Assert(!monitor.IsSafeToContinue(), "Should NOT be safe after kill switch");

			SafetyStatus status = monitor.GetStatus();
			Assert(status.KillSwitchActive, "Kill switch should be active in status");
			Pass("SafetyMonitor_KillSwitch");
		}
		catch (Exception ex) { Fail("SafetyMonitor_KillSwitch", ex); }
	}

	private static void Test_SafetyMonitor_KillSwitchOverride()
	{
		try
		{
			using SafetyMonitor monitor = new();
			monitor.ActivateKillSwitch("Test");

			bool wrongCode = monitor.DeactivateKillSwitch("WRONG-CODE");
			Assert(!wrongCode, "Wrong override code should fail");
			Assert(!monitor.IsSafeToContinue(), "Still should be unsafe");

			bool rightCode = monitor.DeactivateKillSwitch("CONFIRM-RESUME-P4NTH30N");
			Assert(rightCode, "Correct override code should succeed");
			Assert(monitor.IsSafeToContinue(), "Should be safe after override");
			Pass("SafetyMonitor_KillSwitchOverride");
		}
		catch (Exception ex) { Fail("SafetyMonitor_KillSwitchOverride", ex); }
	}

	// ── WinDetector Tests ────────────────────────────────────────────

	private static void Test_WinDetector_BalanceIncrease()
	{
		try
		{
			WinDetector detector = new(winThresholdMultiplier: 1.5m);
			detector.SetBetAmount(1.0m);

			// First call sets baseline
			VisionAnalysis analysis = new();
			WinEvent? result1 = detector.Analyze(analysis, 100m);
			Assert(result1 is null, "First call should return null (baseline)");

			// Balance increase > threshold
			WinEvent? result2 = detector.Analyze(analysis, 105m);
			Assert(result2 is not null, "Should detect win on balance increase");
			Assert(result2!.Amount == 5m, $"Win amount should be 5, got {result2.Amount}");
			Assert(result2.IsOurWin, "Should be flagged as our win");
			Pass("WinDetector_BalanceIncrease");
		}
		catch (Exception ex) { Fail("WinDetector_BalanceIncrease", ex); }
	}

	private static void Test_WinDetector_NoWinOnLoss()
	{
		try
		{
			WinDetector detector = new();
			detector.SetBetAmount(1.0m);

			VisionAnalysis analysis = new();
			detector.Analyze(analysis, 100m); // Baseline
			WinEvent? result = detector.Analyze(analysis, 95m); // Loss

			Assert(result is null, "Should not detect win on balance decrease");
			Pass("WinDetector_NoWinOnLoss");
		}
		catch (Exception ex) { Fail("WinDetector_NoWinOnLoss", ex); }
	}

	// ── InputAction Tests ────────────────────────────────────────────

	private static void Test_InputAction_FactoryMethods()
	{
		try
		{
			InputAction click = InputAction.Click(100, 200);
			Assert(click.Type == InputActionType.Click, "Click type mismatch");
			Assert(click.X == 100 && click.Y == 200, "Click coordinates mismatch");

			InputAction key = InputAction.KeyPress(SynergyKey.Enter);
			Assert(key.Type == InputActionType.KeyPress, "KeyPress type mismatch");
			Assert(key.Key == SynergyKey.Enter, "Key mismatch");

			InputAction text = InputAction.TypeText("hello");
			Assert(text.Type == InputActionType.SendKeys, "SendKeys type mismatch");
			Assert(text.Text == "hello", "Text mismatch");

			InputAction delay = InputAction.Delay(500);
			Assert(delay.Type == InputActionType.Delay, "Delay type mismatch");
			Assert(delay.DelayAfterMs == 500, "Delay duration mismatch");

			Pass("InputAction_FactoryMethods");
		}
		catch (Exception ex) { Fail("InputAction_FactoryMethods", ex); }
	}

	// ── Helpers ──────────────────────────────────────────────────────

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
