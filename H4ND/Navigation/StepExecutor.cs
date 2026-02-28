using System.Diagnostics;
using P4NTHE0N.H4ND.Navigation.ErrorHandling;
using P4NTHE0N.H4ND.Navigation.Retry;
using P4NTHE0N.H4ND.Navigation.Strategies;
using P4NTHE0N.H4ND.Navigation.Verification;

namespace P4NTHE0N.H4ND.Navigation;

/// <summary>
/// ARCH-098: Core step executor — resolves strategy by action type, runs verification gates,
/// handles errors. Stateless and thread-safe (all mutable state is in StepExecutionContext).
/// </summary>
public sealed class StepExecutor : IStepExecutor
{
	private readonly IReadOnlyDictionary<string, IStepStrategy> _strategies;
	private readonly IVerificationStrategy _verification;
	private readonly IErrorHandler _errorHandler;

	public StepExecutor(
		IEnumerable<IStepStrategy> strategies,
		IVerificationStrategy? verification = null,
		IErrorHandler? errorHandler = null)
	{
		_strategies = strategies.ToDictionary(s => s.ActionType, s => s, StringComparer.OrdinalIgnoreCase);
		_verification = verification ?? new JavaScriptVerificationStrategy();
		_errorHandler = errorHandler ?? new ErrorHandlerChain();
	}

	/// <summary>
	/// Execute a single navigation step: verify entry gate → execute action → delay → verify exit gate → screenshot.
	/// </summary>
	public async Task<StepExecutionResult> ExecuteStepAsync(NavigationStep step, StepExecutionContext context, CancellationToken ct)
	{
		var sw = Stopwatch.StartNew();

		try
		{
			// Entry gate verification — fail fast if gate is meaningful
			bool entryOk = await _verification.VerifyAsync(step.Verification.EntryGate, context, ct);
			if (!entryOk && !string.IsNullOrWhiteSpace(step.Verification.EntryGate))
			{
				sw.Stop();
				var error = $"Step {step.StepId} entry gate FAILED: {step.Verification.EntryGate}";
				Console.WriteLine($"[Nav:Worker-{context.WorkerId}] {error}");
				throw new InvalidOperationException(error);
			}

			// Resolve strategy
			if (!_strategies.TryGetValue(step.Action, out var strategy))
			{
				sw.Stop();
				return StepExecutionResult.Failed(step.StepId, $"Unknown action type: '{step.Action}'", sw.Elapsed);
			}

			// Execute the action
			await strategy.ExecuteAsync(step, context, ct);

			// Post-action delay
			if (step.DelayMs > 0)
			{
				await Task.Delay(step.DelayMs, ct);
			}

			// Capture screenshot if required
			await ScreenshotVerificationStrategy.CaptureIfRequiredAsync(step, context, ct);

			// Exit gate verification — fail fast if gate is meaningful
			bool exitOk = await _verification.VerifyAsync(step.Verification.ExitGate, context, ct);
			if (!exitOk && !string.IsNullOrWhiteSpace(step.Verification.ExitGate))
			{
				sw.Stop();
				var error = $"Step {step.StepId} exit gate FAILED: {step.Verification.ExitGate}";
				Console.WriteLine($"[Nav:Worker-{context.WorkerId}] {error}");
				throw new InvalidOperationException(error);
			}

			sw.Stop();
			return StepExecutionResult.Succeeded(step.StepId, sw.Elapsed);
		}
		catch (OperationCanceledException)
		{
			throw; // Propagate cancellation
		}
		catch (Exception ex)
		{
			sw.Stop();

			// Consult error handler chain
			var errorResult = await _errorHandler.HandleAsync(step, context, ex, ct);
			if (errorResult.Action == ErrorAction.Goto && errorResult.GotoStepId.HasValue)
			{
				return StepExecutionResult.Goto(step.StepId, errorResult.GotoStepId.Value, sw.Elapsed);
			}

			return StepExecutionResult.Failed(step.StepId, ex.Message, sw.Elapsed);
		}
	}

	/// <summary>
	/// Execute all enabled steps in a navigation phase sequentially.
	/// Refreshes canvas bounds at the start of each phase.
	/// Supports goto branching from conditional steps.
	/// </summary>
	public async Task<PhaseExecutionResult> ExecutePhaseAsync(NavigationMap map, string phase, StepExecutionContext context, CancellationToken ct)
	{
		var phaseSw = Stopwatch.StartNew();
		var steps = map.GetStepsForPhase(phase).ToList();
		var results = new List<StepExecutionResult>();

		if (steps.Count == 0)
		{
			phaseSw.Stop();
			Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Phase '{phase}' has no enabled steps — skipping");
			return PhaseExecutionResult.Succeeded(phase, results, phaseSw.Elapsed);
		}

		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] ═══ Phase '{phase}' — {steps.Count} steps ═══");

		// Refresh canvas bounds at phase start
		await context.RefreshCanvasBoundsAsync(ct);

		int stepIndex = 0;
		int maxGotoLoops = 5; // Prevent infinite goto loops
		int gotoCount = 0;

		while (stepIndex < steps.Count)
		{
			ct.ThrowIfCancellationRequested();

			var step = steps[stepIndex];

			// Use RetryStepDecorator for per-step retry
			var retryExecutor = new RetryStepDecorator(this);
			var result = await retryExecutor.ExecuteStepAsync(step, context, ct);
			results.Add(result);

			if (!result.Success)
			{
				phaseSw.Stop();
				Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Phase '{phase}' FAILED at step {step.StepId}: {result.ErrorMessage}");
				return PhaseExecutionResult.Failed(phase, results, phaseSw.Elapsed, result.ErrorMessage ?? "Step failed");
			}

			// Handle goto branching
			if (result.GotoStepId.HasValue)
			{
				gotoCount++;
				if (gotoCount >= maxGotoLoops)
				{
					phaseSw.Stop();
					return PhaseExecutionResult.Failed(phase, results, phaseSw.Elapsed,
						$"Max goto loops ({maxGotoLoops}) exceeded at step {step.StepId}");
				}

				var targetStep = map.GetStepById(result.GotoStepId.Value);
				if (targetStep != null)
				{
					int targetIndex = steps.FindIndex(s => s.StepId == result.GotoStepId.Value);
					if (targetIndex >= 0)
					{
						Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Goto: step {step.StepId} → step {result.GotoStepId}");
						stepIndex = targetIndex;
						continue;
					}
				}
			}

			stepIndex++;
		}

		phaseSw.Stop();
		Console.WriteLine($"[Nav:Worker-{context.WorkerId}] Phase '{phase}' COMPLETED in {phaseSw.Elapsed.TotalSeconds:F1}s ({results.Count} steps)");
		return PhaseExecutionResult.Succeeded(phase, results, phaseSw.Elapsed);
	}

	/// <summary>
	/// Factory: create a StepExecutor with all default strategies wired up.
	/// </summary>
	public static StepExecutor CreateDefault()
	{
		var strategies = new IStepStrategy[]
		{
			new ClickStepStrategy(),
			new TypeStepStrategy(),
			new ClipStepStrategy(),
			new WaitStepStrategy(),
			new NavigateStepStrategy(),
			new LongPressStepStrategy(),
		};

		return new StepExecutor(
			strategies,
			new JavaScriptVerificationStrategy(),
			new ErrorHandlerChain());
	}
}
