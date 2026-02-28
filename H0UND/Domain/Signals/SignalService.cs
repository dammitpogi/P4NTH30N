using System;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.H0UND.Domain.Signals;

public static class SignalService
{
	public static List<Signal> GenerateSignals(
		IUnitOfWork uow,
		List<IGrouping<(string House, string Game), Credential>> groups,
		List<Jackpot> jackpots,
		List<Signal> existingSignals
	)
	{
		List<Signal> qualified = new List<Signal>();

		foreach (Jackpot jackpot in jackpots)
		{
			IGrouping<(string House, string Game), Credential>? group = groups.FirstOrDefault(g => g.Key.House == jackpot.House && g.Key.Game == jackpot.Game);
			if (group == null)
				continue;

			Credential? rep = group.Where(c => c.Enabled).OrderByDescending(c => c.LastUpdated).FirstOrDefault();
			if (rep == null)
				continue;

			bool thresholdMet = jackpot.Threshold - jackpot.Current < 0.1;
			List<Credential> gameCreds = group.Where(c => c.Enabled && !c.Banned && !c.CashedOut).ToList();
			double avgBalance = gameCreds.Count > 0 ? gameCreds.Average(c => c.Balance) : 0;

			bool isDue = jackpot.Priority switch
			{
				>= 2 when DateTime.UtcNow.AddHours(6) > jackpot.EstimatedDate && thresholdMet && avgBalance >= 6 => true,
				>= 2 when DateTime.UtcNow.AddHours(4) > jackpot.EstimatedDate && thresholdMet && avgBalance >= 4 => true,
				>= 2 when DateTime.UtcNow.AddHours(2) > jackpot.EstimatedDate => true,
				1 when DateTime.UtcNow.AddHours(1) > jackpot.EstimatedDate => true,
				_ => false,
			};

			if (!isDue)
				continue;

			foreach (Credential cred in gameCreds)
			{
				Signal sig = new Signal(jackpot.Priority, cred) { Timeout = DateTime.UtcNow.AddMinutes(10), Acknowledged = false };
				qualified.Add(sig);
				UpsertSignalIfHigherPriority(uow, existingSignals, sig, cred);
			}
		}

		return qualified;
	}

	public static void UpsertSignalIfHigherPriority(IUnitOfWork uow, List<Signal> existingSignals, Signal sig, Credential cred)
	{
		Signal? existing = existingSignals.FirstOrDefault(s => s.House == cred.House && s.Game == cred.Game && s.Username == cred.Username);
		if (existing == null)
		{
			uow.Signals.Upsert(sig);
			return;
		}

		if (sig.Priority > existing.Priority)
		{
			sig.Acknowledged = existing.Acknowledged;
			uow.Signals.Upsert(sig);
		}
	}

	public static void CleanupStaleSignals(IUnitOfWork uow, List<Signal> signals, List<Signal> qualifiedSignals)
	{
		foreach (Signal sig in signals)
		{
			bool hasQualified = qualifiedSignals.Any(q => q.House == sig.House && q.Game == sig.Game && q.Username == sig.Username);
			if (!hasQualified)
			{
				uow.Signals.Delete(sig);
			}
		}
	}
}
