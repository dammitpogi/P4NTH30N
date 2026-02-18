using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Vision;

/// <summary>
/// Contract for detecting and extracting jackpot values from vision frames via OCR.
/// Supports multiple jackpot tiers (Grand, Major, Minor, Mini) with configurable ROIs.
/// </summary>
public interface IJackpotDetector
{
	/// <summary>
	/// Detects all jackpot values visible in the frame.
	/// </summary>
	/// <param name="frame">The decoded vision frame to analyze.</param>
	/// <returns>Dictionary of tier name → detected value. Missing tiers are omitted.</returns>
	Task<Dictionary<string, decimal>> DetectAsync(VisionFrame frame);

	/// <summary>
	/// Detects a single jackpot value from a specific ROI.
	/// </summary>
	/// <param name="frame">The decoded vision frame.</param>
	/// <param name="roi">Region of interest containing the jackpot display.</param>
	/// <returns>The detected decimal value, or null if OCR failed.</returns>
	Task<decimal?> DetectSingleAsync(VisionFrame frame, RegionOfInterest roi);

	/// <summary>
	/// Configures the ROIs for each jackpot tier.
	/// </summary>
	/// <param name="rois">Dictionary of tier name → ROI definition.</param>
	void ConfigureROIs(Dictionary<string, RegionOfInterest> rois);
}
