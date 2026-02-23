using System;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Execution.Events;

/// <summary>
/// DECISION_110 Phase 3: Spin executed on a game.
/// </summary>
public sealed record SpinExecuted : DomainEventBase
{
	public string SpinId { get; init; }
	public string CredentialId { get; init; }
	public string Username { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public double BalanceBefore { get; init; }
	public double BalanceAfter { get; init; }
	public double WagerAmount { get; init; }
	public bool Success { get; init; }
	public string? ErrorMessage { get; init; }

	public override string AggregateId => SpinId;

	public SpinExecuted(
		string spinId,
		string credentialId,
		string username,
		string house,
		string game,
		double balanceBefore,
		double balanceAfter,
		double wagerAmount,
		bool success,
		string? errorMessage = null)
	{
		SpinId = Guard.NotNullOrWhiteSpace(spinId);
		CredentialId = Guard.NotNullOrWhiteSpace(credentialId);
		Username = Guard.NotNullOrWhiteSpace(username);
		House = Guard.NotNullOrWhiteSpace(house);
		Game = Guard.NotNullOrWhiteSpace(game);
		BalanceBefore = balanceBefore;
		BalanceAfter = balanceAfter;
		WagerAmount = wagerAmount;
		Success = success;
		ErrorMessage = errorMessage;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Jackpot tier popped (threshold reached, value reset).
/// </summary>
public sealed record JackpotPopped : DomainEventBase
{
	public string JackpotId { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public string Tier { get; init; }
	public double ValueBeforePop { get; init; }
	public double Threshold { get; init; }
	public double ValueAfterPop { get; init; }
	public double DpdAverageAtPop { get; init; }

	public override string AggregateId => JackpotId;

	public JackpotPopped(
		string jackpotId,
		string house,
		string game,
		string tier,
		double valueBeforePop,
		double threshold,
		double valueAfterPop,
		double dpdAverageAtPop)
	{
		JackpotId = Guard.NotNullOrWhiteSpace(jackpotId);
		House = Guard.NotNullOrWhiteSpace(house);
		Game = Guard.NotNullOrWhiteSpace(game);
		Tier = Guard.NotNullOrWhiteSpace(tier);
		ValueBeforePop = valueBeforePop;
		Threshold = threshold;
		ValueAfterPop = valueAfterPop;
		DpdAverageAtPop = dpdAverageAtPop;
	}
}

/// <summary>
/// DECISION_110 Phase 3: Jackpot threshold reset after pop.
/// </summary>
public sealed record ThresholdReset : DomainEventBase
{
	public string JackpotId { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public string Tier { get; init; }
	public double OldThreshold { get; init; }
	public double NewThreshold { get; init; }
	public string Reason { get; init; }

	public override string AggregateId => JackpotId;

	public ThresholdReset(
		string jackpotId,
		string house,
		string game,
		string tier,
		double oldThreshold,
		double newThreshold,
		string reason)
	{
		JackpotId = Guard.NotNullOrWhiteSpace(jackpotId);
		House = Guard.NotNullOrWhiteSpace(house);
		Game = Guard.NotNullOrWhiteSpace(game);
		Tier = Guard.NotNullOrWhiteSpace(tier);
		OldThreshold = oldThreshold;
		NewThreshold = newThreshold;
		Reason = Guard.NotNullOrWhiteSpace(reason);
	}
}

/// <summary>
/// DECISION_110 Phase 3: DPD toggle state changed (pop detected/cleared).
/// </summary>
public sealed record DpdToggleChanged : DomainEventBase
{
	public string JackpotId { get; init; }
	public string House { get; init; }
	public string Game { get; init; }
	public string Tier { get; init; }
	public bool PreviousState { get; init; }
	public bool NewState { get; init; }
	public double CurrentValue { get; init; }
	public double Threshold { get; init; }

	public override string AggregateId => JackpotId;

	public DpdToggleChanged(
		string jackpotId,
		string house,
		string game,
		string tier,
		bool previousState,
		bool newState,
		double currentValue,
		double threshold)
	{
		JackpotId = Guard.NotNullOrWhiteSpace(jackpotId);
		House = Guard.NotNullOrWhiteSpace(house);
		Game = Guard.NotNullOrWhiteSpace(game);
		Tier = Guard.NotNullOrWhiteSpace(tier);
		PreviousState = previousState;
		NewState = newState;
		CurrentValue = currentValue;
		Threshold = threshold;
	}
}
