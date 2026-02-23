using System;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Automation.Events;

/// <summary>
/// DECISION_110 Phase 3: Credential locked for exclusive processing.
/// </summary>
public sealed record CredentialLocked : DomainEventBase
{
	public string CredentialId { get; init; }
	public string Username { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public string? LockedBy { get; init; }

	public override string AggregateId => CredentialId;

	public CredentialLocked(string credentialId, string username, string house, string game, string? lockedBy = null)
	{
		CredentialId = Guard.NotNullOrWhiteSpace(credentialId);
		Username = Guard.NotNullOrWhiteSpace(username);
		House = Guard.NotNullOrWhiteSpace(house);
		Game = Guard.NotNullOrWhiteSpace(game);
		LockedBy = lockedBy;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Credential unlocked after processing.
/// </summary>
public sealed record CredentialUnlocked : DomainEventBase
{
	public string CredentialId { get; init; }
	public string Username { get; init; }
	public string? UnlockedBy { get; init; }
	public string? Reason { get; init; }

	public override string AggregateId => CredentialId;

	public CredentialUnlocked(string credentialId, string username, string? unlockedBy = null, string? reason = null)
	{
		CredentialId = Guard.NotNullOrWhiteSpace(credentialId);
		Username = Guard.NotNullOrWhiteSpace(username);
		UnlockedBy = unlockedBy;
		Reason = reason;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Credential balance updated after query.
/// </summary>
public sealed record BalanceUpdated : DomainEventBase
{
	public string CredentialId { get; init; }
	public string Username { get; init; }
	public double PreviousBalance { get; init; }
	public double NewBalance { get; init; }
	public double Delta => NewBalance - PreviousBalance;

	public override string AggregateId => CredentialId;

	public BalanceUpdated(string credentialId, string username, double previousBalance, double newBalance)
	{
		CredentialId = Guard.NotNullOrWhiteSpace(credentialId);
		Username = Guard.NotNullOrWhiteSpace(username);
		PreviousBalance = previousBalance;
		NewBalance = newBalance;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Signal received for credential processing.
/// </summary>
public sealed record SignalReceived : DomainEventBase
{
	public string SignalId { get; init; }
	public string CredentialId { get; init; }
	public string Username { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public float Priority { get; init; }

	public override string AggregateId => SignalId;

	public SignalReceived(string signalId, string credentialId, string username, string house, string game, float priority)
	{
		SignalId = Guard.NotNullOrWhiteSpace(signalId);
		CredentialId = Guard.NotNullOrWhiteSpace(credentialId);
		Username = Guard.NotNullOrWhiteSpace(username);
		House = Guard.NotNullOrWhiteSpace(house);
		Game = Guard.NotNullOrWhiteSpace(game);
		Priority = priority;
	}
}
