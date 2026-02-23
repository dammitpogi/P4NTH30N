using P4NTH30N.H4ND.Monitoring;
using P4NTH30N.H4ND.Parallel;

namespace P4NTH30N.UNI7T35T.Tests;

public static class ProductionReadinessEvaluatorTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		void Run(string name, Func<bool> test)
		{
			try
			{
				if (test())
				{
					Console.WriteLine($"  ✅ {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  ❌ {name}");
					failed++;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  ❌ {name} — Exception: {ex.Message}");
				failed++;
			}
		}

		Run("PREP-001 NoGo_When_SoakUnder24h", () =>
		{
			var metrics = new ParallelMetrics();
			for (var i = 0; i < 50; i++)
			{
				metrics.RecordSpinResult("W00", true, TimeSpan.FromMilliseconds(100));
			}

			var report = ProductionReadinessEvaluator.Evaluate(metrics, new ParallelConfig(), TimeSpan.FromHours(2));
			return !report.IsGo && report.FailedChecks.Any(x => x.Contains("soak duration", StringComparison.OrdinalIgnoreCase));
		});

		Run("PREP-002 NoGo_When_TargetsMissed", () =>
		{
			var metrics = new ParallelMetrics();
			for (var i = 0; i < 20; i++)
			{
				metrics.RecordSpinResult("W00", true, TimeSpan.FromMilliseconds(8000));
			}

			var config = new ParallelConfig
			{
				TargetP95LatencyMs = 3000,
				TargetThroughputPerMinute = 100,
			};

			var report = ProductionReadinessEvaluator.Evaluate(metrics, config, TimeSpan.FromHours(24));
			return !report.IsGo
				&& report.FailedChecks.Any(x => x.Contains("p95 latency", StringComparison.OrdinalIgnoreCase))
				&& report.FailedChecks.Any(x => x.Contains("throughput", StringComparison.OrdinalIgnoreCase));
		});

		return (passed, failed);
	}
}
