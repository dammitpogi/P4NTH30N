using System.Diagnostics;
using System.Net.Http;

namespace P4NTHE0N.H4ND.Services;

/// <summary>
/// AUTO-056: Chrome CDP lifecycle manager.
/// Auto-starts Chrome with remote debugging, monitors health, restarts on crash, graceful shutdown.
/// This is the final piece that enables 24-hour unattended burn-in.
/// </summary>
public sealed class CdpLifecycleManager : ICdpLifecycleManager
{
	private readonly CdpLifecycleConfig _config;
	private readonly string _probeHost;
	private Process? _chromeProcess;
	private int _restartAttempts;
	private CdpLifecycleStatus _status = CdpLifecycleStatus.Stopped;
	private Timer? _healthCheckTimer;
	private CancellationTokenSource? _shutdownCts;
	private bool _disposed;
	private bool _intentionalStop;
	private bool _restartInProgress; // BUGFIX: Prevents parallel restart attempts
	private readonly object _lock = new();

	public CdpLifecycleManager(CdpLifecycleConfig config)
	{
		_config = config;
		// For health probes, use localhost when DebugHost is 0.0.0.0 (binds all interfaces)
		_probeHost = _config.DebugHost == "0.0.0.0" ? "127.0.0.1" : _config.DebugHost;
	}

	/// <summary>
	/// AUTO-056-001: Probes CDP at configured host:port via HTTP GET /json/version.
	/// Returns true if CDP responds with a valid JSON containing "Browser" field.
	/// </summary>
	public async Task<bool> IsAvailableAsync(CancellationToken ct = default)
	{
		try
		{
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
			string url = $"http://{_probeHost}:{_config.DebugPort}/json/version";
			string json = await http.GetStringAsync(url, ct);
			return json.Contains("Browser");
		}
		catch
		{
			return false;
		}
	}

