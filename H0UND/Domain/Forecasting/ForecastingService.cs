using System;
using System.Collections.Generic;
using P4NTH30N.C0MMON;

namespace P4NTH30N.H0UND.Domain.Forecasting;

public static class ForecastingService
{
	public static double CalculateMinutesToValue(double threshold, double currentValue, double dpd)
	{
		double remaining = threshold - currentValue;
		if (remaining <= 0)
			return 0;

		if (double.IsNaN(dpd) || double.IsInfinity(dpd) || dpd <= 1e-9)
			return GetSafeMaxMinutes();

		double dollarsPerMinute = dpd / 1440.0;
		double minutes = remaining / dollarsPerMinute;

		if (double.IsNaN(minutes) || double.IsInfinity(minutes) || minutes < 0)
			return GetSafeMaxMinutes();

		// Cap to a safe maximum that won't overflow DateTime
		double safeMax = GetSafeMaxMinutes();
		if (minutes > safeMax)
			return safeMax;

		return minutes;
	}

	/// <summary>
	/// Returns the maximum safe number of minutes that can be added to DateTime.UtcNow
	/// without causing an overflow (keeps the result well under DateTime.MaxValue).
	/// </summary>
	private static double GetSafeMaxMinutes()
	{
		// Calculate max minutes that won't overflow DateTime
		// Leave a buffer of 10 years to be safe
		TimeSpan maxSpan = DateTime.MaxValue - DateTime.UtcNow - TimeSpan.FromDays(365 * 10);
		return maxSpan.TotalMinutes;
	}

	public static void GeneratePredictions(Credential cred, IUnitOfWork uow, DateTime dateLimit)
	{
		(string Category, double Threshold, double Current, int Priority, bool Enabled)[] tiers =
		[
			("Grand", cred.Thresholds.Grand, cred.Jackpots.Grand, 4, cred.Settings?.SpinGrand ?? true),
			("Major", cred.Thresholds.Major, cred.Jackpots.Major, 3, cred.Settings?.SpinMajor ?? true),
			("Minor", cred.Thresholds.Minor, cred.Jackpots.Minor, 2, cred.Settings?.SpinMinor ?? true),
			("Mini", cred.Thresholds.Mini, cred.Jackpots.Mini, 1, cred.Settings?.SpinMini ?? true),
		];

		foreach ((string cat, double threshold, double current, int pri, bool enabled) in tiers)
		{
			if (!enabled)
				continue;

			Jackpot? existing = uow.Jackpots.Get(cat, cred.House, cred.Game);
			double dpd = existing?.DPD.Average ?? 0;
			double minutes = CalculateMinutesToValue(threshold, current, dpd);
			Jackpot jackpot = new Jackpot(cred, cat, current, threshold, pri, DateTime.UtcNow.AddMinutes(minutes));

			if (existing != null)
			{
				jackpot._id = existing._id;
				jackpot.DPD = existing.DPD;
			}

			uow.Jackpots.Upsert(jackpot);
		}
	}
}
