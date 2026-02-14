using MongoDB.Driver;

namespace P4NTH30N.C0MMON.Infrastructure.Persistence;

public interface IMongoDatabaseProvider
{
	IMongoDatabase Database { get; }
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

	public static MongoDatabaseProvider FromEnvironment()
	{
		return new MongoDatabaseProvider(MongoConnectionOptions.FromEnvironment());
	}
}
