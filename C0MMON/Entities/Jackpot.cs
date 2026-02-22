using System;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON;

public class Jackpot
{
	// DECISION_085: Default estimate horizon in minutes (7 days)
	private const double DefaultEstimateMinutes = 10080;

	public ObjectId _id { get; set; }
	public DPD DPD { get; set; } = new DPD();

	public double GrandDPM { get; set; }
	public double MajorDPM { get; set; }
	public double MinorDPM { get; set; }
	public double MiniDPM { get; set; }
	public DateTime LastUpdated { get; set; }
	public DateTime EstimatedDate { get; set; }
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Category { get; set; } = string.Empty;
	public double Current { get; set; }
	public double Threshold { get; set; }
	public int Priority { get; set; }

	public Jackpot() { }

	/// <summary>
	/// Validates jackpot values - logs error to ERR0R if invalid and errorLogger provided.
	/// </summary>
	public bool IsValid(IStoreErrors? errorLogger = null)
	{
		if (double.IsNaN(Current) || double.IsInfinity(Current))
		{
			Console.WriteLine($"🔴 Jackpot validation failed: {Game} {Category} has invalid value {Current}");
			errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError, $"Jackpot:{Game}/{Category}", $"Invalid jackpot value: {Current}", ErrorSeverity.High));
			return false;
		}
		if (Current < 0)
		{
			Console.WriteLine($"🔴 Jackpot validation failed: {Game} {Category} has negative value {Current}");
			errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError, $"Jackpot:{Game}/{Category}", $"Negative jackpot value: {Current}", ErrorSeverity.High));
			return false;
		}
		return true;
	}

	// Legacy DPM property for backwards compatibility
	public double DPM
	{
		get =>
			Category switch
			{
				"Grand" => GrandDPM,
				"Major" => MajorDPM,
				"Minor" => MinorDPM,
				"Mini" => MiniDPM,
				_ => GrandDPM,
			};
		set
		{
			switch (Category)
			{
				case "Grand":
					GrandDPM = value;
					break;
				case "Major":
					MajorDPM = value;
					break;
				case "Minor":
					MinorDPM = value;
					break;
				case "Mini":
					MiniDPM = value;
					break;
			}
		}
	}

	// Helper to get tier name from priority
	private static string GetCategoryFromPriority(int priority) =>
		priority switch
		{
			4 => "Grand",
			3 => "Major",
			2 => "Minor",
			1 => "Mini",
			_ => "Unknown",
		};

	// Helper to get DPD value for a tier
	private static double GetDPDValue(List<DPD_Data> data, string tier)
	{
		if (data.Count < 2)
			return 0;
		return tier switch
		{
			"Grand" => data[^1].Grand - data[0].Grand,
			"Major" => data[^1].Major - data[0].Major,
			"Minor" => data[^1].Minor - data[0].Minor,
			"Mini" => data[^1].Mini - data[0].Mini,
			_ => 0,
		};
	}

	// Calculate DPM for a specific tier using DPD data
	private static double CalculateTierDPM(List<DPD_Data> dataZoom, string tier, double fallbackDPM)
	{
		if (dataZoom.Count < 2)
			return fallbackDPM;

		double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
		if (minutes <= 0)
			return fallbackDPM;

		double dollars = GetDPDValue(dataZoom, tier);
		if (dollars <= 0)
			return fallbackDPM;

		return dollars / minutes;
	}

	public Jackpot(Credential credential, string category, double current, double threshold, int priority, DateTime eta)
	{
		Category = category;
		House = credential.House;
		Game = credential.Game;
		Priority = priority;
		Current = current;
		Threshold = threshold;
		_id = ObjectId.GenerateNewId();
		LastUpdated = DateTime.UtcNow;
		EstimatedDate = eta;

		DPD.Data.Add(new DPD_Data(credential.Jackpots.Grand, credential.Jackpots.Major, credential.Jackpots.Minor, credential.Jackpots.Mini));
		double fallbackDPM = DPD.Average > 0 ? DPD.Average / TimeSpan.FromDays(1).TotalMinutes : 0;

		// Initialize tier DPMs
		GrandDPM = fallbackDPM;
		MajorDPM = fallbackDPM;
		MinorDPM = fallbackDPM;
		MiniDPM = fallbackDPM;

		// Get tier-specific DPD data for last 24 hours
		List<DPD_Data> dataZoom24h = DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-1)).OrderBy(x => x.Timestamp).ToList();

		// Get tier-specific DPD data for last 8 hours
		List<DPD_Data> dataZoom8h = DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddHours(-8)).OrderBy(x => x.Timestamp).ToList();

		// Calculate per-tier DPM
		if (dataZoom24h.Count >= 2 && eta < DateTime.UtcNow.AddDays(3))
		{
			GrandDPM = CalculateTierDPM(dataZoom24h, "Grand", fallbackDPM);
			MajorDPM = CalculateTierDPM(dataZoom24h, "Major", fallbackDPM);
			MinorDPM = CalculateTierDPM(dataZoom24h, "Minor", fallbackDPM);
			MiniDPM = CalculateTierDPM(dataZoom24h, "Mini", fallbackDPM);
		}

		// Recalculate with 8-hour data if more recent and within time window
		if (dataZoom8h.Count >= 2 && eta < DateTime.UtcNow.AddHours(4))
		{
			GrandDPM = CalculateTierDPM(dataZoom8h, "Grand", GrandDPM);
			MajorDPM = CalculateTierDPM(dataZoom8h, "Major", MajorDPM);
			MinorDPM = CalculateTierDPM(dataZoom8h, "Minor", MinorDPM);
			MiniDPM = CalculateTierDPM(dataZoom8h, "Mini", MiniDPM);
		}

		// Get the DPM for this specific category
		double tierDPM = Category switch
		{
			"Grand" => GrandDPM,
			"Major" => MajorDPM,
			"Minor" => MinorDPM,
			"Mini" => MiniDPM,
			_ => fallbackDPM,
		};

		// Calculate estimated growth using tier-specific DPM
		double estimatedGrowth = DateTime.UtcNow.Subtract(credential.LastUpdated).TotalMinutes * tierDPM;
		double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / tierDPM, 0);

		// DECISION_085: Ensure non-negative and valid minutes
		if (double.IsNaN(MinutesToJackpot) || double.IsInfinity(MinutesToJackpot) || MinutesToJackpot < 0)
		{
			MinutesToJackpot = DefaultEstimateMinutes;
		}

		// Protect against DateTime overflow: cap minutes to safe maximum
		MinutesToJackpot = CapMinutesToSafeRange(MinutesToJackpot);
		EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);

		// DECISION_085: Final guard - never allow past dates (graceful degradation layer)
		if (EstimatedDate < DateTime.UtcNow)
		{
			EstimatedDate = DateTime.UtcNow.AddMinutes(DefaultEstimateMinutes);
		}

		// Update Current with estimated growth
		Current = current + estimatedGrowth;
	}

	/// <summary>
	/// Caps minutes to a safe range that won't cause DateTime overflow.
	/// Leaves a 10-year buffer before DateTime.MaxValue.
	/// </summary>
	private static double CapMinutesToSafeRange(double minutes)
	{
		TimeSpan maxSafeSpan = DateTime.MaxValue - DateTime.UtcNow - TimeSpan.FromDays(365 * 10);
		double maxSafeMinutes = maxSafeSpan.TotalMinutes;

		if (double.IsNaN(minutes) || double.IsInfinity(minutes) || minutes > maxSafeMinutes)
		{
			return maxSafeMinutes;
		}

		return minutes;
	}
}
