using P4NTHE0N.C0MMON.Entities;

namespace P4NTHE0N.C0MMON.Services
{
	public class CostOptimizer : ICostOptimizer
	{
		public decimal EstimateCost(ComplexityLevel complexity)
		{
			return complexity switch
			{
				ComplexityLevel.Small => 0.05m,
				ComplexityLevel.Medium => 0.15m,
				ComplexityLevel.Large => 0.40m,
				ComplexityLevel.Critical => 1.00m, // Costs more due to required oversight/validation
				_ => 0.20m,
			};
		}
	}
}
