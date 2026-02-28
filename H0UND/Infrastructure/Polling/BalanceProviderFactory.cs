using System;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

namespace P4NTHE0N.H0UND.Infrastructure.Polling;

public class BalanceProviderFactory
{
	private readonly IErrorEvidence _errors;

	public BalanceProviderFactory(IErrorEvidence? errors = null)
	{
		_errors = errors ?? NoopErrorEvidence.Instance;
	}

	public IBalanceProvider GetProvider(string game)
	{
		if (string.IsNullOrWhiteSpace(game))
			throw new ArgumentException("Game name cannot be null or empty.", nameof(game));

		return game switch
		{
			"FireKirin" => new FireKirinBalanceProvider(),
			"OrionStars" => new OrionStarsBalanceProvider(_errors),
			_ => throw new ArgumentException($"Unrecognized game: '{game}'. Expected 'FireKirin' or 'OrionStars'.", nameof(game)),
		};
	}
}
