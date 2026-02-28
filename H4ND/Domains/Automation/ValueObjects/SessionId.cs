using System;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

/// <summary>
/// DECISION_110 Phase 1: Immutable session identifier for a single H4ND execution lifecycle.
/// </summary>
public readonly record struct SessionId
{
	public string Value { get; }

	public SessionId(string value)
	{
		Value = Guard.MaxLength(value, 128);
	}

	public static SessionId New() => new($"S-{DateTime.UtcNow:yyyyMMddHHmmss}-{Guid.NewGuid():N}"[..32]);

	public static SessionId From(string raw) => new(raw);

	public override string ToString() => Value;

	public static implicit operator string(SessionId id) => id.Value;
}
