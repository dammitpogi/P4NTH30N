namespace P4NTH30N.C0MMON.Infrastructure.Persistence;

public interface IMongoUnitOfWork : IUnitOfWork
{
	// MongoDB-specific extensions can be added here if needed
	// Currently just inherits from IUnitOfWork for compatibility
}

public sealed class MongoUnitOfWork : IMongoUnitOfWork, IUnitOfWork
{
	private readonly IMongoDatabaseProvider _provider;

	public IMongoDatabaseProvider DatabaseProvider => _provider;
	public IRepoCredentials Credentials { get; }
	public IRepoSignals Signals { get; }
	public IRepoJackpots Jackpots { get; }
	public IRepoHouses Houses { get; }
	public IReceiveSignals Received { get; }
	public IStoreEvents ProcessEvents { get; }
	public IStoreErrors Errors { get; }
	public IRepoTestResults TestResults { get; }

	public MongoUnitOfWork(IMongoDatabaseProvider provider)
	{
		_provider = provider;
		Credentials = new RepoCredentials(_provider);
		Signals = new Signals(_provider);
		Jackpots = new RepoJackpots(_provider);
		Houses = new Houses(_provider);
		Received = new ReceivedRepository(_provider);
		ProcessEvents = new ProcessEventRepository(_provider);
		Errors = new ErrorLogRepository(_provider);
		TestResults = new TestResultsRepository(_provider);
	}

	public MongoUnitOfWork()
		: this(MongoDatabaseProvider.FromEnvironment()) { }
}
