using System;
using System.Linq;
using System.Threading.Tasks;
using MongoDB.Driver;
using P4NTH30N.C0MMON;

namespace M16R4710N
{
	class Program
	{
		static async Task Main(string[] args)
		{
			var client = new MongoClient("mongodb://localhost:27017");
			var database = client.GetDatabase("P4NTH30N");
			var credentials = database.GetCollection<Credential>("CR3D3N7IAL");
			var jackpots = database.GetCollection<Jackpot>("J4CKP0T");

			var allCredentials = await credentials.Find(_ => true).ToListAsync();

			foreach (var credential in allCredentials)
			{
				var credentialJackpots = await jackpots.Find(j => j.House == credential.House && j.Game == credential.Game).ToListAsync();

				foreach (var jackpot in credentialJackpots)
				{
					jackpot.DPD = credential.DPD;
					await jackpots.ReplaceOneAsync(j => j._id == jackpot._id, jackpot);
					Console.WriteLine($"Migrated DPD for Jackpot {jackpot._id} for Credential {credential.Username}@{credential.House}/{credential.Game}");
				}
			}

			Console.WriteLine("Migration complete.");
		}
	}
}
