using System.Diagnostics;

namespace H0UND.Services.Orchestration;

public abstract class ManagedService : IManagedService, IDisposable
{
    protected readonly ExponentialBackoffRetryPolicy RetryPolicy;
    protected Process? Process;
    protected bool Disposed;

    public string Name { get; protected set; } = string.Empty;
    public ServiceStatus Status { get; protected set; } = ServiceStatus.Stopped;

    public event EventHandler<ServiceStatusChangedEventArgs>? StatusChanged;
    public event EventHandler<string>? LogMessage;

    protected ManagedService(string name)
    {
        Name = name;
        RetryPolicy = new ExponentialBackoffRetryPolicy();
    }

    protected void SetStatus(ServiceStatus newStatus, string? message = null)
    {
        var oldStatus = Status;
        Status = newStatus;
        StatusChanged?.Invoke(this, new ServiceStatusChangedEventArgs
        {
            OldStatus = oldStatus,
            NewStatus = newStatus,
            Message = message,
        });
        LogMessage?.Invoke(this, $"[{Name}] Status: {oldStatus} -> {newStatus}");
    }

    protected void Log(string message)
    {
        LogMessage?.Invoke(this, $"[{Name}] {message}");
    }

    public abstract Task StartAsync(CancellationToken cancellationToken = default);
    public abstract Task StopAsync(CancellationToken cancellationToken = default);
    public abstract Task<bool> HealthCheckAsync(CancellationToken cancellationToken = default);

    public virtual void Dispose()
    {
        if (Disposed)
        {
            return;
        }

        Disposed = true;
        Process?.Dispose();
    }
}
