using System;

namespace P4NTH30N.H0UND.Infrastructure.Polling;

public class BalanceProviderFactory
{
	public IBalanceProvider GetProvider(string game)
	{
		return game switch
		{
			"FireKirin" => new FireKirinBalanceProvider(),
			"OrionStars" => new OrionStarsBalanceProvider(),
			_ => throw new Exception($"Unrecognized Game Found. ('{game}')"),
		};
	}
}
