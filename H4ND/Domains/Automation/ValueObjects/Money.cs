using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Domains.Automation.ValueObjects;

public readonly record struct Money
{
	public decimal Amount { get; }

	public Money(decimal amount)
	{
		if (amount < 0)
		{
			throw new DomainException(
				$"Money cannot be negative. Amount={amount}",
				"Money.ctor",
				context: amount.ToString(System.Globalization.CultureInfo.InvariantCulture));
		}

		Amount = amount;
	}

	public static Money Zero => new(0m);

	public bool IsZero => Amount == 0m;

	public static Money operator +(Money left, Money right) => new(left.Amount + right.Amount);

	public static Money operator -(Money left, Money right)
	{
		if (left.Amount < right.Amount)
		{
			throw new DomainException(
				$"Money subtraction underflow. Left={left.Amount}, Right={right.Amount}",
				"Money.operator-",
				context: $"{left.Amount}-{right.Amount}");
		}

		return new Money(left.Amount - right.Amount);
	}

	public static bool operator >(Money left, Money right) => left.Amount > right.Amount;
	public static bool operator <(Money left, Money right) => left.Amount < right.Amount;
	public static bool operator >=(Money left, Money right) => left.Amount >= right.Amount;
	public static bool operator <=(Money left, Money right) => left.Amount <= right.Amount;

	public override string ToString() => Amount.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);
}
