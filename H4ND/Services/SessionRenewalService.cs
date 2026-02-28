using System.Net;
using System.Security.Cryptography;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;
using CommonErrorSeverity = P4NTHE0N.C0MMON.ErrorSeverity;

namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// AUTH-041: Session renewal and authentication recovery service.
/// Detects 403/401 failures, attempts credential refresh, and falls back
/// across platforms (OrionStars → FireKirin) when sessions expire.
/// </summary>
public sealed class SessionRenewalService
{
	private readonly IUnitOfWork _uow;
	private readonly SessionRenewalConfig _config;
	private readonly IErrorEvidence _errors;
	private readonly Dictionary<string, PlatformHealth> _platformHealth = new();
	private DateTime _lastHealthCheck = DateTime.MinValue;

	public SessionRenewalService(IUnitOfWork uow, SessionRenewalConfig? config = null, IErrorEvidence? errors = null)
	{
		_uow = uow;
		_config = config ?? new SessionRenewalConfig();
		_errors = errors ?? NoopErrorEvidence.Instance;

		foreach (string platform in _config.PlatformFallbackOrder)
		{
			_platformHealth[platform] = new PlatformHealth { Platform = platform };
		}
	}

	/// <summary>
	/// AUTH-041-001: Tests whether a platform is reachable by probing its config endpoint.
	/// Returns true if HTTP 200, false on 403/401/timeout.
	/// </summary>
	public async Task<PlatformProbeResult> ProbePlatformAsync(string platform, CancellationToken ct = default)
	{
		using ErrorScope scope = _errors.BeginScope(
			"SessionRenewalService",
			"ProbePlatformAsync",
			new Dictionary<string, object>
			{
				["platform"] = platform,
			});

		string configUrl = platform switch
		{
			"FireKirin" => "http://play.firekirin.in/web_mobile/plat/config/hall/firekirin/config.json",
			"OrionStars" => "http://web.orionstars.org/hot_play/plat/config/hall/orionstars/config.json",
			_ => throw new ArgumentException($"Unknown platform: {platform}"),
		};

		try
		{
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(_config.ProbeTimeoutSeconds) };
			var response = await http.GetAsync(configUrl, ct);

			var result = new PlatformProbeResult
			{
				Platform = platform,
				StatusCode = (int)response.StatusCode,
				IsReachable = response.IsSuccessStatusCode,
				ProbedAt = DateTime.UtcNow,
			};

			// Update health tracking
			if (_platformHealth.TryGetValue(platform, out var health))
			{
				health.LastProbeAt = DateTime.UtcNow;
				health.LastStatusCode = result.StatusCode;
				health.IsHealthy = result.IsReachable;
				if (!result.IsReachable) health.ConsecutiveFailures++;
				else health.ConsecutiveFailures = 0;
			}

			Console.WriteLine($"[SessionRenewal] Probe {platform}: HTTP {result.StatusCode} ({(result.IsReachable ? "OK" : "FAILED")})");
			if (!result.IsReachable)
			{
				_errors.CaptureWarning(
					"H4ND-SESSION-PROBE-001",
					$"Platform probe failed with HTTP {result.StatusCode}",
					context: new Dictionary<string, object>
					{
						["platform"] = platform,
						["statusCode"] = result.StatusCode,
						["url"] = configUrl,
					});
			}

			return result;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SessionRenewal] Probe {platform} error: {ex.Message}");
			_errors.Capture(
				ex,
				"H4ND-SESSION-PROBE-002",
				"Platform probe threw exception",
				context: new Dictionary<string, object>
				{
					["platform"] = platform,
					["url"] = configUrl,
				},
				severity: Infrastructure.Logging.ErrorEvidence.ErrorSeverity.Warning);

			if (_platformHealth.TryGetValue(platform, out var health))
			{
				health.LastProbeAt = DateTime.UtcNow;
				health.IsHealthy = false;
				health.ConsecutiveFailures++;
				health.LastError = ex.Message;
			}

