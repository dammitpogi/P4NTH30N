using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Agent;
using P4NTHE0N.W4TCHD0G.Models;

namespace UNI7T35T.Mocks;

/// <summary>
/// TEST-035: Mock FourEyes client for testing vision pipeline integration.
/// Returns configurable results without requiring actual RTMP stream or OBS.
/// </summary>
public sealed class MockFourEyesClient : IFourEyesAgent
{
	private readonly List<CycleResult> _cycleHistory = new();

	/// <summary>
	/// Pre-configured cycle results to return from the mock.
	/// </summary>
	public Queue<CycleResult> ProgrammedCycles { get; } = new();

	/// <summary>
	/// Number of cycles executed.
	/// </summary>
	public int CyclesExecuted => _cycleHistory.Count;

	/// <summary>
	/// All cycle results produced.
	/// </summary>
	public IReadOnlyList<CycleResult> CycleHistory => _cycleHistory;

	public bool IsRunning { get; private set; }
	public AgentStatus Status { get; private set; } = AgentStatus.Stopped;
	public event Action<CycleResult>? OnCycleComplete;

	/// <summary>
	/// Simulates starting the agent.
	/// </summary>
	public Task StartAsync(CancellationToken cancellationToken = default)
	{
		IsRunning = true;
		Status = AgentStatus.Running;
		Console.WriteLine("[MockFourEyes] Started (mock mode)");
		return Task.CompletedTask;
	}

	/// <summary>
	/// Simulates stopping the agent.
	/// </summary>
	public Task StopAsync()
	{
		IsRunning = false;
		Status = AgentStatus.Stopped;
		Console.WriteLine("[MockFourEyes] Stopped (mock mode)");
		return Task.CompletedTask;
	}

	/// <summary>
	/// Simulates a single cycle execution.
	/// Returns the next programmed result or a default no-frame result.
	/// </summary>
	public CycleResult SimulateCycle()
	{
		CycleResult result;
		if (ProgrammedCycles.Count > 0)
		{
			result = ProgrammedCycles.Dequeue();
		}
		else
		{
			result = new CycleResult
			{
				FrameAvailable = false,
				Decision = "No frame (mock)",
				CycleDurationMs = 10,
			};
		}

		_cycleHistory.Add(result);
		OnCycleComplete?.Invoke(result);
		return result;
	}

	/// <summary>
	/// Programs a series of cycle results for testing.
	/// </summary>
	public void ProgramCycleResults(params CycleResult[] results)
	{
		foreach (CycleResult r in results)
			ProgrammedCycles.Enqueue(r);
	}

	public void Dispose()
	{
		IsRunning = false;
		Status = AgentStatus.Stopped;
	}
}
