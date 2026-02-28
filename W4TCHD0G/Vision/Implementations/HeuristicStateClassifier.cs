using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G.Vision.Implementations;

/// <summary>
/// FEAT-036: Heuristic state classifier using combined vision signals.
/// Classifies game state using button presence, jackpot changes, frame motion,
/// and timing heuristics. Pure rules-based — no ML required.
/// </summary>
public sealed class HeuristicStateClassifier : IStateClassifier
{
	private GameState _previousState = GameState.Unknown;
	private Dictionary<string, decimal> _previousJackpots = new();
	private DateTime _lastStateChange = DateTime.UtcNow;
	private int _stableFrameCount;

	/// <summary>
	/// Number of consecutive frames with the same state before confirming a state change.
	/// </summary>
	public int StabilityThreshold { get; set; } = 3;

	public async Task<GameState> ClassifyAsync(VisionFrame frame, List<DetectedButton> buttons, Dictionary<string, decimal> jackpots)
	{
		await Task.CompletedTask; // Synchronous heuristics

		GameState rawState = ClassifyRaw(frame, buttons, jackpots);

		// Apply stability filter: require N consecutive frames of same state
		if (rawState == _previousState)
		{
			_stableFrameCount++;
		}
		else
		{
			_stableFrameCount = 1;
		}

		GameState confirmedState;
		if (_stableFrameCount >= StabilityThreshold)
		{
			confirmedState = rawState;
			if (confirmedState != _previousState)
			{
				_lastStateChange = DateTime.UtcNow;
			}
		}
		else
		{
			// Not stable yet — keep previous state
			confirmedState = _previousState;
		}

		_previousState = confirmedState;
		_previousJackpots = new Dictionary<string, decimal>(jackpots);

		return confirmedState;
	}

	/// <summary>
	/// Raw classification without stability filtering.
	/// </summary>
	private GameState ClassifyRaw(VisionFrame frame, List<DetectedButton> buttons, Dictionary<string, decimal> jackpots)
	{
		bool hasSpinButton = buttons.Any(b => b.Type == ButtonType.Spin);
		bool spinEnabled = buttons.Any(b => b.Type == ButtonType.Spin && b.IsEnabled);
		bool hasCollectButton = buttons.Any(b => b.Type == ButtonType.Collect);
		bool hasAnyButton = buttons.Count > 0;
		bool hasJackpots = jackpots.Count > 0;

		// Check for jackpot value changes (indicates a pop)
		foreach (var kv in jackpots)
		{
			if (_previousJackpots.TryGetValue(kv.Key, out decimal prev) && Math.Abs(kv.Value - prev) > 0.01m)
			{
				// Jackpot value changed significantly
				break;
			}
		}

		// Error detection: no buttons, no jackpots, frame appears blank
		if (!hasAnyButton && !hasJackpots)
		{
			// Check if this is a loading state or error
			TimeSpan timeSinceChange = DateTime.UtcNow - _lastStateChange;
			if (timeSinceChange > TimeSpan.FromSeconds(30))
				return GameState.Error; // Too long without any detection
			return GameState.Loading;
		}

		// Collect button visible → Win animation
		if (hasCollectButton)
			return GameState.WinAnimation;

		// Spin button enabled → Idle
		if (spinEnabled)
			return GameState.Idle;

		// Spin button visible but disabled → Spinning
		if (hasSpinButton && !spinEnabled)
			return GameState.Spinning;

		// No spin button but jackpots visible → possibly bonus/free spins
		if (!hasSpinButton && hasJackpots)
			return GameState.BonusGame;

		// Buttons visible, jackpots detected → Idle (best guess)
		if (hasAnyButton && hasJackpots)
			return GameState.Idle;

		return GameState.Unknown;
	}
}
