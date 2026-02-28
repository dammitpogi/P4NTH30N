using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace P4NTHE0N.SWE.Workflows;

/// <summary>
/// Orchestrator-mediated parallel agent delegation with timeout handling,
/// circuit breaker logic, and result aggregation.
/// </summary>
public sealed class ParallelDelegation
{
	private readonly DelegationConfig _config;
	private readonly CircuitBreaker _circuitBreaker;
	private readonly ConcurrentBag<DelegationResult> _history = new();

	public ParallelDelegation(DelegationConfig? config = null)
	{
		_config = config ?? new DelegationConfig();
		_circuitBreaker = new CircuitBreaker(failureThreshold: _config.CircuitBreakerFailures, cooldownSeconds: _config.CircuitBreakerCooldownSeconds);
	}

	/// <summary>
	/// Delegates multiple research briefs to agents in parallel with timeout.
	/// </summary>
	public async Task<DelegationBatchResult> DelegateAsync(IReadOnlyList<ResearchBrief> briefs, CancellationToken cancellationToken = default)
	{
		DelegationBatchResult batch = new()
		{
			BatchId = Guid.NewGuid().ToString("N")[..8],
			StartedAt = DateTime.UtcNow,
			TotalBriefs = briefs.Count,
		};

		if (_circuitBreaker.IsOpen)
		{
			batch.Status = BatchStatus.CircuitBreakerOpen;
			batch.Results = briefs.Select(b => DelegationResult.Skipped(b, "Circuit breaker open")).ToList();
			return batch;
		}

		// Create timeout cancellation
		using CancellationTokenSource timeoutCts = new(TimeSpan.FromSeconds(_config.TimeoutSeconds));
		using CancellationTokenSource linkedCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeoutCts.Token);

		Stopwatch sw = Stopwatch.StartNew();

		// Execute all briefs in parallel with semaphore for max concurrency
		using SemaphoreSlim semaphore = new(_config.MaxParallelDelegations);
		ConcurrentBag<DelegationResult> results = new();

		List<Task> tasks = briefs
			.Select(async brief =>
			{
				await semaphore.WaitAsync(linkedCts.Token);
				try
				{
					DelegationResult result = await ExecuteBriefAsync(brief, linkedCts.Token);
					results.Add(result);
					_history.Add(result);

					if (result.Status == DelegationStatus.Succeeded)
					{
						_circuitBreaker.RecordSuccess();
					}
					else if (result.Status == DelegationStatus.Failed)
					{
						_circuitBreaker.RecordFailure();
					}
				}
				catch (OperationCanceledException)
				{
					results.Add(DelegationResult.TimedOut(brief));
				}
				finally
				{
					semaphore.Release();
				}
			})
			.ToList();

		try
		{
			await Task.WhenAll(tasks);
		}
		catch (OperationCanceledException)
		{
			// Some tasks may have been cancelled - that's OK
		}

		sw.Stop();

		batch.Results = results.ToList();
		batch.DurationMs = sw.ElapsedMilliseconds;
		batch.CompletedAt = DateTime.UtcNow;
		batch.SucceededCount = results.Count(r => r.Status == DelegationStatus.Succeeded);
		batch.FailedCount = results.Count(r => r.Status == DelegationStatus.Failed);
		batch.TimedOutCount = results.Count(r => r.Status == DelegationStatus.TimedOut);
		batch.Status =
			batch.FailedCount == 0 && batch.TimedOutCount == 0 ? BatchStatus.AllSucceeded
			: batch.SucceededCount > 0 ? BatchStatus.PartialSuccess
			: BatchStatus.AllFailed;

