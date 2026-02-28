using Xunit;

namespace P4NTHE0N.DeployLogAnalyzer.Tests;

public class FewShotPromptTests
{
	[Fact]
	public void GetConfigValidationPrompt_ContainsExamples()
	{
		string prompt = FewShotPrompt.GetConfigValidationPrompt();

		Assert.NotEmpty(prompt);
		Assert.Contains("Example 1", prompt);
		Assert.Contains("Example 2", prompt);
		Assert.Contains("Example 3", prompt);
		Assert.Contains("Example 4", prompt);
		Assert.Contains("Example 5", prompt);
	}

	[Fact]
	public void GetConfigValidationPrompt_ContainsOutputFormat()
	{
		string prompt = FewShotPrompt.GetConfigValidationPrompt();

		Assert.Contains("valid", prompt);
		Assert.Contains("confidence", prompt);
		Assert.Contains("failures", prompt);
		Assert.Contains("JSON", prompt);
	}

	[Fact]
	public void GetConfigValidationPrompt_ContainsValidationRules()
	{
		string prompt = FewShotPrompt.GetConfigValidationPrompt();

		Assert.Contains("username", prompt);
		Assert.Contains("platform", prompt);
		Assert.Contains("thresholds", prompt);
		Assert.Contains("descending order", prompt);
		Assert.Contains("grand > major > minor > mini", prompt);
	}

	[Fact]
	public void GetLogClassificationPrompt_ContainsExamples()
	{
		string prompt = FewShotPrompt.GetLogClassificationPrompt();

		Assert.NotEmpty(prompt);
		Assert.Contains("Example 1", prompt);
		Assert.Contains("Example 2", prompt);
		Assert.Contains("Example 3", prompt);
		Assert.Contains("Example 4", prompt);
	}

	[Fact]
	public void GetLogClassificationPrompt_ContainsSeverityLevels()
	{
		string prompt = FewShotPrompt.GetLogClassificationPrompt();

		Assert.Contains("CRITICAL", prompt);
		Assert.Contains("WARNING", prompt);
		Assert.Contains("INFO", prompt);
	}

	[Fact]
	public void GetDeploymentDecisionPrompt_ContainsGoNoGoExamples()
	{
		string prompt = FewShotPrompt.GetDeploymentDecisionPrompt();

		Assert.NotEmpty(prompt);
		Assert.Contains("GO", prompt);
		Assert.Contains("NO-GO", prompt);
		Assert.Contains("healthScore", prompt);
		Assert.Contains("decision", prompt);
	}

	[Fact]
	public void GetDeploymentDecisionPrompt_ContainsDecisionCriteria()
	{
		string prompt = FewShotPrompt.GetDeploymentDecisionPrompt();

		Assert.Contains("Health score >= 0.7", prompt);
		Assert.Contains("CRITICAL", prompt);
	}
}
