using System;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.CLEANUP
{
	/// <summary>
	/// MongoDB cleanup utility for extreme values and corrupted data
	/// Identifies and fixes insane credential data, particularly BitVegas-related corruption
	/// </summary>
	public class MongoCleanupUtility
	{
		private readonly IMongoDatabase _database;
		private readonly ValidatedMongoRepository _validatedRepo;

		public MongoCleanupUtility(IMongoDatabase database)
		{
			_database = database;
			_validatedRepo = new ValidatedMongoRepository(database);
		}

		/// <summary>
		/// Comprehensive cleanup of all MongoDB collections with extreme values
		/// </summary>
		public MongoCleanupResult PerformFullCleanup()
		{
			var result = new MongoCleanupResult();

			try
			{
				Console.WriteLine("🧹 Starting MongoDB cleanup for extreme values...");

				// 1. Clean CRED3N7IAL collection
				result.CredentialResults = CleanCredentialCollection();

				// 2. Clean J4CKP0T collection
				result.JackpotResults = CleanJackpotCollection();

				// 3. Clean any remaining legacy collections
				result.LegacyResults = CleanLegacyCollections();

				// 4. Clean analytics collections (LEDGER_*)
				result.AnalyticsResults = CleanAnalyticsCollections();

				// 5. Validate all current data after cleanup
				result.ValidationResults = ValidateAllCollections();

				Console.WriteLine($"✅ Cleanup complete: {result.GetSummary()}");
				return result;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"🔴 Cleanup failed: {ex.Message}");
				result.Errors.Add($"Cleanup failed: {ex.Message}");
				return result;
			}
		}

		/// <summary>
		/// Clean extreme values from CRED3N7IAL collection
		/// </summary>
		private CollectionCleanupResult CleanCredentialCollection()
		{
			var result = new CollectionCleanupResult { CollectionName = "CRED3N7IAL" };
			var collection = _database.GetCollection<BsonDocument>("CRED3N7IAL");

			try
			{
				// Find all BitVegas credentials for special attention
				var bitvegasFilter = Builders<BsonDocument>.Filter.Regex("Game", new BsonRegularExpression("BitVegas", "i"));
				var bitvegasDocs = collection.Find(bitvegasFilter).ToList();

				Console.WriteLine($"🔍 Found {bitvegasDocs.Count} BitVegas credentials for inspection");

				// Find all credentials with extreme jackpot values
				var extremeFilter = Builders<BsonDocument>.Filter.Or(
					Builders<BsonDocument>.Filter.Gt("Jackpots.Grand", 10000),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Major", 1000),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Minor", 200),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Mini", 50),
					Builders<BsonDocument>.Filter.Gt("Balance", 50000)
				);

				var extremeDocs = collection.Find(extremeFilter).ToList();
				result.DocumentsFound = extremeDocs.Count;

				Console.WriteLine($"🚨 Found {extremeDocs.Count} credentials with extreme values");

				foreach (var doc in extremeDocs)
				{
					var username = doc.Contains("Username") ? doc["Username"].AsString : "Unknown";
					var game = doc.Contains("Game") ? doc["Game"].AsString : "Unknown";

					if (doc.Contains("Jackpots"))
					{
						var jackpots = doc["Jackpots"].AsBsonDocument;

						if (jackpots.Contains("Grand"))
						{
							var grandValue = jackpots["Grand"].ToDouble();
							bool isValid = !double.IsNaN(grandValue) && !double.IsInfinity(grandValue) && grandValue >= 0 && grandValue <= 10000;
							if (!isValid)
							{
								result.RepairDetails.Add($"Invalid Grand for {username} ({game}): {grandValue:F2}");
							}
						}

						if (jackpots.Contains("Major"))
						{
							var majorValue = jackpots["Major"].ToDouble();
							bool isValid = !double.IsNaN(majorValue) && !double.IsInfinity(majorValue) && majorValue >= 0 && majorValue <= 10000;
							if (!isValid)
							{
								result.RepairDetails.Add($"Invalid Major for {username} ({game}): {majorValue:F2}");
							}
						}

						if (jackpots.Contains("Minor"))
						{
							var minorValue = jackpots["Minor"].ToDouble();
							bool isValid = !double.IsNaN(minorValue) && !double.IsInfinity(minorValue) && minorValue >= 0 && minorValue <= 10000;
							if (!isValid)
							{
								result.RepairDetails.Add($"Invalid Minor for {username} ({game}): {minorValue:F2}");
							}
						}

						if (jackpots.Contains("Mini"))
						{
							var miniValue = jackpots["Mini"].ToDouble();
							bool isValid = !double.IsNaN(miniValue) && !double.IsInfinity(miniValue) && miniValue >= 0 && miniValue <= 10000;
							if (!isValid)
							{
								result.RepairDetails.Add($"Invalid Mini for {username} ({game}): {miniValue:F2}");
							}
						}
					}

					if (doc.Contains("Balance"))
					{
						var balance = doc["Balance"].ToDouble();
						bool isValid = !double.IsNaN(balance) && !double.IsInfinity(balance) && balance >= 0 && balance <= 50000;
						if (!isValid)
						{
							result.RepairDetails.Add($"Invalid Balance for {username} ({game}): {balance:F2}");
						}
					}
				}

				// Clean corrupted DPD data arrays
				var dpdFilter = Builders<BsonDocument>.Filter.Ne("DPD.Data", BsonNull.Value);
				var dpdDocs = collection.Find(dpdFilter).ToList();

				foreach (var doc in dpdDocs)
				{
					if (doc.Contains("DPD") && doc["DPD"].AsBsonDocument.Contains("Data"))
					{
						var dpdData = doc["DPD"]["Data"].AsBsonArray;
						var cleanedData = new BsonArray();
						var removedCount = 0;

						foreach (var entry in dpdData)
						{
							if (entry.IsBsonDocument)
							{
								var entryDoc = entry.AsBsonDocument;
								if (entryDoc.Contains("Grand"))
								{
									var grandValue = entryDoc["Grand"].ToDouble();
									if (grandValue <= 10000) // Within reasonable limits
									{
										cleanedData.Add(entry);
									}
									else
									{
										removedCount++;
									}
								}
							}
						}

						if (removedCount > 0)
						{
							var filter = Builders<BsonDocument>.Filter.Eq("_id", doc["_id"]);
							var update = Builders<BsonDocument>.Update.Set("DPD.Data", cleanedData);
							collection.UpdateOne(filter, update);

							result.RepairDetails.Add($"Removed {removedCount} corrupted DPD entries");
							Console.WriteLine($"🧹 Removed {removedCount} corrupted DPD entries");
						}
					}
				}

				Console.WriteLine($"✅ CRED3N7IAL cleanup: {result.DocumentsFound} found, {result.DocumentsRepaired} repaired");
				return result;
			}
			catch (Exception ex)
			{
				result.Errors.Add($"CRED3N7IAL cleanup failed: {ex.Message}");
				Console.WriteLine($"🔴 CRED3N7IAL cleanup failed: {ex.Message}");
				return result;
			}
		}

		/// <summary>
		/// Clean extreme values from J4CKP0T collection
		/// </summary>
		private CollectionCleanupResult CleanJackpotCollection()
		{
			var result = new CollectionCleanupResult { CollectionName = "J4CKP0T" };
			var collection = _database.GetCollection<BsonDocument>("J4CKP0T");

			try
			{
				// Find jackpots with extreme current values
				var extremeFilter = Builders<BsonDocument>.Filter.Gt("Current", 10000);
				var extremeDocs = collection.Find(extremeFilter).ToList();
				result.DocumentsFound = extremeDocs.Count;

				foreach (var doc in extremeDocs)
				{
					var currentValue = doc["Current"].ToDouble();
					var category = doc.Contains("Category") ? doc["Category"].AsString : "Unknown";

					// Get appropriate limit based on category
					double maxValue = category switch
					{
						"Grand" => 10000,
						"Major" => 1000,
						"Minor" => 200,
						"Mini" => 50,
						_ => 10000,
					};

					if (currentValue > maxValue)
					{
						// Clamp to maximum allowed value
						var filter = Builders<BsonDocument>.Filter.Eq("_id", doc["_id"]);
						var update = Builders<BsonDocument>.Update.Set("Current", maxValue);
						collection.UpdateOne(filter, update);

						result.DocumentsRepaired++;
						result.RepairDetails.Add($"{category} jackpot: {currentValue:F2} -> {maxValue:F2}");

						Console.WriteLine($"🔧 Repaired {category} jackpot: {currentValue:F2} -> {maxValue:F2}");
					}
				}

				Console.WriteLine($"✅ J4CKP0T cleanup: {result.DocumentsFound} found, {result.DocumentsRepaired} repaired");
				return result;
			}
			catch (Exception ex)
			{
				result.Errors.Add($"J4CKP0T cleanup failed: {ex.Message}");
				Console.WriteLine($"🔴 J4CKP0T cleanup failed: {ex.Message}");
				return result;
			}
		}

		/// <summary>
		/// Clean any remaining legacy collections that might have extreme values
		/// </summary>
		private CollectionCleanupResult CleanLegacyCollections()
		{
			var result = new CollectionCleanupResult { CollectionName = "Legacy" };

			try
			{
				var collections = _database.ListCollections().ToList();
				var legacyCollections = collections.Where(c => c["name"].AsString.Contains("LEGACY")).ToList();

				foreach (var collectionInfo in legacyCollections)
				{
					var collectionName = collectionInfo["name"].AsString;
					var collection = _database.GetCollection<BsonDocument>(collectionName);

					try
					{
						// Sample a few documents to check for extreme values
						var sample = collection.Find(Builders<BsonDocument>.Filter.Empty).Limit(10).ToList();
						var extremeCount = 0;

						foreach (var doc in sample)
						{
							if (HasExtremeValues(doc))
							{
								extremeCount++;
							}
						}

						if (extremeCount > 0)
						{
							result.RepairDetails.Add($"Found {extremeCount} potentially extreme documents in {collectionName}");
							Console.WriteLine($"⚠️ Found {extremeCount} potentially extreme documents in legacy collection {collectionName}");
						}
					}
					catch (Exception ex)
					{
						result.Errors.Add($"Error checking {collectionName}: {ex.Message}");
					}
				}

				Console.WriteLine($"✅ Legacy collections check completed");
				return result;
			}
			catch (Exception ex)
			{
				result.Errors.Add($"Legacy cleanup failed: {ex.Message}");
				Console.WriteLine($"🔴 Legacy cleanup failed: {ex.Message}");
				return result;
			}
		}

		/// <summary>
		/// Clean analytics collections (LEDGER_*) from extreme values
		/// </summary>
		private CollectionCleanupResult CleanAnalyticsCollections()
		{
			var result = new CollectionCleanupResult { CollectionName = "Analytics" };

			try
			{
				var collections = _database.ListCollections().ToList();
				var analyticsCollections = collections.Where(c => c["name"].AsString.StartsWith("LEDGER_")).ToList();

				foreach (var collectionInfo in analyticsCollections)
				{
					var collectionName = collectionInfo["name"].AsString;
					var collection = _database.GetCollection<BsonDocument>(collectionName);

					try
					{
						// Look for extreme values in analytics
						var extremeFilter = Builders<BsonDocument>.Filter.Or(
							Builders<BsonDocument>.Filter.Gt("jackpotGrand", 10000),
							Builders<BsonDocument>.Filter.Gt("jackpotMajor", 1000),
							Builders<BsonDocument>.Filter.Gt("jackpotMinor", 200),
							Builders<BsonDocument>.Filter.Gt("jackpotMini", 50)
						);

						var extremeDocs = collection.Find(extremeFilter).ToList();

						if (extremeDocs.Any())
						{
							result.DocumentsFound += extremeDocs.Count;
							result.RepairDetails.Add($"Found {extremeDocs.Count} extreme entries in {collectionName}");
							Console.WriteLine($"⚠️ Found {extremeDocs.Count} extreme entries in analytics collection {collectionName}");
						}
					}
					catch (Exception ex)
					{
						result.Errors.Add($"Error checking {collectionName}: {ex.Message}");
					}
				}

				Console.WriteLine($"✅ Analytics collections check completed");
				return result;
			}
			catch (Exception ex)
			{
				result.Errors.Add($"Analytics cleanup failed: {ex.Message}");
				Console.WriteLine($"🔴 Analytics cleanup failed: {ex.Message}");
				return result;
			}
		}

		/// <summary>
		/// Validate all collections after cleanup to ensure no extreme values remain
		/// </summary>
		private CollectionCleanupResult ValidateAllCollections()
		{
			var result = new CollectionCleanupResult { CollectionName = "Validation" };

			try
			{
				// Validate CRED3N7IAL
				var credCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");
				var extremeFilter = Builders<BsonDocument>.Filter.Or(
					Builders<BsonDocument>.Filter.Gt("Jackpots.Grand", 10000),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Major", 1000),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Minor", 200),
					Builders<BsonDocument>.Filter.Gt("Jackpots.Mini", 50)
				);

				var remainingExtreme = credCollection.CountDocuments(extremeFilter);
				if (remainingExtreme > 0)
				{
					result.Errors.Add($"Still found {remainingExtreme} credentials with extreme values after cleanup");
				}

				// Validate J4CKP0T
				var jackpotCollection = _database.GetCollection<BsonDocument>("J4CKP0T");
				var extremeJackpotFilter = Builders<BsonDocument>.Filter.Gt("Current", 10000);
				var remainingExtremeJackpots = jackpotCollection.CountDocuments(extremeJackpotFilter);

				if (remainingExtremeJackpots > 0)
				{
					result.Errors.Add($"Still found {remainingExtremeJackpots} jackpots with extreme values after cleanup");
				}

				if (result.Errors.Count == 0)
				{
					result.RepairDetails.Add("All collections validated - no extreme values found");
					Console.WriteLine("✅ All collections validated - no extreme values found");
				}

				return result;
			}
			catch (Exception ex)
			{
				result.Errors.Add($"Validation failed: {ex.Message}");
				Console.WriteLine($"🔴 Validation failed: {ex.Message}");
				return result;
			}
		}

		private bool HasExtremeValues(BsonDocument doc)
		{
			// Check for common extreme value patterns
			var fieldsToCheck = new[] { "Grand", "Major", "Minor", "Mini", "Balance", "jackpotGrand", "jackpotMajor", "jackpotMinor", "jackpotMini" };

			foreach (var field in fieldsToCheck)
			{
				if (doc.Contains(field))
				{
					var value = doc[field].ToDouble();
					if (value > 10000) // General threshold for extreme values
					{
						return true;
					}
				}
			}

			return false;
		}

		/// <summary>
		/// Quick scan for any remaining BitVegas-related corrupted data
		/// </summary>
		public BitVegasScanResult ScanBitVegasCorruption()
		{
			var result = new BitVegasScanResult();

			try
			{
				var credentialCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");
				var bitvegasFilter = Builders<BsonDocument>.Filter.Regex("Game", new BsonRegularExpression("BitVegas", "i"));
				var bitvegasDocs = credentialCollection.Find(bitvegasFilter).ToList();

				result.TotalBitVegasCredentials = bitvegasDocs.Count;

				foreach (var doc in bitvegasDocs)
				{
					var username = doc.Contains("Username") ? doc["Username"].AsString : "Unknown";

					// Check for extreme values in this BitVegas credential
					if (doc.Contains("Jackpots"))
					{
						var jackpots = doc["Jackpots"].AsBsonDocument;

						if (jackpots.Contains("Grand") && jackpots["Grand"].ToDouble() > 10000)
							result.CorruptedEntries++;

						if (jackpots.Contains("Major") && jackpots["Major"].ToDouble() > 1000)
							result.CorruptedEntries++;

						if (jackpots.Contains("Minor") && jackpots["Minor"].ToDouble() > 200)
							result.CorruptedEntries++;

						if (jackpots.Contains("Mini") && jackpots["Mini"].ToDouble() > 50)
							result.CorruptedEntries++;
					}

					if (doc.Contains("Balance") && doc["Balance"].ToDouble() > 50000)
					{
						result.CorruptedEntries++;
					}

					result.BitVegasCredentials.Add(username);
				}

				Console.WriteLine($"🔍 BitVegas scan: {result.TotalBitVegasCredentials} credentials, {result.CorruptedEntries} corrupted entries found");
				return result;
			}
			catch (Exception ex)
			{
				result.Errors.Add($"BitVegas scan failed: {ex.Message}");
				Console.WriteLine($"🔴 BitVegas scan failed: {ex.Message}");
				return result;
			}
		}
	}

	// Result classes for tracking cleanup operations
	public class MongoCleanupResult
	{
		public CollectionCleanupResult CredentialResults { get; set; } = new();
		public CollectionCleanupResult JackpotResults { get; set; } = new();
		public CollectionCleanupResult LegacyResults { get; set; } = new();
		public CollectionCleanupResult AnalyticsResults { get; set; } = new();
		public CollectionCleanupResult ValidationResults { get; set; } = new();
		public List<string> Errors { get; set; } = new();

		public string GetSummary()
		{
			var totalFound = CredentialResults.DocumentsFound + JackpotResults.DocumentsFound + LegacyResults.DocumentsFound + AnalyticsResults.DocumentsFound;
			var totalRepaired = CredentialResults.DocumentsRepaired + JackpotResults.DocumentsRepaired;
			var totalErrors =
				Errors.Count
				+ CredentialResults.Errors.Count
				+ JackpotResults.Errors.Count
				+ LegacyResults.Errors.Count
				+ AnalyticsResults.Errors.Count
				+ ValidationResults.Errors.Count;

			return $"Found: {totalFound}, Repaired: {totalRepaired}, Errors: {totalErrors}";
		}
	}

	public class CollectionCleanupResult
	{
		public string CollectionName { get; set; } = "";
		public int DocumentsFound { get; set; }
		public int DocumentsRepaired { get; set; }
		public List<string> RepairDetails { get; set; } = new();
		public List<string> Errors { get; set; } = new();
	}

	public class BitVegasScanResult
	{
		public int TotalBitVegasCredentials { get; set; }
		public int CorruptedEntries { get; set; }
		public List<string> BitVegasCredentials { get; set; } = new();
		public List<string> Errors { get; set; } = new();
	}
}
