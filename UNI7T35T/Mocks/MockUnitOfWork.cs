using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockUnitOfWork : IUnitOfWork
{
	public IRepoCredentials Credentials { get; }
	public IRepoSignals Signals { get; }
	public IRepoJackpots Jackpots { get; }
	public IStoreEvents ProcessEvents { get; }
	public IStoreErrors Errors { get; }
	public IReceiveSignals Received { get; }
	public IRepoHouses Houses { get; }

	public MockUnitOfWork()
	{
		Credentials = new MockRepoCredentials();
		Signals = new MockRepoSignals();
		Jackpots = new MockRepoJackpots();
		ProcessEvents = new MockStoreEvents();
		Errors = new MockStoreErrors();
		Received = new MockReceiveSignals();
		Houses = new MockRepoHouses();
	}

	public void ClearAll()
	{
		((MockRepoCredentials)Credentials).Clear();
		((MockRepoSignals)Signals).Clear();
		((MockRepoJackpots)Jackpots).Clear();
		((MockStoreEvents)ProcessEvents).Clear();
		((MockStoreErrors)Errors).Clear();
		((MockReceiveSignals)Received).Clear();
		((MockRepoHouses)Houses).Clear();
	}
}
