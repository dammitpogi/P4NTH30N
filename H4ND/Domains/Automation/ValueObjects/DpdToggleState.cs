using P4NTH30N.H4ND.Domains.Common;
using P4NTH30N.H4ND.Domains.Execution.ValueObjects;

namespace P4NTH30N.H4ND.Domains.Automation.ValueObjects;

public sealed record DpdToggleState
{
	public bool GrandPopped { get; init; }
	public bool MajorPopped { get; init; }
	public bool MinorPopped { get; init; }
	public bool MiniPopped { get; init; }

	public bool GetByTier(JackpotTier tier) => tier switch
	{
		JackpotTier.Grand => GrandPopped,
		JackpotTier.Major => MajorPopped,
		JackpotTier.Minor => MinorPopped,
		JackpotTier.Mini => MiniPopped,
		_ => throw new DomainException($"Unsupported jackpot tier '{tier}'.", "DpdToggleState.GetByTier"),
	};

	public DpdToggleState WithTier(JackpotTier tier, bool value) => tier switch
	{
		JackpotTier.Grand => this with { GrandPopped = value },
		JackpotTier.Major => this with { MajorPopped = value },
		JackpotTier.Minor => this with { MinorPopped = value },
		JackpotTier.Mini => this with { MiniPopped = value },
		_ => throw new DomainException($"Unsupported jackpot tier '{tier}'.", "DpdToggleState.WithTier"),
	};
}
