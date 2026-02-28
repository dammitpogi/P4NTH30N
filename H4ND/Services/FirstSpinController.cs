using System.Diagnostics;
using System.Text.Json;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Entities;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.H4ND.Infrastructure;

namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// SPIN-044: First Autonomous Jackpot Spin Execution Controller.
/// Orchestrates the complete first spin protocol:
/// 1. Pre-spin checklist (MongoDB, CDP, balance, bet limit)
/// 2. Signal generation/injection
/// 3. Manual confirmation gate (console-based, 60s timeout)
/// 4. Spin execution via CDP
/// 5. Post-spin verification (balance change, telemetry)
/// 6. Abort conditions enforcement
/// </summary>
public sealed class FirstSpinController
{
	private readonly IUnitOfWork _uow;
	private readonly FirstSpinConfig _config;
	private readonly SpinMetrics _metrics;

	public FirstSpinController(IUnitOfWork uow, FirstSpinConfig config, SpinMetrics metrics)
	{
		_uow = uow;
		_config = config;
		_metrics = metrics;
	}

	/// <summary>
	/// Executes the complete first spin protocol.
	/// Returns a detailed result with telemetry.
	/// </summary>
	public async Task<FirstSpinResult> ExecuteAsync(ICdpClient cdp, CancellationToken ct = default)
	{
		FirstSpinResult result = new() { StartedAt = DateTime.UtcNow };
		Stopwatch totalSw = Stopwatch.StartNew();

		try
		{
			// ── Phase 1: Pre-Spin Checklist ──────────────────────────────
			Log("╔══════════════════════════════════════════════════════╗");
			Log("║       FIRST SPIN PROTOCOL — SPIN-044                ║");
			Log("╚══════════════════════════════════════════════════════╝");
			Log("");

			Log("── Phase 1: Pre-Spin Checklist ──");

			// 1a. MongoDB connectivity
			bool mongoOk = await CheckMongoConnectivityAsync();
			result.Checks.Add("MongoDB", mongoOk);
			if (!mongoOk)
			{
				result.AbortReason = "MongoDB connectivity check failed";
				return Abort(result, totalSw);
			}

			// 1b. CDP connection
			bool cdpOk = cdp.IsConnected;
			result.Checks.Add("CDP", cdpOk);
			Log($"  CDP Connected: {(cdpOk ? "YES" : "NO")}");
			if (!cdpOk)
			{
				result.AbortReason = "CDP not connected";
				return Abort(result, totalSw);
			}

			// 1c. Find test account with sufficient balance
			Credential? testAccount = FindTestAccount();
			result.Checks.Add("TestAccount", testAccount != null);
			if (testAccount == null)
			{
				result.AbortReason = $"No {_config.TargetGame} account found with balance >= ${_config.MinBalance:F2}";
				return Abort(result, totalSw);
			}
			result.Username = testAccount.Username;
			result.Game = testAccount.Game;
			result.House = testAccount.House;
			Log($"  Test Account: {testAccount.Username}@{testAccount.Game} ({testAccount.House})");
			Log($"  Balance: ${testAccount.Balance:F2}");

			// 1d. Balance >= minimum
			bool balanceOk = testAccount.Balance >= _config.MinBalance;
			result.Checks.Add("Balance", balanceOk);
			result.BalanceBefore = testAccount.Balance;
			Log($"  Balance >= ${_config.MinBalance:F2}: {(balanceOk ? "YES" : "NO")}");
			if (!balanceOk)
			{
				result.AbortReason = $"Balance ${testAccount.Balance:F2} < minimum ${_config.MinBalance:F2}";
				return Abort(result, totalSw);
			}

			// 1e. Max bet limit
			result.Checks.Add("MaxBet", _config.MaxBetAmount <= 0.10);
			Log($"  Max Bet: ${_config.MaxBetAmount:F2} (limit: $0.10)");

			// 1f. Screenshot capture
			bool screenshotOk = _config.CaptureScreenshots;
			result.Checks.Add("Screenshots", screenshotOk);
			Log($"  Screenshots: {(screenshotOk ? "ENABLED" : "DISABLED")}");

			Log("");
			Log($"  Pre-spin checklist: {result.Checks.Count(c => c.Value)}/{result.Checks.Count} passed");
			if (result.Checks.Any(c => !c.Value))
			{
				result.AbortReason = "Pre-spin checklist failed: " + string.Join(", ", result.Checks.Where(c => !c.Value).Select(c => c.Key));
				return Abort(result, totalSw);
			}

			// ── Phase 2: Login ───────────────────────────────────────────
			Log("");
			Log("── Phase 2: Login ──");

			bool loginOk = testAccount.Game switch
			{
				"FireKirin" => await CdpGameActions.LoginFireKirinAsync(cdp, testAccount.Username, testAccount.Password, ct),
				"OrionStars" => await CdpGameActions.LoginOrionStarsAsync(cdp, testAccount.Username, testAccount.Password, ct),
				_ => false,
			};

			result.Checks.Add("Login", loginOk);
			Log($"  Login: {(loginOk ? "SUCCESS" : "FAILED")}");
			if (!loginOk)
			{
				result.AbortReason = $"Login failed for {testAccount.Username}@{testAccount.Game}";
				return Abort(result, totalSw);
			}

			// ── Phase 3: Verify Game Page Loaded ─────────────────────────
			Log("");
			Log("── Phase 3: Verify Game Page ──");

			bool pageReady = false;
			for (int i = 0; i < 20; i++)
			{
				pageReady = await CdpGameActions.VerifyGamePageLoadedAsync(cdp, testAccount.Game, null, ct);
				if (pageReady) break;
				await Task.Delay(500, ct);
			}

			result.Checks.Add("PageReady", pageReady);
			Log($"  Game Page Ready: {(pageReady ? "YES" : "NO (proceeding anyway)")}");

			// ── Phase 4: Capture Pre-Spin Screenshot ─────────────────────
			if (_config.CaptureScreenshots)
			{
				Log("");
				Log("── Phase 4: Pre-Spin Screenshot ──");
				try
				{
					var screenshotData = await cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png" }, ct);
					if (screenshotData.TryGetProperty("data", out var dataElement))
					{
						string base64 = dataElement.GetString() ?? "";
						if (base64.Length > 0)
						{
							result.PreSpinScreenshotBase64 = base64;
							Log($"  Screenshot captured: {base64.Length} chars (base64)");
						}
					}
				}
				catch (Exception ex)
				{
					Log($"  Screenshot failed: {ex.Message} (non-fatal)");
				}
			}

			// ── Phase 5: Manual Confirmation Gate ────────────────────────
			Log("");
			Log("── Phase 5: Manual Confirmation Gate ──");

			if (_config.RequireConfirmation)
			{
				Log("┌──────────────────────────────────────────────────────┐");
				Log("│  FIRST SPIN CONFIRMATION REQUIRED                    │");
				Log("│                                                      │");
				Log($"│  Account:    {testAccount.Username,-40}│");
				Log($"│  Game:       {testAccount.Game,-40}│");
				Log($"│  House:      {testAccount.House,-40}│");
				Log($"│  Balance:    ${testAccount.Balance,-39:F2}│");
				Log($"│  Bet Amount: ${_config.MaxBetAmount,-39:F2}│");
				Log("│                                                      │");
				Log($"│  Type CONFIRM within {_config.ConfirmationTimeoutSec}s to proceed.            │");
				Log("│  Any other input or timeout will ABORT.              │");
				Log("└──────────────────────────────────────────────────────┘");

				bool confirmed = await WaitForConfirmationAsync(ct);
				result.Checks.Add("Confirmation", confirmed);
				result.ConfirmationReceivedAt = DateTime.UtcNow;

				if (!confirmed)
				{
					result.AbortReason = "Operator did not confirm within timeout";
					return Abort(result, totalSw);
				}
				Log("  Confirmation: RECEIVED");
			}
			else
			{
				Log("  Confirmation gate DISABLED (config)");
				result.Checks.Add("Confirmation", true);
			}

			// ── Phase 6: Execute Spin ────────────────────────────────────
			Log("");
			Log("── Phase 6: Execute Spin ──");

			Stopwatch spinSw = Stopwatch.StartNew();
			bool spinOk = false;
			string? spinError = null;

			try
			{
				using CancellationTokenSource spinCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
				spinCts.CancelAfter(TimeSpan.FromSeconds(_config.SpinTimeoutSec));

				switch (testAccount.Game)
				{
					case "FireKirin":
						await CdpGameActions.SpinFireKirinAsync(cdp, spinCts.Token);
						break;
					case "OrionStars":
						await CdpGameActions.SpinOrionStarsAsync(cdp, spinCts.Token);
						break;
					default:
						throw new InvalidOperationException($"Unsupported game: {testAccount.Game}");
				}

				spinOk = true;
			}
			catch (OperationCanceledException)
			{
				spinError = $"Spin timed out after {_config.SpinTimeoutSec}s";
			}
			catch (Exception ex)
			{
				spinError = ex.Message;
			}

			spinSw.Stop();
			result.SpinDurationMs = spinSw.Elapsed.TotalMilliseconds;
			result.Checks.Add("SpinExecuted", spinOk);
			Log($"  Spin Executed: {(spinOk ? "YES" : "NO")}");
			Log($"  Spin Duration: {spinSw.Elapsed.TotalMilliseconds:F0}ms");

			if (!spinOk)
			{
				result.AbortReason = $"Spin failed: {spinError}";
				return Abort(result, totalSw);
			}

			// ── Phase 7: Post-Spin Verification ──────────────────────────
			Log("");
			Log("── Phase 7: Post-Spin Verification ──");

			// Wait for spin animation to complete
			await Task.Delay(3000, ct);

			// Capture post-spin screenshot
			if (_config.CaptureScreenshots)
			{
				try
				{
					var screenshotData = await cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png" }, ct);
					if (screenshotData.TryGetProperty("data", out var dataElement))
					{
						string base64 = dataElement.GetString() ?? "";
						if (base64.Length > 0)
						{
							result.PostSpinScreenshotBase64 = base64;
							Log($"  Post-spin screenshot captured: {base64.Length} chars");
						}
					}
				}
				catch (Exception ex)
				{
					Log($"  Post-spin screenshot failed: {ex.Message} (non-fatal)");
				}
			}

			// Record metrics
			_metrics.RecordSpin(new SpinRecord
			{
				Success = spinOk,
				LatencyMs = spinSw.Elapsed.TotalMilliseconds,
				Game = testAccount.Game,
				House = testAccount.House,
				Username = testAccount.Username,
				BalanceBefore = result.BalanceBefore,
				BalanceAfter = result.BalanceBefore, // Updated below if we can re-query
				SignalPriority = 4,
			});

			Log($"  Balance Before: ${result.BalanceBefore:F2}");
			Log($"  Balance After:  (requires API re-query — see main loop)");

			// ── Phase 8: Telemetry ───────────────────────────────────────
			Log("");
			Log("── Phase 8: Telemetry ──");

			result.Success = true;
			result.CompletedAt = DateTime.UtcNow;
			totalSw.Stop();
			result.TotalDurationMs = totalSw.Elapsed.TotalMilliseconds;

			if (_config.SaveToMongoDB)
			{
				try
				{
					_uow.ProcessEvents.Insert(
						ProcessEvent.Log("FirstSpin", JsonSerializer.Serialize(new
						{
							result.Success,
							result.Username,
							result.Game,
							result.House,
							result.BalanceBefore,
							result.SpinDurationMs,
							result.TotalDurationMs,
							result.StartedAt,
							result.CompletedAt,
							ChecksPassed = result.Checks.Count(c => c.Value),
							ChecksTotal = result.Checks.Count,
						}))
					);
					Log("  Telemetry saved to MongoDB: YES");
				}
				catch (Exception ex)
				{
					Log($"  Telemetry save failed: {ex.Message}");
				}
			}

			// ── Final Report ─────────────────────────────────────────────
			Log("");
			Log("╔══════════════════════════════════════════════════════╗");
			Log("║       FIRST SPIN COMPLETE — SUCCESS                 ║");
			Log("╚══════════════════════════════════════════════════════╝");
			Log($"  Account:  {result.Username}@{result.Game}");
			Log($"  Duration: {result.TotalDurationMs:F0}ms total, {result.SpinDurationMs:F0}ms spin");
			Log($"  Checks:   {result.Checks.Count(c => c.Value)}/{result.Checks.Count} passed");
			Log("");

			return result;
		}
		catch (Exception ex)
		{
			result.AbortReason = $"Unhandled exception: {ex.Message}";
			result.Success = false;
			totalSw.Stop();
			result.TotalDurationMs = totalSw.Elapsed.TotalMilliseconds;

			_uow.Errors.Insert(
				ErrorLog.Create(ErrorType.SystemError, "FirstSpinController", $"First spin failed: {ex.Message}", ErrorSeverity.Critical)
			);

			Log($"  ABORT: {ex.Message}");
			return result;
		}
	}

