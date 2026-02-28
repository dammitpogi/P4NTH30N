using System;
using System.Linq;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace CLEANUP;

public class ComprehensiveDataFix
{
	public static void Main(string[] args)
	{
		Console.WriteLine("Starting comprehensive data cleanup...");

		try
		{
			// Connect to MongoDB
			var unitOfWork = new MongoUnitOfWork();
			var credentialsRepo = unitOfWork.Credentials;

			// Get all credentials
			var credentials = credentialsRepo.GetAll();
			Console.WriteLine($"Found {credentials.Count} credentials to process");

			int updatedCredentialsCount = 0;
			int thresholdsResetCount = 0;

			foreach (var credential in credentials)
			{
				bool wasModified = false;

				// Check and reset Thresholds if any threshold > 10000 (or specifically > 15000)
				if (
					credential.Thresholds != null
					&& (
						credential.Thresholds.Mini > 10000
						|| credential.Thresholds.Minor > 10000
						|| credential.Thresholds.Major > 10000
						|| credential.Thresholds.Grand > 15000
					)
				)
				{
					credential.Thresholds.Mini = 23;
					credential.Thresholds.Minor = 117;
					credential.Thresholds.Major = 565;
					credential.Thresholds.Grand = 1785;
					wasModified = true;
					thresholdsResetCount++;
					Console.WriteLine($"Reset insane thresholds for {credential.Username} ({credential.House}/{credential.Game})");
				}

				// DPD removed from Credential - data migrated to Jackpot collection via DpdMigration

				// Save changes if modified
				if (wasModified)
				{
					credentialsRepo.Upsert(credential);
					updatedCredentialsCount++;
				}
			}

			Console.WriteLine($"\nCredentials cleanup complete!");
			Console.WriteLine($"- Updated {updatedCredentialsCount} credentials");
			Console.WriteLine($"- Reset thresholds for {thresholdsResetCount} credentials");

			// Clean Jackpots collection
			var jackpotsRepo = unitOfWork.Jackpots;
			var jackpots = jackpotsRepo.GetAll();
			Console.WriteLine($"\nFound {jackpots.Count} jackpots to process");

			int updatedJackpotsCount = 0;
			int jackpotsResetCount = 0;

			foreach (var jackpot in jackpots)
			{
				bool modified = false;

				// Determine max allowed value based on tier
				double maxAllowed = 15000;
				if (jackpot.Category == "Mini")
					maxAllowed = 200;
				else if (jackpot.Category == "Minor")
					maxAllowed = 1000;
				else if (jackpot.Category == "Major")
					maxAllowed = 3000;

				// Check Current value
				if (jackpot.Current > maxAllowed)
				{
					jackpot.Current = 0; // Reset current if insane
					modified = true;
					Console.WriteLine($"Reset insane Current ({jackpot.Current}) for {jackpot.Category} ({jackpot.House}/{jackpot.Game})");
				}

				// Check Threshold value
				if (jackpot.Threshold > maxAllowed)
				{
					// Reset to default based on tier
					if (jackpot.Category == "Mini")
						jackpot.Threshold = 23;
					else if (jackpot.Category == "Minor")
						jackpot.Threshold = 117;
					else if (jackpot.Category == "Major")
						jackpot.Threshold = 565;
					else
						jackpot.Threshold = 1785; // Grand

					modified = true;
					jackpotsResetCount++;
					Console.WriteLine($"Reset insane Threshold for {jackpot.Category} ({jackpot.House}/{jackpot.Game})");
				}

				// Save changes if modified
				if (modified)
				{
					jackpotsRepo.Upsert(jackpot);
					updatedJackpotsCount++;
				}
			}

			Console.WriteLine($"\nJackpots cleanup complete!");
			Console.WriteLine($"- Updated {updatedJackpotsCount} jackpots");
			Console.WriteLine($"- Reset thresholds for {jackpotsResetCount} jackpots");

			Console.WriteLine($"\n✅ Comprehensive data cleanup finished successfully!");
		}
		catch (Exception ex)
		{
			Console.WriteLine($"❌ Error during cleanup: {ex.Message}");
			Console.WriteLine(ex.StackTrace);
			Environment.Exit(1);
		}
	}
}
