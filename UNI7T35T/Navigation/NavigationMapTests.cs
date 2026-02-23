using System.Text.Json;
using P4NTH30N.H4ND.Navigation;
using P4NTH30N.H4ND.Navigation.Retry;
using P4NTH30N.H4ND.Navigation.Strategies;
using P4NTH30N.H4ND.Navigation.Verification;
using P4NTH30N.H4ND.Navigation.ErrorHandling;
using P4NTH30N.H4ND.Infrastructure;
using UNI7T35T.Mocks;

namespace P4NTH30N.UNI7T35T.Navigation;

/// <summary>
/// ARCH-098: Unit tests for NavigationMap, NavigationMapLoader, StepExecutor, strategies, and retry.
/// </summary>
public static class NavigationMapTests
{
	private static int _passed;
	private static int _failed;

	public static (int Passed, int Failed) RunAll()
	{
		_passed = 0;
		_failed = 0;

		Run("NAV-001: NavigationMap deserializes from JSON", NAV_001_DeserializeFromJson);
		Run("NAV-002: GetStepsForPhase filters by phase", NAV_002_GetStepsForPhase);
		Run("NAV-003: GetPhases returns distinct phases", NAV_003_GetPhases);
		Run("NAV-004: StepCoordinates HasRelative detects rx/ry", NAV_004_HasRelative);
		Run("NAV-005: NavigationMapLoader caches maps", NAV_005_LoaderCaches);
		Run("NAV-006: NavigationMapLoader returns null for missing platform", NAV_006_LoaderMissing);
		Run("NAV-007: ClickStepStrategy executes click", NAV_007_ClickStrategy);
		Run("NAV-008: WaitStepStrategy respects delay", NAV_008_WaitStrategy);
		Run("NAV-009: NavigateStepStrategy navigates to URL", NAV_009_NavigateStrategy);
		Run("NAV-010: LongPressStepStrategy sends mouse events", NAV_010_LongPressStrategy);
		Run("NAV-011: TypeStepStrategy resolves username from context", NAV_011_TypeStrategy);
		Run("NAV-021: ClipStepStrategy writes clipboard from context", NAV_021_ClipStrategy);
		Run("NAV-012: ExponentialBackoffPolicy calculates delays", NAV_012_BackoffPolicy);
		Run("NAV-013: JavaScriptVerificationStrategy passes empty gates", NAV_013_EmptyGates);
		Run("NAV-014: StepExecutor resolves strategy by action type", NAV_014_ExecutorStrategy);
		Run("NAV-015: StepExecutionResult factories", NAV_015_ResultFactories);
		Run("NAV-016: PhaseExecutionResult factories", NAV_016_PhaseResultFactories);
		Run("NAV-017: NavigationMap GetStepById", NAV_017_GetStepById);
		Run("NAV-018: StepExecutionContext resolves coordinates with canvas bounds", NAV_018_ResolveCoordinates);
		Run("NAV-019: ErrorHandlerChain returns abort by default", NAV_019_ErrorHandlerAbort);
		Run("NAV-020: Disabled steps are filtered out", NAV_020_DisabledStepsFiltered);

		return (_passed, _failed);
	}

	private static void Run(string name, Func<bool> test)
	{
		try
		{
			bool result = test();
			if (result) { _passed++; Console.WriteLine($"  ✅ {name}"); }
			else { _failed++; Console.WriteLine($"  ❌ {name}"); }
		}
		catch (Exception ex)
		{
			_failed++;
			Console.WriteLine($"  ❌ {name}: {ex.Message}");
		}
	}

