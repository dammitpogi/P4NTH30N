using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.T00L5ET;

public static class CredCheck
{
	public static async Task RunAsync()
	{
		var client = new MongoClient("mongodb://192.168.56.1:27017");
		var db = client.GetDatabase("P4NTH30N");
		var coll = db.GetCollection<BsonDocument>("CRED3N7IAL");

		// Get distinct House values
		var houses = await coll.DistinctAsync<string>("House", FilterDefinition<BsonDocument>.Empty);
		Console.WriteLine("Distinct House values:");
		await houses.ForEachAsync(h => Console.WriteLine($"  '{h}'"));

		// Get first doc to see field structure
		var first = await coll.Find(FilterDefinition<BsonDocument>.Empty).Limit(1).FirstOrDefaultAsync();
		if (first != null)
		{
			Console.WriteLine("\nFirst document fields:");
			foreach (var el in first.Elements)
			{
				string val = el.Value?.ToString() ?? "null";
				if (val.Length > 80) val = val[..80] + "...";
				Console.WriteLine($"  {el.Name}: {val}");
			}
		}

		// Count by House
		var pipeline = new BsonDocument[]
		{
			new("$group", new BsonDocument { { "_id", "$House" }, { "count", new BsonDocument("$sum", 1) } }),
			new("$sort", new BsonDocument("count", -1))
		};
		var results = await coll.AggregateAsync<BsonDocument>(pipeline);
		Console.WriteLine("\nCredentials per House:");
		await results.ForEachAsync(r => Console.WriteLine($"  {r["_id"]}: {r["count"]}"));

		// Check enabled/banned for FireKirin-like
		var fkFilter = Builders<BsonDocument>.Filter.Regex("House", new BsonRegularExpression("fire|kirin", "i"));
		long fkCount = await coll.CountDocumentsAsync(fkFilter);
		Console.WriteLine($"\nFireKirin-like credentials: {fkCount}");

		if (fkCount > 0)
		{
			var fkDoc = await coll.Find(fkFilter).Sort(Builders<BsonDocument>.Sort.Descending("Balance")).Limit(1).FirstOrDefaultAsync();
			if (fkDoc != null)
			{
				Console.WriteLine($"  Top FK cred: Username={fkDoc.GetValue("Username", "")} Balance={fkDoc.GetValue("Balance", 0)} Enabled={fkDoc.GetValue("Enabled", "?")} Banned={fkDoc.GetValue("Banned", "?")}");
			}
		}
	}
}
