using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockRepoHouses : IRepoHouses
{
	private List<House> _houses = [];

	public List<House> GetAll()
	{
		return _houses;
	}

	public House? GetOrCreate(string name)
	{
		House? house = _houses.FirstOrDefault(h => h.Name == name);
		if (house == null)
		{
			house = new House { Name = name };
			_houses.Add(house);
		}
		return house;
	}

	public void Upsert(House house)
	{
		int index = _houses.FindIndex(h => h._id == house._id);
		if (index >= 0)
		{
			_houses[index] = house;
		}
		else
		{
			_houses.Add(house);
		}
	}

	public void Delete(House house)
	{
		_houses.RemoveAll(h => h._id == house._id);
	}

	public void Add(House house)
	{
		_houses.Add(house);
	}

	public void Clear()
	{
		_houses.Clear();
	}
}