		return batch;
	}

	/// <summary>
	/// Creates a dynamic research brief from a template.
	/// </summary>
	public static ResearchBrief CreateBrief(string agentName, string taskDescription, Dictionary<string, string>? context = null, int? customTimeoutSeconds = null)
	{
		return new ResearchBrief
		{
			BriefId = Guid.NewGuid().ToString("N")[..8],
			AgentName = agentName,
			TaskDescription = taskDescription,
			Context = context ?? new Dictionary<string, string>(),
			TimeoutSeconds = customTimeoutSeconds,
			CreatedAt = DateTime.UtcNow,
		};
	}

	/// <summary>
	/// Packages context for delegation (serializes to JSON).
	/// </summary>
	public static string PackageContext(Dictionary<string, object> context)
	{
		JsonSerializerOptions options = new() { WriteIndented = true, Converters = { new JsonStringEnumConverter() } };
		return JsonSerializer.Serialize(context, options);
	}

	/// <summary>
	/// Aggregates results from a batch, merging outputs.
	/// </summary>
	public static AggregatedResult AggregateResults(DelegationBatchResult batch)
	{
		return new AggregatedResult
		{
			BatchId = batch.BatchId,
			TotalBriefs = batch.TotalBriefs,
			SucceededCount = batch.SucceededCount,
			FailedCount = batch.FailedCount,
			TimedOutCount = batch.TimedOutCount,
			DurationMs = batch.DurationMs,
			Outputs = batch.Results.Where(r => r.Status == DelegationStatus.Succeeded && r.Output != null).ToDictionary(r => r.Brief.AgentName, r => r.Output!),
			Errors = batch.Results.Where(r => r.Status != DelegationStatus.Succeeded).Select(r => $"[{r.Brief.AgentName}] {r.Error ?? r.Status.ToString()}").ToList(),
		};
	}

	private async Task<DelegationResult> ExecuteBriefAsync(ResearchBrief brief, CancellationToken cancellationToken)
	{
		Stopwatch sw = Stopwatch.StartNew();

		try
		{
			// Simulate delegation execution (in production, this would call the agent)
			// The actual execution is handled by the orchestrator via agent protocol
			int timeout = brief.TimeoutSeconds ?? _config.TimeoutSeconds;

			using CancellationTokenSource briefCts = new(TimeSpan.FromSeconds(timeout));
			using CancellationTokenSource linked = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, briefCts.Token);

			// Execute the brief's handler if provided
			object? output = null;
			if (brief.Handler != null)
			{
				output = await brief.Handler(brief, linked.Token);
			}

			sw.Stop();

			return new DelegationResult
			{
				Brief = brief,
				Status = DelegationStatus.Succeeded,
				Output = output,
				DurationMs = sw.ElapsedMilliseconds,
			};
		}
		catch (OperationCanceledException)
		{
			sw.Stop();
			return DelegationResult.TimedOut(brief);
		}
		catch (Exception ex)
		{
			sw.Stop();
			return new DelegationResult
			{
				Brief = brief,
				Status = DelegationStatus.Failed,
				Error = ex.Message,
				DurationMs = sw.ElapsedMilliseconds,
			};
		}
	}
}

/// <summary>
/// Configuration for parallel delegation.
/// </summary>
public sealed class DelegationConfig
{
	public int TimeoutSeconds { get; init; } = 60;
	public int MaxParallelDelegations { get; init; } = 5;
	public int CircuitBreakerFailures { get; init; } = 3;
	public int CircuitBreakerCooldownSeconds { get; init; } = 60;
}

/// <summary>
/// A research brief for agent delegation.
/// </summary>
public sealed class ResearchBrief
{
	public string BriefId { get; init; } = string.Empty;
	public string AgentName { get; init; } = string.Empty;
	public string TaskDescription { get; init; } = string.Empty;
	public Dictionary<string, string> Context { get; init; } = new();
	public int? TimeoutSeconds { get; init; }
	public DateTime CreatedAt { get; init; }
	public Func<ResearchBrief, CancellationToken, Task<object?>>? Handler { get; init; }
}

/// <summary>
/// Result of a single delegation.
/// </summary>
public sealed class DelegationResult
{
	public ResearchBrief Brief { get; init; } = new();
	public DelegationStatus Status { get; init; }
	public object? Output { get; init; }
	public string? Error { get; init; }
	public long DurationMs { get; init; }

	public static DelegationResult Skipped(ResearchBrief brief, string reason) =>
		new()
		{
			Brief = brief,
			Status = DelegationStatus.Skipped,
			Error = reason,
		};

	public static DelegationResult TimedOut(ResearchBrief brief) =>
		new()
		{
			Brief = brief,
			Status = DelegationStatus.TimedOut,
			Error = $"Timed out after {brief.TimeoutSeconds ?? 60}s",
		};
}

/// <summary>
/// Batch delegation result.
/// </summary>
public sealed class DelegationBatchResult
{
	public string BatchId { get; init; } = string.Empty;
	public DateTime StartedAt { get; init; }
	public DateTime CompletedAt { get; set; }
	public long DurationMs { get; set; }
	public int TotalBriefs { get; init; }
	public int SucceededCount { get; set; }
	public int FailedCount { get; set; }
	public int TimedOutCount { get; set; }
	public BatchStatus Status { get; set; }
	public List<DelegationResult> Results { get; set; } = new();
}

/// <summary>
/// Aggregated output from multiple delegations.
/// </summary>
public sealed class AggregatedResult
{
	public string BatchId { get; init; } = string.Empty;
	public int TotalBriefs { get; init; }
	public int SucceededCount { get; init; }
	public int FailedCount { get; init; }
	public int TimedOutCount { get; init; }
	public long DurationMs { get; init; }
	public Dictionary<string, object> Outputs { get; init; } = new();
	public List<string> Errors { get; init; } = new();
}

public enum DelegationStatus
{
	Succeeded,
	Failed,
	TimedOut,
	Skipped,
}

public enum BatchStatus
{
	AllSucceeded,
	PartialSuccess,
	AllFailed,
	CircuitBreakerOpen,
}
