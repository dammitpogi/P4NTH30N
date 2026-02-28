using System.Collections.Generic;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.C0MMON.Interfaces;

public interface IRepoSignals
{
	List<Signal> GetAll();
	Signal? Get(string house, string game, string username);
	Signal? GetOne(string house, string game);
	Signal? GetNext();
	void DeleteAll(string house, string game);
	bool Exists(Signal signal);
	void Acknowledge(Signal signal);
	void Upsert(Signal signal);
	void Delete(Signal signal);
	Signal? ClaimNext(string workerId);
	void ReleaseClaim(Signal signal);
}
