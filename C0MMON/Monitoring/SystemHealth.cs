using System;
using System.Collections.Generic;

namespace P4NTH30N.C0MMON.Monitoring;

public record SystemHealth(HealthStatus OverallStatus, IEnumerable<HealthCheck> Checks, DateTime LastUpdated, TimeSpan Uptime);
