using System;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-012: Stream Health Monitor contract for fallback detection.
/// Monitors RTMP stream health: latency, FPS, drop rate.
/// </summary>
public interface IStreamHealthMonitor : IDisposable
{
	/// <summary>
	/// Starts periodic health monitoring.
	/// </summary>
	void Start(int intervalMs = 5000);

	/// <summary>
	/// Stops health monitoring.
	/// </summary>
	void Stop();

	/// <summary>
	/// Current measured FPS.
	/// </summary>
	double CurrentFps { get; }

	/// <summary>
	/// Current health status (0=Unknown, 1=Healthy, 2=Warning, 3=Critical).
	/// </summary>
	int CurrentHealthLevel { get; }

	/// <summary>
	/// Event raised when health status changes. Args: (healthLevel, summary).
	/// </summary>
	event Action<int, string>? OnHealthChanged;
}
