using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-011: Unbreakable contract for LM Studio local model client.
/// C0MMON-side interface (mirrors W4TCHD0G.ILMStudioClient for decoupling).
/// </summary>
public interface ILMStudioClient
{
	Task<bool> IsAvailableAsync();
	Task<List<string>> GetLoadedModelsAsync();
}
