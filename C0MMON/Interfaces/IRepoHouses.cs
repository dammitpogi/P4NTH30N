using System.Collections.Generic;
using P4NTH30N.C0MMON;

namespace P4NTH30N.C0MMON.Interfaces;

public interface IRepoHouses {
	List<House> GetAll();
	House? GetOrCreate(string name);
	void Upsert(House house);
	void Delete(House house);
}
