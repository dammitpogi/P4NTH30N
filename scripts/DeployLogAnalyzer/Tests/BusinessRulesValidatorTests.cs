using Xunit;

namespace P4NTH30N.DeployLogAnalyzer.Tests;

public class BusinessRulesValidatorTests
{
	private readonly BusinessRulesValidator _validator = new();

	// ──────────────────────────────────────────────
	// Threshold ordering tests
	// ──────────────────────────────────────────────

	[Fact]
	public void ValidThresholdOrder_Passes()
	{
		BusinessRulesOutput result = _validator.Validate(
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
		Assert.False(result.HasErrors);
	}

	[Fact]
	public void GrandLessThanMajor_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 100, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "threshold_ordering" && e.Message.Contains("Grand"));
	}

	[Fact]
	public void MajorLessThanMinor_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 30, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "threshold_ordering" && e.Message.Contains("Major"));
	}

	[Fact]
	public void MinorLessThanMini_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 5, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "threshold_ordering" && e.Message.Contains("Minor"));
	}

	[Fact]
	public void EqualThresholds_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 100, "Major": 100, "Minor": 100, "Mini": 100 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.True(result.Errors.Count(e => e.Rule == "threshold_ordering") >= 3);
	}

	// ──────────────────────────────────────────────
	// Platform limits tests
	// ──────────────────────────────────────────────

	[Fact]
	public void FirekirinGrandWithinLimit_Passes()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 50000, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.True(result.IsValid);
	}

	[Fact]
	public void FirekirinGrandExceedsLimit_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 60000, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "platform_threshold_limit");
	}

	[Fact]
	public void VegasxGrandExceedsLimit_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "vegasx",
				"house": "HOUSE_C",
				"thresholds": { "Grand": 30000, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "platform_threshold_limit" && e.Message.Contains("25000"));
	}

	// ──────────────────────────────────────────────
	// DPD sanity tests
	// ──────────────────────────────────────────────

	[Fact]
	public void DpdLargeWindowSmallSamples_Warns()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true,
				"dpd": { "WindowHours": 48, "MinSamples": 5 }
			}
			"""
		);

		Assert.True(result.IsValid);
		Assert.True(result.HasWarnings);
		Assert.Contains(result.Errors, e => e.Rule == "dpd_sanity" && e.Severity == RuleSeverity.Warning);
	}

	[Fact]
	public void DpdLargeWindowAdequateSamples_NoWarning()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true,
				"dpd": { "WindowHours": 48, "MinSamples": 50 }
			}
			"""
		);

		Assert.True(result.IsValid);
		Assert.False(result.HasWarnings);
	}

	// ──────────────────────────────────────────────
	// Injection detection tests
	// ──────────────────────────────────────────────

	[Fact]
	public void ScriptInjectionInUsername_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "<script>alert(1)</script>",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "injection_detected");
	}

	[Fact]
	public void SqlInjectionInHouse_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A; DELETE FROM users--",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "injection_detected");
	}

	// ──────────────────────────────────────────────
	// Field semantics tests
	// ──────────────────────────────────────────────

	[Fact]
	public void NegativeBalanceMinimum_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true,
				"balanceMinimum": -10
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "balance_minimum");
	}

	[Fact]
	public void TimeoutOutOfRange_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true,
				"timeoutSeconds": 500
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "timeout_range");
	}

	[Fact]
	public void MaxRetriesOutOfRange_Fails()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 500, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true,
				"maxRetries": 15
			}
			"""
		);

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "max_retries_range");
	}

	// ──────────────────────────────────────────────
	// Performance tests
	// ──────────────────────────────────────────────

	[Fact]
	public void LatencyUnder5ms()
	{
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
		_validator.Validate(config);

		BusinessRulesOutput result = _validator.Validate(config);
		Assert.True(result.LatencyMs < 50, $"Business rules validation took {result.LatencyMs}ms, expected <50ms");
	}

	// ──────────────────────────────────────────────
	// Edge cases
	// ──────────────────────────────────────────────

	[Fact]
	public void InvalidJson_ReturnsError()
	{
		BusinessRulesOutput result = _validator.Validate("not json");

		Assert.False(result.IsValid);
		Assert.Contains(result.Errors, e => e.Rule == "json_parse");
	}

	[Fact]
	public void MissingThresholds_NoThresholdErrors()
	{
		// No thresholds key → no threshold ordering errors (schema catches this)
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"enabled": true
			}
			"""
		);

		Assert.True(result.IsValid);
		Assert.DoesNotContain(result.Errors, e => e.Rule == "threshold_ordering");
	}

	[Fact]
	public void GetErrorMessages_FormatsCorrectly()
	{
		BusinessRulesOutput result = _validator.Validate(
			"""
			{
				"username": "player1",
				"platform": "firekirin",
				"house": "HOUSE_A",
				"thresholds": { "Grand": 100, "Major": 200, "Minor": 50, "Mini": 10 },
				"enabled": true
			}
			"""
		);

		IReadOnlyList<string> messages = result.GetErrorMessages();
		Assert.NotEmpty(messages);
		Assert.All(messages, m => Assert.Contains("[Error]", m));
	}
}
