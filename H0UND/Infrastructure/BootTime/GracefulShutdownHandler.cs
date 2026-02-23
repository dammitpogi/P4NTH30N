using H0UND.Services.Orchestration;

namespace H0UND.Infrastructure.BootTime;

public sealed class GracefulShutdownHandler
{
    private readonly IServiceOrchestrator _orchestrator;

    public GracefulShutdownHandler(IServiceOrchestrator orchestrator)
    {
        _orchestrator = orchestrator;
    }

    public async Task ShutdownAsync(CancellationToken cancellationToken = default)
    {
        await _orchestrator.StopAllAsync(cancellationToken);
    }
}
