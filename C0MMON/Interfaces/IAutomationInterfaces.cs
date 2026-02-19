
using P4NTH30N.C0MMON.Entities;

namespace P4NTH30N.C0MMON.Interfaces
{
    public interface IAutomationEngine
    {
        void ExecuteDecision(string decisionId);
        ComplexityLevel ClassifyComplexity(string decisionId);
    }

    public interface ICostOptimizer
    {
        decimal EstimateCost(ComplexityLevel complexity);
    }
}
