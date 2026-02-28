using System;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.CLEANUP
{
	/// <summary>
	/// Quick validation and cleanup script for immediate deployment
	/// </summary>
	public class QuickValidationRunner
	{
		private readonly IMongoDatabase _database;

		public QuickValidationRunner(IMongoDatabase database)
		{
			_database = database;
		}

		/// <summary>
		/// Quick scan for any remaining extreme values and fix them immediately
		/// </summary>
		public async Task<QuickValidationResult> RunQuickValidationAsync()
		{
			var result = new QuickValidationResult();

			try
			{
				Console.WriteLine("🚀 Running quick validation scan...");

				// Check CRED3N7IAL collection
				var credentialCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");
				var extremeFilter = Builders<BsonDocument>.Filter.Or(
					Builders<BsonDocument>.Filter.Gt("Jackpots.Grand", 10000),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Major", 1000),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Minor", 200),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Mini", 50)
				);

				var extremeDocs = await credentialCollection.Find(extremeFilter).ToListAsync();
				result.ExtremeCredentialsFound = extremeDocs.Count;

				if (extremeDocs.Count > 0)
				{
					Console.WriteLine($"⚠️ Found {extremeDocs.Count} credentials with extreme values - fixing...");

					foreach (var doc in extremeDocs)
					{
						await FixCredentialDocument(doc, credentialCollection, result);
					}
				}

				// Check J4CKP0T collection
				var jackpotCollection = _database.GetCollection<BsonDocument>("J4CKP0T");
				var extremeJackpotFilter = Builders<BsonDocument>.Filter.Gt("Current", 10000);
				var extremeJackpots = await jackpotCollection.Find(extremeJackpotFilter).ToListAsync();
				result.ExtremeJackpotsFound = extremeJackpots.Count;

				if (extremeJackpots.Count > 0)
				{
					Console.WriteLine($"⚠️ Found {extremeJackpots.Count} jackpots with extreme values - fixing...");

					foreach (var jackpot in extremeJackpots)
					{
						await FixJackpotDocument(jackpot, jackpotCollection, result);
					}
				}

				// Final validation
				var finalCheck = await credentialCollection.CountDocumentsAsync(extremeFilter);
				var finalJackpotCheck = await jackpotCollection.CountDocumentsAsync(extremeJackpotFilter);

				result.AllClean = finalCheck == 0 && finalJackpotCheck == 0;

				if (result.AllClean)
				{
					Console.WriteLine("✅ All extreme values have been cleaned!");
				}
				else
				{
					Console.WriteLine($"⚠️ Still have {finalCheck} extreme credentials and {finalJackpotCheck} extreme jackpots");
				}

				return result;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"🔴 Quick validation failed: {ex.Message}");
				result.Errors.Add($"Quick validation failed: {ex.Message}");
				return result;
			}
		}

		private async Task FixCredentialDocument(BsonDocument doc, IMongoCollection<BsonDocument> collection, QuickValidationResult result)
		{
			var updates = new List<UpdateDefinition<BsonDocument>>();
			var username = doc.Contains("Username") ? doc["Username"].AsString : "Unknown";
			var game = doc.Contains("Game") ? doc["Game"].AsString : "Unknown";

			if (doc.Contains("Jackpots"))
			{
				var jackpots = doc["Jackpots"].AsBsonDocument;

				// Fix Grand
				if (jackpots.Contains("Grand"))
				{
					var value = jackpots["Grand"].ToDouble();
					if (value > 10000)
					{
						updates.Add(Builders<BsonDocument>.Update.Set("Jackpots.Grand", 10000.0));
						result.Repairs.Add($"{username} Grand: {value:F2} -> 10000.00");
					}
				}

				// Fix Major
				if (jackpots.Contains("Major"))
				{
					var value = jackpots["Major"].ToDouble();
					if (value > 1000)
					{
						updates.Add(Builders<BsonDocument>.Update.Set("Jackpots.Major", 1000.0));
						result.Repairs.Add($"{username} Major: {value:F2} -> 1000.00");
					}
				}

				// Fix Minor
				if (jackpots.Contains("Minor"))
				{
					var value = jackpots["Minor"].ToDouble();
					if (value > 200)
					{
						updates.Add(Builders<BsonDocument>.Update.Set("Jackpots.Minor", 200.0));
						result.Repairs.Add($"{username} Minor: {value:F2} -> 200.00");
					}
				}

				// Fix Mini
				if (jackpots.Contains("Mini"))
				{
					var value = jackpots["Mini"].ToDouble();
					if (value > 50)
					{
						updates.Add(Builders<BsonDocument>.Update.Set("Jackpots.Mini", 50.0));
						result.Repairs.Add($"{username} Mini: {value:F2} -> 50.00");
					}
				}
			}

			if (updates.Any())
			{
				var filter = Builders<BsonDocument>.Filter.Eq("_id", doc["_id"]);
				var update = Builders<BsonDocument>.Update.Combine(updates);
				await collection.UpdateOneAsync(filter, update);
				result.DocumentsRepaired++;
			}
		}

		private async Task FixJackpotDocument(BsonDocument doc, IMongoCollection<BsonDocument> collection, QuickValidationResult result)
		{
			var currentValue = doc["Current"].ToDouble();
			var category = doc.Contains("Category") ? doc["Category"].AsString : "Unknown";

			// Get appropriate maximum based on category
			double maxValue = category switch
			{
				"Grand" => 10000,
				"Major" => 1000,
				"Minor" => 200,
				"Mini" => 50,
				_ => 10000,
			};

			var filter = Builders<BsonDocument>.Filter.Eq("_id", doc["_id"]);
			var update = Builders<BsonDocument>.Update.Set("Current", maxValue);
			await collection.UpdateOneAsync(filter, update);

			result.DocumentsRepaired++;
			result.Repairs.Add($"{category} jackpot: {currentValue:F2} -> {maxValue:F2}");
		}
	}

	public class QuickValidationResult
	{
		public int ExtremeCredentialsFound { get; set; }
		public int ExtremeJackpotsFound { get; set; }
		public int DocumentsRepaired { get; set; }
		public bool AllClean { get; set; }
		public List<string> Repairs { get; set; } = new();
		public List<string> Errors { get; set; } = new();
	}
}