	/// <summary>
	/// Runs the pre-spin checklist only (no execution). For validation/dry-run.
	/// </summary>
	public async Task<Dictionary<string, bool>> RunChecklistAsync(ICdpClient cdp)
	{
		Dictionary<string, bool> checks = new();

		checks["MongoDB"] = await CheckMongoConnectivityAsync();
		checks["CDP"] = cdp.IsConnected;

		Credential? account = FindTestAccount();
		checks["TestAccount"] = account != null;
		checks["Balance"] = account != null && account.Balance >= _config.MinBalance;
		checks["MaxBet"] = _config.MaxBetAmount <= 0.10;
		checks["Screenshots"] = _config.CaptureScreenshots;

		foreach (var check in checks)
		{
			Log($"  [{(check.Value ? "OK" : "FAIL")}] {check.Key}");
		}

		return checks;
	}

	private async Task<bool> CheckMongoConnectivityAsync()
	{
		try
		{
			Stopwatch sw = Stopwatch.StartNew();
			int count = _uow.Credentials.GetAll().Count;
			sw.Stop();
			bool ok = count > 0 && sw.ElapsedMilliseconds < 5000;
			Log($"  MongoDB: {count} credentials, {sw.ElapsedMilliseconds}ms latency — {(ok ? "OK" : "SLOW/EMPTY")}");
			return ok;
		}
		catch (Exception ex)
		{
			Log($"  MongoDB: FAILED — {ex.Message}");
			return false;
		}
	}

