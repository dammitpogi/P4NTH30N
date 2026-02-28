using System;
using System.Collections.Generic;
using System.Linq;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using P4NTHE0N.H0UND.Domain.Signals;
using P4NTHE0N.Services;

namespace P4NTHE0N.H0UND.Application.Analytics;

public sealed class AnalyticsWorker
{
	private readonly IdempotentSignalGenerator? _idempotentGenerator;

	public AnalyticsWorker() { }

	public AnalyticsWorker(IdempotentSignalGenerator idempotentGenerator)
	{
		_idempotentGenerator = idempotentGenerator;
	}

	public void RunAnalytics(IUnitOfWork uow)
	{
		try
		{
			DateTime dateLimit = DateTime.MaxValue;

			List<Credential> credentials = uow.Credentials.GetAll();
			List<Signal> signals = uow.Signals.GetAll();
			List<Jackpot> jackpots = uow.Jackpots.GetAll();

			List<Credential> activeCredentials = credentials.Where(c => !c.Banned).ToList();
			RefreshCashedOutStatus(uow, activeCredentials, signals);

			List<IGrouping<(string House, string Game), Credential>> groups = activeCredentials.GroupBy(c => (c.House, c.Game)).ToList();
			ProcessPredictionPhase(uow, dateLimit, groups);

			List<Jackpot> upcomingJackpots = GetUpcomingJackpots(jackpots, groups, dateLimit);
			List<Signal> qualifiedSignals =
				_idempotentGenerator != null
					? _idempotentGenerator.GenerateSignals(uow, groups, upcomingJackpots, signals)
					: SignalService.GenerateSignals(uow, groups, upcomingJackpots, signals);
			// DECISION_071: Only clean up stale signals when we have qualified signals
			// Prevents wiping all signals when generation fails or returns empty
		if (qualifiedSignals.Count > 0)
		{
			SignalService.CleanupStaleSignals(uow, signals, qualifiedSignals);
		}
		}
		catch (Exception ex)
		{
			Dashboard.AddAnalyticsLog($"Analytics error: {ex.Message}", "red");
		}
	}

	private static void RefreshCashedOutStatus(IUnitOfWork uow, List<Credential> credentials, List<Signal> signals)
	{
		foreach (Credential cred in credentials)
		{
			bool hasSignals = signals.Any(s => s.House == cred.House && s.Game == cred.Game && s.Username == cred.Username);
			if ((cred.Balance < 3 && !hasSignals && !cred.CashedOut) || (cred.Balance < 0.2 && !cred.CashedOut))
			{
				cred.CashedOut = true;
				uow.Credentials.Upsert(cred);
			}
			else if (cred.Balance > 3 && cred.CashedOut)
			{
				cred.CashedOut = false;
				uow.Credentials.Upsert(cred);
			}
		}
	}

	private static void ProcessPredictionPhase(IUnitOfWork uow, DateTime dateLimit, List<IGrouping<(string House, string Game), Credential>> groups)
	{
		foreach (IGrouping<(string House, string Game), Credential> group in groups)
		{
			Credential? representative = group.Where(c => c.Enabled).OrderByDescending(c => c.LastUpdated).FirstOrDefault();
			if (representative == null)
			{
				continue;
			}

			if (!representative.Unlocked && DateTime.UtcNow > representative.UnlockTimeout)
			{
				uow.Credentials.Unlock(representative);
			}

			if (!ValidateJackpots(representative))
			{
				Credential? fallback = group.Where(c => c.Enabled && c != representative).OrderByDescending(c => c.LastUpdated).FirstOrDefault();
				if (fallback == null || !ValidateJackpots(fallback))
				{
					Dashboard.AddAnalyticsLog($"Skipping {representative.House}/{representative.Game}: no valid jackpot data in group", "yellow");
					continue;
				}
				representative = fallback;
			}

			List<Jackpot> existingJackpots = uow.Jackpots.GetAll().Where(j => j.House == representative.House && j.Game == representative.Game).ToList();
			foreach (Jackpot jackpot in existingJackpots)
			{
				DpdCalculator.UpdateDPD(jackpot, representative);
				// DECISION_069: Persist DPD changes — without this, DPD.Data never accumulates
				uow.Jackpots.Upsert(jackpot);
			}

			ForecastingService.GeneratePredictions(representative, uow, dateLimit);

			foreach (Credential cred in group)
			{
				cred.Jackpots = new Jackpots(representative.Jackpots);
				uow.Credentials.Upsert(cred);
			}
		}
	}

	private static bool ValidateJackpots(Credential cred)
	{
		return IsFiniteNonNegative(cred.Jackpots.Grand)
			&& IsFiniteNonNegative(cred.Jackpots.Major)
			&& IsFiniteNonNegative(cred.Jackpots.Minor)
			&& IsFiniteNonNegative(cred.Jackpots.Mini);
	}

	private static bool IsFiniteNonNegative(double value)
	{
		return value >= 0 && !double.IsNaN(value) && !double.IsInfinity(value);
	}

	private static List<Jackpot> GetUpcomingJackpots(List<Jackpot> jackpots, List<IGrouping<(string House, string Game), Credential>> groups, DateTime dateLimit)
	{
		HashSet<(string House, string Game)> gameKeys = groups.Select(g => (House: g.Key.House, Game: g.Key.Game)).ToHashSet();
		Dictionary<(string House, string Game), Credential> representatives = groups.ToDictionary(g => g.Key, g => g.OrderByDescending(c => c.LastUpdated).First());

		return jackpots
			.Where(j => j.EstimatedDate < dateLimit && gameKeys.Contains((j.House, j.Game)))
			.Where(j => representatives.TryGetValue((j.House, j.Game), out Credential? rep) && IsTierEnabled(rep, j.Category))
			.ToList();
	}

	private static bool IsTierEnabled(Credential rep, string category)
	{
		return category.ToUpperInvariant() switch
		{
			"GRAND" => rep.Settings?.SpinGrand ?? true,
			"MAJOR" => rep.Settings?.SpinMajor ?? true,
			"MINOR" => rep.Settings?.SpinMinor ?? true,
			"MINI" => rep.Settings?.SpinMini ?? true,
			_ => true,
		};
	}



	private static double GetDPD(List<Jackpot> jackpots, string house, string game)
	{
		return jackpots.FirstOrDefault(j => j.House == house && j.Game == game)?.DPD.Average ?? 0;
	}

	private static bool IsHiddenGame(List<Credential> creds, string house, string game)
	{
		return creds.FirstOrDefault(c => c.House == house && c.Game == game)?.Settings?.Hidden ?? false;
	}
}
