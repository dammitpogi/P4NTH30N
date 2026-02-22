using System.Collections.Concurrent;
using P4NTH30N.C0MMON.Entities;
using P4NTH30N.C0MMON.Support;

namespace P4NTH30N.H0UND.Services;

/// <summary>
/// DECISION_025: Anomaly detector for jackpot patterns.
/// Maintains sliding windows per house/game/tier and flags anomalies using
/// compression-based atypicality scoring with Z-score fallback.
/// </summary>
public sealed class AnomalyDetector
{
	private readonly ConcurrentDictionary<string, SlidingWindow> _windows = new();
	private readonly int _windowSize;
	private readonly double _compressionThreshold;
	private readonly double _zScoreThreshold;
	private readonly Action<AnomalyEvent>? _onAnomaly;

	/// <summary>
	/// Total anomalies detected since creation.
	/// </summary>
	private long _totalAnomalies;
	public long TotalAnomalies => Interlocked.Read(ref _totalAnomalies);

	/// <summary>
	/// Total values processed since creation.
	/// </summary>
	private long _totalProcessed;
	public long TotalProcessed => Interlocked.Read(ref _totalProcessed);

	/// <param name="windowSize">Sliding window size (default 50).</param>
	/// <param name="compressionThreshold">Atypicality ratio threshold (default 1.3).</param>
	/// <param name="zScoreThreshold">Z-score threshold (default 3.0).</param>
	/// <param name="onAnomaly">Callback when anomaly is detected.</param>
	public AnomalyDetector(
		int windowSize = 50,
		double compressionThreshold = 1.3,
		double zScoreThreshold = 3.0,
		Action<AnomalyEvent>? onAnomaly = null)
	{
		_windowSize = Math.Max(10, windowSize);
		_compressionThreshold = compressionThreshold;
		_zScoreThreshold = zScoreThreshold;
		_onAnomaly = onAnomaly;
	}

	/// <summary>
	/// Processes a new jackpot reading and checks for anomalies.
	/// </summary>
	/// <returns>AnomalyEvent if anomalous, null otherwise.</returns>
	public AnomalyEvent? Process(string house, string game, string tier, double value)
	{
		Interlocked.Increment(ref _totalProcessed);
		string key = $"{house}:{game}:{tier}";
		SlidingWindow window = _windows.GetOrAdd(key, _ => new SlidingWindow(_windowSize));

		if (window.Count < 5)
		{
			window.Add(value);
			return null;
		}

		double[] snapshot = window.ToArray();
		double atypicality = AtypicalityScore.Calculate(snapshot, value);
		double zScore = AtypicalityScore.ZScore(snapshot, value);

		bool compressionFlag = atypicality > _compressionThreshold;
		bool zScoreFlag = zScore > _zScoreThreshold;

		window.Add(value);

		if (!compressionFlag && !zScoreFlag)
			return null;

		// Calculate window stats for the event
		double mean = 0;
		foreach (double v in snapshot) mean += v;
		mean /= snapshot.Length;

		double variance = 0;
		foreach (double v in snapshot) variance += (v - mean) * (v - mean);
		double stdDev = Math.Sqrt(variance / snapshot.Length);

		string method = (compressionFlag && zScoreFlag) ? "Both"
			: compressionFlag ? "Compression" : "ZScore";

		var anomaly = new AnomalyEvent
		{
			House = house,
			Game = game,
			Tier = tier,
			AnomalousValue = value,
			AtypicalityRatio = atypicality,
			ZScore = zScore,
			WindowMean = mean,
			WindowStdDev = stdDev,
			WindowSize = snapshot.Length,
			DetectionMethod = method,
		};

		Interlocked.Increment(ref _totalAnomalies);
		_onAnomaly?.Invoke(anomaly);

		return anomaly;
	}

	/// <summary>
	/// Gets the current window size for a specific key.
	/// </summary>
	public int GetWindowSize(string house, string game, string tier)
	{
		string key = $"{house}:{game}:{tier}";
		return _windows.TryGetValue(key, out var w) ? w.Count : 0;
	}

	/// <summary>
	/// Thread-safe sliding window backed by a circular buffer.
	/// </summary>
	private sealed class SlidingWindow
	{
		private readonly double[] _buffer;
		private readonly object _lock = new();
		private int _head;
		private int _count;

		public int Count
		{
			get { lock (_lock) return _count; }
		}

		public SlidingWindow(int capacity)
		{
			_buffer = new double[capacity];
		}

		public void Add(double value)
		{
			lock (_lock)
			{
				_buffer[_head] = value;
				_head = (_head + 1) % _buffer.Length;
				if (_count < _buffer.Length) _count++;
			}
		}

		public double[] ToArray()
		{
			lock (_lock)
			{
				double[] result = new double[_count];
				int start = (_head - _count + _buffer.Length) % _buffer.Length;
				for (int i = 0; i < _count; i++)
					result[i] = _buffer[(start + i) % _buffer.Length];
				return result;
			}
		}
	}
}
