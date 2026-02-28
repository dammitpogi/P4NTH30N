using MongoDB.Driver;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class MongoDebugEvidenceRepository : IErrorEvidenceRepository
{
	public static readonly string[] RequiredIndexNames =
	[
		"idx_debug_expiresAt_ttl",
		"idx_debug_session_capturedAt",
		"idx_debug_correlation_capturedAt",
		"idx_debug_component_operation_capturedAt",
		"idx_debug_errorCode_capturedAt",
	];

	private readonly IMongoCollection<ErrorEvidenceDocument> _collection;

	public MongoDebugEvidenceRepository(IMongoDatabaseProvider provider, ErrorEvidenceOptions options)
		: this(provider.Database, options)
	{
	}

	public MongoDebugEvidenceRepository(IMongoDatabase database, ErrorEvidenceOptions options)
	{
		ArgumentNullException.ThrowIfNull(database);
		ArgumentNullException.ThrowIfNull(options);
		_collection = database.GetCollection<ErrorEvidenceDocument>(options.Collection);
	}

	public async Task EnsureIndexesAsync(CancellationToken ct = default)
	{
		var models = new List<CreateIndexModel<ErrorEvidenceDocument>>
		{
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.ExpiresAtUtc),
				new CreateIndexOptions { Name = RequiredIndexNames[0], ExpireAfter = TimeSpan.Zero }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.SessionId).Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = RequiredIndexNames[1] }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.CorrelationId).Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = RequiredIndexNames[2], Sparse = true }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys
					.Ascending(x => x.Component)
					.Ascending(x => x.Operation)
					.Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = RequiredIndexNames[3] }),
			new(
				Builders<ErrorEvidenceDocument>.IndexKeys.Ascending(x => x.ErrorCode).Descending(x => x.CapturedAtUtc),
				new CreateIndexOptions { Name = RequiredIndexNames[4], Sparse = true }),
		};

		await _collection.Indexes.CreateManyAsync(models, ct);
	}

	public Task InsertAsync(ErrorEvidenceDocument document, CancellationToken ct = default)
	{
		ArgumentNullException.ThrowIfNull(document);
		return _collection.InsertOneAsync(document, cancellationToken: ct);
	}

	public Task InsertManyAsync(IReadOnlyCollection<ErrorEvidenceDocument> documents, CancellationToken ct = default)
	{
		if (documents.Count == 0)
		{
			return Task.CompletedTask;
		}

		return _collection.InsertManyAsync(documents, new InsertManyOptions { IsOrdered = false }, ct);
	}

	public async Task<IReadOnlyList<ErrorEvidenceDocument>> QueryBySessionAsync(string sessionId, int limit, CancellationToken ct = default)
	{
		ArgumentException.ThrowIfNullOrWhiteSpace(sessionId);
		int safeLimit = Math.Clamp(limit, 1, 1000);
		return await _collection
			.Find(Builders<ErrorEvidenceDocument>.Filter.Eq(x => x.SessionId, sessionId))
			.SortByDescending(x => x.CapturedAtUtc)
			.Limit(safeLimit)
			.ToListAsync(ct);
	}

	public async Task<IReadOnlyList<ErrorEvidenceDocument>> QueryByCorrelationAsync(string correlationId, int limit, CancellationToken ct = default)
	{
		ArgumentException.ThrowIfNullOrWhiteSpace(correlationId);
		int safeLimit = Math.Clamp(limit, 1, 1000);
		return await _collection
			.Find(Builders<ErrorEvidenceDocument>.Filter.Eq(x => x.CorrelationId, correlationId))
			.SortByDescending(x => x.CapturedAtUtc)
			.Limit(safeLimit)
			.ToListAsync(ct);
	}
}
