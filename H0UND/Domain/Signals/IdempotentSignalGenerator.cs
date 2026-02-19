using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Monitoring;
using P4NTH30N.C0MMON.Infrastructure.Resilience;

namespace P4NTH30N.H0UND.Domain.Signals;

public sealed class IdempotentSignalGenerator
{
	private readonly IDistributedLockService _lockService;
	private readonly ISignalDeduplicationCache _dedupCache;
	private readonly IDeadLetterQueue _deadLetterQueue;
	private readonly RetryPolicy _retryPolicy;
	private readonly CircuitBreaker _circuitBreaker;
	private readonly SignalMetrics _metrics;
	private readonly string _instanceId;
	private readonly Action<string>? _logger;

	private static readonly TimeSpan s_lockTtl = TimeSpan.FromSeconds(30);

	public IdempotentSignalGenerator(
		IDistributedLockService lockService,
		ISignalDeduplicationCache dedupCache,
		IDeadLetterQueue deadLetterQueue,
		RetryPolicy retryPolicy,
		CircuitBreaker circuitBreaker,
		SignalMetrics metrics,
		Action<string>? logger = null)
	{
		_lockService = lockService;
		_dedupCache = dedupCache;
		_deadLetterQueue = deadLetterQueue;
		_retryPolicy = retryPolicy;
		_circuitBreaker = circuitBreaker;
		_metrics = metrics;
		_instanceId = $"H0UND-{Environment.MachineName}-{Environment.ProcessId}";
		_logger = logger;
	}

	public List<Signal> GenerateSignals(
		IUnitOfWork uow,
		List<IGrouping<(string House, string Game), Credential>> groups,
		List<Jackpot> jackpots,
		List<Signal> existingSignals)
	{
		List<Signal> allQualified = new();

		foreach (IGrouping<(string House, string Game), Credential> group in groups)
		{
			string lockResource = $"signal:{group.Key.House}:{group.Key.Game}";

			try
			{
				List<Signal> groupSignals = ProcessGroupWithProtection(
					uow, group, jackpots, existingSignals, lockResource);
				allQualified.AddRange(groupSignals);
			}
			catch (CircuitBreakerOpenException)
			{
				_metrics.RecordCircuitBreakerTrip();
				_logger?.Invoke($"[IdempotentSignal] Circuit open — falling through unprotected for {group.Key.House}/{group.Key.Game}");
				// Fallback: run unprotected to maintain availability
				List<Signal> fallbackSignals = SignalService.GenerateSignals(
					uow,
					new List<IGrouping<(string House, string Game), Credential>> { group },
					jackpots.Where(j => j.House == group.Key.House && j.Game == group.Key.Game).ToList(),
					existingSignals);
				allQualified.AddRange(fallbackSignals);
			}
			catch (Exception ex)
			{
				_logger?.Invoke($"[IdempotentSignal] Unexpected error for {group.Key.House}/{group.Key.Game}: {ex.Message}");
			}
		}

		_metrics.ReportIfDue();
		return allQualified;
	}

	private List<Signal> ProcessGroupWithProtection(
		IUnitOfWork uow,
		IGrouping<(string House, string Game), Credential> group,
		List<Jackpot> jackpots,
		List<Signal> existingSignals,
		string lockResource)
	{
		// Phase 1: Try to acquire distributed lock
		bool lockAcquired = false;
		try
		{
			lockAcquired = _circuitBreaker.ExecuteAsync(async () =>
			{
				return _lockService.TryAcquire(lockResource, _instanceId, s_lockTtl);
			}).GetAwaiter().GetResult();
		}
		catch (CircuitBreakerOpenException)
		{
			throw; // Let caller handle circuit breaker fallback
		}
		catch (Exception ex)
		{
			_logger?.Invoke($"[IdempotentSignal] Lock acquire failed for {lockResource}: {ex.Message}");
			// Cannot acquire lock — treat as contention
			_metrics.RecordLockContention();
			return new List<Signal>();
		}

		if (!lockAcquired)
		{
			_metrics.RecordLockContention();
			_logger?.Invoke($"[IdempotentSignal] Lock contention on {lockResource} — skipping");
			return new List<Signal>();
		}

		_metrics.RecordLockAcquired();

		try
		{
			using IDisposable latencyScope = _metrics.MeasureLatency();

			// Phase 2: Generate signals via existing SignalService
			List<Jackpot> groupJackpots = jackpots
				.Where(j => j.House == group.Key.House && j.Game == group.Key.Game)
				.ToList();

			List<Signal> qualified = _retryPolicy.Execute(() =>
			{
				return SignalService.GenerateSignals(
					uow,
					new List<IGrouping<(string House, string Game), Credential>> { group },
					groupJackpots,
					existingSignals);
			}, $"GenerateSignals:{lockResource}");

			// Phase 3: Deduplicate
			List<Signal> deduplicated = new();
			foreach (Signal signal in qualified)
			{
				string key = SignalDeduplicationCache.BuildKey(signal);

				if (_dedupCache.IsProcessed(key))
				{
					_metrics.RecordDeduplicated();
					_logger?.Invoke($"[IdempotentSignal] Deduplicated signal {key}");
					continue;
				}

				_dedupCache.MarkProcessed(key);
				deduplicated.Add(signal);
			}

			_metrics.RecordSignalGenerated(deduplicated.Count);
			return deduplicated;
		}
		catch (Exception ex)
		{
			// Dead-letter failed signals
			_logger?.Invoke($"[IdempotentSignal] Signal generation failed for {lockResource}: {ex.Message}");
			Signal deadSignal = new()
			{
				House = group.Key.House,
				Game = group.Key.Game,
				Username = "GROUP_FAILURE",
				Priority = 0,
			};
			_deadLetterQueue.Enqueue(deadSignal, $"Generation failed: {ex.Message}", ex);
			_metrics.RecordDeadLettered();
			return new List<Signal>();
		}
		finally
		{
			// Always release lock
			try
			{
				_lockService.Release(lockResource, _instanceId);
			}
			catch (Exception ex)
			{
				_logger?.Invoke($"[IdempotentSignal] Lock release failed for {lockResource}: {ex.Message}");
			}
		}
	}
}
