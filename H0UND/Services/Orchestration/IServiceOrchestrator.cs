namespace H0UND.Services.Orchestration;

public interface IServiceOrchestrator
{
    IReadOnlyCollection<IManagedService> Services { get; }
    void RegisterService(IManagedService service);
    Task StartAllAsync(CancellationToken cancellationToken = default);
    Task StopAllAsync(CancellationToken cancellationToken = default);
    Task<IManagedService?> GetServiceAsync(string name);
    event EventHandler<OrchestratorEventArgs>? OrchestratorEvent;
}

public class OrchestratorEventArgs : EventArgs
{
    public string ServiceName { get; set; } = string.Empty;
    public string EventType { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
}
