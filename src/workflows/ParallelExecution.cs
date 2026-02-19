using System.Collections.Concurrent;
using System.Diagnostics;

namespace P4NTH30N.SWE.Workflows;

/// <summary>
/// Parallel tool execution engine supporting up to 10 concurrent calls per turn.
/// Includes dependency resolution, retry logic with circuit breaker, and result aggregation.
/// </summary>
public sealed class ParallelExecution {
	private readonly ParallelExecutionConfig _config;
	private readonly CircuitBreaker _circuitBreaker;

	public ParallelExecution(ParallelExecutionConfig? config = null) {
		_config = config ?? new ParallelExecutionConfig();
		_circuitBreaker = new CircuitBreaker(
			failureThreshold: _config.CircuitBreakerFailures,
			cooldownSeconds: _config.CircuitBreakerCooldownSeconds);
	}

	/// <summary>
	/// Executes multiple tool calls in parallel, respecting dependency order.
	/// </summary>
	public async Task<ExecutionBatch> ExecuteAsync(
		IReadOnlyList<ToolCall> calls,
		CancellationToken cancellationToken = default) {
		ExecutionBatch batch = new() {
			BatchId = Guid.NewGuid().ToString("N")[..8],
			StartedAt = DateTime.UtcNow,
		};

		// Resolve dependencies and group into execution waves
		List<List<ToolCall>> waves = ResolveDependencies(calls);

		Stopwatch sw = Stopwatch.StartNew();

		foreach (List<ToolCall> wave in waves) {
			if (_circuitBreaker.IsOpen) {
				batch.CircuitBreakerTripped = true;
				batch.AddResults(wave.Select(c => ToolCallResult.Skipped(c, "Circuit breaker open")));
				break;
			}

			// Execute wave in parallel (up to max concurrency)
			List<ToolCallResult> waveResults = await ExecuteWaveAsync(wave, cancellationToken);
			batch.AddResults(waveResults);

			// Check for failures that should stop execution
			if (waveResults.Any(r => r.Status == ToolCallStatus.Failed && r.Call.StopOnFailure)) {
				batch.StoppedEarly = true;
				break;
			}
		}

		sw.Stop();
		batch.DurationMs = sw.ElapsedMilliseconds;
		batch.CompletedAt = DateTime.UtcNow;

		return batch;
	}

	/// <summary>
	/// Resolves dependencies between tool calls and groups them into execution waves.
	/// Calls within the same wave have no dependencies on each other.
	/// </summary>
	public static List<List<ToolCall>> ResolveDependencies(IReadOnlyList<ToolCall> calls) {
		List<List<ToolCall>> waves = new();
		HashSet<string> completed = new();
		HashSet<string> remaining = new(calls.Select(c => c.Id));

		while (remaining.Count > 0) {
			List<ToolCall> wave = new();

			foreach (ToolCall call in calls) {
				if (!remaining.Contains(call.Id)) continue;

				// Check if all dependencies are satisfied
				bool depsReady = call.DependsOn.All(dep => completed.Contains(dep));
				if (depsReady) {
					wave.Add(call);
				}
			}

			if (wave.Count == 0) {
				// Circular dependency detected - force remaining into single wave
				wave.AddRange(calls.Where(c => remaining.Contains(c.Id)));
				remaining.Clear();
			} else {
				foreach (ToolCall call in wave) {
					remaining.Remove(call.Id);
					completed.Add(call.Id);
				}
			}

			waves.Add(wave);
		}

		return waves;
	}

	private async Task<List<ToolCallResult>> ExecuteWaveAsync(
		List<ToolCall> wave,
		CancellationToken cancellationToken) {
		// Cap concurrency at configured maximum
		int maxParallel = Math.Min(wave.Count, _config.MaxConcurrentCalls);

		using SemaphoreSlim semaphore = new(maxParallel);
		ConcurrentBag<ToolCallResult> results = new();

		List<Task> tasks = wave.Select(async call => {
			await semaphore.WaitAsync(cancellationToken);
			try {
				ToolCallResult result = await ExecuteWithRetryAsync(call, cancellationToken);
				results.Add(result);
			}
			finally {
				semaphore.Release();
			}
		}).ToList();

		await Task.WhenAll(tasks);

		return results.ToList();
	}

