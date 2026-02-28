using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.C0MMON.Infrastructure.Resilience;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Monitoring;

public class HealthCheckService : IHealthCheckService
{
	private readonly IMongoDatabaseProvider _dbProvider;
	private readonly ICircuitBreaker? _apiCircuit;
	private readonly ICircuitBreaker? _mongoCircuit;
	private readonly IUnitOfWork? _uow;
	private readonly IOBSClient? _obsClient;
	private readonly Stopwatch _uptimeStopwatch = Stopwatch.StartNew();

	public HealthCheckService(
		IMongoDatabaseProvider dbProvider,
		ICircuitBreaker? apiCircuit = null,
		ICircuitBreaker? mongoCircuit = null,
		IUnitOfWork? uow = null,
		IOBSClient? obsClient = null
	)
	{
		_dbProvider = dbProvider;
		_apiCircuit = apiCircuit;
		_mongoCircuit = mongoCircuit;
		_uow = uow;
		_obsClient = obsClient;
	}

	public async Task<SystemHealth> GetSystemHealthAsync()
	{
		List<HealthCheck> checks = new List<HealthCheck>
		{
			await CheckMongoDBHealth(),
			await CheckExternalAPIHealth(),
			await CheckWorkerPoolHealth(),
			await CheckVisionStreamHealth(),
		};

		HealthStatus overallStatus = HealthStatus.Healthy;
		if (checks.Any(c => c.Status == HealthStatus.Unhealthy))
			overallStatus = HealthStatus.Unhealthy;
		else if (checks.Any(c => c.Status == HealthStatus.Degraded))
			overallStatus = HealthStatus.Degraded;

		return new SystemHealth(OverallStatus: overallStatus, Checks: checks, LastUpdated: DateTime.UtcNow, Uptime: _uptimeStopwatch.Elapsed);
	}

	public async Task<HealthCheck> CheckMongoDBHealth()
	{
		try
		{
			TimeSpan latency = await _dbProvider.PingAsync();
			long ms = (long)latency.TotalMilliseconds;
			if (ms > 100)
				return new HealthCheck("MongoDB", HealthStatus.Degraded, $"High latency: {ms}ms", ms);
			return new HealthCheck("MongoDB", HealthStatus.Healthy, $"Ping: {ms}ms", ms);
		}
		catch (Exception ex)
		{
			return new HealthCheck("MongoDB", HealthStatus.Unhealthy, $"Ping failed: {ex.Message}");
		}
	}

	public async Task<HealthCheck> CheckExternalAPIHealth()
	{
		return await Task.FromResult(
			_apiCircuit == null
				? new HealthCheck("ExternalAPI", HealthStatus.Healthy, "No circuit breaker configured")
				: _apiCircuit.State switch
				{
					CircuitState.Open => new HealthCheck("ExternalAPI", HealthStatus.Unhealthy, $"Circuit OPEN ({_apiCircuit.FailureCount} failures)"),
					CircuitState.HalfOpen => new HealthCheck("ExternalAPI", HealthStatus.Degraded, "Circuit HALF-OPEN (testing recovery)"),
					_ => new HealthCheck("ExternalAPI", HealthStatus.Healthy, $"Circuit closed ({_apiCircuit.FailureCount} recent failures)"),
				}
		);
	}

	public async Task<HealthCheck> CheckWorkerPoolHealth()
	{
		if (_uow == null)
			return await Task.FromResult(new HealthCheck("SignalQueue", HealthStatus.Healthy, "No UoW configured"));

		try
		{
			List<Signal> signals = _uow.Signals.GetAll();
			int depth = signals.Count;
			if (depth > 100)
				return await Task.FromResult(new HealthCheck("SignalQueue", HealthStatus.Unhealthy, $"Queue depth: {depth} (>100)"));
			if (depth > 50)
				return await Task.FromResult(new HealthCheck("SignalQueue", HealthStatus.Degraded, $"Queue depth: {depth} (>50)"));
			return await Task.FromResult(new HealthCheck("SignalQueue", HealthStatus.Healthy, $"Queue depth: {depth}"));
		}
		catch (Exception ex)
		{
			return await Task.FromResult(new HealthCheck("SignalQueue", HealthStatus.Unhealthy, $"Failed: {ex.Message}"));
		}
	}

	public async Task<HealthCheck> CheckVisionStreamHealth()
	{
		if (_obsClient == null)
			return await Task.FromResult(new HealthCheck("VisionStream", HealthStatus.Healthy, "No OBS client configured"));

		try
		{
			if (!_obsClient.IsConnected)
				return new HealthCheck("VisionStream", HealthStatus.Unhealthy, "OBS not connected");

			bool streamActive = await _obsClient.IsStreamActiveAsync();
			if (!streamActive)
				return new HealthCheck("VisionStream", HealthStatus.Unhealthy, "Stream not active");

			long latency = await _obsClient.GetLatencyAsync();
			if (latency > 1000)
				return new HealthCheck("VisionStream", HealthStatus.Unhealthy, $"Stream latency critical: {latency}ms", latency);
			if (latency > 500)
				return new HealthCheck("VisionStream", HealthStatus.Degraded, $"Stream latency high: {latency}ms", latency);

			return new HealthCheck("VisionStream", HealthStatus.Healthy, $"Stream active, latency: {latency}ms", latency);
		}
		catch (Exception ex)
		{
			return new HealthCheck("VisionStream", HealthStatus.Unhealthy, $"Vision check failed: {ex.Message}");
		}
	}
}
