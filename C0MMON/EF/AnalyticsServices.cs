using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON.EF;

/// <summary>
/// High-level analytics services for H0UND workloads.
/// Provides DPD analysis, jackpot forecasting, and credential health reporting.
/// </summary>
public interface IAnalyticsService
{
	Task<DPDAnalysisResult> AnalyzeDPDAsync(string house, string game);
	Task<List<JackpotForecast>> ForecastJackpotsAsync(string house, string game);
	Task<CredentialHealthReport> GetCredentialHealthReportAsync();
	Task<HouseSummary> GetHouseSummaryAsync(string house);
}

/// <summary>
/// Result of DPD analysis for a set of credentials.
/// </summary>
public class DPDAnalysisResult
{
	public required string House { get; set; }
	public required string Game { get; set; }
	public int TotalCredentials { get; set; }
	public int ActiveCredentials { get; set; }
	public double AverageDPD { get; set; }
	public double TotalBalance { get; set; }
	public List<DPDCredentialData> Credentials { get; set; } = new();
}

public class DPDCredentialData
{
	public required string Username { get; set; }
	public double Balance { get; set; }

	public DateTime LastUpdated { get; set; }
	public bool IsHealthy { get; set; }
}

/// <summary>
/// Jackpot forecast data for scheduling predictions.
/// </summary>
public class JackpotForecast
{
	public required string House { get; set; }
	public required string Game { get; set; }
	public required string Category { get; set; }
	public double Current { get; set; }
	public double Threshold { get; set; }
	public double Progress { get; set; }
	public DateTime? EstimatedHit { get; set; }
	public int Priority { get; set; }
	public double DPM { get; set; }
	public double HoursRemaining { get; set; }
}

/// <summary>
/// Overall credential health report for monitoring.
/// </summary>
public class CredentialHealthReport
{
	public int TotalCredentials { get; set; }
	public int EnabledCredentials { get; set; }
	public int BannedCredentials { get; set; }
	public int StaleCredentials { get; set; }
	public double AverageBalance { get; set; }
	public double TotalBalance { get; set; }
	public int HouseCount { get; set; }
	public List<HouseHealth> HouseBreakdown { get; set; } = new();
}

public class HouseHealth
{
	public required string House { get; set; }
	public int CredentialCount { get; set; }
	public int EnabledCount { get; set; }
	public double AverageBalance { get; set; }
	public int GameCount { get; set; }
}

/// <summary>
/// Summary data for a specific house.
/// </summary>
public class HouseSummary
{
	public required string House { get; set; }
	public int TotalCredentials { get; set; }
	public int EnabledCredentials { get; set; }
	public double TotalBalance { get; set; }
	public int GameCount { get; set; }
	public List<string> Games { get; set; } = new();
	public int ActiveJackpots { get; set; }
	public DateTime LastUpdated { get; set; }
}

public class AnalyticsService(P4NTH30NDbContext context, ICredentialAnalyticsRepository credentialRepo, IJackpotAnalyticsRepository jackpotRepo) : IAnalyticsService
{
	private readonly P4NTH30NDbContext _context = context;

	public async Task<DPDAnalysisResult> AnalyzeDPDAsync(string house, string game)
	{
		var credentials = await credentialRepo.GetEnabledCredentialsAsync(house, game);
		var stats = await credentialRepo.GetBalanceStatsAsync(house, game);

		var credentialData = credentials
			.Select(c => new DPDCredentialData
			{
				Username = c.Username,
				Balance = c.Balance,

				LastUpdated = c.LastUpdated,
				IsHealthy = c.LastUpdated > DateTime.UtcNow.AddDays(-3),
			})
			.ToList();

		var jackpots = await jackpotRepo.GetJackpotsByHouseGameAsync(house, game);
		var avgDPD = jackpots.Any() ? jackpots.Average(j => j.DPD.Average) : 0;

		return new DPDAnalysisResult
		{
			House = house,
			Game = game,
			TotalCredentials = credentials.Count,
			ActiveCredentials = credentials.Count(c => c.Enabled && !c.Banned),
			AverageDPD = avgDPD,
			TotalBalance = stats.TotalBalance,
			Credentials = credentialData,
		};
	}

