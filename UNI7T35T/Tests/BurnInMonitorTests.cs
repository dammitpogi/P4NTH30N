using P4NTHE0N.H4ND.Monitoring;
using P4NTHE0N.H4ND.Monitoring.Models;
using P4NTHE0N.H4ND.Parallel;
using P4NTHE0N.H4ND.Services;
using UNI7T35T.Mocks;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// Tests for DECISION_057 (Monitoring), DECISION_058 (Alerts),
/// DECISION_059 (Completion Analysis), DECISION_060 (Operational Config).
/// </summary>
public static class BurnInMonitorTests
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
					Console.WriteLine($"  [PASS] {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  [FAIL] {name}");
					failed++;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  [FAIL] {name}: {ex.Message}");
				failed++;
			}
		}

		// DECISION_057 tests
		Run("MON-057-001: BurnInProgressCalculator defaults", Test_ProgressCalculator_Defaults);
		Run("MON-057-002: BurnInProgressCalculator percent", Test_ProgressCalculator_Percent);
		Run("MON-057-003: BurnInProgressCalculator ETA", Test_ProgressCalculator_Eta);
		Run("MON-057-004: BurnInProgressCalculator throughput", Test_ProgressCalculator_Throughput);
		Run("MON-057-005: BurnInStatus model structure", Test_BurnInStatus_Model);
		Run("MON-057-006: BurnInMonitor session ID format", Test_Monitor_SessionId);
		Run("MON-057-007: BurnInMonitor status transitions", Test_Monitor_StatusTransitions);
		Run("MON-057-008: BurnInDashboardServer port config", Test_DashboardServer_Config);

		// DECISION_058 tests
		Run("MON-058-001: AlertSeverity enum values", Test_AlertSeverity_Enum);
		Run("MON-058-002: BurnInAlert factory methods", Test_BurnInAlert_Factories);
		Run("MON-058-003: BurnInAlertConfig defaults", Test_AlertConfig_Defaults);
		Run("MON-058-004: AlertEvaluator no alerts on clean metrics", Test_Evaluator_CleanMetrics);
		Run("MON-058-005: AlertEvaluator WARN on signal backlog", Test_Evaluator_WarnSignalBacklog);
		Run("MON-058-006: AlertEvaluator CRITICAL on memory", Test_Evaluator_CriticalMemory);
		Run("MON-058-007: AlertEvaluator RequiresHalt logic", Test_Evaluator_RequiresHalt);
		Run("MON-058-008: AlertEvaluator recommendations", Test_Evaluator_Recommendations);
		Run("MON-058-009: AlertNotificationDispatcher channels", Test_Dispatcher_Channels);
		Run("MON-058-010: HaltDiagnosticDump structure", Test_HaltDiagnosticDump);

		// DECISION_059 tests
		Run("AUTO-059-001: CompletionCriteria defaults", Test_CompletionCriteria_Defaults);
		Run("AUTO-059-002: CompletionAnalyzer PASS", Test_CompletionAnalyzer_Pass);
		Run("AUTO-059-003: CompletionAnalyzer FAIL on halt", Test_CompletionAnalyzer_FailOnHalt);
		Run("AUTO-059-004: CompletionAnalyzer FAIL on memory", Test_CompletionAnalyzer_FailOnMemory);
		Run("AUTO-059-005: Markdown report generation", Test_MarkdownReport);
		Run("AUTO-059-006: PromotionResult structure", Test_PromotionResult);
		Run("AUTO-059-007: DecisionPromoter FAIL path", Test_DecisionPromoter_FailPath);
		Run("AUTO-059-008: BurnInValidation structure", Test_BurnInValidation);

		// DECISION_060 tests
		Run("OPS-060-001: OperationalConfig defaults", Test_OperationalConfig_Defaults);
		Run("OPS-060-002: OperationalMode enum values", Test_OperationalMode_Enum);
		Run("OPS-060-003: MetricTargets thresholds", Test_MetricTargets);
		Run("OPS-060-004: IncidentResponse config", Test_IncidentResponse);
		Run("OPS-060-005: PreOperationalChecklist items", Test_PreOperationalChecklist);
		Run("OPS-060-006: OperationalSchedule defaults", Test_OperationalSchedule);

		return (passed, failed);
	}

	// ── DECISION_057 Tests ──

	private static bool Test_ProgressCalculator_Defaults()
	{
		var calc = new BurnInProgressCalculator(24);
		return calc.ElapsedHours >= 0 && calc.ElapsedHours < 0.01
			&& calc.PercentComplete >= 0 && calc.PercentComplete < 1
			&& !calc.IsComplete;
	}

	private static bool Test_ProgressCalculator_Percent()
	{
		var calc = new BurnInProgressCalculator(0.001); // Very short duration
		Thread.Sleep(10); // Let some time pass
		return calc.PercentComplete > 0;
	}

	private static bool Test_ProgressCalculator_Eta()
	{
		var calc = new BurnInProgressCalculator(24);
		var eta = calc.Eta;
		return eta.HasValue && eta.Value > DateTime.UtcNow;
	}

	private static bool Test_ProgressCalculator_Throughput()
	{
		var calc = new BurnInProgressCalculator(24);
		double throughput = calc.ThroughputPerHour(100);
		// Just started, so throughput should be very high (100 / ~0 hours)
		return throughput >= 0;
	}

	private static bool Test_BurnInStatus_Model()
	{
		var status = new BurnInStatus
		{
			SessionId = "test-session",
			Status = "Running",
		};
		return status.SessionId == "test-session"
			&& status.Status == "Running"
			&& status.Progress != null
			&& status.Signals != null
			&& status.Workers != null
			&& status.Errors != null
			&& status.Chrome != null
			&& status.Platforms != null;
	}

	private static bool Test_Monitor_SessionId()
	{
		var uow = new MockUnitOfWork();
		var config = new BurnInConfig { DurationHours = 1 };
		var monitor = new BurnInMonitor(uow, config);
		return monitor.SessionId.StartsWith("burnin-") && monitor.Status == "Initializing";
	}

	private static bool Test_Monitor_StatusTransitions()
	{
		var uow = new MockUnitOfWork();
		var config = new BurnInConfig { DurationHours = 1 };
		var monitor = new BurnInMonitor(uow, config);

		bool initial = monitor.Status == "Initializing";
		monitor.Stop("TestStop");
		bool stopped = monitor.Status == "TestStop";
		monitor.Dispose();
		return initial && stopped;
	}

	private static bool Test_DashboardServer_Config()
	{
		var uow = new MockUnitOfWork();
		var config = new BurnInConfig { DurationHours = 1 };
		var monitor = new BurnInMonitor(uow, config);
		var server = new BurnInDashboardServer(monitor, 15002);
		bool notRunning = !server.IsRunning;
		server.Dispose();
		return notRunning;
	}

	// ── DECISION_058 Tests ──

	private static bool Test_AlertSeverity_Enum()
	{
		return Enum.GetValues<AlertSeverity>().Length == 3
			&& AlertSeverity.Info < AlertSeverity.Warn
			&& AlertSeverity.Warn < AlertSeverity.Critical;
	}

	private static bool Test_BurnInAlert_Factories()
	{
		var info = BurnInAlert.Info("Test", "info msg");
		var warn = BurnInAlert.Warn("Test", "warn msg", 5.0, 10.0);
		var critical = BurnInAlert.Critical("Test", "critical msg", 15.0, 10.0);

		return info.Severity == AlertSeverity.Info && !info.RequiresHalt
			&& warn.Severity == AlertSeverity.Warn && !warn.RequiresHalt
			&& critical.Severity == AlertSeverity.Critical && critical.RequiresHalt
			&& warn.MetricValue == 5.0 && warn.ThresholdValue == 10.0
			&& critical.ToString().Contains("critical msg");
	}

	private static bool Test_AlertConfig_Defaults()
	{
		var config = new BurnInAlertConfig();
		return config.ErrorRateWarnThreshold == 0.05
			&& config.ErrorRateCriticalThreshold == 0.10
			&& config.MemoryCriticalThresholdMB == 500
			&& config.ChromeRestartCriticalCount == 5
			&& config.SignalBacklogWarnCount == 20
			&& config.NotificationChannels.Count == 3
			&& config.HaltOnDuplication
			&& config.HaltOnWorkerDeadlock;
	}

	private static bool Test_Evaluator_CleanMetrics()
	{
		var config = new BurnInAlertConfig();
		var uow = new MockUnitOfWork();
		var evaluator = new BurnInAlertEvaluator(config, uow);
		var metrics = new ParallelMetrics();
		var snapshot = new BurnInMetricsSnapshot
		{
			ErrorRate = 0, PendingSignals = 5, MemoryMB = 100, MemoryGrowthMB = 10,
		};

		var alerts = evaluator.Evaluate(metrics, snapshot);
		// Should have no WARN or CRITICAL alerts on clean metrics
		return !alerts.Any(a => a.Severity == AlertSeverity.Critical)
			&& !alerts.Any(a => a.Severity == AlertSeverity.Warn);
	}

	private static bool Test_Evaluator_WarnSignalBacklog()
	{
		var config = new BurnInAlertConfig { SignalBacklogWarnCount = 10 };
		var uow = new MockUnitOfWork();
		var evaluator = new BurnInAlertEvaluator(config, uow);
		var metrics = new ParallelMetrics();
		var snapshot = new BurnInMetricsSnapshot { PendingSignals = 25 };

		var alerts = evaluator.Evaluate(metrics, snapshot);
		return alerts.Any(a => a.Severity == AlertSeverity.Warn && a.Category == "SignalBacklog");
	}

	private static bool Test_Evaluator_CriticalMemory()
	{
		var config = new BurnInAlertConfig { MemoryCriticalThresholdMB = 1 }; // Very low threshold
		var uow = new MockUnitOfWork();
		var evaluator = new BurnInAlertEvaluator(config, uow);
		var metrics = new ParallelMetrics();
		var snapshot = new BurnInMetricsSnapshot { MemoryMB = 200 };

		var alerts = evaluator.Evaluate(metrics, snapshot);
		return alerts.Any(a => a.Severity == AlertSeverity.Critical && a.Category == "Memory");
	}

	private static bool Test_Evaluator_RequiresHalt()
	{
		var noHalt = new List<BurnInAlert>
		{
			BurnInAlert.Info("Test", "info"),
			BurnInAlert.Warn("Test", "warn"),
		};
		var halt = new List<BurnInAlert>
		{
			BurnInAlert.Warn("Test", "warn"),
			BurnInAlert.Critical("Test", "critical"),
		};

		return !BurnInAlertEvaluator.RequiresHalt(noHalt)
			&& BurnInAlertEvaluator.RequiresHalt(halt)
			&& BurnInAlertEvaluator.GetHaltReason(noHalt) == null
			&& BurnInAlertEvaluator.GetHaltReason(halt) != null;
	}

	private static bool Test_Evaluator_Recommendations()
	{
		var config = new BurnInAlertConfig();
		var uow = new MockUnitOfWork();
		var evaluator = new BurnInAlertEvaluator(config, uow);
		var metrics = new ParallelMetrics();
		var alerts = new List<BurnInAlert>
		{
			BurnInAlert.Critical("ErrorRate", "High error rate"),
			BurnInAlert.Critical("Memory", "High memory"),
		};

		var recs = evaluator.GenerateRecommendations(alerts, metrics);
		return recs.Count >= 2 && recs.Any(r => r.Contains("platform stability"));
	}

	private static bool Test_Dispatcher_Channels()
	{
		var config = new BurnInAlertConfig
		{
			NotificationChannels = ["Console"],
		};
		var dispatcher = new AlertNotificationDispatcher(config);
		// Should not throw
		dispatcher.Dispatch([BurnInAlert.Warn("Test", "test warn")]);
		return true;
	}

	private static bool Test_HaltDiagnosticDump()
	{
		var dump = new HaltDiagnosticDump
		{
			SessionId = "test-session",
			HaltReason = "Test reason",
			DurationHours = 6.5,
			SignalsProcessed = 127,
		};
		return dump.SessionId == "test-session"
			&& dump.HaltReason == "Test reason"
			&& dump.FinalMetrics != null
			&& dump.WorkerStates != null
			&& dump.Recommendations != null;
	}

	// ── DECISION_059 Tests ──

	private static bool Test_CompletionCriteria_Defaults()
	{
		var criteria = new BurnInCompletionCriteria();
		return criteria.MaxErrorRatePercent == 5.0
			&& criteria.MaxMemoryGrowthMB == 100
			&& criteria.MinThroughputMultiplier == 5.0
			&& criteria.MaxChromeRestarts == 3;
	}

	private static bool Test_CompletionAnalyzer_Pass()
	{
		var analyzer = new BurnInCompletionAnalyzer(new BurnInCompletionCriteria
		{
			MinThroughputMultiplier = 1.0, // Relax for test
			SequentialBaselinePerHour = 1.0,
		});

		var summary = new BurnInSummary
		{
			Result = "PASS",
			HaltReason = null,
			TotalDuration = TimeSpan.FromHours(24),
			TotalSpinsAttempted = 500,
			TotalSpinsSucceeded = 490,
			TotalSpinsFailed = 10,
			FinalSuccessRate = 98,
			FinalErrorRate = 2,
			MemoryGrowthMB = 50,
			WorkerRestarts = 1,
			InitialMemoryMB = 100,
			FinalMemoryMB = 150,
			CompletedAt = DateTime.UtcNow,
		};

		var snapshots = new List<BurnInMetricsSnapshot>
		{
			new() { ErrorRate = 2, ElapsedMinutes = 1440 },
		};

		var report = analyzer.Analyze(summary, snapshots, 24);
		return report.Result == "PASS"
			&& report.Validations.All(v => v.Passed)
			&& report.ReportType == "BurnInCompletion";
	}

	private static bool Test_CompletionAnalyzer_FailOnHalt()
	{
		var analyzer = new BurnInCompletionAnalyzer();
		var summary = new BurnInSummary
		{
			Result = "FAIL",
			HaltReason = "Error rate too high",
			TotalDuration = TimeSpan.FromHours(6),
			TotalSpinsAttempted = 100,
			TotalSpinsSucceeded = 80,
			TotalSpinsFailed = 20,
			FinalErrorRate = 20,
			MemoryGrowthMB = 50,
			WorkerRestarts = 0,
			CompletedAt = DateTime.UtcNow,
		};

		var report = analyzer.Analyze(summary, [], 24);
		return report.Result == "FAIL" && report.HaltReason != null;
	}

	private static bool Test_CompletionAnalyzer_FailOnMemory()
	{
		var analyzer = new BurnInCompletionAnalyzer(new BurnInCompletionCriteria
		{
			MaxMemoryGrowthMB = 50,
			MinThroughputMultiplier = 0.1,
			SequentialBaselinePerHour = 1.0,
		});

		var summary = new BurnInSummary
		{
			Result = "PASS",
			HaltReason = null,
			TotalDuration = TimeSpan.FromHours(24),
			TotalSpinsAttempted = 100,
			TotalSpinsSucceeded = 98,
			MemoryGrowthMB = 200, // Exceeds 50MB threshold
			WorkerRestarts = 0,
			FinalErrorRate = 2,
			CompletedAt = DateTime.UtcNow,
		};

		var report = analyzer.Analyze(summary, [new() { ErrorRate = 1, ElapsedMinutes = 1440 }], 24);
		return report.Result == "FAIL"
			&& report.Validations.Any(v => v.Criterion == "MemoryGrowth" && !v.Passed);
	}

	private static bool Test_MarkdownReport()
	{
		var report = new BurnInCompletionReport
		{
			Result = "PASS",
			SessionId = "test-session",
			CompletionTime = DateTime.UtcNow,
			Duration = new BurnInDurationReport { PlannedHours = 24, ActualHours = 24.1, VariancePercent = 0.4 },
			Metrics = new BurnInMetricsReport { SignalsProcessed = 450, TotalErrors = 12, ErrorRate = 0.026 },
			Validations = [new BurnInValidation { Criterion = "ZeroDuplication", Passed = true, Detail = "No duplication" }],
		};

		string md = BurnInCompletionAnalyzer.GenerateMarkdownReport(report);
		return md.Contains("BURN-IN PASSED")
			&& md.Contains("test-session")
			&& md.Contains("ZeroDuplication")
			&& md.Contains("DECISION_047");
	}

	private static bool Test_PromotionResult()
	{
		var result = new PromotionResult
		{
			SessionId = "test",
			OverallResult = "PASS",
			Actions = ["DECISION_047: Promoted"],
		};
		string str = result.ToString();
		return str.Contains("PASS") && str.Contains("DECISION_047");
	}

	private static bool Test_DecisionPromoter_FailPath()
	{
		var promoter = new DecisionPromoter(Path.Combine(Path.GetTempPath(), "nonexistent-decisions"));
		var report = new BurnInCompletionReport { Result = "FAIL", HaltReason = "Test failure" };
		var result = promoter.PromoteOnPass(report);
		// Should not throw, should add failure note action
		return result.OverallResult == "FAIL" && result.Actions.Count > 0;
	}

	private static bool Test_BurnInValidation()
	{
		var v = new BurnInValidation
		{
			Criterion = "ErrorRate",
			Passed = true,
			Value = 2.5,
			Threshold = 5.0,
			Detail = "Error rate within bounds",
		};
		return v.Criterion == "ErrorRate" && v.Passed && v.Value == 2.5 && v.Threshold == 5.0;
	}

	// ── DECISION_060 Tests ──

	private static bool Test_OperationalConfig_Defaults()
	{
		var config = new OperationalConfig();
		return config.Mode == OperationalMode.Continuous
			&& config.CredentialCollection == "CR3D3N7IAL_PR0D"
			&& config.Targets != null
			&& config.IncidentResponse != null
			&& config.Schedule != null;
	}

	private static bool Test_OperationalMode_Enum()
	{
		return Enum.GetValues<OperationalMode>().Length == 3
			&& Enum.IsDefined(OperationalMode.Continuous)
			&& Enum.IsDefined(OperationalMode.ScheduledBatch)
			&& Enum.IsDefined(OperationalMode.EventDriven);
	}

	private static bool Test_MetricTargets()
	{
		var targets = new OperationalMetricTargets();
		return targets.UptimeTargetPercent == 99.5
			&& targets.UptimeAlertPercent == 99.0
			&& targets.SignalsPerDayTarget == 1000
			&& targets.ErrorRateTargetPercent == 2.0
			&& targets.AvgSpinTimeSecondsTarget == 45;
	}

	private static bool Test_IncidentResponse()
	{
		var ir = new IncidentResponseConfig();
		return ir.P0.ResponseMinutes == 15
			&& ir.P1.ResponseMinutes == 60
			&& ir.P2.ResponseMinutes == 240
			&& ir.P3.ResponseMinutes == 1440
			&& ir.P0.Name == "System Down";
	}

	private static bool Test_PreOperationalChecklist()
	{
		var config = new OperationalConfig();
		var items = PreOperationalChecklist.Validate(config);
		return items.Count >= 15
			&& items.Any(i => i.Category == "Technical")
			&& items.Any(i => i.Category == "Credentials")
			&& items.Any(i => i.Category == "Infrastructure")
			&& items.Any(i => i.Category == "Monitoring")
			&& items.All(i => !i.Checked); // All unchecked by default
	}

	private static bool Test_OperationalSchedule()
	{
		var schedule = new OperationalSchedule();
		return schedule.CronExpression == "0 */6 * * *"
			&& schedule.BatchDurationMinutes == 60
			&& schedule.JackpotThreshold == 1000
			&& schedule.DailyCheckTimes.Count == 4
			&& schedule.WeeklyTasks.Count == 4;
	}
}
