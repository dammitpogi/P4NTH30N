using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Interfaces;

namespace P4NTHE0N.C0MMON.Services
{
	public class TriageCleanupService
	{
		private readonly IModelTriageRepository _triageRepository;
		private readonly CleanupSettings _settings;
		private System.Threading.Timer? _timer;

		public TriageCleanupService(IModelTriageRepository triageRepository, CleanupSettings settings)
		{
			_triageRepository = triageRepository;
			_settings = settings;
		}

		public void Start()
		{
			_timer = new System.Threading.Timer(DoWork, null, TimeSpan.Zero, _settings.CleanupInterval);
		}

		public void Stop()
		{
			_timer?.Change(Timeout.Infinite, 0);
		}

		private void DoWork(object? state)
		{
			var allTriagedModels = _triageRepository.GetAllTriageInfo().Where(m => m.IsTriaged);

			foreach (var model in allTriagedModels)
			{
				var timeSinceLastFailure = DateTime.UtcNow - model.LastFailure;

				if (timeSinceLastFailure >= _settings.FullCleanupThreshold)
				{
					// After 48 hours, clear the triage entry completely
					model.IsTriaged = false;
					model.FailureCount = 0;
				}
				else if (timeSinceLastFailure >= _settings.PartialCleanupThreshold)
				{
					// After 24 hours, reduce failure count by 1
					if (model.FailureCount > 0)
					{
						model.FailureCount--;
					}
				}

				_triageRepository.UpdateTriageInfo(model);
			}
		}
	}

	public class CleanupSettings
	{
		public TimeSpan CleanupInterval { get; set; } = TimeSpan.FromHours(1);
		public TimeSpan PartialCleanupThreshold { get; set; } = TimeSpan.FromHours(24);
		public TimeSpan FullCleanupThreshold { get; set; } = TimeSpan.FromHours(48);
	}
}
