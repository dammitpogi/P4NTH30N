namespace P4NTH30N.C0MMON.Persistence;

public interface IMongoUnitOfWork {
	IRepoCredentials Credentials { get; }
	IRepoSignals Signals { get; }
	IRepoJackpots Jackpots { get; }
	IRepoHouses Houses { get; }
	IReceiveSignals Received { get; }
	IStoreEvents ProcessEvents { get; }
	IStoreErrors Errors { get; }
}

public sealed class MongoUnitOfWork : IMongoUnitOfWork {
	private readonly IMongoDatabaseProvider _provider;

	public IRepoCredentials Credentials { get; }
	public IRepoSignals Signals { get; }
	public IRepoJackpots Jackpots { get; }
	public IRepoHouses Houses { get; }
	public IReceiveSignals Received { get; }
	public IStoreEvents ProcessEvents { get; }
	public IStoreErrors Errors { get; }

	public MongoUnitOfWork(IMongoDatabaseProvider provider) {
		_provider = provider;
		Credentials = new RepoCredentials(_provider);
		Signals = new Signals(_provider);
		Jackpots = new Jackpots(_provider);
		Houses = new Houses(_provider);
		Received = new ReceivedRepository(_provider);
		ProcessEvents = new ProcessEventRepository(_provider);
		Errors = new ErrorLogRepository(_provider);
	}

	public MongoUnitOfWork()
		: this(MongoDatabaseProvider.FromEnvironment()) { }
}
