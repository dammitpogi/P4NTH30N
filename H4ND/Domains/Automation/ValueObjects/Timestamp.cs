using System;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

/// <summary>
/// DECISION_110 Phase 1: UTC-only timestamp value object. Rejects non-UTC DateTimes.
/// </summary>
public readonly record struct Timestamp : IComparable<Timestamp>
{
	public DateTime Value { get; }

	public Timestamp(DateTime value)
	{
		Guard.NotMinValue(value);
		if (value.Kind != DateTimeKind.Utc)
			throw new ArgumentException("Timestamp must be UTC.", nameof(value));
		Value = value;
	}

	public static Timestamp Now() => new(DateTime.UtcNow);

	public static Timestamp From(DateTime utc) => new(utc);

	public TimeSpan Elapsed() => DateTime.UtcNow - Value;

	public int CompareTo(Timestamp other) => Value.CompareTo(other.Value);

	public override string ToString() => Value.ToString("O");

	public static implicit operator DateTime(Timestamp ts) => ts.Value;
}
