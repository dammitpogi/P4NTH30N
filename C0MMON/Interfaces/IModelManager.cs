using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Interfaces;

/// <summary>
/// FOUREYES-013: C0MMON-side contract for dynamic model loading.
/// Mirrors PROF3T.IModelManager for cross-project decoupling.
/// </summary>
public interface IModelManager
{
	Task<Entities.ModelInstance?> GetModelAsync(string modelId);
	Task<bool> LoadModelAsync(string modelId, string endpointUrl);
	Task UnloadModelAsync(string modelId);
	IReadOnlyList<Entities.ModelInstance> GetLoadedModels();
	Task<bool> IsHealthyAsync();
}