	// ── NAV-001: Deserialize from JSON ──────────────────────────────────
	private static bool NAV_001_DeserializeFromJson()
	{
		string json = @"{
			""platform"": ""firekirin"",
			""decision"": ""DECISION_077"",
			""sessionNotes"": ""test"",
			""steps"": [
				{
					""stepId"": 1,
					""phase"": ""Login"",
					""action"": ""navigate"",
					""coordinates"": { ""x"": 0, ""y"": 0 },
					""delayMs"": 3000,
					""verification"": { ""entryGate"": ""test"", ""exitGate"": ""test"" },
					""url"": ""http://example.com""
				},
				{
					""stepId"": 2,
					""phase"": ""Login"",
					""action"": ""click"",
					""coordinates"": { ""rx"": 0.5, ""ry"": 0.4, ""x"": 460, ""y"": 367 },
					""delayMs"": 500,
					""verification"": { ""entryGate"": """", ""exitGate"": """" }
				}
			],
			""metadata"": { ""created"": ""2026-02-21"", ""modified"": ""2026-02-22"" }
		}";

		var map = JsonSerializer.Deserialize<NavigationMap>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
		if (map == null) return false;
		if (map.Platform != "firekirin") return false;
		if (map.Decision != "DECISION_077") return false;
		if (map.Steps.Count != 2) return false;
		if (map.Steps[0].Action != "navigate") return false;
		if (map.Steps[0].Url != "http://example.com") return false;
		if (map.Steps[1].Coordinates.Rx != 0.5) return false;
		return true;
	}

	// ── NAV-002: GetStepsForPhase ───────────────────────────────────────
	private static bool NAV_002_GetStepsForPhase()
	{
		var map = CreateTestMap();
		var loginSteps = map.GetStepsForPhase("Login").ToList();
		var spinSteps = map.GetStepsForPhase("Spin").ToList();
		if (loginSteps.Count != 3) return false; // navigate + click + type
		if (spinSteps.Count != 1) return false;  // longpress
		return true;
	}

	// ── NAV-003: GetPhases ──────────────────────────────────────────────
	private static bool NAV_003_GetPhases()
	{
		var map = CreateTestMap();
		var phases = map.GetPhases();
		if (phases.Count != 3) return false; // Login, Spin, Logout
		if (phases[0] != "Login") return false;
		if (phases[1] != "Spin") return false;
		if (phases[2] != "Logout") return false;
		return true;
	}

	// ── NAV-004: HasRelative ────────────────────────────────────────────
	private static bool NAV_004_HasRelative()
	{
		var withRelative = new StepCoordinates { Rx = 0.5, Ry = 0.4, X = 460, Y = 367 };
		var withoutRelative = new StepCoordinates { Rx = 0, Ry = 0, X = 460, Y = 367 };
		if (!withRelative.HasRelative) return false;
		if (withoutRelative.HasRelative) return false;
		return true;
	}

	// ── NAV-005: Loader caches ──────────────────────────────────────────
	private static bool NAV_005_LoaderCaches()
	{
		// Use the actual recorder directory
		var loader = new NavigationMapLoader(@"C:\P4NTH30N\H4ND\tools\recorder");
		var map1 = loader.Load("firekirin");
		var map2 = loader.Load("firekirin");

		if (map1 == null) return false;
		if (!ReferenceEquals(map1, map2)) return false; // Same cached instance
		if (loader.CachedPlatforms.Count < 1) return false;
		return true;
	}

	// ── NAV-006: Loader missing platform ────────────────────────────────
	private static bool NAV_006_LoaderMissing()
	{
		var loader = new NavigationMapLoader(@"C:\P4NTH30N\H4ND\tools\recorder");
		var map = loader.Load("nonexistent_platform_xyz");
		// Should return null (falls through to generic step-config.json which exists)
		// Actually the generic exists, so it will load. Test with a truly empty dir instead.
		var emptyLoader = new NavigationMapLoader(Path.GetTempPath());
		var missing = emptyLoader.Load("nonexistent_platform_xyz");
		return missing == null;
	}

	// ── NAV-007: ClickStepStrategy ──────────────────────────────────────
	private static bool NAV_007_ClickStrategy()
	{
		var strategy = new ClickStepStrategy();
		if (strategy.ActionType != "click") return false;

		var cdp = new MockCdpClient();
		var step = new NavigationStep
		{
			StepId = 1,
			Action = "click",
			Coordinates = new StepCoordinates { X = 460, Y = 367 },
		};
		var context = new StepExecutionContext
		{
			CdpClient = cdp,
			Platform = "firekirin",
			WorkerId = "test",
		};

		strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();
		return true; // ClickAtAsync was called on mock (doesn't throw)
	}

