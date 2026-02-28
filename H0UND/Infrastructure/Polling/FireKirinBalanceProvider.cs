using System;
using P4NTHE0N.C0MMON;
using P4NTHE0N.Services;

namespace P4NTHE0N.H0UND.Infrastructure.Polling;

public class FireKirinBalanceProvider : IBalanceProvider
{
	public (double Balance, double Grand, double Major, double Minor, double Mini) GetBalances(string username, string password)
	{
		dynamic balances = FireKirin.QueryBalances(username, password);
		return ValidateBalances(balances);
	}

	private static (double Balance, double Grand, double Major, double Minor, double Mini) ValidateBalances(dynamic balances)
	{
		double validatedBalance = (double)balances.Balance;
		double validatedGrand = (double)balances.Grand;
		double validatedMajor = (double)balances.Major;
		double validatedMinor = (double)balances.Minor;
		double validatedMini = (double)balances.Mini;

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
}
