using System;
using System.Collections.Generic;
using System.Linq;

namespace HUN7ER.SanityCheck
{
    public class GameDataSanityChecker
    {
        // Define expected ranges for different prize tiers
        private static readonly Dictionary<string, (double minValue, double maxValue, double maxThreshold)> PrizeTierLimits = new()
        {
            { "MINOR", (0.01, 200.0, 150.0) },    // Minor prizes: $0.01 - $200, threshold max 150
            { "MAJOR", (50.0, 1000.0, 600.0) },   // Major prizes: $50 - $1000, threshold max 600
            { "GRAND", (500.0, 5000.0, 2000.0) }  // Grand prizes: $500 - $5000, threshold max 2000
        };

        // Maximum reasonable daily rates
        private const double MAX_DAILY_RATE = 50.0;
        private const double MIN_DAILY_RATE = 0.01;

        public class GameEntry
        {
            public string PrizeType { get; set; }
            public DateTime Timestamp { get; set; }
            public string Platform { get; set; }
            public double DailyRate { get; set; }
            public double CurrentValue { get; set; }
            public double Threshold { get; set; }
            public string Location { get; set; }
            public bool IsValid { get; set; } = true;
            public List<string> ValidationErrors { get; set; } = new();
        }

        public static GameEntry ParseAndValidateEntry(string logLine)
        {
            try
            {
                var entry = ParseLogLine(logLine);
                if (entry != null)
                {
                    ValidateEntry(entry);
                }
                return entry;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error parsing log line: {ex.Message}");
                return null;
            }
        }

        private static GameEntry ParseLogLine(string line)
        {
            if (string.IsNullOrWhiteSpace(line)) return null;

            var parts = line.Split('|', StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length < 6) return null;

            try
            {
                var entry = new GameEntry
                {
                    PrizeType = parts[0].Trim(),
                    Timestamp = DateTime.Parse(parts[1].Trim()),
                    Platform = parts[2].Trim(),
                    Location = parts.Length > 6 ? parts[6].Trim() : "Unknown"
                };

                // Parse daily rate (e.g., "3.12 /day")
                var rateStr = parts[3].Trim().Replace("/day", "").Trim();
                if (double.TryParse(rateStr, out double rate))
                    entry.DailyRate = rate;

                // Parse current value and threshold (e.g., "564.16 /565")
                var valueThresholdStr = parts[4].Trim();
                var valueParts = valueThresholdStr.Split('/', StringSplitOptions.RemoveEmptyEntries);
                if (valueParts.Length >= 2)
                {
                    if (double.TryParse(valueParts[0].Trim(), out double currentVal))
                        entry.CurrentValue = currentVal;
                    if (double.TryParse(valueParts[1].Trim(), out double threshold))
                        entry.Threshold = threshold;
                }

                return entry;
            }
            catch
            {
                return null;
            }
        }

        private static void ValidateEntry(GameEntry entry)
        {
            // Validate prize tier limits
            if (PrizeTierLimits.ContainsKey(entry.PrizeType))
            {
                var limits = PrizeTierLimits[entry.PrizeType];
                
                // Check if current value exceeds maximum for this tier
                if (entry.CurrentValue > limits.maxValue)
                {
                    entry.IsValid = false;
                    entry.ValidationErrors.Add($"Current value {entry.CurrentValue:F2} exceeds maximum for {entry.PrizeType} tier ({limits.maxValue:F2})");
                }

                // Check if threshold is reasonable for this tier
                if (entry.Threshold > limits.maxThreshold)
                {
                    entry.IsValid = false;
                    entry.ValidationErrors.Add($"Threshold {entry.Threshold:F2} exceeds maximum for {entry.PrizeType} tier ({limits.maxThreshold:F2})");
                }

                // Check if current value is below minimum
                if (entry.CurrentValue < limits.minValue && entry.CurrentValue > 0)
                {
                    entry.IsValid = false;
                    entry.ValidationErrors.Add($"Current value {entry.CurrentValue:F2} below minimum for {entry.PrizeType} tier ({limits.minValue:F2})");
                }
            }

            // Validate daily rate
            if (entry.DailyRate > MAX_DAILY_RATE || entry.DailyRate < MIN_DAILY_RATE)
            {
                entry.IsValid = false;
                entry.ValidationErrors.Add($"Daily rate {entry.DailyRate:F2} outside acceptable range ({MIN_DAILY_RATE}-{MAX_DAILY_RATE})");
            }

            // Check if current value exceeds threshold (shouldn't happen in normal operation)
            if (entry.CurrentValue > entry.Threshold)
            {
                entry.IsValid = false;
                entry.ValidationErrors.Add($"Current value {entry.CurrentValue:F2} exceeds threshold {entry.Threshold:F2}");
            }

            // Validate timestamp (shouldn't be in the future)
            if (entry.Timestamp > DateTime.Now.AddMinutes(5)) // 5 minute tolerance for clock drift
            {
                entry.IsValid = false;
                entry.ValidationErrors.Add($"Timestamp {entry.Timestamp} is in the future");
            }
        }

