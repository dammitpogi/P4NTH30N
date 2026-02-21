using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockRepoSignals : IRepoSignals
{
	private List<Signal> _signals = [];

	public List<Signal> GetAll()
	{
		return _signals;
	}

	public Signal? Get(string house, string game, string username)
	{
		return _signals.FirstOrDefault(s => s.House == house && s.Game == game && s.Username == username);
	}

	public Signal? GetOne(string house, string game)
	{
		return _signals.FirstOrDefault(s => s.House == house && s.Game == game);
	}

	public Signal? GetNext()
	{
		return _signals.FirstOrDefault();
	}

	public void DeleteAll(string house, string game)
	{
		_signals.RemoveAll(s => s.House == house && s.Game == game);
	}

	public bool Exists(Signal signal)
	{
		return _signals.Any(s => s.House == signal.House && s.Game == signal.Game && s.Username == signal.Username);
	}

	public void Acknowledge(Signal signal)
	{
		signal.Acknowledged = true;
	}

	public void Upsert(Signal signal)
	{
		int index = _signals.FindIndex(s => s._id == signal._id);
		if (index >= 0)
		{
			_signals[index] = signal;
		}
		else
		{
			_signals.Add(signal);
		}
	}

	public void Delete(Signal signal)
	{
		_signals.RemoveAll(s => s._id == signal._id);
	}

	public Signal? ClaimNext(string workerId)
	{
		var signal = _signals.FirstOrDefault(s => !s.Acknowledged && s.ClaimedBy == null);
		if (signal != null)
		{
			signal.ClaimedBy = workerId;
			signal.ClaimedAt = DateTime.UtcNow;
		}
		return signal;
	}

	public void ReleaseClaim(Signal signal)
	{
		signal.ClaimedBy = null;
		signal.ClaimedAt = null;
	}

	public void Add(Signal signal)
	{
		_signals.Add(signal);
	}

	public void Clear()
	{
		_signals.Clear();
	}
}
