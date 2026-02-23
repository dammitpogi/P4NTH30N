using System;
using System.Collections.Generic;

namespace P4NTH30N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 3: Base class for aggregate roots.
/// Aggregates record domain events during state transitions.
/// </summary>
public abstract class AggregateRoot
{
	private readonly List<IDomainEvent> _uncommittedEvents = new();

	/// <summary>Unique identifier for this aggregate instance.</summary>
	public abstract string Id { get; }

	/// <summary>Version number incremented with each state change.</summary>
	public int Version { get; protected set; }

	/// <summary>Events raised but not yet persisted.</summary>
	public IReadOnlyList<IDomainEvent> UncommittedEvents => _uncommittedEvents.AsReadOnly();

	/// <summary>Records a domain event and applies it to state.</summary>
	protected void RaiseEvent(IDomainEvent @event)
	{
		Guard.NotNull(@event);
		_uncommittedEvents.Add(@event);
		Version++;
		Apply(@event);
	}

	/// <summary>Applies an event to update aggregate state. Override in derived classes.</summary>
	protected abstract void Apply(IDomainEvent @event);

	/// <summary>Clears uncommitted events after persistence.</summary>
	public void ClearUncommittedEvents() => _uncommittedEvents.Clear();

	/// <summary>Replays events to rebuild state (for event sourcing).</summary>
	public void LoadFromHistory(IEnumerable<IDomainEvent> history)
	{
		foreach (var @event in history)
		{
			Apply(@event);
			Version++;
		}
	}
}
