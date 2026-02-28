using P4NTHE0N.UNI7T35T.Tests;
using P4NTHE0N.UNI7T35T.Stability;
using P4NTHE0N.UNI7T35T.Sampling;
using P4NTHE0N.UNI7T35T.PostProcessing;
using P4NTHE0N.UNI7T35T.Quality;
using P4NTHE0N.UNI7T35T.Integration;
using P4NTHE0N.UNI7T35T.Navigation;
using P4NTHE0N.UNI7T35T.H4ND.Decision110;
using P4NTHE0N.UNI7T35T.H4ND.Decision113;
using P4NTHE0N.UNI7T35T.H0UND.Decision113;
using UNI7T35T.Mocks;
using UNI7T35T.Tests;
using P4NTH35T.Tests;
using EndToEndTests = P4NTHE0N.UNI7T35T.Tests.EndToEndTests;

namespace UNI7T35T;

class Program
{
	static async Task<int> Main(string[] args)
	{
		Console.WriteLine("╔════════════════════════════════════════════════════════════════════╗");
		Console.WriteLine("║          UNI7T35T - P4NTHE0N Test Platform                        ║");
		Console.WriteLine("║          H0UND Analytics + Security + Pipeline Test Suite          ║");
		Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

		int totalTests = 0;
		int passedTests = 0;

		if (args.Any(a => string.Equals(a, "--decision113-only", StringComparison.OrdinalIgnoreCase)))
		{
			Console.WriteLine("Running Hotspot Fault Harness only (DECISION_113)...\n");
			(int d113PassedOnly, int d113FailedOnly) = HotspotFaultHarnessTests.RunAll();
			totalTests = d113PassedOnly + d113FailedOnly;
			passedTests = d113PassedOnly;

			Console.WriteLine("\n╔════════════════════════════════════════════════════════════════════╗");
			Console.WriteLine($"║  TEST SUMMARY: {passedTests}/{totalTests} tests passed                                   ║");
			Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

			return d113FailedOnly == 0 ? 0 : 1;
		}

		if (args.Any(a => string.Equals(a, "--decision113-outage-only", StringComparison.OrdinalIgnoreCase)))
		{
			Console.WriteLine("Running Mongo Outage Degradation only (DECISION_113)...\n");
			(int d113OutagePassedOnly, int d113OutageFailedOnly) = MongoOutageDegradationTests.RunAll();
			totalTests = d113OutagePassedOnly + d113OutageFailedOnly;
			passedTests = d113OutagePassedOnly;

			Console.WriteLine("\n╔════════════════════════════════════════════════════════════════════╗");
			Console.WriteLine($"║  TEST SUMMARY: {passedTests}/{totalTests} tests passed                                   ║");
			Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

			return d113OutageFailedOnly == 0 ? 0 : 1;
		}

		if (args.Any(a => string.Equals(a, "--decision113-h0und-only", StringComparison.OrdinalIgnoreCase)))
		{
			Console.WriteLine("Running H0UND Error Evidence Rollout only (DECISION_113)...\n");
			(int d113H0undPassedOnly, int d113H0undFailedOnly) = H0UNDErrorEvidenceRolloutTests.RunAll();
			totalTests = d113H0undPassedOnly + d113H0undFailedOnly;
			passedTests = d113H0undPassedOnly;

			Console.WriteLine("\n╔════════════════════════════════════════════════════════════════════╗");
			Console.WriteLine($"║  TEST SUMMARY: {passedTests}/{totalTests} tests passed                                   ║");
			Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

			return d113H0undFailedOnly == 0 ? 0 : 1;
		}

		// ── ForecastingService Tests ──────────────────────────────────────
		Console.WriteLine("Running ForecastingService Tests...\n");
		ForecastingServiceTests forecastingTests = new ForecastingServiceTests();

		// Test 1: Bug Reproduction
		totalTests++;
		forecastingTests.Setup();
		if (forecastingTests.ReproduceDateTimeOverflowBug())
		{
			passedTests++;
		}

		// Test 2: Normal Cases
		totalTests++;
		forecastingTests.Setup();
		if (forecastingTests.TestCalculateMinutesToValue_NormalCases())
		{
			passedTests++;
		}

		// ── EncryptionService Tests (INFRA-009) ──────────────────────────
		Console.WriteLine("\nRunning EncryptionService Tests...\n");
		EncryptionServiceTests encTests = new EncryptionServiceTests();

		Func<bool>[] encryptionTestMethods =
		[
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestKeyGenerationAndLoading();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestEncryptDecryptRoundTrip();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestNonceUniqueness();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestTamperDetection();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestCompactStringRoundTrip();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestDifferentKeysProduceDifferentCiphertext();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestPreventAccidentalKeyOverwrite();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestInvalidCompactStringFormats();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
			() =>
			{
				encTests.Setup();
				try
				{
					return encTests.TestKeyDerivationDeterminism();
				}
				finally
				{
					encTests.Cleanup();
				}
			},
		];

		foreach (Func<bool> test in encryptionTestMethods)
		{
			totalTests++;
			if (test())
			{
				passedTests++;
			}
		}

		// ── Idempotent Signal Generation Tests (ADR-002) ────────────────
		Console.WriteLine("\nRunning Idempotent Signal Generation Tests...\n");
		(int idempotentPassed, int idempotentFailed) = IdempotentSignalTests.RunAll();
		totalTests += idempotentPassed + idempotentFailed;
		passedTests += idempotentPassed;

		// ── Pipeline Integration Tests (WIN-001) ────────────────────────
		Console.WriteLine("\nRunning Pipeline Integration Tests...\n");
		(int pipelinePassed, int pipelineFailed) = PipelineIntegrationTests.RunAll();
		totalTests += pipelinePassed + pipelineFailed;
		passedTests += pipelinePassed;

		// ── CircuitBreaker State Transition Tests (PROD-003) ─────────
		Console.WriteLine("\nRunning CircuitBreaker Tests...\n");
		(int cbPassed, int cbFailed) = CircuitBreakerTests.RunAll();
		totalTests += cbPassed + cbFailed;
		passedTests += cbPassed;

		// ── DPD Calculator Edge Case Tests (PROD-003) ───────────────
		Console.WriteLine("\nRunning DPD Calculator Tests...\n");
		(int dpdPassed, int dpdFailed) = DpdCalculatorTests.RunAll();
		totalTests += dpdPassed + dpdFailed;
		passedTests += dpdPassed;

		// ── SignalService Generation Tests (PROD-003) ───────────────
		Console.WriteLine("\nRunning SignalService Tests...\n");
		(int sigPassed, int sigFailed) = SignalServiceTests.RunAll();
		totalTests += sigPassed + sigFailed;
		passedTests += sigPassed;

		// ── CdpGameActions Tests (OPS_009) ─────────────────────────────
		Console.WriteLine("\nRunning CdpGameActions Tests (OPS_009)...\n");
		(int cdpPassed, int cdpFailed) = CdpGameActionsTests.RunAll();
		totalTests += cdpPassed + cdpFailed;
		passedTests += cdpPassed;

		// ── E2E Test Harness Tests (TEST-035) ─────────────────────────
		Console.WriteLine("\nRunning E2E Test Harness Tests (TEST-035)...\n");
		(int e2ePassed, int e2eFailed) = EndToEndTests.RunAll();
		totalTests += e2ePassed + e2eFailed;
		passedTests += e2ePassed;

		// ── FirstSpinController Tests (SPIN-044) ──────────────────────
		Console.WriteLine("\nRunning FirstSpinController Tests...\n");
		(int fsPassed, int fsFailed) = FirstSpinControllerTests.RunAll();
		totalTests += fsPassed + fsFailed;
		passedTests += fsPassed;

		// ── FourEyes Vision Test (FEAT-036) ────────────────────────────────
		Console.WriteLine("\nRunning FourEyes Vision Pipeline Test...\n");
		try
		{
			await FourEyesVisionTest.RunAsync();
			totalTests++;
			passedTests++;
			Console.WriteLine("✅ FourEyes vision test completed");
		}
		catch (Exception ex)
		{
			totalTests++;
			Console.WriteLine($"❌ FourEyes vision test failed: {ex.Message}");
		}

		// ── Parallel Execution Tests (ARCH-047) ───────────────────────────
		Console.WriteLine("\nRunning Parallel Execution Tests (ARCH-047)...\n");
		(int parPassed, int parFailed) = ParallelExecutionTests.RunAll();
		totalTests += parPassed + parFailed;
		passedTests += parPassed;

		// ── Production Readiness Evaluator Tests (DECISION_110) ──────────
		Console.WriteLine("\nRunning Production Readiness Evaluator Tests (DECISION_110)...\n");
		(int prepPassed, int prepFailed) = ProductionReadinessEvaluatorTests.RunAll();
		totalTests += prepPassed + prepFailed;
		passedTests += prepPassed;

		// ── Session Renewal Tests (AUTH-041) ───────────────────────────────
		Console.WriteLine("\nRunning Session Renewal Tests (AUTH-041)...\n");
		(int srPassed, int srFailed) = SessionRenewalTests.RunAll();
		totalTests += srPassed + srFailed;
		passedTests += srPassed;

		// ── Signal Generator Tests (ARCH-055) ─────────────────────────────
		Console.WriteLine("\nRunning Signal Generator Tests (ARCH-055)...\n");
		(int sgPassed, int sgFailed) = SignalGeneratorTests.RunAll();
		totalTests += sgPassed + sgFailed;
		passedTests += sgPassed;

		// ── System Health Report Tests (ARCH-055) ─────────────────────────
		Console.WriteLine("\nRunning System Health Report Tests (ARCH-055)...\n");
		(int shPassed, int shFailed) = SystemHealthReportTests.RunAll();
		totalTests += shPassed + shFailed;
		passedTests += shPassed;

		// ── Anomaly Detector Tests (DECISION_025) ────────────────────────
		Console.WriteLine("\nRunning Anomaly Detector Tests...\n");
		(int adPassed, int adFailed) = AnomalyDetectorTests.RunAll();
		totalTests += adPassed + adFailed;
		passedTests += adPassed;

		// ── CDP Lifecycle Manager Tests (AUTO-056) ───────────────────────
		Console.WriteLine("\nRunning CDP Lifecycle Manager Tests (AUTO-056)...\n");
		(int clPassed, int clFailed) = CdpLifecycleManagerTests.RunAll();
		totalTests += clPassed + clFailed;
		passedTests += clPassed;

		// ── Burn-In Monitor Tests (MON-057/058/059/060) ─────────────────
		Console.WriteLine("\nRunning Burn-In Monitor Tests (MON-057/058/059/060)...\n");
		(int bmPassed, int bmFailed) = BurnInMonitorTests.RunAll();
		totalTests += bmPassed + bmFailed;
		passedTests += bmPassed;

		// ── DECISION_070: Credential Lock Leak Tests ────────────────────
		Console.WriteLine("\nRunning Credential Lock Tests (DECISION_070)...\n");
		(int d070Passed, int d070Failed) = H0UNDCredentialLockTests.RunAll();
		totalTests += d070Passed + d070Failed;
		passedTests += d070Passed;

		// ── DECISION_069: DPD Data Persistence Tests ───────────────────
		Console.WriteLine("\nRunning DPD Data Persistence Tests (DECISION_069)...\n");
		(int d069Passed, int d069Failed) = AnalyticsWorkerDPDTests.RunAll();
		totalTests += d069Passed + d069Failed;
		passedTests += d069Passed;

		// ── DECISION_071: Signal Preservation Tests ────────────────────
		Console.WriteLine("\nRunning Signal Preservation Tests (DECISION_071)...\n");
		(int d071Passed, int d071Failed) = AnalyticsWorkerSignalPreservationTests.RunAll();
		totalTests += d071Passed + d071Failed;
		passedTests += d071Passed;

		// ── DECISION_072: Idempotent Generator Fallback Tests ─────────
		Console.WriteLine("\nRunning Idempotent Generator Fallback Tests (DECISION_072)...\n");
		(int d072Passed, int d072Failed) = IdempotentSignalGeneratorDecision072Tests.RunAll();
		totalTests += d072Passed + d072Failed;
		passedTests += d072Passed;

		// ── DECISION_073: WebSocket Error Handling Tests ───────────────
		Console.WriteLine("\nRunning WebSocket Error Handling Tests (DECISION_073)...\n");
		(int d073Passed, int d073Failed) = FireKirinQueryBalancesTests.RunAll();
		totalTests += d073Passed + d073Failed;
		passedTests += d073Passed;

		// ── DECISION_074: Dedup TTL Tests ─────────────────────────────
		Console.WriteLine("\nRunning Dedup TTL Tests (DECISION_074)...\n");
		(int d074Passed, int d074Failed) = SignalDeduplicationCacheDecision074Tests.RunAll();
		totalTests += d074Passed + d074Failed;
		passedTests += d074Passed;

		// ── DECISION_075: Signal Reclaim Window Tests ─────────────────
		Console.WriteLine("\nRunning Signal Reclaim Window Tests (DECISION_075)...\n");
		(int d075Passed, int d075Failed) = SignalDistributorReclaimTests.RunAll();
		totalTests += d075Passed + d075Failed;
		passedTests += d075Passed;

		// ── H0UND Weakpoint Audit Tests (AUDIT-076) ─────────────────────
		Console.WriteLine("\nRunning H0UND Weakpoint Audit Tests (AUDIT-076)...\n");
		(int wpPassed, int wpFailed) = H0UNDWeakpointAuditTests.RunAll();
		totalTests += wpPassed + wpFailed;
		passedTests += wpPassed;

		// ── Canvas Login Tests (FireKirin Typing Fix) ─────────────────────
		Console.WriteLine("\nRunning Canvas Login Tests (FireKirin Typing Fix)...\n");
		try
		{
			bool canvasResult = await CanvasLoginTests.TestFireKirinLoginWithScreenshot();
			totalTests++;
			if (canvasResult) passedTests++;
			Console.WriteLine($"Canvas Login Test: {(canvasResult ? "PASSED" : "FAILED")}");
		}
		catch (Exception ex)
		{
			totalTests++;
			Console.WriteLine($"Canvas Login Test: EXCEPTION - {ex.Message}");
		}

		// ── DECISION_081: Canvas Typing Fix + Chrome Profile Isolation ────
		Console.WriteLine("\nRunning DECISION_081 Tests (Canvas Typing + Chrome Profiles)...\n");
		(int d081Passed, int d081Failed) = Decision081Tests.RunAll();
		totalTests += d081Passed + d081Failed;
		passedTests += d081Passed;

		// ── DECISION_085/086: Vertical Stability Tests (Godahewa 2023) ──
		Console.WriteLine("\nRunning Vertical Stability Tests (DECISION_085/086)...\n");
		(int vsPassed, int vsFailed) = VerticalStabilityTests.RunAll();
		totalTests += vsPassed + vsFailed;
		passedTests += vsPassed;

		// ── DECISION_085/086: Horizontal Stability Tests (Godahewa 2023) ─
		Console.WriteLine("\nRunning Horizontal Stability Tests (DECISION_085/086)...\n");
		(int hsPassed, int hsFailed) = HorizontalStabilityTests.RunAll();
		totalTests += hsPassed + hsFailed;
		passedTests += hsPassed;

		// ── DECISION_085/086: Stochasticity Tests (Klee & Xia 2025) ─────
		Console.WriteLine("\nRunning Stochasticity Tests (DECISION_085/086)...\n");
		(int stPassed, int stFailed) = StochasticityTests.RunAll();
		totalTests += stPassed + stFailed;
		passedTests += stPassed;

		// ── DECISION_086: Minimum Sampling Tests (Liu & Zhang 2019) ──────
		Console.WriteLine("\nRunning Minimum Sampling Tests (DECISION_086)...\n");
		(int msPassed, int msFailed) = MinimumSamplingTests.RunAll();
		totalTests += msPassed + msFailed;
		passedTests += msPassed;

		// ── DECISION_086: Post-Processing Tests (Klee & Xia 2025) ────────
		Console.WriteLine("\nRunning Post-Processing Tests (DECISION_086)...\n");
		(int ppPassed, int ppFailed) = PostProcessingTests.RunAll();
		totalTests += ppPassed + ppFailed;
		passedTests += ppPassed;

		// ── DECISION_086: Data Quality Tests (Hu et al. 2025) ────────────
		Console.WriteLine("\nRunning Data Quality Tests (DECISION_086)...\n");
		(int dqPassed, int dqFailed) = DataQualityTests.RunAll();
		totalTests += dqPassed + dqFailed;
		passedTests += dqPassed;

		// ── DECISION_086: Burn-In Integration Scenario Tests ─────────────
		Console.WriteLine("\nRunning Burn-In Scenario Tests (DECISION_086)...\n");
		(int biPassed, int biFailed) = BurnInScenarioTests.RunAll();
		totalTests += biPassed + biFailed;
		passedTests += biPassed;

		// ── DECISION_085: Display Pipeline Tests ───────────────────────────
		Console.WriteLine("\nRunning Display Pipeline Tests (DECISION_085)...\n");
		(int dpPassed, int dpFailed) = P4NTHE0N.UNI7T35T.C0MMON.DisplayPipelineTests.RunAll();
		totalTests += dpPassed + dpFailed;
		passedTests += dpPassed;

		// ── DECISION_098: Navigation Map Tests ──────────────────────────
		Console.WriteLine("\nRunning Navigation Map Tests (DECISION_098)...\n");
		(int navPassed, int navFailed) = NavigationMapTests.RunAll();
		totalTests += navPassed + navFailed;
		passedTests += navPassed;

		// ── CRIT-103: Tychon Chaos Tests ────────────────────────────────
		Console.WriteLine("\nRunning Tychon Chaos Tests (CRIT-103)...\n");
		(int tychonPassed, int tychonFailed) = TychonChaosTests.RunAll();
		totalTests += tychonPassed + tychonFailed;
		passedTests += tychonPassed;

		// ── DECISION_110: Guard Tests ───────────────────────────────────
		Console.WriteLine("\nRunning Guard Tests (DECISION_110)...\n");
		(int guardPassed, int guardFailed) = GuardTests.RunAll();
		totalTests += guardPassed + guardFailed;
		passedTests += guardPassed;

		// ── DECISION_110: Value Object Tests ────────────────────────────
		Console.WriteLine("\nRunning Value Object Tests (DECISION_110)...\n");
		(int voPassed, int voFailed) = ValueObjectTests.RunAll();
		totalTests += voPassed + voFailed;
		passedTests += voPassed;

		// ── DECISION_110: Structured Logging Tests ──────────────────────
		Console.WriteLine("\nRunning Structured Logging Tests (DECISION_110)...\n");
		(int logPassed, int logFailed) = StructuredLoggingTests.RunAll();
		totalTests += logPassed + logFailed;
		passedTests += logPassed;

		// ── DECISION_110: Domain Aggregate Tests ───────────────────────
		Console.WriteLine("\nRunning Domain Aggregate Tests (DECISION_110 Phase 3)...\n");
		(int domainPassed, int domainFailed) = DomainAggregateTests.RunAll();
		totalTests += domainPassed + domainFailed;
		passedTests += domainPassed;

		// ── DECISION_110: Persistence Repository Tests ──────────────────
		Console.WriteLine("\nRunning Persistence Repository Tests (DECISION_110 Phase 4)...\n");
		(int persistencePassed, int persistenceFailed) = PersistenceRepositoryTests.RunAll();
		totalTests += persistencePassed + persistenceFailed;
		passedTests += persistencePassed;

		// ── DECISION_113: Hotspot Runtime Fault Harness ────────────────
		Console.WriteLine("\nRunning Hotspot Fault Harness (DECISION_113)...\n");
		(int hotspotPassed, int hotspotFailed) = HotspotFaultHarnessTests.RunAll();
		totalTests += hotspotPassed + hotspotFailed;
		passedTests += hotspotPassed;

		// ── DECISION_113: Mongo Outage Degradation Validation ──────────
		Console.WriteLine("\nRunning Mongo Outage Degradation (DECISION_113)...\n");
		(int outagePassed, int outageFailed) = MongoOutageDegradationTests.RunAll();
		totalTests += outagePassed + outageFailed;
		passedTests += outagePassed;

		// ── DECISION_113: H0UND Rollout Validation ─────────────────────
		Console.WriteLine("\nRunning H0UND Error Evidence Rollout (DECISION_113)...\n");
		(int h0undRolloutPassed, int h0undRolloutFailed) = H0UNDErrorEvidenceRolloutTests.RunAll();
		totalTests += h0undRolloutPassed + h0undRolloutFailed;
		passedTests += h0undRolloutPassed;

		// ── Summary ──────────────────────────────────────────────────────
		Console.WriteLine("\n╔════════════════════════════════════════════════════════════════════╗");
		Console.WriteLine($"║  TEST SUMMARY: {passedTests}/{totalTests} tests passed                                   ║");
		Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

		if (passedTests == totalTests)
		{
			Console.WriteLine("✓ All tests passed!");
			return 0;
		}
		else
		{
			Console.WriteLine($"✗ {totalTests - passedTests} test(s) failed.");
			return 1;
		}
	}
}
