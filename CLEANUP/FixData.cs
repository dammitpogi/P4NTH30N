using System;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace CLEANUP;

public class FixData
{
	public static void Main(string[] args)
	{
		Console.WriteLine("Starting data cleanup...");
		
		try
		{
			// Connect to MongoDB
			var unitOfWork = new MongoUnitOfWork();
			var credentialsRepo = unitOfWork.Credentials;
			
			// Get all credentials
			var credentials = credentialsRepo.GetAll();
			Console.WriteLine($"Found {credentials.Count} credentials to process");
			
			int updatedCount = 0;
			int dpdCleanedCount = 0;
			int jackpotResetCount = 0;

			foreach (var credential in credentials)
			{
				bool wasModified = false;
				
				// Reset credential Jackpots to 0 to prevent threshold miscalculation
				// When games run, they use credential.Jackpots.Grand as "grandPrior" to calculate new thresholds
				// If these values are stale/wrong, thresholds get set incorrectly
				if (credential.Jackpots.Grand > 0) {
					credential.Jackpots.Grand = 0;
					wasModified = true;
				}
				if (credential.Jackpots.Major > 0) {
					credential.Jackpots.Major = 0;
					wasModified = true;
				}
				if (credential.Jackpots.Minor > 0) {
					credential.Jackpots.Minor = 0;
					wasModified = true;
				}
				if (credential.Jackpots.Mini > 0) {
					credential.Jackpots.Mini = 0;
					wasModified = true;
				}
				
				if (wasModified) {
					jackpotResetCount++;
					Console.WriteLine($"Reset jackpots for {credential.Username} ({credential.House}/{credential.Game})");
				}
				
				// Reset ALL Thresholds to defaults
				if (credential.Thresholds.Mini != 23 ||
				    credential.Thresholds.Minor != 117 ||
				    credential.Thresholds.Major != 565 ||
				    credential.Thresholds.Grand != 1785)
				{
					credential.Thresholds.Mini = 23;
					credential.Thresholds.Minor = 117;
					credential.Thresholds.Major = 565;
					credential.Thresholds.Grand = 1785;
					wasModified = true;
					Console.WriteLine($"Reset thresholds for {credential.Username} ({credential.House}/{credential.Game}): {credential.Thresholds.Grand}/{credential.Thresholds.Major}/{credential.Thresholds.Minor}/{credential.Thresholds.Mini}");
				}
				
				// Clean DPD.Data - remove insane values (> 15000)
				if (credential.DPD?.Data != null && credential.DPD.Data.Count > 0)
				{
					var initialCount = credential.DPD.Data.Count;
					var cleanedData = credential.DPD.Data.Where(d => d.Grand <= 15000).ToList();
					var removedCount = initialCount - cleanedData.Count;
					
					if (removedCount > 0)
					{
						credential.DPD.Data = cleanedData;
						wasModified = true;
						dpdCleanedCount += removedCount;
						Console.WriteLine($"Removed {removedCount} insane DPD values (> 15000) from {credential.Username}");
					}
				}
				
				// Save changes if modified
				if (wasModified)
				{
					credentialsRepo.Upsert(credential);
					updatedCount++;
				}
			}
			
			Console.WriteLine($"\nCleanup complete!");
			Console.WriteLine($"- Reset jackpots for {jackpotResetCount} credentials");
			Console.WriteLine($"- Updated {updatedCount} credentials");
			Console.WriteLine($"- Removed {dpdCleanedCount} insane DPD values");

			// Clean Jackpots collection (separate collection)
			var jackpotsRepo = unitOfWork.Jackpots;
			var jackpots = jackpotsRepo.GetAll();
			Console.WriteLine($"Found {jackpots.Count} jackpots to process");
			
			int updatedJackpots = 0;
			
			foreach (var jackpot in jackpots)
			{
				bool modified = false;
				double max = 15000;
				if (jackpot.Category == "Mini") max = 200;
				else if (jackpot.Category == "Minor") max = 1000;
				else if (jackpot.Category == "Major") max = 3000;
				
				if (jackpot.Current > max)
				{
					jackpot.Current = 0; // Reset current if insane
					modified = true;
					Console.WriteLine($"Reset insane Current for {jackpot.Category} ({jackpot.House}/{jackpot.Game})");
				}
				
				if (jackpot.Threshold > max)
				{
					// Reset to default
					if (jackpot.Category == "Mini") jackpot.Threshold = 23;
					else if (jackpot.Category == "Minor") jackpot.Threshold = 117;
					else if (jackpot.Category == "Major") jackpot.Threshold = 565;
					else jackpot.Threshold = 1785;
					
					modified = true;
					Console.WriteLine($"Reset insane Threshold for {jackpot.Category} ({jackpot.House}/{jackpot.Game})");
				}
				
				if (modified)
				{
					jackpotsRepo.Upsert(jackpot);
					updatedJackpots++;
				}
			}
			Console.WriteLine($"- Updated {updatedJackpots} jackpots");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"Error during cleanup: {ex.Message}");
			Console.WriteLine(ex.StackTrace);
			Environment.Exit(1);
		}
	}
}
