using MongoDB.Bson;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockReceiveSignals : IReceiveSignals
{
	private List<Received> _received = [];

	public List<Received> GetAll()
	{
		return _received;
	}

	public Received? GetOpen(Signal signal)
	{
		return _received.FirstOrDefault(r => r.House == signal.House && r.Game == signal.Game && r.Username == signal.Username && r.Rewarded == null);
	}

	public void Upsert(Received received)
	{
		int index = _received.FindIndex(r => r._id == received._id);
		if (index >= 0)
		{
			_received[index] = received;
		}
		else
		{
			_received.Add(received);
		}
	}

	public void Add(Received received)
	{
		_received.Add(received);
	}

	public void Clear()
	{
		_received.Clear();
	}
}
