using P4NTH30N.C0MMON;
using P4NTH30N.HUN7ER.Domain.Entities;
using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Application.UseCases;

/// <summary>
/// Use case for polling credentials and updating their state
/// </summary>
public class PollCredentialsUseCase
{
	private readonly Random _random = new();

	/// <summary>
	/// Executes the polling for a single credential
	/// </summary>
	public async Task<PollResult> ExecuteAsync(GameCredential credential)
	{
		var result = new PollResult { CredentialId = credential.Id };

		try
		{
			// Get balances with validation
			var balances = await QueryBalancesAsync(credential);

			// Validate raw values
			if (!ValidateBalances(balances))
			{
				result.Success = false;
				result.ErrorMessage = "Invalid raw values detected";
				return result;
			}

			// Create previous values for comparison
			var previousJackpots = new JackpotValues(credential.Jackpots.Grand, credential.Jackpots.Major, credential.Jackpots.Minor, credential.Jackpots.Mini);

			// Update credential with new values
			credential.Balance = balances.Balance;
			credential.Jackpots = new JackpotValues(balances.Grand, balances.Major, balances.Minor, balances.Mini);

			// Detect jackpot pops
			var poppedTier = credential.DetectJackpotPop(previousJackpots, credential.Jackpots);
			if (poppedTier.HasValue)
			{
				result.JackpotPopped = true;
				result.PoppedTier = poppedTier.Value;
			}

			// Update DPD
			credential.UpdateDPD();

			result.Success = true;
			result.NewJackpots = credential.Jackpots;
			credential.LastUpdated = DateTime.UtcNow;
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("suspended"))
		{
			credential.Banned = true;
			result.Success = false;
			result.ErrorMessage = "Account suspended";
		}
		catch (Exception ex)
		{
			result.Success = false;
			result.ErrorMessage = ex.Message;
		}

		return result;
	}

	private async Task<(double Balance, double Grand, double Major, double Minor, double Mini)> QueryBalancesAsync(GameCredential credential)
	{
		// Add random delay to avoid rate limiting
		int delayMs = _random.Next(3000, 5001);
		await Task.Delay(delayMs);

		switch (credential.Game)
		{
			case "FireKirin":
			{
				var balances = await Task.Run(() => FireKirin.QueryBalances(credential.Username, credential.Password));
				return ((double)balances.Balance, (double)balances.Grand, (double)balances.Major, (double)balances.Minor, (double)balances.Mini);
			}
			case "OrionStars":
			{
				var balances = await Task.Run(() => OrionStars.QueryBalances(credential.Username, credential.Password));
				return ((double)balances.Balance, (double)balances.Grand, (double)balances.Major, (double)balances.Minor, (double)balances.Mini);
			}
			default:
				throw new Exception($"Unrecognized game: {credential.Game}");
		}
	}

	private bool ValidateBalances((double Balance, double Grand, double Major, double Minor, double Mini) balances)
	{
		return !double.IsNaN(balances.Grand)
			&& !double.IsInfinity(balances.Grand)
			&& balances.Grand >= 0
			&& !double.IsNaN(balances.Major)
			&& !double.IsInfinity(balances.Major)
			&& balances.Major >= 0
			&& !double.IsNaN(balances.Minor)
			&& !double.IsInfinity(balances.Minor)
			&& balances.Minor >= 0
			&& !double.IsNaN(balances.Mini)
			&& !double.IsInfinity(balances.Mini)
			&& balances.Mini >= 0
			&& !double.IsNaN(balances.Balance)
			&& !double.IsInfinity(balances.Balance)
			&& balances.Balance >= 0;
	}
}

public class PollResult
{
	public string CredentialId { get; set; } = string.Empty;
	public bool Success { get; set; }
	public string ErrorMessage { get; set; } = string.Empty;
	public bool JackpotPopped { get; set; }
	public JackpotTier? PoppedTier { get; set; }
	public JackpotValues? NewJackpots { get; set; }
}