			return new PlatformProbeResult
			{
				Platform = platform,
				StatusCode = 0,
				IsReachable = false,
				ErrorMessage = ex.Message,
				ProbedAt = DateTime.UtcNow,
			};
		}
	}

	/// <summary>
	/// AUTH-041-002: Attempts credential refresh by querying balances via WebSocket API.
	/// This validates whether the credential can actually authenticate.
	/// </summary>
	public CredentialRefreshResult RefreshCredential(Credential credential)
	{
		using ErrorScope scope = _errors.BeginScope(
			"SessionRenewalService",
			"RefreshCredential",
			new Dictionary<string, object>
			{
				["credentialId"] = credential._id.ToString(),
				["house"] = credential.House,
				["game"] = credential.Game,
				["usernameHash"] = HashForEvidence(credential.Username),
			});

		try
		{
			var balances = credential.Game switch
			{
				"FireKirin" => CastBalances(FireKirin.QueryBalances(credential.Username, credential.Password)),
				"OrionStars" => CastBalances(OrionStars.QueryBalances(credential.Username, credential.Password)),
				_ => throw new Exception($"Unknown game: {credential.Game}"),
			};

			return new CredentialRefreshResult
			{
				Success = true,
				Credential = credential,
				Balance = balances.Balance,
				RefreshedAt = DateTime.UtcNow,
			};
		}
		catch (InvalidOperationException ex) when (ex.Message.Contains("suspended"))
		{
			_errors.CaptureWarning(
				"H4ND-SESSION-REFRESH-001",
				"Credential refresh detected suspended account",
				context: new Dictionary<string, object>
				{
					["credentialId"] = credential._id.ToString(),
					["house"] = credential.House,
					["game"] = credential.Game,
					["usernameHash"] = HashForEvidence(credential.Username),
				});

			return new CredentialRefreshResult
			{
				Success = false,
				Credential = credential,
				ErrorMessage = $"Account suspended: {ex.Message}",
				IsBanned = true,
			};
		}
		catch (Exception ex)
		{
			_errors.Capture(
				ex,
				"H4ND-SESSION-REFRESH-002",
				"Credential refresh failed",
				context: new Dictionary<string, object>
				{
					["credentialId"] = credential._id.ToString(),
					["house"] = credential.House,
					["game"] = credential.Game,
					["usernameHash"] = HashForEvidence(credential.Username),
				},
				severity: Infrastructure.Logging.ErrorEvidence.ErrorSeverity.Warning);

			return new CredentialRefreshResult
			{
				Success = false,
				Credential = credential,
				ErrorMessage = ex.Message,
			};
		}
	}

	/// <summary>
	/// AUTH-041-003: Full session renewal attempt with retries.
	/// Tries up to MaxRenewalAttempts times with exponential backoff.
	/// </summary>
	public async Task<SessionRenewalResult> RenewSessionAsync(string platform, CancellationToken ct = default)
	{
		using ErrorScope scope = _errors.BeginScope(
			"SessionRenewalService",
			"RenewSessionAsync",
			new Dictionary<string, object>
			{
				["platform"] = platform,
				["maxAttempts"] = _config.MaxRenewalAttempts,
			});

		Console.WriteLine($"[SessionRenewal] Attempting session renewal for {platform}");

		for (int attempt = 1; attempt <= _config.MaxRenewalAttempts; attempt++)
		{
			if (ct.IsCancellationRequested) break;

			// Probe platform first
			var probe = await ProbePlatformAsync(platform, ct);
			if (!probe.IsReachable)
			{
				Console.WriteLine($"[SessionRenewal] {platform} unreachable (attempt {attempt}/{_config.MaxRenewalAttempts})");

				if (attempt < _config.MaxRenewalAttempts)
				{
					int delayMs = (int)(1000 * Math.Pow(2, attempt - 1));
					await Task.Delay(Math.Min(delayMs, 15000), ct);
				}
				continue;
			}

			// Platform is reachable — try a credential refresh
			var credentials = _uow.Credentials.GetAllEnabledFor("", platform);
			if (credentials.Count == 0)
			{
				// Try any house for this game
				var allCreds = _uow.Credentials.GetAll()
					.Where(c => c.Game == platform && c.Enabled && !c.Banned)
					.Take(3)
					.ToList();
				credentials = allCreds;
			}

			foreach (var cred in credentials.Take(3))
			{
				var refreshResult = RefreshCredential(cred);
				if (refreshResult.Success)
				{
					Console.WriteLine($"[SessionRenewal] {platform} renewed via {cred.Username} (balance: ${refreshResult.Balance:F2})");

					if (_platformHealth.TryGetValue(platform, out var health))
					{
						health.IsHealthy = true;
						health.ConsecutiveFailures = 0;
						health.LastSuccessAt = DateTime.UtcNow;
					}

					return new SessionRenewalResult
					{
						Success = true,
						Platform = platform,
						Credential = cred,
						Balance = refreshResult.Balance,
						AttemptsUsed = attempt,
					};
				}

				if (refreshResult.IsBanned)
				{
					cred.Banned = true;
					_uow.Credentials.Upsert(cred);
					Console.WriteLine($"[SessionRenewal] {cred.Username} banned — skipping");
				}
			}

			if (attempt < _config.MaxRenewalAttempts)
			{
				int delayMs = (int)(1000 * Math.Pow(2, attempt - 1));
				await Task.Delay(Math.Min(delayMs, 15000), ct);
			}
		}

		return new SessionRenewalResult
		{
			Success = false,
			Platform = platform,
			ErrorMessage = $"Session renewal failed after {_config.MaxRenewalAttempts} attempts",
		};
	}

	/// <summary>
	/// AUTH-041-004: Attempts platform fallback in configured order.
	/// If the primary platform fails, tries alternatives.
	/// Returns the first working platform or failure.
	/// </summary>
	public async Task<PlatformFallbackResult> FindWorkingPlatformAsync(CancellationToken ct = default)
	{
		using ErrorScope scope = _errors.BeginScope(
			"SessionRenewalService",
			"FindWorkingPlatformAsync",
			new Dictionary<string, object>
			{
				["fallbackOrder"] = string.Join("|", _config.PlatformFallbackOrder),
			});

		Console.WriteLine($"[SessionRenewal] Searching for working platform (order: {string.Join(" → ", _config.PlatformFallbackOrder)})");

		foreach (string platform in _config.PlatformFallbackOrder)
		{
			var renewResult = await RenewSessionAsync(platform, ct);
			if (renewResult.Success)
			{
				return new PlatformFallbackResult
				{
					Success = true,
					Platform = platform,
					Credential = renewResult.Credential,
					Balance = renewResult.Balance,
					FallbacksAttempted = _config.PlatformFallbackOrder.TakeWhile(p => p != platform).Count(),
				};
			}
		}

		Console.WriteLine("[SessionRenewal] ALL PLATFORMS FAILED — operator intervention required");
		_uow.Errors.Insert(
			ErrorLog.Create(ErrorType.SystemError, "SessionRenewal", "All platforms failed session renewal — operator intervention required", CommonErrorSeverity.Critical)
		);

		_errors.CaptureInvariantFailure(
			"H4ND-SESSION-FALLBACK-001",
			"All platforms exhausted during session fallback",
			expected: "AnyHealthyPlatform",
			actual: "None",
			context: new Dictionary<string, object>
			{
				["attemptedPlatforms"] = string.Join("|", _config.PlatformFallbackOrder),
				["count"] = _config.PlatformFallbackOrder.Length,
			});

		return new PlatformFallbackResult
		{
			Success = false,
			ErrorMessage = "All platforms exhausted",
			FallbacksAttempted = _config.PlatformFallbackOrder.Length,
		};
	}

	/// <summary>
	/// AUTH-041-003: Periodic health check of all platforms.
	/// Should be called every HealthCheckIntervalMinutes.
	/// </summary>
	public async Task<Dictionary<string, PlatformHealth>> RunHealthCheckAsync(CancellationToken ct = default)
	{
		if ((DateTime.UtcNow - _lastHealthCheck).TotalMinutes < _config.HealthCheckIntervalMinutes)
		{
			return new Dictionary<string, PlatformHealth>(_platformHealth);
		}

		_lastHealthCheck = DateTime.UtcNow;

		foreach (string platform in _config.PlatformFallbackOrder)
		{
			await ProbePlatformAsync(platform, ct);
		}

		return new Dictionary<string, PlatformHealth>(_platformHealth);
	}

	/// <summary>
	/// AUTH-041-001: Determines if an exception indicates a session/auth failure.
	/// Used by callers to decide whether to trigger renewal.
	/// </summary>
	public static bool IsSessionFailure(Exception ex)
	{
		string msg = ex.Message.ToLowerInvariant();
		return msg.Contains("403")
			|| msg.Contains("401")
			|| msg.Contains("forbidden")
			|| msg.Contains("unauthorized")
			|| msg.Contains("session expired")
			|| msg.Contains("login failed")
			|| msg.Contains("server is busy");
	}

	/// <summary>
	/// Gets current health status for all platforms.
	/// </summary>
	public IReadOnlyDictionary<string, PlatformHealth> GetHealthStatus() =>
		new Dictionary<string, PlatformHealth>(_platformHealth);

	private static (double Balance, double Grand, double Major, double Minor, double Mini) CastBalances(dynamic b)
	{
		return ((double)b.Balance, (double)b.Grand, (double)b.Major, (double)b.Minor, (double)b.Mini);
	}

	private static string HashForEvidence(string input)
	{
		if (string.IsNullOrWhiteSpace(input))
		{
			return string.Empty;
		}

		byte[] bytes = SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(input));
		return Convert.ToHexString(bytes).Substring(0, 16);
	}
}

