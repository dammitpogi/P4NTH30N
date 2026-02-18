using System.Collections.Concurrent;
using P4NTH30N.W4TCHD0G.Models;

namespace P4NTH30N.W4TCHD0G.Stream;

/// <summary>
/// Thread-safe circular frame buffer for storing decoded video frames.
/// Automatically drops oldest frames when capacity is reached to maintain
/// low-latency access to the most recent frames.
/// </summary>
/// <remarks>
/// DESIGN:
/// - Fixed capacity (default 30 = 1 second at 30 FPS)
/// - Lock-free concurrent queue for thread safety
/// - Oldest frames dropped on overflow (no backpressure)
/// - GetLatest() always returns the most recent frame in O(1)
///
/// PERFORMANCE TARGETS (FOUR-005):
/// - Frame drop rate: &lt;1% under normal conditions
/// - GetLatest() latency: &lt;1ms
/// - Memory: ~27MB for 30 frames at 1280x720 BGR24
/// </remarks>
public sealed class FrameBuffer : IDisposable
{
	/// <summary>
	/// Internal concurrent queue for thread-safe frame storage.
	/// </summary>
	private readonly ConcurrentQueue<VisionFrame> _frames = new();

	/// <summary>
	/// Maximum number of frames to retain. Oldest are dropped on overflow.
	/// </summary>
	private readonly int _maxSize;

	/// <summary>
	/// Reference to the most recently added frame for O(1) latest access.
	/// </summary>
	private volatile VisionFrame? _latestFrame;

	/// <summary>
	/// Total frames successfully added to the buffer.
	/// </summary>
	private long _totalAdded;

	/// <summary>
	/// Total frames dropped due to buffer overflow.
	/// </summary>
	private long _totalDropped;

	/// <summary>
	/// Whether the buffer has been disposed.
	/// </summary>
	private bool _disposed;

	/// <summary>
	/// Total frames added since buffer creation.
	/// </summary>
	public long TotalAdded => Interlocked.Read(ref _totalAdded);

	/// <summary>
	/// Total frames dropped due to overflow since buffer creation.
	/// </summary>
	public long TotalDropped => Interlocked.Read(ref _totalDropped);

	/// <summary>
	/// Current number of frames in the buffer.
	/// </summary>
	public int Count => _frames.Count;

	/// <summary>
	/// Maximum buffer capacity.
	/// </summary>
	public int MaxSize => _maxSize;

	/// <summary>
	/// Frame drop rate as a percentage (0.0 - 100.0).
	/// </summary>
	public double DropRate
	{
		get
		{
			long total = TotalAdded + TotalDropped;
			return total == 0 ? 0.0 : (TotalDropped * 100.0) / total;
		}
	}

	/// <summary>
	/// Creates a FrameBuffer with the specified capacity.
	/// </summary>
	/// <param name="maxSize">Maximum frames to retain. Default: 30 (1 second at 30 FPS).</param>
	public FrameBuffer(int maxSize = 30)
	{
		if (maxSize < 1)
			throw new ArgumentOutOfRangeException(nameof(maxSize), "Buffer size must be at least 1.");

		_maxSize = maxSize;
	}

	/// <summary>
	/// Adds a frame to the buffer. Drops oldest frames if at capacity.
	/// Thread-safe — can be called from the FFmpeg decode thread.
	/// </summary>
	/// <param name="frame">The decoded vision frame to buffer.</param>
	public void AddFrame(VisionFrame frame)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentNullException.ThrowIfNull(frame, nameof(frame));

		// Drop oldest frames to make room
		while (_frames.Count >= _maxSize)
		{
			if (_frames.TryDequeue(out _))
				Interlocked.Increment(ref _totalDropped);
		}

		_frames.Enqueue(frame);
		_latestFrame = frame;
		Interlocked.Increment(ref _totalAdded);
	}

	/// <summary>
	/// Returns the most recent frame in the buffer, or null if empty.
	/// O(1) operation — does not iterate the queue.
	/// </summary>
	public VisionFrame? GetLatest()
	{
		return _latestFrame;
	}

	/// <summary>
	/// Returns all frames currently in the buffer as a snapshot.
	/// Useful for batch analysis or debugging.
	/// </summary>
	public VisionFrame[] GetAll()
	{
		return _frames.ToArray();
	}

	/// <summary>
	/// Clears all frames from the buffer and resets counters.
	/// </summary>
	public void Clear()
	{
		while (_frames.TryDequeue(out _)) { }
		_latestFrame = null;
	}

	/// <summary>
	/// Disposes the frame buffer, clearing all stored frames.
	/// </summary>
	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			Clear();
		}
	}
}
