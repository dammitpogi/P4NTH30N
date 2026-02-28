using System.Collections.Generic;
using P4NTHE0N.C0MMON;

namespace P4NTHE0N.C0MMON.Interfaces;

public interface IRepoJackpots
{
	Jackpot? Get(string category, string house, string game);
	List<Jackpot> GetAll();
	List<Jackpot> GetEstimations(string house, string game);
	Jackpot? GetMini(string house, string game);
	void Upsert(Jackpot jackpot);
}
