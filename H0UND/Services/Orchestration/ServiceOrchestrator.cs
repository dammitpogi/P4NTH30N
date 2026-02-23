using System.Collections.Concurrent;
using H0UND.Infrastructure.BootTime;

namespace H0UND.Services.Orchestration;

public class ServiceOrchestrator : IServiceOrchestrator, IDisposable
{
    private readonly ConcurrentDictionary<string, IManagedService> _services = new();
    private readonly System.Threading.Timer _healthCheckTimer;
    private readonly ConcurrentDictionary<string, int> _consecutiveFailures = new();
    private readonly ConcurrentDictionary<string, bool> _restartInProgress = new();
    private readonly CancellationTokenSource _shutdown = new();
    private readonly StartupConfig _startupConfig;
    private int _healthCheckRunning;
    private bool _disposed;

    public IReadOnlyCollection<IManagedService> Services => _services.Values.ToList();
    public StartupConfig StartupConfig => _startupConfig;

    public event EventHandler<OrchestratorEventArgs>? OrchestratorEvent;

    public ServiceOrchestrator(TimeSpan? healthCheckInterval = null, StartupConfig? startupConfig = null)
    {
        var interval = healthCheckInterval ?? TimeSpan.FromSeconds(30);
        _healthCheckTimer = new System.Threading.Timer(OnHealthCheckTick, null, interval, interval);
        _startupConfig = startupConfig ?? new StartupConfig();
    }

    public void RegisterService(IManagedService service)
    {
        _services[service.Name] = service;
        service.StatusChanged += OnServiceStatusChanged;
        service.LogMessage += OnServiceLogMessage;

        OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
        {
            ServiceName = service.Name,
            EventType = "Registered",
            Message = $"Service {service.Name} registered",
        });
    }

    public async Task StartAllAsync(CancellationToken cancellationToken = default)
    {
        // Apply global startup delay if configured
        if (_startupConfig.DelaySeconds > 0)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = "orchestrator",
                EventType = "StartupDelay",
                Message = $"Waiting {_startupConfig.DelaySeconds}s before starting services",
            });
            await Task.Delay(TimeSpan.FromSeconds(_startupConfig.DelaySeconds), cancellationToken);
        }

        var servicesList = _services.Values.ToList();
        for (int i = 0; i < servicesList.Count; i++)
        {
            var service = servicesList[i];

            // Apply stagger interval between service starts
            if (i > 0 && _startupConfig.ServiceStartInterval > 0)
            {
                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = "orchestrator",
                    EventType = "StaggerDelay",
                    Message = $"Waiting {_startupConfig.ServiceStartInterval}s before starting {service.Name}",
                });
                await Task.Delay(TimeSpan.FromSeconds(_startupConfig.ServiceStartInterval), cancellationToken);
            }

            try
            {
                await service.StartAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = service.Name,
                    EventType = "StartFailed",
                    Message = ex.Message,
                });
            }
        }
    }

    public async Task StopAllAsync(CancellationToken cancellationToken = default)
    {
        foreach (var service in _services.Values.Reverse())
        {
            try
            {
                await service.StopAsync(cancellationToken);
            }
            catch (Exception ex)
            {
                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = service.Name,
                    EventType = "StopFailed",
                    Message = ex.Message,
                });
            }
        }
    }

    public Task<IManagedService?> GetServiceAsync(string name)
    {
        _services.TryGetValue(name, out var service);
        return Task.FromResult(service);
    }

    private async void OnHealthCheckTick(object? state)
    {
        if (Interlocked.CompareExchange(ref _healthCheckRunning, 1, 0) != 0)
        {
            return;
        }

        try
        {
        foreach (var service in _services.Values.Where(s => s.Status == ServiceStatus.Running))
        {
            var healthy = await service.HealthCheckAsync(_shutdown.Token);
            if (!healthy)
            {
                var failures = _consecutiveFailures.AddOrUpdate(
                    service.Name,
                    1,
                    (_, current) => current + 1);

                OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
                {
                    ServiceName = service.Name,
                    EventType = "HealthCheckFailed",
                    Message = $"Service failed health check ({failures} consecutive)",
                });

                if (failures >= 2)
                {
                    if (_restartInProgress.TryAdd(service.Name, true))
                    {
                        _ = RestartServiceAsync(service, failures, _shutdown.Token);
                    }
                }
                continue;
            }

            _consecutiveFailures.TryRemove(service.Name, out _);
        }
        }
        catch (OperationCanceledException)
        {
        }
        catch (Exception ex)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = "orchestrator",
                EventType = "HealthLoopError",
                Message = ex.Message,
            });
        }
        finally
        {
            Interlocked.Exchange(ref _healthCheckRunning, 0);
        }
    }

    private async Task RestartServiceAsync(
        IManagedService service,
        int failures,
        CancellationToken cancellationToken)
    {
        try
        {
            var cappedFailures = Math.Min(failures, 6);
            var delaySeconds = Math.Min(60, 2 * (1 << (cappedFailures - 1)));

            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "RestartScheduled",
                Message = $"Restart in {delaySeconds}s after {failures} failed checks",
            });

            await Task.Delay(TimeSpan.FromSeconds(delaySeconds), cancellationToken);

            await service.StopAsync(cancellationToken);
            await service.StartAsync(cancellationToken);
            _consecutiveFailures.TryRemove(service.Name, out _);

            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "RestartSucceeded",
                Message = "Service restarted successfully",
            });
        }
        catch (OperationCanceledException)
        {
        }
        catch (Exception ex)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "RestartFailed",
                Message = ex.Message,
            });
        }
        finally
        {
            _restartInProgress.TryRemove(service.Name, out _);
        }
    }

    private void OnServiceStatusChanged(object? sender, ServiceStatusChangedEventArgs e)
    {
        if (sender is IManagedService service)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "StatusChanged",
                Message = $"{e.OldStatus} -> {e.NewStatus}",
            });
        }
    }

    private void OnServiceLogMessage(object? sender, string message)
    {
        if (sender is IManagedService service)
        {
            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "Log",
                Message = message,
            });
        }
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _disposed = true;
        _shutdown.Cancel();
        _healthCheckTimer.Dispose();
        _shutdown.Dispose();
        foreach (var service in _services.Values)
        {
            (service as IDisposable)?.Dispose();
        }
    }
}
