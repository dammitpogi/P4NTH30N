using System;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;
using P4NTHE0N.C0MMON.Interfaces;

namespace CLEANUP;

public class FixData
{
	public static void Main(string[] args)
	{
		Console.WriteLine("Starting data cleanup...");

		try
		{
			MongoUnitOfWork unitOfWork = new();
			IRepoCredentials credentialsRepo = unitOfWork.Credentials;

			List<Credential> credentials = credentialsRepo.GetAll();
			Console.WriteLine($"Found {credentials.Count} credentials to process");

			int updatedCount = 0;
			int dpdCleanedCount = 0;
			int jackpotResetCount = 0;

			foreach (Credential credential in credentials)
			{
				bool wasModified = false;

				if (credential.Jackpots.Grand > 0)
				{
					credential.Jackpots.Grand = 0;
					wasModified = true;
				}
				if (credential.Jackpots.Major > 0)
				{
					credential.Jackpots.Major = 0;
					wasModified = true;
				}
				if (credential.Jackpots.Minor > 0)
				{
					credential.Jackpots.Minor = 0;
					wasModified = true;
				}
				if (credential.Jackpots.Mini > 0)
				{
					credential.Jackpots.Mini = 0;
					wasModified = true;
				}

				if (wasModified)
				{
					jackpotResetCount++;
					Console.WriteLine($"Reset jackpots for {credential.Username} ({credential.House}/{credential.Game})");
				}

				// DPD removed from Credential - data migrated to Jackpot collection via DpdMigration

				if (wasModified)
				{
					credentialsRepo.Upsert(credential);
					updatedCount++;
				}
			}

			Console.WriteLine("\nCleanup complete!");
			Console.WriteLine($"- Reset jackpots for {jackpotResetCount} credentials");
			Console.WriteLine($"- Updated {updatedCount} credentials");
			Console.WriteLine($"- Removed {dpdCleanedCount} insane DPD values");

			IRepoJackpots jackpotsRepo = unitOfWork.Jackpots;
			List<Jackpot> jackpots = jackpotsRepo.GetAll();
			Console.WriteLine($"Found {jackpots.Count} jackpots to process");

			int updatedJackpots = 0;

			foreach (Jackpot jackpot in jackpots)
			{
				bool modified = false;
				double max = 15000;
				if (jackpot.Category == "Mini")
				{
					max = 200;
				}
				else if (jackpot.Category == "Minor")
				{
					max = 1000;
				}
				else if (jackpot.Category == "Major")
				{
					max = 3000;
				}

				if (jackpot.Current > max)
				{
					jackpot.Current = 0;
					modified = true;
					Console.WriteLine($"Reset insane Current for {jackpot.Category} ({jackpot.House}/{jackpot.Game})");
				}

				if (jackpot.Threshold > max)
				{
					if (jackpot.Category == "Mini")
					{
						jackpot.Threshold = 23;
					}
					else if (jackpot.Category == "Minor")
					{
						jackpot.Threshold = 117;
					}
					else if (jackpot.Category == "Major")
					{
						jackpot.Threshold = 565;
					}
					else
					{
						jackpot.Threshold = 1785;
					}

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
