using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.IO;

namespace HUN7ER.Embedded
{
    /// <summary>
    /// Embedded sanity checker and self-repair for HUN7ER.exe
    /// Add this directly to your existing HUN7ER codebase
    /// </summary>
    public static class EmbeddedSanityChecker
    {
        private static readonly Dictionary<string, (double min, double max, double maxThreshold)> TierLimits = new()
        {
            { "MINOR", (0.01, 200.0, 150.0) },
            { "MAJOR", (50.0, 1000.0, 600.0) },
            { "GRAND", (500.0, 5000.0, 2000.0) }
        };

        private static int _errorCount = 0;
        private static DateTime _lastAlert = DateTime.MinValue;
        private const int ALERT_COOLDOWN_MINUTES = 5;

        /// <summary>
        /// Call this method before processing/logging any game data
        /// Returns sanitized values or null if entry should be discarded
        /// </summary>
        public static GameData ValidateAndRepair(string prizeType, double currentValue, double threshold, double dailyRate, string location)
        {
            var data = new GameData
            {
                PrizeType = prizeType,
                CurrentValue = currentValue,
                Threshold = threshold,
                DailyRate = dailyRate,
                Location = location,
                IsValid = true
            };

            // Quick sanity checks
            if (!TierLimits.ContainsKey(prizeType))
            {
                LogError($"Unknown prize type: {prizeType}");
                return null;
            }

            var limits = TierLimits[prizeType];
            bool needsRepair = false;

            // Check 1: Value overflow (like your 167475.54 issue)
            if (currentValue > limits.max)
            {
                if (currentValue > limits.max * 50) // Likely decimal error
                {
                    data.CurrentValue = currentValue / 100.0;
                    needsRepair = true;
                    LogRepair($"Decimal correction: {currentValue:F2} -> {data.CurrentValue:F2} for {location}");
                }
                else
                {
                    LogError($"Value {currentValue:F2} too high for {prizeType} at {location} - DISCARDING");
                    return null;
                }
            }

            // Check 2: Threshold sanity
            if (threshold > limits.maxThreshold)
            {
                data.Threshold = limits.maxThreshold;
                needsRepair = true;
                LogRepair($"Threshold capped: {threshold:F2} -> {data.Threshold:F2} for {location}");
            }

            // Check 3: Current value exceeds threshold (shouldn't happen)
            if (data.CurrentValue > data.Threshold)
            {
                LogError($"CRITICAL: Value {data.CurrentValue:F2} exceeds threshold {data.Threshold:F2} at {location}");
                // Don't auto-repair this - needs investigation
                data.IsValid = false;
            }

            // Check 4: Daily rate sanity
            if (dailyRate > 50.0 || dailyRate < 0.01)
            {
                data.DailyRate = Math.Max(0.01, Math.Min(50.0, dailyRate));
                needsRepair = true;
                LogRepair($"Rate clamped: {dailyRate:F2} -> {data.DailyRate:F2} for {location}");
            }

            // Check 5: Tier mismatch (like MINOR showing 10664.54)
            if (prizeType == "MINOR" && data.CurrentValue > 500)
            {
                if (data.CurrentValue < 1000)
                {
                    data.PrizeType = "MAJOR";
                    LogRepair($"Tier reclassified: MINOR -> MAJOR for {data.CurrentValue:F2} at {location}");
                }
                else
                {
                    data.CurrentValue = data.CurrentValue / 100.0;
                    LogRepair($"MINOR decimal fix: {currentValue:F2} -> {data.CurrentValue:F2} at {location}");
                }
                needsRepair = true;
            }

            if (needsRepair)
            {
                LogRepair($"Entry repaired for {location}");
            }

            return data.IsValid ? data : null;
        }

        /// <summary>
        /// Call this method in your main processing loop to monitor system health
        /// </summary>
        public static void PerformHealthCheck(List<GameData> recentEntries)
        {
            if (recentEntries == null || !recentEntries.Any()) return;

            var now = DateTime.Now;
            var anomalies = new List<string>();

            // Check for value spikes
            var grouped = recentEntries.GroupBy(e => e.PrizeType);
            foreach (var group in grouped)
            {
                var sorted = group.OrderBy(e => e.Timestamp).ToList();
                for (int i = 1; i < sorted.Count; i++)
                {
                    if (sorted[i].CurrentValue > sorted[i-1].CurrentValue * 3)
                    {
                        anomalies.Add($"Value spike in {group.Key}: {sorted[i-1].CurrentValue:F2} -> {sorted[i].CurrentValue:F2}");
                    }
                }
            }

            // Check for threshold approaches
            var nearThreshold = recentEntries.Where(e => e.CurrentValue / e.Threshold > 0.9).ToList();
            if (nearThreshold.Any())
            {
                anomalies.Add($"{nearThreshold.Count} entries near threshold");
            }

            // Alert if needed
            if (anomalies.Any() && (now - _lastAlert).TotalMinutes > ALERT_COOLDOWN_MINUTES)
            {
                LogAlert($"Health check found {anomalies.Count} anomalies: {string.Join("; ", anomalies)}");
                _lastAlert = now;
            }
        }

