using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Services;

/// <summary>
/// Retry strategy with exponential backoff and model fallback chain.
/// WIND-003: Max 3 attempts, Initial * 2^(Attempt-1) backoff, max 5 min.
/// Fallback chain: Opus 4.6 → Sonnet → Haiku.
/// </summary>
public class RetryStrategy
{
	private readonly RetryConfig _config;

	public RetryStrategy(RetryConfig? config = null)
	{
		_config = config ?? RetryConfig.Default;
	}

	/// <summary>
	/// Executes an action with retry logic and exponential backoff.
	/// </summary>
	public async Task<T> ExecuteAsync<T>(Func<CancellationToken, Task<T>> action, CancellationToken cancellationToken = default)
	{
		Exception? lastException = null;

		for (int attempt = 1; attempt <= _config.MaxAttempts; attempt++)
		{
			try
			{
				return await action(cancellationToken);
			}
			catch (Exception ex) when (!cancellationToken.IsCancellationRequested)
			{
				lastException = ex;
				StackTrace trace = new(ex, true);
				StackFrame? frame = trace.GetFrame(0);
				int line = frame?.GetFileLineNumber() ?? 0;
				Console.WriteLine($"[{line}] [RetryStrategy] Attempt {attempt}/{_config.MaxAttempts} failed: {ex.Message}");

				if (attempt < _config.MaxAttempts)
				{
					TimeSpan delay = CalculateBackoff(attempt);
					Console.WriteLine($"[RetryStrategy] Waiting {delay.TotalSeconds:F1}s before retry...");
					await Task.Delay(delay, cancellationToken);
				}
			}
		}

		throw new RetryExhaustedException($"All {_config.MaxAttempts} retry attempts exhausted.", lastException!);
	}

	/// <summary>
	/// Executes an action with retry logic across a fallback chain.
	/// Tries each model in the chain before exhausting retries on each.
	/// </summary>
	public async Task<T> ExecuteWithFallbackAsync<T>(Func<string, CancellationToken, Task<T>> action, CancellationToken cancellationToken = default)
	{
		Exception? lastException = null;

		foreach (string model in _config.FallbackChain)
		{
			for (int attempt = 1; attempt <= _config.MaxAttempts; attempt++)
			{
				try
				{
					Console.WriteLine($"[RetryStrategy] Trying model '{model}' (attempt {attempt}/{_config.MaxAttempts})");
					return await action(model, cancellationToken);
				}
				catch (Exception ex) when (!cancellationToken.IsCancellationRequested)
				{
					lastException = ex;
					StackTrace trace = new(ex, true);
					StackFrame? frame = trace.GetFrame(0);
					int line = frame?.GetFileLineNumber() ?? 0;
					Console.WriteLine($"[{line}] [RetryStrategy] Model '{model}' attempt {attempt} failed: {ex.Message}");

					if (attempt < _config.MaxAttempts)
					{
						TimeSpan delay = CalculateBackoff(attempt);
						await Task.Delay(delay, cancellationToken);
					}
				}
			}

			Console.WriteLine($"[RetryStrategy] Model '{model}' exhausted. Falling back to next model...");
		}

		throw new FallbackExhaustedException($"All models in fallback chain exhausted after {_config.MaxAttempts} attempts each.", _config.FallbackChain, lastException!);
	}

	private TimeSpan CalculateBackoff(int attempt)
	{
		double delayMs = _config.InitialDelayMs * Math.Pow(2, attempt - 1);
		double maxMs = _config.MaxDelayMs;
		double jitter = Random.Shared.NextDouble() * _config.JitterMs;
		return TimeSpan.FromMilliseconds(Math.Min(delayMs + jitter, maxMs));
	}
}

public class RetryConfig
{
	public int MaxAttempts { get; set; } = 3;
	public double InitialDelayMs { get; set; } = 1000;
	public double MaxDelayMs { get; set; } = 300_000; // 5 minutes
	public double JitterMs { get; set; } = 500;
	public List<string> FallbackChain { get; set; } = new() { "claude-opus-4-20250514", "claude-sonnet-4-20250514", "claude-haiku-3" };

	public static RetryConfig Default => new();
}

public class RetryExhaustedException : Exception
{
	public RetryExhaustedException(string message, Exception innerException)
		: base(message, innerException) { }
}

public class FallbackExhaustedException : Exception
{
	public IReadOnlyList<string> TriedModels { get; }

	public FallbackExhaustedException(string message, IReadOnlyList<string> triedModels, Exception innerException)
		: base(message, innerException)
	{
		TriedModels = triedModels;
	}
}
