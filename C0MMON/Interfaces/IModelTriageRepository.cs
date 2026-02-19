
using P4NTH30N.C0MMON.Infrastructure.Resilience;
using System.Collections.Generic;

namespace P4NTH30N.C0MMON.Interfaces
{
    public interface IModelTriageRepository
    {
        ModelTriageInfo GetTriageInfo(string modelId);
        void UpdateTriageInfo(ModelTriageInfo triageInfo);
        IEnumerable<ModelTriageInfo> GetAllTriageInfo();
    }
}
