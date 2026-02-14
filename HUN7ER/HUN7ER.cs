using System.Linq;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.HUN7ER.Domain.Services;

namespace P4NTH30N.HUN7ER;

class Program
{
	private const int LoopDelayMs = 10000;

	#region Loop
	static void Main()
	{
		RunHunterLoop();
	}

	private static void RunHunterLoop()
	{
		IMongoUnitOfWork uow = new MongoUnitOfWork();
		PredictionService predictionService = new PredictionService();

		while (true)
		{
			try
			{
				RunIteration(uow, predictionService);

				Thread.Sleep(LoopDelayMs);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[{ex.StackTrace?.GetHashCode()}] Error: {ex.Message}");
				Thread.Sleep(LoopDelayMs);
			}
		}
	}
	#endregion

	#region Iteration Phases
	private static void RunIteration(IMongoUnitOfWork uow, PredictionService predictionService)
	{
		DateTime dateLimit = DateTime.UtcNow.AddDays(5);

		ProcessPollingPhase(uow);

		List<Credential> credentials = GetActiveCredentials(uow);
		List<Signal> signals = uow.Signals.GetAll();
		RefreshCashedOutStatus(uow, credentials, signals);

		List<IGrouping<(string House, string Game), Credential>> groups = GroupCredentials(credentials);
		ProcessPredictionPhase(uow, predictionService, dateLimit, groups);

		List<Jackpot> upcomingJackpots = GetUpcomingJackpots(uow, groups, dateLimit);
		List<Signal> qualifiedSignals = GenerateSignals(uow, groups, upcomingJackpots, signals);
		CleanupStaleSignals(uow, signals, qualifiedSignals);

		PrintSummary(credentials, upcomingJackpots);
	}

	private static void ProcessPollingPhase(IMongoUnitOfWork uow)
	{
		Credential? mongoCred = uow.Credentials.GetNext(true);
		if (mongoCred == null)
		{
			return;
		}

		uow.Credentials.Lock(mongoCred);
		try
		{
			(double Balance, double Grand, double Major, double Minor, double Mini) balances = QueryBalancesWithRetry(mongoCred);
			if (!ValidateBalances(balances))
			{
				Console.WriteLine($"🔴 Invalid values for {mongoCred.Game} - {mongoCred.Username}");
				return;
			}

			ProcessCredentialUpdate(uow, mongoCred, balances);
		}
		finally
		{
			uow.Credentials.Unlock(mongoCred);
		}
	}

	private static List<Credential> GetActiveCredentials(IMongoUnitOfWork uow)
	{
		return uow.Credentials.GetAll().Where(c => !c.Banned).ToList();
	}

	private static void RefreshCashedOutStatus(IMongoUnitOfWork uow, List<Credential> credentials, List<Signal> signals)
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

	private static List<IGrouping<(string House, string Game), Credential>> GroupCredentials(List<Credential> credentials)
	{
		return credentials.GroupBy(c => (c.House, c.Game)).ToList();
	}

	private static void ProcessPredictionPhase(
		IMongoUnitOfWork uow,
		PredictionService predictionService,
		DateTime dateLimit,
		List<IGrouping<(string House, string Game), Credential>> groups
	)
	{
		foreach (IGrouping<(string House, string Game), Credential> group in groups)
		{
			Credential representative = group.OrderByDescending(c => c.LastUpdated).First();
			if (!representative.Enabled)
			{
				continue;
			}

			if (!representative.Unlocked && DateTime.UtcNow > representative.UnlockTimeout)
			{
				uow.Credentials.Unlock(representative);
			}

			if (!ValidateJackpots(representative))
			{
				continue;
			}

			UpdateDPD(representative);
			if (representative.DPD.Average > 0.1)
			{
				GeneratePredictions(representative, uow, predictionService, dateLimit);
			}

			foreach (Credential cred in group)
			{
				cred.Jackpots = representative.Jackpots;
				cred.DPD = representative.DPD;
				uow.Credentials.Upsert(cred);
			}
		}
	}

	private static List<Jackpot> GetUpcomingJackpots(IMongoUnitOfWork uow, List<IGrouping<(string House, string Game), Credential>> groups, DateTime dateLimit)
	{
		HashSet<(string House, string Game)> gameKeys = groups.Select(g => (House: g.Key.House, Game: g.Key.Game)).ToHashSet();
		return uow.Jackpots.GetAll().Where(j => j.EstimatedDate < dateLimit && gameKeys.Contains((j.House, j.Game))).ToList();
	}

	private static void CleanupStaleSignals(IMongoUnitOfWork uow, List<Signal> signals, List<Signal> qualifiedSignals)
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
	#endregion

