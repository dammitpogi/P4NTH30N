using P4NTH30N.UNI7T35T.Tests;
using UNI7T35T.Mocks;
using UNI7T35T.Tests;

namespace UNI7T35T;

class Program
{
	static int Main(string[] args)
	{
		Console.WriteLine("╔════════════════════════════════════════════════════════════════════╗");
		Console.WriteLine("║          UNI7T35T - P4NTH30N Test Platform                        ║");
		Console.WriteLine("║          H0UND Analytics + Security + Pipeline Test Suite          ║");
		Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

		int totalTests = 0;
		int passedTests = 0;

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
			() => { encTests.Setup(); try { return encTests.TestKeyGenerationAndLoading(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestEncryptDecryptRoundTrip(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestNonceUniqueness(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestTamperDetection(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestCompactStringRoundTrip(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestDifferentKeysProduceDifferentCiphertext(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestPreventAccidentalKeyOverwrite(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestInvalidCompactStringFormats(); } finally { encTests.Cleanup(); } },
			() => { encTests.Setup(); try { return encTests.TestKeyDerivationDeterminism(); } finally { encTests.Cleanup(); } },
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
