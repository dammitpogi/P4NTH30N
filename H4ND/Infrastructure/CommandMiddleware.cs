using System.Diagnostics;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;

namespace P4NTHE0N.H4ND.Infrastructure;

/// <summary>
/// TECH-FE-015: Validates required fields and confidence threshold.
/// </summary>
public sealed class ValidationMiddleware : ICommandMiddleware
{
	private const double _confidenceThreshold = 0.80;

	public Task<bool> PreProcessAsync(CommandContext context)
	{
		VisionCommand cmd = context.Command;

		if (string.IsNullOrEmpty(cmd.TargetUsername) || string.IsNullOrEmpty(cmd.TargetGame))
		{
			context.Error = "Missing target identification (username or game)";
			return Task.FromResult(false);
		}

		if (cmd.Confidence < _confidenceThreshold && cmd.CommandType != VisionCommandType.Escalate)
		{
			context.Error = $"Confidence {cmd.Confidence:F2} below threshold {_confidenceThreshold}";
			return Task.FromResult(false);
		}

		return Task.FromResult(true);
	}

	public Task PostProcessAsync(CommandContext context, CommandResult result) => Task.CompletedTask;
}

/// <summary>
/// TECH-FE-015: Prevents duplicate commands within a time window.
/// </summary>
public sealed class IdempotencyMiddleware : ICommandMiddleware
{
	private readonly IOperationTracker _tracker;

	public IdempotencyMiddleware(IOperationTracker tracker)
	{
		_tracker = tracker;
	}

	public Task<bool> PreProcessAsync(CommandContext context)
	{
		VisionCommand cmd = context.Command;
		string operationId = $"{cmd.CommandType}:{cmd.TargetUsername}:{cmd.Timestamp:yyyyMMddHHmmss}";

		if (!_tracker.TryRegisterOperation(operationId))
		{
			context.Error = "Duplicate command detected";
			cmd.Status = VisionCommandStatus.Expired;
			return Task.FromResult(false);
		}

		context.OperationId = operationId;
		return Task.FromResult(true);
	}

	public Task PostProcessAsync(CommandContext context, CommandResult result) => Task.CompletedTask;
}

/// <summary>
/// TECH-FE-015: Wraps execution in the existing CircuitBreaker.
/// </summary>
public sealed class CircuitBreakerMiddleware : ICommandMiddleware
{
	private readonly ICircuitBreaker _circuitBreaker;

	public CircuitBreakerMiddleware(ICircuitBreaker circuitBreaker)
	{
		_circuitBreaker = circuitBreaker;
	}

	public Task<bool> PreProcessAsync(CommandContext context)
	{
		if (_circuitBreaker.State == CircuitState.Open)
		{
			context.Error = $"Circuit breaker is open ({_circuitBreaker.FailureCount} failures)";
			return Task.FromResult(false);
		}
		return Task.FromResult(true);
	}

	public Task PostProcessAsync(CommandContext context, CommandResult result)
	{
		// CircuitBreaker state is managed by the caller wrapping ExecuteAsync
		return Task.CompletedTask;
	}
}

/// <summary>
/// TECH-FE-015: Logs command execution timing.
/// </summary>
public sealed class LoggingMiddleware : ICommandMiddleware
{
	private Stopwatch? _stopwatch;

	public Task<bool> PreProcessAsync(CommandContext context)
	{
		_stopwatch = Stopwatch.StartNew();
		Console.WriteLine($"[Pipeline] Processing {context.Command.CommandType} for {context.Command.TargetUsername}@{context.Command.TargetGame}");
		return Task.FromResult(true);
	}

	public Task PostProcessAsync(CommandContext context, CommandResult result)
	{
		_stopwatch?.Stop();
		string status = result.IsSuccess ? "OK" : $"FAIL: {result.ErrorMessage}";
		Console.WriteLine($"[Pipeline] {context.Command.CommandType} completed in {_stopwatch?.ElapsedMilliseconds}ms — {status}");
		return Task.CompletedTask;
	}
}
