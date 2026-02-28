using System.Collections.Concurrent;
using System.Diagnostics;

namespace P4NTHE0N.RAG;

/// <summary>
/// Circuit breaker: opens after N consecutive failures, half-opens after cooldown.
/// 5 failures = open state. Prevents cascading failures in embedding/bridge calls.
/// </summary>
public sealed class CircuitBreaker
{
	private readonly int _failureThreshold;
	private readonly TimeSpan _cooldownPeriod;
	private readonly string _name;

	private int _consecutiveFailures;
	private CircuitState _state = CircuitState.Closed;
	private DateTime _lastFailure;
	private DateTime _openedAt;
	private readonly object _lock = new();

	// Tracking
	private long _totalCalls;
	private long _totalFailures;
	private long _totalRejected;
	private long _totalSuccesses;

	public CircuitState State
	{
		get
		{
			lock (_lock)
			{
				if (_state == CircuitState.Open && DateTime.UtcNow - _openedAt >= _cooldownPeriod)
				{
					_state = CircuitState.HalfOpen;
				}
				return _state;
			}
		}
	}

	public long TotalCalls => _totalCalls;
	public long TotalFailures => _totalFailures;
	public long TotalRejected => _totalRejected;
	public long TotalSuccesses => _totalSuccesses;
	public string Name => _name;

	public CircuitBreaker(string name = "default", int failureThreshold = 5, int cooldownSeconds = 60)
	{
		_name = name;
		_failureThreshold = failureThreshold;
		_cooldownPeriod = TimeSpan.FromSeconds(cooldownSeconds);
	}

	/// <summary>
	/// Executes an action through the circuit breaker.
	/// Throws CircuitBreakerOpenException if the circuit is open.
	/// </summary>
	public async Task<T> ExecuteAsync<T>(Func<CancellationToken, Task<T>> action, CancellationToken cancellationToken = default)
	{
		Interlocked.Increment(ref _totalCalls);

		CircuitState currentState = State;

		if (currentState == CircuitState.Open)
		{
			Interlocked.Increment(ref _totalRejected);
			throw new CircuitBreakerOpenException(_name, _cooldownPeriod - (DateTime.UtcNow - _openedAt));
		}

		try
		{
			T result = await action(cancellationToken);
			OnSuccess();
			return result;
		}
		catch (Exception ex) when (ex is not CircuitBreakerOpenException)
		{
			OnFailure();
			throw;
		}
	}

	/// <summary>
	/// Executes a void action through the circuit breaker.
	/// </summary>
	public async Task ExecuteAsync(Func<CancellationToken, Task> action, CancellationToken cancellationToken = default)
	{
		await ExecuteAsync(
			async ct =>
			{
				await action(ct);
				return true;
			},
			cancellationToken
		);
	}

	/// <summary>
	/// Manually resets the circuit breaker to closed state.
	/// </summary>
	public void Reset()
	{
		lock (_lock)
		{
			_state = CircuitState.Closed;
			_consecutiveFailures = 0;
			Console.WriteLine($"[CircuitBreaker:{_name}] Manually reset to Closed.");
		}
	}

	private void OnSuccess()
	{
		Interlocked.Increment(ref _totalSuccesses);
		lock (_lock)
		{
			_consecutiveFailures = 0;
			if (_state == CircuitState.HalfOpen)
			{
				_state = CircuitState.Closed;
				Console.WriteLine($"[CircuitBreaker:{_name}] Half-Open → Closed (success).");
			}
		}
	}

	private void OnFailure()
	{
		Interlocked.Increment(ref _totalFailures);
		lock (_lock)
		{
			_consecutiveFailures++;
			_lastFailure = DateTime.UtcNow;

			if (_state == CircuitState.HalfOpen)
			{
				_state = CircuitState.Open;
				_openedAt = DateTime.UtcNow;
				Console.WriteLine($"[CircuitBreaker:{_name}] Half-Open → Open (failure during probe).");
			}
			else if (_consecutiveFailures >= _failureThreshold)
			{
				_state = CircuitState.Open;
				_openedAt = DateTime.UtcNow;
				Console.WriteLine($"[CircuitBreaker:{_name}] Closed → Open ({_consecutiveFailures} consecutive failures).");
			}
		}
	}
}

/// <summary>
/// Circuit breaker states.
/// </summary>
public enum CircuitState
{
	/// <summary>Normal operation, requests flow through.</summary>
	Closed,

	/// <summary>Circuit tripped, requests are rejected.</summary>
	Open,

