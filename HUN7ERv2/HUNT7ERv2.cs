using Figgle;
using P4NTH30N.C0MMON;

namespace P4NTH30N {
	[GenerateFiggleText(sourceText: "v    0 . 2 . 0 . 0", memberName: "Version", fontName: "colossal")]
	internal static partial class Header { }
}

internal class Program {
	private const double MinimumDpdAverage = 0.1;
	private static readonly TimeSpan ForecastWindow = TimeSpan.FromDays(5);

	private static void Main(string[] args) {
		_ = args;

		while (true) {
			try {
				// Banner + rolling forecast horizon.
				Console.WriteLine(Header.Version);
				DateTime forecastLimit = DateTime.UtcNow.Add(ForecastWindow);

				// Pull the full credential + signal snapshots for this cycle.
				List<CredentialRecord> credentials = CredentialRecord.GetAll();
				List<SignalRecord> signals = SignalRecord.GetAll();
				List<SignalRecord> qualifiedSignals = [];
				List<JackpotForecast> forecasts = [];

				foreach (CredentialRecord credential in credentials) {
					// Normalize credential toggles and skip disabled entries early.
					bool updated = UpdateCredentialToggles(credential);

					if (!credential.Enabled) {
						if (updated) {
							credential.Save();
						}
						continue;
					}

					// Reopen credentials after lock timeouts.
					if (!credential.Toggles.Unlocked && DateTime.UtcNow > credential.Dates.UnlockTimeout) {
						credential.Unlock();
					}

					// Ensure all jackpot categories exist for the credential.
					List<JackpotRecord> jackpots = LoadJackpots(credential);
					foreach (JackpotRecord jackpot in jackpots) {
						// Respect per-category spin settings.
						if (!IsCategoryEnabled(credential, jackpot.Category)) {
							continue;
						}

						// Maintain DPD data/history for this jackpot.
						bool jackpotUpdated = UpdateJackpotDpd(jackpot);
						if (jackpot.DPD.Average <= MinimumDpdAverage || jackpot.Threshold <= 0) {
							if (jackpotUpdated) {
								jackpot.Save();
							}
							continue;
						}

						// Estimate current value and ETA for forecast + signaling.
						double estimatedCurrent = UpdateJackpotEstimate(jackpot);
						jackpot.Save();

						// Only forecast and signal when the ETA is inside the horizon.
						if (jackpot.Dates.EstimatedDate < forecastLimit) {
							forecasts.AddRange(BuildForecasts(credential, jackpot, estimatedCurrent, forecastLimit));
							SignalRecord? signal = TryCreateSignal(credential, jackpot, estimatedCurrent);
							if (signal != null) {
								qualifiedSignals.Add(signal);
								UpsertSignal(signal, signals);
							}
						}
					}

					// Persist updated credential toggles.
					if (updated) {
						credential.Save();
					}
				}

				// Remove stale signals and report the newest forecast list.
				CleanupSignals(signals, qualifiedSignals);
				PrintForecasts(forecasts, credentials);

				Thread.Sleep(TimeSpan.FromSeconds(10));
			} catch (Exception ex) {
				Console.WriteLine(ex.Message);
				Console.WriteLine(ex);
			}
		}
	}

	private static bool UpdateCredentialToggles(CredentialRecord credential) {
		// Mirror legacy cash-out logic based on balance thresholds.
		bool updated = false;
		if (credential.Balance < 1 && credential.Toggles.CashedOut.Equals(false)) {
			credential.Toggles.CashedOut = true;
			updated = true;
		} else if (credential.Balance > 3 && credential.Toggles.CashedOut) {
			credential.Dates.LastDepositDate = DateTime.UtcNow;
			credential.Toggles.CashedOut = false;
			updated = true;
		}

		return updated;
	}

	private static List<JackpotRecord> LoadJackpots(CredentialRecord credential) {
		// Ensure each credential has a jackpot record for every category.
		List<JackpotRecord> jackpots = JackpotRecord.GetBy(credential);
		string[] categories = ["Grand", "Major", "Minor", "Mini"];
		foreach (string category in categories) {
			if (jackpots.Exists(j => j.Category.Equals(category, StringComparison.OrdinalIgnoreCase))) {
				continue;
			}
			jackpots.Add(new JackpotRecord(category, credential));
		}
		return jackpots;
	}

