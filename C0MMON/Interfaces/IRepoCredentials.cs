using System.Collections.Generic;
using P4NTH30N.C0MMON;

namespace P4NTH30N.C0MMON.Interfaces;

public interface IRepoCredentials
{
	List<Credential> GetAll();
	void IntroduceProperties();
	List<Credential> GetBy(string house, string game);
	List<Credential> GetAllEnabledFor(string house, string game);
	Credential? GetBy(string house, string game, string username);
	Credential GetNext(bool usePriorityCalculation);
	void Upsert(Credential credential);
	void Lock(Credential credential);
	void Unlock(Credential credential);
}
