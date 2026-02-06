using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;

namespace HUN7ER.SelfMonitoring
{
    public class HunterWatchdog
    {
        private readonly string _logFilePath;
        private readonly Timer _monitorTimer;
        private readonly object _lockObject = new object();
        private DateTime _lastHealthCheck = DateTime.MinValue;
        private int _consecutiveErrors = 0;
        private const int MAX_CONSECUTIVE_ERRORS = 3;

        // Alert thresholds
        private readonly Dictionary<string, double> _alertThresholds = new()
        {
            { "MINOR_MAX", 200.0 },
            { "MAJOR_MAX", 1000.0 },
            { "GRAND_MAX", 5000.0 },
            { "DAILY_RATE_MAX", 50.0 }
        };

        public HunterWatchdog(string logFilePath)
        {
            _logFilePath = logFilePath;
            _monitorTimer = new Timer(PerformHealthCheck, null, TimeSpan.Zero, TimeSpan.FromMinutes(5));
            
            Console.WriteLine($"HunterWatchdog initialized, monitoring: {logFilePath}");
            WriteToLog("WATCHDOG", "Service started");
        }

        private void PerformHealthCheck(object state)
        {
            lock (_lockObject)
            {
                try
                {
                    if (!File.Exists(_logFilePath))
                    {
                        HandleError("Log file not found");
                        return;
                    }

                    var recentLines = GetRecentLogLines(50); // Check last 50 entries
                    if (recentLines.Count == 0)
                    {
                        HandleError("No recent log entries found");
                        return;
                    }

                    var entries = HUN7ER.SanityCheck.GameDataSanityChecker.SanitizeAndRepairEntries(recentLines);
                    var anomalies = DetectAnomalies(entries);

                    if (anomalies.Count > 0)
                    {
                        HandleAnomalies(anomalies);
                    }
                    else
                    {
                        _consecutiveErrors = 0; // Reset error counter on successful check
                        WriteToLog("WATCHDOG", $"Health check passed - {entries.Count} entries validated");
                    }

                    _lastHealthCheck = DateTime.Now;
                }
                catch (Exception ex)
                {
                    HandleError($"Health check failed: {ex.Message}");
                }
            }
        }

        private List<string> GetRecentLogLines(int count)
        {
            try
            {
                var lines = File.ReadAllLines(_logFilePath);
                return lines.Skip(Math.Max(0, lines.Length - count)).ToList();
            }
            catch
            {
                return new List<string>();
            }
        }

        private List<AnomalyReport> DetectAnomalies(List<HUN7ER.SanityCheck.GameDataSanityChecker.GameEntry> entries)
        {
            var anomalies = new List<AnomalyReport>();

            foreach (var entry in entries)
            {
                // Check for value anomalies
                if (entry.PrizeType == "GRAND" && entry.CurrentValue > _alertThresholds["GRAND_MAX"])
                {
                    anomalies.Add(new AnomalyReport
                    {
                        Type = "VALUE_OVERFLOW",
                        Severity = "HIGH",
                        Message = $"GRAND prize value {entry.CurrentValue:F2} exceeds threshold {_alertThresholds["GRAND_MAX"]}",
                        Entry = entry,
                        Timestamp = DateTime.Now
                    });
                }

                if (entry.PrizeType == "MINOR" && entry.CurrentValue > _alertThresholds["MINOR_MAX"])
                {
                    anomalies.Add(new AnomalyReport
                    {
                        Type = "TIER_MISMATCH",
                        Severity = "HIGH",
                        Message = $"MINOR prize showing {entry.CurrentValue:F2} - possible tier classification error",
                        Entry = entry,
                        Timestamp = DateTime.Now
                    });
                }

                // Check for rate anomalies
                if (entry.DailyRate > _alertThresholds["DAILY_RATE_MAX"])
                {
                    anomalies.Add(new AnomalyReport
                    {
                        Type = "RATE_ANOMALY",
                        Severity = "MEDIUM",
                        Message = $"Daily rate {entry.DailyRate:F2} exceeds normal range",
                        Entry = entry,
                        Timestamp = DateTime.Now
                    });
                }

                // Check for threshold breaches
                if (entry.CurrentValue > entry.Threshold)
                {
                    anomalies.Add(new AnomalyReport
                    {
                        Type = "THRESHOLD_BREACH",
                        Severity = "HIGH",
                        Message = $"Current value {entry.CurrentValue:F2} exceeds threshold {entry.Threshold:F2}",
                        Entry = entry,
                        Timestamp = DateTime.Now
                    });
                }
            }

            // Detect patterns - sudden spikes in values
            var recentValues = entries.Where(e => e.Timestamp > DateTime.Now.AddHours(-1))
                                    .OrderBy(e => e.Timestamp)
                                    .ToList();

            if (recentValues.Count >= 3)
            {
                for (int i = 1; i < recentValues.Count; i++)
                {
                    var prev = recentValues[i - 1];
                    var curr = recentValues[i];
                    
                    if (prev.PrizeType == curr.PrizeType && curr.CurrentValue > prev.CurrentValue * 5)
                    {
                        anomalies.Add(new AnomalyReport
                        {
                            Type = "SUDDEN_SPIKE",
                            Severity = "MEDIUM",
                            Message = $"Value spiked from {prev.CurrentValue:F2} to {curr.CurrentValue:F2} in {curr.PrizeType}",
                            Entry = curr,
                            Timestamp = DateTime.Now
                        });
                    }
                }
            }

            return anomalies;
        }

