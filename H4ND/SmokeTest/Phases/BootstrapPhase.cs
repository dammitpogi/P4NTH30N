using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Parallel;

namespace P4NTH30N.H4ND.SmokeTest.Phases;

/// <summary>
/// ARCH-099: Phase 1 — Launch Chrome Profile-W0, connect CDP, verify canvas bounds.
/// </summary>
public sealed class BootstrapPhase : ISmokeTestPhase
{
	private readonly SmokeTestConfig _config;
	private readonly ChromeProfileManager _profileManager;
	private readonly Action<CdpConfig> _onCdpConfigReady;
	private readonly Action<ICdpClient> _onCdpClientReady;
	private readonly Action<CanvasBounds> _onCanvasBoundsReady;

	public string Name => "Bootstrap";
	public int PhaseNumber => 1;
	public int FailureExitCode => 1;

	public BootstrapPhase(
		SmokeTestConfig config,
		ChromeProfileManager profileManager,
		Action<CdpConfig> onCdpConfigReady,
		Action<ICdpClient> onCdpClientReady,
		Action<CanvasBounds> onCanvasBoundsReady)
	{
		_config = config;
		_profileManager = profileManager;
		_onCdpConfigReady = onCdpConfigReady;
		_onCdpClientReady = onCdpClientReady;
		_onCanvasBoundsReady = onCanvasBoundsReady;
	}

	public async Task<PhaseReport> ExecuteAsync(CancellationToken ct)
	{
		var sw = System.Diagnostics.Stopwatch.StartNew();

		try
		{
			// Launch Chrome with isolated profile
			var cdpConfig = await _profileManager.LaunchWithProfileAsync(_config.WorkerId, ct);
			_onCdpConfigReady(cdpConfig);

			// Connect CdpClient
			var cdpClient = new CdpClient(cdpConfig);
			bool connected = await cdpClient.ConnectAsync(ct);
			if (!connected)
			{
				sw.Stop();
				return new PhaseReport
				{
					Name = Name,
					Success = false,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					ErrorMessage = $"CDP connection failed on port {cdpConfig.Port}",
				};
			}

			_onCdpClientReady(cdpClient);

			// Navigate to platform URL so canvas is available
			string url = _config.GetPlatformUrl();
			await cdpClient.NavigateAsync(url, ct);
			await Task.Delay(3000, ct);

			// Verify canvas bounds
			var bounds = await CdpGameActions.GetCanvasBoundsAsync(cdpClient, ct);
			_onCanvasBoundsReady(bounds);

			sw.Stop();
			string boundsStr = bounds.IsValid
				? $"{bounds.Width:F0}x{bounds.Height:F0}"
				: "not yet available (will retry)";

			return new PhaseReport
			{
				Name = Name,
				Success = true,
				DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
				Detail = $"Chrome {_config.Profile} on port {cdpConfig.Port}, bounds: {boundsStr}",
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
