using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Navigation;
using P4NTH30N.H4ND.Navigation.Retry;

namespace P4NTH30N.H4ND.SmokeTest.Phases;

/// <summary>
/// ARCH-099: Phase 3 — Execute Login phase from NavigationMap with 6-strategy Canvas typing.
/// Uses StepExecutor + NavigationMapLoader to drive the login sequence.
/// Falls back to CdpGameActions.LoginFireKirinAsync if no NavigationMap is available.
/// </summary>
public sealed class LoginPhase : ISmokeTestPhase
{
	private readonly SmokeTestConfig _config;
	private readonly Func<ICdpClient> _getCdpClient;
	private readonly NavigationMapLoader _mapLoader;
	private readonly IStepExecutor _stepExecutor;

	public string Name => "Login";
	public int PhaseNumber => 3;
	public int FailureExitCode => 4;

	public LoginPhase(
		SmokeTestConfig config,
		Func<ICdpClient> getCdpClient,
		NavigationMapLoader mapLoader,
		IStepExecutor stepExecutor)
	{
		_config = config;
		_getCdpClient = getCdpClient;
		_mapLoader = mapLoader;
		_stepExecutor = stepExecutor;
	}

	public async Task<PhaseReport> ExecuteAsync(CancellationToken ct)
	{
		var sw = System.Diagnostics.Stopwatch.StartNew();

		try
		{
			var cdp = _getCdpClient();
			string username = _config.Username ?? string.Empty;
			string password = _config.Password ?? string.Empty;

			if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
			{
				sw.Stop();
				return new PhaseReport
				{
					Name = Name,
					Success = false,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					ErrorMessage = "No credentials available — provide --username/--password or ensure MongoDB has enabled credentials",
				};
			}

			// Try NavigationMap first
			var map = _mapLoader.Load(_config.Platform);
			if (map != null)
			{
				var context = new StepExecutionContext
				{
					CdpClient = cdp,
					Platform = _config.Platform,
					WorkerId = "smoke-test",
					Username = username,
					Password = password,
					Variables = new Dictionary<string, string>
					{
						["username"] = username,
						["password"] = password,
					},
				};

				var phaseResult = await _stepExecutor.ExecutePhaseAsync(map, "Login", context, ct);

				sw.Stop();

				if (phaseResult.Success)
				{
					return new PhaseReport
					{
						Name = Name,
						Success = true,
						DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
						Detail = $"Login sequence completed ({phaseResult.StepResults.Count} steps)",
					};
				}

				return new PhaseReport
				{
					Name = Name,
					Success = false,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					ErrorMessage = $"NavigationMap Login phase failed: {phaseResult.ErrorMessage}",
				};
			}

			// Fallback: use CdpGameActions directly
			Console.WriteLine("[SmokeTest] No NavigationMap found — falling back to CdpGameActions login");
			bool loginOk = _config.Platform.ToLowerInvariant() switch
			{
				"firekirin" => await P4NTH30N.H4ND.Infrastructure.CdpGameActions.LoginFireKirinAsync(cdp, username, password, ct),
				"orionstars" => await P4NTH30N.H4ND.Infrastructure.CdpGameActions.LoginOrionStarsAsync(cdp, username, password, ct),
				_ => false,
			};

			sw.Stop();

			if (loginOk)
			{
				return new PhaseReport
				{
					Name = Name,
					Success = true,
					DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
					Detail = "Login completed via CdpGameActions fallback",
				};
			}

			return new PhaseReport
			{
				Name = Name,
				Success = false,
				DurationSeconds = Math.Round(sw.Elapsed.TotalSeconds, 1),
				ErrorMessage = "Login failed via CdpGameActions fallback",
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
