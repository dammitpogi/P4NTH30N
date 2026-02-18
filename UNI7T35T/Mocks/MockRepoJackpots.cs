using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockRepoJackpots : IRepoJackpots
{
	private List<Jackpot> _jackpots = [];

	public Jackpot? Get(string category, string house, string game)
	{
		return _jackpots.FirstOrDefault(j => j.Category == category && j.House == house && j.Game == game);
	}

	public List<Jackpot> GetAll()
	{
		return _jackpots;
	}

	public List<Jackpot> GetEstimations(string house, string game)
	{
		return _jackpots.Where(j => j.House == house && j.Game == game).ToList();
	}

	public Jackpot? GetMini(string house, string game)
	{
		return _jackpots.FirstOrDefault(j => j.Category == "Mini" && j.House == house && j.Game == game);
	}

	public void Upsert(Jackpot jackpot)
	{
		int index = _jackpots.FindIndex(j => j._id == jackpot._id);
		if (index >= 0)
		{
			_jackpots[index] = jackpot;
		}
		else
		{
			_jackpots.Add(jackpot);
		}
	}

	public void Add(Jackpot jackpot)
	{
		_jackpots.Add(jackpot);
	}

	public void Clear()
	{
		_jackpots.Clear();
	}
}
