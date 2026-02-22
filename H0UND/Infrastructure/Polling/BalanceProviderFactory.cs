using System;

namespace P4NTH30N.H0UND.Infrastructure.Polling;

public class BalanceProviderFactory
{
	public IBalanceProvider GetProvider(string game)
	{
		if (string.IsNullOrWhiteSpace(game))
			throw new ArgumentException("Game name cannot be null or empty.", nameof(game));

		return game switch
		{
			"FireKirin" => new FireKirinBalanceProvider(),
			"OrionStars" => new OrionStarsBalanceProvider(),
			_ => throw new ArgumentException($"Unrecognized game: '{game}'. Expected 'FireKirin' or 'OrionStars'.", nameof(game)),
		};
	}
}
