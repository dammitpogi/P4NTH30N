using System;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Stream.Alternatives;

/// <summary>
/// FEAT-036: CDP-based frame capture alternative to RTMP stream.
/// Captures screenshots via Chrome DevTools Protocol Page.captureScreenshot.
/// No OBS required — works directly with any CDP-connected Chrome instance.
/// Achieves 2-5 FPS depending on network latency and resolution.
/// </summary>
public sealed class CDPScreenshotReceiver : IStreamReceiver
{
	private readonly ICdpClient _cdp;
	private readonly int _targetFps;
	private readonly int _captureWidth;
	private readonly int _captureHeight;
	private VisionFrame? _latestFrame;
	private CancellationTokenSource? _cts;
	private Task? _captureTask;
	private long _totalReceived;
	private long _totalDropped;
	private long _latencyMs;

	public bool IsReceiving { get; private set; }
	public long LatencyMs => Interlocked.Read(ref _latencyMs);
	public long TotalFramesReceived => Interlocked.Read(ref _totalReceived);
	public long TotalFramesDropped => Interlocked.Read(ref _totalDropped);

	public event Action<VisionFrame>? OnFrameReceived;
	public event Action<string>? OnStreamError;

	/// <summary>
	/// Creates a CDP screenshot receiver.
	/// </summary>
	/// <param name="cdpClient">Connected CDP client.</param>
	/// <param name="targetFps">Target capture rate (2-5 recommended).</param>
	/// <param name="captureWidth">Capture width (0 = native resolution).</param>
	/// <param name="captureHeight">Capture height (0 = native resolution).</param>
	public CDPScreenshotReceiver(ICdpClient cdpClient, int targetFps = 3, int captureWidth = 1280, int captureHeight = 720)
	{
		_cdp = cdpClient ?? throw new ArgumentNullException(nameof(cdpClient));
		_targetFps = Math.Clamp(targetFps, 1, 10);
		_captureWidth = captureWidth;
		_captureHeight = captureHeight;
	}

	public Task StartAsync(string rtmpUrl = "", CancellationToken cancellationToken = default)
	{
		if (IsReceiving) return Task.CompletedTask;

		_cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
		IsReceiving = true;

		_captureTask = Task.Run(() => CaptureLoopAsync(_cts.Token), _cts.Token);
		Console.WriteLine($"[CDPScreenshotReceiver] Started at {_targetFps} FPS ({_captureWidth}x{_captureHeight})");
		return Task.CompletedTask;
	}

	public async Task StopAsync()
	{
		if (!IsReceiving) return;

		IsReceiving = false;
		if (_cts != null) await _cts.CancelAsync();

		if (_captureTask != null)
		{
			try { await _captureTask; }
			catch (OperationCanceledException) { }
		}

		_cts?.Dispose();
		_cts = null;
		Console.WriteLine($"[CDPScreenshotReceiver] Stopped. Received: {TotalFramesReceived}, Dropped: {TotalFramesDropped}");
	}

	public VisionFrame? GetLatestFrame() => _latestFrame;

	/// <summary>
	/// Main capture loop: captures screenshots at the target FPS.
	/// </summary>
	private async Task CaptureLoopAsync(CancellationToken ct)
	{
		int intervalMs = 1000 / _targetFps;

		while (!ct.IsCancellationRequested)
		{
			DateTime captureStart = DateTime.UtcNow;

			try
			{
				// Capture screenshot via CDP
				JsonElement response = await _cdp.SendCommandAsync(
					"Page.captureScreenshot",
					new { format = "png", quality = 80 },
					ct
				);

				if (response.TryGetProperty("data", out JsonElement dataElement))
				{
					string? base64 = dataElement.GetString();
					if (!string.IsNullOrEmpty(base64))
					{
						byte[] pngBytes = Convert.FromBase64String(base64);

						VisionFrame frame = new()
						{
							FrameNumber = (int)(TotalFramesReceived + 1),
							Timestamp = DateTime.UtcNow,
							Data = pngBytes, // PNG-encoded (VisionProcessor will need to decode)
							Width = _captureWidth,
							Height = _captureHeight,
							IsPng = true,
						};

						_latestFrame = frame;
						Interlocked.Increment(ref _totalReceived);
						Interlocked.Exchange(ref _latencyMs, (long)(DateTime.UtcNow - captureStart).TotalMilliseconds);

						OnFrameReceived?.Invoke(frame);
					}
					else
					{
						Interlocked.Increment(ref _totalDropped);
					}
				}
				else
				{
					Interlocked.Increment(ref _totalDropped);
				}
			}
			catch (OperationCanceledException) { break; }
			catch (Exception ex)
			{
				Interlocked.Increment(ref _totalDropped);
				OnStreamError?.Invoke($"CDP screenshot failed: {ex.Message}");

				// Back off on error
				await Task.Delay(1000, ct);
				continue;
			}

			// Wait for next capture slot
			int elapsed = (int)(DateTime.UtcNow - captureStart).TotalMilliseconds;
			int remaining = intervalMs - elapsed;
			if (remaining > 0)
				await Task.Delay(remaining, ct);
		}
	}

	public void Dispose()
	{
		IsReceiving = false;
		_cts?.Cancel();
		_cts?.Dispose();
	}
}
