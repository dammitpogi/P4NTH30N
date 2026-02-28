using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using MongoDB.Driver;
using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Generates test reports in JSON and persists to MongoDB.
/// Produces structured output for CI/CD integration and historical tracking.
/// </summary>
public sealed class TestReportGenerator
{
	private readonly IMongoCollection<TestResult>? _collection;
	private readonly string? _jsonOutputDirectory;

	/// <summary>
	/// Creates a report generator with optional MongoDB and file output.
	/// </summary>
	/// <param name="database">MongoDB database for persisting results (null to skip).</param>
	/// <param name="jsonOutputDirectory">Directory for JSON report output (null to skip).</param>
	public TestReportGenerator(IMongoDatabase? database = null, string? jsonOutputDirectory = null)
	{
		_collection = database?.GetCollection<TestResult>("T35T_R3SULT");
		_jsonOutputDirectory = jsonOutputDirectory;

		if (_jsonOutputDirectory != null && !Directory.Exists(_jsonOutputDirectory))
			Directory.CreateDirectory(_jsonOutputDirectory);
	}

	/// <summary>
	/// Persists a single test result to MongoDB and/or JSON file.
	/// </summary>
	public async Task SaveResultAsync(TestResult result, CancellationToken ct = default)
	{
		// Persist to MongoDB
		if (_collection != null)
		{
			try
			{
				await _collection.InsertOneAsync(result, cancellationToken: ct);
				Console.WriteLine($"[TestReport] Saved to MongoDB: {result.TestName} = {result.Status}");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[TestReport] MongoDB save failed: {ex.Message}");
			}
		}

		// Write JSON file
		if (_jsonOutputDirectory != null)
		{
			try
			{
				string fileName = $"{result.TestRunId}_{result.TestName}.json";
				string filePath = Path.Combine(_jsonOutputDirectory, fileName);
				string json = JsonSerializer.Serialize(result, new JsonSerializerOptions { WriteIndented = true });
				await File.WriteAllTextAsync(filePath, json, ct);
				Console.WriteLine($"[TestReport] JSON saved: {filePath}");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[TestReport] JSON save failed: {ex.Message}");
			}
		}
	}

	/// <summary>
	/// Generates a summary report for a collection of test results.
	/// </summary>
	public async Task<TestSummary> GenerateSummaryAsync(IReadOnlyList<TestResult> results, string testRunId, CancellationToken ct = default)
	{
		TestSummary summary = new()
		{
			TestRunId = testRunId,
			GeneratedAt = DateTime.UtcNow,
			TotalTests = results.Count,
			Passed = results.Count(r => r.Status == TestStatus.Passed),
			Failed = results.Count(r => r.Status == TestStatus.Failed),
			Skipped = results.Count(r => r.Status == TestStatus.Skipped),
			TimedOut = results.Count(r => r.Status == TestStatus.TimedOut),
			TotalDurationMs = results.Sum(r => r.DurationMs),
			TotalFramesCaptured = results.Sum(r => r.CapturedFrames.Count),
			Results = results.ToList(),
		};

		// Write summary JSON
		if (_jsonOutputDirectory != null)
		{
			try
			{
				string filePath = Path.Combine(_jsonOutputDirectory, $"{testRunId}_SUMMARY.json");
				string json = JsonSerializer.Serialize(summary, new JsonSerializerOptions { WriteIndented = true });
				await File.WriteAllTextAsync(filePath, json, ct);
				Console.WriteLine($"[TestReport] Summary saved: {filePath}");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[TestReport] Summary save failed: {ex.Message}");
			}
		}

		// Print summary to console
		Console.WriteLine($"\n╔══════════════════════════════════════════════╗");
		Console.WriteLine($"║  E2E TEST SUMMARY: {summary.Passed}/{summary.TotalTests} passed");
		Console.WriteLine($"║  Failed: {summary.Failed} | Skipped: {summary.Skipped} | TimedOut: {summary.TimedOut}");
		Console.WriteLine($"║  Duration: {summary.TotalDurationMs}ms | Frames: {summary.TotalFramesCaptured}");
		Console.WriteLine($"╚══════════════════════════════════════════════╝\n");

		return summary;
	}
}

/// <summary>
/// Summary of a complete test run.
/// </summary>
public sealed class TestSummary
{
	public string TestRunId { get; set; } = string.Empty;
	public DateTime GeneratedAt { get; set; }
	public int TotalTests { get; set; }
	public int Passed { get; set; }
	public int Failed { get; set; }
	public int Skipped { get; set; }
	public int TimedOut { get; set; }
	public long TotalDurationMs { get; set; }
	public int TotalFramesCaptured { get; set; }
	public List<TestResult> Results { get; set; } = new();
	public bool AllPassed => Failed == 0 && TimedOut == 0;
}
