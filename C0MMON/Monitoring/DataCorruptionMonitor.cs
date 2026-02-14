using System;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using MongoDB.Driver;
using Timer = System.Timers.Timer;

namespace P4NTH30N.C0MMON.Monitoring
{
	/// <summary>
	/// Real-time monitoring service for detecting extreme values and data corruption
	/// Provides automated alerts and logging for system health
	/// </summary>
	public class DataCorruptionMonitor
	{
		private readonly IMongoDatabase _database;
		private readonly Timer _monitoringTimer;
		private readonly List<string> _recentAlerts = new();
		private DateTime _lastAlertTime = DateTime.MinValue;
		private readonly TimeSpan _alertCooldown = TimeSpan.FromMinutes(5);

		public DataCorruptionMonitor(IMongoDatabase database)
		{
			_database = database;
			_monitoringTimer = new Timer(TimeSpan.FromMinutes(2).TotalMilliseconds); // Check every 2 minutes
			_monitoringTimer.Elapsed += PerformHealthCheck;
			_monitoringTimer.AutoReset = true;
		}

		public void StartMonitoring()
		{
			Console.WriteLine("🔍 Starting data corruption monitoring...");
			_monitoringTimer.Start();
		}

		public void StopMonitoring()
		{
			Console.WriteLine("⏹️ Stopping data corruption monitoring...");
			_monitoringTimer.Stop();
		}

		private void PerformHealthCheck(object? sender, System.Timers.ElapsedEventArgs? e)
		{
			try
			{
				var issues = new List<string>();

				// Check for extreme values in current credentials
				issues.AddRange(CheckCredentialExtremes());

				// Check for corrupted DPD data
				issues.AddRange(CheckDPDDataCorruption());

				// Check jackpot collection
				issues.AddRange(CheckJackpotExtremes());

				// Report findings
				if (issues.Any())
				{
					var alertMessage = $"Data corruption detected: {string.Join("; ", issues)}";
					LogAlert(alertMessage);
				}
				else
				{
					Console.WriteLine($"✅ Health check passed - {DateTime.Now:HH:mm:ss}");
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"🔴 Health check error: {ex.Message}");
			}
		}

		private List<string> CheckCredentialExtremes()
		{
			var issues = new List<string>();
			var credentialCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");

			// Find extreme jackpot values
			var extremeFilter = Builders<BsonDocument>.Filter.Or(
				Builders<BsonDocument>.Filter.Gt("Jackpots.Grand", 10000),
				Builders<BsonDocument>.Filter.Gt("Jackpots.Major", 1000),
				Builders<BsonDocument>.Filter.Gt("Jackpots.Minor", 200),
				Builders<BsonDocument>.Filter.Gt("Jackpots.Mini", 50),
				Builders<BsonDocument>.Filter.Gt("Balance", 50000)
			);

			var extremeDocs = credentialCollection.Find(extremeFilter).Limit(5).ToList();

			foreach (var doc in extremeDocs)
			{
				var username = doc.Contains("Username") ? doc["Username"].AsString : "Unknown";
				var game = doc.Contains("Game") ? doc["Game"].AsString : "Unknown";
				issues.Add($"Extreme values in {username} ({game})");
			}

			return issues;
		}

		private List<string> CheckDPDDataCorruption()
		{
			var issues = new List<string>();
			var credentialCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");

			// Find credentials with corrupted DPD data
			var corruptedDPDFilter = Builders<BsonDocument>.Filter.And(
				Builders<BsonDocument>.Filter.Ne("DPD.Data", BsonNull.Value),
				Builders<BsonDocument>.Filter.ElemMatch(
					"DPD.Data",
					Builders<BsonDocument>.Filter.Or(Builders<BsonDocument>.Filter.Gt("Grand", 10000), Builders<BsonDocument>.Filter.Lt("Grand", 0))
				)
			);

			var corruptedDPDs = credentialCollection.Find(corruptedDPDFilter).Limit(3).ToList();

			foreach (var doc in corruptedDPDs)
			{
				var username = doc.Contains("Username") ? doc["Username"].AsString : "Unknown";
				issues.Add($"Corrupted DPD data for {username}");
			}

			return issues;
		}

		private List<string> CheckJackpotExtremes()
		{
			var issues = new List<string>();
			var jackpotCollection = _database.GetCollection<BsonDocument>("J4CKP0T");

			// Check for extreme jackpot entries
			var extremeJackpotFilter = Builders<BsonDocument>.Filter.Or(
				Builders<BsonDocument>.Filter.Gt("Current", 10000),
				Builders<BsonDocument>.Filter.Gt("Threshold", 2000),
				Builders<BsonDocument>.Filter.Lt("DPM", 0)
			);

			var extremeJackpots = jackpotCollection.Find(extremeJackpotFilter).Limit(3).ToList();

			foreach (var doc in extremeJackpots)
			{
				var house = doc.Contains("House") ? doc["House"].AsString : "Unknown";
				var game = doc.Contains("Game") ? doc["Game"].AsString : "Unknown";
				issues.Add($"Extreme jackpot in {house} ({game})");
			}

			return issues;
		}

		private void LogAlert(string message)
		{
			var now = DateTime.Now;

			// Respect alert cooldown to prevent spam
			if (now - _lastAlertTime < _alertCooldown)
			{
				if (!_recentAlerts.Contains(message))
				{
					_recentAlerts.Add(message);
				}
				return;
			}

			_lastAlertTime = now;
			_recentAlerts.Clear();
			_recentAlerts.Add(message);

			Console.WriteLine($"🚨 [{now:HH:mm:ss}] DATA CORRUPTION ALERT: {message}");

			// Create process event for tracking
			try
			{
				var alertEvent = new ProcessEvent
				{
					Component = "DataCorruptionMonitor",
					Message = message,
					Timestamp = now,
					Severity = "HIGH",
				};

				var eventsCollection = _database.GetCollection<BsonDocument>("EV3NT");
				eventsCollection.InsertOne(alertEvent.ToBsonDocument());
			}
			catch (Exception ex)
			{
				Console.WriteLine($"Failed to log alert event: {ex.Message}");
			}
		}

		/// <summary>
		/// Manual trigger for immediate health check
		/// </summary>
		public void TriggerImmediateCheck()
		{
			Console.WriteLine("🔍 Triggering immediate data corruption check...");
			PerformHealthCheck(null!, null!);
		}
	}

	// Extension method for ProcessEvent to support BsonDocument conversion
	public static class ProcessEventExtensions
	{
		public static BsonDocument ToBsonDocument(this ProcessEvent processEvent)
		{
			return new BsonDocument
			{
				{ "_id", ObjectId.GenerateNewId() },
				{ "Component", processEvent.Component },
				{ "Message", processEvent.Message },
				{ "Timestamp", processEvent.Timestamp },
				{ "Severity", processEvent.Severity },
			};
		}
	}

	// Simplified ProcessEvent for monitoring
	public class ProcessEvent
	{
		public string Component { get; set; } = "";
		public string Message { get; set; } = "";
		public DateTime Timestamp { get; set; }
		public string Severity { get; set; } = "MEDIUM";
	}
}