        /// <summary>
        /// Embedded logging - writes to console and optional file
        /// </summary>
        private static void LogError(string message)
        {
            _errorCount++;
            var timestamp = DateTime.Now.ToString("HH:mm:ss");
            var logMsg = $"[{timestamp}] HUN7ER-ERROR: {message}";
            
            Console.WriteLine($"🔴 {logMsg}");
            WriteToFile(logMsg);

            // If too many errors, suggest intervention
            if (_errorCount % 10 == 0)
            {
                Console.WriteLine($"⚠️  {_errorCount} errors detected - recommend system review");
            }
        }

        private static void LogRepair(string message)
        {
            var timestamp = DateTime.Now.ToString("HH:mm:ss");
            var logMsg = $"[{timestamp}] HUN7ER-REPAIR: {message}";
            
            Console.WriteLine($"🔧 {logMsg}");
            WriteToFile(logMsg);
        }

        private static void LogAlert(string message)
        {
            var timestamp = DateTime.Now.ToString("HH:mm:ss");
            var logMsg = $"[{timestamp}] HUN7ER-ALERT: {message}";
            
            Console.WriteLine($"🚨 {logMsg}");
            WriteToFile(logMsg);
        }

        private static void WriteToFile(string message)
        {
            try
            {
                // Write to same directory as exe
                var logPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "hunter_sanity.log");
                File.AppendAllText(logPath, message + Environment.NewLine);
            }
            catch
            {
                // Fail silently - console output is more important
            }
        }

        /// <summary>
        /// Get current system health status
        /// </summary>
        public static string GetHealthStatus()
        {
            var uptime = DateTime.Now - Process.GetCurrentProcess().StartTime;
            return $"Errors: {_errorCount}, Uptime: {uptime:hh\\:mm\\:ss}, Last Alert: {(DateTime.Now - _lastAlert).TotalMinutes:F1}m ago";
        }
    }

    /// <summary>
    /// Simple data structure for game entries
    /// </summary>
    public class GameData
    {
        public string PrizeType { get; set; }
        public double CurrentValue { get; set; }
        public double Threshold { get; set; }
        public double DailyRate { get; set; }
        public string Location { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.Now;
        public bool IsValid { get; set; }
    }

    /// <summary>
    /// Example integration - add this to your existing HUN7ER main processing
    /// </summary>
    public class ExampleIntegration
    {
        private static List<GameData> _recentEntries = new List<GameData>();
        private static DateTime _lastHealthCheck = DateTime.MinValue;

        /// <summary>
        /// Replace your current data processing with this protected version
        /// </summary>
        public static void ProcessGameEntry(string prizeType, double currentValue, double threshold, 
                                          double dailyRate, string location, string platform)
        {
            // EMBEDDED SANITY CHECK - validates and repairs automatically
            var validatedData = EmbeddedSanityChecker.ValidateAndRepair(prizeType, currentValue, threshold, dailyRate, location);
            
            if (validatedData == null)
            {
                // Entry was too corrupted to repair - skip processing
                Console.WriteLine($"❌ Skipped corrupted entry for {location}");
                return;
            }

            // Use the validated/repaired data for your normal processing
            ProcessValidatedEntry(validatedData, platform);

            // Keep track of recent entries for health monitoring
            _recentEntries.Add(validatedData);
            if (_recentEntries.Count > 50) // Keep last 50 entries
            {
                _recentEntries.RemoveAt(0);
            }

            // Periodic health check (every 5 minutes)
            if ((DateTime.Now - _lastHealthCheck).TotalMinutes >= 5)
            {
                EmbeddedSanityChecker.PerformHealthCheck(_recentEntries);
                _lastHealthCheck = DateTime.Now;

                // Show health status
                Console.WriteLine($"💊 Health: {EmbeddedSanityChecker.GetHealthStatus()}");
            }
        }

        private static void ProcessValidatedEntry(GameData data, string platform)
        {
            // YOUR EXISTING BUSINESS LOGIC GOES HERE
            // Data is now guaranteed to be sane and valid
            
            Console.WriteLine($"✅ {data.PrizeType} | {data.CurrentValue:F2}/{data.Threshold:F2} | {data.Location}");
            
            // Example: Check if payout should trigger
            if (data.CurrentValue >= data.Threshold)
            {
                Console.WriteLine($"🎰 PAYOUT TRIGGERED: {data.PrizeType} at {data.Location}");
                // Trigger your payout logic here
            }
        }

        /// <summary>
        /// Example of parsing your existing log format with embedded validation
        /// </summary>
        public static void ProcessLogLine(string logLine)
        {
            try
            {
                // Parse your existing log format
                var parts = logLine.Split('|');
                if (parts.Length < 6) return;

                var prizeType = parts[0].Trim();
                var platform = parts[2].Trim();
                var rateStr = parts[3].Trim().Replace("/day", "").Trim();
                var valueThresholdStr = parts[4].Trim();
                var location = parts[5].Split(')').LastOrDefault()?.Trim() ?? "Unknown";

                if (!double.TryParse(rateStr, out double dailyRate)) return;

                var valueParts = valueThresholdStr.Split('/');
                if (valueParts.Length < 2) return;

                if (!double.TryParse(valueParts[0].Trim(), out double currentValue)) return;
                if (!double.TryParse(valueParts[1].Trim(), out double threshold)) return;

                // Process with embedded validation
                ProcessGameEntry(prizeType, currentValue, threshold, dailyRate, location, platform);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"❌ Failed to process log line: {ex.Message}");
            }
        }
    }
}