using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;
using Microsoft.Extensions.Logging;
using P4NTH30N.C0MMON.SanityCheck;
using P4NTH30N.C0MMON.Persistence;

namespace P4NTH30N.CLEANUP
{
    /// <summary>
    /// Real-time MongoDB data corruption monitor and prevention system
    /// Continuously monitors collections and prevents extreme values from entering the system
    /// </summary>
    public class MongoCorruptionPreventionService
    {
        private readonly IMongoDatabase _database;
        private readonly ILogger<MongoCorruptionPreventionService> _logger;
        private readonly Timer _monitoringTimer;
        private readonly ValidatedMongoRepository _validatedRepo;
        
        // Configuration
        private readonly TimeSpan _checkInterval = TimeSpan.FromMinutes(2);
        private readonly TimeSpan _alertCooldown = TimeSpan.FromMinutes(5);
        private DateTime _lastAlert = DateTime.MinValue;
        
        // Statistics
        private int _checksPerformed = 0;
        private int _alertsTriggered = 0;
        private int _correctionsMade = 0;
        
        public MongoCorruptionPreventionService(IMongoDatabase database, ILogger<MongoCorruptionPreventionService> logger)
        {
            _database = database;
            _logger = logger;
            _validatedRepo = new ValidatedMongoRepository(database);
            _monitoringTimer = new Timer(PerformHealthCheck, null, _checkInterval, _checkInterval);
        }
        
        /// <summary>
        /// Periodic health check that monitors all collections for corruption
        /// </summary>
        private async void PerformHealthCheck(object state)
        {
            try
            {
                _checksPerformed++;
                var timestamp = DateTime.Now;
                
                _logger.LogInformation("🔍 MongoDB corruption prevention check #{_checksPerformed} at {timestamp}", 
                    _checksPerformed, timestamp.ToString("HH:mm:ss"));
                
                var issues = await CheckForCorruptionAsync();
                
                if (issues.Any())
                {
                    await HandleCorruptionIssuesAsync(issues);
                }
                else
                {
                    _logger.LogInformation("✅ No corruption detected - all collections healthy");
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "🔴 Error during corruption prevention check");
                await SendAlert($"Corruption prevention check failed: {ex.Message}");
            }
        }
        
        /// <summary>
        /// Check all collections for extreme values and corruption patterns
        /// </summary>
        private async Task<List<CorruptionIssue>> CheckForCorruptionAsync()
        {
            var issues = new List<CorruptionIssue>();
            
            // Check CRED3N7IAL collection
            var credentialIssues = await CheckCredentialCollectionAsync();
            issues.AddRange(credentialIssues);
            
            // Check J4CKP0T collection
            var jackpotIssues = await CheckJackpotCollectionAsync();
            issues.AddRange(jackpotIssues);
            
            // Check LEDGER collections for analytics corruption
            var analyticsIssues = await CheckAnalyticsCollectionsAsync();
            issues.AddRange(analyticsIssues);
            
            return issues;
        }
        