        private void HandleAnomalies(List<AnomalyReport> anomalies)
        {
            var highSeverityCount = anomalies.Count(a => a.Severity == "HIGH");
            
            WriteToLog("ALERT", $"{anomalies.Count} anomalies detected ({highSeverityCount} high severity)");

            foreach (var anomaly in anomalies.OrderBy(a => a.Severity == "HIGH" ? 0 : 1))
            {
                WriteToLog("ANOMALY", $"{anomaly.Severity}: {anomaly.Message}");
                Console.WriteLine($"🚨 [{anomaly.Type}] {anomaly.Message}");

                // Auto-remediation for specific anomaly types
                if (anomaly.Type == "VALUE_OVERFLOW" && anomaly.Severity == "HIGH")
                {
                    SuggestRemediation(anomaly);
                }
            }

            // If too many high-severity anomalies, suggest system pause
            if (highSeverityCount >= 3)
            {
                WriteToLog("CRITICAL", "Multiple high-severity anomalies detected - recommend system review");
                Console.WriteLine("⚠️ CRITICAL: Multiple anomalies detected. Consider pausing HUN7ER operations for review.");
            }
        }

        private void SuggestRemediation(AnomalyReport anomaly)
        {
            switch (anomaly.Type)
            {
                case "VALUE_OVERFLOW":
                    WriteToLog("REMEDY", $"Suggested: Check decimal placement - {anomaly.Entry.CurrentValue} may need /100 correction");
                    break;
                case "TIER_MISMATCH":
                    WriteToLog("REMEDY", $"Suggested: Verify prize tier classification for {anomaly.Entry.Location}");
                    break;
                case "THRESHOLD_BREACH":
                    WriteToLog("REMEDY", $"Suggested: Reset threshold or investigate payout trigger for {anomaly.Entry.Location}");
                    break;
            }
        }

        private void HandleError(string error)
        {
            _consecutiveErrors++;
            WriteToLog("ERROR", $"Health check error ({_consecutiveErrors}/{MAX_CONSECUTIVE_ERRORS}): {error}");

            if (_consecutiveErrors >= MAX_CONSECUTIVE_ERRORS)
            {
                WriteToLog("CRITICAL", "Maximum consecutive errors reached - watchdog entering safe mode");
                Console.WriteLine("🔴 CRITICAL: Watchdog detected persistent issues. Manual intervention required.");
            }
        }

        private void WriteToLog(string level, string message)
        {
            try
            {
                var timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                var logLine = $"[{timestamp}] WATCHDOG-{level}: {message}";
                
                File.AppendAllText($"{Path.GetDirectoryName(_logFilePath)}\\watchdog.log", logLine + Environment.NewLine);
                
                if (level == "CRITICAL" || level == "ALERT")
                {
                    Console.WriteLine(logLine);
                }
            }
            catch
            {
                // Fallback to console if file writing fails
                Console.WriteLine($"WATCHDOG-{level}: {message}");
            }
        }

        public void Stop()
        {
            _monitorTimer?.Dispose();
            WriteToLog("WATCHDOG", "Service stopped");
        }
    }

    public class AnomalyReport
    {
        public string Type { get; set; }
        public string Severity { get; set; }
        public string Message { get; set; }
        public HUN7ER.SanityCheck.GameDataSanityChecker.GameEntry Entry { get; set; }
        public DateTime Timestamp { get; set; }
    }

    // Usage example
    public class Program
    {
        public static void Main(string[] args)
        {
            var logPath = args.Length > 0 ? args[0] : @"C:\HUN7ER\logs\hunter.log";
            
            using (var watchdog = new HunterWatchdog(logPath))
            {
                Console.WriteLine("HunterWatchdog running. Press 'q' to quit.");
                
                while (true)
                {
                    var key = Console.ReadKey(true);
                    if (key.KeyChar == 'q' || key.KeyChar == 'Q')
                        break;
                }
            }
        }
    }
}