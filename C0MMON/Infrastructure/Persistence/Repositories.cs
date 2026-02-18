using System;
using System.Collections.Generic;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.C0MMON.Infrastructure.Persistence;

internal sealed class RepoCredentials(IMongoDatabaseProvider provider) : IRepoCredentials
{
	private readonly IMongoCollection<Credential> _credentials = provider.Database.GetCollection<Credential>(MongoCollectionNames.Credentials);
	private readonly IMongoCollection<Jackpot> _jackpots = provider.Database.GetCollection<Jackpot>(MongoCollectionNames.Jackpots);

	public List<Credential> GetAll()
	{
		return _credentials.Find(Builders<Credential>.Filter.Empty).SortByDescending(c => c.Balance).ToList();
	}

	public void IntroduceProperties()
	{
		FilterDefinition<Credential> filter = Builders<Credential>.Filter.Exists(x => x.Enabled, false);
		List<Credential> missing = _credentials.Find(filter).ToList();
		foreach (Credential credential in missing)
		{
			Upsert(credential);
		}
	}

	public List<Credential> GetBy(string house, string game)
	{
		FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
		FilterDefinition<Credential> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Banned", false);
		return _credentials.Find(filter).SortBy(g => g.LastUpdated).ToList();
	}

	public List<Credential> GetAllEnabledFor(string house, string game)
	{
		FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
		FilterDefinition<Credential> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Enabled", true) & builder.Eq("Banned", false);
		return _credentials.Find(filter).SortBy(g => g.LastUpdated).ToList();
	}

	public Credential? GetBy(string house, string game, string username)
	{
		FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
		FilterDefinition<Credential> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Username", username);
		return _credentials.Find(filter).FirstOrDefault();
	}

