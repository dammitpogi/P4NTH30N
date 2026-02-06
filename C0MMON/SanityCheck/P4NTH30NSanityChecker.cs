using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;

namespace P4NTH30N.C0MMON.SanityCheck
{
    /// <summary>
    /// Embedded sanity checker and self-repair for P4NTH30N platform
    /// Validates jackpot values, balances, DPD rates, and thresholds for H4ND, H0UND, and HUN7ER
    /// </summary>
    public static class P4NTH30NSanityChecker
    {
        // Prize tier limits based on your platform's actual ranges
        private static readonly Dictionary<string, (double min, double max, double maxThreshold)> TierLimits = new()
        {
            { "Mini", (0.01, 50.0, 40.0) },      // Mini jackpots: $0.01 - $50
            { "Minor", (0.01, 200.0, 150.0) },   // Minor jackpots: $0.01 - $200  
            { "Major", (50.0, 1000.0, 600.0) },  // Major jackpots: $50 - $1000
            { "Grand", (500.0, 10000.0, 2000.0) } // Grand jackpots: $500 - $10,000 (matches your validation)
        };

        // System limits
        private const double MAX_BALANCE = 50000.0; // Maximum reasonable balance
        private const double MIN_BALANCE = 0.0;     // Minimum balance
        private const double MAX_DPD_RATE = 100.0;  // Maximum dollars per day growth
        private const double MIN_DPD_RATE = 0.01;   // Minimum DPD rate

        // Error tracking
        private static int _errorCount = 0;
        private static int _repairCount = 0;
        private static DateTime _lastAlert = DateTime.MinValue;
        private const int ALERT_COOLDOWN_MINUTES = 5;

        /// <summary>
        /// Validates and repairs jackpot value before processing
        /// </summary>
        public static JackpotValidationResult ValidateJackpot(string tier, double currentValue, double threshold)
        {
            var result = new JackpotValidationResult
            {
                OriginalValue = currentValue,
                OriginalThreshold = threshold,
                ValidatedValue = currentValue,
                ValidatedThreshold = threshold,
                Tier = tier,
                IsValid = true
            };

            if (!TierLimits.ContainsKey(tier))
            {
                result.IsValid = false;
                result.Errors.Add($"Unknown jackpot tier: {tier}");
                LogError($"Unknown jackpot tier: {tier}");
                return result;
            }

            var limits = TierLimits[tier];

            // Check 1: Value range validation with auto-repair for decimal errors
            if (currentValue > limits.max)
            {
                if (currentValue > limits.max * 500) // Likely decimal point error (like 1787125.84 for a Grand max of 10000)
                {
                    result.ValidatedValue = currentValue / 1000.0;
                    result.WasRepaired = true;
                    result.RepairActions.Add($"Applied decimal correction (÷1000): {currentValue:F2} -> {result.ValidatedValue:F2}");
                    LogRepair($"Decimal correction applied to {tier}: {currentValue:F2} -> {result.ValidatedValue:F2}");
                }
                else if (currentValue > limits.max * 100) // Likely decimal point error (smaller scale)
                {
                    result.ValidatedValue = currentValue / 100.0;
                    result.WasRepaired = true;
                    result.RepairActions.Add($"Applied decimal correction (÷100): {currentValue:F2} -> {result.ValidatedValue:F2}");
                    LogRepair($"Decimal correction applied to {tier}: {currentValue:F2} -> {result.ValidatedValue:F2}");
                }
                else if (currentValue > limits.max * 2) // Still too high, clamp it
                {
                    result.ValidatedValue = limits.max;
                    result.WasRepaired = true;
                    result.RepairActions.Add($"Clamped excessive value: {currentValue:F2} -> {result.ValidatedValue:F2}");
                    LogRepair($"Value clamped for {tier}: {currentValue:F2} -> {result.ValidatedValue:F2}");
                }
                else
                {
                    result.IsValid = false;
                    result.Errors.Add($"Value {currentValue:F2} exceeds maximum for {tier} ({limits.max:F2})");
                }
            }

            // Check 2: Negative or zero value validation
            if (result.ValidatedValue < 0)
            {
                result.ValidatedValue = 0;
                result.WasRepaired = true;
                result.RepairActions.Add($"Corrected negative value: {currentValue:F2} -> 0.00");
                LogRepair($"Negative value corrected for {tier}: {currentValue:F2} -> 0.00");
            }

            // Check 3: Threshold validation and repair
            if (threshold > limits.maxThreshold)
            {
                result.ValidatedThreshold = limits.maxThreshold;
                result.WasRepaired = true;
                result.RepairActions.Add($"Threshold capped: {threshold:F2} -> {result.ValidatedThreshold:F2}");
                LogRepair($"Threshold capped for {tier}: {threshold:F2} -> {result.ValidatedThreshold:F2}");
            }

            // Check 4: Value exceeds threshold (critical issue)
            if (result.ValidatedValue > result.ValidatedThreshold)
            {
                result.IsValid = false;
                result.Errors.Add($"Value {result.ValidatedValue:F2} exceeds threshold {result.ValidatedThreshold:F2}");
                LogError($"CRITICAL: {tier} value {result.ValidatedValue:F2} exceeds threshold {result.ValidatedThreshold:F2}");
            }

            if (result.WasRepaired)
                _repairCount++;

            return result;
        }

