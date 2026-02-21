using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using P4NTH30N.C0MMON.Services;

namespace P4NTH30N.PROF3T.Forgewright;

/// <summary>
/// FOUREYES-024-D: Conditional automated fix system.
/// Automatically applies fixes that meet confidence and safety thresholds.
/// Only applies auto-fixable suggestions with high confidence and low risk.
/// </summary>
public class ConditionalAutomationService
{
	private readonly ForgewrightAnalysisService _analysisService;
	private readonly SafeFixApplicator _applicator;
	private readonly PlatformGenerator _generator;
	private readonly AutomationConfig _config;
	private readonly List<AutomationResult> _results = new();

	public ConditionalAutomationService(
		ForgewrightAnalysisService analysisService,
		SafeFixApplicator applicator,
		PlatformGenerator generator,
		AutomationConfig? config = null
	)
	{
		_analysisService = analysisService;
		_applicator = applicator;
		_generator = generator;
		_config = config ?? new AutomationConfig();
	}

	/// <summary>
	/// Evaluates a bug report and conditionally applies an automated fix.
	/// </summary>
	public AutomationResult EvaluateAndFix(BugReport bug)
	{
		AutomationResult result = new() { BugId = bug.Id };

		try
		{
			// Step 1: Analyze the bug
			FixAnalysis analysis = _analysisService.Analyze(bug);
			result.Analysis = analysis;

			// Step 2: Check if auto-fix is possible and safe
			if (!analysis.CanAutoFix)
			{
				result.Decision = AutomationDecision.RequiresHumanReview;
				result.Reason = "Analysis indicates manual review needed";
				return result;
			}

			if (analysis.Confidence < _config.MinConfidenceForAutoFix)
			{
				result.Decision = AutomationDecision.InsufficientConfidence;
				result.Reason = $"Confidence {analysis.Confidence:F2} below threshold {_config.MinConfidenceForAutoFix:F2}";
				return result;
			}

			// Step 3: Find the best auto-fixable suggestion
			FixSuggestion? bestSuggestion = analysis
				.Suggestions.Where(s => s.IsAutoFixable && s.Confidence >= _config.MinSuggestionConfidence)
				.OrderByDescending(s => s.Confidence)
				.FirstOrDefault();

			if (bestSuggestion == null)
			{
				result.Decision = AutomationDecision.NoSuitableFix;
				result.Reason = "No auto-fixable suggestions meet confidence threshold";
				return result;
			}

			// Step 4: Check safety constraints
			if (!IsSafeToAutoFix(bug, analysis))
			{
				result.Decision = AutomationDecision.SafetyBlock;
				result.Reason = "Safety constraints prevent auto-fix";
				return result;
			}

			// Step 5: Generate patch and apply
			string patch = _generator.GeneratePatch(analysis, bestSuggestion);
			result.GeneratedPatch = patch;

			if (_config.DryRun)
			{
				result.Decision = AutomationDecision.DryRunSuccess;
				result.Reason = "Dry run - patch generated but not applied";
			}
			else
			{
				AppliedFix appliedFix = _applicator.ApplyFix(analysis, bestSuggestion);
				result.AppliedFix = appliedFix;
				result.Decision = appliedFix.Success ? AutomationDecision.Applied : AutomationDecision.ApplyFailed;
				result.Reason = appliedFix.Success ? "Fix applied successfully" : $"Apply failed: {appliedFix.ErrorMessage}";
			}
		}
		catch (Exception ex)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [ConditionalAutomation] Error: {ex.Message}");
			result.Decision = AutomationDecision.Error;
			result.Reason = ex.Message;
		}

		_results.Add(result);
		Console.WriteLine($"[ConditionalAutomation] Bug {bug.Id}: {result.Decision} - {result.Reason}");
		return result;
	}

	/// <summary>
	/// Gets all automation results.
	/// </summary>
	public IReadOnlyList<AutomationResult> GetResults()
	{
		return _results;
	}

	/// <summary>
	/// Gets automation success rate.
	/// </summary>
	public double GetSuccessRate()
	{
		if (_results.Count == 0)
			return 0;
		int successful = _results.Count(r => r.Decision == AutomationDecision.Applied || r.Decision == AutomationDecision.DryRunSuccess);
		return (double)successful / _results.Count;
	}

	private bool IsSafeToAutoFix(BugReport bug, FixAnalysis analysis)
	{
		// Don't auto-fix critical infrastructure components
		if (_config.ProtectedComponents.Contains(bug.Component))
			return false;

		// Don't auto-fix if occurrence count is too low (might be flaky)
		if (bug.OccurrenceCount < _config.MinOccurrencesForAutoFix)
			return false;

		// Don't auto-fix if we've already failed to fix this bug
		if (_results.Any(r => r.BugId == bug.Id && r.Decision == AutomationDecision.ApplyFailed))
			return false;

		return true;
	}
}

public class AutomationConfig
{
	public double MinConfidenceForAutoFix { get; set; } = 0.7;
	public double MinSuggestionConfidence { get; set; } = 0.6;
	public int MinOccurrencesForAutoFix { get; set; } = 3;
	public bool DryRun { get; set; } = true; // Default to dry-run for safety
	public HashSet<string> ProtectedComponents { get; set; } = new() { "H4ND", "H0UND", "Database" };
}

public class AutomationResult
{
	public string BugId { get; set; } = string.Empty;
	public AutomationDecision Decision { get; set; }
	public string Reason { get; set; } = string.Empty;
	public FixAnalysis? Analysis { get; set; }
	public string GeneratedPatch { get; set; } = string.Empty;
	public AppliedFix? AppliedFix { get; set; }
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}

public enum AutomationDecision
{
	Applied,
	DryRunSuccess,
	RequiresHumanReview,
	InsufficientConfidence,
	NoSuitableFix,
	SafetyBlock,
	ApplyFailed,
	Error,
}
