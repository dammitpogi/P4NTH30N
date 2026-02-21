using P4NTH30N.H4ND.Services;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// ARCH-055: Unit tests for SystemHealthReport DTOs and BurnIn metrics.
/// Tests health report structure, burn-in snapshots, and self-healing metrics.
/// </summary>
public static class SystemHealthReportTests
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

		Run("Test_HealthReport_DefaultStructure", Test_HealthReport_DefaultStructure);
		Run("Test_CdpHealthInfo_Structure", Test_CdpHealthInfo_Structure);
		Run("Test_MongoHealthInfo_Structure", Test_MongoHealthInfo_Structure);
		Run("Test_PlatformInfo_Structure", Test_PlatformInfo_Structure);
		Run("Test_BurnInMetricsSnapshot_ToString", Test_BurnInMetricsSnapshot_ToString);
		Run("Test_BurnInSummary_PassResult", Test_BurnInSummary_PassResult);
		Run("Test_BurnInSummary_FailResult", Test_BurnInSummary_FailResult);
		Run("Test_ParallelMetrics_SelfHealingCounters", Test_ParallelMetrics_SelfHealingCounters);

		return (passed, failed);
	}

	static bool Test_HealthReport_DefaultStructure()
	{
		HealthReport report = new();
		return report.Overall == "Unknown"
			&& report.Cdp != null
			&& report.MongoDb != null
			&& report.Platforms != null
			&& report.Parallel != null;
	}

	static bool Test_CdpHealthInfo_Structure()
	{
		CdpHealthInfo cdp = new()
		{
			Connected = true,
			HostIp = "192.168.56.1",
			Port = 9222,
			Summary = "OK",
		};
		return cdp.Connected && cdp.HostIp == "192.168.56.1" && cdp.Port == 9222;
	}

	static bool Test_MongoHealthInfo_Structure()
	{
		MongoHealthInfo mongo = new()
		{
			Connected = true,
			Signals = new CollectionStats { Total = 50, Unacknowledged = 12, Claimed = 3 },
			Credentials = new CredentialStats { Total = 310, Enabled = 298, Banned = 4, Locked = 2 },
			Errors = new ErrorStats { Total = 145 },
		};

		return mongo.Connected
			&& mongo.Signals.Total == 50
			&& mongo.Credentials.Enabled == 298
			&& mongo.Errors.Total == 145;
	}

	static bool Test_PlatformInfo_Structure()
	{
		PlatformInfo platform = new()
		{
			Reachable = true,
			StatusCode = 200,
			LastProbe = DateTime.UtcNow,
		};
		return platform.Reachable && platform.StatusCode == 200 && platform.LastProbe.HasValue;
	}

	static bool Test_BurnInMetricsSnapshot_ToString()
	{
		BurnInMetricsSnapshot snapshot = new()
		{
			ElapsedMinutes = 30.5,
			SpinsAttempted = 100,
			SpinsSucceeded = 95,
			SpinsFailed = 5,
			SuccessRate = 95.0,
			ErrorRate = 5.0,
			RenewalAttempts = 3,
			RenewalSuccesses = 2,
			MemoryMB = 150.0,
			MemoryGrowthMB = 25.0,
			PendingSignals = 8,
		};

		string str = snapshot.ToString();
		return str.Contains("Elapsed=30.5m")
			&& str.Contains("Spins=95/100")
			&& str.Contains("Err=5.0%");
	}

	static bool Test_BurnInSummary_PassResult()
	{
		BurnInSummary summary = new()
		{
			Result = "PASS",
			HaltReason = null,
			TotalDuration = TimeSpan.FromHours(24),
			TotalSpinsAttempted = 5000,
			TotalSpinsSucceeded = 4950,
			FinalSuccessRate = 99.0,
			FinalErrorRate = 1.0,
		};

		return summary.Result == "PASS" && summary.HaltReason == null && summary.FinalSuccessRate == 99.0;
	}

	static bool Test_BurnInSummary_FailResult()
	{
		BurnInSummary summary = new()
		{
			Result = "FAIL",
			HaltReason = "Error rate sustained above 10%",
			TotalDuration = TimeSpan.FromMinutes(45),
		};

		return summary.Result == "FAIL" && summary.HaltReason != null;
	}

	static bool Test_ParallelMetrics_SelfHealingCounters()
	{
		var metrics = new P4NTH30N.H4ND.Parallel.ParallelMetrics();

		metrics.IncrementRenewalAttempts();
		metrics.IncrementRenewalAttempts();
		metrics.IncrementRenewalSuccesses();
		metrics.IncrementRenewalFailures();
		metrics.IncrementStaleClaims();
		metrics.IncrementStaleClaims();
		metrics.IncrementStaleClaims();
		metrics.IncrementCriticalFailures();
		metrics.IncrementSelectorFallbacks();

		return metrics.RenewalAttempts == 2
			&& metrics.RenewalSuccesses == 1
			&& metrics.RenewalFailures == 1
			&& metrics.StaleClaims == 3
			&& metrics.CriticalFailures == 1
			&& metrics.SelectorFallbacks == 1;
	}
}
