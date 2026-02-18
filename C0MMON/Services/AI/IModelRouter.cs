using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Services.AI;

public interface IModelRouter
{
	string GetModelForTask(string taskName);
	string[] GetFallbackChain(string taskName);
	Task<bool> IsModelAvailableAsync(string modelId);
	ModelEndpoint? GetEndpoint(string endpointName);
}
