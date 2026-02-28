using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G;

public interface ILMStudioClient
{
	Task<VisionAnalysis> AnalyzeFrameAsync(VisionFrame frame, string modelId);
	Task<bool> IsAvailableAsync();
	Task<List<string>> GetLoadedModelsAsync();
}
