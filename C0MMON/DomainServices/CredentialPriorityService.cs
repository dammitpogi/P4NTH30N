using System;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.DomainServices;

/// <summary>
/// Domain service for calculating credential priority based on jackpot estimations and DPD.
/// Extracted from repository to be shared between MongoDB and EF implementations.
/// </summary>
public class CredentialPriorityService
{
	/// <summary>
	/// Calculates priority for a credential based on jackpot estimations and funding status.
	/// </summary>
	public static (int priority, DateTime processBy, bool isOverdue) CalculatePriority(Credential credential, List<Jackpot> estimations, Jackpot? mini, DateTime now)
	{
		DateTime created = credential.CreateDate;
		DateTime updated = credential.LastUpdated > DateTime.MinValue ? credential.LastUpdated : created;
		bool funded = !credential.CashedOut;

		bool leastWeekOld = created < now.AddDays(-7);
		Jackpot? latestEstimation = estimations.FirstOrDefault();

		bool jackpotWeek = latestEstimation == null || latestEstimation.EstimatedDate > now.AddDays(7);
		bool jackpotDay = latestEstimation == null || latestEstimation.EstimatedDate > now.AddDays(1);
		bool jackpot12H = latestEstimation == null || latestEstimation.EstimatedDate > now.AddHours(12);
		bool jackpot3H = latestEstimation == null || latestEstimation.EstimatedDate > now.AddHours(3);

		double miniDiff = mini != null ? mini.Threshold - mini.Current : 0;
		double jackpotDiff = latestEstimation != null ? latestEstimation.Threshold - latestEstimation.Current : 0;

		int priority = 7;
		if (jackpotDiff != 0)
		{
			if (jackpotDiff <= 0.12 || (miniDiff <= 0.07 && funded))
			{
				priority = 1;
			}
			else if (jackpot3H || jackpotDiff <= 0.3 || (miniDiff <= 0.15 && funded))
			{
				priority = 2;
			}
			else if (jackpot12H)
			{
				priority = 3;
			}
			else if (!leastWeekOld && latestEstimation == null)
			{
				priority = 4;
			}
			else if (jackpotDay)
			{
				priority = 5;
			}
			else if (jackpotWeek)
			{
				priority = 6;
			}
		}

		DateTime by = priority switch
		{
			1 => updated.AddMinutes(4),
			2 => updated.AddMinutes(8),
			3 => updated.AddMinutes(16),
			4 => updated.AddHours(1),
			5 => updated.AddHours(3),
			6 => updated.AddHours(6),
			_ => updated.AddDays(1),
		};

		bool overdue = now > by;
		return (priority, by, overdue);
	}

	/// <summary>
	/// Sorts credentials by priority, overdue status, and last updated time.
	/// </summary>
	public static List<Credential> SortByPriority(List<(Credential credential, int priority, DateTime by, bool overdue)> prioritized)
	{
		return prioritized.OrderBy(p => p.priority).ThenByDescending(p => p.overdue).ThenBy(p => p.credential.LastUpdated).Select(p => p.credential).ToList();
	}
}