	private async Task<ToolCallResult> ExecuteWithRetryAsync(
		ToolCall call,
		CancellationToken cancellationToken) {
		Exception? lastException = null;

		for (int attempt = 0; attempt <= _config.MaxRetries; attempt++) {
			try {
				Stopwatch sw = Stopwatch.StartNew();
				object? output = await call.ExecuteFunc(cancellationToken);
				sw.Stop();

				_circuitBreaker.RecordSuccess();

				return new ToolCallResult {
					Call = call,
					Status = ToolCallStatus.Succeeded,
					Output = output,
					DurationMs = sw.ElapsedMilliseconds,
					Attempt = attempt + 1,
				};
			}
			catch (Exception ex) when (attempt < _config.MaxRetries) {
				lastException = ex;
				int delayMs = (int)(Math.Pow(2, attempt) * 1000);
				await Task.Delay(delayMs, cancellationToken);
			}
			catch (Exception ex) {
				lastException = ex;
				_circuitBreaker.RecordFailure();
			}
		}

		return new ToolCallResult {
			Call = call,
			Status = ToolCallStatus.Failed,
			Error = lastException?.Message ?? "Unknown error",
			Attempt = _config.MaxRetries + 1,
		};
	}
}

/// <summary>
/// Simple circuit breaker implementation.
/// Opens after N consecutive failures, closes after cooldown period.
/// </summary>
public sealed class CircuitBreaker {
	private readonly int _failureThreshold;
	private readonly TimeSpan _cooldown;
	private int _consecutiveFailures;
	private DateTime _openedAt;

	public bool IsOpen =>
		_consecutiveFailures >= _failureThreshold &&
		DateTime.UtcNow - _openedAt < _cooldown;

	public CircuitBreaker(int failureThreshold = 3, int cooldownSeconds = 60) {
		_failureThreshold = failureThreshold;
		_cooldown = TimeSpan.FromSeconds(cooldownSeconds);
	}

	public void RecordSuccess() {
		_consecutiveFailures = 0;
	}

	public void RecordFailure() {
		_consecutiveFailures++;
		if (_consecutiveFailures >= _failureThreshold) {
			_openedAt = DateTime.UtcNow;
		}
	}

	public void Reset() {
		_consecutiveFailures = 0;
	}
}

/// <summary>
/// Configuration for parallel execution engine.
/// </summary>
public sealed class ParallelExecutionConfig {
	public int MaxConcurrentCalls { get; init; } = 10;
	public int MaxRetries { get; init; } = 2;
	public int CircuitBreakerFailures { get; init; } = 3;
	public int CircuitBreakerCooldownSeconds { get; init; } = 60;
}

/// <summary>
/// Represents a single tool call to execute.
/// </summary>
public sealed class ToolCall {
	public string Id { get; init; } = Guid.NewGuid().ToString("N")[..8];
	public string Name { get; init; } = string.Empty;
	public List<string> DependsOn { get; init; } = new();
	public bool StopOnFailure { get; init; }
	public Func<CancellationToken, Task<object?>> ExecuteFunc { get; init; } = _ => Task.FromResult<object?>(null);
}

/// <summary>
/// Result of a single tool call execution.
/// </summary>
public sealed class ToolCallResult {
	public ToolCall Call { get; init; } = new();
	public ToolCallStatus Status { get; init; }
	public object? Output { get; init; }
	public string? Error { get; init; }
	public long DurationMs { get; init; }
	public int Attempt { get; init; }

	public static ToolCallResult Skipped(ToolCall call, string reason) => new() {
		Call = call,
		Status = ToolCallStatus.Skipped,
		Error = reason,
	};
}

/// <summary>
/// Aggregated results of a batch execution.
/// </summary>
public sealed class ExecutionBatch {
	public string BatchId { get; init; } = string.Empty;
	public DateTime StartedAt { get; init; }
	public DateTime CompletedAt { get; set; }
	public long DurationMs { get; set; }
	public bool CircuitBreakerTripped { get; set; }
	public bool StoppedEarly { get; set; }
	public List<ToolCallResult> Results { get; } = new();

	public int SucceededCount => Results.Count(r => r.Status == ToolCallStatus.Succeeded);
	public int FailedCount => Results.Count(r => r.Status == ToolCallStatus.Failed);
	public int SkippedCount => Results.Count(r => r.Status == ToolCallStatus.Skipped);

	public void AddResults(IEnumerable<ToolCallResult> results) {
		Results.AddRange(results);
	}
}

public enum ToolCallStatus { Succeeded, Failed, Skipped }
