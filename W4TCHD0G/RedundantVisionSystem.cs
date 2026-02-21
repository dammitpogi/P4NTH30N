using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Interfaces;

namespace P4NTH30N.W4TCHD0G;

/// <summary>
/// FOUREYES-016: Redundant vision system with multi-stream failover.
/// Manages multiple OBS stream sources, monitors health, and performs automatic failover.
/// </summary>
public class RedundantVisionSystem : IRedundantVisionSystem
{
	private readonly ConcurrentDictionary<string, StreamSource> _sources = new();
	private readonly ConcurrentDictionary<string, StreamSourceHealth> _healthCache = new();
	private string _activeSourceId = string.Empty;

	public string ActiveSource => _activeSourceId;

	/// <summary>
	/// Adds a stream source to the redundant system.
	/// </summary>
	public void AddSource(StreamSource source)
	{
		_sources[source.Id] = source;
		if (string.IsNullOrEmpty(_activeSourceId) || source.Priority < (_sources.TryGetValue(_activeSourceId, out StreamSource? active) ? active.Priority : int.MaxValue))
		{
			_activeSourceId = source.Id;
			source.IsActive = true;
		}
		Console.WriteLine($"[RedundantVision] Added source '{source.Name}' (priority: {source.Priority})");
	}

	public IReadOnlyList<StreamSource> GetSources()
	{
		return _sources.Values.OrderBy(s => s.Priority).ToList();
	}

	public async Task<bool> SwitchSourceAsync(string sourceId, CancellationToken cancellationToken = default)
	{
		if (!_sources.TryGetValue(sourceId, out StreamSource? target))
			return false;

		// Deactivate current source
		if (_sources.TryGetValue(_activeSourceId, out StreamSource? current))
			current.IsActive = false;

		// Activate new source
		target.IsActive = true;
		_activeSourceId = sourceId;

		Console.WriteLine($"[RedundantVision] Switched to source '{target.Name}'");
		return await Task.FromResult(true);
	}

	public async Task<bool> FailoverAsync(CancellationToken cancellationToken = default)
	{
		IReadOnlyList<StreamSourceHealth> healthResults = await CheckAllSourcesAsync(cancellationToken);

		// Find the best available source that isn't the current one
		StreamSourceHealth? bestAlternative = healthResults
			.Where(h => h.IsAvailable && h.SourceId != _activeSourceId)
			.OrderBy(h =>
			{
				_sources.TryGetValue(h.SourceId, out StreamSource? src);
				return src?.Priority ?? int.MaxValue;
			})
			.ThenBy(h => h.LatencyMs)
			.FirstOrDefault();

		if (bestAlternative == null)
		{
			Console.WriteLine("[RedundantVision] No alternative sources available for failover");
			return false;
		}

		Console.WriteLine($"[RedundantVision] Failing over to source '{bestAlternative.SourceId}' (latency: {bestAlternative.LatencyMs}ms)");
		return await SwitchSourceAsync(bestAlternative.SourceId, cancellationToken);
	}

	public async Task<IReadOnlyList<StreamSourceHealth>> CheckAllSourcesAsync(CancellationToken cancellationToken = default)
	{
		List<StreamSourceHealth> results = new();

		foreach (StreamSource source in _sources.Values)
		{
			StreamSourceHealth health = new() { SourceId = source.Id };

			try
			{
				Stopwatch sw = Stopwatch.StartNew();
				// Simulate health check - in production this would ping the stream URL
				await Task.Delay(10, cancellationToken);
				sw.Stop();

				health.IsAvailable = true;
				health.LatencyMs = sw.ElapsedMilliseconds;
				health.StatusMessage = "Available";
			}
			catch (Exception ex)
			{
				health.IsAvailable = false;
				health.StatusMessage = $"Unavailable: {ex.Message}";
			}

			_healthCache[source.Id] = health;
			results.Add(health);
		}

		return results;
	}
}
