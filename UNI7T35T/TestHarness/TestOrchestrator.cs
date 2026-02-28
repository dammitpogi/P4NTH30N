using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using MongoDB.Driver;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;

namespace P4NTHE0N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Main E2E test orchestrator.
/// Coordinates the full signal-to-spin testing pipeline:
/// Signal Injection → Login → Page Readiness → Spin → Splash Detection → Vision Capture → Report.
/// </summary>
public sealed class TestOrchestrator
{
	private readonly TestConfiguration _config;
	private readonly IMongoDatabase? _database;
	private readonly Func<ICdpClient>? _cdpFactory;
	private readonly List<TestResult> _results = new();
	private readonly string _testRunId;

	/// <summary>
	/// All test results collected during this orchestration run.
	/// </summary>
	public IReadOnlyList<TestResult> Results => _results;

	/// <summary>
	/// Creates a test orchestrator.
	/// </summary>
	/// <param name="config">Test configuration.</param>
	/// <param name="database">MongoDB database (null for dry-run mode).</param>
	/// <param name="cdpFactory">Factory to create CDP clients (null for mock mode).</param>
	public TestOrchestrator(TestConfiguration config, IMongoDatabase? database = null, Func<ICdpClient>? cdpFactory = null)
	{
		_config = config;
		_database = database;
		_cdpFactory = cdpFactory;
		_testRunId = $"E2E-{DateTime.UtcNow:yyyyMMdd-HHmmss}";
	}

	/// <summary>
	/// Runs the full E2E test suite for all configured games.
	/// </summary>
	public async Task<TestSummary> RunAllAsync(CancellationToken ct = default)
	{
		Console.WriteLine($"\n╔══════════════════════════════════════════════╗");
		Console.WriteLine($"║  E2E TEST ORCHESTRATOR - Run: {_testRunId}");
		Console.WriteLine($"║  Games: {string.Join(", ", _config.TargetGames)}");
		Console.WriteLine($"╚══════════════════════════════════════════════╝\n");

		Stopwatch totalSw = Stopwatch.StartNew();

		foreach (string game in _config.TargetGames)
		{
			if (!_config.TestAccounts.TryGetValue(game, out TestAccount? account))
			{
				TestResult skip = new()
				{
					TestRunId = _testRunId,
					TestName = $"E2E_{game}_Full",
					Category = "E2E",
					Game = game,
				};
				skip.Skip($"No test account configured for {game}");
				_results.Add(skip);
				continue;
			}

			if (ct.IsCancellationRequested) break;

			await RunGameTestSuiteAsync(game, account, ct);
		}

		totalSw.Stop();

		// Generate report
		TestReportGenerator reporter = new(
			_database,
			_config.PersistResults ? @"C:\P4NTHE0N\test-results" : null
		);

		TestSummary summary = await reporter.GenerateSummaryAsync(_results, _testRunId, ct);

		// Save individual results
		foreach (TestResult result in _results)
		{
			await reporter.SaveResultAsync(result, ct);
		}

		return summary;
	}

	/// <summary>
	/// Runs the full test suite for a single game platform.
	/// </summary>
	private async Task RunGameTestSuiteAsync(string game, TestAccount account, CancellationToken ct)
	{
		Console.WriteLine($"\n── {game} Test Suite ──────────────────────────\n");

		// Phase 1: Signal Injection
		TestResult signalResult = await RunSignalInjectionTestAsync(game, account, ct);
		_results.Add(signalResult);

		// Phase 2: Login Validation (requires CDP)
		TestResult loginResult = await RunLoginTestAsync(game, account, ct);
		_results.Add(loginResult);

		// Phase 3: Game Readiness Check
		if (loginResult.Status == TestStatus.Passed)
		{
			TestResult readinessResult = await RunGameReadinessTestAsync(game, account, ct);
			_results.Add(readinessResult);

			// Phase 4: Spin Execution
			if (readinessResult.Status == TestStatus.Passed)
			{
				TestResult spinResult = await RunSpinTestAsync(game, account, ct);
				_results.Add(spinResult);

				// Phase 5: Vision Capture
				if (_config.CaptureFrames)
				{
					TestResult captureResult = await RunVisionCaptureTestAsync(game, account, ct);
					_results.Add(captureResult);
				}
			}
		}

		// Cleanup: logout
		await TryLogoutAsync(game, ct);
	}