	// ── NAV-008: WaitStepStrategy ───────────────────────────────────────
	private static bool NAV_008_WaitStrategy()
	{
		var strategy = new WaitStepStrategy();
		if (strategy.ActionType != "wait") return false;

		var cdp = new MockCdpClient();
		var step = new NavigationStep { StepId = 1, Action = "wait", DelayMs = 50 };
		var context = new StepExecutionContext { CdpClient = cdp, Platform = "test", WorkerId = "test" };

		var sw = System.Diagnostics.Stopwatch.StartNew();
		strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();
		sw.Stop();

		return sw.ElapsedMilliseconds >= 40; // At least 40ms of the 50ms delay
	}

	// ── NAV-009: NavigateStepStrategy ───────────────────────────────────
	private static bool NAV_009_NavigateStrategy()
	{
		var strategy = new NavigateStepStrategy();
		if (strategy.ActionType != "navigate") return false;

		var cdp = new MockCdpClient();
		var step = new NavigationStep { StepId = 1, Action = "navigate", Url = "http://test.com" };
		var context = new StepExecutionContext { CdpClient = cdp, Platform = "test", WorkerId = "test" };

		strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();

		return cdp.NavigatedUrls.Contains("http://test.com");
	}

	// ── NAV-010: LongPressStepStrategy ──────────────────────────────────
	private static bool NAV_010_LongPressStrategy()
	{
		var strategy = new LongPressStepStrategy();
		if (strategy.ActionType != "longpress") return false;

		var cdp = new MockCdpClient();
		var step = new NavigationStep
		{
			StepId = 1,
			Action = "longpress",
			Coordinates = new StepCoordinates { X = 860, Y = 655 },
			HoldMs = 100, // Short for testing
		};
		var context = new StepExecutionContext { CdpClient = cdp, Platform = "test", WorkerId = "test" };

		strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();

		// Should have sent mousePressed and mouseReleased
		if (cdp.SentCommands.Count < 2) return false;
		if (cdp.SentCommands[0].method != "Input.dispatchMouseEvent") return false;
		if (cdp.SentCommands[1].method != "Input.dispatchMouseEvent") return false;
		return true;
	}

	// ── NAV-011: TypeStepStrategy resolves username ─────────────────────
	private static bool NAV_011_TypeStrategy()
	{
		var strategy = new TypeStepStrategy();
		if (strategy.ActionType != "type") return false;

		var cdp = new MockCdpClient();
		var step = new NavigationStep
		{
			StepId = 3,
			Phase = "Login",
			Action = "type",
			Comment = "Username Field",
			Input = "JustinHu21", // Template credential from recorder
			Verification = new StepVerification { EntryGate = "Account field focused", ExitGate = "" },
		};
		var context = new StepExecutionContext
		{
			CdpClient = cdp,
			Platform = "firekirin",
			Username = "RealUser123", // Actual runtime credential
			Password = "RealPass456",
			WorkerId = "test",
		};

		strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();

		// Should have typed 11 chars (length of "RealUser123") via dispatchKeyEvent
		int charEvents = cdp.SentCommands.Count(c => c.method == "Input.dispatchKeyEvent");
		return charEvents == 11; // "RealUser123" = 11 chars
	}

	// ── NAV-021: ClipStepStrategy writes clipboard text ────────────────
	private static bool NAV_021_ClipStrategy()
	{
		var strategy = new ClipStepStrategy();
		if (strategy.ActionType != "clip") return false;

		var cdp = new MockCdpClient();
		var step = new NavigationStep
		{
			StepId = 4,
			Phase = "Login",
			Action = "clip",
			Comment = "Username to Clipboard",
			Input = "TemplateUser",
			Verification = new StepVerification(),
		};
		var context = new StepExecutionContext
		{
			CdpClient = cdp,
			Platform = "orionstars",
			Username = "ActualUser",
			Password = "ActualPass",
			WorkerId = "test",
		};

		strategy.ExecuteAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();

		bool granted = cdp.SentCommands.Any(c => c.method == "Browser.grantPermissions");
		bool wroteClipboard = cdp.SentCommands.Any(c =>
			c.method == "Runtime.evaluate"
			&& c.parameters?.ToString()?.Contains("navigator.clipboard.writeText('ActualUser')", StringComparison.Ordinal) == true);

		return granted && wroteClipboard;
	}

