using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Services;

/// <summary>
/// OPS-045: Extension-free jackpot reading with platform-aware fallback chain.
/// Primary jackpot source remains the WebSocket API (QueryBalances).
/// This service provides secondary CDP-based validation and logging.
/// </summary>
public sealed class JackpotReader
{
	private readonly GameSelectorConfig? _config;

	public JackpotReader(GameSelectorConfig? config = null)
	{
		_config = config;
	}

	/// <summary>
	/// Reads a single jackpot tier via CDP using the fallback chain for the given platform.
	/// Returns 0 if all selectors fail (expected for Canvas/Cocos2d-x games).
	/// </summary>
	public async Task<double> ReadJackpotAsync(
		ICdpClient cdp,
		string platform,
		string jackpotType,
		CancellationToken ct = default)
	{
		GameSelectors selectors = _config?.GetSelectors(platform) ?? GameSelectors.Default;
		List<string> expressions = selectors.JackpotTierExpressions;

		for (int i = 0; i < expressions.Count; i++)
		{
			string expr = expressions[i].Replace("{tier}", jackpotType);
			try
			{
				double? value = await cdp.EvaluateAsync<double>(expr, ct);
				if (value.HasValue && value.Value > 0)
				{
					Console.WriteLine($"[JackpotReader:{platform}] {jackpotType} = {value.Value / 100:F2} via selector #{i + 1}");
					return value.Value / 100;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[JackpotReader:{platform}] Selector #{i + 1} failed for {jackpotType}: {ex.Message}");
			}
		}

		Console.WriteLine($"[JackpotReader:{platform}] {jackpotType} = 0 (all {expressions.Count} selectors returned 0 — expected for Canvas games)");
		return 0;
	}

	/// <summary>
	/// Reads all four jackpot tiers via CDP for the given platform.
	/// Returns (Grand, Major, Minor, Mini) — all may be 0 for Canvas games.
	/// </summary>
	public async Task<(double Grand, double Major, double Minor, double Mini)> ReadAllJackpotsAsync(
		ICdpClient cdp,
		string platform,
		CancellationToken ct = default)
	{
		double grand = await ReadJackpotAsync(cdp, platform, "Grand", ct);
		double major = await ReadJackpotAsync(cdp, platform, "Major", ct);
		double minor = await ReadJackpotAsync(cdp, platform, "Minor", ct);
		double mini = await ReadJackpotAsync(cdp, platform, "Mini", ct);
		return (grand, major, minor, mini);
	}

	/// <summary>
	/// Cross-validates CDP-read jackpot values against API values.
	/// Logs discrepancies but does NOT block execution — API is authoritative.
	/// </summary>
	public void CrossValidate(
		string platform,
		(double Grand, double Major, double Minor, double Mini) cdpValues,
		(double Grand, double Major, double Minor, double Mini) apiValues)
	{
		bool cdpHasData = cdpValues.Grand > 0 || cdpValues.Major > 0 || cdpValues.Minor > 0 || cdpValues.Mini > 0;

		if (!cdpHasData)
		{
			Console.WriteLine($"[JackpotReader:{platform}] CDP returned all zeros — Canvas game, API is sole source (expected)");
			return;
		}

		ValidateTier(platform, "Grand", cdpValues.Grand, apiValues.Grand);
		ValidateTier(platform, "Major", cdpValues.Major, apiValues.Major);
		ValidateTier(platform, "Minor", cdpValues.Minor, apiValues.Minor);
		ValidateTier(platform, "Mini", cdpValues.Mini, apiValues.Mini);
	}

	private static void ValidateTier(string platform, string tier, double cdpValue, double apiValue)
	{
		if (cdpValue <= 0 || apiValue <= 0)
			return;

		double diff = Math.Abs(cdpValue - apiValue);
		double pct = apiValue > 0 ? (diff / apiValue) * 100 : 0;

		if (pct > 10)
		{
			Console.WriteLine($"[JackpotReader:{platform}] WARNING: {tier} mismatch — CDP={cdpValue:F2} API={apiValue:F2} (diff={pct:F1}%)");
		}
		else
		{
			Console.WriteLine($"[JackpotReader:{platform}] {tier} validated — CDP={cdpValue:F2} API={apiValue:F2} (diff={pct:F1}%)");
		}
	}
}
