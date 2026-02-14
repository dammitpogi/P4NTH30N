using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Domain.Entities;

/// <summary>
/// Domain entity representing a jackpot prediction
/// </summary>
public class JackpotPrediction
{
	public string Id { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Category { get; set; } = string.Empty;

	public double Current { get; set; }
	public double Threshold { get; set; }
	public int Priority { get; set; }
	public DateTime EstimatedDate { get; set; }
	public DateTime LastUpdated { get; set; }

	public JackpotPrediction() { }

	public JackpotPrediction(string house, string game, string category, double current, double threshold, int priority, DateTime estimatedDate)
	{
		House = house;
		Game = game;
		Category = category;
		Current = current;
		Threshold = threshold;
		Priority = priority;
		EstimatedDate = estimatedDate;
		LastUpdated = DateTime.UtcNow;
	}

	public JackpotTier Tier => JackpotTierExtensions.FromString(Category);

	/// <summary>
	/// Calculates dollars per minute rate
	/// </summary>
	public double DPM { get; private set; }

	/// <summary>
	/// Updates the prediction based on time elapsed
	/// </summary>
	public void Update(double dpm)
	{
		DPM = dpm;
		double minutesElapsed = DateTime.UtcNow.Subtract(LastUpdated).TotalMinutes;
		Current += minutesElapsed * dpm;

		double remaining = Threshold - Current;
		if (remaining <= 0 || dpm <= 0)
		{
			EstimatedDate = DateTime.UtcNow;
		}
		else
		{
			EstimatedDate = DateTime.UtcNow.AddMinutes(remaining / dpm);
		}

		LastUpdated = DateTime.UtcNow;
	}

	/// <summary>
	/// Checks if the jackpot is due
	/// </summary>
	public bool IsDue(DateTime now, double minBalance = 0, double avgBalance = 0)
	{
		bool thresholdMet = Threshold - Current < 0.1;

		return Priority switch
		{
			>= 2 when now.AddHours(6) > EstimatedDate && thresholdMet && avgBalance >= 6 => true,
			>= 2 when now.AddHours(4) > EstimatedDate && thresholdMet && avgBalance >= 4 => true,
			>= 2 when now.AddHours(2) > EstimatedDate => true,
			1 when now.AddHours(1) > EstimatedDate => true,
			_ => false,
		};
	}
}
