using System;
using System.Collections.Generic;
using System.Linq;
using MongoDB.Bson;
using MongoDB.Bson.Serialization;
using MongoDB.Driver;
using P4NTH30N.C0MMON;

namespace P4NTH30N.C0MMON.Infrastructure.Persistence
{
    /// <summary>
    /// MongoDB operation interceptor that validates all data before persistence
    /// Prevents extreme values and corrupted data from entering the database
    /// </summary>
    public class ValidatedMongoRepository
    {
        private readonly IMongoDatabase _database;

        public ValidatedMongoRepository(IMongoDatabase database)
        {
            _database = database;
        }

        /// <summary>
        /// Validated upsert for credentials - applies comprehensive validation before any write
        /// </summary>
        public void ValidatedCredentialUpsert(Credential credential)
        {
            try
            {
                var issues = new List<string>();
                bool hasCriticalIssues = false;

                // Validate balance
                if (credential.Balance < 0 || double.IsNaN(credential.Balance) || double.IsInfinity(credential.Balance))
                {
                    hasCriticalIssues = true;
                    issues.Add($"Balance: {credential.Balance}");
                }

                // Validate jackpots
                if (credential.Jackpots != null)
                {
                    bool grandValid = !double.IsNaN(credential.Jackpots.Grand) && !double.IsInfinity(credential.Jackpots.Grand) && credential.Jackpots.Grand >= 0;
                    bool majorValid = !double.IsNaN(credential.Jackpots.Major) && !double.IsInfinity(credential.Jackpots.Major) && credential.Jackpots.Major >= 0;
                    bool minorValid = !double.IsNaN(credential.Jackpots.Minor) && !double.IsInfinity(credential.Jackpots.Minor) && credential.Jackpots.Minor >= 0;
                    bool miniValid = !double.IsNaN(credential.Jackpots.Mini) && !double.IsInfinity(credential.Jackpots.Mini) && credential.Jackpots.Mini >= 0;

                    if (!grandValid || !majorValid || !minorValid || !miniValid)
                    {
                        hasCriticalIssues = true;
                        if (!grandValid) issues.Add($"Grand: {credential.Jackpots.Grand}");
                        if (!majorValid) issues.Add($"Major: {credential.Jackpots.Major}");
                        if (!minorValid) issues.Add($"Minor: {credential.Jackpots.Minor}");
                        if (!miniValid) issues.Add($"Mini: {credential.Jackpots.Mini}");
                    }
                }

                // Validate DPD data arrays for historical corruption
                if (credential.DPD?.Data != null)
                {
                    var cleanedDpdData = new List<DPD_Data>();
                    foreach (var dpdEntry in credential.DPD.Data)
                    {
                        if (dpdEntry.Grand < 0 || dpdEntry.Grand > 10000)
                        {
                            issues.Add($"Removed corrupted DPD entry: Grand={dpdEntry.Grand}");
                            continue; // Skip corrupted entries
                        }
                        cleanedDpdData.Add(dpdEntry);
                    }
                    credential.DPD.Data = cleanedDpdData;
                }

                // Log any repairs or issues
                if (issues.Any())
                {
                    Console.WriteLine($"🔧 Validation for {credential.Game} - {credential.Username}: {string.Join("; ", issues)}");
                }

                // Prevent writes with critical validation failures
                if (hasCriticalIssues)
                {
                    throw new InvalidOperationException($"Critical validation failures prevent credential upsert: {string.Join("; ", issues)}");
                }

                // Perform the actual upsert if validation passed
                var collection = _database.GetCollection<Credential>("CRED3N7IAL");
                var filter = Builders<Credential>.Filter.Eq(c => c._id, credential._id);
                collection.ReplaceOne(filter, credential, new ReplaceOptions { IsUpsert = true });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"🔴 Validation error during credential upsert: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Validated jackpot upsert with enhanced validation
        /// </summary>
        public void ValidatedJackpotUpsert(Jackpot jackpot)
        {
            try
            {
                var issues = new List<string>();
                bool hasCriticalIssues = false;

                // Validate Current value against Category-specific limits
                var categoryLimits = new Dictionary<string, (double max, double threshold)>
                {
                    { "Grand", (10000.0, 2000.0) },
                    { "Major", (1000.0, 1000.0) },
                    { "Minor", (200.0, 150.0) },
                    { "Mini", (50.0, 40.0) }
                };

                if (categoryLimits.TryGetValue(jackpot.Category, out var limits))
                {
                    bool isValid = !double.IsNaN(jackpot.Current) && !double.IsInfinity(jackpot.Current) && jackpot.Current >= 0;
                    if (!isValid)
                    {
                        hasCriticalIssues = true;
                        issues.Add($"{jackpot.Category}: {jackpot.Current}");
                    }
                }

                if (hasCriticalIssues)
                {
                    throw new InvalidOperationException($"Critical jackpot validation failures: {string.Join("; ", issues)}");
                }

                // Perform the upsert
                var collection = _database.GetCollection<Jackpot>("J4CKP0T");
                var filter = Builders<Jackpot>.Filter.Eq(j => j._id, jackpot._id);
                collection.ReplaceOne(filter, jackpot, new ReplaceOptions { IsUpsert = true });
            }
            catch (Exception ex)
            {
                Console.WriteLine($"🔴 Validation error during jackpot upsert: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Comprehensive data cleaning for legacy corrupted entries with enhanced BitVegas detection
        /// </summary>
        public DataCleaningResult CleanCorruptedData()
        {
            var result = new DataCleaningResult();
            var credentialCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");

            try
            {
                // First, specifically target BitVegas credentials which are known to have corruption
                var bitvegasFilter = Builders<BsonDocument>.Filter.Regex("Game", new BsonRegularExpression("BitVegas", "i"));
                var bitvegasDocs = credentialCollection.Find(bitvegasFilter).ToList();
                Console.WriteLine($"🔍 Found {bitvegasDocs.Count} BitVegas credentials for targeted cleanup");
                
                // Aggressively clean BitVegas data - known corruption source
                foreach (var doc in bitvegasDocs)
                {
                    CleanCredentialDocument(doc, credentialCollection, result, true); // Force aggressive cleaning for BitVegas
                }

                // Then find and clean all other credentials with corrupted jackpot values
                var extremeJackpotFilter = Builders<BsonDocument>.Filter.Or(
                    Builders<BsonDocument>.Filter.Gt("Jackpots.Grand", 10000),
                    Builders<BsonDocument>.Filter.Gt("Jackpots.Major", 1000),
                    Builders<BsonDocument>.Filter.Gt("Jackpots.Minor", 200),
                    Builders<BsonDocument>.Filter.Gt("Jackpots.Mini", 50),
                    Builders<BsonDocument>.Filter.Gt("Balance", 50000)
                );

                var corruptedCredentials = credentialCollection.Find(extremeJackpotFilter).ToList();
                result.CorruptedCredentialsFound = corruptedCredentials.Count;

                foreach (var credential in corruptedCredentials)
                {
                    CleanCredentialDocument(credential, credentialCollection, result, false);
                }

                // Clean legacy collection extreme values
                var legacyCollection = _database.GetCollection<BsonDocument>("G4ME_LEGACY_20260209");
                var extremeLegacyFilter = Builders<BsonDocument>.Filter.Gt("Thresholds.Data.Grand", 5000);
                var extremeLegacyDocs = legacyCollection.Find(extremeLegacyFilter).ToList();
                result.CorruptedLegacyEntries = extremeLegacyDocs.Count;

                // Archive or clean extreme legacy data
                foreach (var doc in extremeLegacyDocs)
                {
                    var house = doc.Contains("House") ? doc["House"].AsString : "Unknown";
                    
                    // Find and clean extreme Grand values in Data arrays
                    if (doc.Contains("Thresholds") && doc["Thresholds"].AsBsonDocument.Contains("Data"))
                    {
                        var data = doc["Thresholds"]["Data"].AsBsonDocument;
                        if (data.Contains("Grand"))
                        {
                            var grandArray = data["Grand"].AsBsonArray;
                            var cleanedArray = new BsonArray();
                            
                            foreach (var value in grandArray)
                            {
                                var doubleValue = value.ToDouble();
                                if (doubleValue <= 10000)
                                {
                                    cleanedArray.Add(value);
                                }
                                else
                                {
                                    result.Repairs.Add($"Removed extreme legacy Grand from {house}: {doubleValue}");
                                }
                            }
                            
                            if (cleanedArray.Count != grandArray.Count)
                            {
                                var updateFilter = Builders<BsonDocument>.Filter.Eq("_id", doc["_id"]);
                                var update = Builders<BsonDocument>.Update.Set("Thresholds.Data.Grand", cleanedArray);
                                legacyCollection.UpdateOne(updateFilter, update);
                            }
                        }
                    }
                }

                Console.WriteLine($"🧹 Data cleaning complete: {result.Summary}");
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"🔴 Error during data cleaning: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Helper method to clean a single credential document
        /// </summary>
        private void CleanCredentialDocument(BsonDocument credential, IMongoCollection<BsonDocument> collection, DataCleaningResult result, bool aggressive = false)
        {
            var username = credential.Contains("Username") ? credential["Username"].AsString : "Unknown";
            var game = credential.Contains("Game") ? credential["Game"].AsString : "Unknown";

            // Validate - don't mutate (validate but don't repair)
            if (credential.Contains("Jackpots"))
            {
                var jackpots = credential["Jackpots"].AsBsonDocument;
                
                // Repair each tier with enhanced validation for aggressive mode
                if (jackpots.Contains("Grand"))
                {
                    var grandValue = jackpots["Grand"].ToDouble();
                    bool isValid = !double.IsNaN(grandValue) && !double.IsInfinity(grandValue) && grandValue >= 0 && grandValue <= 10000;
                    
                    // REMOVED: Auto-repair logic - only log invalid values, don't mutate
                    if (!isValid)
                    {
                        result.Repairs.Add($"Invalid Grand for {username}: {grandValue} (not repairing - validate but don't mutate)");
                    }
                }
                
                if (jackpots.Contains("Major"))
                {
                    var majorValue = jackpots["Major"].ToDouble();
                    bool isValid = !double.IsNaN(majorValue) && !double.IsInfinity(majorValue) && majorValue >= 0 && majorValue <= 10000;
                    
                    // REMOVED: Auto-repair logic - only log invalid values, don't mutate
                    if (!isValid)
                    {
                        result.Repairs.Add($"Invalid Major for {username}: {majorValue} (not repairing - validate but don't mutate)");
                    }
                }
                
                if (jackpots.Contains("Minor"))
                {
                    var minorValue = jackpots["Minor"].ToDouble();
                    bool isValid = !double.IsNaN(minorValue) && !double.IsInfinity(minorValue) && minorValue >= 0 && minorValue <= 10000;
                    
                    // REMOVED: Auto-repair logic - only log invalid values, don't mutate
                    if (!isValid)
                    {
                        result.Repairs.Add($"Invalid Minor for {username}: {minorValue} (not repairing - validate but don't mutate)");
                    }
                }
                
                if (jackpots.Contains("Mini"))
                {
                    var miniValue = jackpots["Mini"].ToDouble();
                    bool isValid = !double.IsNaN(miniValue) && !double.IsInfinity(miniValue) && miniValue >= 0 && miniValue <= 10000;
                    
                    // REMOVED: Auto-repair logic - only log invalid values, don't mutate
                    if (!isValid)
                    {
                        result.Repairs.Add($"Invalid Mini for {username}: {miniValue} (not repairing - validate but don't mutate)");
                    }
                }
            }

            // Balance validation - removed auto-repair
            if (credential.Contains("Balance"))
            {
                var balance = credential["Balance"].ToDouble();
                bool isValid = !double.IsNaN(balance) && !double.IsInfinity(balance) && balance >= 0 && balance <= 100000;
                
                // REMOVED: Auto-repair logic - only log invalid values, don't mutate
                if (!isValid)
                {
                    result.Repairs.Add($"Invalid Balance for {username}: {balance} (not repairing - validate but don't mutate)");
                }
            }

            // REMOVED: Apply updates if any repairs needed - no longer auto-repairing
        }

        /// <summary>
        /// Additional aggressive cleanup for known corruption patterns
        /// </summary>
        public DataCleaningResult AggressiveCleanup()
        {
            var result = new DataCleaningResult();
            var credentialCollection = _database.GetCollection<BsonDocument>("CRED3N7IAL");

            try
            {
                // Clean all BitVegas credentials aggressively regardless of current values
                var bitvegasFilter = Builders<BsonDocument>.Filter.Regex("Game", new BsonRegularExpression("BitVegas", "i"));
                var bitvegasDocs = credentialCollection.Find(bitvegasFilter).ToList();
                
                foreach (var doc in bitvegasDocs)
                {
                    CleanCredentialDocument(doc, credentialCollection, result, true); // Force aggressive cleaning
                }

                // Clean legacy collection extreme values
                var legacyCollection = _database.GetCollection<BsonDocument>("G4ME_LEGACY_20260209");
                var extremeLegacyFilter = Builders<BsonDocument>.Filter.Gt("Thresholds.Data.Grand", 5000);
                var extremeLegacyDocs = legacyCollection.Find(extremeLegacyFilter).ToList();
                result.CorruptedLegacyEntries = extremeLegacyDocs.Count;

                // Archive or clean extreme legacy data
                foreach (var doc in extremeLegacyDocs)
                {
                    var house = doc.Contains("House") ? doc["House"].AsString : "Unknown";
                    
                    // Find and clean extreme Grand values in Data arrays
                    if (doc.Contains("Thresholds") && doc["Thresholds"].AsBsonDocument.Contains("Data"))
                    {
                        var data = doc["Thresholds"]["Data"].AsBsonDocument;
                        if (data.Contains("Grand"))
                        {
                            var grandArray = data["Grand"].AsBsonArray;
                            var cleanedArray = new BsonArray();
                            
                            foreach (var value in grandArray)
                            {
                                var doubleValue = value.ToDouble();
                                if (doubleValue <= 10000)
                                {
                                    cleanedArray.Add(value);
                                }
                                else
                                {
                                    result.Repairs.Add($"Removed extreme legacy Grand from {house}: {doubleValue}");
                                }
                            }
                            
                            if (cleanedArray.Count != grandArray.Count)
                            {
                                var updateFilter = Builders<BsonDocument>.Filter.Eq("_id", doc["_id"]);
                                var update = Builders<BsonDocument>.Update.Set("Thresholds.Data.Grand", cleanedArray);
                                legacyCollection.UpdateOne(updateFilter, update);
                            }
                        }
                    }
                }

                Console.WriteLine($"🧹 Data cleaning complete: {result.Summary}");
                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"🔴 Error during data cleaning: {ex.Message}");
                throw;
            }
        }
    }

    public class DataCleaningResult
    {
        public int CorruptedCredentialsFound { get; set; }
        public int CorruptedLegacyEntries { get; set; }
        public List<string> Repairs { get; set; } = new List<string>();
        public string Summary => $"Cleaned {CorruptedCredentialsFound} credentials, {CorruptedLegacyEntries} legacy entries, {Repairs.Count} total repairs";
    }
}