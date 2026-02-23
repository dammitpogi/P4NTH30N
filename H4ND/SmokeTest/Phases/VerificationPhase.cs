using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.SmokeTest.Phases;

/// <summary>
/// ARCH-099: Phase 4 — Verify login success by querying balance via CDP.
/// Retries up to BalanceRetryCount times with delay between attempts.
/// </summary>
public sealed class VerificationPhase : ISmokeTestPhase
{
	private readonly SmokeTestConfig _config;
	private readonly Func<ICdpClient> _getCdpClient;
	private readonly Action<double> _onBalanceReady;

	public string Name => "Verification";
	public int PhaseNumber => 4;
	public int FailureExitCode => 5;

	public VerificationPhase(
		SmokeTestConfig config,
		Func<ICdpClient> getCdpClient,
		Action<double> onBalanceReady)
	{
		_config = config;
		_getCdpClient = getCdpClient;
		_onBalanceReady = onBalanceReady;
	}

	public async Task<PhaseReport> ExecuteAsync(CancellationToken ct)
	{
		var sw = System.Diagnostics.Stopwatch.StartNew();

		try
		{
			var cdp = _getCdpClient();

			// Wait for WebSocket to settle after login
			await Task.Delay(_config.BalanceRetryDelayMs, ct);

			double balance = 0;
			int attempts = 0;

			for (int i = 0; i < _config.BalanceRetryCount; i++)
			{
				ct.ThrowIfCancellationRequested();
				attempts++;

				// Try window.parent.Balance (set by Resource Override extension or WebSocket interceptor)
				balance = await TryReadBalanceAsync(cdp, ct);

				if (balance > 0)
					break;

				if (i < _config.BalanceRetryCount - 1)
				{
					Console.WriteLine($"[SmokeTest] Balance = {balance}, retrying in {_config.BalanceRetryDelayMs}ms (attempt {attempts}/{_config.BalanceRetryCount})");
					await Task.Delay(_config.BalanceRetryDelayMs, ct);
				}
			}

			_onBalanceReady(balance);
			sw.Stop();

			if (balance > 0)
			{
				return new PhaseReport
				{
					Name = Name,
					Success = true,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					Detail = $"Login verified, balance: ${balance:F2}",
				};
			}

			return new PhaseReport
			{
				Name = Name,
				Success = false,
				DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
				ErrorMessage = $"Balance = {balance} after {attempts} attempts — authentication may have failed",
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

	private static async Task<double> TryReadBalanceAsync(ICdpClient cdp, CancellationToken ct)
	{
		// Strategy 1: window.parent.Balance (Resource Override extension)
		try
		{
			double? val = await cdp.EvaluateAsync<double>("Number(window.parent.Balance) || 0", ct);
			if (val.HasValue && val.Value > 0)
				return val.Value;
		}
		catch { /* try next */ }

		// Strategy 2: window.Balance (some pages expose directly)
		try
		{
			double? val = await cdp.EvaluateAsync<double>("Number(window.Balance) || 0", ct);
			if (val.HasValue && val.Value > 0)
				return val.Value;
		}
		catch { /* try next */ }

		// Strategy 3: Check for Cocos2d-x player credit
		try
		{
			double? val = await cdp.EvaluateAsync<double>(
				"(function(){ try { return cc.game._scene._player._credit.value || 0; } catch(e) { return 0; } })()", ct);
			if (val.HasValue && val.Value > 0)
				return val.Value;
		}
		catch { /* exhausted */ }

		return 0;
	}
}
