using System;
using System.Diagnostics;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON.Infrastructure.Persistence;

public interface IMongoDatabaseProvider
{
	IMongoDatabase Database { get; }
	Task<TimeSpan> PingAsync();
}

public sealed class MongoDatabaseProvider : IMongoDatabaseProvider
{
	private readonly IMongoDatabase _database;

	public IMongoDatabase Database => _database;

	public MongoDatabaseProvider(MongoConnectionOptions options)
	{
		MongoClient client = new(options.ConnectionString);
		_database = client.GetDatabase(options.DatabaseName);
	}

	public async Task<TimeSpan> PingAsync()
	{
		Stopwatch sw = Stopwatch.StartNew();
		await _database.RunCommandAsync<BsonDocument>(new BsonDocument("ping", 1));
		sw.Stop();
		return sw.Elapsed;
	}

	public static MongoDatabaseProvider FromEnvironment()
	{
		return new MongoDatabaseProvider(MongoConnectionOptions.FromEnvironment());
	}
}
