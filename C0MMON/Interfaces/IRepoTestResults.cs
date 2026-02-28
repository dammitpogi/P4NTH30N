using System.Collections.Generic;
using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// TEST-035: Repository interface for E2E test results.
/// </summary>
public interface IRepoTestResults
{
	void Insert(TestResult result);
	void Update(TestResult result);
	TestResult? GetByRunId(string testRunId);
	List<TestResult> GetByCategory(string category);
	List<TestResult> GetRecent(int count = 20);
	long Count();
}