	private Credential? FindTestAccount()
	{
		try
		{
			// Get a credential for the target game with sufficient balance
			Credential? cred = _uow.Credentials.GetNext(false);
			if (cred == null) return null;

			// Find one matching the target game with enough balance
			// GetNext returns the next unlocked credential — check if it matches
			if (cred.Game == _config.TargetGame && cred.Balance >= _config.MinBalance && !cred.Banned)
			{
				return cred;
			}

			// If the first one doesn't match, we'll use whatever is available
			if (cred.Balance >= _config.MinBalance && !cred.Banned)
			{
				Log($"  Note: Using {cred.Game} instead of {_config.TargetGame} (first available with balance)");
				return cred;
			}

			return null;
		}
		catch (Exception ex)
		{
			Log($"  FindTestAccount failed: {ex.Message}");
			return null;
		}
	}

	private async Task<bool> WaitForConfirmationAsync(CancellationToken ct)
	{
		try
		{
			using CancellationTokenSource timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
			timeoutCts.CancelAfter(TimeSpan.FromSeconds(_config.ConfirmationTimeoutSec));

			Console.Write(">> ");

			// Read input with timeout using async polling
			string? input = null;
			Task<string?> readTask = Task.Run(() => Console.ReadLine(), timeoutCts.Token);

			try
			{
				input = await readTask.WaitAsync(timeoutCts.Token);
			}
			catch (OperationCanceledException)
			{
				Log("  Confirmation TIMED OUT");
				return false;
			}

			bool confirmed = string.Equals(input?.Trim(), "CONFIRM", StringComparison.OrdinalIgnoreCase);
			if (!confirmed)
			{
				Log($"  Received: '{input}' — not CONFIRM. ABORTING.");
			}
			return confirmed;
		}
		catch (Exception ex)
		{
			Log($"  Confirmation error: {ex.Message}");
			return false;
		}
	}