	private static bool IsCategoryEnabled(CredentialRecord credential, string category) {
		// Allow per-credential switches to disable categories.
		return category switch {
			"Grand" => credential.Settings.SpinGrand,
			"Major" => credential.Settings.SpinMajor,
			"Minor" => credential.Settings.SpinMinor,
			"Mini" => credential.Settings.SpinMini,
			_ => false
		};
	}

	private static bool UpdateJackpotDpd(JackpotRecord jackpot) {
		// Split DPD data at reset boundaries to preserve old runs as history.
		List<DpdRecordData> dataAfterReset = jackpot.DPD.Data
			.Where(d => d.Timestamp >= jackpot.Dates.ResetDate)
			.OrderBy(d => d.Timestamp)
			.ToList();

		List<DpdRecordData> dataBeforeReset = jackpot.DPD.Data
			.Where(d => d.Timestamp < jackpot.Dates.ResetDate)
			.OrderBy(d => d.Timestamp)
			.ToList();

		// Archive historical DPD data when a reset boundary was crossed.
		bool historyUpdated = false;
		if (dataBeforeReset.Count > 1 && ShouldArchiveHistory(jackpot, dataBeforeReset)) {
			double historyAverage = CalculateDpdAverage(dataBeforeReset);
			jackpot.DPD.History.Add(new DpdRecordHistory(historyAverage, dataBeforeReset));
			jackpot.DPD.Data = dataAfterReset;
			historyUpdated = true;
		}

		// Prefer the latest DPD average, but fall back to last history when needed.
		double updatedAverage = dataAfterReset.Count > 1 ? CalculateDpdAverage(dataAfterReset) : 0;
		if (updatedAverage <= MinimumDpdAverage && jackpot.DPD.History.Count > 0) {
			updatedAverage = jackpot.DPD.History[^1].Average;
		}

		updatedAverage = Math.Max(0, updatedAverage);
		if (Math.Abs(updatedAverage - jackpot.DPD.Average) > 0.0001) {
			jackpot.DPD.Average = updatedAverage;
			return true;
		}

		return historyUpdated;
	}

	private static bool ShouldArchiveHistory(JackpotRecord jackpot, List<DpdRecordData> dataBeforeReset) {
		// Only archive if we have not already saved history for this reset span.
		if (jackpot.DPD.History.Count == 0) {
			return true;
		}

		DateTime lastHistoryTimestamp = jackpot.DPD.History[^1].Timestamp;
		return lastHistoryTimestamp < dataBeforeReset[^1].Timestamp;
	}

	private static double CalculateDpdAverage(List<DpdRecordData> data) {
		// Average growth per day using the first/last DPD sample.
		if (data.Count < 2) {
			return 0;
		}

		DpdRecordData first = data[0];
		DpdRecordData last = data[^1];
		double minutes = last.Timestamp.Subtract(first.Timestamp).TotalMinutes;
		if (minutes <= 0) {
			return 0;
		}

		double dollars = last.Value - first.Value;
		double days = minutes / TimeSpan.FromDays(1).TotalMinutes;
		if (days <= 0) {
			return 0;
		}

		return dollars / days;
	}

	private static double UpdateJackpotEstimate(JackpotRecord jackpot) {
		// Convert DPD to DPM and use it to estimate current value + ETA.
		double dpm = jackpot.DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
		jackpot.DPM = dpm;

		if (dpm <= 0) {
			return jackpot.Current;
		}

		double estimatedGrowth = DateTime.UtcNow.Subtract(jackpot.Dates.LastUpdated).TotalMinutes * dpm;
		double estimatedCurrent = jackpot.Current + estimatedGrowth;
		double minutesToJackpot = Math.Max((jackpot.Threshold - estimatedCurrent) / dpm, 0);
		jackpot.Dates.EstimatedDate = DateTime.UtcNow.AddMinutes(minutesToJackpot);
		return estimatedCurrent;
	}

