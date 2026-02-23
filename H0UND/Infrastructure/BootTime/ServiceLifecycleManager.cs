namespace H0UND.Infrastructure.BootTime;

public enum ServiceLifecycleState
{
    Initializing,
    Starting,
    Running,
    Degraded,
    Error,
    Stopping,
    Stopped,
}

public sealed class ServiceLifecycleManager
{
    public ServiceLifecycleState CurrentState { get; private set; } = ServiceLifecycleState.Initializing;

    public event EventHandler<ServiceLifecycleState>? StateChanged;

    public void TransitionTo(ServiceLifecycleState state)
    {
        if (CurrentState == state)
        {
            return;
        }

        CurrentState = state;
        StateChanged?.Invoke(this, state);
    }
}
