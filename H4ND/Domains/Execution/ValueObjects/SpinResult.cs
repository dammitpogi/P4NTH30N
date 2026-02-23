using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Execution.ValueObjects;

public sealed record SpinResult
{
	public bool Success { get; init; }
	public decimal BalanceBefore { get; init; }
	public decimal BalanceAfter { get; init; }
	public decimal WagerAmount { get; init; }
	public string? FailureReason { get; init; }

	public SpinResult(bool success, decimal balanceBefore, decimal balanceAfter, decimal wagerAmount, string? failureReason = null)
	{
		if (balanceBefore < 0 || balanceAfter < 0 || wagerAmount < 0)
		{
			throw new DomainException(
				"SpinResult values must be non-negative.",
				"SpinResult.ctor",
				context: $"before={balanceBefore}, after={balanceAfter}, wager={wagerAmount}");
		}

		Success = success;
		BalanceBefore = balanceBefore;
		BalanceAfter = balanceAfter;
		WagerAmount = wagerAmount;
		FailureReason = failureReason;
	}
}