	/// <summary>
	/// CRIT-103: Validates Chrome is actually rendering content, not just responding to HTTP.
	/// Checks if a page has a valid DOM with documentElement.
	/// </summary>
	public async Task<bool> IsRenderingAsync(CancellationToken ct = default)
	{
		try
		{
			// First check basic availability
			if (!await IsAvailableAsync(ct))
			{
				Console.WriteLine("[CdpLifecycle] IsRendering: CDP not available");
				return false;
			}

			// Get the WebSocket debugger URL
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
			string listUrl = $"http://{_probeHost}:{_config.DebugPort}/json/list";
			string listJson = await http.GetStringAsync(listUrl, ct);

			// Check if there's at least one page with a valid WebSocket URL
			if (!listJson.Contains("webSocketDebuggerUrl"))
			{
				Console.WriteLine("[CdpLifecycle] IsRendering: No pages with WebSocket debugger URL");
				return false;
			}

			// Try to connect via CDP and evaluate a simple expression
			// This validates the renderer process is actually working
			using var cdp = new C0MMON.Infrastructure.Cdp.CdpClient(
				new C0MMON.Infrastructure.Cdp.CdpConfig
				{
					HostIp = _probeHost,
					Port = _config.DebugPort,
					CommandTimeoutMs = 5000
				});

			bool connected = await cdp.ConnectAsync(ct);
			if (!connected)
			{
				Console.WriteLine("[CdpLifecycle] IsRendering: Failed to connect CDP client");
				return false;
			}

			// Try to evaluate - this will fail if renderer is hung
			var result = await cdp.EvaluateAsync<string>(
				"document.documentElement ? 'ok' : 'no-dom'",
				ct);

			bool isRendering = result == "ok";
			if (!isRendering)
			{
				Console.WriteLine($"[CdpLifecycle] IsRendering: DOM check returned '{result}'");
			}
			else
			{
				Console.WriteLine("[CdpLifecycle] IsRendering: Renderer healthy");
			}

			return isRendering;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpLifecycle] IsRendering check failed: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// AUTO-056-006: Ensures CDP is available. If not, auto-starts Chrome and waits for readiness.
	/// Returns true when CDP is confirmed healthy, false if auto-start failed or disabled.
	/// </summary>
	public async Task<bool> EnsureAvailableAsync(CancellationToken ct = default)
	{
		// 1. Check if CDP already available
		if (await IsAvailableAsync(ct))
		{
			_status = CdpLifecycleStatus.Healthy;
			Console.WriteLine("[CdpLifecycle] CDP already available — no action needed");
			return true;
		}

		// 2. Auto-start Chrome if configured
		if (!_config.AutoStart)
		{
			Console.WriteLine("[CdpLifecycle] CDP unavailable and AutoStart=false — cannot proceed");
			_status = CdpLifecycleStatus.Stopped;
			return false;
		}

		// 3. Validate Chrome path
		if (!File.Exists(_config.ChromePath))
		{
			Console.WriteLine($"[CdpLifecycle] Chrome not found at: {_config.ChromePath}");
			_status = CdpLifecycleStatus.Error;
			return false;
		}

		Console.WriteLine("[CdpLifecycle] CDP unavailable — auto-starting Chrome...");
		await StartChromeAsync(ct);

		// 4. Wait for CDP with timeout
		return await WaitForCdpAsync(_config.StartupTimeoutSeconds, ct);
	}

	/// <summary>
	/// AUTO-056-002: Starts Chrome with remote debugging flags via Process.Start.
	/// Attaches Exited event handler for crash detection and auto-restart.
	/// CRIT-103: Now validates renderer health before reusing existing processes.
	/// </summary>
	public async Task StartChromeAsync(CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		// BUGFIX: _intentionalStop remains true until after new Chrome starts
		// This prevents OnChromeExited from triggering parallel restarts

		// CRIT-103: Check outside lock first to allow async health check
		Process? existingProcess = null;
		lock (_lock)
		{
			existingProcess = _chromeProcess;
		}

		if (existingProcess != null && !existingProcess.HasExited)
		{
			// CRIT-103: Validate Chrome is actually rendering, not just running
			Console.WriteLine("[CdpLifecycle] Chrome process exists (PID {0}) — validating renderer health...", existingProcess.Id);
			bool isRendering = await IsRenderingAsync(ct);
			if (isRendering)
			{
				Console.WriteLine("[CdpLifecycle] Chrome renderer healthy — reusing existing process");
				return;
			}
			Console.WriteLine("[CdpLifecycle] Chrome renderer UNHEALTHY — killing and restarting");
			_intentionalStop = true; // BUGFIX: Prevent OnChromeExited from triggering parallel restart
			try
			{
				existingProcess.Kill(entireProcessTree: true);
				await existingProcess.WaitForExitAsync(CancellationToken.None);
			}
			catch (Exception killEx)
			{
				Console.WriteLine($"[CdpLifecycle] Warning: Failed to kill zombie Chrome: {killEx.Message}");
			}
			lock (_lock)
			{
				if (_chromeProcess == existingProcess)
					_chromeProcess = null;
			}
		}

		lock (_lock)
		{
			_status = CdpLifecycleStatus.Starting;
			string args = BuildChromeArgs();

			Console.WriteLine($"[CdpLifecycle] Starting: \"{_config.ChromePath}\" {args}");

			// CRIT-103: Clean up corrupted profile directory before starting
			string userDataDir = Path.Combine(Path.GetTempPath(), $"chrome_cdp_{_config.DebugPort}");
			try
			{
				if (Directory.Exists(userDataDir))
				{
					Console.WriteLine($"[CdpLifecycle] Cleaning up existing profile directory: {userDataDir}");
					Directory.Delete(userDataDir, recursive: true);
				}
			}
			catch (Exception cleanupEx)
			{
				Console.WriteLine($"[CdpLifecycle] Warning: Failed to cleanup profile directory: {cleanupEx.Message}");
			}

			var psi = new ProcessStartInfo
			{
				FileName = _config.ChromePath,
				Arguments = args,
				UseShellExecute = false,
				CreateNoWindow = _config.Headless,
				RedirectStandardError = true,
				RedirectStandardOutput = true,
			};

			// Ensure chrome args include user-data-dir
			if (!args.Contains("--user-data-dir"))
			{
				psi.Arguments += $" --user-data-dir=\"{userDataDir}\"";
			}

			try
			{
				_chromeProcess = Process.Start(psi);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[CdpLifecycle] Failed to start Chrome: {ex.Message}");
				_status = CdpLifecycleStatus.Error;
				throw;
			}

			if (_chromeProcess == null)
			{
				Console.WriteLine("[CdpLifecycle] Process.Start returned null — Chrome failed to launch");
				_status = CdpLifecycleStatus.Error;
				return;
			}

			Console.WriteLine($"[CdpLifecycle] Chrome started (PID {_chromeProcess.Id})");

			// BUGFIX: Reset _intentionalStop AFTER new Chrome starts
			// This prevents race condition where OnChromeExited fires during startup
			_intentionalStop = false;
			_autoLoginTriggered = false; // HYBRID-002: Reset auto-login flag for new session

			_chromeProcess.EnableRaisingEvents = true;
			_chromeProcess.Exited += OnChromeExited;

			// Discard stdout/stderr to avoid buffer deadlocks
			_chromeProcess.BeginErrorReadLine();
			_chromeProcess.BeginOutputReadLine();

			StartHealthMonitoring();
		}
	}

	/// <summary>
	/// AUTO-056-004: Graceful shutdown — CloseMainWindow → wait → force Kill.
	/// </summary>
	public async Task StopChromeAsync(CancellationToken ct = default)
	{
		_intentionalStop = true;
		StopHealthMonitoring();

		Process? proc;
		lock (_lock)
		{
			proc = _chromeProcess;
			_chromeProcess = null;
		}

		if (proc == null || proc.HasExited)
		{
			_status = CdpLifecycleStatus.Stopped;
			Console.WriteLine("[CdpLifecycle] Chrome already stopped");
			return;
		}

		Console.WriteLine($"[CdpLifecycle] Stopping Chrome (PID {proc.Id})...");

		// Step 1: Try graceful close
		try
		{
			proc.CloseMainWindow();
		}
		catch { /* Non-fatal */ }

		// Step 2: Wait for exit
		int waitMs = _config.GracefulShutdownTimeoutSeconds * 1000;
		bool exited = false;
		try
		{
			using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
			timeoutCts.CancelAfter(waitMs);
			await proc.WaitForExitAsync(timeoutCts.Token);
			exited = true;
		}
		catch (OperationCanceledException)
		{
			exited = proc.HasExited;
		}

		// Step 3: Force kill if still running
		if (!exited && !proc.HasExited)
		{
			Console.WriteLine("[CdpLifecycle] Chrome did not exit gracefully — force killing");
			try
			{
				proc.Kill(entireProcessTree: true);
				await proc.WaitForExitAsync(CancellationToken.None);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[CdpLifecycle] Force kill error: {ex.Message}");
			}
		}

		_status = CdpLifecycleStatus.Stopped;
		Console.WriteLine("[CdpLifecycle] Chrome stopped");
	}

	/// <summary>
	/// AUTO-056-003: Restart Chrome — stop then start with backoff reset.
	/// </summary>
	public async Task RestartChromeAsync(CancellationToken ct = default)
	{
		Console.WriteLine("[CdpLifecycle] Restarting Chrome...");
		await StopChromeAsync(ct);
		await Task.Delay(1000, ct); // Brief pause between stop and start
		await StartChromeAsync(ct);
	}

	public CdpLifecycleStatus GetLifecycleStatus() => _status;

	/// <summary>
	/// HYBRID-002: Flag to prevent duplicate auto-login attempts per Chrome session.
	/// Reset when Chrome restarts.
	/// </summary>
	private bool _autoLoginTriggered;

	/// <summary>
	/// AUTO-056-003: Called when Chrome process exits unexpectedly.
	/// Implements exponential backoff restart (5s, 10s, 30s) up to MaxAutoRestarts.
	/// BUGFIX: Added _restartInProgress guard to prevent parallel restart attempts.
	/// </summary>
	private void OnChromeExited(object? sender, EventArgs e)
	{
		if (_intentionalStop || _disposed)
			return;

		// BUGFIX: Prevent parallel restart attempts
		lock (_lock)
		{
			if (_restartInProgress)
			{
				Console.WriteLine("[CdpLifecycle] Restart already in progress — skipping duplicate");
				return;
			}
			_restartInProgress = true;
		}

		int exitCode = -1;
		try
		{
			if (sender is Process p)
				exitCode = p.ExitCode;
		}
		catch { /* Process may be disposed */ }

		Console.WriteLine($"[CdpLifecycle] Chrome exited unexpectedly (exit code: {exitCode})");
		_status = CdpLifecycleStatus.Unhealthy;

		lock (_lock)
		{
			_chromeProcess = null;
		}

		if (_restartAttempts >= _config.MaxAutoRestarts)
		{
			Console.WriteLine($"[CdpLifecycle] Max auto-restarts ({_config.MaxAutoRestarts}) exceeded — giving up");
			_status = CdpLifecycleStatus.Error;
			_restartInProgress = false; // BUGFIX: Reset flag on early return
			return;
		}

		int backoffIndex = Math.Min(_restartAttempts, _config.RestartBackoffSeconds.Length - 1);
		int backoffSeconds = _config.RestartBackoffSeconds[backoffIndex];
		_restartAttempts++;

		Console.WriteLine($"[CdpLifecycle] Auto-restart {_restartAttempts}/{_config.MaxAutoRestarts} in {backoffSeconds}s...");

		// Fire-and-forget restart with backoff
		_ = Task.Run(async () =>
		{
			try
			{
				await Task.Delay(TimeSpan.FromSeconds(backoffSeconds));
				if (!_disposed && !_intentionalStop)
				{
					await StartChromeAsync();
					if (await WaitForCdpAsync(_config.StartupTimeoutSeconds))
					{
						Console.WriteLine("[CdpLifecycle] Auto-restart successful — CDP healthy");
						_restartAttempts = 0; // Reset on success
					}
					else
					{
						Console.WriteLine("[CdpLifecycle] Auto-restart: Chrome started but CDP not responding");
					}
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[CdpLifecycle] Auto-restart failed: {ex.Message}");
				_status = CdpLifecycleStatus.Error;
			}
			finally
			{
				// BUGFIX: Always reset _restartInProgress when restart completes or fails
				_restartInProgress = false;
			}
		});
	}

	/// <summary>
	/// Waits for CDP to become available with retry + timeout.
	/// HYBRID-002: Triggers immediate login after CDP becomes healthy (redundancy with startup URL).
	/// </summary>
	private async Task<bool> WaitForCdpAsync(int timeoutSeconds, CancellationToken ct = default)
	{
		Stopwatch sw = Stopwatch.StartNew();
		TimeSpan timeout = TimeSpan.FromSeconds(timeoutSeconds);

		Console.WriteLine($"[CdpLifecycle] Waiting for CDP (timeout: {timeoutSeconds}s)...");

		while (sw.Elapsed < timeout && !ct.IsCancellationRequested)
		{
			if (await IsAvailableAsync(ct))
			{
				_status = CdpLifecycleStatus.Healthy;
				_restartAttempts = 0;
				Console.WriteLine($"[CdpLifecycle] CDP available after {sw.Elapsed.TotalSeconds:F1}s");

				// HYBRID-002: Trigger immediate login after Chrome is ready (redundancy with startup URL)
				// This ensures login happens even if startup URL navigation fails or gets stuck
				_ = Task.Run(async () => await TriggerAutoLoginAsync(ct), ct);

				return true;
			}

			await Task.Delay(1000, ct);
		}

		Console.WriteLine($"[CdpLifecycle] CDP did not become available within {timeoutSeconds}s");
		_status = CdpLifecycleStatus.Unhealthy;
		return false;
	}

	/// <summary>
	/// HYBRID-002: Triggers automatic login to OrionStars after Chrome becomes healthy.
	/// Only runs once per Chrome session and only if not already logged in.
	/// </summary>
	private async Task TriggerAutoLoginAsync(CancellationToken ct)
	{
		try
		{
			// Safety check: only trigger once per session
			if (_autoLoginTriggered)
			{
				Console.WriteLine("[CdpLifecycle] Auto-login already triggered for this session — skipping");
				return;
			}

			// Wait a moment for renderer to stabilize
			await Task.Delay(3000, ct);

			// Check if already logged in before attempting
			using var cdp = new C0MMON.Infrastructure.Cdp.CdpClient(
				new C0MMON.Infrastructure.Cdp.CdpConfig
				{
					HostIp = _probeHost,
					Port = _config.DebugPort,
					CommandTimeoutMs = 10000
				});

			bool connected = await cdp.ConnectAsync(ct);
			if (!connected)
			{
				Console.WriteLine("[CdpLifecycle] Auto-login: Failed to connect CDP client");
				return;
			}

			// Check current URL to avoid unnecessary navigation
			string? currentUrl = await cdp.EvaluateAsync<string>("window.location.href", ct);
			Console.WriteLine($"[CdpLifecycle] Auto-login: Current URL = {currentUrl}");

			// Check if already logged in (has balance)
			double? balance = await cdp.EvaluateAsync<double>("Number(window.parent.Balance) || 0", ct);
			if (balance > 0)
			{
				Console.WriteLine($"[CdpLifecycle] Auto-login: Already logged in (balance: ${balance:F2}) — skipping");
				_autoLoginTriggered = true;
				return;
			}

			// Mark as triggered to prevent duplicate attempts
			_autoLoginTriggered = true;

			Console.WriteLine("[CdpLifecycle] Auto-login: Not logged in, triggering OrionStars login...");

			// Get credentials from credential repository
			var credentials = GetOrionStarsCredentials();
			if (credentials == null)
			{
				Console.WriteLine("[CdpLifecycle] Auto-login: No credentials available — cannot auto-login");
				return;
			}

			// Trigger login via CdpGameActions
			bool loginSuccess = await Infrastructure.CdpGameActions.LoginOrionStarsAsync(
				cdp, credentials.Value.Username, credentials.Value.Password, ct);

			if (loginSuccess)
			{
				Console.WriteLine($"[CdpLifecycle] Auto-login: SUCCESS for {credentials.Value.Username}");
			}
			else
			{
				Console.WriteLine($"[CdpLifecycle] Auto-login: FAILED for {credentials.Value.Username}");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpLifecycle] Auto-login: Exception occurred: {ex.Message}");
		}
	}

	/// <summary>
	/// HYBRID-002: Retrieves OrionStars credentials from the credential repository.
	/// Uses IRepoCredentials via MongoUnitOfWork to fetch credentials for the platform.
	/// </summary>
	private (string Username, string Password)? GetOrionStarsCredentials()
	{
		try
		{
			// Use MongoUnitOfWork to access credentials (does not implement IDisposable)
			var uow = new C0MMON.Infrastructure.Persistence.MongoUnitOfWork();

			// Get all credentials and filter for OrionStars
			var allCredentials = uow.Credentials.GetAll();
			var orionStarsCredentials = allCredentials
				.Where(c => c.Game.Equals("OrionStars", StringComparison.OrdinalIgnoreCase))
				.ToList();

			// First try to get an active/enabled credential
			var credential = orionStarsCredentials.FirstOrDefault(c => c.Enabled);

			if (credential != null)
			{
				Console.WriteLine($"[CdpLifecycle] Auto-login: Found active credential for {credential.Username}");
				return (credential.Username, credential.Password);
			}

			// Fallback: use first available credential
			credential = orionStarsCredentials.FirstOrDefault();
			if (credential != null)
			{
				Console.WriteLine($"[CdpLifecycle] Auto-login: Using fallback credential for {credential.Username}");
				return (credential.Username, credential.Password);
			}

			Console.WriteLine("[CdpLifecycle] Auto-login: No OrionStars credentials found");
			return null;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpLifecycle] Auto-login: Failed to retrieve credentials: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Builds Chrome command line arguments from config.
	/// HYBRID-001: Added --app= startup URL to open directly to OrionStars instead of Google welcome screen.
	/// </summary>
	private string BuildChromeArgs()
	{
		var args = new List<string>
		{
			// HYBRID-001: Open directly to OrionStars game (prevents Google welcome screen)
			"--app=http://web.orionstars.org/hot_play/orionstars/",
			$"--remote-debugging-port={_config.DebugPort}",
			$"--remote-debugging-address={_config.DebugHost}",
		};

		if (_config.Headless)
			args.Add("--headless=new");

		foreach (string extra in _config.AdditionalArgs)
		{
			if (!string.IsNullOrWhiteSpace(extra))
				args.Add(extra);
		}

		return string.Join(" ", args);
	}

	/// <summary>
	/// AUTO-056-003: Starts periodic health monitoring timer.
	/// </summary>
	private void StartHealthMonitoring()
	{
		StopHealthMonitoring();
		_shutdownCts = new CancellationTokenSource();

		int intervalMs = _config.HealthCheckIntervalSeconds * 1000;
		_healthCheckTimer = new Timer(async _ =>
		{
			if (_disposed || _intentionalStop)
				return;

			try
			{
				bool healthy = await IsAvailableAsync(_shutdownCts?.Token ?? CancellationToken.None);
				if (healthy)
				{
					_status = CdpLifecycleStatus.Healthy;
				}
				else if (_status == CdpLifecycleStatus.Healthy)
				{
					Console.WriteLine("[CdpLifecycle] Health check FAILED: CDP became unhealthy");
					_status = CdpLifecycleStatus.Unhealthy;

					// CRIT-103: Trigger auto-restart instead of silently degrading
					if (_restartAttempts < _config.MaxAutoRestarts)
					{
						Console.WriteLine("[CdpLifecycle] Health check triggering auto-restart...");
						_ = Task.Run(async () =>
						{
							try { await RestartChromeAsync(); }
							catch (Exception restartEx)
							{
								Console.WriteLine($"[CdpLifecycle] Health-triggered restart failed: {restartEx.Message}");
								_status = CdpLifecycleStatus.Error;
							}
						});
					}
					else
					{
						Console.WriteLine($"[CdpLifecycle] Max restarts ({_config.MaxAutoRestarts}) exceeded — entering ERROR state");
						_status = CdpLifecycleStatus.Error;
					}
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[CdpLifecycle] Health check exception: {ex.Message}");
				_status = CdpLifecycleStatus.Unhealthy;
			}
		}, null, intervalMs, intervalMs);
	}

	private void StopHealthMonitoring()
	{
		_shutdownCts?.Cancel();
		_shutdownCts?.Dispose();
		_shutdownCts = null;
		_healthCheckTimer?.Dispose();
		_healthCheckTimer = null;
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;

		StopHealthMonitoring();

		// Synchronous graceful shutdown
		try
		{
			StopChromeAsync().GetAwaiter().GetResult();
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CdpLifecycle] Dispose cleanup error: {ex.Message}");
		}
	}
}