        /// <summary>
        /// Validates balance values with auto-repair
        /// </summary>
        public static BalanceValidationResult ValidateBalance(double balance, string username = "Unknown")
        {
            var result = new BalanceValidationResult
            {
                OriginalBalance = balance,
                ValidatedBalance = balance,
                Username = username,
                IsValid = true
            };

            // Check 1: Negative balance
            if (balance < MIN_BALANCE)
            {
                result.ValidatedBalance = MIN_BALANCE;
                result.WasRepaired = true;
                result.RepairActions.Add($"Corrected negative balance: {balance:F2} -> {result.ValidatedBalance:F2}");
                LogRepair($"Negative balance corrected for {username}: {balance:F2} -> {result.ValidatedBalance:F2}");
            }

            // Check 2: Excessively high balance (possible data corruption)
            if (balance > MAX_BALANCE)
            {
                if (balance > MAX_BALANCE * 100) // Likely decimal error
                {
                    result.ValidatedBalance = balance / 100.0;
                    result.WasRepaired = true;
                    result.RepairActions.Add($"Applied decimal correction: {balance:F2} -> {result.ValidatedBalance:F2}");
                    LogRepair($"Balance decimal correction for {username}: {balance:F2} -> {result.ValidatedBalance:F2}");
                }
                else
                {
                    result.IsValid = false;
                    result.Errors.Add($"Balance {balance:F2} exceeds maximum allowed ({MAX_BALANCE:F2})");
                    LogError($"Excessive balance for {username}: {balance:F2}");
                }
            }

            if (result.WasRepaired)
                _repairCount++;

            return result;
        }

        /// <summary>
        /// Validates DPD (Dollars Per Day) growth rates
        /// </summary>
        public static DPDValidationResult ValidateDPD(double dpdRate, string gameName = "Unknown")
        {
            var result = new DPDValidationResult
            {
                OriginalRate = dpdRate,
                ValidatedRate = dpdRate,
                GameName = gameName,
                IsValid = true
            };

            // Check 1: Negative or zero DPD
            if (dpdRate < MIN_DPD_RATE && dpdRate != 0) // Allow exactly 0 for new games
            {
                result.ValidatedRate = MIN_DPD_RATE;
                result.WasRepaired = true;
                result.RepairActions.Add($"DPD rate clamped to minimum: {dpdRate:F2} -> {result.ValidatedRate:F2}");
                LogRepair($"DPD rate clamped for {gameName}: {dpdRate:F2} -> {result.ValidatedRate:F2}");
            }

            // Check 2: Excessively high DPD (suspicious)
            if (dpdRate > MAX_DPD_RATE)
            {
                result.ValidatedRate = MAX_DPD_RATE;
                result.WasRepaired = true;
                result.RepairActions.Add($"DPD rate capped to maximum: {dpdRate:F2} -> {result.ValidatedRate:F2}");
                LogRepair($"Excessive DPD rate capped for {gameName}: {dpdRate:F2} -> {result.ValidatedRate:F2}");
            }

            if (result.WasRepaired)
                _repairCount++;

            return result;
        }

