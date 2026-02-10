namespace P4NTH30N.C0MMON.Persistence;

public interface IMongoUnitOfWork {
	ICredentialRepository Credentials { get; }
	ISignalRepository Signals { get; }
	IJackpotRepository Jackpots { get; }
	IHouseRepository Houses { get; }
	IReceivedRepository Received { get; }
	IProcessEventRepository ProcessEvents { get; }
}

public sealed class MongoUnitOfWork : IMongoUnitOfWork {
	private readonly IMongoDatabaseProvider _provider;

	public ICredentialRepository Credentials { get; }
	public ISignalRepository Signals { get; }
	public IJackpotRepository Jackpots { get; }
	public IHouseRepository Houses { get; }
	public IReceivedRepository Received { get; }
	public IProcessEventRepository ProcessEvents { get; }

	public MongoUnitOfWork(IMongoDatabaseProvider provider) {
		_provider = provider;
		Credentials = new CredentialRepository(_provider);
		Signals = new SignalRepository(_provider);
		Jackpots = new JackpotRepository(_provider);
		Houses = new HouseRepository(_provider);
		Received = new ReceivedRepository(_provider);
		ProcessEvents = new ProcessEventRepository(_provider);
	}

	public MongoUnitOfWork()
		: this(MongoDatabaseProvider.FromEnvironment()) { }
}
