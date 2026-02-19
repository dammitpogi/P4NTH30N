using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;

namespace P4NTH30N.C0MMON.Services;

/// <summary>
/// Keyword-based task complexity estimator.
/// Scores tasks by matching keywords against configurable complexity tiers.
/// WIND-002: Simple=1pt, Medium=2pts, Complex=3pts, Critical=4pts.
/// </summary>
public class ComplexityEstimator {
	private readonly Dictionary<string, ComplexityTier> _tiers;

	public ComplexityEstimator(Dictionary<string, ComplexityTier>? tiers = null) {
		_tiers = tiers ?? GetDefaultTiers();
	}

	/// <summary>
	/// Loads complexity keywords from a JSON configuration file.
	/// </summary>
	public static ComplexityEstimator FromJson(string jsonPath) {
		if (!File.Exists(jsonPath))
			throw new FileNotFoundException($"Complexity keywords config not found: {jsonPath}");

		string json = File.ReadAllText(jsonPath);
		Dictionary<string, ComplexityTier>? tiers = JsonSerializer.Deserialize<Dictionary<string, ComplexityTier>>(json, new JsonSerializerOptions {
			PropertyNameCaseInsensitive = true,
		});

		return new ComplexityEstimator(tiers);
	}

	/// <summary>
	/// Estimates complexity score for a given task description.
	/// Returns the highest matching tier score.
	/// </summary>
	public ComplexityResult Estimate(string taskDescription) {
		if (string.IsNullOrWhiteSpace(taskDescription))
			return new ComplexityResult(0, "unknown", "Empty task description");

		string lower = taskDescription.ToLowerInvariant();
		int maxScore = 0;
		string matchedTier = "unknown";
		List<string> matchedKeywords = new();

		foreach (KeyValuePair<string, ComplexityTier> tier in _tiers) {
			foreach (string keyword in tier.Value.Keywords) {
				if (lower.Contains(keyword, StringComparison.OrdinalIgnoreCase)) {
					matchedKeywords.Add(keyword);
					if (tier.Value.Score > maxScore) {
						maxScore = tier.Value.Score;
						matchedTier = tier.Key;
					}
				}
			}
		}

		if (maxScore == 0) {
			maxScore = 1;
			matchedTier = "simple";
		}

		return new ComplexityResult(maxScore, matchedTier, $"Matched: [{string.Join(", ", matchedKeywords)}]");
	}

	private static Dictionary<string, ComplexityTier> GetDefaultTiers() {
		return new Dictionary<string, ComplexityTier> {
			["simple"] = new ComplexityTier {
				Keywords = new List<string> { "doc", "typo", "comment", "readme", "bugfix", "hotfix", "lint", "format", "rename", "spelling" },
				Score = 1,
				Description = "Documentation, typo fixes, formatting changes",
			},
			["medium"] = new ComplexityTier {
				Keywords = new List<string> { "feature", "refactor", "update", "add", "remove", "change", "fix", "test", "endpoint", "service", "handler" },
				Score = 2,
				Description = "Feature additions, refactors, service changes",
			},
			["complex"] = new ComplexityTier {
				Keywords = new List<string> { "architecture", "migration", "redesign", "infrastructure", "database", "schema", "pipeline", "security", "auth", "encryption" },
				Score = 3,
				Description = "Architectural changes, migrations, security overhauls",
			},
			["critical"] = new ComplexityTier {
				Keywords = new List<string> { "breaking", "rollback", "disaster", "production", "hotdeploy", "emergency" },
				Score = 4,
				Description = "Breaking changes, production emergencies",
			},
		};
	}
}

public class ComplexityTier {
	public List<string> Keywords { get; set; } = new();
	public int Score { get; set; }
	public string Description { get; set; } = string.Empty;
}

public class ComplexityResult {
	public int Score { get; }
	public string Tier { get; }
	public string Reasoning { get; }

	public ComplexityResult(int score, string tier, string reasoning) {
		Score = score;
		Tier = tier;
		Reasoning = reasoning;
	}
}
