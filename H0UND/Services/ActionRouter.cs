using System;
using System.Collections.Generic;
using P4NTHE0N.H0UND.Domain;

namespace P4NTHE0N.H0UND.Services;

public class ActionRouter
{
	private readonly Dictionary<DecisionType, Action<Decision>> _handlers = new();
	private readonly List<Decision> _executionLog = new();

	public void RegisterHandler(DecisionType type, Action<Decision> handler)
	{
		_handlers[type] = handler;
	}

	public bool Route(Decision decision)
	{
		if (!_handlers.TryGetValue(decision.Type, out Action<Decision>? handler))
		{
			Console.WriteLine($"[ActionRouter] No handler for {decision.Type}");
			return false;
		}

		try
		{
			handler(decision);
			decision.Executed = true;
			decision.ExecutedAt = DateTime.UtcNow;
			_executionLog.Add(decision);
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[ActionRouter] Handler failed for {decision.Type}: {ex.Message}");
			return false;
		}
	}

	public IReadOnlyList<Decision> GetExecutionLog()
	{
		return _executionLog;
	}
}
