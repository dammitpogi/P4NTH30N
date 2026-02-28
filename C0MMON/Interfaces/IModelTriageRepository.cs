using System.Collections.Generic;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;

namespace P4NTHE0N.C0MMON.Interfaces
{
	public interface IModelTriageRepository
	{
		ModelTriageInfo GetTriageInfo(string modelId);
		void UpdateTriageInfo(ModelTriageInfo triageInfo);
		IEnumerable<ModelTriageInfo> GetAllTriageInfo();
	}
}
