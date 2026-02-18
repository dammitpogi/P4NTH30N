using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Monitoring;

/// <summary>
/// Detects jackpot wins by monitoring balance changes and vision analysis.
/// Captures screenshots and logs comprehensive win data for verification.
/// </summary>
/// <remarks>
/// WIN DETECTION STRATEGY:
/// 1. Balance increase exceeding bet amount → probable win
/// 2. Win animation detected in game state → confirmed win
/// 3. Jackpot value change in OCR → jackpot tier identified
///
/// REQUIREMENTS (WIN-003):
/// - Win detected within 5 seconds
/// - 99% detection accuracy
/// - Complete win data captured (amount, tier, screenshot, timestamp)
/// </remarks>
public sealed class WinDetector
{
	/// <summary>
	/// Minimum balance increase (relative to bet) to classify as a win.
	/// Wins are typically 2x+ the bet amount.
	/// </summary>
	private readonly decimal _winThresholdMultiplier;

	/// <summary>
	/// Last known balance for change detection.
	/// </summary>
	private decimal _lastBalance;

	/// <summary>
	/// Last known bet amount.
	/// </summary>
	private decimal _lastBetAmount;

	/// <summary>
	/// Previous jackpot values for change detection.
	/// </summary>
	private Dictionary<string, decimal> _previousJackpots = new();

	/// <summary>
	/// Total wins detected since start.
	/// </summary>
	private long _totalWinsDetected;

	/// <summary>
	/// Total jackpot wins detected (subset of total wins).
	/// </summary>
	private long _totalJackpotWinsDetected;

	/// <summary>
	/// Total wins detected.
	/// </summary>
	public long TotalWinsDetected => Interlocked.Read(ref _totalWinsDetected);

	/// <summary>
	/// Total jackpot wins detected.
	/// </summary>
	public long TotalJackpotWinsDetected => Interlocked.Read(ref _totalJackpotWinsDetected);

	/// <summary>
	/// Event raised when any win is detected.
	/// </summary>
	public event Action<WinEvent>? OnWinDetected;

	/// <summary>
	/// Event raised specifically for jackpot wins (large balance changes or jackpot value resets).
	/// </summary>
	public event Action<WinEvent>? OnJackpotWinDetected;

	/// <summary>
	/// Creates a WinDetector.
	/// </summary>
	/// <param name="winThresholdMultiplier">Balance increase multiplier to count as a win. Default: 1.5x bet.</param>
	public WinDetector(decimal winThresholdMultiplier = 1.5m)
	{
		_winThresholdMultiplier = winThresholdMultiplier;
	}

	/// <summary>
	/// Sets the current bet amount for win threshold calculation.
	/// </summary>
	public void SetBetAmount(decimal betAmount)
	{
		_lastBetAmount = betAmount;
	}