	/// <summary>Probing: allows one request to test recovery.</summary>
	HalfOpen,
}

/// <summary>
/// Thrown when circuit breaker is open and rejecting requests.
/// </summary>
public sealed class CircuitBreakerOpenException : Exception
{
	public string CircuitName { get; }
	public TimeSpan RemainingCooldown { get; }

	public CircuitBreakerOpenException(string circuitName, TimeSpan remainingCooldown)
		: base($"Circuit breaker '{circuitName}' is open. Retry in {remainingCooldown.TotalSeconds:F0}s.")
	{
		CircuitName = circuitName;
		RemainingCooldown = remainingCooldown;
	}
}

/// <summary>
/// Retry policy with exponential backoff.
/// 3 retries, delays: 1s, 2s, 4s.
/// </summary>
public sealed class RetryPolicy
{
	private readonly int _maxRetries;
	private readonly TimeSpan _baseDelay;
	private readonly double _backoffMultiplier;
	private readonly string _name;

	// Tracking
	private long _totalAttempts;
	private long _totalRetries;
	private long _totalSuccesses;
	private long _totalExhausted;

	public long TotalAttempts => _totalAttempts;
	public long TotalRetries => _totalRetries;
	public long TotalSuccesses => _totalSuccesses;
	public long TotalExhausted => _totalExhausted;

	public RetryPolicy(string name = "default", int maxRetries = 3, double baseDelaySeconds = 1.0, double backoffMultiplier = 2.0)
	{
		_name = name;
		_maxRetries = maxRetries;
		_baseDelay = TimeSpan.FromSeconds(baseDelaySeconds);
		_backoffMultiplier = backoffMultiplier;
	}

	/// <summary>
	/// Executes an action with retry and exponential backoff.
	/// </summary>
	public async Task<T> ExecuteAsync<T>(Func<CancellationToken, Task<T>> action, CancellationToken cancellationToken = default)
	{
		Interlocked.Increment(ref _totalAttempts);
		Exception? lastException = null;

		for (int attempt = 0; attempt <= _maxRetries; attempt++)
		{
			try
			{
				if (attempt > 0)
				{
					Interlocked.Increment(ref _totalRetries);
					TimeSpan delay = _baseDelay * Math.Pow(_backoffMultiplier, attempt - 1);
					await Task.Delay(delay, cancellationToken);
				}

				T result = await action(cancellationToken);
				Interlocked.Increment(ref _totalSuccesses);
				return result;
			}
			catch (OperationCanceledException)
			{
				throw;
			}
			catch (CircuitBreakerOpenException)
			{
				throw; // Don't retry circuit breaker rejections
			}
			catch (Exception ex)
			{
				lastException = ex;
				if (attempt < _maxRetries)
				{
					Console.WriteLine($"[RetryPolicy:{_name}] Attempt {attempt + 1}/{_maxRetries + 1} failed: {ex.Message}");
				}
			}
		}

		Interlocked.Increment(ref _totalExhausted);
		throw new RetryExhaustedException(_name, _maxRetries, lastException!);
	}

	/// <summary>
	/// Executes a void action with retry.
	/// </summary>
	public async Task ExecuteAsync(Func<CancellationToken, Task> action, CancellationToken cancellationToken = default)
	{
		await ExecuteAsync(
			async ct =>
			{
				await action(ct);
				return true;
			},
			cancellationToken
		);
	}
}

/// <summary>
/// Thrown when all retry attempts have been exhausted.
/// </summary>
public sealed class RetryExhaustedException : Exception
{
	public string PolicyName { get; }
	public int MaxRetries { get; }

	public RetryExhaustedException(string policyName, int maxRetries, Exception innerException)
		: base($"Retry policy '{policyName}' exhausted after {maxRetries} retries.", innerException)
	{
		PolicyName = policyName;
		MaxRetries = maxRetries;
	}
}

/// <summary>
/// Collects and aggregates performance metrics for RAG operations.
/// Tracks latency percentiles, cache hit rates, throughput, and error rates.
/// </summary>
public sealed class MetricsCollector
{
	private readonly ConcurrentDictionary<string, MetricBucket> _buckets = new();
	private readonly TimeSpan _bucketWindow;

	public MetricsCollector(int bucketWindowMinutes = 5)
	{
		_bucketWindow = TimeSpan.FromMinutes(bucketWindowMinutes);
	}

