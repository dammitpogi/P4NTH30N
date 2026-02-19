using Xunit;

namespace P4NTH30N.DeployLogAnalyzer.Tests;

public class DecisionTrackerTests
{
	[Fact]
	public void RecordDecision_SingleGo_NoRollback()
	{
		DecisionTracker tracker = new();

		DeploymentDecision decision = new()
		{
			Timestamp = DateTime.UtcNow,
			Decision = DeployDecision.Go,
			Confidence = 0.9,
			Rationale = "All healthy",
			HealthScore = 0.95,
		};

		bool rollback = tracker.RecordDecision(decision);

		Assert.False(rollback);
		Assert.Equal(0, tracker.ConsecutiveNoGoCount);
		Assert.False(tracker.RollbackTriggered);
		Assert.Equal(1, tracker.TotalDecisions);
	}

	[Fact]
	public void RecordDecision_TwoConsecutiveNoGo_TriggersRollback()
	{
		DecisionTracker tracker = new(rollbackThreshold: 2);

		DeploymentDecision noGo1 = new()
		{
			Timestamp = DateTime.UtcNow,
			Decision = DeployDecision.NoGo,
			Confidence = 0.9,
			Rationale = "Critical errors",
			HealthScore = 0.3,
		};

		DeploymentDecision noGo2 = new()
		{
			Timestamp = DateTime.UtcNow.AddMinutes(1),
			Decision = DeployDecision.NoGo,
			Confidence = 0.95,
			Rationale = "Still failing",
			HealthScore = 0.2,
		};

		bool rollback1 = tracker.RecordDecision(noGo1);
		Assert.False(rollback1);
		Assert.Equal(1, tracker.ConsecutiveNoGoCount);

		bool rollback2 = tracker.RecordDecision(noGo2);
		Assert.True(rollback2);
		Assert.Equal(2, tracker.ConsecutiveNoGoCount);
		Assert.True(tracker.RollbackTriggered);
	}

	[Fact]
	public void RecordDecision_GoResetsNoGoCounter()
	{
		DecisionTracker tracker = new(rollbackThreshold: 2);

		tracker.RecordDecision(
			new DeploymentDecision
			{
				Timestamp = DateTime.UtcNow,
				Decision = DeployDecision.NoGo,
				HealthScore = 0.3,
			}
		);

		Assert.Equal(1, tracker.ConsecutiveNoGoCount);

		tracker.RecordDecision(
			new DeploymentDecision
			{
				Timestamp = DateTime.UtcNow,
				Decision = DeployDecision.Go,
				HealthScore = 0.9,
			}
		);

		Assert.Equal(0, tracker.ConsecutiveNoGoCount);
		Assert.False(tracker.RollbackTriggered);
	}

	[Fact]
	public void CreateDecision_HealthyNoCritical_ReturnsGo()
	{
		DecisionTracker tracker = new();

		HealthReport health = new()
		{
			OverallScore = 0.9,
			IsHealthy = true,
			Checks = new List<HealthCheckResult>
			{
				new() { Name = "MongoDB", Score = 1.0 },
				new() { Name = "LMStudio", Score = 0.8 },
			},
		};

		LogAnalysisReport logs = new()
		{
			CriticalCount = 0,
			WarningCount = 2,
			InfoCount = 10,
		};

		DeploymentDecision decision = tracker.CreateDecision(health, logs);

		Assert.Equal(DeployDecision.Go, decision.Decision);
		Assert.True(decision.Confidence > 0.5);
	}

	[Fact]
	public void CreateDecision_UnhealthyScore_ReturnsNoGo()
	{
		DecisionTracker tracker = new();

		HealthReport health = new()
		{
			OverallScore = 0.4,
			IsHealthy = false,
			Checks = new List<HealthCheckResult>
			{
				new() { Name = "MongoDB", Score = 0.0 },
			},
		};

		LogAnalysisReport logs = new() { CriticalCount = 0 };

		DeploymentDecision decision = tracker.CreateDecision(health, logs);
		Assert.Equal(DeployDecision.NoGo, decision.Decision);
	}

	[Fact]
	public void CreateDecision_CriticalErrors_ReturnsNoGo()
	{
		DecisionTracker tracker = new();

		HealthReport health = new()
		{
			OverallScore = 0.9,
			IsHealthy = true,
			Checks = new List<HealthCheckResult>
			{
				new() { Name = "MongoDB", Score = 1.0 },
			},
		};

		LogAnalysisReport logs = new()
		{
			CriticalCount = 3,
			ErrorPatterns = new List<string> { "null_reference", "build_error" },
		};

		DeploymentDecision decision = tracker.CreateDecision(health, logs);
		Assert.Equal(DeployDecision.NoGo, decision.Decision);
	}

	[Fact]
	public void GetRecentDecisions_ReturnsLatestFirst()
	{
		DecisionTracker tracker = new();

		for (int i = 0; i < 5; i++)
		{
			tracker.RecordDecision(
				new DeploymentDecision
				{
					Timestamp = DateTime.UtcNow.AddMinutes(i),
					Decision = i % 2 == 0 ? DeployDecision.Go : DeployDecision.NoGo,
					Rationale = $"Decision {i}",
				}
			);
		}

		IReadOnlyList<DeploymentDecision> recent = tracker.GetRecentDecisions(3);

		Assert.Equal(3, recent.Count);
		Assert.True(recent[0].Timestamp >= recent[1].Timestamp);
	}

	[Fact]
	public void ResetNoGoCounter_ClearsState()
	{
		DecisionTracker tracker = new(rollbackThreshold: 2);

		tracker.RecordDecision(new DeploymentDecision { Decision = DeployDecision.NoGo });
		tracker.RecordDecision(new DeploymentDecision { Decision = DeployDecision.NoGo });

		Assert.True(tracker.RollbackTriggered);

		tracker.ResetNoGoCounter();

		Assert.Equal(0, tracker.ConsecutiveNoGoCount);
		Assert.False(tracker.RollbackTriggered);
	}

	[Fact]
	public async Task SaveAndLoadHistory_RoundTrips()
	{
		string tempFile = Path.GetTempFileName();
		try
		{
			DecisionTracker tracker1 = new(historyFilePath: tempFile, rollbackThreshold: 2);
			tracker1.RecordDecision(
				new DeploymentDecision
				{
					Timestamp = DateTime.UtcNow,
					Decision = DeployDecision.NoGo,
					Rationale = "Test",
					HealthScore = 0.3,
				}
			);

			await tracker1.SaveHistoryAsync();

			DecisionTracker tracker2 = new(historyFilePath: tempFile, rollbackThreshold: 2);
			await tracker2.LoadHistoryAsync();

			Assert.Equal(1, tracker2.TotalDecisions);
			Assert.Equal(1, tracker2.ConsecutiveNoGoCount);
		}
		finally
		{
			File.Delete(tempFile);
		}
	}
}