	public Credential GetNext(bool usePriorityCalculation)
	{
		FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
		FilterDefinition<Credential> filter = builder.Eq(c => c.Enabled, true) & builder.Eq(c => c.Banned, false);
		List<Credential> credentials = _credentials.Find(filter).ToList();
		if (credentials.Count == 0)
			throw new InvalidOperationException("No enabled, non-banned credentials found.");

		if (!usePriorityCalculation)
		{
			List<Credential> unlockedCredentials = credentials.Where(c => c.Unlocked).OrderBy(c => c.LastUpdated).ToList();
			if (unlockedCredentials.Count == 0)
				throw new InvalidOperationException("No unlocked credentials available.");
			return unlockedCredentials.First();
		}

		List<(Credential credential, int priority, DateTime by, bool overdue)> prioritized = new();
		foreach (Credential cred in credentials)
		{
			DateTime created = cred.CreateDate;
			DateTime updated = cred.LastUpdated > DateTime.MinValue ? cred.LastUpdated : created;
			bool funded = !cred.CashedOut;

			List<Jackpot> estimations = _jackpots
				.Find(
					Builders<Jackpot>.Filter.And(
						Builders<Jackpot>.Filter.Eq(j => j.House, cred.House),
						Builders<Jackpot>.Filter.Eq(j => j.Game, cred.Game),
						Builders<Jackpot>.Filter.Gte(j => j.Priority, 2)
					)
				)
				.SortBy(j => j.EstimatedDate)
				.ToList();
			double dpdAverage = estimations.Any() ? estimations.Average(j => j.DPD.Average) : 0;

			Jackpot? mini = _jackpots
				.Find(
					Builders<Jackpot>.Filter.And(
						Builders<Jackpot>.Filter.Eq(j => j.House, cred.House),
						Builders<Jackpot>.Filter.Eq(j => j.Game, cred.Game),
						Builders<Jackpot>.Filter.Eq(j => j.Priority, 1)
					)
				)
				.FirstOrDefault();

			bool leastWeekOld = created < DateTime.UtcNow.AddDays(-7);
			DateTime now = DateTime.UtcNow;
			Jackpot? latestEstimation = estimations.FirstOrDefault();

			bool jackpotWeek = latestEstimation == null || latestEstimation.EstimatedDate > now.AddDays(7);
			bool jackpotDay = latestEstimation == null || latestEstimation.EstimatedDate > now.AddDays(1);
			bool jackpot12H = latestEstimation == null || latestEstimation.EstimatedDate > now.AddHours(12);
			bool jackpot3H = latestEstimation == null || latestEstimation.EstimatedDate > now.AddHours(3);

			double miniDiff = mini != null ? mini.Threshold - mini.Current : 0;
			double jackpotDiff = latestEstimation != null ? latestEstimation.Threshold - latestEstimation.Current : 0;

			int priority = 7;
			if (jackpotDiff != 0)
			{
				if (jackpotDiff <= 0.12 || (miniDiff <= 0.07 && funded))
				{
					priority = 1;
				}
				else if (jackpot3H || jackpotDiff <= 0.3 || (miniDiff <= 0.15 && funded))
				{
					priority = 2;
				}
				else if (jackpot12H)
				{
					priority = 3;
				}
				else if (!leastWeekOld && latestEstimation == null)
				{
					priority = 4;
				}
				else if (jackpotDay)
				{
					priority = 5;
				}
				else if (jackpotWeek)
				{
					priority = 6;
				}
			}

			DateTime by = priority switch
			{
				1 => updated.AddMinutes(4),
				2 => updated.AddMinutes(8),
				3 => updated.AddMinutes(16),
				4 => updated.AddHours(1),
				5 => updated.AddHours(3),
				6 => updated.AddHours(6),
				_ => updated.AddDays(1),
			};

			bool overdue = now > by;
			prioritized.Add((cred, priority, by, overdue));
		}

		(Credential credential, int priority, DateTime by, bool overdue)[] sorted = prioritized
			.OrderBy(p => p.priority)
			.ThenByDescending(p => p.overdue)
			.ThenBy(p => p.credential.LastUpdated)
			.ToArray();

		var nextCredential = sorted.Where(p => p.credential.Unlocked).FirstOrDefault();
		if (nextCredential.credential == null)
			throw new InvalidOperationException("No unlocked credentials available.");

		return nextCredential.credential;
	}

	public void Upsert(Credential credential)
	{
		credential.Settings ??= new GameSettings(credential.Game);

		if (credential.Thresholds.Grand > 1800)
			credential.Settings.SpinGrand = false;
		if (credential.Thresholds.Major > 630)
			credential.Settings.SpinMajor = false;
		if (credential.Thresholds.Minor > 134)
			credential.Settings.SpinMinor = false;
		if (credential.Thresholds.Mini > 30)
			credential.Settings.SpinMini = false;

		FilterDefinition<Credential> filter = Builders<Credential>.Filter.Eq(x => x._id, credential._id);
		_credentials.ReplaceOne(filter, credential, new ReplaceOptions { IsUpsert = true });
	}

	public void Lock(Credential credential)
	{
		credential.UnlockTimeout = DateTime.UtcNow.AddMinutes(1.5);
		credential.Unlocked = false;
		Upsert(credential);
	}

	public void Unlock(Credential credential)
	{
		credential.Unlocked = true;
		Upsert(credential);
	}
}

internal sealed class Signals(IMongoDatabaseProvider provider) : IRepoSignals
{
	private readonly IMongoCollection<Signal> _signals = provider.Database.GetCollection<Signal>(MongoCollectionNames.Signals);

	public List<Signal> GetAll()
	{
		return _signals.Find(Builders<Signal>.Filter.Empty).ToList();
	}

	public Signal? Get(string house, string game, string username)
	{
		FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Username", username);
		return _signals.Find(filter).FirstOrDefault();
	}

	public Signal? GetOne(string house, string game)
	{
		FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", house) & builder.Eq("Game", game);
		return _signals.Find(filter).FirstOrDefault();
	}

