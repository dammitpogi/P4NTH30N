using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Support;

namespace P4NTH30N.H0UND.Services;

/// <summary>
/// DECISION_028: Dynamic wager optimization service.
/// Phase 1: Rule-based optimizer that logs WagerFeatures for training data collection.
/// Phase 2 (future): XGBoost model replaces rules when sufficient training data exists.
/// Integrates with signal generation to make spin/bet decisions.
/// </summary>
public sealed class WagerOptimizer
{
	private readonly IUnitOfWork _uow;
	private readonly WagerOptimizerConfig _config;
	private long _totalDecisions;
	private long _spinRecommendations;
	private long _skipRecommendations;

	public long TotalDecisions => Interlocked.Read(ref _totalDecisions);
	public long SpinRecommendations => Interlocked.Read(ref _spinRecommendations);
	public long SkipRecommendations => Interlocked.Read(ref _skipRecommendations);

	public WagerOptimizer(IUnitOfWork uow, WagerOptimizerConfig? config = null)
	{
		_uow = uow;
		_config = config ?? new WagerOptimizerConfig();
	}

	/// <summary>
	/// Makes a spin decision based on current game state.
	/// Returns a WagerDecision with recommendation and confidence.
	/// Logs the WagerFeatures for future model training.
	/// </summary>
	public WagerDecision Evaluate(WagerFeatures features)
	{
		Interlocked.Increment(ref _totalDecisions);

		// Rule-based scoring (Phase 1 — replaced by XGBoost in Phase 2)
		double score = CalculateRuleScore(features);
		bool shouldSpin = score >= _config.SpinThreshold;

		if (shouldSpin)
			Interlocked.Increment(ref _spinRecommendations);
		else
			Interlocked.Increment(ref _skipRecommendations);

		var decision = new WagerDecision
		{
			ShouldSpin = shouldSpin,
			Confidence = Math.Clamp(score, 0, 1),
			Score = score,
			Reason = BuildReason(features, score),
			Features = features,
			DecidedAt = DateTime.UtcNow,
		};

		// Log features for training data
		if (_config.LogFeatures)
		{
			LogFeatures(features, decision);
		}

		return decision;
	}

	/// <summary>
	/// Records the outcome of a spin session for training data.
	/// Called after a spin completes to update the WagerFeatures record.
	/// </summary>
	public void RecordOutcome(WagerFeatures features, bool jackpotHit, double profitLoss, int spinCount)
	{
		features.JackpotHit = jackpotHit;
		features.ProfitLoss = profitLoss;
		features.SpinCount = spinCount;
		features.OutcomeRecorded = true;

		if (_config.LogFeatures)
		{
			Console.WriteLine($"[WagerOptimizer] Outcome: {features.House}/{features.Game}/{features.Tier} " +
				$"hit={jackpotHit} P/L={profitLoss:+0.00;-0.00} spins={spinCount}");
		}
	}

	/// <summary>
	/// Phase 1: Rule-based scoring.
	/// Score 0.0-1.0 where higher = stronger recommendation to spin.
	/// </summary>
	private double CalculateRuleScore(WagerFeatures features)
	{
		double score = 0;

		// Jackpot ratio is the primary signal (0-40% of score)
		if (features.JackpotRatio >= 1.0)
			score += 0.40; // At or above threshold
		else if (features.JackpotRatio >= 0.9)
			score += 0.30; // Close to threshold
		else if (features.JackpotRatio >= 0.8)
			score += 0.20;
		else
			score += features.JackpotRatio * 0.15;

		// DPD growth rate (0-20% of score)
		if (features.DPD > 50)
			score += 0.20; // Fast growth
		else if (features.DPD > 20)
			score += 0.15;
		else if (features.DPD > 5)
			score += 0.10;
		else
			score += 0.05;

		// Time-of-day pattern (0-15% of score)
		// Historical data shows higher hit rates during peak hours
		if (features.HourOfDay >= 20 || features.HourOfDay <= 2)
			score += 0.15; // Late night peak
		else if (features.HourOfDay >= 12 && features.HourOfDay <= 14)
			score += 0.10; // Lunch peak
		else
			score += 0.05;

		// Minutes since last hit (0-15% of score)
		// Longer time since last hit = higher probability
		if (features.MinutesSinceLastHit > 1440) // > 24 hours
			score += 0.15;
		else if (features.MinutesSinceLastHit > 720) // > 12 hours
			score += 0.12;
		else if (features.MinutesSinceLastHit > 360) // > 6 hours
			score += 0.08;
		else
			score += 0.03;

		// Balance check (0-10% of score)
		if (features.Balance >= _config.MinBalanceForSpin)
			score += 0.10;
		else
			score -= 0.10; // Penalty for low balance

		return Math.Clamp(score, 0, 1);
	}

	private static string BuildReason(WagerFeatures features, double score)
	{
		return $"JR={features.JackpotRatio:F2} DPD={features.DPD:F1} " +
			$"Hr={features.HourOfDay} MinSinceHit={features.MinutesSinceLastHit:F0} " +
			$"Bal={features.Balance:F2} Score={score:F3}";
	}

	private void LogFeatures(WagerFeatures features, WagerDecision decision)
	{
		Console.WriteLine($"[WagerOptimizer] {features.House}/{features.Game}/{features.Tier}: " +
			$"score={decision.Score:F3} → {(decision.ShouldSpin ? "SPIN" : "SKIP")} " +
			$"(JR={features.JackpotRatio:F2}, DPD={features.DPD:F1}, Bal=${features.Balance:F2})");
	}

	/// <summary>
	/// Gets a summary of optimizer performance.
	/// </summary>
	public string GetSummary()
	{
		double spinRate = TotalDecisions > 0 ? (double)SpinRecommendations / TotalDecisions * 100 : 0;
		return $"[WagerOptimizer] Decisions={TotalDecisions} Spin={SpinRecommendations} Skip={SkipRecommendations} Rate={spinRate:F1}%";
	}
}

/// <summary>
/// DECISION_028: Configuration for the wager optimizer.
/// </summary>
public sealed class WagerOptimizerConfig
{
	/// <summary>
	/// Minimum score threshold to recommend a spin (0.0-1.0).
	/// </summary>
	public double SpinThreshold { get; set; } = 0.55;

	/// <summary>
	/// Minimum account balance to consider spinning.
	/// </summary>
	public double MinBalanceForSpin { get; set; } = 1.00;

	/// <summary>
	/// Whether to log features for training data.
	/// </summary>
	public bool LogFeatures { get; set; } = true;

	/// <summary>
	/// Path to XGBoost model file (Phase 2 — null means use rule-based).
	/// </summary>
	public string? ModelPath { get; set; }
}

/// <summary>
/// DECISION_028: Result of a wager optimization decision.
/// </summary>
public sealed class WagerDecision
{
	public bool ShouldSpin { get; init; }
	public double Confidence { get; init; }
	public double Score { get; init; }
	public string Reason { get; init; } = string.Empty;
	public WagerFeatures? Features { get; init; }
	public DateTime DecidedAt { get; init; }

	public override string ToString() =>
		$"[Wager] {(ShouldSpin ? "SPIN" : "SKIP")} conf={Confidence:F2} score={Score:F3} — {Reason}";
}
