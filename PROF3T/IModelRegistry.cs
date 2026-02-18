using System.Collections.Generic;

namespace P4NTH30N.PROF3T;

public interface IModelRegistry
{
	void Register(string modelId, ModelInstance instance);
	void Unregister(string modelId);
	ModelInstance? Get(string modelId);
	IReadOnlyList<ModelInstance> GetAll();
	bool Contains(string modelId);
}