/// <summary>
/// AUTH-041: Configuration for session renewal behavior.
/// </summary>
public sealed class SessionRenewalConfig
{
	public int MaxRenewalAttempts { get; set; } = 3;
	public int ProbeTimeoutSeconds { get; set; } = 10;
	public double HealthCheckIntervalMinutes { get; set; } = 5;
	public string[] PlatformFallbackOrder { get; set; } = ["FireKirin", "OrionStars"];
}

/// <summary>
/// Result of a platform HTTP probe.
/// </summary>
public sealed class PlatformProbeResult
{
	public string Platform { get; init; } = string.Empty;
	public int StatusCode { get; init; }
	public bool IsReachable { get; init; }
	public string? ErrorMessage { get; init; }
	public DateTime ProbedAt { get; init; }
}

/// <summary>
/// Result of a credential refresh (WebSocket balance query).
/// </summary>
public sealed class CredentialRefreshResult
{
	public bool Success { get; init; }
	public Credential? Credential { get; init; }
	public double Balance { get; init; }
	public string? ErrorMessage { get; init; }
	public bool IsBanned { get; init; }
	public DateTime RefreshedAt { get; init; }
}

/// <summary>
/// Result of a full session renewal attempt.
/// </summary>
public sealed class SessionRenewalResult
{
	public bool Success { get; init; }
	public string Platform { get; init; } = string.Empty;
	public Credential? Credential { get; init; }
	public double Balance { get; init; }
	public int AttemptsUsed { get; init; }
	public string? ErrorMessage { get; init; }
}

/// <summary>
/// Result of platform fallback search.
/// </summary>
public sealed class PlatformFallbackResult
{
	public bool Success { get; init; }
	public string? Platform { get; init; }
	public Credential? Credential { get; init; }
	public double Balance { get; init; }
	public int FallbacksAttempted { get; init; }
	public string? ErrorMessage { get; init; }
}

/// <summary>
/// Health status tracking for a single platform.
/// </summary>
public sealed class PlatformHealth
{
	public string Platform { get; set; } = string.Empty;
	public bool IsHealthy { get; set; } = true;
	public int LastStatusCode { get; set; }
	public int ConsecutiveFailures { get; set; }
	public DateTime? LastProbeAt { get; set; }
	public DateTime? LastSuccessAt { get; set; }
	public string? LastError { get; set; }
}
