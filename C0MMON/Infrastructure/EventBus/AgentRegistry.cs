using System.Collections.Concurrent;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.C0MMON.Infrastructure.EventBus;

/// <summary>
/// DECISION_027: Agent registry for dynamic capability discovery and message routing.
/// Agents register with capabilities; messages route to agents by role or capability.
/// </summary>
public sealed class AgentRegistry
{
	private readonly ConcurrentDictionary<string, IAgent> _agents = new();
	private readonly IEventBus _eventBus;

	public AgentRegistry(IEventBus eventBus)
	{
		_eventBus = eventBus;
	}

	/// <summary>
	/// Registers an agent in the coordination network.
	/// </summary>
	public void Register(IAgent agent)
	{
		if (_agents.TryAdd(agent.AgentId, agent))
		{
			Console.WriteLine($"[AgentRegistry] Registered {agent.Name} ({agent.Role}) with {agent.Capabilities.Count} capabilities");
		}
	}

	/// <summary>
	/// Unregisters an agent.
	/// </summary>
	public void Unregister(string agentId)
	{
		if (_agents.TryRemove(agentId, out var agent))
		{
			Console.WriteLine($"[AgentRegistry] Unregistered {agent.Name}");
		}
	}

	/// <summary>
	/// Gets an agent by ID.
	/// </summary>
	public IAgent? GetAgent(string agentId)
	{
		_agents.TryGetValue(agentId, out var agent);
		return agent;
	}

	/// <summary>
	/// Gets all agents with a specific role, ordered by priority.
	/// </summary>
	public IReadOnlyList<IAgent> GetAgentsByRole(AgentRole role)
	{
		return _agents.Values
			.Where(a => a.Role == role && a.IsActive)
			.OrderBy(a => a.Priority)
			.ToList();
	}

	/// <summary>
	/// Gets all agents that advertise a specific capability.
	/// </summary>
	public IReadOnlyList<IAgent> GetAgentsByCapability(string capability)
	{
		return _agents.Values
			.Where(a => a.IsActive && a.Capabilities.Contains(capability))
			.OrderBy(a => a.Priority)
			.ToList();
	}

	/// <summary>
	/// Routes a message to the appropriate agent(s).
	/// If ToAgent is set, routes directly. If TargetRole is set, routes to highest-priority agent with that role.
	/// </summary>
	public async Task RouteMessageAsync(AgentMessage message, CancellationToken ct = default)
	{
		if (!string.IsNullOrEmpty(message.ToAgent))
		{
			// Direct routing
			if (_agents.TryGetValue(message.ToAgent, out var target))
			{
				await target.HandleMessageAsync(message, ct);
				return;
			}
			Console.WriteLine($"[AgentRegistry] Target agent {message.ToAgent} not found");
			return;
		}

		if (message.TargetRole.HasValue)
		{
			// Role-based routing — send to highest priority agent
			var agents = GetAgentsByRole(message.TargetRole.Value);
			if (agents.Count > 0)
			{
				await agents[0].HandleMessageAsync(message, ct);
				return;
			}
			Console.WriteLine($"[AgentRegistry] No active agents for role {message.TargetRole}");
			return;
		}

		// Broadcast to all active agents
		foreach (var agent in _agents.Values.Where(a => a.IsActive))
		{
			try
			{
				await agent.HandleMessageAsync(message, ct);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[AgentRegistry] Error routing to {agent.Name}: {ex.Message}");
			}
		}
	}

	/// <summary>
	/// Gets all registered agents.
	/// </summary>
	public IReadOnlyList<IAgent> GetAllAgents() => _agents.Values.ToList();

	/// <summary>
	/// Gets count of active agents.
	/// </summary>
	public int ActiveCount => _agents.Values.Count(a => a.IsActive);

	/// <summary>
	/// Gets count of registered agents.
	/// </summary>
	public int RegisteredCount => _agents.Count;
}