        /// <summary>
        /// Validates tier classification based on value ranges
        /// </summary>
        public static TierValidationResult ValidateTierClassification(string currentTier, double value)
        {
            var result = new TierValidationResult
            {
                OriginalTier = currentTier,
                ValidatedTier = currentTier,
                Value = value,
                IsValid = true
            };

            // Find the correct tier for this value
            string correctTier = currentTier;
            foreach (var tier in TierLimits)
            {
                if (value >= tier.Value.min && value <= tier.Value.max)
                {
                    correctTier = tier.Key;
                    break;
                }
            }

            // If the value doesn't fit the current tier, suggest reclassification
            if (correctTier != currentTier && TierLimits.ContainsKey(currentTier))
            {
                var currentLimits = TierLimits[currentTier];
                if (value < currentLimits.min || value > currentLimits.max)
                {
                    result.ValidatedTier = correctTier;
                    result.WasReclassified = true;
                    result.RepairActions.Add($"Tier reclassified: {currentTier} -> {correctTier} for value {value:F2}");
                    LogRepair($"Tier reclassification: {currentTier} -> {correctTier} for value {value:F2}");
                    _repairCount++;
                }
            }

            return result;
        }

        /// <summary>
        /// Comprehensive validation for complete game state
        /// </summary>
        public static GameStateValidationResult ValidateGameState(
            double grandValue, double grandThreshold,
            double majorValue, double majorThreshold, 
            double minorValue, double minorThreshold,
            double miniValue, double miniThreshold,
            double dpdRate, string gameName)
        {
            var result = new GameStateValidationResult { GameName = gameName, IsValid = true };

            // Validate each jackpot tier
            result.GrandResult = ValidateJackpot("Grand", grandValue, grandThreshold);
            result.MajorResult = ValidateJackpot("Major", majorValue, majorThreshold);
            result.MinorResult = ValidateJackpot("Minor", minorValue, minorThreshold);
            result.MiniResult = ValidateJackpot("Mini", miniValue, miniThreshold);

            // Validate DPD
            result.DPDResult = ValidateDPD(dpdRate, gameName);

            // Overall validity
            result.IsValid = result.GrandResult.IsValid && result.MajorResult.IsValid && 
                            result.MinorResult.IsValid && result.MiniResult.IsValid && 
                            result.DPDResult.IsValid;

            // Check for value progression (Grand should be highest, Mini lowest)
            if (result.GrandResult.ValidatedValue < result.MajorResult.ValidatedValue ||
                result.MajorResult.ValidatedValue < result.MinorResult.ValidatedValue ||
                result.MinorResult.ValidatedValue < result.MiniResult.ValidatedValue)
            {
                result.Anomalies.Add("Jackpot values are not in expected order (Grand > Major > Minor > Mini)");
                LogError($"Jackpot progression anomaly detected for {gameName}");
            }

            return result;
        }

        /// <summary>
        /// Health check for system-wide monitoring
        /// </summary>
        public static SystemHealthStatus GetSystemHealth()
        {
            var uptime = DateTime.Now - System.Diagnostics.Process.GetCurrentProcess().StartTime;
            var errorRate = _errorCount > 0 ? (_repairCount / (double)_errorCount) : 1.0;

            return new SystemHealthStatus
            {
                ErrorCount = _errorCount,
                RepairCount = _repairCount,
                RepairSuccessRate = errorRate,
                Uptime = uptime,
                LastAlertTime = _lastAlert,
                Status = DetermineHealthStatus()
            };
        }

        private static string DetermineHealthStatus()
        {
            if (_errorCount == 0) return "HEALTHY";
            if (_repairCount >= _errorCount * 0.8) return "RECOVERING";
            if (_errorCount > 50) return "CRITICAL";
            return "WARNING";
        }

        private static void LogError(string message)
        {
            _errorCount++;
            var timestamp = DateTime.Now.ToString("HH:mm:ss.fff");
            var logMsg = $"[{timestamp}] P4NTH30N-ERROR: {message}";
            
            Console.WriteLine($"🔴 {logMsg}");
            WriteToFile(logMsg);

            // Alert every 10 errors
            if (_errorCount % 10 == 0)
            {
                Console.WriteLine($"⚠️ {_errorCount} data errors detected - recommend system review");
            }
        }

        private static void LogRepair(string message)
        {
            _repairCount++;
            var timestamp = DateTime.Now.ToString("HH:mm:ss.fff");
            var logMsg = $"[{timestamp}] P4NTH30N-REPAIR: {message}";
            
            Console.WriteLine($"🔧 {logMsg}");
            WriteToFile(logMsg);
        }