	#region Query And Validation
	private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalancesWithRetry(Credential cred)
	{
		int attempts = 0;
		while (true)
		{
			try
			{
				return QueryBalances(cred);
			}
			catch
			{
				attempts++;
				if (attempts >= 3)
					throw;
				Thread.Sleep(2000 * attempts);
			}
		}
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryBalances(Credential cred)
	{
		DelayBeforeQuery();

		return cred.Game switch
		{
			"FireKirin" => QueryFireKirin(cred),
			"OrionStars" => QueryOrionStars(cred),
			_ => throw new Exception($"Unknown game: {cred.Game}"),
		};
	}

	private static void DelayBeforeQuery()
	{
		Thread.Sleep(new Random().Next(3000, 5001));
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryFireKirin(Credential cred)
	{
		var b = FireKirin.QueryBalances(cred.Username, cred.Password);
		return ClampBalances((double)b.Balance, (double)b.Grand, (double)b.Major, (double)b.Minor, (double)b.Mini);
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) QueryOrionStars(Credential cred)
	{
		var b = OrionStars.QueryBalances(cred.Username, cred.Password);
		return ClampBalances((double)b.Balance, (double)b.Grand, (double)b.Major, (double)b.Minor, (double)b.Mini);
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) ClampBalances(double b, double g, double ma, double mi, double mx)
	{
		return (ClampNonNegativeFinite(b), ClampNonNegativeFinite(g), ClampNonNegativeFinite(ma), ClampNonNegativeFinite(mi), ClampNonNegativeFinite(mx));
	}

	private static double ClampNonNegativeFinite(double value)
	{
		return IsFiniteNonNegative(value) ? value : 0;
	}

	private static bool IsFiniteNonNegative(double value)
	{
		return value >= 0 && !double.IsNaN(value) && !double.IsInfinity(value);
	}

	private static bool ValidateBalances((double Balance, double Grand, double Major, double Minor, double Mini) b)
	{
		return IsFiniteNonNegative(b.Grand)
			&& IsFiniteNonNegative(b.Major)
			&& IsFiniteNonNegative(b.Minor)
			&& IsFiniteNonNegative(b.Mini)
			&& IsFiniteNonNegative(b.Balance);
	}

	private static bool ValidateJackpots(Credential cred)
	{
		return IsFiniteNonNegative(cred.Jackpots.Grand)
			&& IsFiniteNonNegative(cred.Jackpots.Major)
			&& IsFiniteNonNegative(cred.Jackpots.Minor)
			&& IsFiniteNonNegative(cred.Jackpots.Mini);
	}
	#endregion

	#region Credential And Dpd Updates
	private static void ProcessCredentialUpdate(IMongoUnitOfWork uow, Credential cred, (double Balance, double Grand, double Major, double Minor, double Mini) b)
	{
		double prevGrand = cred.Jackpots.Grand;

		HandleGrandPop(cred, b.Grand, prevGrand);
		ApplyJackpotValues(cred, b);

		cred.Balance = b.Balance;
		cred.LastUpdated = DateTime.UtcNow;

		uow.Credentials.Upsert(cred);

		Console.WriteLine($"{cred.Game} - {cred.House} - {cred.Username} - ${b.Balance:F2} - [{b.Grand:F0}/{b.Major:F0}/{b.Minor:F0}/{b.Mini:F0}]");
	}

	private static void HandleGrandPop(Credential cred, double grandCurrent, double grandPrevious)
	{
		if (grandCurrent >= grandPrevious || grandPrevious - grandCurrent <= 0.1)
		{
			return;
		}

		if (cred.DPD.Toggles.GrandPopped)
		{
			cred.DPD.Toggles.GrandPopped = false;
			cred.Thresholds.NewGrand(grandPrevious);
			Console.WriteLine($"🎰 Grand Popped! New threshold: {cred.Thresholds.Grand}");
		}
		else
		{
			cred.DPD.Toggles.GrandPopped = true;
		}
	}

	private static void ApplyJackpotValues(Credential cred, (double Balance, double Grand, double Major, double Minor, double Mini) b)
	{
		cred.Jackpots.Grand = ClampTierValue(b.Grand);
		cred.Jackpots.Major = ClampTierValue(b.Major);
		cred.Jackpots.Minor = ClampTierValue(b.Minor);
		cred.Jackpots.Mini = ClampTierValue(b.Mini);
	}

	private static double ClampTierValue(double value)
	{
		return value >= 0 && value <= 10000 ? value : 0;
	}

	private static void UpdateDPD(Credential cred)
	{
		if (cred.DPD.Data.Count == 0)
		{
			AppendDpdDataPoint(cred);
			return;
		}

		double prevGrand = cred.DPD.Data[^1].Grand;

		if (cred.Jackpots.Grand != prevGrand && cred.Jackpots.Grand < 100000)
		{
			if (cred.Jackpots.Grand > prevGrand)
			{
				AppendDpdDataPoint(cred);
				UpdateDpdAverage(cred);
			}
			else
			{
				ResetDpdAfterJackpotReset(cred);
			}
		}
	}

	private static void AppendDpdDataPoint(Credential cred)
	{
		cred.DPD.Data.Add(new DPD_Data(cred.Jackpots.Grand, cred.Jackpots.Major, cred.Jackpots.Minor, cred.Jackpots.Mini));
	}

	private static void UpdateDpdAverage(Credential cred)
	{
		if (cred.DPD.Data.Count <= 1)
		{
			return;
		}

		double minutes = (cred.DPD.Data[^1].Timestamp - cred.DPD.Data[0].Timestamp).TotalMinutes;
		double dollars = cred.DPD.Data[^1].Grand - cred.DPD.Data[0].Grand;
		double days = minutes / TimeSpan.FromDays(1).TotalMinutes;
		double dpd = dollars / days;

		if (!double.IsNaN(dpd) && !double.IsInfinity(dpd) && dpd >= 0)
		{
			cred.DPD.Average = dpd;
		}
	}

	private static void ResetDpdAfterJackpotReset(Credential cred)
	{
		cred.DPD.Average = 0;
		cred.DPD.Data.Clear();
		AppendDpdDataPoint(cred);
	}
	#endregion

	#region Predictions And Signals
	private static void GeneratePredictions(Credential cred, IMongoUnitOfWork uow, PredictionService svc, DateTime dateLimit)
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

			double minutes = svc.CalculateMinutesToValue(threshold, current, cred.DPD.Average);
			Jackpot jackpot = new Jackpot(cred, cat, current, threshold, pri, DateTime.UtcNow.AddMinutes(minutes));
			uow.Jackpots.Upsert(jackpot);
		}
	}

