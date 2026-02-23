namespace H0UND.Services.Orchestration;

public interface IManagedService
{
    string Name { get; }
    ServiceStatus Status { get; }
    Task StartAsync(CancellationToken cancellationToken = default);
    Task StopAsync(CancellationToken cancellationToken = default);
    Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default);
    event EventHandler<ServiceStatusChangedEventArgs>? StatusChanged;
    event EventHandler<string>? LogMessage;
}

public enum ServiceStatus
{
    Stopped,
    Starting,
    Running,
    Stopping,
    Degraded,
    Error,
}

public class ServiceStatusChangedEventArgs : EventArgs
{
    public ServiceStatus OldStatus { get; set; }
    public ServiceStatus NewStatus { get; set; }
    public string? Message { get; set; }
}
