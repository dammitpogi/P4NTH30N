using System;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;

namespace P4NTH30N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: CDP-based spin execution for E2E testing.
/// Executes a spin via the game platform's spin button and monitors results.
/// </summary>
public sealed class SpinExecutor
{
	private readonly CdpTestClient _cdpTest;
	private readonly int _spinWaitMs;
	private readonly int _postSpinDelayMs;

	public SpinExecutor(CdpTestClient cdpTest, int spinWaitMs = 5000, int postSpinDelayMs = 3000)
	{
		_cdpTest = cdpTest ?? throw new ArgumentNullException(nameof(cdpTest));
		_spinWaitMs = spinWaitMs;
		_postSpinDelayMs = postSpinDelayMs;
	}

	/// <summary>
	/// Executes a spin for the specified game platform.
	/// </summary>
	public async Task<SpinResult> ExecuteSpinAsync(string game, CancellationToken ct = default)
	{
		SpinResult result = new() { Game = game };
		Stopwatch sw = Stopwatch.StartNew();

		try
		{
			ICdpClient cdp = _cdpTest.GetInnerClient();

			// Capture pre-spin screenshot
			result.PreSpinScreenshot = await _cdpTest.CaptureScreenshotAsync(ct);

			// Execute spin based on game platform
			switch (game)
			{
				case "FireKirin":
					await CdpGameActions.SpinFireKirinAsync(cdp, ct);
					break;
				case "OrionStars":
					await CdpGameActions.SpinOrionStarsAsync(cdp, ct);
					break;
				default:
					result.Success = false;
					result.ErrorMessage = $"Unsupported game: {game}";
					return result;
			}

			// Wait for spin animation to complete
			await Task.Delay(_spinWaitMs, ct);

			// Capture post-spin screenshot
			result.PostSpinScreenshot = await _cdpTest.CaptureScreenshotAsync(ct);

			// Wait for any win animations
			await Task.Delay(_postSpinDelayMs, ct);

			// Final state capture
			result.FinalScreenshot = await _cdpTest.CaptureScreenshotAsync(ct);

			result.Success = true;
			Console.WriteLine($"[SpinExecutor] {game} spin executed successfully");
		}
		catch (Exception ex)
		{
			result.Success = false;
			result.ErrorMessage = ex.Message;
			Console.WriteLine($"[SpinExecutor] {game} spin failed: {ex.Message}");
		}

		sw.Stop();
		result.DurationMs = sw.ElapsedMilliseconds;
		return result;
	}
}

/// <summary>
/// Result of a spin execution.
/// </summary>
public sealed class SpinResult
{
	public string Game { get; set; } = string.Empty;
	public bool Success { get; set; }
	public long DurationMs { get; set; }
	public string? ErrorMessage { get; set; }
	public string? PreSpinScreenshot { get; set; }
	public string? PostSpinScreenshot { get; set; }
	public string? FinalScreenshot { get; set; }
}