	public Signal? GetNext()
	{
		return _signals.Find(Builders<Signal>.Filter.Eq("Acknowledged", false)).SortByDescending(g => g.Priority).Limit(1).FirstOrDefault();
	}

	public void DeleteAll(string house, string game)
	{
		FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", house) & builder.Eq("Game", game);
		_signals.DeleteMany(filter);
	}

	public bool Exists(Signal signal)
	{
		FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", signal.House) & builder.Eq("Game", signal.Game) & builder.Eq("Username", signal.Username);
		return _signals.Find(filter).Limit(1).Any();
	}

	public void Acknowledge(Signal signal)
	{
		FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", signal.House) & builder.Eq("Game", signal.Game) & builder.Eq("Username", signal.Username);

		signal.Acknowledged = true;
		signal.Timeout = DateTime.UtcNow.AddMinutes(1);

		UpdateDefinition<Signal> update = Builders<Signal>.Update.Set(x => x.Acknowledged, true).Set(x => x.Timeout, signal.Timeout);

		_signals.UpdateOne(filter, update, new UpdateOptions { IsUpsert = false });
	}

	public void Upsert(Signal signal)
	{
		var builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", signal.House) & builder.Eq("Game", signal.Game) & builder.Eq("Username", signal.Username);

		var existing = _signals.Find(filter).FirstOrDefault();
		if (existing != null)
		{
			signal._id = existing._id; // PRESERVE EXISTING _ID
			_signals.ReplaceOne(filter, signal);
		}
		else
		{
			_signals.InsertOne(signal);
		}
	}

	public void Delete(Signal signal)
	{
		FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
		FilterDefinition<Signal> filter = builder.Eq("House", signal.House) & builder.Eq("Game", signal.Game) & builder.Eq("Username", signal.Username);
		_signals.DeleteOne(filter);
	}
}

internal sealed class RepoJackpots(IMongoDatabaseProvider provider) : IRepoJackpots
{
	private readonly IMongoCollection<Jackpot> _jackpots = provider.Database.GetCollection<Jackpot>(MongoCollectionNames.Jackpots);

	public Jackpot? Get(string category, string house, string game)
	{
		FilterDefinitionBuilder<Jackpot> builder = Builders<Jackpot>.Filter;
		FilterDefinition<Jackpot> query = builder.Eq("Category", category) & builder.Eq("House", house) & builder.Eq("Game", game);
		return _jackpots.Find(query).FirstOrDefault();
	}

	public List<Jackpot> GetAll()
	{
		return _jackpots.Find(Builders<Jackpot>.Filter.Empty).SortByDescending(x => x.EstimatedDate).ToList();
	}

	public List<Jackpot> GetEstimations(string house, string game)
	{
		FilterDefinitionBuilder<Jackpot> builder = Builders<Jackpot>.Filter;
		FilterDefinition<Jackpot> query = builder.Eq(x => x.House, house) & builder.Eq(x => x.Game, game) & builder.Gte(x => x.Priority, 2);
		return _jackpots.Find(query).SortBy(x => x.EstimatedDate).ToList();
	}

	public Jackpot? GetMini(string house, string game)
	{
		FilterDefinitionBuilder<Jackpot> builder = Builders<Jackpot>.Filter;
		FilterDefinition<Jackpot> query = builder.Eq(x => x.House, house) & builder.Eq(x => x.Game, game) & builder.Eq(x => x.Priority, 1);
		return _jackpots.Find(query).FirstOrDefault();
	}

	public void Upsert(Jackpot jackpot)
	{
		var builder = Builders<Jackpot>.Filter;
		FilterDefinition<Jackpot> filter = builder.Eq("House", jackpot.House) & builder.Eq("Game", jackpot.Game) & builder.Eq("Category", jackpot.Category);

		var existing = _jackpots.Find(filter).FirstOrDefault();
		if (existing != null)
		{
			jackpot._id = existing._id; // PRESERVE EXISTING _ID
			_jackpots.ReplaceOne(filter, jackpot);
		}
		else
		{
			_jackpots.InsertOne(jackpot);
		}
	}
}

