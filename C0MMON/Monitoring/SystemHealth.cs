using System;
using System.Collections.Generic;

namespace P4NTHE0N.C0MMON.Monitoring;

public record SystemHealth(HealthStatus OverallStatus, IEnumerable<HealthCheck> Checks, DateTime LastUpdated, TimeSpan Uptime);
