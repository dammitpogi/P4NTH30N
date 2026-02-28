using Xunit;

namespace P4NTHE0N.DeployLogAnalyzer.Tests;

public class TwoStagePipelineTests
{
	private static readonly string SchemaJson = """
		{
			"$schema": "http://json-schema.org/draft-07/schema#",
			"type": "object",
			"required": ["username", "platform", "house", "thresholds", "enabled"],
			"properties": {
				"username": { "type": "string", "minLength": 1, "pattern": "^[a-zA-Z0-9_.-]+$" },
				"platform": { "type": "string", "enum": ["firekirin", "orionstars", "gamereel", "vegasx", "pandamaster"] },
				"house": { "type": "string", "minLength": 1 },
				"thresholds": {
					"type": "object",
					"required": ["Grand", "Major", "Minor", "Mini"],
					"properties": {
						"Grand": { "type": "number", "minimum": 1, "maximum": 100000 },
						"Major": { "type": "number", "minimum": 1, "maximum": 50000 },
						"Minor": { "type": "number", "minimum": 1, "maximum": 10000 },
						"Mini": { "type": "number", "minimum": 1, "maximum": 5000 }
					},
					"additionalProperties": false
				},
				"enabled": { "type": "boolean" }
			},
			"additionalProperties": true
		}
		""";

	private static readonly string ValidConfig = """
		{
			"username": "player1",
			"platform": "firekirin",
			"house": "HOUSE_A",
			"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
			"enabled": true
		}
		""";

	private async Task<ValidationPipeline> CreatePipelineAsync(bool llmEnabled = false)
	{
		JsonSchemaValidator schemaValidator = new();
		await schemaValidator.InitializeFromJsonAsync(SchemaJson);
		BusinessRulesValidator businessValidator = new();
		return new ValidationPipeline(schemaValidator, businessValidator, llmEnabled: llmEnabled);
	}

	// ──────────────────────────────────────────────
	// Stage 1: Valid configs pass rule-based
	// ──────────────────────────────────────────────

	[Fact]
	public async Task ValidConfig_PassesRuleBased()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync(ValidConfig);

		Assert.True(result.IsValid);
		Assert.Equal(ValidationStage.RuleBased, result.Stage);
		Assert.Empty(result.Failures);
		Assert.True(result.Confidence >= 0.9);
	}

	// ──────────────────────────────────────────────
	// Stage 1A: Schema failures
	// ──────────────────────────────────────────────

	[Fact]
	public async Task MissingRequired_FailsAtSchema()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync(
			"""
			{
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Equal(ValidationStage.Schema, result.Stage);
		Assert.NotEmpty(result.Failures);
	}

	[Fact]
	public async Task InvalidPlatform_FailsAtSchema()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync(
			"""
			{
				"username": "player1",
				"platform": "invalid_platform",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Equal(ValidationStage.Schema, result.Stage);
	}

	// ──────────────────────────────────────────────
	// Stage 1B: Business rules failures
	// ──────────────────────────────────────────────

	[Fact]
	public async Task BadThresholdOrder_FailsAtBusinessRules()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 50, "Minor": 200, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Equal(ValidationStage.BusinessRules, result.Stage);
		Assert.Contains(result.Failures, f => f.Contains("threshold_ordering"));
	}

	// ──────────────────────────────────────────────
	// Safety: Input sanitization
	// ──────────────────────────────────────────────

	[Fact]
	public async Task EmptyInput_Rejected()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync("");

		Assert.False(result.IsValid);
		Assert.Equal(ValidationStage.Error, result.Stage);
		Assert.Contains(result.Failures, f => f == "empty_input");
	}

	[Fact]
	public async Task WhitespaceOnlyInput_Rejected()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync("   \n\t  ");

		Assert.False(result.IsValid);
		Assert.Contains(result.Failures, f => f == "empty_input");
	}

	[Fact]
	public async Task OversizedInput_Rejected()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		string hugeInput = new string('x', 20000);
		TwoStageResult result = await pipeline.ValidateAsync(hugeInput);

		Assert.False(result.IsValid);
		Assert.Contains(result.Failures, f => f.Contains("input_too_large"));
	}

	// ──────────────────────────────────────────────
	// Safety: Manual override
	// ──────────────────────────────────────────────

	[Fact]
	public async Task ManualOverrideFlag_RequiresReview()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		TwoStageResult result = await pipeline.ValidateAsync(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true,
				"_requires_review": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.True(result.RequiresReview);
		Assert.Contains(result.Failures, f => f == "manual_review_requested");
	}

	// ──────────────────────────────────────────────
	// Circuit breaker
	// ──────────────────────────────────────────────

	[Fact]
	public async Task CircuitBreaker_InitiallyNotTripped()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		Assert.False(pipeline.IsCircuitBreakerTripped);
		Assert.Equal(0.0, pipeline.LlmFailureRate);
	}

	[Fact]
	public async Task CircuitBreaker_ResetWorks()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		pipeline.ResetCircuitBreaker();

		Assert.False(pipeline.IsCircuitBreakerTripped);
	}

	// ──────────────────────────────────────────────
	// Batch validation (legacy)
	// ──────────────────────────────────────────────

	[Fact]
	public async Task BatchValidation_CalculatesMetrics()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		List<ValidationSample> samples = new()
		{
			new()
			{
				Name = "Valid config",
				ConfigJson = ValidConfig,
				ExpectedValid = true,
			},
			new()
			{
				Name = "Missing username",
				ConfigJson = """
					{
						"platform": "firekirin",
						"house": "HOUSE_A",
						"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
						"enabled": true
					}
					""",
				ExpectedValid = false,
			},
			new()
			{
				Name = "Bad threshold order",
				ConfigJson = """
					{
						"username": "player1",
						"platform": "firekirin",
						"house": "HOUSE_A",
						"thresholds": { "Grand": 10, "Major": 200, "Minor": 50, "Mini": 5 },
						"enabled": true
					}
					""",
				ExpectedValid = false,
			},
		};

		PipelineResult result = await pipeline.RunValidationAsync(samples);

		Assert.Equal(3, result.TotalSamples);
		Assert.Equal(3, result.CorrectCount);
		Assert.Equal(1.0, result.Accuracy, precision: 2);
		Assert.True(result.AccuracyPassed);
		Assert.Equal(3, result.SampleResults.Count);
	}

	// ──────────────────────────────────────────────
	// Performance: rule-based should be fast
	// ──────────────────────────────────────────────

	[Fact]
	public async Task RuleBasedValidation_Under10ms()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		// Warmup
		await pipeline.ValidateAsync(ValidConfig);

		TwoStageResult result = await pipeline.ValidateAsync(ValidConfig);

		// Allow generous margin for CI
		Assert.True(result.LatencyMs < 100, $"Rule-based validation took {result.LatencyMs}ms, target <10ms");
	}

	// ──────────────────────────────────────────────
	// Integration: multiple error types
	// ──────────────────────────────────────────────

	[Fact]
	public async Task SchemaError_TakesPrecedence_OverBusinessRules()
	{
		ValidationPipeline pipeline = await CreatePipelineAsync();

		// Both schema invalid (missing username) AND bad threshold order
		TwoStageResult result = await pipeline.ValidateAsync(
			"""
			{
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 10, "Major": 200, "Minor": 50, "Mini": 5 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		// Should fail at Schema stage first, never reaching BusinessRules
		Assert.Equal(ValidationStage.Schema, result.Stage);
	}
}
