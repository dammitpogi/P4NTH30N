using System.Collections.Generic;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Monitoring;

public interface IHealthCheckService
{
	Task<SystemHealth> GetSystemHealthAsync();
	Task<HealthCheck> CheckMongoDBHealth();
	Task<HealthCheck> CheckExternalAPIHealth();
	Task<HealthCheck> CheckWorkerPoolHealth();
	Task<HealthCheck> CheckVisionStreamHealth();
}