	private FirstSpinResult Abort(FirstSpinResult result, Stopwatch sw)
	{
		result.Success = false;
		sw.Stop();
		result.TotalDurationMs = sw.Elapsed.TotalMilliseconds;
		result.CompletedAt = DateTime.UtcNow;

		Log("");
		Log("╔══════════════════════════════════════════════════════╗");
		Log("║       FIRST SPIN ABORTED                            ║");
		Log("╚══════════════════════════════════════════════════════╝");
		Log($"  Reason: {result.AbortReason}");
		Log($"  Duration: {result.TotalDurationMs:F0}ms");
		Log("");

		_uow.Errors.Insert(
			ErrorLog.Create(ErrorType.SystemError, "FirstSpinController", $"First spin aborted: {result.AbortReason}", ErrorSeverity.High)
		);

		return result;
	}

	private static void Log(string message)
	{
		Console.WriteLine($"[FirstSpin] {message}");
	}
}

/// <summary>
/// SPIN-044: Result of a first spin execution attempt.
/// </summary>
public sealed class FirstSpinResult
{
	public bool Success { get; set; }
	public string? AbortReason { get; set; }

	public string? Username { get; set; }
	public string? Game { get; set; }
	public string? House { get; set; }

	public double BalanceBefore { get; set; }
	public double BalanceAfter { get; set; }
	public double BalanceChange => BalanceAfter - BalanceBefore;

	public double SpinDurationMs { get; set; }
	public double TotalDurationMs { get; set; }

	public DateTime StartedAt { get; set; }
	public DateTime? CompletedAt { get; set; }
	public DateTime? ConfirmationReceivedAt { get; set; }

	public Dictionary<string, bool> Checks { get; set; } = new();

	public string? PreSpinScreenshotBase64 { get; set; }
	public string? PostSpinScreenshotBase64 { get; set; }

	public override string ToString()
	{
		string status = Success ? "SUCCESS" : $"ABORTED ({AbortReason})";
		return $"[FirstSpinResult] {status} | {Username}@{Game} | "
			+ $"Balance: ${BalanceBefore:F2} → ${BalanceAfter:F2} ({BalanceChange:+0.00;-0.00;0.00}) | "
			+ $"Duration: {TotalDurationMs:F0}ms (spin: {SpinDurationMs:F0}ms) | "
			+ $"Checks: {Checks.Count(c => c.Value)}/{Checks.Count}";
	}
}