	// ── NAV-012: ExponentialBackoffPolicy ───────────────────────────────
	private static bool NAV_012_BackoffPolicy()
	{
		var policy = new ExponentialBackoffPolicy { InitialDelay = TimeSpan.FromSeconds(1), JitterFraction = 0 };
		var d1 = policy.CalculateDelay(1); // 1s
		var d2 = policy.CalculateDelay(2); // 2s
		var d3 = policy.CalculateDelay(3); // 4s

		if (Math.Abs(d1.TotalSeconds - 1.0) > 0.1) return false;
		if (Math.Abs(d2.TotalSeconds - 2.0) > 0.1) return false;
		if (Math.Abs(d3.TotalSeconds - 4.0) > 0.1) return false;
		if (policy.MaxRetries != 3) return false;
		return true;
	}

	// ── NAV-013: Empty gates pass ───────────────────────────────────────
	private static bool NAV_013_EmptyGates()
	{
		var verification = new JavaScriptVerificationStrategy();
		var cdp = new MockCdpClient();
		var context = new StepExecutionContext { CdpClient = cdp, Platform = "test", WorkerId = "test" };

		bool empty = verification.VerifyAsync("", context, CancellationToken.None).GetAwaiter().GetResult();
		bool whitespace = verification.VerifyAsync("   ", context, CancellationToken.None).GetAwaiter().GetResult();
		bool descriptive = verification.VerifyAsync("Lobby visible with categories", context, CancellationToken.None).GetAwaiter().GetResult();

		return empty && whitespace && descriptive;
	}

	// ── NAV-014: StepExecutor resolves strategy ─────────────────────────
	private static bool NAV_014_ExecutorStrategy()
	{
		var executor = StepExecutor.CreateDefault();
		var cdp = new MockCdpClient();
		var step = new NavigationStep
		{
			StepId = 1,
			Action = "wait",
			DelayMs = 10,
			Verification = new StepVerification(),
		};
		var context = new StepExecutionContext { CdpClient = cdp, Platform = "test", WorkerId = "test" };

		var result = executor.ExecuteStepAsync(step, context, CancellationToken.None).GetAwaiter().GetResult();
		return result.Success;
	}

	// ── NAV-015: StepExecutionResult factories ──────────────────────────
	private static bool NAV_015_ResultFactories()
	{
		var success = StepExecutionResult.Succeeded(1, TimeSpan.FromSeconds(1));
		var failure = StepExecutionResult.Failed(2, "test error", TimeSpan.FromSeconds(2));
		var gotoResult = StepExecutionResult.Goto(3, 1, TimeSpan.FromSeconds(0.5));

		if (!success.Success) return false;
		if (success.StepId != 1) return false;
		if (failure.Success) return false;
		if (failure.ErrorMessage != "test error") return false;
		if (!gotoResult.Success) return false;
		if (gotoResult.GotoStepId != 1) return false;
		if (gotoResult.RecoveryAction != "goto") return false;
		return true;
	}

	// ── NAV-016: PhaseExecutionResult factories ─────────────────────────
	private static bool NAV_016_PhaseResultFactories()
	{
		var steps = new List<StepExecutionResult> { StepExecutionResult.Succeeded(1, TimeSpan.FromSeconds(1)) };
		var success = PhaseExecutionResult.Succeeded("Login", steps, TimeSpan.FromSeconds(2));
		var failure = PhaseExecutionResult.Failed("Login", steps, TimeSpan.FromSeconds(2), "fail");

		if (!success.Success) return false;
		if (success.Phase != "Login") return false;
		if (success.StepResults.Count != 1) return false;
		if (failure.Success) return false;
		if (failure.ErrorMessage != "fail") return false;
		return true;
	}

	// ── NAV-017: GetStepById ────────────────────────────────────────────
	private static bool NAV_017_GetStepById()
	{
		var map = CreateTestMap();
		var step1 = map.GetStepById(1);
		var step3 = map.GetStepById(3);
		var missing = map.GetStepById(999);

		if (step1 == null) return false;
		if (step1.Action != "navigate") return false;
		if (step3 == null) return false;
		if (step3.Action != "type") return false;
		if (missing != null) return false;
		return true;
	}

