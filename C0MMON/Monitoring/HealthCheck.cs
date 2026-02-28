using System;

namespace P4NTHE0N.C0MMON.Monitoring;

public record HealthCheck(string Component, HealthStatus Status, string Message, long ResponseTimeMs = 0);
