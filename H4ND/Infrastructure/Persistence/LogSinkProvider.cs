using System;
using MongoDB.Driver;
using P4NTHE0N.H4ND.Infrastructure.Logging;

namespace P4NTHE0N.H4ND.Infrastructure.Persistence;

/// <summary>
/// DECISION_110 Phase 2: Creates the 4 log collections and ensures indexes.
/// Unique index on L0G_D0M41N.EventId for deduplication.
/// </summary>
public sealed class LogSinkProvider
{
	private readonly IMongoDatabase _database;
	private static bool s_indexesEnsured;
	private static readonly object s_indexLock = new();

	public IMongoCollection<OperationalLogEntry> Operational { get; }
	public IMongoCollection<AuditLogEntry> Audit { get; }
	public IMongoCollection<PerformanceLogEntry> Performance { get; }
	public IMongoCollection<DomainLogEntry> Domain { get; }

	public LogSinkProvider(IMongoDatabase database)
	{
		_database = database ?? throw new ArgumentNullException(nameof(database));

		Operational = _database.GetCollection<OperationalLogEntry>(LogCollectionNames.Operational);
		Audit = _database.GetCollection<AuditLogEntry>(LogCollectionNames.Audit);
		Performance = _database.GetCollection<PerformanceLogEntry>(LogCollectionNames.Performance);
		Domain = _database.GetCollection<DomainLogEntry>(LogCollectionNames.Domain);

		EnsureIndexes();
	}

	private void EnsureIndexes()
	{
		if (s_indexesEnsured) return;

		lock (s_indexLock)
		{
			if (s_indexesEnsured) return;

			try
			{
				// Unique index on L0G_D0M41N.EventId
				var domainIndexModel = new CreateIndexModel<DomainLogEntry>(
					Builders<DomainLogEntry>.IndexKeys.Ascending(x => x.EventId),
					new CreateIndexOptions { Unique = true, Name = "idx_eventId_unique" });
				Domain.Indexes.CreateOne(domainIndexModel);

				// Timestamp indexes for query performance on all collections
				Operational.Indexes.CreateOne(new CreateIndexModel<OperationalLogEntry>(
					Builders<OperationalLogEntry>.IndexKeys.Descending(x => x.Timestamp),
					new CreateIndexOptions { Name = "idx_timestamp" }));

				Audit.Indexes.CreateOne(new CreateIndexModel<AuditLogEntry>(
					Builders<AuditLogEntry>.IndexKeys.Descending(x => x.Timestamp),
					new CreateIndexOptions { Name = "idx_timestamp" }));

				Performance.Indexes.CreateOne(new CreateIndexModel<PerformanceLogEntry>(
					Builders<PerformanceLogEntry>.IndexKeys.Descending(x => x.Timestamp),
					new CreateIndexOptions { Name = "idx_timestamp" }));

				Domain.Indexes.CreateOne(new CreateIndexModel<DomainLogEntry>(
					Builders<DomainLogEntry>.IndexKeys.Descending(x => x.Timestamp),
					new CreateIndexOptions { Name = "idx_timestamp" }));

				// CorrelationId index on operational + domain for drilldown queries
				Operational.Indexes.CreateOne(new CreateIndexModel<OperationalLogEntry>(
					Builders<OperationalLogEntry>.IndexKeys.Ascending(x => x.CorrelationId),
					new CreateIndexOptions { Name = "idx_correlationId" }));

				Domain.Indexes.CreateOne(new CreateIndexModel<DomainLogEntry>(
					Builders<DomainLogEntry>.IndexKeys.Ascending(x => x.CorrelationId),
					new CreateIndexOptions { Name = "idx_correlationId" }));

				s_indexesEnsured = true;
			}
			catch (Exception)
			{
				// Index creation failure should not crash the application.
				// Indexes may already exist from a prior run.
				s_indexesEnsured = true;
			}
		}
	}

	/// <summary>
	/// Creates a fully wired StructuredLogger from this provider.
	/// </summary>
	public StructuredLogger CreateLogger(
		int bufferCapacity = 4096,
		int batchSize = 64,
		TimeSpan? flushInterval = null,
		Action<string>? errorLogger = null)
	{
		return new StructuredLogger(
			Operational, Audit, Performance, Domain,
			bufferCapacity, batchSize, flushInterval, errorLogger);
	}

	/// <summary>
	/// Resets the static index flag. For testing only.
	/// </summary>
	public static void ResetIndexFlag() => s_indexesEnsured = false;
}
