using System.Collections.Generic;
using System.Linq;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Interfaces;

namespace UNI7T35T.Mocks;

/// <summary>
/// TEST-035: In-memory mock for IRepoTestResults.
/// </summary>
public class MockRepoTestResults : IRepoTestResults
{
	private readonly List<TestResult> _results = new();

	public void Insert(TestResult result) => _results.Add(result);

	public void Update(TestResult result)
	{
		var idx = _results.FindIndex(r => r._id == result._id);
		if (idx >= 0) _results[idx] = result;
		else _results.Add(result);
	}

	public TestResult? GetByRunId(string testRunId) =>
		_results.FirstOrDefault(r => r.TestRunId == testRunId);

	public List<TestResult> GetByCategory(string category) =>
		_results.Where(r => r.Category == category).OrderByDescending(r => r.StartedAt).ToList();

	public List<TestResult> GetRecent(int count = 20) =>
		_results.OrderByDescending(r => r.StartedAt).Take(count).ToList();

	public long Count() => _results.Count;

	public void Clear() => _results.Clear();
}