internal sealed class Houses(IMongoDatabaseProvider provider) : IRepoHouses
{
	private readonly IMongoCollection<House> _houses = provider.Database.GetCollection<House>(MongoCollectionNames.Houses);

	public List<House> GetAll()
	{
		return _houses.Find(Builders<House>.Filter.Empty).ToList();
	}

	public House? GetOrCreate(string name)
	{
		if (string.IsNullOrWhiteSpace(name))
			return null;

		House? dto = _houses.Find(Builders<House>.Filter.Eq("Name", name)).FirstOrDefault();
		if (dto is not null)
			return dto;

		House house = new(name, "");
		_houses.InsertOne(house);
		return house;
	}

	public void Upsert(House house)
	{
		FilterDefinition<House> filter = Builders<House>.Filter.Eq("_id", house._id);
		_houses.ReplaceOne(filter, house, new ReplaceOptions { IsUpsert = true });
	}

	public void Delete(House house)
	{
		_houses.DeleteOne(Builders<House>.Filter.Eq("_id", house._id));
	}
}

public sealed class ReceivedRepository(IMongoDatabaseProvider provider) : IReceiveSignals
{
	private readonly IMongoCollection<Received> _received = provider.Database.GetCollection<Received>(MongoCollectionNames.Received);

	public List<Received> GetAll()
	{
		return _received.Find(Builders<Received>.Filter.Empty).ToList();
	}

	public Received? GetOpen(Signal signal)
	{
		FilterDefinitionBuilder<Received> builder = Builders<Received>.Filter;
		FilterDefinition<Received> filter =
			builder.Eq("House", signal.House)
			& builder.Eq("Game", signal.Game)
			& builder.Eq("Username", signal.Username)
			& builder.Eq("Rewarded", MongoDB.Bson.BsonNull.Value);
		return _received.Find(filter).FirstOrDefault();
	}

	public void Upsert(Received received)
	{
		if (received._id == null)
			received._id = ObjectId.GenerateNewId();
		_received.ReplaceOne(Builders<Received>.Filter.Eq("_id", received._id), received, new ReplaceOptions { IsUpsert = true });
	}
}

internal sealed class ProcessEventRepository(IMongoDatabaseProvider provider) : IStoreEvents
{
	private readonly IMongoCollection<ProcessEvent> _events = provider.Database.GetCollection<ProcessEvent>(MongoCollectionNames.Events);

	public void Insert(ProcessEvent processEvent)
	{
		_events.InsertOne(processEvent);
	}
}

internal sealed class ErrorLogRepository(IMongoDatabaseProvider provider) : IStoreErrors
{
	private readonly IMongoCollection<ErrorLog> _errors = provider.Database.GetCollection<ErrorLog>(MongoCollectionNames.Errors);

	public void Insert(ErrorLog error)
	{
		_errors.InsertOne(error);
	}

	public List<ErrorLog> GetAll()
	{
		return _errors.Find(Builders<ErrorLog>.Filter.Empty).SortByDescending(e => e.Timestamp).ToList();
	}

	public List<ErrorLog> GetBySource(string source)
	{
		return _errors.Find(e => e.Source == source).SortByDescending(e => e.Timestamp).ToList();
	}

	public List<ErrorLog> GetUnresolved()
	{
		return _errors.Find(e => !e.Resolved).SortByDescending(e => e.Timestamp).ToList();
	}

	public void MarkResolved(ObjectId id)
	{
		var filter = Builders<ErrorLog>.Filter.Eq("_id", id);
		var update = Builders<ErrorLog>.Update.Set(e => e.Resolved, true).Set(e => e.ResolvedAt, DateTime.UtcNow);
		_errors.UpdateOne(filter, update);
	}
}
