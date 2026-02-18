using System.Diagnostics;
using System.Text;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Stream;

/// <summary>
/// RTMP stream receiver using a process-based FFmpeg subprocess.
/// Connects to an OBS RTMP output, decodes H.264 frames to raw BGR24,
/// and pipes them into a <see cref="FrameBuffer"/> for vision analysis.
/// </summary>
/// <remarks>
/// DECISION: Using Process-based FFmpeg (not FFmpeg.NET) per FOUR-005 spec.
/// Process isolation prevents FFmpeg crashes from affecting the C# host.
/// FFmpeg reads RTMP via librtmp and outputs raw BGR24 frames to stdout pipe.
///
/// ARCHITECTURE:
/// VM OBS (RTMP) → FFmpeg subprocess → stdout pipe → RTMPStreamReceiver → FrameBuffer → W4TCHD0G
///
/// PERFORMANCE TARGETS:
/// - Latency: &lt;300ms end-to-end
/// - Frame drop rate: &lt;1%
/// - Resolution: 1280x720 (configurable)
/// - Input FPS: 30, Analysis FPS: 2-5 (sampled by W4TCHD0G)
/// </remarks>
public sealed class RTMPStreamReceiver : IStreamReceiver
{
	/// <summary>
	/// Default frame width in pixels.
	/// </summary>
	private const int DefaultWidth = 1280;

	/// <summary>
	/// Default frame height in pixels.
	/// </summary>
	private const int DefaultHeight = 720;

	/// <summary>
	/// Bytes per pixel for BGR24 format (3 bytes: Blue, Green, Red).
	/// </summary>
	private const int BytesPerPixel = 3;

	/// <summary>
	/// Path to the FFmpeg executable. Resolved from PATH or configured.
	/// </summary>
	private readonly string _ffmpegPath;

	/// <summary>
	/// Frame width for decoded output.
	/// </summary>
	private readonly int _frameWidth;

	/// <summary>
	/// Frame height for decoded output.
	/// </summary>
	private readonly int _frameHeight;

	/// <summary>
	/// Circular buffer storing decoded frames for vision analysis.
	/// </summary>
	private readonly FrameBuffer _frameBuffer;

	/// <summary>
	/// The running FFmpeg subprocess.
	/// </summary>
	private Process? _ffmpegProcess;

	/// <summary>
	/// Background task reading frames from FFmpeg stdout.
	/// </summary>
	private Task? _readTask;

	/// <summary>
	/// Cancellation source for stopping the receiver.
	/// </summary>
	private CancellationTokenSource? _cts;

	/// <summary>
	/// Timestamp of the last received frame for latency calculation.
	/// </summary>
	private DateTime _lastFrameTime = DateTime.MinValue;

	/// <summary>
	/// Total frames successfully decoded and buffered.
	/// </summary>
	private long _totalFramesReceived;

	/// <summary>
	/// Total frames that failed to decode.
	/// </summary>
	private long _totalFramesDropped;

	/// <summary>
	/// Whether the receiver has been disposed.
	/// </summary>
	private bool _disposed;

	/// <inheritdoc />
	public bool IsReceiving => _ffmpegProcess is not null && !_ffmpegProcess.HasExited;

	/// <inheritdoc />
	public long LatencyMs
	{
		get
		{
			if (_lastFrameTime == DateTime.MinValue)
				return -1;
			return (long)(DateTime.UtcNow - _lastFrameTime).TotalMilliseconds;
		}
	}

	/// <inheritdoc />
	public long TotalFramesReceived => Interlocked.Read(ref _totalFramesReceived);

	/// <inheritdoc />
	public long TotalFramesDropped => Interlocked.Read(ref _totalFramesDropped);

	/// <inheritdoc />
	public event Action<VisionFrame>? OnFrameReceived;

	/// <inheritdoc />
	public event Action<string>? OnStreamError;

