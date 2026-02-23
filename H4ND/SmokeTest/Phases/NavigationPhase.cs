using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;

namespace P4NTH30N.H4ND.SmokeTest.Phases;

/// <summary>
/// ARCH-099: Phase 2 — Verify FireKirin page loads with canvas element.
/// </summary>
public sealed class NavigationPhase : ISmokeTestPhase
{
	private readonly SmokeTestConfig _config;
	private readonly Func<ICdpClient> _getCdpClient;
	private readonly Action<CanvasBounds> _onCanvasBoundsReady;

	public string Name => "Navigation";
	public int PhaseNumber => 2;
	public int FailureExitCode => 2;

	public NavigationPhase(
		SmokeTestConfig config,
		Func<ICdpClient> getCdpClient,
		Action<CanvasBounds> onCanvasBoundsReady)
	{
		_config = config;
		_getCdpClient = getCdpClient;
		_onCanvasBoundsReady = onCanvasBoundsReady;
	}

	public async Task<PhaseReport> ExecuteAsync(CancellationToken ct)
	{
		var sw = System.Diagnostics.Stopwatch.StartNew();

		try
		{
			var cdp = _getCdpClient();

			// Wait for document.readyState == "complete"
			int maxWaitMs = _config.PageLoadTimeoutSeconds * 1000;
			int waited = 0;
			bool pageReady = false;

			while (waited < maxWaitMs)
			{
				ct.ThrowIfCancellationRequested();
				string? readyState = await cdp.EvaluateAsync<string>("document.readyState", ct);
				if (readyState == "complete")
				{
					pageReady = true;
					break;
				}
				await Task.Delay(500, ct);
				waited += 500;
			}

			if (!pageReady)
			{
				sw.Stop();
				return new PhaseReport
				{
					Name = Name,
					Success = false,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					ErrorMessage = $"Page load timeout after {_config.PageLoadTimeoutSeconds}s",
				};
			}

			// Extra delay for Cocos2d-x framework initialization
			await Task.Delay(2000, ct);

			// Verify canvas bounds
			var bounds = await CdpGameActions.GetCanvasBoundsAsync(cdp, ct);
			if (!bounds.IsValid)
			{
				// Retry once after additional wait — Cocos2d-x may still be initializing
				await Task.Delay(3000, ct);
				bounds = await CdpGameActions.GetCanvasBoundsAsync(cdp, ct);
			}

			_onCanvasBoundsReady(bounds);

			sw.Stop();

			if (!bounds.IsValid)
			{
				return new PhaseReport
				{
					Name = Name,
					Success = false,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					ErrorMessage = "Canvas bounds invalid — page may not have loaded correctly",
				};
			}

			return new PhaseReport
			{
				Name = Name,
				Success = true,
				DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
				Detail = $"Page loaded, canvas: {bounds.Width:F0}x{bounds.Height:F0}",
			};
		}
		catch (Exception ex)
		{
			sw.Stop();
			return new PhaseReport
			{
				Name = Name,
				Success = false,
				DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
				ErrorMessage = ex.Message,
			};
		}
	}
}
