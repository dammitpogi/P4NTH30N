using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision.Stubs;

/// <summary>
/// FEAT-036: Rules-based state classifier stub.
/// Classifies game state using button presence and jackpot detection heuristics.
/// No ML model required — pure rule-based logic for development mode.
/// </summary>
public sealed class StubStateClassifier : IStateClassifier
{
	/// <summary>
	/// If set, always returns this state regardless of analysis.
	/// </summary>
	public GameState? ForcedState { get; set; }

	/// <summary>
	/// Simulated latency in milliseconds.
	/// </summary>
	public int SimulatedLatencyMs { get; set; } = 10;

	public async Task<GameState> ClassifyAsync(VisionFrame frame, List<DetectedButton> buttons, Dictionary<string, decimal> jackpots)
	{
		if (SimulatedLatencyMs > 0)
			await Task.Delay(SimulatedLatencyMs);

		if (ForcedState.HasValue)
			return ForcedState.Value;

		// Rule-based classification:

		// Rule 1: No buttons and no jackpots → Loading or Unknown
		if (buttons.Count == 0 && jackpots.Count == 0)
			return GameState.Loading;

		// Rule 2: Spin button enabled → Idle (ready for input)
		DetectedButton? spinButton = buttons.FirstOrDefault(b => b.Type == ButtonType.Spin);
		if (spinButton != null && spinButton.IsEnabled)
			return GameState.Idle;

		// Rule 3: Spin button present but disabled → Spinning
		if (spinButton != null && !spinButton.IsEnabled)
			return GameState.Spinning;

		// Rule 4: Collect button present → Win animation
		if (buttons.Any(b => b.Type == ButtonType.Collect))
			return GameState.WinAnimation;

		// Rule 5: Jackpots detected but no spin button → Bonus/FreeSpins
		if (jackpots.Count > 0 && spinButton == null)
			return GameState.BonusGame;

		// Rule 6: Buttons present, jackpots detected → Idle
		if (buttons.Count > 0 && jackpots.Count > 0)
			return GameState.Idle;

		return GameState.Unknown;
	}
}
