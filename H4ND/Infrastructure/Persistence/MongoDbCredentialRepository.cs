using MongoDB.Driver;
using P4NTHE0N.H4ND.Domains.Automation.Aggregates;
using P4NTHE0N.H4ND.Domains.Automation.Repositories;
using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Infrastructure.Persistence;

public sealed class MongoDbCredentialRepository : ICredentialRepository
{
	private readonly IMongoCollection<CredentialDocument> _collection;

	public MongoDbCredentialRepository(MongoDbContext context)
	{
		_collection = context.Credentials;
	}

	public async Task<Credential?> GetByIdAsync(CredentialId credentialId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var filter = Builders<CredentialDocument>.Filter.Eq(x => x.Id, credentialId.Value);
		var row = await _collection.Find(filter).FirstOrDefaultAsync(ct);
		return row is null ? null : ToAggregate(row);
	}

	public async Task<Credential?> GetByIdentityAsync(Username username, string house, string game, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var normalizedHouse = Guard.MaxLength(house, 64);
		var normalizedGame = Guard.MaxLength(game, 64);

		var filter = Builders<CredentialDocument>.Filter.And(
			Builders<CredentialDocument>.Filter.Eq(x => x.Username, username.Value),
			Builders<CredentialDocument>.Filter.Eq(x => x.House, normalizedHouse),
			Builders<CredentialDocument>.Filter.Eq(x => x.Game, normalizedGame));

		var row = await _collection.Find(filter).FirstOrDefaultAsync(ct);
		return row is null ? null : ToAggregate(row);
	}

	public async Task<IReadOnlyCollection<Credential>> GetUnlockedAsync(CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var filter = Builders<CredentialDocument>.Filter.Eq(x => x.IsLocked, false);
		var rows = await _collection.Find(filter).ToListAsync(ct);
		return rows.Select(ToAggregate).ToArray();
	}

	public async Task AddOrUpdateAsync(Credential credential, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		Guard.NotNull(credential);

		var row = ToDocument(credential);
		var filter = Builders<CredentialDocument>.Filter.Eq(x => x.Id, row.Id);
		await _collection.ReplaceOneAsync(filter, row, new ReplaceOptions { IsUpsert = true }, ct);
	}

	public async Task DeleteAsync(CredentialId credentialId, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		var filter = Builders<CredentialDocument>.Filter.Eq(x => x.Id, credentialId.Value);
		await _collection.DeleteOneAsync(filter, ct);
	}

	private static CredentialDocument ToDocument(Credential credential)
	{
		return new CredentialDocument
		{
			Id = credential.CredentialId.Value,
			Username = credential.Username.Value,
			Platform = credential.Platform.ToString(),
			House = credential.House,
			Game = credential.Game,
			IsLocked = credential.IsLocked,
			LockExpiresAtUtc = credential.LockExpiresAtUtc,
			Grand = credential.Jackpots.Grand.Amount,
			Major = credential.Jackpots.Major.Amount,
			Minor = credential.Jackpots.Minor.Amount,
			Mini = credential.Jackpots.Mini.Amount,
			ThresholdGrand = credential.Thresholds.Grand.Amount,
			ThresholdMajor = credential.Thresholds.Major.Amount,
			ThresholdMinor = credential.Thresholds.Minor.Amount,
			ThresholdMini = credential.Thresholds.Mini.Amount,
			DpdGrand = credential.DpdState.GrandPopped,
			DpdMajor = credential.DpdState.MajorPopped,
			DpdMinor = credential.DpdState.MinorPopped,
			DpdMini = credential.DpdState.MiniPopped,
			AggregateVersion = credential.Version,
		};
	}

	private static Credential ToAggregate(CredentialDocument row)
	{
		return new Credential(
			new CredentialId(row.Id),
			new Username(row.Username),
			GamePlatformParser.Parse(row.Platform),
			row.House,
			row.Game,
			new JackpotBalance(new Money(row.Grand), new Money(row.Major), new Money(row.Minor), new Money(row.Mini)),
			new Threshold(new Money(row.ThresholdGrand), new Money(row.ThresholdMajor), new Money(row.ThresholdMinor), new Money(row.ThresholdMini)),
			new DpdToggleState
			{
				GrandPopped = row.DpdGrand,
				MajorPopped = row.DpdMajor,
				MinorPopped = row.DpdMinor,
				MiniPopped = row.DpdMini,
			},
			row.IsLocked,
			row.LockExpiresAtUtc,
			row.AggregateVersion);
	}
}
