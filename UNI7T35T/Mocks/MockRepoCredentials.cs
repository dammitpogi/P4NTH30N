using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

public class MockRepoCredentials : IRepoCredentials
{
	private List<Credential> _credentials = [];

	public List<Credential> GetAll()
	{
		return _credentials;
	}

	public void IntroduceProperties() { }

	public List<Credential> GetBy(string house, string game)
	{
		return _credentials.Where(c => c.House == house && c.Game == game).ToList();
	}

	public List<Credential> GetAllEnabledFor(string house, string game)
	{
		return _credentials.Where(c => c.House == house && c.Game == game && c.Enabled).ToList();
	}

	public Credential? GetBy(string house, string game, string username)
	{
		return _credentials.FirstOrDefault(c => c.House == house && c.Game == game && c.Username == username);
	}

	public Credential GetNext(bool usePriorityCalculation)
	{
		return _credentials.FirstOrDefault() ?? new Credential();
	}

	public void Upsert(Credential credential)
	{
		int index = _credentials.FindIndex(c => c._id == credential._id);
		if (index >= 0)
		{
			_credentials[index] = credential;
		}
		else
		{
			_credentials.Add(credential);
		}
	}

	public void Lock(Credential credential)
	{
		credential.Unlocked = false;
	}

	public void Unlock(Credential credential)
	{
		credential.Unlocked = true;
	}

	public void Add(Credential credential)
	{
		_credentials.Add(credential);
	}

	public void Clear()
	{
		_credentials.Clear();
	}
}
