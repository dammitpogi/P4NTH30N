using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-011: Unbreakable contract for OBS Studio integration.
/// C0MMON-side interface (mirrors W4TCHD0G.IOBSClient for decoupling).
/// </summary>
public interface IOBSClient
{
	Task ConnectAsync();
	Task DisconnectAsync();
	bool IsConnected { get; }
	Task<bool> IsStreamActiveAsync();
	Task<long> GetLatencyAsync();
}