        private static void LogAlert(string message)
        {
            var timestamp = DateTime.Now.ToString("HH:mm:ss.fff");
            var logMsg = $"[{timestamp}] P4NTH30N-ALERT: {message}";
            
            Console.WriteLine($"🚨 {logMsg}");
            WriteToFile(logMsg);
            _lastAlert = DateTime.Now;
        }

        private static void WriteToFile(string message)
        {
            try
            {
                var logPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "p4nth30n_sanity.log");
                File.AppendAllText(logPath, message + Environment.NewLine);
            }
            catch
            {
                // Fail silently - console output is more important
            }
        }

        /// <summary>
        /// Periodic health check with anomaly detection
        /// </summary>
        public static void PerformHealthCheck(List<(string tier, double value, double threshold)> recentJackpots)
        {
            if (recentJackpots == null || !recentJackpots.Any()) return;

            var now = DateTime.Now;
            if ((now - _lastAlert).TotalMinutes < ALERT_COOLDOWN_MINUTES) return;

            var anomalies = new List<string>();

            // Check for sudden spikes
            var grandValues = recentJackpots.Where(j => j.tier == "Grand").Select(j => j.value).ToList();
            if (grandValues.Count >= 2)
            {
                var latest = grandValues.Last();
                var previous = grandValues[grandValues.Count - 2];
                
                if (latest > previous * 3 && latest > 1000)
                {
                    anomalies.Add($"Sudden Grand spike: {previous:F2} -> {latest:F2}");
                }
            }

            // Check for threshold approaches
            var nearThreshold = recentJackpots.Where(j => j.value / j.threshold > 0.95).ToList();
            if (nearThreshold.Count > 3)
            {
                anomalies.Add($"{nearThreshold.Count} jackpots approaching threshold");
            }

            if (anomalies.Any())
            {
                LogAlert($"Health check detected {anomalies.Count} anomalies: {string.Join("; ", anomalies)}");
            }
        }
    }

    // Supporting classes for validation results
    public class JackpotValidationResult
    {
        public double OriginalValue { get; set; }
        public double OriginalThreshold { get; set; }
        public double ValidatedValue { get; set; }
        public double ValidatedThreshold { get; set; }
        public string Tier { get; set; } = "";
        public bool IsValid { get; set; }
        public bool WasRepaired { get; set; }
        public List<string> Errors { get; set; } = new();
        public List<string> RepairActions { get; set; } = new();
    }

    public class BalanceValidationResult
    {
        public double OriginalBalance { get; set; }
        public double ValidatedBalance { get; set; }
        public string Username { get; set; } = "";
        public bool IsValid { get; set; }
        public bool WasRepaired { get; set; }
        public List<string> Errors { get; set; } = new();
        public List<string> RepairActions { get; set; } = new();
    }

    public class DPDValidationResult
    {
        public double OriginalRate { get; set; }
        public double ValidatedRate { get; set; }
        public string GameName { get; set; } = "";
        public bool IsValid { get; set; }
        public bool WasRepaired { get; set; }
        public List<string> Errors { get; set; } = new();
        public List<string> RepairActions { get; set; } = new();
    }

    public class TierValidationResult
    {
        public string OriginalTier { get; set; } = "";
        public string ValidatedTier { get; set; } = "";
        public double Value { get; set; }
        public bool IsValid { get; set; }
        public bool WasReclassified { get; set; }
        public List<string> RepairActions { get; set; } = new();
    }

    public class GameStateValidationResult
    {
        public string GameName { get; set; } = "";
        public bool IsValid { get; set; }
        public JackpotValidationResult GrandResult { get; set; } = new();
        public JackpotValidationResult MajorResult { get; set; } = new();
        public JackpotValidationResult MinorResult { get; set; } = new();
        public JackpotValidationResult MiniResult { get; set; } = new();
        public DPDValidationResult DPDResult { get; set; } = new();
        public List<string> Anomalies { get; set; } = new();
    }

    public class SystemHealthStatus
    {
        public int ErrorCount { get; set; }
        public int RepairCount { get; set; }
        public double RepairSuccessRate { get; set; }
        public TimeSpan Uptime { get; set; }
        public DateTime LastAlertTime { get; set; }
        public string Status { get; set; } = "";
    }
}