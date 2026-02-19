using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.W4TCHD0G;

/// <summary>
/// FOUREYES-025: LM Studio process manager implementation.
/// Manages the local LM Studio server lifecycle, health checks, and model discovery.
/// </summary>
public class LMStudioProcessManager : ILMStudioProcessManager, IDisposable {
	private readonly string _lmStudioPath;
	private readonly string _endpointUrl;
	private readonly HttpClient _http;
	private Process? _process;
	private readonly Stopwatch _uptimeWatch = new();
	private bool _disposed;

	public bool IsRunning => _process != null && !_process.HasExited;

	public LMStudioProcessManager(
		string? lmStudioPath = null,
		string endpointUrl = "http://localhost:1234") {
		_lmStudioPath = lmStudioPath ?? FindLMStudioPath();
		_endpointUrl = endpointUrl.TrimEnd('/');
		_http = new HttpClient { Timeout = TimeSpan.FromSeconds(10) };
	}

	public async Task<bool> StartAsync(CancellationToken cancellationToken = default) {
		if (IsRunning)
			return true;

		// Check if LM Studio is already running externally
		if (await IsEndpointAvailableAsync(cancellationToken)) {
			Console.WriteLine("[LMStudioProcessManager] LM Studio already running externally");
			_uptimeWatch.Restart();
			return true;
		}

		try {
			ProcessStartInfo psi = new() {
				FileName = _lmStudioPath,
				Arguments = "--server",
				UseShellExecute = false,
				CreateNoWindow = true,
				RedirectStandardOutput = true,
				RedirectStandardError = true,
			};

			_process = Process.Start(psi);
			if (_process == null) {
				Console.WriteLine("[LMStudioProcessManager] Failed to start LM Studio process");
				return false;
			}

			_uptimeWatch.Restart();
			Console.WriteLine($"[LMStudioProcessManager] Started LM Studio (PID: {_process.Id})");

			// Wait for endpoint to become available
			int retries = 30;
			while (retries > 0 && !cancellationToken.IsCancellationRequested) {
				if (await IsEndpointAvailableAsync(cancellationToken))
					return true;
				await Task.Delay(1000, cancellationToken);
				retries--;
			}

			Console.WriteLine("[LMStudioProcessManager] LM Studio started but endpoint not responding");
			return false;
		}
		catch (Exception ex) {
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [LMStudioProcessManager] Start failed: {ex.Message}");
			return false;
		}
	}

	public async Task StopAsync(CancellationToken cancellationToken = default) {
		if (_process == null || _process.HasExited) {
			_process = null;
			_uptimeWatch.Stop();
			return;
		}

		try {
			_process.CloseMainWindow();
			bool exited = await Task.Run(() => _process.WaitForExit(5000), cancellationToken);
			if (!exited) {
				_process.Kill(entireProcessTree: true);
				Console.WriteLine("[LMStudioProcessManager] Force killed LM Studio process");
			}
		}
		catch (Exception ex) {
			Console.WriteLine($"[LMStudioProcessManager] Stop error: {ex.Message}");
		}
		finally {
			_process?.Dispose();
			_process = null;
			_uptimeWatch.Stop();
		}
	}

	public async Task<bool> RestartAsync(CancellationToken cancellationToken = default) {
		await StopAsync(cancellationToken);
		await Task.Delay(2000, cancellationToken);
		return await StartAsync(cancellationToken);
	}

	public async Task<ProcessHealthStatus> GetHealthAsync(CancellationToken cancellationToken = default) {
		ProcessHealthStatus status = new() {
			EndpointUrl = _endpointUrl,
			IsRunning = IsRunning || await IsEndpointAvailableAsync(cancellationToken),
			UptimeSeconds = (long)_uptimeWatch.Elapsed.TotalSeconds,
		};

		if (status.IsRunning) {
			try {
				status.IsResponding = await IsEndpointAvailableAsync(cancellationToken);
				IReadOnlyList<string> models = await GetLoadedModelsAsync(cancellationToken);
				status.LoadedModelCount = models.Count;
			}
			catch {
				status.IsResponding = false;
			}

			if (_process != null && !_process.HasExited) {
				try {
					_process.Refresh();
					status.MemoryUsageBytes = _process.WorkingSet64;
				}
				catch { }
			}
		}

		return status;
	}

	public async Task<IReadOnlyList<string>> GetLoadedModelsAsync(CancellationToken cancellationToken = default) {
		try {
			HttpResponseMessage response = await _http.GetAsync($"{_endpointUrl}/v1/models", cancellationToken);
			if (!response.IsSuccessStatusCode)
				return Array.Empty<string>();

			string json = await response.Content.ReadAsStringAsync(cancellationToken);
			using JsonDocument doc = JsonDocument.Parse(json);

			List<string> models = new();
			if (doc.RootElement.TryGetProperty("data", out JsonElement data)) {
				foreach (JsonElement model in data.EnumerateArray()) {
					if (model.TryGetProperty("id", out JsonElement id))
						models.Add(id.GetString() ?? string.Empty);
				}
			}

			return models;
		}
		catch {
			return Array.Empty<string>();
		}
	}

	private async Task<bool> IsEndpointAvailableAsync(CancellationToken cancellationToken) {
		try {
			HttpResponseMessage response = await _http.GetAsync($"{_endpointUrl}/v1/models", cancellationToken);
			return response.IsSuccessStatusCode;
		}
		catch {
			return false;
		}
	}

	private static string FindLMStudioPath() {
		string[] candidates = new[] {
			@"C:\Users\paulc\AppData\Local\Programs\LM Studio\LM Studio.exe",
			@"C:\Program Files\LM Studio\LM Studio.exe",
			@"C:\Program Files (x86)\LM Studio\LM Studio.exe",
		};

		return candidates.FirstOrDefault(System.IO.File.Exists) ?? "lmstudio";
	}

	public void Dispose() {
		if (!_disposed) {
			_disposed = true;
			_process?.Dispose();
			_http.Dispose();
			_uptimeWatch.Stop();
		}
	}
}
