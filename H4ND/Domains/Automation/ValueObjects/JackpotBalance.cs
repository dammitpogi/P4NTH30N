using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Automation.ValueObjects;

public sealed record JackpotBalance
{
	public Money Grand { get; init; }
	public Money Major { get; init; }
	public Money Minor { get; init; }
	public Money Mini { get; init; }

	public JackpotBalance(Money grand, Money major, Money minor, Money mini)
	{
		Grand = grand;
		Major = major;
		Minor = minor;
		Mini = mini;
	}

	public Money GetByTier(JackpotTier tier) => tier switch
	{
		JackpotTier.Grand => Grand,
		JackpotTier.Major => Major,
		JackpotTier.Minor => Minor,
		JackpotTier.Mini => Mini,
		_ => throw new DomainException($"Unsupported jackpot tier '{tier}'.", "JackpotBalance.GetByTier"),
	};

	public JackpotBalance WithTier(JackpotTier tier, Money value) => tier switch
	{
		JackpotTier.Grand => this with { Grand = value },
		JackpotTier.Major => this with { Major = value },
		JackpotTier.Minor => this with { Minor = value },
		JackpotTier.Mini => this with { Mini = value },
		_ => throw new DomainException($"Unsupported jackpot tier '{tier}'.", "JackpotBalance.WithTier"),
	};
}