        /// <summary>
        /// Check CRED3N7IAL collection for extreme jackpot values and balances
        /// </summary>
        private async Task<List<CorruptionIssue>> CheckCredentialCollectionAsync()
        {
            var issues = new List<CorruptionIssue>();
            var collection = _database.GetCollection<BsonDocument>("CRED3N7IAL");
            
            // Find extreme jackpot values
            var extremeFilter = Builders<BsonDocument>.Filter.Or(
                Builders<BsonDocument>.Filter.Gt("Jackpots.Grand", 10000),
                Builders<BsonDocument>.Filter.Gt("Jackpots.Major", 1000),
                Builders<BsonDocument>.Filter.Gt("Jackpots.Minor", 200),
                Builders<BsonDocument>.Filter.Gt("Jackpots.Mini", 50),
                Builders<BsonDocument>.Filter.Gt("Balance", 50000)
            );
            
            var extremeDocs = await collection.Find(extremeFilter).ToListAsync();
            
            foreach (var doc in extremeDocs)
            {
                var username = doc.Contains("Username") ? doc["Username"].AsString : "Unknown";
                var game = doc.Contains("Game") ? doc["Game"].AsString : "Unknown";
                
                if (doc.Contains("Jackpots"))
                {
                    var jackpots = doc["Jackpots"].AsBsonDocument;
                    
                    if (jackpots.Contains("Grand") && jackpots["Grand"].ToDouble() > 10000)
                    {
                        issues.Add(new CorruptionIssue
                        {
                            Collection = "CRED3N7IAL",
                            DocumentId = doc["_id"].ToString(),
                            IssueType = "Extreme Grand Jackpot",
                            Description = $"{username} ({game}) Grand: {jackpots["Grand"]:F2}",
                            Severity = Severity.High
                        });
                    }
                    
                    if (jackpots.Contains("Major") && jackpots["Major"].ToDouble() > 1000)
                    {
                        issues.Add(new CorruptionIssue
                        {
                            Collection = "CRED3N7IAL",
                            DocumentId = doc["_id"].ToString(),
                            IssueType = "Extreme Major Jackpot",
                            Description = $"{username} ({game}) Major: {jackpots["Major"]:F2}",
                            Severity = Severity.High
                        });
                    }
                    
                    if (jackpots.Contains("Minor") && jackpots["Minor"].ToDouble() > 200)
                    {
                        issues.Add(new CorruptionIssue
                        {
                            Collection = "CRED3N7IAL",
                            DocumentId = doc["_id"].ToString(),
                            IssueType = "Extreme Minor Jackpot",
                            Description = $"{username} ({game}) Minor: {jackpots["Minor"]:F2}",
                            Severity = Severity.Medium
                        });
                    }
                    
                    if (jackpots.Contains("Mini") && jackpots["Mini"].ToDouble() > 50)
                    {
                        issues.Add(new CorruptionIssue
                        {
                            Collection = "CRED3N7IAL",
                            DocumentId = doc["_id"].ToString(),
                            IssueType = "Extreme Mini Jackpot",
                            Description = $"{username} ({game}) Mini: {jackpots["Mini"]:F2}",
                            Severity = Severity.Medium
                        });
                    }
                }
                
                if (doc.Contains("Balance") && doc["Balance"].ToDouble() > 50000)
                {
                    issues.Add(new CorruptionIssue
                    {
                        Collection = "CRED3N7IAL",
                        DocumentId = doc["_id"].ToString(),
                        IssueType = "Extreme Balance",
                        Description = $"{username} Balance: {doc["Balance"]:F2}",
                        Severity = Severity.High
                    });
                }
            }
            
            return issues;
        }
        
        /// <summary>
        /// Check J4CKP0T collection for extreme values
        /// </summary>
        private async Task<List<CorruptionIssue>> CheckJackpotCollectionAsync()
        {
            var issues = new List<CorruptionIssue>();
            var collection = _database.GetCollection<BsonDocument>("J4CKP0T");
            
            var extremeFilter = Builders<BsonDocument>.Filter.Gt("Current", 10000);
            var extremeDocs = await collection.Find(extremeFilter).ToListAsync();
            
            foreach (var doc in extremeDocs)
            {
                var category = doc.Contains("Category") ? doc["Category"].AsString : "Unknown";
                var currentValue = doc["Current"].ToDouble();
                
                issues.Add(new CorruptionIssue
                {
                    Collection = "J4CKP0T",
                    DocumentId = doc["_id"].ToString(),
                    IssueType = "Extreme Jackpot Value",
                    Description = $"{category} jackpot: {currentValue:F2}",
                    Severity = Severity.High
                });
            }
            
            return issues;
        }
        