	// ── NAV-018: ResolveCoordinates ─────────────────────────────────────
	private static bool NAV_018_ResolveCoordinates()
	{
		var cdp = new MockCdpClient();
		var context = new StepExecutionContext
		{
			CdpClient = cdp,
			Platform = "test",
			WorkerId = "test",
			CanvasBounds = new CanvasBounds(0, 0, 930, 865),
		};

		// Step with relative coordinates
		var step = new NavigationStep
		{
			Coordinates = new StepCoordinates { Rx = 0.5, Ry = 0.5, X = 460, Y = 430 },
		};

		var (x, y) = context.ResolveCoordinates(step);
		// 0.5 * 930 = 465, 0.5 * 865 = 432.5 ≈ 433
		if (Math.Abs(x - 465) > 1) return false;
		if (Math.Abs(y - 433) > 1) return false;

		// Step without relative coordinates — should use fallback
		var stepNoRelative = new NavigationStep
		{
			Coordinates = new StepCoordinates { Rx = 0, Ry = 0, X = 460, Y = 430 },
		};
		var (x2, y2) = context.ResolveCoordinates(stepNoRelative);
		if (x2 != 460) return false;
		if (y2 != 430) return false;

		return true;
	}

	// ── NAV-019: ErrorHandlerChain aborts by default ────────────────────
	private static bool NAV_019_ErrorHandlerAbort()
	{
		var handler = new ErrorHandlerChain();
		var cdp = new MockCdpClient();
		var step = new NavigationStep { StepId = 5, Action = "click", TakeScreenshot = false };
		var context = new StepExecutionContext { CdpClient = cdp, Platform = "test", WorkerId = "test" };

		var result = handler.HandleAsync(step, context, new Exception("test error"), CancellationToken.None)
			.GetAwaiter().GetResult();

		if (result.Action != ErrorAction.Abort) return false;
		if (!result.Message.Contains("test error")) return false;
		return true;
	}

	// ── NAV-020: Disabled steps filtered ────────────────────────────────
	private static bool NAV_020_DisabledStepsFiltered()
	{
		var map = new NavigationMap
		{
			Platform = "test",
			Steps = new List<NavigationStep>
			{
				new() { StepId = 1, Phase = "Login", Enabled = true, Action = "click" },
				new() { StepId = 2, Phase = "Login", Enabled = false, Action = "type" },
				new() { StepId = 3, Phase = "Login", Enabled = true, Action = "wait" },
			},
		};

		var steps = map.GetStepsForPhase("Login").ToList();
		if (steps.Count != 2) return false; // Only enabled steps
		if (steps[0].StepId != 1) return false;
		if (steps[1].StepId != 3) return false;
		return true;
	}

	// ── Helper: Create a test NavigationMap ──────────────────────────────
	private static NavigationMap CreateTestMap()
	{
		return new NavigationMap
		{
			Platform = "firekirin",
			Decision = "DECISION_098",
			Steps = new List<NavigationStep>
			{
				new() { StepId = 1, Phase = "Login", Enabled = true, Action = "navigate", Url = "http://test.com", DelayMs = 10, Verification = new() },
				new() { StepId = 2, Phase = "Login", Enabled = true, Action = "click", Coordinates = new() { Rx = 0.5, Ry = 0.4, X = 460, Y = 367 }, DelayMs = 10, Verification = new() },
				new() { StepId = 3, Phase = "Login", Enabled = true, Action = "type", Input = "test", Comment = "Username Field", DelayMs = 10, Verification = new() { EntryGate = "Account field focused" } },
				new() { StepId = 4, Phase = "Spin", Enabled = true, Action = "longpress", Coordinates = new() { X = 860, Y = 655 }, HoldMs = 50, DelayMs = 10, Verification = new() },
				new() { StepId = 5, Phase = "Logout", Enabled = true, Action = "navigate", Url = "http://test.com", DelayMs = 10, Verification = new() },
			},
		};
	}
}
