using System;
using System.Diagnostics;

// INTEGRATION INSTRUCTIONS FOR HUN7ER.exe
// =====================================

namespace HUN7ER
{
    public class Program 
    {
        // Add this field to your main class
        private static List<GameData> recentEntries = new List<GameData>();
        private static DateTime lastHealthCheck = DateTime.MinValue;

        public static void Main(string[] args)
        {
            Console.WriteLine("🚀 HUN7ER.exe starting with embedded sanity checking...");
            
            // Your existing initialization code here
            InitializeH0UND();
            InitializeHUN7ER();
            
            // Main processing loop
            while (true)
            {
                try
                {
                    // Your existing data collection logic
                    var gameData = CollectGameData(); // Your method
                    
                    // REPLACE your direct processing with this protected version:
                    ProcessGameDataSafely(gameData);
                    
                    System.Threading.Thread.Sleep(1000); // Your polling interval
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Main loop error: {ex.Message}");
                }
            }
        }

        // STEP 1: Replace your existing data processing method with this
        private static void ProcessGameDataSafely(YourExistingGameDataClass gameData)
        {
            // Extract values from your existing data structure
            string prizeType = gameData.PrizeType;    // e.g., "MINOR", "MAJOR", "GRAND"
            double currentValue = gameData.CurrentValue;
            double threshold = gameData.Threshold;
            double dailyRate = gameData.DailyRate;
            string location = gameData.Location;
            string platform = gameData.Platform;     // e.g., "FireKirin", "OrionStar"

            // EMBEDDED SANITY CHECK - this is the key addition
            var validatedData = EmbeddedSanityChecker.ValidateAndRepair(
                prizeType, currentValue, threshold, dailyRate, location);
            
            if (validatedData == null)
            {
                Console.WriteLine($"❌ Data corruption detected for {location} - entry discarded");
                return; // Skip this corrupted entry
            }

            // If data was repaired, log what changed
            if (Math.Abs(validatedData.CurrentValue - currentValue) > 0.01 ||
                Math.Abs(validatedData.Threshold - threshold) > 0.01)
            {
                Console.WriteLine($"🔧 Repaired data for {location}: " +
                    $"{currentValue:F2}->{validatedData.CurrentValue:F2}, " +
                    $"threshold {threshold:F2}->{validatedData.Threshold:F2}");
            }

            // Continue with your normal processing using the validated data
            ProcessValidGameEntry(validatedData, platform);

            // STEP 2: Add health monitoring
            TrackEntryForHealthMonitoring(validatedData);
        }

        // STEP 3: Add this method to track entries and perform health checks
        private static void TrackEntryForHealthMonitoring(GameData validatedData)
        {
            recentEntries.Add(validatedData);
            
            // Keep only last 50 entries to avoid memory issues
            if (recentEntries.Count > 50)
            {
                recentEntries.RemoveAt(0);
            }

            // Perform health check every 5 minutes
            if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5)
            {
                EmbeddedSanityChecker.PerformHealthCheck(recentEntries);
                lastHealthCheck = DateTime.Now;
                
                // Display health status in console
                Console.WriteLine($"💊 System Health: {EmbeddedSanityChecker.GetHealthStatus()}");
            }
        }

        // Your existing game processing logic - now guaranteed to receive valid data
        private static void ProcessValidGameEntry(GameData data, string platform)
        {
            // YOUR EXISTING BUSINESS LOGIC GOES HERE UNCHANGED
            // The data is now guaranteed to be sane and within acceptable ranges
            
            // Example of what your existing code might look like:
            UpdateDatabase(data.PrizeType, data.CurrentValue, data.Threshold, data.Location);
            
            // Check for payout trigger
            if (data.CurrentValue >= data.Threshold)
            {
                TriggerPayout(data.PrizeType, data.CurrentValue, data.Location, platform);
            }
            
            // Update display/UI
            UpdateDisplay(data);
            
            // Log to your existing log file (now with clean data)
            LogToFile($"{data.PrizeType} | {DateTime.Now} | {platform} | " +
                     $"{data.DailyRate:F2} /day | {data.CurrentValue:F2} /{data.Threshold:F0} | (0) {data.Location}");
        }

