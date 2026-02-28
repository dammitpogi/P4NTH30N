using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Infrastructure.Logging;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

namespace P4NTHE0N.H4ND.Infrastructure.Persistence;

public sealed class MongoDbContext
{
	private readonly IMongoDatabase _database;

	public MongoDbContext(IMongoDatabase database)
	{
		_database = database ?? throw new ArgumentNullException(nameof(database));
	}

	public IMongoCollection<CredentialDocument> Credentials =>
		_database.GetCollection<CredentialDocument>("P4NTHE0N_CREDENTIAL");

	public IMongoCollection<SignalQueueDocument> SignalQueues =>
		_database.GetCollection<SignalQueueDocument>("P4NTHE0N_SIGNAL_QUEUE");

	public IMongoCollection<SpinSessionDocument> SpinSessions =>
		_database.GetCollection<SpinSessionDocument>("P4NTHE0N_SPIN_SESSION");

	public IMongoCollection<HealthCheckDocument> HealthChecks =>
		_database.GetCollection<HealthCheckDocument>("P4NTHE0N_HEALTH_CHECK");

	public IMongoCollection<DomainLogEntry> DomainLogs =>
		_database.GetCollection<DomainLogEntry>(LogCollectionNames.Domain);

	public IMongoCollection<DomainEventEnvelope> DomainEvents =>
		_database.GetCollection<DomainEventEnvelope>(LogCollectionNames.Domain);

	public IMongoCollection<ErrorEvidenceDocument> DebugEvidence =>
		_database.GetCollection<ErrorEvidenceDocument>("_debug");

	public void EnsurePhase4Indexes()
	{
		DomainEvents.Indexes.CreateOne(new CreateIndexModel<DomainEventEnvelope>(
			Builders<DomainEventEnvelope>.IndexKeys.Ascending(x => x.EventId),
			new CreateIndexOptions { Name = "idx_eventId_unique", Unique = true }));

		DomainEvents.Indexes.CreateOne(new CreateIndexModel<DomainEventEnvelope>(
			Builders<DomainEventEnvelope>.IndexKeys.Ascending(x => x.CorrelationId),
			new CreateIndexOptions { Name = "idx_domain_correlationId" }));

		DomainEvents.Indexes.CreateOne(new CreateIndexModel<DomainEventEnvelope>(
			Builders<DomainEventEnvelope>.IndexKeys.Ascending(x => x.AggregateId).Descending(x => x.Timestamp),
			new CreateIndexOptions { Name = "idx_domain_aggregate_timestamp" }));

		Credentials.Indexes.CreateOne(new CreateIndexModel<CredentialDocument>(
			Builders<CredentialDocument>.IndexKeys.Ascending(x => x.Id),
			new CreateIndexOptions { Name = "idx_credential_id", Unique = true }));

		SignalQueues.Indexes.CreateOne(new CreateIndexModel<SignalQueueDocument>(
			Builders<SignalQueueDocument>.IndexKeys.Ascending(x => x.QueueId),
			new CreateIndexOptions { Name = "idx_signal_queue_id", Unique = true }));

		SpinSessions.Indexes.CreateOne(new CreateIndexModel<SpinSessionDocument>(
			Builders<SpinSessionDocument>.IndexKeys.Ascending(x => x.SpinId),
			new CreateIndexOptions { Name = "idx_spin_session_id", Unique = true }));

		HealthChecks.Indexes.CreateOne(new CreateIndexModel<HealthCheckDocument>(
			Builders<HealthCheckDocument>.IndexKeys.Ascending(x => x.Component),
			new CreateIndexOptions { Name = "idx_health_component", Unique = true }));
	}

	public void EnsureDebugEvidenceIndexes(string collectionName = "_debug")
	{
		IMongoCollection<ErrorEvidenceDocument> collection = _database.GetCollection<ErrorEvidenceDocument>(collectionName);

		List<CreateIndexModel<ErrorEvidenceDocument>> models =
		[
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.ExpiresAtUtc),
				new CreateIndexOptions { Name = "idx_debug_expiresAt_ttl", ExpireAfter = TimeSpan.Zero }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.SessionId).Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = "idx_debug_session_capturedAt" }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.CorrelationId).Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = "idx_debug_correlation_capturedAt", Sparse = true }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys
					.Ascending(x => x.Component)
					.Ascending(x => x.Operation)
					.Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = "idx_debug_component_operation_capturedAt" }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.ErrorCode).Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = "idx_debug_errorCode_capturedAt", Sparse = true }),
		];

		collection.Indexes.CreateMany(models);
	}
}

public sealed class CredentialDocument
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public int SchemaVersion { get; set; } = 1;
	public string Id { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public string Platform { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public bool IsLocked { get; set; }
	public DateTime? LockExpiresAtUtc { get; set; }
	public decimal Grand { get; set; }
	public decimal Major { get; set; }
	public decimal Minor { get; set; }
	public decimal Mini { get; set; }
	public decimal ThresholdGrand { get; set; }
	public decimal ThresholdMajor { get; set; }
	public decimal ThresholdMinor { get; set; }
	public decimal ThresholdMini { get; set; }
	public bool DpdGrand { get; set; }
	public bool DpdMajor { get; set; }
	public bool DpdMinor { get; set; }
	public bool DpdMini { get; set; }
	public int AggregateVersion { get; set; }
}

public sealed class SignalQueueDocument
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public int SchemaVersion { get; set; } = 1;
	public string QueueId { get; set; } = string.Empty;
	public List<SignalDocument> Signals { get; set; } = new();
	public int AggregateVersion { get; set; }
}

public sealed class SignalDocument
{
	public string SignalId { get; set; } = string.Empty;
	public string CredentialId { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public int Priority { get; set; }
}

public sealed class SpinSessionDocument
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public int SchemaVersion { get; set; } = 1;
	public string SpinId { get; set; } = string.Empty;
	public string CredentialId { get; set; } = string.Empty;
	public DateTime StartedAtUtc { get; set; }
	public DateTime? CompletedAtUtc { get; set; }
	public bool? Success { get; set; }
	public decimal? BalanceBefore { get; set; }
	public decimal? BalanceAfter { get; set; }
	public decimal? WagerAmount { get; set; }
	public string? FailureReason { get; set; }
	public int AggregateVersion { get; set; }
}

public sealed class HealthCheckDocument
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public int SchemaVersion { get; set; } = 1;
	public string HealthCheckId { get; set; } = string.Empty;
	public string Component { get; set; } = string.Empty;
	public string Status { get; set; } = string.Empty;
	public List<HealthMetricDocument> Metrics { get; set; } = new();
	public int AggregateVersion { get; set; }
}

public sealed class HealthMetricDocument
{
	public string Name { get; set; } = string.Empty;
	public double Value { get; set; }
	public double Threshold { get; set; }
	public DateTime ObservedAtUtc { get; set; }
}
