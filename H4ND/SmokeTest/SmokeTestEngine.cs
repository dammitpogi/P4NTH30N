using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.H4ND.Infrastructure;
using P4NTHE0N.H4ND.Navigation;
using P4NTHE0N.H4ND.Parallel;
using P4NTHE0N.H4ND.SmokeTest.Phases;
using P4NTHE0N.H4ND.SmokeTest.Reporting;

namespace P4NTHE0N.H4ND.SmokeTest;

/// <summary>
/// ARCH-099: Main orchestrator with circuit breaker pattern.
/// Executes 4 phases sequentially — halts on first failure.
/// </summary>
public sealed class SmokeTestEngine : IDisposable
{
	private readonly SmokeTestConfig _config;
	private readonly ISmokeTestReporter _reporter;
	private readonly ChromeProfileManager _profileManager;
	private readonly NavigationMapLoader _mapLoader;
	private readonly StepExecutor _stepExecutor;

	// Shared state passed between phases via callbacks
	private CdpConfig? _cdpConfig;
	private ICdpClient? _cdpClient;
	private CanvasBounds _canvasBounds = CanvasBounds.Empty;
	private double _balance;

	private const int TotalPhases = 4;

	public SmokeTestEngine(SmokeTestConfig config, ISmokeTestReporter reporter)
	{
		_config = config;
		_reporter = reporter;

		_profileManager = new ChromeProfileManager(new ChromeProfileConfig
		{
			BasePort = config.Port,
			CleanupProfilesOnDispose = false,
		});

		_mapLoader = new NavigationMapLoader();
		_stepExecutor = StepExecutor.CreateDefault();
	}

	public async Task<SmokeTestResult> ExecuteAsync(CancellationToken ct = default)
	{
		var overallSw = System.Diagnostics.Stopwatch.StartNew();
		var phases = new List<PhaseReport>();

		_reporter.ReportStart(_config);

		try
		{
			// Phase 1: Bootstrap
			var bootstrapPhase = new BootstrapPhase(
				_config,
				_profileManager,
				cdpConfig => _cdpConfig = cdpConfig,
				cdpClient => _cdpClient = cdpClient,
				bounds => _canvasBounds = bounds);

			var bootstrapReport = await ExecutePhaseAsync(bootstrapPhase, phases, ct);
			if (!bootstrapReport.Success)
				return Halt(overallSw, phases, bootstrapPhase, bootstrapReport);

			// Phase 2: Navigation
			var navigationPhase = new NavigationPhase(
				_config,
				() => _cdpClient!,
				bounds => _canvasBounds = bounds);

			var navigationReport = await ExecutePhaseAsync(navigationPhase, phases, ct);
			if (!navigationReport.Success)
				return Halt(overallSw, phases, navigationPhase, navigationReport);

			// Phase 3: Login
			var loginPhase = new LoginPhase(
				_config,
				() => _cdpClient!,
				_mapLoader,
				_stepExecutor);

			var loginReport = await ExecutePhaseAsync(loginPhase, phases, ct);
			if (!loginReport.Success)
				return Halt(overallSw, phases, loginPhase, loginReport);

			// Phase 4: Verification
			var verificationPhase = new VerificationPhase(
				_config,
				() => _cdpClient!,
				balance => _balance = balance);

			var verificationReport = await ExecutePhaseAsync(verificationPhase, phases, ct);
			if (!verificationReport.Success)
				return Halt(overallSw, phases, verificationPhase, verificationReport);

			// All phases passed
			overallSw.Stop();
			string boundsStr = _canvasBounds.IsValid ? $"{_canvasBounds.Width:F0}x{_canvasBounds.Height:F0}" : null!;

			var result = SmokeTestResult.Pass(_config, overallSw.Elapsed, phases, _balance, boundsStr);
			_reporter.ReportResult(result);
			return result;
		}
		catch (OperationCanceledException)
		{
			overallSw.Stop();
			var result = SmokeTestResult.Fatal(_config, "Operation cancelled");
			_reporter.ReportResult(result);
			return result;
		}
		catch (Exception ex)
		{
			overallSw.Stop();
			var result = SmokeTestResult.Fatal(_config, ex.Message);
			_reporter.ReportResult(result);
			return result;
		}
	}

	private async Task<PhaseReport> ExecutePhaseAsync(ISmokeTestPhase phase, List<PhaseReport> phases, CancellationToken ct)
	{
		_reporter.ReportPhaseRunning(phase.Name, phase.PhaseNumber, TotalPhases);
		var report = await phase.ExecuteAsync(ct);
		phases.Add(report);
		_reporter.ReportPhaseComplete(report, phase.PhaseNumber, TotalPhases);
		return report;
	}

	private SmokeTestResult Halt(System.Diagnostics.Stopwatch sw, List<PhaseReport> phases, ISmokeTestPhase failedPhase, PhaseReport failedReport)
	{
		sw.Stop();
		var result = SmokeTestResult.Fail(
			_config, sw.Elapsed, phases,
			failedPhase.Name,
			failedReport.ErrorMessage ?? "Phase failed",
			failedPhase.FailureExitCode);
		_reporter.ReportResult(result);
		return result;
	}

	public void Dispose()
	{
		_cdpClient?.Dispose();
		_profileManager.Dispose();
	}
}
