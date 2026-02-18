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
			return TimeSpan.FromDays(365 * 100).TotalMinutes;

		double dollarsPerMinute = dpd / 1440.0;
		double minutes = remaining / dollarsPerMinute;

		if (double.IsNaN(minutes) || double.IsInfinity(minutes) || minutes < 0)
			return TimeSpan.FromDays(365 * 100).TotalMinutes;

		return minutes;
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
