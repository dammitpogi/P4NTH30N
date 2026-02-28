using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-016: Contract for redundant vision system with multi-stream support.
/// Manages multiple OBS stream sources for failover and redundancy.
/// </summary>
public interface IRedundantVisionSystem
{
	/// <summary>
	/// Gets the currently active stream source.
	/// </summary>
	string ActiveSource { get; }

	/// <summary>
	/// Gets all configured stream sources.
	/// </summary>
	IReadOnlyList<StreamSource> GetSources();

	/// <summary>
	/// Switches to a different stream source.
	/// </summary>
	Task<bool> SwitchSourceAsync(string sourceId, CancellationToken cancellationToken = default);

	/// <summary>
	/// Performs automatic failover to the best available source.
	/// </summary>
	Task<bool> FailoverAsync(CancellationToken cancellationToken = default);

	/// <summary>
	/// Checks health of all configured sources.
	/// </summary>
	Task<IReadOnlyList<StreamSourceHealth>> CheckAllSourcesAsync(CancellationToken cancellationToken = default);
}

public class StreamSource
{
	public string Id { get; set; } = string.Empty;
	public string Name { get; set; } = string.Empty;
	public string Url { get; set; } = string.Empty;
	public int Priority { get; set; }
	public bool IsActive { get; set; }
}

public class StreamSourceHealth
{
	public string SourceId { get; set; } = string.Empty;
	public bool IsAvailable { get; set; }
	public long LatencyMs { get; set; }
	public double FPS { get; set; }
	public string StatusMessage { get; set; } = string.Empty;
}
