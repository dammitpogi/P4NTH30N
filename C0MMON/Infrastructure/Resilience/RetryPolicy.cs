using System;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Infrastructure.Resilience;

public sealed class RetryPolicy
{
	private readonly int _maxRetries;
	private readonly TimeSpan _baseDelay;
	private readonly double _backoffMultiplier;
	private readonly TimeSpan _maxDelay;
	private readonly Action<string>? _logger;

	private long _totalRetries;
	private long _totalFailures;

	public long TotalRetries => Interlocked.Read(ref _totalRetries);
	public long TotalFailures => Interlocked.Read(ref _totalFailures);

	public RetryPolicy(int maxRetries = 3, TimeSpan? baseDelay = null, double backoffMultiplier = 2.0, TimeSpan? maxDelay = null, Action<string>? logger = null)
	{
		_maxRetries = maxRetries;
		_baseDelay = baseDelay ?? TimeSpan.FromMilliseconds(100);
		_backoffMultiplier = backoffMultiplier;
		_maxDelay = maxDelay ?? TimeSpan.FromSeconds(5);
		_logger = logger;
	}

	public T Execute<T>(Func<T> operation, string? operationName = null)
	{
		int attempt = 0;
		while (true)
		{
			try
			{
				return operation();
			}
			catch (Exception ex)
			{
				attempt++;
				if (attempt > _maxRetries)
				{
					Interlocked.Increment(ref _totalFailures);
					_logger?.Invoke($"[RetryPolicy] '{operationName ?? "operation"}' failed after {_maxRetries} retries: {ex.Message}");
					throw;
				}

				Interlocked.Increment(ref _totalRetries);
				TimeSpan delay = CalculateDelay(attempt);
				_logger?.Invoke(
					$"[RetryPolicy] '{operationName ?? "operation"}' attempt {attempt}/{_maxRetries} failed: {ex.Message}. Retrying in {delay.TotalMilliseconds}ms"
				);
				Thread.Sleep(delay);
			}
		}
	}

	public void Execute(Action operation, string? operationName = null)
	{
		Execute(
			() =>
			{
				operation();
				return true;
			},
			operationName
		);
	}

	public async Task<T> ExecuteAsync<T>(Func<Task<T>> operation, string? operationName = null)
	{
		int attempt = 0;
		while (true)
		{
			try
			{
				return await operation();
			}
			catch (Exception ex)
			{
				attempt++;
				if (attempt > _maxRetries)
				{
					Interlocked.Increment(ref _totalFailures);
					_logger?.Invoke($"[RetryPolicy] '{operationName ?? "operation"}' failed after {_maxRetries} retries: {ex.Message}");
					throw;
				}

				Interlocked.Increment(ref _totalRetries);
				TimeSpan delay = CalculateDelay(attempt);
				_logger?.Invoke(
					$"[RetryPolicy] '{operationName ?? "operation"}' attempt {attempt}/{_maxRetries} failed: {ex.Message}. Retrying in {delay.TotalMilliseconds}ms"
				);
				await Task.Delay(delay);
			}
		}
	}

	public async Task ExecuteAsync(Func<Task> operation, string? operationName = null)
	{
		await ExecuteAsync(
			async () =>
			{
				await operation();
				return true;
			},
			operationName
		);
	}

	private TimeSpan CalculateDelay(int attempt)
	{
		// Exponential backoff with jitter
		double delayMs = _baseDelay.TotalMilliseconds * Math.Pow(_backoffMultiplier, attempt - 1);
		// Add ±25% jitter
		double jitter = delayMs * 0.25 * (Random.Shared.NextDouble() * 2 - 1);
		delayMs = Math.Min(delayMs + jitter, _maxDelay.TotalMilliseconds);
		return TimeSpan.FromMilliseconds(Math.Max(delayMs, 1));
	}
}
