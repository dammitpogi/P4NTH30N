using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON.EF;

/// <summary>
/// EF Core-based analytics repositories for HUN7ER workloads.
/// These provide LINQ-based querying for complex analytics operations.
///
/// NOTE: MongoDB EF Core provider limitations:
/// - No GroupBy support (calculate in memory)
/// - No Select projections with anonymous types
/// - Use AsNoTracking() for read-only queries
/// </summary>
public interface ICredentialAnalyticsRepository
{
	Task<List<Credential>> GetEnabledCredentialsAsync(string house, string game);
	Task<Credential?> GetByHouseGameUsernameAsync(string house, string game, string username);
	Task<(double TotalBalance, int Count, double AverageBalance)> GetBalanceStatsAsync(string house, string game);
	Task<List<Credential>> GetHighValueCredentialsAsync(double minBalance);
	Task<List<Credential>> GetStaleCredentialsAsync(DateTime cutoff);
	Task<List<Credential>> GetAllByHouseAsync(string house);
	Task<int> GetEnabledCountAsync(string house, string game);
}

public interface IJackpotAnalyticsRepository
{
	Task<List<Jackpot>> GetUpcomingJackpotsAsync(string house, string game, int priority, DateTime beforeDate);
	Task<List<Jackpot>> GetJackpotsByHouseGameAsync(string house, string game);
	Task<Jackpot?> GetMiniJackpotAsync(string house, string game);
	Task<List<Jackpot>> GetAllUpcomingJackpotsAsync(int minPriority);
}

public class CredentialAnalyticsRepository(P4NTH30NDbContext context) : ICredentialAnalyticsRepository
{
	private readonly P4NTH30NDbContext _context = context;

	public async Task<List<Credential>> GetEnabledCredentialsAsync(string house, string game)
	{
		return await _context
			.Credentials.Where(c => c.House == house && c.Game == game && c.Enabled && !c.Banned)
			.OrderBy(c => c.LastUpdated)
			.AsNoTracking()
			.ToListAsync();
	}

	public async Task<Credential?> GetByHouseGameUsernameAsync(string house, string game, string username)
	{
		return await _context.Credentials.Where(c => c.House == house && c.Game == game && c.Username == username).AsNoTracking().FirstOrDefaultAsync();
	}

	public async Task<(double TotalBalance, int Count, double AverageBalance)> GetBalanceStatsAsync(string house, string game)
	{
		var credentials = await _context.Credentials.Where(c => c.House == house && c.Game == game && c.Enabled && !c.Banned).AsNoTracking().ToListAsync();

		var count = credentials.Count;
		var total = credentials.Sum(c => c.Balance);
		var average = count > 0 ? total / count : 0;

		return (total, count, average);
	}

	public async Task<List<Credential>> GetHighValueCredentialsAsync(double minBalance)
	{
		return await _context.Credentials.Where(c => c.Balance >= minBalance && c.Enabled && !c.Banned).OrderByDescending(c => c.Balance).AsNoTracking().ToListAsync();
	}

	public async Task<List<Credential>> GetStaleCredentialsAsync(DateTime cutoff)
	{
		return await _context.Credentials.Where(c => c.LastUpdated < cutoff).OrderBy(c => c.LastUpdated).AsNoTracking().ToListAsync();
	}

	public async Task<List<Credential>> GetAllByHouseAsync(string house)
	{
		return await _context.Credentials.Where(c => c.House == house).AsNoTracking().ToListAsync();
	}

	public async Task<int> GetEnabledCountAsync(string house, string game)
	{
		return await _context.Credentials.CountAsync(c => c.House == house && c.Game == game && c.Enabled && !c.Banned);
	}
}

public class JackpotAnalyticsRepository(P4NTH30NDbContext context) : IJackpotAnalyticsRepository
{
	private readonly P4NTH30NDbContext _context = context;

	public async Task<List<Jackpot>> GetUpcomingJackpotsAsync(string house, string game, int priority, DateTime beforeDate)
	{
		return await _context
			.Jackpots.Where(j => j.House == house && j.Game == game && j.Priority == priority && j.EstimatedDate < beforeDate)
			.OrderBy(j => j.EstimatedDate)
			.AsNoTracking()
			.ToListAsync();
	}

	public async Task<List<Jackpot>> GetJackpotsByHouseGameAsync(string house, string game)
	{
		return await _context
			.Jackpots.Where(j => j.House == house && j.Game == game)
			.OrderByDescending(j => j.Priority)
			.ThenBy(j => j.EstimatedDate)
			.AsNoTracking()
			.ToListAsync();
	}

	public async Task<Jackpot?> GetMiniJackpotAsync(string house, string game)
	{
		return await _context.Jackpots.Where(j => j.House == house && j.Game == game && j.Priority == 1).AsNoTracking().FirstOrDefaultAsync();
	}

	public async Task<List<Jackpot>> GetAllUpcomingJackpotsAsync(int minPriority)
	{
		return await _context
			.Jackpots.Where(j => j.Priority >= minPriority && j.EstimatedDate > DateTime.UtcNow)
			.OrderBy(j => j.EstimatedDate)
			.AsNoTracking()
			.ToListAsync();
	}
}
