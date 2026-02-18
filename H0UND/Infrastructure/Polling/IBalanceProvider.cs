namespace P4NTH30N.H0UND.Infrastructure.Polling;

public interface IBalanceProvider
{
	(double Balance, double Grand, double Major, double Minor, double Mini) GetBalances(string username, string password);
}