        /// <summary>
        /// Check LEDGER analytics collections for corrupted data
        /// </summary>
        private async Task<List<CorruptionIssue>> CheckAnalyticsCollectionsAsync()
        {
            var issues = new List<CorruptionIssue>();
            
            try
            {
                var collections = await _database.ListCollections().ToListAsync();
                var analyticsCollections = collections.Where(c => c["name"].AsString.StartsWith("LEDGER_")).ToList();
                
                foreach (var collectionInfo in analyticsCollections)
                {
                    var collectionName = collectionInfo["name"].AsString;
                    var collection = _database.GetCollection<BsonDocument>(collectionName);
                    
                    // Look for extreme values in analytics data
                    var extremeFilter = Builders<BsonDocument>.Filter.Or(
                        Builders<BsonDocument>.Filter.Gt("jackpotGrand", 10000),
                        Builders<BsonDocument>.Filter.Gt("jackpotMajor", 1000),
                        Builders<BsonDocument>.Filter.Gt("jackpotMinor", 200),
                        Builders<BsonDocument>.Filter.Gt("jackpotMini", 50)
                    );
                    
                    var extremeDocs = await collection.Find(extremeFilter).Limit(10).ToListAsync(); // Limit to avoid too many alerts
                    
                    foreach (var doc in extremeDocs)
                    {
                        issues.Add(new CorruptionIssue
                        {
                            Collection = collectionName,
                            DocumentId = doc["_id"].ToString(),
                            IssueType = "Analytics Extreme Values",
                            Description = "Analytics data contains extreme jackpot values",
                            Severity = Severity.Medium
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Error checking analytics collections");
            }
            
            return issues;
        }
        
        /// <summary>
        /// Handle detected corruption issues by logging, alerting, and auto-correcting
        /// </summary>
        private async Task HandleCorruptionIssuesAsync(List<CorruptionIssue> issues)
        {
            if (issues.Count == 0) return;
            
            // Check alert cooldown
            if (DateTime.Now - _lastAlert < _alertCooldown)
            {
                _logger.LogWarning("Alert cooldown active - {count} corruption issues detected but not alerting", issues.Count);
                return;
            }
            
            _lastAlert = DateTime.Now;
            _alertsTriggered++;
            
            var highSeverityIssues = issues.Where(i => i.Severity == Severity.High).ToList();
            var mediumSeverityIssues = issues.Where(i => i.Severity == Severity.Medium).ToList();
            
            _logger.LogWarning("🚨 CORRUPTION DETECTED: {total} issues ({high} high, {medium} medium)", 
                issues.Count, highSeverityIssues.Count, mediumSeverityIssues.Count);
            
            // Log all issues
            foreach (var issue in issues)
            {
                _logger.LogWarning("🔴 [{severity}] {collection}: {description}", 
                    issue.Severity, issue.Collection, issue.Description);
            }
            
            // Attempt auto-correction for high severity issues
            var correctedIssues = await AutoCorrectIssuesAsync(highSeverityIssues);
            _correctionsMade += correctedIssues.Count;
            
            if (correctedIssues.Count > 0)
            {
                _logger.LogInformation("🔧 Auto-corrected {count} corruption issues", correctedIssues.Count);
            }
            
            // Send alert for remaining uncorrected issues
            var remainingIssues = issues.Except(correctedIssues).ToList();
            if (remainingIssues.Any())
            {
                await SendAlert($"Active corruption detected: {remainingIssues.Count} issues remaining after auto-correction");
            }
        }
        
        /// <summary>
        /// Attempt to automatically correct corruption issues
        /// </summary>
        private async Task<List<CorruptionIssue>> AutoCorrectIssuesAsync(List<CorruptionIssue> issues)
        {
            var corrected = new List<CorruptionIssue>();
            
            try
            {
                // Use the existing ValidatedMongoRepository for cleanup
                var cleanupResult = _validatedRepo.CleanCorruptedData();
                
                if (cleanupResult.Repairs.Any())
                {
                    _logger.LogInformation("🧹 ValidatedMongoRepository performed {count} repairs", cleanupResult.Repairs.Count);
                    
                    // Mark issues as corrected if they match the repairs performed
                    foreach (var issue in issues)
                    {
                        if (cleanupResult.Repairs.Any(r => r.Contains(issue.DocumentId) || r.Contains(issue.Collection)))
                        {
                            corrected.Add(issue);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Auto-correction failed");
            }
            
            return corrected;
        }
        
        /// <summary>
        /// Send alert notification (log to EV3NT collection and console)
        /// </summary>
        private async Task SendAlert(string message)
        {
            try
            {
                _logger.LogError("🚨 CORRUPTION ALERT: {message}", message);
                
                // Also log to EV3NT collection for persistence
                var eventCollection = _database.GetCollection<BsonDocument>("EV3NT");
                var alertEvent = new BsonDocument
                {
                    { "_id", ObjectId.GenerateNewId() },
                    { "type", "CORRUPTION_ALERT" },
                    { "message", message },
                    { "timestamp", DateTime.UtcNow },
                    { "checksPerformed", _checksPerformed },
                    { "alertsTriggered", _alertsTriggered },
                    { "correctionsMade", _correctionsMade }
                };
                
                await eventCollection.InsertOneAsync(alertEvent);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to send alert");
            }
        }
        
        /// <summary>
        /// Get current monitoring statistics
        /// </summary>
        public MonitoringStats GetStats()
        {
            return new MonitoringStats
            {
                ChecksPerformed = _checksPerformed,
                AlertsTriggered = _alertsTriggered,
                CorrectionsMade = _correctionsMade,
                LastAlertTime = _lastAlert,
                IsHealthy = DateTime.Now - _lastAlert > _alertCooldown
            };
        }
        
        /// <summary>
        /// Graceful shutdown
        /// </summary>
        public void Dispose()
        {
            _monitoringTimer?.Dispose();
            _logger.LogInformation("MongoDB corruption prevention service stopped");
        }
    }
    
    // Supporting classes
    public class CorruptionIssue
    {
        public string Collection { get; set; } = "";
        public string DocumentId { get; set; } = "";
        public string IssueType { get; set; } = "";
        public string Description { get; set; } = "";
        public Severity Severity { get; set; }
        public DateTime DetectedAt { get; set; } = DateTime.UtcNow;
    }
    
    public enum Severity
    {
        Low,
        Medium,
        High,
        Critical
    }
    
    public class MonitoringStats
    {
        public int ChecksPerformed { get; set; }
        public int AlertsTriggered { get; set; }
        public int CorrectionsMade { get; set; }
        public DateTime LastAlertTime { get; set; }
        public bool IsHealthy { get; set; }
    }
}