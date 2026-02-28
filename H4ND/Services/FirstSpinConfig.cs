namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// SPIN-044: Configuration for the first autonomous jackpot spin execution.
/// Bound from appsettings.json P4NTHE0N:H4ND:FirstSpin section.
/// </summary>
public sealed class FirstSpinConfig
{
	/// <summary>
	/// Maximum bet amount in dollars. Hardcoded safety limit for first spin.
	/// </summary>
	public double MaxBetAmount { get; set; } = 0.10;

	/// <summary>
	/// Whether manual operator confirmation is required before spinning.
	/// </summary>
	public bool RequireConfirmation { get; set; } = true;

	/// <summary>
	/// Timeout in seconds for operator confirmation. Aborts if exceeded.
	/// </summary>
	public int ConfirmationTimeoutSec { get; set; } = 60;

	/// <summary>
	/// Maximum time in seconds to wait for a spin to complete.
	/// </summary>
	public int SpinTimeoutSec { get; set; } = 30;

	/// <summary>
	/// Target game platform for the first spin.
	/// </summary>
	public string TargetGame { get; set; } = "FireKirin";

	/// <summary>
	/// Minimum account balance required to proceed with spin.
	/// </summary>
	public double MinBalance { get; set; } = 1.00;

	/// <summary>
	/// Whether to capture screenshots during the spin process.
	/// </summary>
	public bool CaptureScreenshots { get; set; } = true;

	/// <summary>
	/// Whether to save telemetry to MongoDB.
	/// </summary>
	public bool SaveToMongoDB { get; set; } = true;
}
