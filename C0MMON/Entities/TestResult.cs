using System;
using System.Collections.Generic;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.C0MMON.Entities;

/// <summary>
/// TEST-035: Entity representing the result of an E2E test execution.
/// Stored in MongoDB T35T_R3SULT collection for tracking and analysis.
/// </summary>
[BsonIgnoreExtraElements]
public class TestResult
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	/// <summary>
	/// Unique test run identifier.
	/// </summary>
	public string TestRunId { get; set; } = Guid.NewGuid().ToString("N");

	/// <summary>
	/// Test name (e.g., "E2E_FireKirin_Signal_Spin").
	/// </summary>
	public string TestName { get; set; } = string.Empty;

	/// <summary>
	/// Test category: SignalInjection, Login, GameReadiness, SpinExecution, SplashDetection, VisionCapture.
	/// </summary>
	public string Category { get; set; } = string.Empty;

	/// <summary>
	/// Overall test status.
	/// </summary>
	public TestStatus Status { get; set; } = TestStatus.Pending;

	/// <summary>
	/// Game platform tested (FireKirin, OrionStars).
	/// </summary>
	public string Game { get; set; } = string.Empty;

	/// <summary>
	/// House used for testing.
	/// </summary>
	public string House { get; set; } = string.Empty;

	/// <summary>
	/// Username used for testing.
	/// </summary>
	public string Username { get; set; } = string.Empty;

	/// <summary>
	/// When the test started.
	/// </summary>
	public DateTime StartedAt { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// When the test completed.
	/// </summary>
	public DateTime? CompletedAt { get; set; }

	/// <summary>
	/// Duration in milliseconds.
	/// </summary>
	public long DurationMs { get; set; }

	/// <summary>
	/// Individual step results within the test.
	/// </summary>
	public List<TestStepResult> Steps { get; set; } = new();

	/// <summary>
	/// Captured frames during the test (file paths or base64 refs).
	/// </summary>
	public List<CapturedFrame> CapturedFrames { get; set; } = new();

	/// <summary>
	/// Jackpot values observed during the test.
	/// </summary>
	public Dictionary<string, double> ObservedJackpots { get; set; } = new();

	/// <summary>
	/// Balance before test execution.
	/// </summary>
	public double BalanceBefore { get; set; }

	/// <summary>
	/// Balance after test execution.
	/// </summary>
	public double BalanceAfter { get; set; }

	/// <summary>
	/// Error message if the test failed.
	/// </summary>
	public string? ErrorMessage { get; set; }

	/// <summary>
	/// Stack trace if the test failed.
	/// </summary>
	public string? ErrorStackTrace { get; set; }

	/// <summary>
	/// Whether this was a test signal (flagged for cleanup).
	/// </summary>
	public bool IsTestSignal { get; set; } = true;

	/// <summary>
	/// Additional metadata for the test run.
	/// </summary>
	public Dictionary<string, string> Metadata { get; set; } = new();

	/// <summary>
	/// Marks the test as passed.
	/// </summary>
	public void Pass(string? message = null)
	{
		Status = TestStatus.Passed;
		CompletedAt = DateTime.UtcNow;
		DurationMs = (long)(CompletedAt.Value - StartedAt).TotalMilliseconds;
		if (message != null)
			Metadata["passMessage"] = message;
	}

	/// <summary>
	/// Marks the test as failed.
	/// </summary>
	public void Fail(string error, string? stackTrace = null)
	{
		Status = TestStatus.Failed;
		CompletedAt = DateTime.UtcNow;
		DurationMs = (long)(CompletedAt.Value - StartedAt).TotalMilliseconds;
		ErrorMessage = error;
		ErrorStackTrace = stackTrace;
	}

	/// <summary>
	/// Marks the test as skipped.
	/// </summary>
	public void Skip(string reason)
	{
		Status = TestStatus.Skipped;
		CompletedAt = DateTime.UtcNow;
		DurationMs = 0;
		Metadata["skipReason"] = reason;
	}
}

/// <summary>
/// Result of a single step within a test.
/// </summary>
public class TestStepResult
{
	public string StepName { get; set; } = string.Empty;
	public TestStatus Status { get; set; } = TestStatus.Pending;
	public long DurationMs { get; set; }
	public string? ErrorMessage { get; set; }
	public Dictionary<string, string> Data { get; set; } = new();
}

/// <summary>
/// A frame captured during testing for vision training data.
/// </summary>
public class CapturedFrame
{
	public string FrameId { get; set; } = Guid.NewGuid().ToString("N");
	public DateTime CapturedAt { get; set; } = DateTime.UtcNow;
	public string FilePath { get; set; } = string.Empty;
	public string GameState { get; set; } = string.Empty;
	public string Label { get; set; } = string.Empty;
	public int Width { get; set; }
	public int Height { get; set; }
}

/// <summary>
/// Test execution status.
/// </summary>
public enum TestStatus
{
	Pending,
	Running,
	Passed,
	Failed,
	Skipped,
	TimedOut,
}
