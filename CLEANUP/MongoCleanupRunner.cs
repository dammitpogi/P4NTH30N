using System;
using System.Threading.Tasks;
using MongoDB.Driver;
using MongoDB.Bson;
using P4NTH30N.CLEANUP;

namespace P4NTH30N.CLEANUP
{
    /// <summary>
    /// Standalone MongoDB cleanup runner for P4NTH30N
    /// Connects to MongoDB and performs comprehensive cleanup of extreme values
    /// </summary>
    public class MongoCleanupRunner
    {
        private readonly string _connectionString;
        private readonly string _databaseName;
        
        public MongoCleanupRunner(string connectionString = "mongodb://localhost:27017", string databaseName = "P4NTH30N")
        {
            _connectionString = connectionString;
            _databaseName = databaseName;
        }
        
        public async Task RunCleanupAsync()
        {
            try
            {
                Console.WriteLine("🚀 Starting P4NTH30N MongoDB Cleanup Utility");
                Console.WriteLine($"📍 Connecting to: {_connectionString}/{_databaseName}");
                Console.WriteLine($"🕒 Started at: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
                Console.WriteLine();
                
                // Connect to MongoDB
                var client = new MongoClient(_connectionString);
                var database = client.GetDatabase(_databaseName);
                
                // Test connection
                await database.RunCommandAsync(new JsonCommand<BsonDocument>("{ ping: 1 }"));
                Console.WriteLine("✅ MongoDB connection established");
                
                // Initialize cleanup utility
                var cleanupUtility = new MongoCleanupUtility(database);
                
                // Scan for BitVegas corruption first
                Console.WriteLine("\n🔍 Scanning for BitVegas-related corruption...");
                var bitvegasScan = cleanupUtility.ScanBitVegasCorruption();
                
                if (bitvegasScan.CorruptedEntries > 0)
                {
                    Console.WriteLine($"⚠️ Found {bitvegasScan.CorruptedEntries} corrupted BitVegas entries");
                    foreach (var cred in bitvegasScan.BitVegasCredentials)
                    {
                        Console.WriteLine($"   - {cred}");
                    }
                }
                else
                {
                    Console.WriteLine("✅ No BitVegas corruption found");
                }
                
                // Perform full cleanup
                Console.WriteLine("\n🧹 Performing comprehensive cleanup...");
                var cleanupResult = cleanupUtility.PerformFullCleanup();
                
                // Display results
                Console.WriteLine("\n📊 CLEANUP RESULTS:");
                Console.WriteLine($"   Credentials: {cleanupResult.CredentialResults.DocumentsFound} found, {cleanupResult.CredentialResults.DocumentsRepaired} repaired");
                Console.WriteLine($"   Jackpots: {cleanupResult.JackpotResults.DocumentsFound} found, {cleanupResult.JackpotResults.DocumentsRepaired} repaired");
                Console.WriteLine($"   Legacy: {cleanupResult.LegacyResults.DocumentsFound} potentially extreme");
                Console.WriteLine($"   Analytics: {cleanupResult.AnalyticsResults.DocumentsFound} potentially extreme");
                Console.WriteLine($"   Validation: {(cleanupResult.ValidationResults.Errors.Count == 0 ? "✅ PASSED" : "❌ FAILED")}");
                
                if (cleanupResult.CredentialResults.RepairDetails.Count > 0)
                {
                    Console.WriteLine("\n🔧 REPAIR DETAILS:");
                    foreach (var detail in cleanupResult.CredentialResults.RepairDetails)
                    {
                        Console.WriteLine($"   {detail}");
                    }
                }
                
                if (cleanupResult.Errors.Count > 0 || cleanupResult.CredentialResults.Errors.Count > 0)
                {
                    Console.WriteLine("\n🔴 ERRORS:");
                    foreach (var error in cleanupResult.Errors)
                    {
                        Console.WriteLine($"   {error}");
                    }
                    foreach (var error in cleanupResult.CredentialResults.Errors)
                    {
                        Console.WriteLine($"   {error}");
                    }
                }
                
                Console.WriteLine($"\n🎯 Summary: {cleanupResult.GetSummary()}");
                Console.WriteLine($"✅ Cleanup completed at: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
                
                // Exit with appropriate code
                var exitCode = (cleanupResult.Errors.Count > 0 || cleanupResult.ValidationResults.Errors.Count > 0) ? 1 : 0;
                Environment.Exit(exitCode);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\n🔴 FATAL ERROR: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
                Environment.Exit(1);
            }
        }
    }
    
    /// <summary>
    /// Program entry point for standalone cleanup execution
    /// </summary>
    public class Program
    {
        public static async Task Main(string[] args)
        {
            // Parse command line arguments
            string connectionString = "mongodb://localhost:27017";
            string databaseName = "P4NTH30N";
            
            if (args.Length >= 1)
            {
                connectionString = args[0];
            }
            
            if (args.Length >= 2)
            {
                databaseName = args[1];
            }
            
            Console.WriteLine("🔧 P4NTH30N MongoDB Cleanup Utility");
            Console.WriteLine("Usage: MongoCleanupRunner.exe [connectionString] [databaseName]");
            Console.WriteLine($"Using: {connectionString} / {databaseName}");
            Console.WriteLine();
            
            var runner = new MongoCleanupRunner(connectionString, databaseName);
            await runner.RunCleanupAsync();
        }
    }
}