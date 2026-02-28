using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Execution.ValueObjects;

public readonly record struct SpinId
{
	public string Value { get; }

	public SpinId(string value)
	{
		Value = Guard.MaxLength(value, 128);
	}

	public static SpinId New() => new($"SPIN-{Guid.NewGuid():N}");

	public override string ToString() => Value;

	public static implicit operator string(SpinId id) => id.Value;
}
