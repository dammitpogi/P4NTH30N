using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Monitoring.ValueObjects;

public readonly record struct ComponentName
{
	public string Value { get; }

	public ComponentName(string value)
	{
		Value = Guard.MaxLength(value, 128);
	}

	public override string ToString() => Value;

	public static implicit operator string(ComponentName componentName) => componentName.Value;
}