        public static List<GameEntry> SanitizeAndRepairEntries(List<string> logLines)
        {
            var validEntries = new List<GameEntry>();
            var repairedCount = 0;
            var discardedCount = 0;

            foreach (var line in logLines)
            {
                var entry = ParseAndValidateEntry(line);
                if (entry == null) continue;

                if (!entry.IsValid)
                {
                    Console.WriteLine($"Invalid entry detected: {string.Join(", ", entry.ValidationErrors)}");
                    
                    // Attempt repairs for specific issues
                    var repaired = AttemptRepair(entry);
                    if (repaired.IsValid)
                    {
                        validEntries.Add(repaired);
                        repairedCount++;
                        Console.WriteLine($"Successfully repaired entry for {repaired.Location}");
                    }
                    else
                    {
                        discardedCount++;
                        Console.WriteLine($"Could not repair entry for {entry.Location}, discarding");
                    }
                }
                else
                {
                    validEntries.Add(entry);
                }
            }

            Console.WriteLine($"Sanity check complete: {validEntries.Count} valid, {repairedCount} repaired, {discardedCount} discarded");
            return validEntries;
        }

        private static GameEntry AttemptRepair(GameEntry entry)
        {
            var repaired = new GameEntry
            {
                PrizeType = entry.PrizeType,
                Timestamp = entry.Timestamp,
                Platform = entry.Platform,
                Location = entry.Location,
                DailyRate = entry.DailyRate,
                CurrentValue = entry.CurrentValue,
                Threshold = entry.Threshold,
                ValidationErrors = new List<string>()
            };

            // Repair strategy 1: Check for decimal point errors (e.g., 167475.54 should be 1674.7554)
            if (PrizeTierLimits.ContainsKey(entry.PrizeType))
            {
                var limits = PrizeTierLimits[entry.PrizeType];
                
                // If value is way too high, try dividing by 100 (decimal point shift)
                if (entry.CurrentValue > limits.maxValue * 10)
                {
                    repaired.CurrentValue = entry.CurrentValue / 100.0;
                    Console.WriteLine($"Attempted decimal repair: {entry.CurrentValue:F2} -> {repaired.CurrentValue:F2}");
                }

                // If threshold is too high, try using the standard threshold for this tier
                if (entry.Threshold > limits.maxThreshold)
                {
                    repaired.Threshold = limits.maxThreshold * 0.8; // Use 80% of max as reasonable default
                    Console.WriteLine($"Attempted threshold repair: {entry.Threshold:F2} -> {repaired.Threshold:F2}");
                }
            }

            // Repair strategy 2: Clamp daily rate to acceptable range
            if (entry.DailyRate > MAX_DAILY_RATE)
            {
                repaired.DailyRate = MAX_DAILY_RATE;
            }
            else if (entry.DailyRate < MIN_DAILY_RATE && entry.DailyRate > 0)
            {
                repaired.DailyRate = MIN_DAILY_RATE;
            }

            // Re-validate the repaired entry
            ValidateEntry(repaired);
            return repaired;
        }

        public static void GenerateHealthReport(List<GameEntry> entries)
        {
            Console.WriteLine("\n=== HEALTH REPORT ===");
            Console.WriteLine($"Total Entries: {entries.Count}");
            
            var byTier = entries.GroupBy(e => e.PrizeType);
            foreach (var tier in byTier)
            {
                var avg = tier.Average(e => e.CurrentValue);
                var max = tier.Max(e => e.CurrentValue);
                var min = tier.Min(e => e.CurrentValue);
                Console.WriteLine($"{tier.Key}: Count={tier.Count()}, Avg={avg:F2}, Min={min:F2}, Max={max:F2}");
            }

            var recentEntries = entries.Where(e => e.Timestamp > DateTime.Now.AddHours(-24)).ToList();
            Console.WriteLine($"\nLast 24 hours: {recentEntries.Count} entries");
            
            Console.WriteLine("===================\n");
        }
    }
}