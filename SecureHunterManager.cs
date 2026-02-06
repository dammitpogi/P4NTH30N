using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using HUN7ER.SanityCheck;
using HUN7ER.SelfMonitoring;

namespace HUN7ER.Integration
{
    /// <summary>
    /// Integration wrapper for HUN7ER.exe with sanity checking and self-monitoring
    /// </summary>
    public class SecureHunterManager
    {
        private HunterWatchdog _watchdog;
        private readonly string _logPath;
        private readonly object _processLock = new object();

        public SecureHunterManager(string logPath)
        {
            _logPath = logPath;
            InitializeMonitoring();
        }

        private void InitializeMonitoring()
        {
            try
            {
                _watchdog = new HunterWatchdog(_logPath);
                Console.WriteLine("✅ Secure monitoring initialized for HUN7ER.exe");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Failed to initialize monitoring: {ex.Message}");
                throw;
            }
        }

        /// <summary>
        /// Process and validate incoming HUN7ER log entries in real-time
        /// </summary>
        public void ProcessLogEntry(string logLine)
        {
            lock (_processLock)
            {
                try
                {
                    var entry = GameDataSanityChecker.ParseAndValidateEntry(logLine);
                    
                    if (entry == null)
                    {
                        LogIssue("PARSE_ERROR", $"Could not parse log line: {logLine}");
                        return;
                    }

                    if (!entry.IsValid)
                    {
                        LogIssue("VALIDATION_FAILED", 
                            $"Entry validation failed: {string.Join(", ", entry.ValidationErrors)}");
                        
                        // Try to repair the entry
                        var repairedEntry = AttemptRepair(entry);
                        if (repairedEntry != null && repairedEntry.IsValid)
                        {
                            LogIssue("REPAIR_SUCCESS", 
                                $"Successfully repaired entry for {repairedEntry.Location}");
                            ProcessValidEntry(repairedEntry);
                        }
                        else
                        {
                            LogIssue("REPAIR_FAILED", 
                                $"Could not repair entry for {entry.Location} - DISCARDING");
                            // Optionally halt processing if too many failures
                            CheckFailureThreshold();
                        }
                    }
                    else
                    {
                        ProcessValidEntry(entry);
                    }
                }
                catch (Exception ex)
                {
                    LogIssue("PROCESSING_ERROR", $"Error processing log entry: {ex.Message}");
                }
            }
        }

        private GameDataSanityChecker.GameEntry AttemptRepair(GameDataSanityChecker.GameEntry entry)
        {
            // Use the repair logic from GameDataSanityChecker
            Console.WriteLine($"🔧 Attempting to repair entry: {entry.Location}");
            
            // For the specific issues you're seeing:
            if (entry.PrizeType == "GRAND" && entry.CurrentValue > 50000)
            {
                // Likely decimal point error - divide by 100
                entry.CurrentValue = entry.CurrentValue / 100.0;
                Console.WriteLine($"   Applied decimal correction: {entry.CurrentValue:F2}");
            }
            
            if (entry.PrizeType == "MINOR" && entry.CurrentValue > 500)
            {
                // Possible tier misclassification or decimal error
                if (entry.CurrentValue < 1000)
                {
                    entry.PrizeType = "MAJOR"; // Reclassify
                    Console.WriteLine($"   Reclassified to MAJOR tier");
                }
                else
                {
                    entry.CurrentValue = entry.CurrentValue / 100.0; // Decimal correction
                    Console.WriteLine($"   Applied decimal correction: {entry.CurrentValue:F2}");
                }
            }

            // Re-validate after repair
            GameDataSanityChecker.ParseAndValidateEntry(entry.ToString());
            return entry;
        }

        private void ProcessValidEntry(GameDataSanityChecker.GameEntry entry)
        {
            // Log successful processing
            Console.WriteLine($"✅ Processed: {entry.PrizeType} | {entry.CurrentValue:F2}/{entry.Threshold:F2} | {entry.Location}");
            
            // Check for approaching thresholds
            var threshold_ratio = entry.CurrentValue / entry.Threshold;
            if (threshold_ratio > 0.95)
            {
                Console.WriteLine($"⚠️  THRESHOLD WARNING: {entry.Location} at {threshold_ratio:P1} of threshold");
            }
            
            // You can add your business logic here
            // For example: trigger payouts, update databases, etc.
        }

        private int _consecutiveFailures = 0;
        private const int MAX_CONSECUTIVE_FAILURES = 5;

