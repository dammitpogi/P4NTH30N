using MongoDB.Bson;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockStoreErrors : IStoreErrors
{
	private List<ErrorLog> _errors = [];

	public void Insert(ErrorLog error)
	{
		_errors.Add(error);
	}

	public List<ErrorLog> GetAll()
	{
		return _errors;
	}

	public List<ErrorLog> GetBySource(string source)
	{
		return _errors.Where(e => e.Source == source).ToList();
	}

	public List<ErrorLog> GetUnresolved()
	{
		return _errors.Where(e => !e.Resolved).ToList();
	}

	public void MarkResolved(ObjectId id)
	{
		ErrorLog? error = _errors.FirstOrDefault(e => e._id == id);
		if (error != null)
		{
			error.Resolved = true;
		}
	}

	public void Clear()
	{
		_errors.Clear();
	}
}
