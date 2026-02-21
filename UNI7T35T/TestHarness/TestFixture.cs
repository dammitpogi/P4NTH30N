using System;
using System.Collections.Generic;
using System.Diagnostics;
using P4NTH30N.C0MMON.Entities;

namespace P4NTH30N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Base test fixture providing lifecycle management for E2E tests.
/// Handles setup, teardown, timing, and result collection.
/// </summary>
public abstract class TestFixture
{
	/// <summary>
	/// Test configuration.
	/// </summary>
	protected TestConfiguration Config { get; }

	/// <summary>
	/// Current test result being built.
	/// </summary>
	protected TestResult CurrentResult { get; private set; } = new();

	/// <summary>
	/// Stopwatch for the current test.
	/// </summary>
	private readonly Stopwatch _stopwatch = new();

	protected TestFixture(TestConfiguration config)
	{
		Config = config;
	}

	/// <summary>
	/// Runs a named test step with timing and error capture.
	/// </summary>
	protected TestStepResult RunStep(string stepName, Func<bool> action)
	{
		Stopwatch stepSw = Stopwatch.StartNew();
		TestStepResult step = new() { StepName = stepName };

		try
		{
			bool success = action();
			stepSw.Stop();
			step.DurationMs = stepSw.ElapsedMilliseconds;
			step.Status = success ? TestStatus.Passed : TestStatus.Failed;
			if (!success)
				step.ErrorMessage = $"Step '{stepName}' returned false";
		}
		catch (Exception ex)
		{
			stepSw.Stop();
			step.DurationMs = stepSw.ElapsedMilliseconds;
			step.Status = TestStatus.Failed;
			step.ErrorMessage = ex.Message;
			Console.WriteLine($"[TestFixture] Step '{stepName}' failed: {ex.Message}");
		}

		CurrentResult.Steps.Add(step);
		return step;
	}

	/// <summary>
	/// Runs a named async test step with timing and error capture.
	/// </summary>
	protected async Task<TestStepResult> RunStepAsync(string stepName, Func<Task<bool>> action)
	{
		Stopwatch stepSw = Stopwatch.StartNew();
		TestStepResult step = new() { StepName = stepName };

		try
		{
			bool success = await action();
			stepSw.Stop();
			step.DurationMs = stepSw.ElapsedMilliseconds;
			step.Status = success ? TestStatus.Passed : TestStatus.Failed;
			if (!success)
				step.ErrorMessage = $"Step '{stepName}' returned false";
		}
		catch (Exception ex)
		{
			stepSw.Stop();
			step.DurationMs = stepSw.ElapsedMilliseconds;
			step.Status = TestStatus.Failed;
			step.ErrorMessage = ex.Message;
			Console.WriteLine($"[TestFixture] Async step '{stepName}' failed: {ex.Message}");
		}

		CurrentResult.Steps.Add(step);
		return step;
	}

	/// <summary>
	/// Initializes a new test result and starts timing.
	/// </summary>
	protected void BeginTest(string testName, string category, string game, string house, string username)
	{
		CurrentResult = new TestResult
		{
			TestName = testName,
			Category = category,
			Game = game,
			House = house,
			Username = username,
			Status = TestStatus.Running,
			StartedAt = DateTime.UtcNow,
		};
		_stopwatch.Restart();
		Console.WriteLine($"[TestFixture] BEGIN: {testName} ({game}/{house}/{username})");
	}

	/// <summary>
	/// Finalizes the current test result.
	/// </summary>
	protected TestResult EndTest(bool passed, string? message = null)
	{
		_stopwatch.Stop();
		CurrentResult.DurationMs = _stopwatch.ElapsedMilliseconds;

		if (passed)
			CurrentResult.Pass(message);
		else
			CurrentResult.Fail(message ?? "Test failed");

		Console.WriteLine($"[TestFixture] END: {CurrentResult.TestName} = {CurrentResult.Status} ({CurrentResult.DurationMs}ms)");
		return CurrentResult;
	}
}