	public async Task<List<JackpotForecast>> ForecastJackpotsAsync(string house, string game)
	{
		var jackpots = await jackpotRepo.GetJackpotsByHouseGameAsync(house, game);
		var forecasts = new List<JackpotForecast>();

		foreach (var jackpot in jackpots)
		{
			var progress = jackpot.Threshold > 0 ? jackpot.Current / jackpot.Threshold * 100 : 0;
			var hoursRemaining = jackpot.DPM > 0 ? (jackpot.Threshold - jackpot.Current) / jackpot.DPM / 60 : 0;

			forecasts.Add(
				new JackpotForecast
				{
					House = jackpot.House,
					Game = jackpot.Game,
					Category = jackpot.Category,
					Current = jackpot.Current,
					Threshold = jackpot.Threshold,
					Progress = progress,
					EstimatedHit = jackpot.EstimatedDate,
					Priority = jackpot.Priority,
					DPM = jackpot.DPM,
					HoursRemaining = hoursRemaining,
				}
			);
		}

		return forecasts.OrderBy(f => f.HoursRemaining).ToList();
	}

	public async Task<CredentialHealthReport> GetCredentialHealthReportAsync()
	{
		var allCredentials = await _context.Credentials.AsNoTracking().ToListAsync();
		var cutoff = DateTime.UtcNow.AddDays(-7);
		var stale = allCredentials.Where(c => c.LastUpdated < cutoff).ToList();
		var enabled = allCredentials.Where(c => c.Enabled && !c.Banned).ToList();

		var houseBreakdown = allCredentials
			.GroupBy(c => c.House)
			.Select(g => new HouseHealth
			{
				House = g.Key,
				CredentialCount = g.Count(),
				EnabledCount = g.Count(c => c.Enabled && !c.Banned),
				AverageBalance = g.Average(c => c.Balance),
				GameCount = g.Select(c => c.Game).Distinct().Count(),
			})
			.ToList();

		var avgBalance = enabled.Any() ? enabled.Average(c => c.Balance) : 0;
		var totalBalance = enabled.Sum(c => c.Balance);

		return new CredentialHealthReport
		{
			TotalCredentials = allCredentials.Count,
			EnabledCredentials = enabled.Count,
			BannedCredentials = allCredentials.Count(c => c.Banned),
			StaleCredentials = stale.Count,
			AverageBalance = avgBalance,
			TotalBalance = totalBalance,
			HouseCount = houseBreakdown.Count,
			HouseBreakdown = houseBreakdown,
		};
	}

	public async Task<HouseSummary> GetHouseSummaryAsync(string house)
	{
		var credentials = await credentialRepo.GetAllByHouseAsync(house);
		var jackpots = await _context.Jackpots.Where(j => j.House == house).AsNoTracking().ToListAsync();

		var enabled = credentials.Where(c => c.Enabled && !c.Banned).ToList();
		var games = credentials.Select(c => c.Game).Distinct().ToList();

		DateTime lastUpdated = DateTime.UtcNow;
		if (credentials.Any())
		{
			var maxLastUpdated = credentials.Max(c => c.LastUpdated);
			if (maxLastUpdated > DateTime.MinValue.AddYears(1) && maxLastUpdated < DateTime.MaxValue.AddYears(-1))
				lastUpdated = maxLastUpdated;
		}

		return new HouseSummary
		{
			House = house,
			TotalCredentials = credentials.Count,
			EnabledCredentials = enabled.Count,
			TotalBalance = enabled.Sum(c => c.Balance),
			GameCount = games.Count,
			Games = games,
			ActiveJackpots = jackpots.Count,
			LastUpdated = lastUpdated,
		};
	}
}
