using Xunit;

namespace P4NTHE0N.DeployLogAnalyzer.Tests;

public class LogClassifierTests
{
	private readonly LogClassifier _classifier = new(lmClient: null);

	[Theory]
	[InlineData("error CS1729: 'MongoUnitOfWork' does not contain a constructor", LogSeverity.Critical)]
	[InlineData("error MSB4018: The 'ResolveAssemblyReference' task failed", LogSeverity.Critical)]
	[InlineData("Unhandled exception: System.NullReferenceException", LogSeverity.Critical)]
	[InlineData("NullReferenceException at H0UND.cs:line 42", LogSeverity.Critical)]
	[InlineData("OutOfMemoryException in process", LogSeverity.Critical)]
	[InlineData("StackOverflowException detected", LogSeverity.Critical)]
	public void ClassifyByRules_CriticalErrors_ReturnsCritical(string logLine, LogSeverity expected)
	{
		LogClassification? result = LogClassifier.ClassifyByRules(logLine);

		Assert.NotNull(result);
		Assert.Equal(expected, result.Severity);
		Assert.True(result.ActionRequired);
		Assert.Equal(ClassificationSource.RuleBased, result.Source);
	}

	[Theory]
	[InlineData("warn: MongoDB connection pool exhausted", LogSeverity.Warning)]
	[InlineData("TimeoutException: Operation timed out after 30s", LogSeverity.Warning)]
	[InlineData("Using deprecated API: GetLegacyCredentials", LogSeverity.Warning)]
	[InlineData("retry attempt 3 of 5 for credential fetch", LogSeverity.Warning)]
	public void ClassifyByRules_Warnings_ReturnsWarning(string logLine, LogSeverity expected)
	{
		LogClassification? result = LogClassifier.ClassifyByRules(logLine);

		Assert.NotNull(result);
		Assert.Equal(expected, result.Severity);
		Assert.False(result.ActionRequired);
	}

	[Theory]
	[InlineData("Build succeeded. 0 Warning(s) 0 Error(s)", LogSeverity.Info)]
	[InlineData("info: Application started successfully", LogSeverity.Info)]
	public void ClassifyByRules_Info_ReturnsInfo(string logLine, LogSeverity expected)
	{
		LogClassification? result = LogClassifier.ClassifyByRules(logLine);

		Assert.NotNull(result);
		Assert.Equal(expected, result.Severity);
		Assert.False(result.ActionRequired);
	}

	[Fact]
	public void ClassifyByRules_UnknownPattern_ReturnsNull()
	{
		LogClassification? result = LogClassifier.ClassifyByRules("Just some random text here");
		Assert.Null(result);
	}

	[Fact]
	public async Task ClassifyAsync_UnknownNoLlm_ReturnsDefault()
	{
		LogClassification result = await _classifier.ClassifyAsync("Some unrecognized log line", useLlmFallback: false);

		Assert.Equal(LogSeverity.Info, result.Severity);
		Assert.Equal("unclassified", result.Category);
		Assert.Equal(ClassificationSource.Default, result.Source);
	}

	[Fact]
	public async Task AnalyzeBuildLogAsync_MixedLogs_CountsCorrectly()
	{
		List<string> logLines = new()
		{
			"info: Starting build...",
			"error CS1729: Constructor mismatch",
			"warn: Deprecated API usage",
			"NullReferenceException at line 42",
			"Build succeeded. 0 Warning(s) 0 Error(s)",
			"",
			"warning: Slow query detected",
		};

		LogAnalysisReport report = await _classifier.AnalyzeBuildLogAsync(logLines);

		Assert.Equal(6, report.TotalLines);
		Assert.Equal(2, report.CriticalCount);
		Assert.True(report.WarningCount >= 2);
		Assert.True(report.InfoCount >= 1);
		Assert.True(report.ErrorPatterns.Count >= 1);
	}

	[Fact]
	public async Task AnalyzeBuildLogAsync_EmptyLog_ReturnsEmptyReport()
	{
		LogAnalysisReport report = await _classifier.AnalyzeBuildLogAsync(Array.Empty<string>());

		Assert.Equal(0, report.TotalLines);
		Assert.Equal(0, report.CriticalCount);
		Assert.Empty(report.Classifications);
	}

	[Fact]
	public void ClassifyByRules_LongLogLine_TruncatesMessage()
	{
		string longLine = "error CS1729: " + new string('x', 300);
		LogClassification? result = LogClassifier.ClassifyByRules(longLine);

		Assert.NotNull(result);
		Assert.True(result.Message.Length <= 203);
		Assert.EndsWith("...", result.Message);
	}
}