	/// <summary>
	/// Records a latency measurement for a named operation.
	/// </summary>
	public void RecordLatency(string operation, long latencyMs)
	{
		MetricBucket bucket = GetOrCreateBucket(operation);
		bucket.RecordLatency(latencyMs);
	}

	/// <summary>
	/// Records a cache hit or miss.
	/// </summary>
	public void RecordCacheAccess(string operation, bool hit)
	{
		MetricBucket bucket = GetOrCreateBucket(operation);
		if (hit)
			Interlocked.Increment(ref bucket.CacheHits);
		else
			Interlocked.Increment(ref bucket.CacheMisses);
	}

	/// <summary>
	/// Records an error occurrence.
	/// </summary>
	public void RecordError(string operation)
	{
		MetricBucket bucket = GetOrCreateBucket(operation);
		Interlocked.Increment(ref bucket.Errors);
	}

	/// <summary>
	/// Gets a snapshot of all metrics.
	/// </summary>
	public Dictionary<string, MetricSnapshot> GetSnapshot()
	{
		Dictionary<string, MetricSnapshot> snapshot = new();
		foreach (KeyValuePair<string, MetricBucket> kvp in _buckets)
		{
			snapshot[kvp.Key] = kvp.Value.ToSnapshot();
		}
		return snapshot;
	}

	/// <summary>
	/// Gets metrics for a specific operation.
	/// </summary>
	public MetricSnapshot? GetMetric(string operation)
	{
		if (_buckets.TryGetValue(operation, out MetricBucket? bucket))
		{
			return bucket.ToSnapshot();
		}
		return null;
	}

	/// <summary>
	/// Resets all metrics.
	/// </summary>
	public void Reset()
	{
		_buckets.Clear();
	}

	private MetricBucket GetOrCreateBucket(string operation)
	{
		return _buckets.GetOrAdd(operation, _ => new MetricBucket());
	}
}

/// <summary>
/// Internal metric bucket for a single operation type.
/// </summary>
internal sealed class MetricBucket
{
	private readonly ConcurrentBag<long> _latencies = new();
	public long CacheHits;
	public long CacheMisses;
	public long Errors;

	public void RecordLatency(long latencyMs)
	{
		_latencies.Add(latencyMs);
	}

	public MetricSnapshot ToSnapshot()
	{
		long[] sorted = _latencies.ToArray();
		Array.Sort(sorted);

		long totalCacheAccess = Interlocked.Read(ref CacheHits) + Interlocked.Read(ref CacheMisses);

		return new MetricSnapshot
		{
			Count = sorted.Length,
			MeanLatencyMs = sorted.Length > 0 ? sorted.Average() : 0,
			P50LatencyMs = Percentile(sorted, 0.50),
			P95LatencyMs = Percentile(sorted, 0.95),
			P99LatencyMs = Percentile(sorted, 0.99),
			MaxLatencyMs = sorted.Length > 0 ? sorted[^1] : 0,
			MinLatencyMs = sorted.Length > 0 ? sorted[0] : 0,
			CacheHitRate = totalCacheAccess > 0 ? (double)Interlocked.Read(ref CacheHits) / totalCacheAccess : 0,
			ErrorCount = Interlocked.Read(ref Errors),
			ErrorRate = sorted.Length > 0 ? (double)Interlocked.Read(ref Errors) / (sorted.Length + Interlocked.Read(ref Errors)) : 0,
		};
	}

	private static long Percentile(long[] sorted, double p)
	{
		if (sorted.Length == 0)
			return 0;
		int index = (int)Math.Ceiling(p * sorted.Length) - 1;
		return sorted[Math.Clamp(index, 0, sorted.Length - 1)];
	}
}

/// <summary>
/// Snapshot of metrics for a single operation type.
/// </summary>
public sealed class MetricSnapshot
{
	public int Count { get; init; }
	public double MeanLatencyMs { get; init; }
	public long P50LatencyMs { get; init; }
	public long P95LatencyMs { get; init; }
	public long P99LatencyMs { get; init; }
	public long MaxLatencyMs { get; init; }
	public long MinLatencyMs { get; init; }
	public double CacheHitRate { get; init; }
	public long ErrorCount { get; init; }
	public double ErrorRate { get; init; }

	public override string ToString() =>
		$"n={Count} mean={MeanLatencyMs:F1}ms p50={P50LatencyMs}ms p95={P95LatencyMs}ms p99={P99LatencyMs}ms "
		+ $"cache={CacheHitRate:P1} errors={ErrorCount} ({ErrorRate:P2})";
}