        // STEP 4: If you're reading from log files, use this parser
        private static void ProcessExistingLogFile(string logFilePath)
        {
            Console.WriteLine($"🧹 Processing existing log file with sanity checking: {logFilePath}");
            
            var lines = File.ReadAllLines(logFilePath);
            var cleanedLines = new List<string>();
            int repaired = 0, discarded = 0;

            foreach (var line in lines)
            {
                try
                {
                    // Parse the line using your existing format
                    var parts = line.Split('|');
                    if (parts.Length < 6) continue;

                    var prizeType = parts[0].Trim();
                    var platform = parts[2].Trim();
                    var dailyRate = double.Parse(parts[3].Replace("/day", "").Trim());
                    
                    var valueThreshold = parts[4].Trim().Split('/');
                    var currentValue = double.Parse(valueThreshold[0].Trim());
                    var threshold = double.Parse(valueThreshold[1].Trim());
                    
                    var location = parts[5].Split(')').LastOrDefault()?.Trim() ?? "Unknown";

                    // Validate and repair
                    var validatedData = EmbeddedSanityChecker.ValidateAndRepair(
                        prizeType, currentValue, threshold, dailyRate, location);

                    if (validatedData != null)
                    {
                        // Reconstruct the line with cleaned data
                        var cleanedLine = $"{validatedData.PrizeType} | {parts[1]} | {platform} | " +
                            $"{validatedData.DailyRate:F2} /day | {validatedData.CurrentValue:F2} /{validatedData.Threshold:F0} | {parts[5]}";
                        cleanedLines.Add(cleanedLine);
                        
                        if (Math.Abs(validatedData.CurrentValue - currentValue) > 0.01)
                            repaired++;
                    }
                    else
                    {
                        discarded++;
                        Console.WriteLine($"   Discarded: {line.Substring(0, Math.Min(60, line.Length))}...");
                    }
                }
                catch
                {
                    discarded++;
                }
            }

            // Write cleaned log file
            File.WriteAllLines(logFilePath + ".cleaned", cleanedLines);
            Console.WriteLine($"✅ Log cleanup complete: {cleanedLines.Count} clean, {repaired} repaired, {discarded} discarded");
        }

        // Your existing methods (unchanged)
        private static void InitializeH0UND() { /* Your code */ }
        private static void InitializeHUN7ER() { /* Your code */ }
        private static YourExistingGameDataClass CollectGameData() { /* Your code */ return null; }
        private static void UpdateDatabase(string prizeType, double value, double threshold, string location) { /* Your code */ }
        private static void TriggerPayout(string prizeType, double value, string location, string platform) { /* Your code */ }
        private static void UpdateDisplay(GameData data) { /* Your code */ }
        private static void LogToFile(string logEntry) { /* Your code */ }
    }

    // If you don't have a GameData class, use this one
    public class YourExistingGameDataClass
    {
        public string PrizeType { get; set; }
        public double CurrentValue { get; set; }
        public double Threshold { get; set; }
        public double DailyRate { get; set; }
        public string Location { get; set; }
        public string Platform { get; set; }
    }
}

/*
SUMMARY OF CHANGES TO MAKE:

1. Add the EmbeddedSanityChecker.cs file to your project
2. Replace your data processing method with ProcessGameDataSafely()
3. Add health monitoring with TrackEntryForHealthMonitoring()
4. Your existing business logic remains unchanged - it just gets clean data

WHAT THIS FIXES:

✅ 167475.54 /1785 -> Automatically detects decimal errors and fixes to 1674.75
✅ 10664.54 /117 (MINOR) -> Either fixes decimal or reclassifies as MAJOR  
✅ Invalid thresholds -> Clamps to reasonable values
✅ Corrupted entries -> Discards them safely
✅ Rate anomalies -> Clamps to acceptable range
✅ Real-time monitoring -> Shows health status every 5 minutes
✅ Self-repair logging -> Shows what was fixed and why

ZERO EXTERNAL DEPENDENCIES - Everything embedded in your exe!
*/