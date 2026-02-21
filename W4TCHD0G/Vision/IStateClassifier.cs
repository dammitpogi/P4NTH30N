using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision;

/// <summary>
/// Contract for classifying the current game state from vision analysis data.
/// Uses rules-based classification combining button presence, animation detection,
/// and OCR results to determine the game's current phase.
/// </summary>
public interface IStateClassifier
{
	/// <summary>
	/// Classifies the game state from a vision frame and partial analysis.
	/// </summary>
	/// <param name="frame">The decoded vision frame.</param>
	/// <param name="buttons">Detected buttons from the button detector.</param>
	/// <param name="jackpots">Detected jackpot values from the jackpot detector.</param>
	/// <returns>The classified game state.</returns>
	Task<GameState> ClassifyAsync(VisionFrame frame, List<DetectedButton> buttons, Dictionary<string, decimal> jackpots);
}

/// <summary>
/// Comprehensive game state enumeration for casino slot games.
/// Extends the existing AnimationState with more granular states.
/// </summary>
public enum GameState
{
	/// <summary>State has not been determined.</summary>
	Unknown = 0,

	/// <summary>Game is idle, waiting for player input (spin button enabled).</summary>
	Idle = 1,

	/// <summary>Reels are spinning (animation in progress).</summary>
	Spinning = 2,

	/// <summary>Win animation playing (showing win amount).</summary>
	WinAnimation = 3,

	/// <summary>Bonus round is active.</summary>
	BonusGame = 4,

	/// <summary>Free spins mode is active.</summary>
	FreeSpins = 5,

	/// <summary>Game is loading or transitioning.</summary>
	Loading = 6,

	/// <summary>Error or disconnect detected in the game UI.</summary>
	Error = 7,

	/// <summary>Game session has ended or timed out.</summary>
	SessionEnded = 8,
}
