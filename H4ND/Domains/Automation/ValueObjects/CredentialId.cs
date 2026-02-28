using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

public readonly record struct CredentialId
{
	public string Value { get; }

	public CredentialId(string value)
	{
		Value = Guard.MaxLength(value, 128);
	}

	public static CredentialId New() => new($"CRED-{Guid.NewGuid():N}");

	public override string ToString() => Value;

	public static implicit operator string(CredentialId id) => id.Value;
}
