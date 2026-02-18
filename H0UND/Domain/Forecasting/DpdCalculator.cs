using System;
using System.Collections.Generic;
using System.Linq;
using P4NTH30N.C0MMON;

namespace P4NTH30N.H0UND.Domain.Forecasting;

public static class DpdCalculator
{
	public static void UpdateDPD(Jackpot jackpot, Credential cred)
	{
		if (jackpot.DPD.Data.Count == 0)
		{
			AppendDpdDataPoint(jackpot, cred);
			return;
		}

		double prevGrand = jackpot.DPD.Data[^1].Grand;

		if (cred.Jackpots.Grand != prevGrand && cred.Jackpots.Grand < 100000)
		{
			if (cred.Jackpots.Grand > prevGrand)
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
		double dollars = jackpot.DPD.Data[^1].Grand - jackpot.DPD.Data[0].Grand;
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