	private static List<Signal> GenerateSignals(
		IMongoUnitOfWork uow,
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

			Credential? rep = group.OrderByDescending(c => c.LastUpdated).FirstOrDefault();
			if (rep == null || rep.DPD.Average <= 0.01)
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
				Signal sig = BuildSignal(jackpot, cred);
				qualified.Add(sig);

				UpsertSignalIfHigherPriority(uow, existingSignals, sig, cred);
			}
		}

		return qualified;
	}

	private static Signal BuildSignal(Jackpot jackpot, Credential cred)
	{
		return new Signal(jackpot.Priority, cred) { Timeout = DateTime.UtcNow.AddSeconds(30), Acknowledged = true };
	}

	private static void UpsertSignalIfHigherPriority(IMongoUnitOfWork uow, List<Signal> existingSignals, Signal sig, Credential cred)
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
	#endregion

	#region Summary
	private static void PrintSummary(List<Credential> credentials, List<Jackpot> jackpots)
	{
		double totalBalance = credentials.Where(c => c.Enabled).Sum(c => c.Balance);

		// Filter visible predictions
		IEnumerable<Jackpot> visible = jackpots
			.Where(j => !IsHiddenGame(credentials, j.House, j.Game))
			.Where(j => j.Category != "Mini")
			.OrderByDescending(j => j.EstimatedDate)
			.Take(20);

		foreach (Jackpot j in visible)
		{
			int creds = credentials.Count(c => c.House == j.House && c.Game == j.Game);
			Console.WriteLine(
				$"{j.Category.ToUpper().PadRight(7)}| {j.EstimatedDate.ToLocalTime():ddd MM/dd HH:mm:ss} | {j.Game[..Math.Min(9, j.Game.Length)].PadRight(9)} | {GetDPD(credentials, j.House, j.Game):F2}/day |{j.Current, 7:F2}/{j.Threshold, 4:F0}| ({creds, 2}) {j.House}"
			);
		}

		DateTime oldest = credentials.Min(c => c.LastUpdated);
		TimeSpan queueAge = DateTime.UtcNow - oldest;

		Console.WriteLine(
			$"------|-{DateTime.Now:ddd-MM/dd HH:mm:ss}-|-${totalBalance, 9:F2}-/$-{jackpots.Count, 11}-|-------------|-({credentials.Count})-HUN7ER:{queueAge.Hours:D2}:{queueAge.Minutes:D2}:{queueAge.Seconds:D2}----------"
		);
	}

	private static double GetDPD(List<Credential> creds, string house, string game)
	{
		return creds.FirstOrDefault(c => c.House == house && c.Game == game)?.DPD.Average ?? 0;
	}

	private static bool IsHiddenGame(List<Credential> creds, string house, string game)
	{
		return creds.FirstOrDefault(c => c.House == house && c.Game == game)?.Settings?.Hidden ?? false;
	}
	#endregion
}