	private static IEnumerable<JackpotForecast> BuildForecasts(
		CredentialRecord credential,
		JackpotRecord jackpot,
		double estimatedCurrent,
		DateTime forecastLimit
	) {
		// Seed with the current forecast and add future repeats based on cycle capacity.
		List<JackpotForecast> forecasts = [
			new JackpotForecast(
				credential,
				jackpot.Category,
				jackpot.Priority,
				estimatedCurrent,
				jackpot.Threshold,
				jackpot.Dates.EstimatedDate,
				jackpot.DPD.Average
			)
		];

		double baseThreshold = GetBaseThreshold(jackpot.Category);
		double capacity = jackpot.Threshold - baseThreshold;
		if (capacity <= 0 || jackpot.DPD.Average <= 0) {
			return forecasts;
		}

		double daysToAdd = capacity / jackpot.DPD.Average;
		if (daysToAdd <= 0) {
			return forecasts;
		}

		int iterations = 1;
		for (
			DateTime i = jackpot.Dates.EstimatedDate.AddDays(daysToAdd);
			i < forecastLimit;
			i = i.AddDays(daysToAdd)
		) {
			forecasts.Add(
				new JackpotForecast(
					credential,
					jackpot.Category,
					jackpot.Priority,
					estimatedCurrent,
					jackpot.Threshold + (capacity * iterations++),
					i,
					jackpot.DPD.Average
				)
			);
		}

		return forecasts;
	}

	private static double GetBaseThreshold(string category) {
		// Baseline threshold estimates for each category.
		return category switch {
			"Grand" => 1500,
			"Major" => 500,
			"Minor" => 100,
			"Mini" => 20,
			_ => 0
		};
	}

	private static SignalRecord? TryCreateSignal(
		CredentialRecord credential,
		JackpotRecord jackpot,
		double estimatedCurrent
	) {
		// Use ETA and balance thresholds to decide when to raise a signal.
		if (jackpot.DPM <= 0) {
			return null;
		}

		bool shouldSignal =
			(jackpot.Priority >= 2
				&& DateTime.UtcNow.AddHours(6) > jackpot.Dates.EstimatedDate
				&& jackpot.Threshold - estimatedCurrent < 0.1
				&& credential.Balance >= 6)
			|| (jackpot.Priority >= 2
				&& DateTime.UtcNow.AddHours(4) > jackpot.Dates.EstimatedDate
				&& jackpot.Threshold - estimatedCurrent < 0.1
				&& credential.Balance >= 4)
			|| (jackpot.Priority >= 2
				&& DateTime.UtcNow.AddHours(2) > jackpot.Dates.EstimatedDate)
			|| (jackpot.Priority == 1
				&& DateTime.UtcNow.AddHours(1) > jackpot.Dates.EstimatedDate);

		if (!shouldSignal) {
			return null;
		}

		SignalRecord signal = new(jackpot.Priority, credential) {
			Timeout = DateTime.UtcNow.AddSeconds(30),
			Acknowledged = true
		};

		return signal;
	}

	private static void UpsertSignal(SignalRecord signal, List<SignalRecord> signals) {
		// Maintain a single signal per credential, upgrading priority when needed.
		SignalRecord? existing = signals.FirstOrDefault(s =>
			s.House == signal.House
			&& s.Game == signal.Game
			&& s.Username == signal.Username
		);

		if (existing == null) {
			signal.Save();
			signals.Add(signal);
		} else if (signal.Priority > existing.Priority) {
			signal.Acknowledged = existing.Acknowledged;
			signal.Save();
		}
	}

	private static void CleanupSignals(List<SignalRecord> signals, List<SignalRecord> qualifiedSignals) {
		// Delete stale signals and release acknowledgements after timeout.
		foreach (SignalRecord signal in signals) {
			SignalRecord? qualified = qualifiedSignals.FirstOrDefault(s =>
				s.House == signal.House
				&& s.Game == signal.Game
				&& s.Username == signal.Username
			);

			if (qualified == null) {
				signal.Delete();
			} else if (signal.Acknowledged && signal.Timeout < DateTime.UtcNow) {
				signal.Acknowledged = false;
				signal.Save();
			}
		}
	}

