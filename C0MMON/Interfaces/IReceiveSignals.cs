using System.Collections.Generic;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.C0MMON.Interfaces;

public interface IReceiveSignals
{
	List<Received> GetAll();
	Received? GetOpen(Signal signal);
	void Upsert(Received received);
}