	/// <summary>
	/// Phase 1: Test signal injection into MongoDB.
	/// </summary>
	private async Task<TestResult> RunSignalInjectionTestAsync(string game, TestAccount account, CancellationToken ct)
	{
		TestResult result = new()
		{
			TestRunId = _testRunId,
			TestName = $"E2E_{game}_SignalInjection",
			Category = "SignalInjection",
			Game = game,
			House = account.House,
			Username = account.Username,
		};

		if (_database == null)
		{
			result.Skip("No MongoDB connection — signal injection skipped");
			return result;
		}

		try
		{
			TestSignalInjector injector = new(_database, _testRunId);
			var signalId = await injector.InjectSignalAsync(account, _config.TestSignalPriority, ct);
			result.Metadata["signalId"] = signalId.ToString();
			result.Pass($"Signal {signalId} injected for P{_config.TestSignalPriority}");

			// Cleanup test signal immediately (we're testing injection, not consumption)
			if (_config.CleanupTestSignals)
			{
				await injector.CleanupAsync(ct);
			}
		}
		catch (Exception ex)
		{
			result.Fail(ex.Message, ex.StackTrace);
		}

		return result;
	}

	/// <summary>
	/// Phase 2: Test login via CDP.
	/// </summary>
	private async Task<TestResult> RunLoginTestAsync(string game, TestAccount account, CancellationToken ct)
	{
		TestResult result = new()
		{
			TestRunId = _testRunId,
			TestName = $"E2E_{game}_Login",
			Category = "Login",
			Game = game,
			House = account.House,
			Username = account.Username,
		};

		if (_cdpFactory == null)
		{
			result.Skip("No CDP factory — login test skipped");
			return result;
		}

		CdpTestClient? cdpTest = null;
		try
		{
			ICdpClient cdp = _cdpFactory();
			cdpTest = new CdpTestClient(cdp);

			if (!await cdpTest.ConnectAsync(ct))
			{
				result.Fail("CDP connection failed");
				return result;
			}

			LoginValidator validator = new(cdpTest);
			LoginValidationResult loginResult = await validator.ValidateLoginAsync(account, ct);

			result.Metadata["loginSuccess"] = loginResult.LoginSuccess.ToString();
			result.Metadata["pageReady"] = loginResult.PageReady.ToString();

			if (loginResult.LoginSuccess)
				result.Pass($"Login successful, page ready: {loginResult.PageReady}");
			else
				result.Fail(loginResult.ErrorMessage ?? "Login failed");
		}
		catch (Exception ex)
		{
			result.Fail(ex.Message, ex.StackTrace);
		}
		finally
		{
			cdpTest?.Dispose();
		}

		return result;
	}

	/// <summary>
	/// Phase 3: Test game page readiness.
	/// </summary>
	private async Task<TestResult> RunGameReadinessTestAsync(string game, TestAccount account, CancellationToken ct)
	{
		TestResult result = new()
		{
			TestRunId = _testRunId,
			TestName = $"E2E_{game}_GameReadiness",
			Category = "GameReadiness",
			Game = game,
			House = account.House,
			Username = account.Username,
		};

		if (_cdpFactory == null)
		{
			result.Skip("No CDP factory — readiness test skipped");
			return result;
		}

		CdpTestClient? cdpTest = null;
		try
		{
			ICdpClient cdp = _cdpFactory();
			cdpTest = new CdpTestClient(cdp);

			if (!await cdpTest.ConnectAsync(ct))
			{
				result.Fail("CDP connection failed");
				return result;
			}

			GameReadinessChecker checker = new(cdpTest);
			GameReadinessResult readiness = await checker.CheckReadinessAsync(game, ct: ct);

			result.Metadata["pageReady"] = readiness.PageReady.ToString();
			result.Metadata["attemptsNeeded"] = readiness.AttemptsNeeded.ToString();
			result.Metadata["jackpotsViaCdp"] = readiness.JackpotsAvailableViaCdp.ToString();
			result.ObservedJackpots = new()
			{
				["Grand"] = readiness.CdpGrand,
				["Major"] = readiness.CdpMajor,
				["Minor"] = readiness.CdpMinor,
				["Mini"] = readiness.CdpMini,
			};

			if (readiness.PageReady)
				result.Pass($"Page ready in {readiness.AttemptsNeeded} attempts");
			else
				result.Fail(readiness.LastError ?? "Page readiness check failed");
		}
		catch (Exception ex)
		{
			result.Fail(ex.Message, ex.StackTrace);
		}
		finally
		{
			cdpTest?.Dispose();
		}

		return result;
	}

