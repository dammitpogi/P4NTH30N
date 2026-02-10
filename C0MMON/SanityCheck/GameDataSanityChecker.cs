using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace P4NTH30N.C0MMON.SanityCheck
{
	/// <summary>
	/// Compatibility shim for HunterWatchdog - parses HUN7ER log entries and provides GameEntry objects
	/// Integrates with existing P4NTH30NSanityChecker for validation
	/// </summary>
	public static class GameDataSanityChecker
	{
		/// <summary>
		/// Represents a parsed game entry from HUN7ER logs
		/// </summary>
		public class GameEntry
		{
			public string PrizeType { get; set; } = "";
			public double CurrentValue { get; set; }
			public double Threshold { get; set; }
			public double DailyRate { get; set; }
			public string Location { get; set; } = "";
			public DateTime Timestamp { get; set; }
			public string RawLine { get; set; } = "";
		}

		/// <summary>
		/// Parses HUN7ER log lines and returns sanitized GameEntry objects
		/// Expected format: "{TIER}| {DATE} | {GAME} | {DPD} /day |{current} /{threshold}| ({accounts}) {house}"
		/// </summary>
		public static List<GameEntry> SanitizeAndRepairEntries(IEnumerable<string> logLines)
		{
			var entries = new List<GameEntry>();
			
			if (logLines == null)
				return entries;

			foreach (var line in logLines)
			{
				if (string.IsNullOrWhiteSpace(line))
					continue;

				var entry = ParseLogLine(line.Trim());
				if (entry != null)
				{
					// Apply validation using existing sanity checker
					var validationResult = P4NTH30NSanityChecker.ValidateJackpot(
						entry.PrizeType, 
						entry.CurrentValue, 
						entry.Threshold);

					if (validationResult.WasRepaired)
					{
						entry.CurrentValue = validationResult.ValidatedValue;
						entry.Threshold = validationResult.ValidatedThreshold;
					}

					// Only add entries that are either valid or successfully repaired
					if (validationResult.IsValid || validationResult.WasRepaired)
					{
						entries.Add(entry);
					}
				}
			}

			return entries;
		}

		/// <summary>
		/// Parses a single HUN7ER log line into a GameEntry
		/// Format examples:
		/// "MINOR| 2025-02-08 14:23:15 | Dragon's Fire | 12.34 /day |145.67 /200.00| (3) FireKirin"
		/// "GRAND| 2025-02-08 14:23:15 | Phoenix Rising | 45.78 /day |1567.89 /2000.00| (5) OrionStars"
		/// </summary>
		private static GameEntry? ParseLogLine(string line)
		{
			try
			{
				// Regex pattern to parse the log format
				var pattern = @"^(?<tier>MINI|MINOR|MAJOR|GRAND)\|\s*(?<date>\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\s*\|\s*(?<game>[^|]+)\s*\|\s*(?<dpd>[\d.]+)\s*/day\s*\|\s*(?<current>[\d.]+)\s*/\s*(?<threshold>[\d.]+)\s*\|\s*\((?<accounts>\d+)\)\s*(?<house>[^|]+)$";
				
				var match = Regex.Match(line, pattern, RegexOptions.IgnoreCase);
				if (!match.Success)
				{
					// Try a more lenient pattern for malformed entries
					var lenientPattern = @"^(?<tier>MINI|MINOR|MAJOR|GRAND)[^|]*\|[^|]*\|[^|]*\|[^|]*\|\s*(?<current>[\d.]+)\s*/\s*(?<threshold>[\d.]+)[^|]*\|";
					var lenientMatch = Regex.Match(line, lenientPattern, RegexOptions.IgnoreCase);
					
					if (!lenientMatch.Success)
						return null;

					// Create entry with limited data from lenient parsing
					return new GameEntry
					{
						PrizeType = lenientMatch.Groups["tier"].Value.ToUpperInvariant(),
						CurrentValue = double.Parse(lenientMatch.Groups["current"].Value),
						Threshold = double.Parse(lenientMatch.Groups["threshold"].Value),
						Location = "Unknown",
						Timestamp = DateTime.Now,
						RawLine = line
					};
				}

				// Parse the full match
				var entry = new GameEntry
				{
					PrizeType = match.Groups["tier"].Value.ToUpperInvariant(),
					CurrentValue = double.Parse(match.Groups["current"].Value),
					Threshold = double.Parse(match.Groups["threshold"].Value),
					DailyRate = double.Parse(match.Groups["dpd"].Value),
					Location = $"{match.Groups["game"].Value.Trim()} ({match.Groups["house"].Value.Trim()})",
					RawLine = line
				};

				// Parse timestamp
				if (DateTime.TryParse(match.Groups["date"].Value, out var timestamp))
				{
					entry.Timestamp = timestamp;
				}
				else
				{
					entry.Timestamp = DateTime.Now;
				}

				return entry;
			}
			catch (Exception)
			{
				// Silently skip malformed lines
				return null;
			}
		}

		/// <summary>
		/// Validates a GameEntry using the existing P4NTH30NSanityChecker
		/// </summary>
		public static bool ValidateEntry(GameEntry entry)
		{
			if (entry == null)
				return false;

			var result = P4NTH30NSanityChecker.ValidateJackpot(
				entry.PrizeType, 
				entry.CurrentValue, 
				entry.Threshold);

			return result.IsValid || result.WasRepaired;
		}
	}
}