using P4NTH30N.W4TCHD0G.Input;
using P4NTH30N.W4TCHD0G.Models;
using P4NTH30N.W4TCHD0G.Vision;

namespace P4NTH30N.W4TCHD0G.Agent;

/// <summary>
/// Makes automation decisions by combining vision analysis with signal data.
/// Translates "what we see" + "what we need to do" into concrete input actions.
/// </summary>
/// <remarks>
/// DECISION FLOW:
/// 1. Check if game state allows action (Idle = ready to spin)
/// 2. Check if there's a pending signal requiring action
/// 3. Determine the appropriate action (click spin, adjust bet, collect, etc.)
/// 4. Generate InputAction sequence with correct coordinates
///
/// SAFETY:
/// - No action if game state is Unknown or Error
/// - No action if balance below minimum threshold
/// - No action if daily loss limit reached
/// </remarks>
public sealed class DecisionEngine
{
	/// <summary>
	/// Minimum balance (USD) below which the agent refuses to act.
	/// </summary>
	private readonly decimal _minBalance;

	/// <summary>
	/// Daily loss limit (USD) — agent pauses when exceeded.
	/// </summary>
	private readonly decimal _dailyLossLimit;

	/// <summary>
	/// Screen coordinate mapper for translating vision coords to VM coords.
	/// </summary>
	private readonly ScreenMapper _screenMapper;

	/// <summary>
	/// Running daily loss total.
	/// </summary>
	private decimal _dailyLoss;

	/// <summary>
	/// Last known balance for loss tracking.
	/// </summary>
	private decimal _lastBalance;

	/// <summary>
	/// Whether the daily loss limit has been hit.
	/// </summary>
	public bool IsLossLimitReached => _dailyLoss >= _dailyLossLimit;

	/// <summary>
	/// Current daily loss amount.
	/// </summary>
	public decimal DailyLoss => _dailyLoss;

	/// <summary>
	/// Creates a DecisionEngine with safety parameters.
	/// </summary>
	/// <param name="minBalance">Minimum balance to continue playing.</param>
	/// <param name="dailyLossLimit">Maximum daily loss before auto-pause.</param>
	/// <param name="screenMapper">Coordinate mapper for action targeting.</param>
	public DecisionEngine(decimal minBalance = 5.0m, decimal dailyLossLimit = 100.0m, ScreenMapper? screenMapper = null)
	{
		_minBalance = minBalance;
		_dailyLossLimit = dailyLossLimit;
		_screenMapper = screenMapper ?? new ScreenMapper();
	}

	/// <summary>
	/// Evaluates the current vision analysis and determines what actions to take.
	/// </summary>
	/// <param name="analysis">Vision analysis from the current frame.</param>
	/// <param name="hasSignal">Whether there's a pending signal requiring action.</param>
	/// <param name="currentBalance">Current account balance.</param>
	/// <returns>A decision result containing the action plan.</returns>
	public DecisionResult Evaluate(VisionAnalysis analysis, bool hasSignal, decimal currentBalance)
	{
		// SAFETY: Track balance changes for loss limit
		if (_lastBalance > 0 && currentBalance < _lastBalance)
		{
			_dailyLoss += _lastBalance - currentBalance;
		}
		_lastBalance = currentBalance;

		// SAFETY: Check loss limit
		if (IsLossLimitReached)
		{
			return DecisionResult.Pause($"Daily loss limit reached: ${_dailyLoss:F2} >= ${_dailyLossLimit:F2}");
		}

		// SAFETY: Check minimum balance
		if (currentBalance < _minBalance)
		{
			return DecisionResult.Pause($"Balance too low: ${currentBalance:F2} < ${_minBalance:F2}");
		}

		// SAFETY: No action on error state
		if (analysis.ErrorDetected || analysis.GameState == AnimationState.Error)
		{
			return DecisionResult.NoAction("Game error detected. Waiting for recovery.");
		}

		// Only act when game is idle (ready for input)
		if (analysis.GameState != AnimationState.Idle)
		{
			return DecisionResult.NoAction($"Game busy: {analysis.GameState}. Waiting.");
		}

		// No signal = no action needed
		if (!hasSignal)
		{
			return DecisionResult.NoAction("No pending signal.");
		}

		// Game is idle and we have a signal — execute spin
		// FEAT-036: Use vision-detected button coordinates when available
		if (analysis.DetectedButtons != null && analysis.DetectedButtons.Count > 0)
		{
			DetectedButton? spinButton = analysis.DetectedButtons.FirstOrDefault(b =>
	b?.Label?.Contains("spin", StringComparison.OrdinalIgnoreCase) == true);
			if (spinButton != null)
			{
				return DecisionResult.Act("Execute spin (vision-targeted)", GenerateButtonClickActions(spinButton));
			}
		}

		return DecisionResult.Act("Execute spin", GenerateSpinActions());
	}

	/// <summary>
	/// Generates the input action sequence for clicking the spin button.
	/// Uses a generic center-screen click as a fallback.
	/// </summary>
	private List<InputAction> GenerateSpinActions()
	{
		// Default spin button location (bottom-center of typical slot game)
		// These should be overridden by button detection results
		return new List<InputAction> { InputAction.Delay(200), InputAction.Click(640, 650, MouseButton.Left, delayAfterMs: 500) };
	}

	/// <summary>
	/// Generates actions targeting a specific detected button.
	/// </summary>
	/// <param name="button">The detected button to click.</param>
	/// <returns>Action sequence for clicking the button.</returns>
	public List<InputAction> GenerateButtonClickActions(DetectedButton button)
	{
		return new List<InputAction>
		{
			InputAction.MoveMouse(button.CenterX, button.CenterY, delayAfterMs: 100),
			InputAction.Click(button.CenterX, button.CenterY, MouseButton.Left, delayAfterMs: 500),
		};
	}

	/// <summary>
	/// Resets the daily loss counter (call at midnight or manual reset).
	/// </summary>
	public void ResetDailyLoss()
	{
		_dailyLoss = 0;
		Console.WriteLine("[DecisionEngine] Daily loss counter reset.");
	}
}

/// <summary>
/// Result of a decision evaluation cycle.
/// </summary>
public sealed class DecisionResult
{
	/// <summary>
	/// Type of decision made.
	/// </summary>
	public DecisionType Type { get; init; }

	/// <summary>
	/// Human-readable reason for the decision.
	/// </summary>
	public string Reason { get; init; } = string.Empty;

	/// <summary>
	/// Actions to execute (empty if no action).
	/// </summary>
	public List<InputAction> Actions { get; init; } = new();

	/// <summary>
	/// Creates a "no action needed" decision.
	/// </summary>
	public static DecisionResult NoAction(string reason)
	{
		return new DecisionResult { Type = DecisionType.NoAction, Reason = reason };
	}

	/// <summary>
	/// Creates an "execute actions" decision.
	/// </summary>
	public static DecisionResult Act(string reason, List<InputAction> actions)
	{
		return new DecisionResult
		{
			Type = DecisionType.Act,
			Reason = reason,
			Actions = actions,
		};
	}

	/// <summary>
	/// Creates a "pause agent" decision (safety limit reached).
	/// </summary>
	public static DecisionResult Pause(string reason)
	{
		return new DecisionResult { Type = DecisionType.Pause, Reason = reason };
	}
}

/// <summary>
/// Types of decisions the engine can make.
/// </summary>
public enum DecisionType
{
	/// <summary>No action needed this cycle.</summary>
	NoAction,

	/// <summary>Execute the planned actions.</summary>
	Act,

	/// <summary>Pause the agent (safety limit).</summary>
	Pause,
}
