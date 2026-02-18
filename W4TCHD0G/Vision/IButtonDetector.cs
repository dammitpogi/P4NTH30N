using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision;

/// <summary>
/// Contract for detecting interactive UI buttons in vision frames.
/// Identifies button positions, types, and enabled/disabled state.
/// </summary>
public interface IButtonDetector
{
	/// <summary>
	/// Detects all visible buttons in the frame.
	/// </summary>
	/// <param name="frame">The decoded vision frame to analyze.</param>
	/// <returns>List of detected buttons with positions and types.</returns>
	Task<List<DetectedButton>> DetectAsync(VisionFrame frame);

	/// <summary>
	/// Loads button templates for template matching detection.
	/// </summary>
	/// <param name="templateDirectory">Directory containing button template images.</param>
	void LoadTemplates(string templateDirectory);
}

/// <summary>
/// Represents a detected UI button in the vision frame.
/// </summary>
public sealed class DetectedButton
{
	/// <summary>
	/// Type of button detected.
	/// </summary>
	public ButtonType Type { get; init; }

	/// <summary>
	/// Center X coordinate of the button in frame pixels.
	/// </summary>
	public int CenterX { get; init; }

	/// <summary>
	/// Center Y coordinate of the button in frame pixels.
	/// </summary>
	public int CenterY { get; init; }

	/// <summary>
	/// Button width in pixels.
	/// </summary>
	public int Width { get; init; }

	/// <summary>
	/// Button height in pixels.
	/// </summary>
	public int Height { get; init; }

	/// <summary>
	/// Detection confidence score (0.0–1.0).
	/// </summary>
	public double Confidence { get; init; }

	/// <summary>
	/// Whether the button appears to be enabled (clickable).
	/// Determined by brightness/color analysis.
	/// </summary>
	public bool IsEnabled { get; init; } = true;

	/// <summary>
	/// Optional label text detected on the button.
	/// </summary>
	public string? Label { get; init; }
}

/// <summary>
/// Types of buttons detectable in casino game interfaces.
/// </summary>
public enum ButtonType
{
	Unknown,
	Spin,
	AutoSpin,
	BetIncrease,
	BetDecrease,
	MaxBet,
	Menu,
	Close,
	Collect,
	Gamble,
	Info,
}
