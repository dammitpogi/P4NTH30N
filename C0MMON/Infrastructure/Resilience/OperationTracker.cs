using System.Collections.Concurrent;

namespace P4NTHE0N.C0MMON.Infrastructure.Resilience;

public interface IOperationTracker
{
	bool TryRegisterOperation(string operationId);
	bool IsRegistered(string operationId);
}

public class OperationTracker : IOperationTracker
{
	private readonly ConcurrentDictionary<string, DateTime> _operations = new();
	private readonly TimeSpan _operationIdTTL;

	public OperationTracker(TimeSpan? operationIdTTL = null)
	{
		_operationIdTTL = operationIdTTL ?? TimeSpan.FromMinutes(5);
	}

	public bool TryRegisterOperation(string operationId)
	{
		CleanupExpiredOperations();
		return _operations.TryAdd(operationId, DateTime.UtcNow);
	}

	public bool IsRegistered(string operationId)
	{
		CleanupExpiredOperations();
		return _operations.ContainsKey(operationId);
	}

	private void CleanupExpiredOperations()
	{
		var now = DateTime.UtcNow;
		var expiredKeys = _operations.Where(kvp => now - kvp.Value > _operationIdTTL).Select(kvp => kvp.Key).ToList();

		foreach (var key in expiredKeys)
		{
			_operations.TryRemove(key, out _);
		}
	}
}
