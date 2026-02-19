using Xunit;

namespace P4NTH30N.DeployLogAnalyzer.Tests;

public class HealthCheckerTests
{
	[Fact]
	public void CheckDiskSpace_ReturnsValidResult()
	{
		HealthChecker checker = new();
		HealthCheckResult result = checker.CheckDiskSpace();

		Assert.Equal("DiskSpace", result.Name);
		Assert.Equal("System", result.Category);
		Assert.InRange(result.Score, 0.0, 1.0);
		Assert.NotEmpty(result.Details);
		Assert.NotEqual("Unknown", result.Status);
	}

	[Fact]
	public void CheckMemoryUsage_ReturnsValidResult()
	{
		HealthChecker checker = new();
		HealthCheckResult result = checker.CheckMemoryUsage();

		Assert.Equal("Memory", result.Name);
		Assert.Equal("System", result.Category);
		Assert.InRange(result.Score, 0.0, 1.0);
		Assert.NotEmpty(result.Details);
	}

	[Fact]
	public async Task CheckLmStudioAsync_NoClient_ReturnsNotConfigured()
	{
		HealthChecker checker = new(lmClient: null);
		HealthCheckResult result = await checker.CheckLmStudioAsync();

		Assert.Equal("LMStudio", result.Name);
		Assert.Equal(0.0, result.Score);
		Assert.Equal("NotConfigured", result.Status);
	}

	[Fact]
	public async Task CheckAllAsync_ReturnsAggregateReport()
	{
		HealthChecker checker = new(lmClient: null);
		HealthReport report = await checker.CheckAllAsync();

		Assert.Equal(4, report.Checks.Count);
		Assert.InRange(report.OverallScore, 0.0, 1.0);
		Assert.NotEqual(default, report.Timestamp);
	}

	[Fact]
	public async Task CheckAllAsync_ScoreWeightingCorrect()
	{
		HealthChecker checker = new(lmClient: null);
		HealthReport report = await checker.CheckAllAsync();

		// Verify weights sum correctly
		double calculatedScore =
			report.Checks.First(c => c.Name == "MongoDB").Score * 0.3
			+ report.Checks.First(c => c.Name == "DiskSpace").Score * 0.2
			+ report.Checks.First(c => c.Name == "Memory").Score * 0.2
			+ report.Checks.First(c => c.Name == "LMStudio").Score * 0.3;

		Assert.Equal(calculatedScore, report.OverallScore, precision: 4);
	}

	[Fact]
	public async Task CheckMongoDbAsync_InvalidHost_ReturnsZeroScore()
	{
		HealthChecker checker = new(mongoConnectionString: "mongodb://nonexistent-host:99999/test");

		HealthCheckResult result = await checker.CheckMongoDbAsync();

		Assert.Equal(0.0, result.Score);
		Assert.Equal("Failed", result.Status);
	}
}