        private void CheckFailureThreshold()
        {
            _consecutiveFailures++;
            
            if (_consecutiveFailures >= MAX_CONSECUTIVE_FAILURES)
            {
                Console.WriteLine($"🚨 CRITICAL: {_consecutiveFailures} consecutive failures detected!");
                Console.WriteLine("   Recommend halting HUN7ER.exe for investigation.");
                
                // Optionally implement auto-shutdown logic here
                // System.Diagnostics.Process.GetProcessesByName("HUN7ER").FirstOrDefault()?.Kill();
            }
        }

        private void LogIssue(string issueType, string message)
        {
            var timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            var logLine = $"[{timestamp}] {issueType}: {message}";
            
            Console.WriteLine(logLine);
            
            // Write to separate issues log
            try
            {
                var issuesLogPath = Path.Combine(Path.GetDirectoryName(_logPath), "hunter_issues.log");
                File.AppendAllText(issuesLogPath, logLine + Environment.NewLine);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to write to issues log: {ex.Message}");
            }
        }

        /// <summary>
        /// Batch process existing log file for cleanup and analysis
        /// </summary>
        public async Task BatchCleanupLogFile()
        {
            if (!File.Exists(_logPath))
            {
                Console.WriteLine($"Log file not found: {_logPath}");
                return;
            }

            Console.WriteLine("🧹 Starting batch cleanup of HUN7ER log file...");
            
            var lines = await File.ReadAllLinesAsync(_logPath);
            var cleanedLines = new List<string>();
            var repairedCount = 0;
            var discardedCount = 0;

            foreach (var line in lines)
            {
                try
                {
                    var entry = GameDataSanityChecker.ParseAndValidateEntry(line);
                    if (entry != null && entry.IsValid)
                    {
                        cleanedLines.Add(line);
                    }
                    else if (entry != null)
                    {
                        var repaired = AttemptRepair(entry);
                        if (repaired != null && repaired.IsValid)
                        {
                            cleanedLines.Add(FormatLogEntry(repaired));
                            repairedCount++;
                        }
                        else
                        {
                            discardedCount++;
                            Console.WriteLine($"   Discarded: {line.Substring(0, Math.Min(50, line.Length))}...");
                        }
                    }
                }
                catch
                {
                    discardedCount++;
                }
            }

            // Backup original and write cleaned version
            var backupPath = $"{_logPath}.backup_{DateTime.Now:yyyyMMdd_HHmmss}";
            File.Copy(_logPath, backupPath);
            
            await File.WriteAllLinesAsync(_logPath, cleanedLines);
            
            Console.WriteLine($"✅ Batch cleanup complete:");
            Console.WriteLine($"   Original entries: {lines.Length}");
            Console.WriteLine($"   Cleaned entries: {cleanedLines.Count}");
            Console.WriteLine($"   Repaired: {repairedCount}");
            Console.WriteLine($"   Discarded: {discardedCount}");
            Console.WriteLine($"   Backup saved: {backupPath}");
        }

        private string FormatLogEntry(GameDataSanityChecker.GameEntry entry)
        {
            return $"{entry.PrizeType} | {entry.Timestamp:ddd MM/dd/yyyy HH:mm:ss} | {entry.Platform} | {entry.DailyRate:F2} /day | {entry.CurrentValue:F2} /{entry.Threshold:F0} | (0) {entry.Location}";
        }

        public void Dispose()
        {
            _watchdog?.Stop();
            Console.WriteLine("🔒 SecureHunterManager disposed");
        }
    }

    // Example usage
    public class ExampleUsage
    {
        public static async Task Main(string[] args)
        {
            var logPath = @"C:\HUN7ER\logs\hunter.log";
            
            using (var manager = new SecureHunterManager(logPath))
            {
                Console.WriteLine("🚀 Starting secure HUN7ER monitoring...");
                
                // Clean up existing log file
                await manager.BatchCleanupLogFile();
                
                // Example: Process individual log entries
                var testEntries = new[]
                {
                    "GRAND | MON 02/02/2026 08:12:46 | OrionStar | 0.10 /day |167475.54 /1785| (0) Golden Cove Lounge",
                    "MINOR | MON 02/02/2026 08:12:46 | OrionStar | 0.10 /day |10664.54 /117 | (0) Test Location"
                };

                foreach (var entry in testEntries)
                {
                    manager.ProcessLogEntry(entry);
                }
                
                Console.WriteLine("Monitoring active. Press any key to stop...");
                Console.ReadKey();
            }
        }
    }
}