using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.C0MMON.Support;

/// <summary>
/// DECISION_028: Feature vector for XGBoost dynamic wager placement.
/// Logged on every spin decision to build training data for the ML model.
/// Based on ArXiv 2401.06086v1 - XGBoost Learning of Dynamic Wager Placement.
/// </summary>
[BsonIgnoreExtraElements]
public class WagerFeatures
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();

	// --- Jackpot features ---

	/// <summary>
	/// Current jackpot value for the target tier.
	/// </summary>
	public double JackpotCurrent { get; set; }

	/// <summary>
	/// Jackpot threshold for the target tier.
	/// </summary>
	public double JackpotThreshold { get; set; }

	/// <summary>
	/// Ratio of current to threshold (0.0 to 1.0+).
	/// </summary>
	public double JackpotRatio { get; set; }

	/// <summary>
	/// DPD (dollars per day) growth rate.
	/// </summary>
	public double DPD { get; set; }

	/// <summary>
	/// Estimated minutes until threshold hit.
	/// </summary>
	public double EstimatedMinutes { get; set; }

	// --- Time features ---

	/// <summary>
	/// Hour of day (0-23) for time-of-day patterns.
	/// </summary>
	public int HourOfDay { get; set; }

	/// <summary>
	/// Day of week (0=Sunday, 6=Saturday).
	/// </summary>
	public int DayOfWeek { get; set; }

	/// <summary>
	/// Minutes since last jackpot hit on this tier.
	/// </summary>
	public double MinutesSinceLastHit { get; set; }

	// --- Account features ---

	/// <summary>
	/// Current account balance.
	/// </summary>
	public double Balance { get; set; }

	/// <summary>
	/// Whether the account has been funded (not cashed out).
	/// </summary>
	public bool IsFunded { get; set; }

	/// <summary>
	/// Account age in days.
	/// </summary>
	public double AccountAgeDays { get; set; }

	// --- Game features ---

	/// <summary>
	/// House identifier.
	/// </summary>
	public string House { get; set; } = string.Empty;

	/// <summary>
	/// Game platform.
	/// </summary>
	public string Game { get; set; } = string.Empty;

	/// <summary>
	/// Jackpot tier: Grand, Major, Minor, Mini.
	/// </summary>
	public string Tier { get; set; } = string.Empty;

	/// <summary>
	/// Signal priority at decision time (1=highest).
	/// </summary>
	public int SignalPriority { get; set; }

	// --- Outcome (label for training) ---

	/// <summary>
	/// Whether a jackpot was hit during this session.
	/// </summary>
	public bool JackpotHit { get; set; }

	/// <summary>
	/// Profit/loss from this spin session (positive = profit).
	/// </summary>
	public double ProfitLoss { get; set; }

	/// <summary>
	/// Number of spins executed in this session.
	/// </summary>
	public int SpinCount { get; set; }

	// --- Metadata ---

	/// <summary>
	/// When this feature vector was logged.
	/// </summary>
	public DateTime LoggedAt { get; set; } = DateTime.UtcNow;

	/// <summary>
	/// Username used for this session.
	/// </summary>
	public string Username { get; set; } = string.Empty;

	/// <summary>
	/// Whether outcome has been recorded (initially false, set true after session).
	/// </summary>
	public bool OutcomeRecorded { get; set; }

	/// <summary>
	/// Creates a feature vector from current game state.
	/// </summary>
	public static WagerFeatures FromGameState(
		string house, string game, string tier, string username,
		double jackpotCurrent, double jackpotThreshold, double dpd,
		double estimatedMinutes, double balance, bool isFunded,
		double accountAgeDays, int signalPriority, double minutesSinceLastHit)
	{
		DateTime now = DateTime.UtcNow;
		return new WagerFeatures
		{
			House = house,
			Game = game,
			Tier = tier,
			Username = username,
			JackpotCurrent = jackpotCurrent,
			JackpotThreshold = jackpotThreshold,
			JackpotRatio = jackpotThreshold > 0 ? jackpotCurrent / jackpotThreshold : 0,
			DPD = dpd,
			EstimatedMinutes = estimatedMinutes,
			HourOfDay = now.Hour,
			DayOfWeek = (int)now.DayOfWeek,
			MinutesSinceLastHit = minutesSinceLastHit,
			Balance = balance,
			IsFunded = isFunded,
			AccountAgeDays = accountAgeDays,
			SignalPriority = signalPriority,
		};
	}

	/// <summary>
	/// Extracts the numeric feature array for model input (14 features).
	/// </summary>
	public double[] ToFeatureArray()
	{
		return new double[]
		{
			JackpotCurrent,
			JackpotThreshold,
			JackpotRatio,
			DPD,
			EstimatedMinutes,
			HourOfDay,
			DayOfWeek,
			MinutesSinceLastHit,
			Balance,
			IsFunded ? 1.0 : 0.0,
			AccountAgeDays,
			SignalPriority,
			SpinCount,
			ProfitLoss,
		};
	}
}