	/// <summary>
	/// Creates an RTMPStreamReceiver with configurable resolution and buffer.
	/// </summary>
	/// <param name="ffmpegPath">Path to ffmpeg executable. Default: "ffmpeg" (from PATH).</param>
	/// <param name="frameWidth">Output frame width. Default: 1280.</param>
	/// <param name="frameHeight">Output frame height. Default: 720.</param>
	/// <param name="bufferSize">Frame buffer capacity. Default: 30 (1 second at 30 FPS).</param>
	public RTMPStreamReceiver(
		string ffmpegPath = "ffmpeg",
		int frameWidth = DefaultWidth,
		int frameHeight = DefaultHeight,
		int bufferSize = 30)
	{
		_ffmpegPath = ffmpegPath;
		_frameWidth = frameWidth;
		_frameHeight = frameHeight;
		_frameBuffer = new FrameBuffer(bufferSize);
	}

	/// <inheritdoc />
	public async Task StartAsync(string rtmpUrl = "rtmp://localhost:1935/live", CancellationToken cancellationToken = default)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (IsReceiving)
		{
			Console.WriteLine("[RTMPStreamReceiver] Already receiving. Call StopAsync() first.");
			return;
		}

		_cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);

		// FFmpeg command:
		// -i {rtmpUrl}           - Input from RTMP stream
		// -f rawvideo            - Output raw uncompressed video
		// -pix_fmt bgr24         - BGR24 pixel format (3 bytes/pixel, compatible with OpenCV)
		// -s {width}x{height}    - Scale to target resolution
		// -an                    - Disable audio
		// -sn                    - Disable subtitles
		// -loglevel warning      - Reduce FFmpeg log noise
		// pipe:1                 - Output to stdout
		string arguments = string.Join(" ",
			$"-i \"{rtmpUrl}\"",
			"-f rawvideo",
			"-pix_fmt bgr24",
			$"-s {_frameWidth}x{_frameHeight}",
			"-an",
			"-sn",
			"-loglevel warning",
			"pipe:1"
		);

		ProcessStartInfo startInfo = new()
		{
			FileName = _ffmpegPath,
			Arguments = arguments,
			UseShellExecute = false,
			RedirectStandardOutput = true,
			RedirectStandardError = true,
			CreateNoWindow = true,
		};

		try
		{
			_ffmpegProcess = Process.Start(startInfo);
			if (_ffmpegProcess is null || _ffmpegProcess.HasExited)
			{
				string error = "Failed to start FFmpeg process. Ensure FFmpeg is installed and in PATH.";
				OnStreamError?.Invoke(error);
				throw new InvalidOperationException(error);
			}

			Console.WriteLine($"[RTMPStreamReceiver] FFmpeg started (PID: {_ffmpegProcess.Id}). Connecting to: {rtmpUrl}");

			// Start background frame reading task
			_readTask = Task.Run(() => ReadFramesAsync(_cts.Token), _cts.Token);

			// Start background stderr monitoring task (for FFmpeg errors/warnings)
			_ = Task.Run(() => MonitorStderrAsync(_cts.Token), _cts.Token);

			// Brief delay to let FFmpeg connect
			await Task.Delay(500, cancellationToken);

			if (_ffmpegProcess.HasExited)
			{
				string error = $"FFmpeg exited immediately with code {_ffmpegProcess.ExitCode}. Check RTMP URL and FFmpeg installation.";
				OnStreamError?.Invoke(error);
				throw new InvalidOperationException(error);
			}

			Console.WriteLine("[RTMPStreamReceiver] Stream receiver active.");
		}
		catch (Exception ex) when (ex is not InvalidOperationException)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			string error = $"[{line}] FFmpeg start failed: {ex.Message}";
			Console.WriteLine(error);
			OnStreamError?.Invoke(error);
			throw;
		}
	}

	/// <inheritdoc />
	public async Task StopAsync()
	{
		if (_cts is not null)
		{
			await _cts.CancelAsync();
		}

		if (_ffmpegProcess is not null && !_ffmpegProcess.HasExited)
		{
			try
			{
				// Send 'q' to FFmpeg stdin for graceful shutdown
				_ffmpegProcess.Kill();
				await _ffmpegProcess.WaitForExitAsync();
			}
			catch
			{
				// Best-effort shutdown
			}
		}

		if (_readTask is not null)
		{
			try
			{
				await _readTask;
			}
			catch (OperationCanceledException)
			{
				// Expected on cancellation
			}
		}

		Console.WriteLine($"[RTMPStreamReceiver] Stopped. Total frames: {TotalFramesReceived}, Dropped: {TotalFramesDropped}");
	}

	/// <inheritdoc />
	public VisionFrame? GetLatestFrame()
	{
		return _frameBuffer.GetLatest();
	}

	/// <summary>
	/// Continuously reads raw BGR24 frames from FFmpeg stdout pipe.
	/// Each frame is exactly (width * height * 3) bytes.
	/// </summary>
	private async Task ReadFramesAsync(CancellationToken token)
	{
		int frameSize = _frameWidth * _frameHeight * BytesPerPixel;
		byte[] frameData = new byte[frameSize];
		System.IO.Stream stdout = _ffmpegProcess!.StandardOutput.BaseStream;
		long frameNumber = 0;

		try
		{
			while (!token.IsCancellationRequested && !_ffmpegProcess.HasExited)
			{
				// Read exactly one frame worth of bytes
				int totalRead = 0;
				while (totalRead < frameSize)
				{
					int bytesRead = await stdout.ReadAsync(
						frameData.AsMemory(totalRead, frameSize - totalRead),
						token
					);

					if (bytesRead == 0)
					{
						// Stream ended (FFmpeg closed, RTMP disconnected)
						string error = "FFmpeg stdout stream ended (RTMP disconnected or FFmpeg exited).";
						Console.WriteLine($"[RTMPStreamReceiver] {error}");
						OnStreamError?.Invoke(error);
						return;
					}

					totalRead += bytesRead;
				}

				// Successfully read one complete frame
				frameNumber++;
				DateTime now = DateTime.UtcNow;
				_lastFrameTime = now;

				VisionFrame visionFrame = new()
				{
					Data = (byte[])frameData.Clone(), // Clone to avoid buffer reuse issues
					Width = _frameWidth,
					Height = _frameHeight,
					Timestamp = now,
					FrameNumber = (int)(frameNumber & int.MaxValue),
					SourceName = "RTMP",
				};

				_frameBuffer.AddFrame(visionFrame);
				Interlocked.Increment(ref _totalFramesReceived);

				// Raise event for subscribers
				OnFrameReceived?.Invoke(visionFrame);
			}
		}
		catch (OperationCanceledException)
		{
			// Normal shutdown
		}
		catch (Exception ex)
		{
			Interlocked.Increment(ref _totalFramesDropped);
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			string error = $"[{line}] Frame read error: {ex.Message}";
			Console.WriteLine($"[RTMPStreamReceiver] {error}");
			OnStreamError?.Invoke(error);
		}
	}

	/// <summary>
	/// Monitors FFmpeg stderr for warnings and errors.
	/// FFmpeg logs diagnostics to stderr even when outputting video to stdout.
	/// </summary>
	private async Task MonitorStderrAsync(CancellationToken token)
	{
		if (_ffmpegProcess is null)
			return;

		try
		{
			using StreamReader stderr = _ffmpegProcess.StandardError;
			while (!token.IsCancellationRequested)
			{
				string? line = await stderr.ReadLineAsync(token);
				if (line is null)
					break;

				// Log FFmpeg warnings/errors
				if (line.Contains("error", StringComparison.OrdinalIgnoreCase) ||
					line.Contains("fatal", StringComparison.OrdinalIgnoreCase))
				{
					Console.WriteLine($"[FFmpeg ERROR] {line}");
					OnStreamError?.Invoke(line);
				}
				else if (line.Contains("warning", StringComparison.OrdinalIgnoreCase))
				{
					Console.WriteLine($"[FFmpeg WARN] {line}");
				}
			}
		}
		catch (OperationCanceledException)
		{
			// Normal shutdown
		}
		catch
		{
			// Best-effort stderr monitoring
		}
	}

	/// <inheritdoc />
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_cts?.Cancel();
			_cts?.Dispose();

			if (_ffmpegProcess is not null && !_ffmpegProcess.HasExited)
			{
				try { _ffmpegProcess.Kill(); } catch { }
			}
			_ffmpegProcess?.Dispose();
			_frameBuffer.Dispose();
		}
	}
}
