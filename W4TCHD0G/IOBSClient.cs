using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G;

public interface IOBSClient
{
	Task ConnectAsync();
	Task DisconnectAsync();
	bool IsConnected { get; }
	Task<bool> IsStreamActiveAsync();
	Task<long> GetLatencyAsync();
	Task<VisionFrame?> CaptureFrameAsync(string sourceName);
}