	private static void PrintForecasts(List<JackpotForecast> forecasts, List<CredentialRecord> credentials) {
		// Aggregate per-house forecast totals for recommendations.
		Dictionary<string, double> potentials = [];
		foreach (JackpotForecast forecast in forecasts) {
			if (potentials.ContainsKey(forecast.House)) {
				potentials[forecast.House] += forecast.Threshold;
			} else {
				potentials.Add(forecast.House, forecast.Threshold);
			}
		}

		Dictionary<string, int> recommendations = [];
		foreach (KeyValuePair<string, double> potential in potentials.OrderByDescending(i => i.Value)) {
			int give = (int)potential.Value / 100;
			if (!give.Equals(0)) {
				if (potential.Value - (give * 100) > 74) {
					give++;
				}
				recommendations.Add(potential.Key, give);
			}
		}

		List<CredentialRecord> activeCredentials = credentials.FindAll(c =>
			c.Enabled && c.Toggles.CashedOut == false && c.Toggles.Banned == false
		);
		// Ensure every active house has a recommendation entry.
		foreach (CredentialRecord credential in activeCredentials) {
			if (!recommendations.ContainsKey(credential.House)) {
				recommendations.Add(credential.House, 0);
			}
		}

		// Render forecasts ordered by ETA with a per-house recommendation marker.
		double totalPotential = 0;
		foreach (JackpotForecast forecast in forecasts.OrderByDescending(i => i.EstimatedDate)) {
			if (!recommendations.TryGetValue(forecast.House, out int recommendation)) {
				continue;
			}

			string current = string.Format($"{forecast.Current:F2}").PadLeft(7);
			string threshold = string.Format($"{forecast.Threshold:F0}").PadRight(4);
			totalPotential += recommendation.Equals(0) ? 0 : forecast.Threshold;
			CredentialRecord credential = forecast.Credential;
			int accounts = activeCredentials
				.FindAll(c => c.House == forecast.House && c.Game == forecast.Game)
				.Count;

			if (!credential.Settings.Hidden && !forecast.Category.Equals("Mini")) {
				Console.WriteLine(
					$"{(forecast.Category.Equals("Mini") ? "----- " : forecast.Category + " ").ToUpper()}| {forecast.EstimatedDate.ToLocalTime():ddd MM/dd/yyyy HH:mm:ss} | {forecast.Game.Substring(0, 9)} | {forecast.DpdAverage:F2} /day |{current} /{threshold}| ({accounts}) {forecast.House}"
				);
			}
		}

		double balance = 0;
		foreach (CredentialRecord credential in credentials) {
			if (credential.Enabled) {
				balance += credential.Balance;
			}
		}

		// Footer mirrors the legacy timing/balance summary.
		DateTime oldestUpdate = activeCredentials.Count > 0
			? activeCredentials.Min(c => c.Dates.LastUpdated)
			: DateTime.UtcNow;
		TimeSpan queryTime = DateTime.UtcNow.Subtract(oldestUpdate);
		string houndHours = queryTime.Hours.ToString().PadLeft(2, '0');
		string houndMinutes = queryTime.Minutes.ToString().PadLeft(2, '0');
		string houndSeconds = queryTime.Seconds.ToString().PadLeft(2, '0');

		string footer = string.Concat(
			$"------|-{DateTime.Now:ddd-MM/dd/yyyy-HH:mm:ss}-",
			$"|-{balance.ToString("F2").PadLeft(9, '-')}-/{totalPotential.ToString("F2").PadRight(11, '-')}|-------------",
			$"|{$"({activeCredentials.Count})".PadLeft(4, '-')}-H0UNDS:{houndHours}:{houndMinutes}:{houndSeconds}----------"
		);
		Console.WriteLine(footer);
	}

	private sealed record JackpotForecast(
		CredentialRecord Credential,
		string Category,
		int Priority,
		double Current,
		double Threshold,
		DateTime EstimatedDate,
		double DpdAverage
	) {
		public string House => Credential.House;
		public string Game => Credential.Game;
	}
}
