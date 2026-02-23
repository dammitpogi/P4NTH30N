using System.Diagnostics;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.H4ND.Parallel;

/// <summary>
/// ARCH-081: Manages isolated Chrome profiles for parallel workers.
/// Each worker gets its own Chrome instance with:
/// - Separate user-data-dir (isolated cookies, localStorage, sessions)
/// - Dedicated CDP port (9222 + workerId, range 9222-9231)
/// - Automatic cleanup on dispose (kills Chrome process, optionally removes profile)
/// </summary>
public sealed class ChromeProfileManager : IDisposable
{
	private readonly ChromeProfileConfig _config;
	private readonly Dictionary<int, ChromeWorkerInstance> _instances = new();
	private readonly object _lock = new();
	private bool _disposed;

	public ChromeProfileManager(ChromeProfileConfig? config = null)
	{
		_config = config ?? new ChromeProfileConfig();
	}

	/// <summary>
	/// Launch a Chrome instance with an isolated profile for the given worker.
	/// Returns a CdpConfig pointing to the worker's dedicated CDP port.
	/// </summary>
	public async Task<CdpConfig> LaunchWithProfileAsync(int workerId, CancellationToken ct = default)
	{
		if (workerId < 0 || workerId > _config.MaxWorkers - 1)
			throw new ArgumentOutOfRangeException(nameof(workerId), $"Worker ID must be 0-{_config.MaxWorkers - 1}");

		int port = _config.BasePort + workerId;
		string profileDir = Path.Combine(_config.ProfilesBasePath, $"Profile-W{workerId}");

		// Ensure profile directory exists
		Directory.CreateDirectory(profileDir);

		// Kill any existing Chrome on this port
		await KillChromeOnPortAsync(port);

		string chromeArgs = string.Join(" ", [
			$"--remote-debugging-port={port}",
			"--remote-debugging-address=127.0.0.1",
			$"--user-data-dir=\"{profileDir}\"",
			"--no-first-run",
			"--no-default-browser-check",
			"--ignore-certificate-errors",
			"--disable-web-security",
			"--allow-running-insecure-content",
			"--disable-features=SafeBrowsing",
			"--incognito",
			.. _config.AdditionalArgs,
		]);

		Console.WriteLine($"[ChromeProfile] Launching worker {workerId} on port {port} with profile {profileDir}");

		Process? process = null;
		try
		{
			var startInfo = new ProcessStartInfo
			{
				FileName = _config.ChromePath,
				Arguments = chromeArgs,
				UseShellExecute = false,
				CreateNoWindow = true,
				RedirectStandardOutput = true,
				RedirectStandardError = true,
			};

			process = Process.Start(startInfo);
			if (process == null)
				throw new InvalidOperationException($"Failed to start Chrome for worker {workerId}");

			// CRIT-103: Drain stdout/stderr to prevent buffer deadlock
			process.OutputDataReceived += (_, _) => { };
			process.ErrorDataReceived += (_, e) =>
			{
				if (!string.IsNullOrEmpty(e.Data))
					Console.WriteLine($"[Chrome:W{workerId}] {e.Data}");
			};
			process.BeginOutputReadLine();
			process.BeginErrorReadLine();

			// Wait for CDP to become available
			bool ready = await WaitForCdpReadyAsync(port, ct);
			if (!ready)
			{
				process.Kill();
				throw new TimeoutException($"Chrome CDP not ready on port {port} after {_config.StartupTimeoutSeconds}s");
			}

			var instance = new ChromeWorkerInstance(workerId, port, profileDir, process);

			lock (_lock)
			{
				_instances[workerId] = instance;
			}

			Console.WriteLine($"[ChromeProfile] Worker {workerId} ready on port {port} (PID {process.Id})");

			return new CdpConfig
			{
				HostIp = "127.0.0.1",
				Port = port,
			};
		}
		catch
		{
			process?.Kill();
			process?.Dispose();
			throw;
		}
	}

