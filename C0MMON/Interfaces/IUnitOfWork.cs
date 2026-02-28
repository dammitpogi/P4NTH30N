using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON;

/// <summary>
/// Unified Unit of Work interface for both MongoDB and EF Core implementations.
/// Provides access to all repositories through a consistent abstraction.
/// </summary>
public interface IUnitOfWork
{
	IRepoCredentials Credentials { get; }
	IRepoSignals Signals { get; }
	IRepoJackpots Jackpots { get; }
	IStoreEvents ProcessEvents { get; }
	IStoreErrors Errors { get; }
	IReceiveSignals Received { get; }
	IRepoHouses Houses { get; }
	IRepoTestResults TestResults { get; }
}
