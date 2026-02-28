using System;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

/// <summary>
/// DECISION_110 Phase 1: Immutable correlation identifier for tracing operations across components.
/// </summary>
public readonly record struct CorrelationId
{
	public Guid Value { get; }

	public CorrelationId(Guid value)
	{
		Value = Guard.NotEmpty(value);
	}

	public static CorrelationId New() => new(Guid.NewGuid());

	public static CorrelationId Parse(string raw)
	{
		Guard.NotNullOrWhiteSpace(raw);
		if (!Guid.TryParse(raw, out var guid))
			throw new FormatException($"Invalid CorrelationId format: '{raw}'");
		return new CorrelationId(guid);
	}

	public override string ToString() => Value.ToString("D");

	public static implicit operator Guid(CorrelationId id) => id.Value;
	public static implicit operator string(CorrelationId id) => id.ToString();
}
