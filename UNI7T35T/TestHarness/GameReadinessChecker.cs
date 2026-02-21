using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;

namespace P4NTH30N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Verifies game page load and jackpot availability after login.
/// Uses CDP page readiness checks and WebSocket API balance queries.
/// </summary>
public sealed class GameReadinessChecker
{
	private readonly CdpTestClient _cdpTest;
	private readonly int _maxAttempts;
	private readonly int _delayBetweenAttemptsMs;

	public GameReadinessChecker(CdpTestClient cdpTest, int maxAttempts = 20, int delayBetweenAttemptsMs = 500)
	{
		_cdpTest = cdpTest ?? throw new ArgumentNullException(nameof(cdpTest));
		_maxAttempts = maxAttempts;
		_delayBetweenAttemptsMs = delayBetweenAttemptsMs;
	}

	/// <summary>
	/// Checks that the game page is loaded and ready for interaction.
	/// </summary>
	public async Task<GameReadinessResult> CheckReadinessAsync(string game, GameSelectors? selectors = null, CancellationToken ct = default)
	{
		GameReadinessResult result = new() { Game = game };
		ICdpClient cdp = _cdpTest.GetInnerClient();

		for (int attempt = 1; attempt <= _maxAttempts; attempt++)
		{
			try
			{
				bool ready = await CdpGameActions.VerifyGamePageLoadedAsync(cdp, game, selectors, ct);
				if (ready)
				{
					result.PageReady = true;
					result.AttemptsNeeded = attempt;
					Console.WriteLine($"[GameReadinessChecker] {game} page ready after {attempt} attempt(s)");
					break;
				}
			}
			catch (Exception ex)
			{
				result.LastError = ex.Message;
			}

			if (attempt < _maxAttempts)
				await Task.Delay(_delayBetweenAttemptsMs, ct);
		}

		if (!result.PageReady)
		{
			Console.WriteLine($"[GameReadinessChecker] {game} page NOT ready after {_maxAttempts} attempts");
			result.AttemptsNeeded = _maxAttempts;
		}

		// Try reading jackpots via CDP (secondary validation)
		try
		{
			var jackpots = await CdpGameActions.ReadJackpotsViaCdpAsync(cdp, selectors, ct);
			result.CdpGrand = jackpots.Grand;
			result.CdpMajor = jackpots.Major;
			result.CdpMinor = jackpots.Minor;
			result.CdpMini = jackpots.Mini;
			result.JackpotsAvailableViaCdp = jackpots.Grand > 0 || jackpots.Major > 0 || jackpots.Minor > 0 || jackpots.Mini > 0;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[GameReadinessChecker] CDP jackpot read failed (expected for Canvas games): {ex.Message}");
			result.JackpotsAvailableViaCdp = false;
		}

		// Capture readiness screenshot
		result.ScreenshotBase64 = await _cdpTest.CaptureScreenshotAsync(ct);

		return result;
	}
}

/// <summary>
/// Result of a game readiness check.
/// </summary>
public sealed class GameReadinessResult
{
	public string Game { get; set; } = string.Empty;
	public bool PageReady { get; set; }
	public int AttemptsNeeded { get; set; }
	public bool JackpotsAvailableViaCdp { get; set; }
	public double CdpGrand { get; set; }
	public double CdpMajor { get; set; }
	public double CdpMinor { get; set; }
	public double CdpMini { get; set; }
	public string? ScreenshotBase64 { get; set; }
	public string? LastError { get; set; }
}
