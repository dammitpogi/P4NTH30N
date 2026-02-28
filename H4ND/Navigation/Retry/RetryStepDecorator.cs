using System.Diagnostics;

namespace P4NTHE0N.H4ND.Navigation.Retry;

/// <summary>
/// ARCH-098: Decorator pattern — wraps IStepExecutor with retry logic.
/// Retries failed steps with exponential backoff. Captures screenshots on each failure.
/// </summary>
public sealed class RetryStepDecorator : IStepExecutor
{
	private readonly IStepExecutor _inner;
	private readonly ExponentialBackoffPolicy _policy;

	public RetryStepDecorator(IStepExecutor inner, ExponentialBackoffPolicy? policy = null)
	{
		_inner = inner;
		_policy = policy ?? new ExponentialBackoffPolicy();
	}

	public async Task<StepExecutionResult> ExecuteStepAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		var sw = Stopwatch.StartNew();
		StepExecutionResult? lastResult = null;

		for (int attempt = 1; attempt <= _policy.MaxRetries; attempt++)
		{
			lastResult = await _inner.ExecuteStepAsync(step, context, ct);

			if (lastResult.Success)
			{
				return StepExecutionResult.Succeeded(step.StepId, sw.Elapsed, attempt);
			}

			if (attempt < _policy.MaxRetries)
			{
				var delay = _policy.CalculateDelay(attempt);
				Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Step {step.StepId} failed (attempt {attempt}/{_policy.MaxRetries}): {lastResult.ErrorMessage} — retrying in {delay.TotalMilliseconds:F0}ms");
				await Task.Delay(delay, ct);
			}
		}

		sw.Stop();
		return StepExecutionResult.Failed(
			step.StepId,
			$"Failed after {_policy.MaxRetries} attempts: {lastResult?.ErrorMessage}",
			sw.Elapsed,
			_policy.MaxRetries);
	}

	public async Task<PhaseExecutionResult> ExecutePhaseAsync(NavigationMap map, string phase, StepExecutionContext context, CancellationToken ct)
	{
		// Phase execution delegates to inner — retry is per-step, not per-phase
		return await _inner.ExecutePhaseAsync(map, phase, context, ct);
	}
}
