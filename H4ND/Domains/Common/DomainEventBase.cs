using System;

namespace P4NTHE0N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 3: Abstract base for domain events with common fields.
/// </summary>
public abstract record DomainEventBase : IDomainEvent
{
	public string EventId { get; init; } = Guid.NewGuid().ToString("D");
	public int EventVersion { get; init; } = 1;
	public DateTime OccurredAt { get; init; } = DateTime.UtcNow;
	public abstract string AggregateId { get; }
	public string EventType => GetType().Name;
}