	/// <summary>
	/// Analyzes a vision frame and balance for win detection.
	/// Call this after each analysis cycle.
	/// </summary>
	/// <param name="analysis">Vision analysis results.</param>
	/// <param name="currentBalance">Current account balance.</param>
	/// <param name="frameData">Raw frame data for screenshot capture (optional).</param>
	/// <returns>WinEvent if a win was detected, null otherwise.</returns>
	public WinEvent? Analyze(VisionAnalysis analysis, decimal currentBalance, byte[]? frameData = null)
	{
		WinEvent? winEvent = null;

		// Detection method 1: Balance increase
		if (_lastBalance > 0 && currentBalance > _lastBalance)
		{
			decimal increase = currentBalance - _lastBalance;
			decimal threshold = _lastBetAmount > 0 ? _lastBetAmount * _winThresholdMultiplier : 0.01m;

			if (increase >= threshold)
			{
				winEvent = new WinEvent
				{
					Type = increase >= _lastBetAmount * 50 ? WinType.Jackpot : WinType.Regular,
					Amount = increase,
					PreviousBalance = _lastBalance,
					NewBalance = currentBalance,
					DetectionMethod = "BalanceIncrease",
					GameState = analysis.GameState.ToString(),
					Confidence = 0.95,
					FrameSnapshot = frameData,
				};
			}
		}

		// Detection method 2: Jackpot value reset (jackpot was won)
		if (analysis.ExtractedJackpots.Count > 0 && _previousJackpots.Count > 0)
		{
			foreach (KeyValuePair<string, double> kv in analysis.ExtractedJackpots)
			{
				if (_previousJackpots.TryGetValue(kv.Key, out decimal previousValue))
				{
					decimal currentValue = (decimal)kv.Value;
					// Jackpot reset: value dropped significantly (>50% decrease = someone won)
					if (previousValue > 0 && currentValue < previousValue * 0.5m)
					{
						WinEvent jackpotEvent = new()
						{
							Type = WinType.Jackpot,
							Amount = previousValue, // The jackpot was at this value when won
							JackpotTier = kv.Key,
							DetectionMethod = "JackpotReset",
							GameState = analysis.GameState.ToString(),
							Confidence = 0.90,
							FrameSnapshot = frameData,
						};

						// If we also saw a balance increase, this is our jackpot
						if (winEvent is not null)
						{
							winEvent.Type = WinType.Jackpot;
							winEvent.JackpotTier = kv.Key;
							winEvent.Confidence = 0.99; // High confidence: both indicators
						}
						else
						{
							// Jackpot reset without our balance change = someone else won
							jackpotEvent.IsOurWin = false;
							Console.WriteLine($"[WinDetector] Jackpot reset detected ({kv.Key}: ${previousValue:F2} → ${currentValue:F2}) — not our win.");
						}
					}
				}
			}
		}

		// Update tracking state
		_lastBalance = currentBalance;
		_previousJackpots = analysis.ExtractedJackpots.ToDictionary(
			kv => kv.Key,
			kv => (decimal)kv.Value
		);

		// Raise events if win detected
		if (winEvent is not null)
		{
			Interlocked.Increment(ref _totalWinsDetected);
			Console.WriteLine($"[WinDetector] WIN DETECTED: {winEvent.Type} — ${winEvent.Amount:F2} ({winEvent.DetectionMethod})");
			OnWinDetected?.Invoke(winEvent);

			if (winEvent.Type == WinType.Jackpot)
			{
				Interlocked.Increment(ref _totalJackpotWinsDetected);
				Console.WriteLine($"[WinDetector] *** JACKPOT WIN: {winEvent.JackpotTier} — ${winEvent.Amount:F2} ***");
				OnJackpotWinDetected?.Invoke(winEvent);
			}
		}

		return winEvent;
	}
}

/// <summary>
/// Represents a detected win event with all relevant data.
/// </summary>
public sealed class WinEvent
{
	/// <summary>Type of win (regular or jackpot).</summary>
	public WinType Type { get; set; }

	/// <summary>Win amount in dollars.</summary>
	public decimal Amount { get; init; }

	/// <summary>Jackpot tier name (Grand, Major, Minor, Mini) if applicable.</summary>
	public string? JackpotTier { get; set; }

	/// <summary>Balance before the win.</summary>
	public decimal PreviousBalance { get; init; }

	/// <summary>Balance after the win.</summary>
	public decimal NewBalance { get; init; }

	/// <summary>How the win was detected.</summary>
	public string DetectionMethod { get; init; } = string.Empty;

	/// <summary>Game state at time of detection.</summary>
	public string GameState { get; init; } = string.Empty;

	/// <summary>Detection confidence (0.0–1.0).</summary>
	public double Confidence { get; set; }

	/// <summary>Whether this is our win (vs someone else winning the jackpot).</summary>
	public bool IsOurWin { get; set; } = true;

	/// <summary>Raw frame data at time of win (for screenshot evidence).</summary>
	public byte[]? FrameSnapshot { get; init; }

	/// <summary>Timestamp of detection.</summary>
	public DateTime Timestamp { get; init; } = DateTime.UtcNow;
}

/// <summary>
/// Classification of win types.
/// </summary>
public enum WinType
{
	/// <summary>Regular win (small/medium balance increase).</summary>
	Regular,

	/// <summary>Jackpot win (large balance increase or jackpot tier reset).</summary>
	Jackpot,

	/// <summary>Bonus round win.</summary>
	Bonus,

	/// <summary>Free spin win.</summary>
	FreeSpin,
}
