using System;

namespace P4NTHE0N.C0MMON.Infrastructure.Resilience;

public enum CircuitState
{
	Closed,
	Open,
	HalfOpen,
}

public class CircuitBreakerOpenException : Exception
{
	public CircuitState State { get; }
	public int FailureCount { get; }
	public DateTime LastFailureTime { get; }

	public CircuitBreakerOpenException(string message, CircuitState state, int failureCount, DateTime lastFailureTime)
		: base(message)
	{
		State = state;
		FailureCount = failureCount;
		LastFailureTime = lastFailureTime;
	}

	public CircuitBreakerOpenException(string message, Exception innerException, CircuitState state, int failureCount, DateTime lastFailureTime)
		: base(message, innerException)
	{
		State = state;
		FailureCount = failureCount;
		LastFailureTime = lastFailureTime;
	}
}

public interface ICircuitBreaker
{
	CircuitState State { get; }
	int FailureCount { get; }
	DateTime LastFailureTime { get; }
	void Reset();
}

public class CircuitBreaker : ICircuitBreaker
{
	private readonly int _failureThreshold;
	private readonly TimeSpan _recoveryTimeout;
	private readonly Action<string>? _logger;

	private int _failureCount = 0;
	private DateTime _lastFailureTime = DateTime.MinValue;
	private CircuitState _state = CircuitState.Closed;
	private readonly object _lock = new();

	public CircuitState State
	{
		get
		{
			lock (_lock)
			{
				if (_state == CircuitState.Open && DateTime.UtcNow - _lastFailureTime > _recoveryTimeout)
				{
					_state = CircuitState.HalfOpen;
				}
				return _state;
			}
		}
	}

	public int FailureCount
	{
		get
		{
			lock (_lock)
			{
				return _failureCount;
			}
		}
	}

	public DateTime LastFailureTime
	{
		get
		{
			lock (_lock)
			{
				return _lastFailureTime;
			}
		}
	}

	public CircuitBreaker(int failureThreshold = 3, TimeSpan? recoveryTimeout = null, Action<string>? logger = null)
	{
		_failureThreshold = failureThreshold;
		_recoveryTimeout = recoveryTimeout ?? TimeSpan.FromMinutes(5);
		_logger = logger;
	}

	public async Task<T> ExecuteAsync<T>(Func<Task<T>> operation)
	{
		lock (_lock)
		{
			if (_state == CircuitState.Open)
			{
				if (DateTime.UtcNow - _lastFailureTime > _recoveryTimeout)
				{
					_state = CircuitState.HalfOpen;
					_logger?.Invoke($"[CircuitBreaker] Transitioning to HalfOpen after {_recoveryTimeout.TotalMinutes} minutes");
				}
				else
				{
					throw new CircuitBreakerOpenException(
						$"Circuit is open. Too many recent failures ({_failureCount}). Retry after {_recoveryTimeout.TotalMinutes} minutes.",
						_state,
						_failureCount,
						_lastFailureTime
					);
				}
			}
		}

		try
		{
			T result = await operation();

			lock (_lock)
			{
				if (_state == CircuitState.HalfOpen)
				{
					_state = CircuitState.Closed;
					_failureCount = 0;
					_logger?.Invoke("[CircuitBreaker] Recovered - transitioning to Closed");
				}
			}

			return result;
		}
		catch (Exception ex)
		{
			lock (_lock)
			{
				_failureCount++;
				_lastFailureTime = DateTime.UtcNow;

				if (_failureCount >= _failureThreshold)
				{
					_state = CircuitState.Open;
					_logger?.Invoke($"[CircuitBreaker] Opened after {_failureCount} failures. Last error: {ex.Message}");
				}
			}

			throw;
		}
	}

	public async Task ExecuteAsync(Func<Task> operation)
	{
		await ExecuteAsync(async () =>
		{
			await operation();
			return true;
		});
	}

	public void Reset()
	{
		lock (_lock)
		{
			_state = CircuitState.Closed;
			_failureCount = 0;
			_lastFailureTime = DateTime.MinValue;
			_logger?.Invoke("[CircuitBreaker] Manual reset - state reset to Closed");
		}
	}
}

public class CircuitBreaker<T> : ICircuitBreaker
{
	private readonly CircuitBreaker _inner;

	public CircuitState State => _inner.State;
	public int FailureCount => _inner.FailureCount;
	public DateTime LastFailureTime => _inner.LastFailureTime;

	public CircuitBreaker(int failureThreshold = 3, TimeSpan? recoveryTimeout = null, Action<string>? logger = null)
	{
		_inner = new CircuitBreaker(failureThreshold, recoveryTimeout, logger);
	}

	public async Task<T> ExecuteAsync(Func<Task<T>> operation)
	{
		return await _inner.ExecuteAsync(operation);
	}

	public void Reset()
	{
		_inner.Reset();
	}
}
