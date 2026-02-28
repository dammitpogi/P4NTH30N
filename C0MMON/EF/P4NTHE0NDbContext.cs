using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using MongoDB.EntityFrameworkCore;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.C0MMON.EF
{
	/// <summary>
	/// Entity Framework DbContext for P4NTHE0N platform using MongoDB provider.
	/// This provides an alternative to the existing MongoDB.Driver repository pattern.
	/// Use alongside existing repositories for gradual migration or specific scenarios.
	///
	/// NOTE: MongoDB EF Core provider has different APIs than standard EF Core.
	/// This is a basic example - full feature mapping may require additional configuration.
	/// </summary>
	public class P4NTHE0NDbContext : DbContext
	{
		// Entity sets mirroring existing MongoDB collections
		public DbSet<Credential> Credentials { get; set; }
		public DbSet<Signal> Signals { get; set; }
		public DbSet<Jackpot> Jackpots { get; set; }
		public DbSet<House> Houses { get; set; }
		public DbSet<ProcessEvent> ProcessEvents { get; set; }
		public DbSet<Received> Received { get; set; }
		public DbSet<ErrorLog> ErrorLogs { get; set; }

		protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
		{
			// Configure MongoDB EF Core provider
			MongoConnectionOptions options = MongoConnectionOptions.FromEnvironment();
			optionsBuilder.UseMongoDB(options.ConnectionString, options.DatabaseName);
		}

		protected override void OnModelCreating(ModelBuilder modelBuilder)
		{
			base.OnModelCreating(modelBuilder);

			// Configure Credential entity
			modelBuilder.Entity<Credential>(entity =>
			{
				entity.HasKey(e => e._id);
				entity.Property(e => e.House);
				entity.Property(e => e.Game);
				entity.Property(e => e.Username);
				entity.Property(e => e.Balance);
				entity.Property(e => e.Enabled);
				entity.Property(e => e.Banned);
				entity.Property(e => e.Unlocked);
				entity.Property(e => e.LastUpdated);
				entity.Property(e => e.CreateDate);
			});

			// Configure Signal entity
			modelBuilder.Entity<Signal>(entity =>
			{
				entity.HasKey(e => e._id);
				entity.Property(e => e.House);
				entity.Property(e => e.Game);
				entity.Property(e => e.Username);
				entity.Property(e => e.Acknowledged);
				entity.Property(e => e.Priority);
			});

			// Configure Jackpot entity
			modelBuilder.Entity<Jackpot>(entity =>
			{
				entity.HasKey(e => e._id);
				entity.Property(e => e.House);
				entity.Property(e => e.Game);
				entity.Property(e => e.Category);
				entity.Property(e => e.Current);
				entity.Property(e => e.Threshold);
				entity.Property(e => e.Priority);
				entity.Property(e => e.EstimatedDate);
				entity.Property(e => e.DPM);
			});

			// Configure House entity
			modelBuilder.Entity<House>(entity =>
			{
				entity.HasKey(e => e._id);
				entity.Property(e => e.Name);
			});

			// Configure ProcessEvent entity
			modelBuilder.Entity<ProcessEvent>(entity =>
			{
				entity.HasKey(e => e._id);
			});

			// Configure Received entity
			modelBuilder.Entity<Received>(entity =>
			{
				entity.HasKey(e => e._id);
				entity.Property(e => e.House);
				entity.Property(e => e.Game);
				entity.Property(e => e.Username);
			});

			// Configure ErrorLog entity
			modelBuilder.Entity<ErrorLog>(entity =>
			{
				entity.HasKey(e => e._id);
				entity.Property(e => e.Timestamp);
				entity.Property(e => e.ErrorType);
				entity.Property(e => e.Severity);
				entity.Property(e => e.Source);
				entity.Property(e => e.Message);
				entity.Property(e => e.Resolved);
			});
		}

		public ICredentialAnalyticsRepository CreateCredentialAnalyticsRepository() => new CredentialAnalyticsRepository(this);

		public IJackpotAnalyticsRepository CreateJackpotAnalyticsRepository() => new JackpotAnalyticsRepository(this);

		public IAnalyticsService CreateAnalyticsService() => new AnalyticsService(this, new CredentialAnalyticsRepository(this), new JackpotAnalyticsRepository(this));
	}

	/// <summary>
	/// Usage example showing how to use EF alongside existing MongoDB repositories
	/// </summary>
	public static class EFUsageExample
	{
		/// <summary>
		/// Example of using EF analytics repositories (no GroupBy, no anonymous projections)
		/// </summary>
		public static async Task ExampleUsage()
		{
			await using var efContext = new P4NTHE0NDbContext();
			var credentialRepo = efContext.CreateCredentialAnalyticsRepository();

			var highValue = await credentialRepo.GetHighValueCredentialsAsync(1000);
			foreach (var c in highValue)
				Console.WriteLine($"{c.House}/{c.Game} {c.Username} balance={c.Balance:F2}");

			var (totalBalance, count, averageBalance) = await credentialRepo.GetBalanceStatsAsync("FireKirin", "Default");
			Console.WriteLine($"Stats: Total={totalBalance:F2}, Avg={averageBalance:F2}, Count={count}");
		}
	}
}
