using System;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.H0UND.Domain.Forecasting;

public static class DpdCalculator
{
	public static void UpdateDPD(Jackpot jackpot, Credential cred)
	{
		if (jackpot.DPD.Data.Count == 0)
		{
			AppendDpdDataPoint(jackpot, cred);
			return;
		}

		// Use the correct tier value based on the jackpot's category, not always Grand
		double currentValue = GetTierValue(jackpot.Category, cred);
		double prevValue = GetPrevTierValue(jackpot.Category, jackpot.DPD.Data[^1]);

		if (currentValue != prevValue && currentValue < 100000)
		{
			if (currentValue > prevValue)
			{
				AppendDpdDataPoint(jackpot, cred);
				UpdateDpdAverage(jackpot);
			}
			else
			{
				ResetDpdAfterJackpotReset(jackpot, cred);
			}
		}
	}

	private static double GetTierValue(string category, Credential cred) => category switch
	{
		"Grand" => cred.Jackpots.Grand,
		"Major" => cred.Jackpots.Major,
		"Minor" => cred.Jackpots.Minor,
		"Mini" => cred.Jackpots.Mini,
		_ => cred.Jackpots.Grand,
	};

	private static double GetPrevTierValue(string category, DPD_Data data) => category switch
	{
		"Grand" => data.Grand,
		"Major" => data.Major,
		"Minor" => data.Minor,
		"Mini" => data.Mini,
		_ => data.Grand,
	};

	public static void AppendDpdDataPoint(Jackpot jackpot, Credential cred)
	{
		jackpot.DPD.Data.Add(new DPD_Data(cred.Jackpots.Grand, cred.Jackpots.Major, cred.Jackpots.Minor, cred.Jackpots.Mini));
	}

	public static void UpdateDpdAverage(Jackpot jackpot)
	{
		if (jackpot.DPD.Data.Count <= 1)
		{
			return;
		}

		double minutes = (jackpot.DPD.Data[^1].Timestamp - jackpot.DPD.Data[0].Timestamp).TotalMinutes;
		double dollars = GetPrevTierValue(jackpot.Category, jackpot.DPD.Data[^1])
			- GetPrevTierValue(jackpot.Category, jackpot.DPD.Data[0]);
		double days = minutes / TimeSpan.FromDays(1).TotalMinutes;
		double dpd = dollars / days;

		if (!double.IsNaN(dpd) && !double.IsInfinity(dpd) && dpd >= 0)
		{
			jackpot.DPD.Average = dpd;
		}
	}

	public static void ResetDpdAfterJackpotReset(Jackpot jackpot, Credential cred)
	{
		jackpot.DPD.Average = 0;
		jackpot.DPD.Data.Clear();
		AppendDpdDataPoint(jackpot, cred);
	}
}
