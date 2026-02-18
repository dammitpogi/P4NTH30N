using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTH30N.PROF3T;

public interface IModelManager
{
	Task<ModelInstance?> GetModelAsync(string modelId);
	Task<bool> LoadModelAsync(string modelId, string endpointUrl);
	Task UnloadModelAsync(string modelId);
	IReadOnlyList<ModelInstance> GetLoadedModels();
	Task<bool> IsHealthyAsync();
}
