using P4NTH30N.H4ND.Services;

namespace P4NTH30N.UNI7T35T.Tests;

/// <summary>
/// AUTH-041: Unit tests for SessionRenewalService components.
/// Tests config defaults, probe results, failure detection, and health tracking.
/// </summary>
public static class SessionRenewalTests
{
	public static (int passed, int failed) RunAll()
	{
		int passed = 0;
		int failed = 0;

		void Run(string name, Func<bool> test)
		{
			try
			{
				if (test())
				{
					Console.WriteLine($"  ✅ {name}");
					passed++;
				}
				else
				{
					Console.WriteLine($"  ❌ {name}");
					failed++;
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"  ❌ {name} — Exception: {ex.Message}");
				failed++;
			}
		}

		Run("Test_SessionRenewalConfig_Defaults", Test_SessionRenewalConfig_Defaults);
		Run("Test_PlatformFallbackOrder", Test_PlatformFallbackOrder);
		Run("Test_IsSessionFailure_403", Test_IsSessionFailure_403);
		Run("Test_IsSessionFailure_401", Test_IsSessionFailure_401);
		Run("Test_IsSessionFailure_Forbidden", Test_IsSessionFailure_Forbidden);
		Run("Test_IsSessionFailure_NormalException", Test_IsSessionFailure_NormalException);
		Run("Test_IsSessionFailure_ServerBusy", Test_IsSessionFailure_ServerBusy);
		Run("Test_PlatformProbeResult_Structure", Test_PlatformProbeResult_Structure);
		Run("Test_CredentialRefreshResult_Structure", Test_CredentialRefreshResult_Structure);
		Run("Test_PlatformHealth_Defaults", Test_PlatformHealth_Defaults);
		Run("Test_SessionRenewalResult_Structure", Test_SessionRenewalResult_Structure);
		Run("Test_PlatformFallbackResult_Structure", Test_PlatformFallbackResult_Structure);

		return (passed, failed);
	}

	static bool Test_SessionRenewalConfig_Defaults()
	{
		var config = new SessionRenewalConfig();
		return config.MaxRenewalAttempts == 3
			&& config.ProbeTimeoutSeconds == 10
			&& config.HealthCheckIntervalMinutes == 5
			&& config.PlatformFallbackOrder.Length == 2
			&& config.PlatformFallbackOrder[0] == "FireKirin"
			&& config.PlatformFallbackOrder[1] == "OrionStars";
	}

	static bool Test_PlatformFallbackOrder()
	{
		var config = new SessionRenewalConfig
		{
			PlatformFallbackOrder = ["OrionStars", "FireKirin"],
		};
		return config.PlatformFallbackOrder[0] == "OrionStars";
	}

	static bool Test_IsSessionFailure_403()
	{
		return SessionRenewalService.IsSessionFailure(new Exception("HTTP 403 Forbidden"));
	}

	static bool Test_IsSessionFailure_401()
	{
		return SessionRenewalService.IsSessionFailure(new Exception("HTTP 401 Unauthorized"));
	}

	static bool Test_IsSessionFailure_Forbidden()
	{
		return SessionRenewalService.IsSessionFailure(new Exception("Access forbidden by server"));
	}

	static bool Test_IsSessionFailure_NormalException()
	{
		return !SessionRenewalService.IsSessionFailure(new Exception("Network timeout"));
	}

	static bool Test_IsSessionFailure_ServerBusy()
	{
		return SessionRenewalService.IsSessionFailure(new Exception("The server is busy, Please try again later."));
	}

	static bool Test_PlatformProbeResult_Structure()
	{
		var result = new PlatformProbeResult
		{
			Platform = "FireKirin",
			StatusCode = 200,
			IsReachable = true,
			ProbedAt = DateTime.UtcNow,
		};
		return result.Platform == "FireKirin" && result.StatusCode == 200 && result.IsReachable;
	}

	static bool Test_CredentialRefreshResult_Structure()
	{
		var result = new CredentialRefreshResult
		{
			Success = false,
			ErrorMessage = "timeout",
			IsBanned = false,
		};
		return !result.Success && result.ErrorMessage == "timeout" && !result.IsBanned;
	}

	static bool Test_PlatformHealth_Defaults()
	{
		var health = new PlatformHealth { Platform = "OrionStars" };
		return health.IsHealthy && health.ConsecutiveFailures == 0 && health.LastProbeAt == null;
	}

	static bool Test_SessionRenewalResult_Structure()
	{
		var result = new SessionRenewalResult
		{
			Success = true,
			Platform = "FireKirin",
			Balance = 17.75,
			AttemptsUsed = 1,
		};
		return result.Success && result.Platform == "FireKirin" && result.Balance == 17.75 && result.AttemptsUsed == 1;
	}

	static bool Test_PlatformFallbackResult_Structure()
	{
		var result = new PlatformFallbackResult
		{
			Success = false,
			ErrorMessage = "All platforms exhausted",
			FallbacksAttempted = 2,
		};
		return !result.Success && result.FallbacksAttempted == 2;
	}
}
