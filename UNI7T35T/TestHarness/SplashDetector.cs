using System;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;

namespace P4NTHE0N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Detects jackpot splash screens via CDP.
/// Since games use Canvas rendering (Cocos2d-x), detection relies on
/// DOM state changes and timing rather than element inspection.
/// </summary>
public sealed class SplashDetector
{
	private readonly CdpTestClient _cdpTest;
	private readonly int _pollIntervalMs;
	private readonly int _maxWaitMs;

	public SplashDetector(CdpTestClient cdpTest, int pollIntervalMs = 500, int maxWaitMs = 15000)
	{
		_cdpTest = cdpTest ?? throw new ArgumentNullException(nameof(cdpTest));
		_pollIntervalMs = pollIntervalMs;
		_maxWaitMs = maxWaitMs;
	}

	/// <summary>
	/// Watches for a jackpot splash screen after a spin.
	/// Canvas games show splash overlays that can sometimes be detected via DOM changes.
	/// </summary>
	public async Task<SplashDetectionResult> DetectSplashAsync(string game, CancellationToken ct = default)
	{
		SplashDetectionResult result = new() { Game = game };
		DateTime deadline = DateTime.UtcNow.AddMilliseconds(_maxWaitMs);
		ICdpClient cdp = _cdpTest.GetInnerClient();
		int framesCaptured = 0;

		while (DateTime.UtcNow < deadline && !ct.IsCancellationRequested)
		{
			try
			{
				// Check for common splash/win overlay indicators
				// Canvas games may inject DOM elements for win celebrations
				bool? hasWinOverlay = await cdp.EvaluateAsync<bool>(
					"document.querySelector('.win-overlay, .jackpot-win, .splash-screen, [class*=\"win\"], [class*=\"jackpot\"]') !== null",
					ct
				);

				if (hasWinOverlay == true)
				{
					result.SplashDetected = true;
					result.DetectionMethod = "DOM overlay element";
					result.ScreenshotBase64 = await _cdpTest.CaptureScreenshotAsync(ct);
					Console.WriteLine($"[SplashDetector] {game}: Splash detected via DOM overlay");
					return result;
				}

				// Check for balance changes that might indicate a win
				string? balanceText = await cdp.EvaluateAsync<string>(
					"(document.querySelector('.balance-display, .user-balance, #userBalance') || {}).textContent || ''",
					ct
				);
				if (!string.IsNullOrEmpty(balanceText))
				{
					result.LastBalanceText = balanceText;
				}

				framesCaptured++;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[SplashDetector] Poll error: {ex.Message}");
			}

			await Task.Delay(_pollIntervalMs, ct);
		}

		result.SplashDetected = false;
		result.DetectionMethod = "timeout";
		result.FramesChecked = framesCaptured;
		Console.WriteLine($"[SplashDetector] {game}: No splash detected after {_maxWaitMs}ms ({framesCaptured} polls)");
		return result;
	}
}

/// <summary>
/// Result of splash detection.
/// </summary>
public sealed class SplashDetectionResult
{
	public string Game { get; set; } = string.Empty;
	public bool SplashDetected { get; set; }
	public string DetectionMethod { get; set; } = string.Empty;
	public int FramesChecked { get; set; }
	public string? ScreenshotBase64 { get; set; }
	public string? LastBalanceText { get; set; }
}
