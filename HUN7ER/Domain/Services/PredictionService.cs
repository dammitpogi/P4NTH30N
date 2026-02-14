using P4NTH30N.HUN7ER.Domain.Entities;
using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Domain.Services;

/// <summary>
/// Domain service for generating jackpot predictions
/// </summary>
public class PredictionService
{
	private const double DpmEpsilon = 1e-9;
	private const double MaxDaysToAdd = 365;

	/// <summary>
	/// Calculates minutes until jackpot reaches threshold
	/// </summary>
	public double CalculateMinutesToThreshold(GameCredential credential, JackpotTier tier)
	{
		double jackpotValue = tier switch
		{
			JackpotTier.Grand => credential.Jackpots.Grand,
			JackpotTier.Major => credential.Jackpots.Major,
			JackpotTier.Minor => credential.Jackpots.Minor,
			JackpotTier.Mini => credential.Jackpots.Mini,
			_ => 0,
		};

		double threshold = tier switch
		{
			JackpotTier.Grand => credential.Thresholds.Grand,
			JackpotTier.Major => credential.Thresholds.Major,
			JackpotTier.Minor => credential.Thresholds.Minor,
			JackpotTier.Mini => credential.Thresholds.Mini,
			_ => 0,
		};

		return CalculateMinutesToValue(threshold, jackpotValue, credential.DPD.Average);
	}

	/// <summary>
	/// Calculates estimated time to reach a value given DPD
	/// </summary>
	public double CalculateMinutesToValue(double threshold, double currentValue, double dpd)
	{
		double remaining = threshold - currentValue;
		if (remaining <= 0)
			return 0;

		if (double.IsNaN(dpd) || double.IsInfinity(dpd) || dpd <= DpmEpsilon)
			return TimeSpan.FromDays(365 * 100).TotalMinutes; // 100 years

		double dpm = dpd / TimeSpan.FromDays(1).TotalMinutes;
		return remaining / dpm;
	}

	/// <summary>
	/// Generates predictions for all jackpot tiers
	/// </summary>
	public List<JackpotPrediction> GeneratePredictions(GameCredential credential, DateTime dateLimit)
	{
		var predictions = new List<JackpotPrediction>();

		if (credential.DPD.Average <= 0.01)
			return predictions;

		var tiers = new[]
		{
			(JackpotTier.Grand, credential.SpinGrand),
			(JackpotTier.Major, credential.SpinMajor),
			(JackpotTier.Minor, credential.SpinMinor),
			(JackpotTier.Mini, credential.SpinMini),
		};

		foreach (var (tier, enabled) in tiers)
		{
			if (!enabled)
				continue;

			double current = tier switch
			{
				JackpotTier.Grand => credential.Jackpots.Grand,
				JackpotTier.Major => credential.Jackpots.Major,
				JackpotTier.Minor => credential.Jackpots.Minor,
				JackpotTier.Mini => credential.Jackpots.Mini,
				_ => 0,
			};

			double threshold = tier switch
			{
				JackpotTier.Grand => credential.Thresholds.Grand,
				JackpotTier.Major => credential.Thresholds.Major,
				JackpotTier.Minor => credential.Thresholds.Minor,
				JackpotTier.Mini => credential.Thresholds.Mini,
				_ => 0,
			};

			double minutesToThreshold = CalculateMinutesToValue(threshold, current, credential.DPD.Average);
			var prediction = new JackpotPrediction(
				credential.House,
				credential.Game,
				tier.ToString().ToUpper(),
				current,
				threshold,
				(int)tier,
				DateTime.UtcNow.AddMinutes(minutesToThreshold)
			);

			predictions.Add(prediction);
		}

		return predictions;
	}

	/// <summary>
	/// Projects future jackpot values
	/// </summary>
	public List<JackpotPrediction> ProjectPredictions(JackpotPrediction basePrediction, double dpd, DateTime dateLimit)
	{
		var projections = new List<JackpotPrediction>();
		double capacity = basePrediction.Tier.Capacity();

		if (capacity <= 0 || dpd <= 0)
			return projections;

		double daysToCapacity = capacity / dpd;
		if (daysToCapacity > MaxDaysToAdd)
			daysToCapacity = MaxDaysToAdd;

		int maxIterations = (int)((dateLimit - basePrediction.EstimatedDate).TotalDays / daysToCapacity) + 1;
		maxIterations = Math.Min(maxIterations, 100);

		for (int i = 0; i < maxIterations; i++)
		{
			DateTime projectedDate = i == 0 ? DateTime.UtcNow.AddDays(daysToCapacity) : basePrediction.EstimatedDate.AddDays(daysToCapacity * i);

			if (projectedDate >= dateLimit)
				break;

			var projection = new JackpotPrediction(
				basePrediction.House,
				basePrediction.Game,
				basePrediction.Category,
				basePrediction.Current,
				basePrediction.Threshold + (capacity * (i + 1)),
				basePrediction.Priority,
				projectedDate
			);

			projections.Add(projection);
		}

		return projections;
	}
}
