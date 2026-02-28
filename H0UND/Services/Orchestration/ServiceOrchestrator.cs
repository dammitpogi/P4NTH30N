using System.Collections.Concurrent;
using H0UND.Infrastructure.BootTime;
using P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

namespace H0UND.Services.Orchestration;

public class ServiceOrchestrator : IServiceOrchestrator, IDisposable
{
    private readonly ConcurrentDictionary<string, IManagedService> _services = new();
    private readonly System.Threading.Timer _healthCheckTimer;
    private readonly ConcurrentDictionary<string, int> _consecutiveFailures = new();
    private readonly ConcurrentDictionary<string, bool> _restartInProgress = new();
    private readonly CancellationTokenSource _shutdown = new();
    private readonly StartupConfig _startupConfig;
    private readonly IErrorEvidence _errors;
    private int _healthCheckRunning;
    private bool _disposed;

    public IReadOnlyCollection<IManagedService> Services => _services.Values.ToList();
    public StartupConfig StartupConfig => _startupConfig;

    public event EventHandler<OrchestratorEventArgs>? OrchestratorEvent;

    public ServiceOrchestrator(TimeSpan? healthCheckInterval = null, StartupConfig? startupConfig = null, IErrorEvidence? errors = null)
    {
        var interval = healthCheckInterval ?? TimeSpan.FromSeconds(30);
        _healthCheckTimer = new System.Threading.Timer(OnHealthCheckTick, null, interval, interval);
        _startupConfig = startupConfig ?? new StartupConfig();
        _errors = errors ?? NoopErrorEvidence.Instance;
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
            if (ShouldSample("H0UND-ORCH-HEALTH-SKIP", 20))
            {
                _errors.CaptureWarning(
                    "H0UND-ORCH-HEALTH-SKIP-001",
                    "Health check tick skipped due to active run",
                    context: new Dictionary<string, object>
                    {
                        ["services"] = _services.Count,
                    });
            }

            return;
        }

        try
        {
            using ErrorScope healthScope = _errors.BeginScope(
                "H0UND.ServiceOrchestrator",
                "HealthCheckTick",
                new Dictionary<string, object>
                {
                    ["serviceCount"] = _services.Count,
                });

            foreach (var service in _services.Values.Where(s => s.Status == ServiceStatus.Running))
            {
                bool healthy;
                try
                {
                    healthy = await service.HealthCheckAsync(_shutdown.Token);
                }
                catch (Exception ex)
                {
                    _errors.Capture(
                        ex,
                        "H0UND-ORCH-HEALTH-ERR-001",
                        "Service health check threw exception",
                        context: new Dictionary<string, object>
                        {
                            ["service"] = service.Name,
                        });
                    continue;
                }

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
                        else
                        {
                            _errors.CaptureWarning(
                                "H0UND-ORCH-RESTART-COALESCE-001",
                                "Restart already in progress for service",
                                context: new Dictionary<string, object>
                                {
                                    ["service"] = service.Name,
                                    ["failures"] = failures,
                                });
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
            _errors.Capture(
                ex,
                "H0UND-ORCH-HEALTH-LOOP-001",
                "Unhandled exception in health check loop",
                context: new Dictionary<string, object>
                {
                    ["serviceCount"] = _services.Count,
                });

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

            if (delaySeconds <= 0)
            {
                _errors.CaptureInvariantFailure(
                    "H0UND-ORCH-RESTART-INV-001",
                    "Restart delay must be positive",
                    expected: true,
                    actual: delaySeconds > 0,
                    context: new Dictionary<string, object>
                    {
                        ["service"] = service.Name,
                        ["failures"] = failures,
                        ["delaySeconds"] = delaySeconds,
                    });
            }

            if (ShouldSample($"H0UND-ORCH-RESTART-SCHED-{service.Name}", 5))
            {
                _errors.CaptureWarning(
                    "H0UND-ORCH-RESTART-SCHED-001",
                    "Restart scheduled after health check failures",
                    context: new Dictionary<string, object>
                    {
                        ["service"] = service.Name,
                        ["failures"] = failures,
                        ["delaySeconds"] = delaySeconds,
                    });
            }

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
            _errors.Capture(
                ex,
                "H0UND-ORCH-RESTART-ERR-001",
                "Service restart failed",
                context: new Dictionary<string, object>
                {
                    ["service"] = service.Name,
                    ["failures"] = failures,
                });

            OrchestratorEvent?.Invoke(this, new OrchestratorEventArgs
            {
                ServiceName = service.Name,
                EventType = "RestartFailed",
                Message = ex.Message,
            });
        }
        finally
        {
            bool removed = _restartInProgress.TryRemove(service.Name, out _);
            if (!removed)
            {
                _errors.CaptureInvariantFailure(
                    "H0UND-ORCH-RESTART-INV-002",
                    "Restart in-progress marker missing during release",
                    expected: true,
                    actual: removed,
                    context: new Dictionary<string, object>
                    {
                        ["service"] = service.Name,
                    });
            }
        }
    }

    private static bool ShouldSample(string key, int modulus)
    {
        if (modulus <= 1)
        {
            return true;
        }

        unchecked
        {
            int hash = 17;
            foreach (char c in key)
            {
                hash = hash * 31 + c;
            }

            int bucket = Math.Abs(hash % modulus);
            return bucket == 0;
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

    public static void RecordHealthLoopError(IErrorEvidence errors, Exception ex, string serviceName, int serviceCount)
    {
        errors.Capture(
            ex,
            "H0UND-ORCH-HEALTH-LOOP-001",
            "Unhandled exception in health check loop",
            context: new Dictionary<string, object>
            {
                ["service"] = serviceName,
                ["serviceCount"] = serviceCount,
            });
    }

    public static void RecordRestartSchedule(IErrorEvidence errors, string serviceName, int failures, int delaySeconds)
    {
        errors.CaptureWarning(
            "H0UND-ORCH-RESTART-SCHED-001",
            "Restart scheduled after health check failures",
            context: new Dictionary<string, object>
            {
                ["service"] = serviceName,
                ["failures"] = failures,
                ["delaySeconds"] = delaySeconds,
            });
    }
}
