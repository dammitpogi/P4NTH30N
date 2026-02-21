using System.Diagnostics;
using System.Net.Http;

namespace P4NTH30N.H4ND.Services;

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
	/// </summary>
	public Task StartChromeAsync(CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		_intentionalStop = false;

		lock (_lock)
		{
			if (_chromeProcess != null && !_chromeProcess.HasExited)
			{
				Console.WriteLine("[CdpLifecycle] Chrome already running (PID {0})", _chromeProcess.Id);
				return Task.CompletedTask;
			}

			_status = CdpLifecycleStatus.Starting;
			string args = BuildChromeArgs();

			Console.WriteLine($"[CdpLifecycle] Starting: \"{_config.ChromePath}\" {args}");

			var psi = new ProcessStartInfo
			{
				FileName = _config.ChromePath,
				Arguments = args,
				UseShellExecute = false,
				CreateNoWindow = _config.Headless,
				RedirectStandardError = true,
				RedirectStandardOutput = true,
			};

			// Use a unique user-data-dir to avoid conflicts with existing Chrome instances
			string userDataDir = Path.Combine(Path.GetTempPath(), $"chrome_cdp_{_config.DebugPort}");
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
				return Task.CompletedTask;
			}

			Console.WriteLine($"[CdpLifecycle] Chrome started (PID {_chromeProcess.Id})");

			_chromeProcess.EnableRaisingEvents = true;
			_chromeProcess.Exited += OnChromeExited;

			// Discard stdout/stderr to avoid buffer deadlocks
			_chromeProcess.BeginErrorReadLine();
			_chromeProcess.BeginOutputReadLine();

			StartHealthMonitoring();
		}

		return Task.CompletedTask;
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
	/// AUTO-056-003: Called when Chrome process exits unexpectedly.
	/// Implements exponential backoff restart (5s, 10s, 30s) up to MaxAutoRestarts.
	/// </summary>
	private void OnChromeExited(object? sender, EventArgs e)
	{
		if (_intentionalStop || _disposed)
			return;

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
		});
	}

	/// <summary>
	/// Waits for CDP to become available with retry + timeout.
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
				return true;
			}

			await Task.Delay(1000, ct);
		}

		Console.WriteLine($"[CdpLifecycle] CDP did not become available within {timeoutSeconds}s");
		_status = CdpLifecycleStatus.Unhealthy;
		return false;
	}

	/// <summary>
	/// Builds Chrome command line arguments from config.
	/// </summary>
	private string BuildChromeArgs()
	{
		var args = new List<string>
		{
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
					Console.WriteLine("[CdpLifecycle] Health check: CDP became unhealthy");
					_status = CdpLifecycleStatus.Unhealthy;
				}
			}
			catch
			{
				// Timer callback exceptions are non-fatal
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
