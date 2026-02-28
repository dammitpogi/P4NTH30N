using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTHE0N.C0MMON.Monitoring;

public interface IHealthCheckService
{
	Task<SystemHealth> GetSystemHealthAsync();
	Task<HealthCheck> CheckMongoDBHealth();
	Task<HealthCheck> CheckExternalAPIHealth();
	Task<HealthCheck> CheckWorkerPoolHealth();
	Task<HealthCheck> CheckVisionStreamHealth();
}
