using System;
using System.Collections.Concurrent;
using System.Linq;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Infrastructure.Resilience
{
	public class ProactiveCircuitBreaker
	{
		private readonly IModelTriageRepository _triageRepository;
		private readonly BreakerSettings _settings;
		private readonly ConcurrentDictionary<string, FailureTracker> _failureTrackers = new ConcurrentDictionary<string, FailureTracker>();

		public ProactiveCircuitBreaker(IModelTriageRepository triageRepository, BreakerSettings settings)
		{
			_triageRepository = triageRepository;
			_settings = settings;
		}

		public bool IsOpen(string modelId)
		{
			var triageInfo = _triageRepository.GetTriageInfo(modelId);
			return triageInfo != null && triageInfo.IsTriaged;
		}

		public void RecordFailure(string modelId)
		{
			var tracker = _failureTrackers.GetOrAdd(modelId, _ => new FailureTracker());
			tracker.AddFailure(DateTime.UtcNow);

			var triageInfo = _triageRepository.GetTriageInfo(modelId) ?? new ModelTriageInfo { ModelId = modelId };

			if (ShouldTriage(tracker, triageInfo))
			{
				triageInfo.IsTriaged = true;
				triageInfo.FailureCount++;
				triageInfo.LastFailure = DateTime.UtcNow;
				_triageRepository.UpdateTriageInfo(triageInfo);
			}
		}

		private bool ShouldTriage(FailureTracker tracker, ModelTriageInfo triageInfo)
		{
			if (triageInfo.IsTriaged)
				return false;

			var failuresInWindow = tracker.GetFailuresInWindow(DateTime.UtcNow, _settings.FailureWindow);

			// Triage if failure count hits the threshold OR if the failure rate exceeds the velocity threshold
			return failuresInWindow.Count() >= _settings.FailureThreshold || CalculateFailureVelocity(failuresInWindow) > _settings.FailureRateThreshold;
		}

		private double CalculateFailureVelocity(System.Collections.Generic.IEnumerable<DateTime> failures)
		{
			if (failures == null || !failures.Any())
				return 0.0;

			var orderedFailures = failures.OrderBy(f => f).ToList();
			var timeSpan = orderedFailures.Last() - orderedFailures.First();

			// Avoid division by zero if failures happened at the same time
			if (timeSpan.TotalSeconds < 1)
				return orderedFailures.Count();

			return orderedFailures.Count() / timeSpan.TotalSeconds;
		}
	}

	public class FailureTracker
	{
		private readonly ConcurrentQueue<DateTime> _failureTimestamps = new ConcurrentQueue<DateTime>();

		public void AddFailure(DateTime timestamp)
		{
			_failureTimestamps.Enqueue(timestamp);
			// Prune old entries to keep the queue from growing indefinitely
			while (_failureTimestamps.Count > 100 && _failureTimestamps.TryPeek(out var oldest) && oldest < DateTime.UtcNow.AddHours(-1))
			{
				_failureTimestamps.TryDequeue(out _);
			}
		}

		public System.Collections.Generic.IEnumerable<DateTime> GetFailuresInWindow(DateTime now, TimeSpan window)
		{
			return _failureTimestamps.Where(t => now - t <= window);
		}
	}

	public class BreakerSettings
	{
		public int FailureThreshold { get; set; } = 2; // Triage after 2 consecutive failures
		public TimeSpan FailureWindow { get; set; } = TimeSpan.FromMinutes(5); // within a 5-minute window
		public double FailureRateThreshold { get; set; } = 0.1; // failures per second
	}

	public class ModelTriageInfo
	{
		public string? ModelId { get; set; }
		public bool IsTriaged { get; set; }
		public int FailureCount { get; set; }
		public DateTime LastFailure { get; set; }
	}
}
