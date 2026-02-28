using P4NTHE0N.H4ND.Domains.Automation.ValueObjects;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.Events;

public sealed record SignalReceivedEvent : DomainEventBase
{
	public string SignalId { get; init; }
	public string CredentialId { get; init; }
	public string Username { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public int Priority { get; init; }

	public override string AggregateId => CredentialId;

	public SignalReceivedEvent(
		string signalId,
		CredentialId credentialId,
		Username username,
		string house,
		string game,
		int priority)
	{
		SignalId = Guard.MaxLength(signalId, 128);
		CredentialId = credentialId.Value;
		Username = username.Value;
		House = Guard.MaxLength(house, 64);
		Game = Guard.MaxLength(game, 64);
		Priority = priority;
	}
}

public sealed record CredentialLockedEvent : DomainEventBase
{
	public string CredentialId { get; init; }
	public DateTime LockedUntilUtc { get; init; }
	public string LockedBy { get; init; }

	public override string AggregateId => CredentialId;

	public CredentialLockedEvent(CredentialId credentialId, DateTime lockedUntilUtc, string lockedBy)
	{
		CredentialId = credentialId.Value;
		LockedUntilUtc = Guard.NotMinValue(lockedUntilUtc);
		LockedBy = Guard.MaxLength(lockedBy, 128);
	}
}

public sealed record CredentialUnlockedEvent : DomainEventBase
{
	public string CredentialId { get; init; }
	public string UnlockedBy { get; init; }
	public string Reason { get; init; }

	public override string AggregateId => CredentialId;

	public CredentialUnlockedEvent(CredentialId credentialId, string unlockedBy, string reason)
	{
		CredentialId = credentialId.Value;
		UnlockedBy = Guard.MaxLength(unlockedBy, 128);
		Reason = Guard.MaxLength(reason, 256);
	}
}

public sealed record BalanceUpdatedEvent : DomainEventBase
{
	public string CredentialId { get; init; }
	public decimal PreviousBalance { get; init; }
	public decimal CurrentBalance { get; init; }

	public override string AggregateId => CredentialId;

	public BalanceUpdatedEvent(CredentialId credentialId, Money previousBalance, Money currentBalance)
	{
		CredentialId = credentialId.Value;
		PreviousBalance = previousBalance.Amount;
		CurrentBalance = currentBalance.Amount;
	}
}
