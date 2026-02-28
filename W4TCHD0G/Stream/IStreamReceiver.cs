using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G.Stream;

/// <summary>
/// Contract for receiving and decoding video streams from VM OBS instances.
/// Provides decoded frames to the W4TCHD0G vision analysis pipeline.
/// </summary>
public interface IStreamReceiver : IDisposable
{
	/// <summary>
	/// Starts receiving the RTMP stream and decoding frames.
	/// </summary>
	/// <param name="rtmpUrl">RTMP URL to connect to. Default: rtmp://localhost:1935/live</param>
	/// <param name="cancellationToken">Token to cancel the stream receiver.</param>
	Task StartAsync(string rtmpUrl = "rtmp://localhost:1935/live", CancellationToken cancellationToken = default);

	/// <summary>
	/// Stops receiving and releases resources.
	/// </summary>
	Task StopAsync();

	/// <summary>
	/// Returns the most recent decoded frame, or null if no frames available.
	/// </summary>
	VisionFrame? GetLatestFrame();

	/// <summary>
	/// Returns true if the stream is currently connected and receiving frames.
	/// </summary>
	bool IsReceiving { get; }

	/// <summary>
	/// Current estimated latency in milliseconds from capture to frame availability.
	/// </summary>
	long LatencyMs { get; }

	/// <summary>
	/// Total frames received since the stream started.
	/// </summary>
	long TotalFramesReceived { get; }

	/// <summary>
	/// Total frames dropped due to buffer overflow or decode errors.
	/// </summary>
	long TotalFramesDropped { get; }

	/// <summary>
	/// Event raised when a new frame is decoded and available.
	/// </summary>
	event Action<VisionFrame>? OnFrameReceived;

	/// <summary>
	/// Event raised when the stream connection is lost or encounters an error.
	/// </summary>
	event Action<string>? OnStreamError;
}
