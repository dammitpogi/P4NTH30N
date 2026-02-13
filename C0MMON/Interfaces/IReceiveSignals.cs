using System.Collections.Generic;
using P4NTH30N.C0MMON;

namespace P4NTH30N.C0MMON.Interfaces;

public interface IReceiveSignals {
	List<Received> GetAll();
	Received? GetOpen(Signal signal);
	void Upsert(Received received);
}
