using MongoDB.Driver;
using P4NTH30N.C0MMON.Infrastructure.Persistence;
using P4NTH30N.C0MMON.Monitoring;

namespace P4NTH30N.MONITOR
{
	/// <summary>
	/// Standalone monitoring service for data corruption detection
	/// Can be run independently or integrated into main applications
	/// </summary>
	public class MonitoringService
	{
		private readonly DataCorruptionMonitor _monitor;
		private readonly ValidatedMongoRepository _validatedRepo;

		public MonitoringService(string connectionString = "mongodb://localhost:27017", string databaseName = "P4NTH30N")
		{
			var client = new MongoClient(connectionString);
			var database = client.GetDatabase(databaseName);

			_monitor = new DataCorruptionMonitor(database);
			_validatedRepo = new ValidatedMongoRepository(database);
		}

		public void Start()
		{
			Console.WriteLine("🚀 Starting P4NTH30N Monitoring Service...");
			Console.WriteLine("📊 Monitoring for data corruption and extreme values...");

			// Run initial health check
			_monitor.TriggerImmediateCheck();

			// Perform initial data cleaning if needed
			try
			{
				Console.WriteLine("🧹 Performing initial data validation and cleaning...");
				var cleaningResult = _validatedRepo.CleanCorruptedData();
				Console.WriteLine($"✅ Initial cleaning complete: {cleaningResult.Summary}");
			}
			catch (Exception ex)
			{
				Console.WriteLine($"⚠️ Initial cleaning failed: {ex.Message}");
			}

			// Start continuous monitoring
			_monitor.StartMonitoring();

			Console.WriteLine("✅ Monitoring service started successfully");
			Console.WriteLine("Press Ctrl+C to stop monitoring...");
		}

		public void Stop()
		{
			Console.WriteLine("🛑 Stopping monitoring service...");
			_monitor.StopMonitoring();
			Console.WriteLine("✅ Monitoring service stopped");
		}

		public void TriggerHealthCheck()
		{
			_monitor.TriggerImmediateCheck();
		}
	}

	// Program entry point for standalone monitoring
	public class Program
	{
		public static void Main(string[] args)
		{
			var monitoringService = new MonitoringService();

			// Set up graceful shutdown
			Console.CancelKeyPress += (sender, e) =>
			{
				e.Cancel = true;
				monitoringService.Stop();
				Environment.Exit(0);
			};

			try
			{
				monitoringService.Start();

				// Keep the service running
				while (true)
				{
					System.Threading.Thread.Sleep(60000); // Sleep for 1 minute

					// Optional: trigger periodic additional checks
					if (DateTime.Now.Minute % 10 == 0) // Every 10 minutes
					{
						monitoringService.TriggerHealthCheck();
					}
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"🔴 Monitoring service crashed: {ex.Message}");
				Environment.Exit(1);
			}
		}
	}
}
