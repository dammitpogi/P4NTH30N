using System;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTHE0N.CLEANUP;

public class DpdMigrationRunner
{
	private readonly string _connectionString;
	private readonly string _databaseName;

	public DpdMigrationRunner(string connectionString = "mongodb://localhost:27017", string databaseName = "P4NTHE0N")
	{
		_connectionString = connectionString;
		_databaseName = databaseName;
	}

	public async Task RunMigrationAsync()
	{
		try
		{
			Console.WriteLine("🚀 Starting DPD Migration: Credential → Jackpot");
			Console.WriteLine($"📍 Connecting to: {_connectionString}/{_databaseName}");
			Console.WriteLine($"🕒 Started at: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
			Console.WriteLine();

			var client = new MongoClient(_connectionString);
			var database = client.GetDatabase(_databaseName);

			await database.RunCommandAsync(new JsonCommand<BsonDocument>("{ ping: 1 }"));
			Console.WriteLine("✅ MongoDB connection established");

			var credentialsCollection = database.GetCollection<BsonDocument>("CR3D3N7IAL");
			var jackpotsCollection = database.GetCollection<BsonDocument>("J4CKP0T");

			var credentialsWithDpd = await credentialsCollection.Find(new BsonDocument("DPD", new BsonDocument("$exists", true))).ToListAsync();

			Console.WriteLine($"📋 Found {credentialsWithDpd.Count} credentials with DPD data");

			int migrated = 0;
			int skipped = 0;

			foreach (var cred in credentialsWithDpd)
			{
				var credId = cred["_id"].AsObjectId;
				var house = cred["House"].AsString;
				var game = cred["Game"].AsString;
				var username = cred["Username"].AsString;

				var dpd = cred["Dpd"].AsBsonDocument;

				var filter = Builders<BsonDocument>.Filter.And(Builders<BsonDocument>.Filter.Eq("House", house), Builders<BsonDocument>.Filter.Eq("Game", game));

				var existingJackpot = await jackpotsCollection.Find(filter).FirstOrDefaultAsync();

				if (existingJackpot != null)
				{
					var update = Builders<BsonDocument>.Update.Set("DPD", dpd);
					await jackpotsCollection.UpdateOneAsync(filter, update);
					Console.WriteLine($"   ✅ Migrated DPD for {house}/{game}");
					migrated++;
				}
				else
				{
					Console.WriteLine($"   ⚠️ No jackpot found for {house}/{game} - DPD NOT migrated");
					skipped++;
				}

				var credUpdate = Builders<BsonDocument>.Update.Unset("DPD");
				await credentialsCollection.UpdateOneAsync(Builders<BsonDocument>.Filter.Eq("_id", credId), credUpdate);
			}

			Console.WriteLine();
			Console.WriteLine("✅ Migration complete!");
			Console.WriteLine($"   - Migrated: {migrated}");
			Console.WriteLine($"   - Skipped (no jackpot): {skipped}");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"❌ Migration failed: {ex.Message}");
			throw;
		}
	}
}
