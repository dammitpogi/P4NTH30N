using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Automation.ValueObjects;

public readonly record struct Username
{
	public string Value { get; }

	public Username(string value)
	{
		Value = Guard.MaxLength(value, 64);
	}

	public override string ToString() => Value;

	public static implicit operator string(Username username) => username.Value;
}