	/// <summary>
	/// Check if a worker's Chrome instance is still alive and responsive.
	/// </summary>
	public async Task<bool> IsHealthyAsync(int workerId, CancellationToken ct = default)
	{
		ChromeWorkerInstance? instance;
		lock (_lock)
		{
			if (!_instances.TryGetValue(workerId, out instance))
				return false;
		}

		if (instance.Process.HasExited)
			return false;

		// Probe CDP endpoint
		try
		{
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(3) };
			string url = $"http://127.0.0.1:{instance.Port}/json/version";
			string response = await http.GetStringAsync(url, ct);
			return !string.IsNullOrEmpty(response);
		}
		catch
		{
			return false;
		}
	}

	/// <summary>
	/// Restart a worker's Chrome instance (kill + relaunch).
	/// </summary>
	public async Task<CdpConfig> RestartWorkerAsync(int workerId, CancellationToken ct = default)
	{
		Console.WriteLine($"[ChromeProfile] Restarting worker {workerId}...");
		DisposeWorker(workerId);
		await Task.Delay(1000, ct); // Brief cooldown
		return await LaunchWithProfileAsync(workerId, ct);
	}

	/// <summary>
	/// Get the CDP port for a worker.
	/// </summary>
	public int GetPort(int workerId) => _config.BasePort + workerId;

	/// <summary>
	/// Get the number of active Chrome instances.
	/// </summary>
	public int ActiveCount
	{
		get
		{
			lock (_lock)
			{
				return _instances.Count(kv => !kv.Value.Process.HasExited);
			}
		}
	}

	/// <summary>
	/// Dispose a single worker's Chrome instance.
	/// </summary>
	public void DisposeWorker(int workerId)
	{
		ChromeWorkerInstance? instance;
		lock (_lock)
		{
			if (!_instances.Remove(workerId, out instance))
				return;
		}

		try
		{
			if (!instance.Process.HasExited)
			{
				instance.Process.Kill();
				instance.Process.WaitForExit(5000);
			}
			instance.Process.Dispose();
			Console.WriteLine($"[ChromeProfile] Worker {workerId} Chrome process terminated");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[ChromeProfile] Error disposing worker {workerId}: {ex.Message}");
		}

		// Optionally clean up profile directory
		if (_config.CleanupProfilesOnDispose)
		{
			try
			{
				if (Directory.Exists(instance.ProfileDir))
				{
					Directory.Delete(instance.ProfileDir, recursive: true);
					Console.WriteLine($"[ChromeProfile] Cleaned up profile {instance.ProfileDir}");
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[ChromeProfile] Profile cleanup failed for worker {workerId}: {ex.Message}");
			}
		}
	}

	public void Dispose()
	{
		if (_disposed) return;
		_disposed = true;

		int[] workerIds;
		lock (_lock)
		{
			workerIds = [.. _instances.Keys];
		}

		foreach (int id in workerIds)
		{
			DisposeWorker(id);
		}

		Console.WriteLine("[ChromeProfile] All Chrome instances disposed");
	}

	// --- Private helpers ---

	private async Task<bool> WaitForCdpReadyAsync(int port, CancellationToken ct)
	{
		using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(2) };
		string url = $"http://127.0.0.1:{port}/json/version";

		int waited = 0;
		int intervalMs = 500;
		int maxWaitMs = _config.StartupTimeoutSeconds * 1000;

		while (waited < maxWaitMs)
		{
			ct.ThrowIfCancellationRequested();
			try
			{
				string response = await http.GetStringAsync(url, ct);
				if (!string.IsNullOrEmpty(response))
					return true;
			}
			catch
			{
				// Not ready yet
			}

			await Task.Delay(intervalMs, ct);
			waited += intervalMs;
		}

		return false;
	}

	private static async Task KillChromeOnPortAsync(int port)
	{
		try
		{
			using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(2) };
			// Try to gracefully close via CDP
			await http.GetStringAsync($"http://127.0.0.1:{port}/json/close");
		}
		catch
		{
			// Port not in use or Chrome not responding — that's fine
		}
	}

	/// <summary>
	/// Represents a running Chrome instance for a specific worker.
	/// </summary>
	private sealed record ChromeWorkerInstance(int WorkerId, int Port, string ProfileDir, Process Process);
}

/// <summary>
/// ARCH-081: Configuration for Chrome profile isolation.
/// </summary>
public sealed class ChromeProfileConfig
{
	/// <summary>
	/// Base CDP port. Worker N gets port BasePort + N.
	/// </summary>
	public int BasePort { get; set; } = 9222;

	/// <summary>
	/// Maximum number of parallel workers (port range = BasePort to BasePort + MaxWorkers - 1).
	/// </summary>
	public int MaxWorkers { get; set; } = 10;

	/// <summary>
	/// Base directory for Chrome profile directories.
	/// Each worker gets a subdirectory: Profile-W{workerId}
	/// </summary>
	public string ProfilesBasePath { get; set; } = @"C:\ProgramData\P4NTH30N\chrome-profiles";

	/// <summary>
	/// Path to Chrome executable.
	/// </summary>
	public string ChromePath { get; set; } = @"C:\Program Files\Google\Chrome\Application\chrome.exe";

	/// <summary>
	/// Maximum seconds to wait for Chrome CDP to become available after launch.
	/// </summary>
	public int StartupTimeoutSeconds { get; set; } = 15;

	/// <summary>
	/// Whether to delete profile directories when disposing workers.
	/// Set to false to preserve session cookies across restarts.
	/// </summary>
	public bool CleanupProfilesOnDispose { get; set; } = false;

	/// <summary>
	/// Additional Chrome command-line arguments.
	/// </summary>
	public List<string> AdditionalArgs { get; set; } = [];

	/// <summary>
	/// Timeout in minutes for reclaiming stale Chrome processes.
	/// </summary>
	public int StaleProcessTimeoutMinutes { get; set; } = 5;
}
