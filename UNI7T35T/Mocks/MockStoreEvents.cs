using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockStoreEvents : IStoreEvents
{
	private List<ProcessEvent> _events = [];

	public void Insert(ProcessEvent processEvent)
	{
		_events.Add(processEvent);
	}

	public List<ProcessEvent> GetAll()
	{
		return _events;
	}

	public void Clear()
	{
		_events.Clear();
	}
}
