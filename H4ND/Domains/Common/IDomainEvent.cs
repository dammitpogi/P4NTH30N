using System;

namespace P4NTHE0N.H4ND.Domains.Common;

/// <summary>
/// DECISION_110 Phase 3: Base contract for all domain events.
/// Events are immutable facts that have already happened.
/// </summary>
public interface IDomainEvent
{
	/// <summary>Globally unique event identifier for idempotency.</summary>
	string EventId { get; }

	/// <summary>Event schema version for safe evolution.</summary>
	int EventVersion { get; }

	/// <summary>UTC timestamp when the event occurred.</summary>
	DateTime OccurredAt { get; }

	/// <summary>Aggregate ID that produced this event.</summary>
	string AggregateId { get; }

	/// <summary>Type name of the event (e.g. "CredentialLocked").</summary>
	string EventType { get; }
}
