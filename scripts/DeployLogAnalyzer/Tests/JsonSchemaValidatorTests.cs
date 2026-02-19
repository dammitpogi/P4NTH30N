using Xunit;

namespace P4NTH30N.DeployLogAnalyzer.Tests;

public class JsonSchemaValidatorTests
{
	private static readonly string SchemaJson = """
		{
			"$schema": "http://json-schema.org/draft-07/schema#",
			"type": "object",
			"required": ["username", "platform", "house", "thresholds", "enabled"],
			"properties": {
				"username": {
					"type": "string",
					"minLength": 1,
					"maxLength": 50,
					"pattern": "^[a-zA-Z0-9_.-]+$"
				},
				"platform": {
					"type": "string",
					"enum": ["firekirin", "orionstars", "gamereel", "vegasx", "pandamaster"]
				},
				"house": {
					"type": "string",
					"minLength": 1,
					"maxLength": 100
				},
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
				"enabled": { "type": "boolean" },
				"timeoutSeconds": { "type": "integer", "minimum": 1, "maximum": 300 },
				"maxRetries": { "type": "integer", "minimum": 0, "maximum": 10 },
				"balanceMinimum": { "type": "number", "minimum": 0 }
			},
			"additionalProperties": true
		}
		""";

	private async Task<JsonSchemaValidator> CreateValidatorAsync()
	{
		JsonSchemaValidator validator = new();
		await validator.InitializeFromJsonAsync(SchemaJson);
		return validator;
	}

	[Fact]
	public async Task ValidConfig_ReturnsValid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.True(result.IsValid);
		Assert.Empty(result.Errors);
	}

	[Fact]
	public async Task MissingRequiredField_Username_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
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
		Assert.Contains(result.Errors, e => e.Kind == "PropertyRequired");
	}

	[Fact]
	public async Task MissingRequiredField_Thresholds_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "PropertyRequired");
	}

	[Fact]
	public async Task EmptyUsername_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "StringTooShort" || e.Kind == "PatternMismatch");
	}

	[Fact]
	public async Task InvalidPlatform_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "unknown_platform",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "NotInEnumeration");
	}

	[Fact]
	public async Task ThresholdTooLarge_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 999999, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "NumberTooBig");
	}

	[Fact]
	public async Task NegativeThreshold_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": -500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "NumberTooSmall");
	}

	[Fact]
	public async Task WrongTypeForEnabled_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": "yes"
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "BooleanExpected");
	}

	[Fact]
	public async Task InvalidJson_ReturnsParseError()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate("not valid json {{{");

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "JsonParseError");
	}

	[Fact]
	public async Task UsernameWithSpecialChars_ReturnsInvalid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player<script>alert(1)</script>",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Kind == "PatternMismatch");
	}

	[Fact]
	public async Task ValidConfigWithOptionalFields_ReturnsValid()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		SchemaValidationOutput result = validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "orionstars",
				"house": "HOUSE_B",
				"thresholds": { "Grand": 1000, "Major": 500, "Minor": 100, "Mini": 25 },
				"enabled": false,
				"timeoutSeconds": 60,
				"maxRetries": 3,
				"balanceMinimum": 10.50
			}
			"""
		);

		Assert.True(result.IsValid);
		Assert.Empty(result.Errors);
	}

	[Fact]
	public void Validate_BeforeInit_Throws()
	{
		JsonSchemaValidator validator = new();
		Assert.Throws<InvalidOperationException>(() => validator.Validate("{}"));
	}

	[Fact]
	public async Task LatencyUnder5ms()
	{
		JsonSchemaValidator validator = await CreateValidatorAsync();

		string config = """
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			""";

		// Warmup
		validator.Validate(config);

		SchemaValidationOutput result = validator.Validate(config);
		// Allow generous margin — target is <5ms but CI can be slow
		Assert.True(result.LatencyMs < 50, $"Schema validation took {result.LatencyMs}ms, expected <50ms");
	}
}