	/// <summary>
	/// Phase 4: Test spin execution.
	/// </summary>
	private async Task<TestResult> RunSpinTestAsync(string game, TestAccount account, CancellationToken ct)
	{
		TestResult result = new()
		{
			TestRunId = _testRunId,
			TestName = $"E2E_{game}_SpinExecution",
			Category = "SpinExecution",
			Game = game,
			House = account.House,
			Username = account.Username,
		};

		if (_cdpFactory == null)
		{
			result.Skip("No CDP factory — spin test skipped");
			return result;
		}

		CdpTestClient? cdpTest = null;
		try
		{
			ICdpClient cdp = _cdpFactory();
			cdpTest = new CdpTestClient(cdp);

			if (!await cdpTest.ConnectAsync(ct))
			{
				result.Fail("CDP connection failed");
				return result;
			}

			SpinExecutor executor = new(cdpTest);
			SpinResult spinResult = await executor.ExecuteSpinAsync(game, ct);

			result.Metadata["spinSuccess"] = spinResult.Success.ToString();
			result.Metadata["spinDurationMs"] = spinResult.DurationMs.ToString();

			// Check for splash after spin
			SplashDetector detector = new(cdpTest);
			SplashDetectionResult splash = await detector.DetectSplashAsync(game, ct);
			result.Metadata["splashDetected"] = splash.SplashDetected.ToString();
			result.Metadata["splashMethod"] = splash.DetectionMethod;

			if (spinResult.Success)
				result.Pass($"Spin executed in {spinResult.DurationMs}ms, splash: {splash.SplashDetected}");
			else
				result.Fail(spinResult.ErrorMessage ?? "Spin failed");
		}
		catch (Exception ex)
		{
			result.Fail(ex.Message, ex.StackTrace);
		}
		finally
		{
			cdpTest?.Dispose();
		}

		return result;
	}

	/// <summary>
	/// Phase 5: Capture vision training frames.
	/// </summary>
	private async Task<TestResult> RunVisionCaptureTestAsync(string game, TestAccount account, CancellationToken ct)
	{
		TestResult result = new()
		{
			TestRunId = _testRunId,
			TestName = $"E2E_{game}_VisionCapture",
			Category = "VisionCapture",
			Game = game,
			House = account.House,
			Username = account.Username,
		};

		if (_cdpFactory == null)
		{
			result.Skip("No CDP factory — vision capture skipped");
			return result;
		}

		CdpTestClient? cdpTest = null;
		try
		{
			ICdpClient cdp = _cdpFactory();
			cdpTest = new CdpTestClient(cdp);

			if (!await cdpTest.ConnectAsync(ct))
			{
				result.Fail("CDP connection failed");
				return result;
			}

			string outputDir = Path.Combine(_config.FrameOutputDirectory, game, _testRunId);
			VisionCapture capture = new(cdpTest, outputDir);

			int captured = await capture.CaptureBurstAsync(
				_config.FramesPerTest,
				intervalMs: 200,
				label: $"{game}_e2e",
				ct
			);

			result.CapturedFrames.AddRange(capture.CapturedFrames);
			result.Metadata["framesCaptured"] = captured.ToString();
			result.Metadata["outputDirectory"] = outputDir;

			if (captured >= _config.FramesPerTest / 2) // At least half captured
				result.Pass($"{captured}/{_config.FramesPerTest} frames captured");
			else
				result.Fail($"Only {captured}/{_config.FramesPerTest} frames captured");
		}
		catch (Exception ex)
		{
			result.Fail(ex.Message, ex.StackTrace);
		}
		finally
		{
			cdpTest?.Dispose();
		}

		return result;
	}

	/// <summary>
	/// Best-effort logout after test suite.
	/// </summary>
	private async Task TryLogoutAsync(string game, CancellationToken ct)
	{
		if (_cdpFactory == null) return;

		try
		{
			using ICdpClient cdp = _cdpFactory();
			using CdpTestClient cdpTest = new(cdp);
			if (await cdpTest.ConnectAsync(ct))
			{
				LoginValidator validator = new(cdpTest);
				await validator.ValidateLogoutAsync(game, ct);
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[TestOrchestrator] Logout cleanup failed: {ex.Message}");
		}
	}
}
