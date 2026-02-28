using P4NTHE0N.H4ND.Domains.Common;
using P4NTHE0N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTHE0N.H4ND.Domains.Execution.Events;

public sealed record SpinExecutedEvent : DomainEventBase
{
	public string SpinId { get; init; }
	public string CredentialId { get; init; }
	public bool Success { get; init; }
	public decimal BalanceBefore { get; init; }
	public decimal BalanceAfter { get; init; }

	public override string AggregateId => SpinId;

	public SpinExecutedEvent(string spinId, string credentialId, bool success, decimal balanceBefore, decimal balanceAfter)
	{
		SpinId = Guard.MaxLength(spinId, 128);
		CredentialId = Guard.MaxLength(credentialId, 128);
		Success = success;
		BalanceBefore = balanceBefore;
		BalanceAfter = balanceAfter;
	}
}

public sealed record JackpotPoppedEvent : DomainEventBase
{
	public string CredentialId { get; init; }
	public JackpotTier Tier { get; init; }
	public decimal PreviousValue { get; init; }
	public decimal CurrentValue { get; init; }

	public override string AggregateId => CredentialId;

	public JackpotPoppedEvent(string credentialId, JackpotTier tier, decimal previousValue, decimal currentValue)
	{
		CredentialId = Guard.MaxLength(credentialId, 128);
		Tier = tier;
		PreviousValue = previousValue;
		CurrentValue = currentValue;
	}
}

public sealed record ThresholdResetEvent : DomainEventBase
{
	public string CredentialId { get; init; }
	public JackpotTier Tier { get; init; }
	public decimal NewThreshold { get; init; }

	public override string AggregateId => CredentialId;

	public ThresholdResetEvent(string credentialId, JackpotTier tier, decimal newThreshold)
	{
		CredentialId = Guard.MaxLength(credentialId, 128);
		Tier = tier;
		NewThreshold = newThreshold;
	}
}
