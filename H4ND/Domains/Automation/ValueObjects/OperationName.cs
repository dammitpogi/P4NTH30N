using System;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

/// <summary>
/// DECISION_110 Phase 1: Strongly-typed operation name (e.g. "Login", "Spin", "ReadJackpot").
/// Max 64 chars, alphanumeric + dots/underscores/hyphens only.
/// </summary>
public readonly record struct OperationName
{
	private static readonly System.Text.RegularExpressions.Regex s_pattern =
		new(@"^[A-Za-z0-9._\-]{1,64}$", System.Text.RegularExpressions.RegexOptions.Compiled);

	public string Value { get; }

	public OperationName(string value)
	{
		Guard.NotNullOrWhiteSpace(value);
		if (!s_pattern.IsMatch(value))
			throw new ArgumentException(
				$"OperationName '{value}' must be 1-64 chars of [A-Za-z0-9._-].", nameof(value));
		Value = value;
	}

	public static OperationName From(string raw) => new(raw);

	public override string ToString() => Value;

	public static implicit operator string(OperationName name) => name.Value;
}
