using System;
using P4NTHE0N.C0MMON;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using P4NTHE0N.Services;

namespace P4NTHE0N.H0UND.Infrastructure.Polling;

public class OrionStarsBalanceProvider : IBalanceProvider
{
	private readonly IErrorEvidence _errors;

	public OrionStarsBalanceProvider(IErrorEvidence? errors = null)
	{
		_errors = errors ?? NoopErrorEvidence.Instance;
	}

	public (double Balance, double Grand, double Major, double Minor, double Mini) GetBalances(string username, string password)
	{
		using ErrorScope scope = _errors.BeginScope(
			"H0UND.OrionStarsBalanceProvider",
			"GetBalances",
			new Dictionary<string, object>
			{
				["usernameHash"] = HashForEvidence(username),
			});

		dynamic balances = OrionStars.QueryBalances(username, password);
		return ValidateBalances(balances, _errors, username);
	}

	public static (double Balance, double Grand, double Major, double Minor, double Mini) ValidateBalances(dynamic balances, IErrorEvidence? errors = null, string? username = null)
	{
		errors ??= NoopErrorEvidence.Instance;

		double validatedBalance = (double)balances.Balance;
		double validatedGrand = (double)balances.Grand;
		double validatedMajor = (double)balances.Major;
		double validatedMinor = (double)balances.Minor;
		double validatedMini = (double)balances.Mini;

		bool invalidBalance = double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0;
		bool invalidGrand = double.IsNaN(validatedGrand) || double.IsInfinity(validatedGrand) || validatedGrand < 0;
		bool invalidMajor = double.IsNaN(validatedMajor) || double.IsInfinity(validatedMajor) || validatedMajor < 0;
		bool invalidMinor = double.IsNaN(validatedMinor) || double.IsInfinity(validatedMinor) || validatedMinor < 0;
		bool invalidMini = double.IsNaN(validatedMini) || double.IsInfinity(validatedMini) || validatedMini < 0;

		if (invalidBalance || invalidGrand || invalidMajor || invalidMinor || invalidMini)
		{
			errors.CaptureWarning(
				"H0UND-ORION-COERCE-001",
				"OrionStars balances coerced due to invalid numeric values",
				context: new Dictionary<string, object>
				{
					["usernameHash"] = HashForEvidence(username ?? string.Empty),
					["invalidBalance"] = invalidBalance,
					["invalidGrand"] = invalidGrand,
					["invalidMajor"] = invalidMajor,
					["invalidMinor"] = invalidMinor,
					["invalidMini"] = invalidMini,
				},
				evidence: new
				{
					raw = new
					{
						balance = (double)balances.Balance,
						grand = (double)balances.Grand,
						major = (double)balances.Major,
						minor = (double)balances.Minor,
						mini = (double)balances.Mini,
					},
				});
		}

		if (double.IsNaN(validatedBalance) || double.IsInfinity(validatedBalance) || validatedBalance < 0)
			validatedBalance = 0;
		if (double.IsNaN(validatedGrand) || double.IsInfinity(validatedGrand) || validatedGrand < 0)
			validatedGrand = 0;
		if (double.IsNaN(validatedMajor) || double.IsInfinity(validatedMajor) || validatedMajor < 0)
			validatedMajor = 0;
		if (double.IsNaN(validatedMinor) || double.IsInfinity(validatedMinor) || validatedMinor < 0)
			validatedMinor = 0;
		if (double.IsNaN(validatedMini) || double.IsInfinity(validatedMini) || validatedMini < 0)
			validatedMini = 0;

		return (validatedBalance, validatedGrand, validatedMajor, validatedMinor, validatedMini);
	}

	private static string HashForEvidence(string input)
	{
		if (string.IsNullOrWhiteSpace(input))
		{
			return string.Empty;
		}

		byte[] bytes = System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes).Substring(0, 16);
	}
}
