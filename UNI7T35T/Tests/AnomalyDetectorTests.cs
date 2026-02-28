using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Support;
using P4NTHE0N.H0UND.Services;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// DECISION_025: Unit tests for AtypicalityScore and AnomalyDetector.
/// Tests compression-based scoring, Z-score fallback, sliding window, and anomaly callback.
/// </summary>
public static class AnomalyDetectorTests
{
	public static (int Passed, int Failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		void Run(string name, Action test)
		{
			try
			{
				test();
				Console.WriteLine($"  ✅ {name}");
				passed++;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  ❌ {name}: {ex.Message}");
				failed++;
			}
		}

		// AtypicalityScore tests
		Run("AtypicalityScore: small window returns 0", () =>
		{
			double[] window = [1.0, 2.0, 3.0];
			double result = AtypicalityScore.Calculate(window, 4.0);
			Assert(result == 0.0, $"Expected 0.0, got {result}");
		});

		Run("AtypicalityScore: normal value has low ratio", () =>
		{
			double[] window = Enumerable.Range(0, 50).Select(i => 1000.0 + i * 0.5).ToArray();
			double result = AtypicalityScore.Calculate(window, 1025.5);
			Assert(result < 2.0, $"Expected ratio < 2.0 for normal value, got {result}");
		});

		Run("AtypicalityScore: outlier has higher ratio", () =>
		{
			double[] window = Enumerable.Range(0, 50).Select(i => 1000.0 + i * 0.5).ToArray();
			double normalRatio = AtypicalityScore.Calculate(window, 1025.5);
			double outlierRatio = AtypicalityScore.Calculate(window, 9999.0);
			Assert(outlierRatio > normalRatio, $"Outlier ratio ({outlierRatio:F2}) should exceed normal ({normalRatio:F2})");
		});

		Run("AtypicalityScore: ZScore returns 0 for insufficient window", () =>
		{
			double[] window = [1.0];
			double z = AtypicalityScore.ZScore(window, 2.0);
			Assert(z == 0.0, $"Expected 0.0, got {z}");
		});

		Run("AtypicalityScore: ZScore flags extreme values", () =>
		{
			double[] window = Enumerable.Range(0, 50).Select(i => 100.0 + i * 0.1).ToArray();
			double z = AtypicalityScore.ZScore(window, 999.0);
			Assert(z > 3.0, $"Expected Z > 3.0 for extreme outlier, got {z:F2}");
		});

		Run("AtypicalityScore: IsAnomalous returns false for normal value", () =>
		{
			double[] window = Enumerable.Range(0, 50).Select(i => 500.0 + i * 0.2).ToArray();
			bool anomalous = AtypicalityScore.IsAnomalous(window, 505.0, compressionThreshold: 2.0, zScoreThreshold: 3.0);
			Assert(!anomalous, "Normal value should not be anomalous");
		});

		// AnomalyDetector tests
		Run("AnomalyDetector: first 5 values return null (building window)", () =>
		{
			AnomalyDetector detector = new(windowSize: 50);
			for (int i = 0; i < 5; i++)
			{
				AnomalyEvent? result = detector.Process("TestHouse", "TestGame", "Grand", 100.0 + i);
				Assert(result == null, $"Value {i} should return null while building window");
			}
		});

		Run("AnomalyDetector: normal sequence produces no anomalies", () =>
		{
			AnomalyDetector detector = new(windowSize: 20);
			for (int i = 0; i < 30; i++)
			{
				AnomalyEvent? result = detector.Process("TestHouse", "TestGame", "Grand", 1000.0 + i * 0.5);
				if (i >= 5)
					Assert(result == null, $"Normal value at step {i} should not be anomalous");
			}
			Assert(detector.TotalAnomalies == 0, $"Expected 0 anomalies, got {detector.TotalAnomalies}");
		});

		Run("AnomalyDetector: tracks TotalProcessed correctly", () =>
		{
			AnomalyDetector detector = new(windowSize: 10);
			for (int i = 0; i < 15; i++)
				detector.Process("H", "G", "Grand", 100.0 + i);
			Assert(detector.TotalProcessed == 15, $"Expected 15 processed, got {detector.TotalProcessed}");
		});

		Run("AnomalyDetector: callback fires on anomaly", () =>
		{
			int callbackCount = 0;
			AnomalyDetector detector = new(
				windowSize: 20,
				compressionThreshold: 1.3,
				zScoreThreshold: 3.0,
				onAnomaly: _ => callbackCount++
			);

			// Fill window with steady values
			for (int i = 0; i < 25; i++)
				detector.Process("H", "G", "Grand", 100.0);

			// Inject extreme outlier
			detector.Process("H", "G", "Grand", 99999.0);

			Assert(callbackCount > 0, $"Expected callback to fire, count = {callbackCount}");
			Assert(detector.TotalAnomalies > 0, $"Expected anomalies > 0, got {detector.TotalAnomalies}");
		});

		Run("AnomalyDetector: separate windows per house/game/tier", () =>
		{
			AnomalyDetector detector = new(windowSize: 10);
			Assert(detector.GetWindowSize("H", "G", "Grand") == 0, "Window should start at 0");

			for (int i = 0; i < 10; i++)
			{
				detector.Process("H1", "G1", "Grand", 100.0 + i);
				detector.Process("H2", "G2", "Major", 200.0 + i);
			}

			Assert(detector.GetWindowSize("H1", "G1", "Grand") == 10, "H1/G1/Grand should have 10 values");
			Assert(detector.GetWindowSize("H2", "G2", "Major") == 10, "H2/G2/Major should have 10 values");
			Assert(detector.GetWindowSize("H1", "G1", "Major") == 0, "H1/G1/Major should be empty");
		});

		Run("AnomalyDetector: sliding window caps at windowSize", () =>
		{
			AnomalyDetector detector = new(windowSize: 10);
			for (int i = 0; i < 50; i++)
				detector.Process("H", "G", "Grand", 100.0 + i);
			Assert(detector.GetWindowSize("H", "G", "Grand") == 10, "Window should cap at 10");
		});

		Console.WriteLine($"\n  AnomalyDetector: {passed} passed, {failed} failed");
		return (passed, failed);
	}

	private static void Assert(bool condition, string message)
	{
		if (!condition) throw new Exception(message);
	}
}
