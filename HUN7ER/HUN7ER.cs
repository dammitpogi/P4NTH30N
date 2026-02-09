using System.Diagnostics;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.SanityCheck;

namespace P4NTH30N;

class PROF3T {
	static void Main() {
		HUN7ER();
	}

	private static void HUN7ER() {
		// Health monitoring for sanity checks
		List<(string tier, double value, double threshold)> recentJackpots = new();
		DateTime lastHealthCheck = DateTime.MinValue;

		while (true) {
			try {
				DateTime DateLimit = DateTime.UtcNow.AddDays(5);
				List<Credential> credentials = Credential.GetAll();
				Credential.IntroduceProperties();

				// Filter out banned credentials
				credentials = [.. credentials.Where(x => x.Banned == false)];

				// Group credentials by House+Game to get game profiles
				var credentialGroups = credentials
					.GroupBy(c => (c.House, c.Game))
					.ToList();

				List<Signal> signals = Signal.GetAll();
				credentials.ForEach(x => {
					// Check if there are any signals for this credential
					bool hasSignals = signals.Any(s =>
						s.House == x.House &&
						s.Game == x.Game &&
						s.Username == x.Username
					);

					if ((x.Balance < 3 && !hasSignals && !x.CashedOut) || (x.Balance < 0.2 && !x.CashedOut)) {
						// Set to cashed out if: (no signals and balance < 3) OR (balance < 0.2 regardless of signals)
						x.CashedOut = true;
						x.Save();
					} else if (x.Balance > 3 && x.CashedOut) {
						// Set to false if balance > 3 and none of the previous conditions apply
						x.CashedOut = false;
						x.Save();
					}
				});

				// Process each credential group (represents a game)
				credentialGroups.ForEach(group => {
					// Pick representative credential (most recent LastUpdated) for game profile
					Credential representative = group.OrderByDescending(c => c.LastUpdated).First();
					List<Credential> gameCredentials = group.ToList();

					if (representative.Enabled == true) {

						// Handle unlock timeout - use representative credential's lock/unlock
						if (representative.Unlocked == false && DateTime.UtcNow > representative.UnlockTimeout)
							representative.Unlock();

						double previousGrand =
							representative.DPD.Data.Count > 0 ? representative.DPD.Data[^1].Grand : 0;

						// SANITY CHECK: Validate jackpot progression with embedded validation
						var jackpotValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", representative.Jackpots.Grand, representative.Thresholds.Grand);
						if (!jackpotValidation.IsValid) {
							Console.WriteLine($"🔴 Invalid Grand jackpot detected for {representative.Game}: {string.Join(", ", jackpotValidation.Errors)}");
							return; // Skip this game for corrupted data
						}

						// Use validated values
						var validatedGrandValue = jackpotValidation.ValidatedValue;
						var validatedGrandThreshold = jackpotValidation.ValidatedThreshold;

						// Update representative with validated values if repairs were made
						if (jackpotValidation.WasRepaired) {
							representative.Jackpots.Grand = validatedGrandValue;
							representative.Thresholds.Grand = validatedGrandThreshold;
							Console.WriteLine($"🔧 Repaired Grand jackpot for {representative.Game}: {string.Join(", ", jackpotValidation.RepairActions)}");

							// Persist repairs even if the Grand value itself did not change.
							foreach (var cred in gameCredentials) {
								cred.Jackpots = representative.Jackpots;
								cred.DPD = representative.DPD;
								cred.Save();
							}
						}

						if (validatedGrandValue != previousGrand) {
							if (validatedGrandValue > previousGrand && validatedGrandValue >= 0 && validatedGrandValue <= 10000) {
								representative.DPD.Data.Add(new DPD_Data(validatedGrandValue));
								if (representative.DPD.Data.Count > 2) {
									float minutes = Convert.ToSingle(
										representative.DPD.Data[representative.DPD.Data.Count - 1]
											.Timestamp.Subtract(representative.DPD.Data[0].Timestamp)
											.TotalMinutes
									);
									double dollars =
										representative.DPD.Data[representative.DPD.Data.Count - 1].Grand
										- representative.DPD.Data[0].Grand;
									float days =
										minutes
										/ Convert.ToSingle(TimeSpan.FromDays(1).TotalMinutes);
									double dollarsPerDay = dollars / days;

									// SANITY CHECK: Validate DPD rate before using it
									var dpdValidation = P4NTH30NSanityChecker.ValidateDPD(dollarsPerDay, representative.Game);
									if (!dpdValidation.IsValid) {
										Console.WriteLine($"🔴 Invalid DPD rate for {representative.Game}: {string.Join(", ", dpdValidation.Errors)}");
										dollarsPerDay = 0; // Use safe fallback
									}
									else if (dpdValidation.WasRepaired) {
										dollarsPerDay = dpdValidation.ValidatedRate;
										Console.WriteLine($"🔧 Repaired DPD rate for {representative.Game}: {string.Join(", ", dpdValidation.RepairActions)}");
									}

									if (
										dollarsPerDay > 5
										&& representative.DPD.History.Count.Equals(0) == false
									)
										representative.DPD.Average = representative.DPD.History.Average(x =>
											x.Average
										);
									else
										representative.DPD.Average = dollarsPerDay;
								}
							}
							else {
								DPD_History? lastHistory = representative.DPD.History is { Count: > 0 }
									? representative.DPD.History[^1]
									: null;
								List<DPD_Data>? lastHistoryData = lastHistory?.Data;
								if (lastHistoryData is { Count: > 0 } && lastHistoryData[^1].Grand <= previousGrand) {
									representative.DPD.Data = [];
									// SANITY CHECK: Validate reset values before using
									var resetValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", representative.Jackpots.Grand, representative.Thresholds.Grand);
									if (resetValidation.IsValid && resetValidation.ValidatedValue >= 0 && resetValidation.ValidatedValue <= 10000) {
										representative.DPD.Data.Add(new DPD_Data(resetValidation.ValidatedValue));
										if (resetValidation.WasRepaired) {
											representative.Jackpots.Grand = resetValidation.ValidatedValue;
											Console.WriteLine($"🔧 Repaired Grand during reset for {representative.Game}");
										}
									}
									representative.DPD.Average = 0F;
								}
								else {
									representative.DPD.History.Add(
										new DPD_History(representative.DPD.Average, representative.DPD.Data)
									);
								}
							}
						// Save all credentials in the group with updated DPD/jackpot data
						foreach (var cred in gameCredentials) {
							cred.Jackpots = representative.Jackpots;
							cred.DPD = representative.DPD;
							cred.Save();
						}
					}

						if (representative.DPD.Average.Equals(0) && representative.DPD.History is { Count: > 0 }) {
							double lastAverage = representative.DPD.History[^1].Average;
							if (lastAverage > 0.1)
								representative.DPD.Average = lastAverage;
						}

						if (representative.DPD.Average > 0.1) {
							// SANITY CHECK: Comprehensive validation of all jackpot tiers and thresholds
							var gameStateValidation = P4NTH30NSanityChecker.ValidateGameState(
								representative.Jackpots.Grand, representative.Thresholds.Grand,
								representative.Jackpots.Major, representative.Thresholds.Major,
								representative.Jackpots.Minor, representative.Thresholds.Minor,
								representative.Jackpots.Mini, representative.Thresholds.Mini,
								representative.DPD.Average, representative.Game
							);

							if (!gameStateValidation.IsValid) {
								Console.WriteLine($"🔴 Game state validation failed for {representative.Game}");
								return; // Skip processing for invalid game state
							}

							// Apply any repairs made during validation
							if (gameStateValidation.GrandResult.WasRepaired) {
								representative.Jackpots.Grand = gameStateValidation.GrandResult.ValidatedValue;
								representative.Thresholds.Grand = gameStateValidation.GrandResult.ValidatedThreshold;
							}
							if (gameStateValidation.MajorResult.WasRepaired) {
								representative.Jackpots.Major = gameStateValidation.MajorResult.ValidatedValue;
								representative.Thresholds.Major = gameStateValidation.MajorResult.ValidatedThreshold;
							}
							if (gameStateValidation.MinorResult.WasRepaired) {
								representative.Jackpots.Minor = gameStateValidation.MinorResult.ValidatedValue;
								representative.Thresholds.Minor = gameStateValidation.MinorResult.ValidatedThreshold;
							}
							if (gameStateValidation.MiniResult.WasRepaired) {
								representative.Jackpots.Mini = gameStateValidation.MiniResult.ValidatedValue;
								representative.Thresholds.Mini = gameStateValidation.MiniResult.ValidatedThreshold;
							}
							if (gameStateValidation.DPDResult.WasRepaired) {
								representative.DPD.Average = gameStateValidation.DPDResult.ValidatedRate;
							}

							if (
								gameStateValidation.GrandResult.WasRepaired
								|| gameStateValidation.MajorResult.WasRepaired
								|| gameStateValidation.MinorResult.WasRepaired
								|| gameStateValidation.MiniResult.WasRepaired
								|| gameStateValidation.DPDResult.WasRepaired
							) {
								foreach (var cred in gameCredentials) {
									cred.Jackpots = representative.Jackpots;
									cred.DPD = representative.DPD;
									cred.Save();
								}
							}

							// Track for health monitoring
							recentJackpots.Add(("Grand", representative.Jackpots.Grand, representative.Thresholds.Grand));
							recentJackpots.Add(("Major", representative.Jackpots.Major, representative.Thresholds.Major));
							recentJackpots.Add(("Minor", representative.Jackpots.Minor, representative.Thresholds.Minor));
							recentJackpots.Add(("Mini", representative.Jackpots.Mini, representative.Thresholds.Mini));

							// Limit tracking to last 20 entries per tier
							if (recentJackpots.Count > 80) {
								recentJackpots.RemoveRange(0, 20);
							}

							// Continue with validated values
							double validatedDPM = gameStateValidation.DPDResult.ValidatedRate / TimeSpan.FromDays(1).TotalMinutes;

							double DPM = validatedDPM;
							double estimatedGrowth =
								DateTime.Now.Subtract(representative.LastUpdated).TotalMinutes * DPM;

							const double DpmEpsilon = 1e-9;
							double unreachableMinutes = TimeSpan.FromDays(365 * 100).TotalMinutes;

							double SafeMinutesTo(double threshold, double jackpotValue) {
								double remaining = threshold - (jackpotValue + estimatedGrowth);
								if (remaining <= 0)
									return 0;

								if (double.IsNaN(DPM) || double.IsInfinity(DPM) || DPM <= DpmEpsilon)
									return unreachableMinutes;

								return remaining / DPM;
							}

							double MinutesToGrand = SafeMinutesTo(representative.Thresholds.Grand, representative.Jackpots.Grand);
							double MinutesToMajor = SafeMinutesTo(representative.Thresholds.Major, representative.Jackpots.Major);
							double MinutesToMinor = SafeMinutesTo(representative.Thresholds.Minor, representative.Jackpots.Minor);
							double MinutesToMini = SafeMinutesTo(representative.Thresholds.Mini, representative.Jackpots.Mini);

							if (representative.Settings.SpinGrand)
								new Jackpot(
									representative,
									"Grand",
									representative.Jackpots.Grand,
									representative.Thresholds.Grand,
									4,
									DateTime.UtcNow.AddMinutes(MinutesToGrand)
								).Save();

							if (representative.Settings.SpinMajor)
								new Jackpot(
									representative,
									"Major",
									representative.Jackpots.Major,
									representative.Thresholds.Major,
									3,
									DateTime.UtcNow.AddMinutes(MinutesToMajor)
								).Save();

							if (representative.Settings.SpinMinor)
								new Jackpot(
									representative,
									"Minor",
									representative.Jackpots.Minor,
									representative.Thresholds.Minor,
									2,
									DateTime.UtcNow.AddMinutes(MinutesToMinor)
								).Save();

							if (representative.Settings.SpinMini)
								new Jackpot(
									representative,
									"Mini",
									representative.Jackpots.Mini,
									representative.Thresholds.Mini,
									1,
									DateTime.UtcNow.AddMinutes(MinutesToMini)
								).Save();
						}
					}
				});

				// Get all jackpots for enabled games (where we have credentials)
				var gameKeys = credentialGroups.Select(g => (House: g.Key.House, Game: g.Key.Game)).ToHashSet();
				List<Jackpot> jackpots = Jackpot
					.GetAll()
					.FindAll(x => x.EstimatedDate < DateLimit)
					.FindAll(x => gameKeys.Contains((x.House, x.Game)));

				List<Signal> qualified = [];
				List<Jackpot> predictions = [];
				foreach (Jackpot jackpot in jackpots) {
					// Get representative credential for this jackpot's game
					var group = credentialGroups.FirstOrDefault(g =>
						g.Key.House == jackpot.House && g.Key.Game == jackpot.Game);
					if (group == null) continue;
					Credential? representative = group.OrderByDescending(c => c.LastUpdated).FirstOrDefault();
					if (representative == null) continue;

					if (representative.Settings.SpinGrand.Equals(false) && jackpot.Category.Equals("Grand"))
						continue;
					if (representative.Settings.SpinMajor.Equals(false) && jackpot.Category.Equals("Major"))
						continue;
					if (representative.Settings.SpinMinor.Equals(false) && jackpot.Category.Equals("Minor"))
						continue;
					if (representative.Settings.SpinMini.Equals(false) && jackpot.Category.Equals("Mini"))
						continue;

					if (representative.DPD.Average > 0.01) {
						predictions.Add(jackpot);
						double capacity =
							jackpot.Threshold
							- jackpot.Category switch {
								"Grand" => 1500,
								"Major" => 500,
								"Minor" => 100,
								"Mini" => 20,
								_ => 0,
							};
						double daysToAdd = capacity / representative.DPD.Average;
						int iterations = 1;
						for (
							DateTime i = jackpot.EstimatedDate.AddDays(daysToAdd);
							i < DateLimit;
							i = i.AddDays(daysToAdd)
						) {
							predictions.Add(
								new Jackpot(
									representative,
									jackpot.Category,
									jackpot.Current,
									jackpot.Threshold + (capacity * iterations++),
									jackpot.Priority,
									i
								)
							);
						}

						jackpot.Current +=
							DateTime.UtcNow.Subtract(jackpot.LastUpdated).TotalMinutes
							* jackpot.DPM;
						jackpot.EstimatedDate = DateTime.UtcNow.AddMinutes(
							Math.Max((jackpot.Threshold - jackpot.Current) / jackpot.DPM, 0)
						);

						List<Credential> gameCredentials = group
							.Where(x => x.Enabled && !x.Banned && !x.CashedOut)
							.ToList();
						double avgBalance =
							gameCredentials.Count > 0 ? gameCredentials.Average(x => x.Balance) : 0;

						if (
							(
								jackpot.Priority >= 2
								&& DateTime.UtcNow.AddHours(6) > jackpot.EstimatedDate
								&& jackpot.Threshold - jackpot.Current < 0.1
								&& avgBalance >= 6
							)
							|| (
								jackpot.Priority >= 2
								&& DateTime.UtcNow.AddHours(4) > jackpot.EstimatedDate
								&& jackpot.Threshold - jackpot.Current < 0.1
								&& avgBalance >= 4
							)
							|| (
								jackpot.Priority >= 2
								&& DateTime.UtcNow.AddHours(2) > jackpot.EstimatedDate
							)
							|| (
								jackpot.Priority == 1
								&& DateTime.UtcNow.AddHours(1) > jackpot.EstimatedDate
							)
						) {
							gameCredentials.ForEach(
								delegate (Credential credential) {
									Signal? dto = signals.Find(s =>
										s.House == credential.House
										&& s.Game == credential.Game
										&& s.Username == credential.Username
									);
									Signal signal = new Signal(jackpot.Priority, credential);
									signal.Timeout = DateTime.UtcNow.AddSeconds(30);
									signal.Acknowledged = true;
									qualified.Add(signal);
									if (dto == null)
										signal.Save();
									else if (signal.Priority > dto.Priority) {
										signal.Acknowledged = dto.Acknowledged;
										signal.Save();
									}
								}
							);
						}
					}
				}

				Dictionary<string, double> potentials = [];
				Dictionary<string, int> recommendations = [];
				predictions.ForEach(
					delegate (Jackpot jackpot) {
						if (potentials.ContainsKey(jackpot.House))
							potentials[jackpot.House] += jackpot.Threshold;
						else
							potentials.Add(jackpot.House, jackpot.Threshold);
					}
				);
				potentials = potentials.OrderByDescending(i => i.Value).ToDictionary();

				for (int i = 0; i < potentials.Count; i++) {
					string house = potentials.ElementAt(i).Key;
					double potential = potentials.ElementAt(i).Value;
					int give = (int)potential / 100;
					if (give.Equals(0) == false) {
						if (potential - (give * 100) > 74)
							give++;
						recommendations.Add(house, give);
					}
				}

				credentials = credentials.FindAll(c =>
					c.Enabled && c.CashedOut == false && c.Banned == false
				);
				credentials.ForEach(
					delegate (Credential credential) {
						if (recommendations.ContainsKey(credential.House) == false)
							recommendations.Add(credential.House, 0);
					}
				);

				double totalPotential = 0f;
				predictions
					.OrderByDescending(i => i.EstimatedDate)
					.ToList()
					.ForEach(
						delegate (Jackpot jackpot) {
							if (recommendations.TryGetValue(jackpot.House, out int recommendation)) {
								string current = string.Format($"{jackpot.Current:F2}").PadLeft(7);
								string threshold = string.Format($"{jackpot.Threshold:F0}")
									.PadRight(4);
								totalPotential += recommendations[jackpot.House].Equals(0)
									? 0
									: jackpot.Threshold;

								// Get representative credential for printing
								var group = credentialGroups.FirstOrDefault(g =>
									g.Key.House == jackpot.House && g.Key.Game == jackpot.Game);
								if (group == null) return;
								Credential? representative = group.OrderByDescending(c => c.LastUpdated).FirstOrDefault();
								if (representative == null) return;

								int accounts = credentials
									.FindAll(c =>
										c.House == jackpot.House && c.Game == jackpot.Game
									)
									.Count;
								if (representative.Settings.Hidden.Equals(false) && (jackpot.Category.Equals("Mini") == false))
									Console.WriteLine(
										$"{(jackpot.Category.Equals("Mini") ? "----- " : jackpot.Category + " ").ToUpper()}| {jackpot.EstimatedDate.ToLocalTime().ToString("ddd MM/dd/yyyy HH:mm:ss").ToUpper()} | {representative.Game.Substring(0, 9)} | {representative.DPD.Average:F2} /day |{current} /{threshold}| ({accounts}) {jackpot.House}"
									);
							}
						}
					);

				signals.ForEach(
					delegate (Signal signal) {
						Signal? qc = qualified.FirstOrDefault(s =>
							s.House == signal.House
							&& s.Game == signal.Game
							&& s.Username == signal.Username
						);
						if (qc == null) {
							signal.Delete();
						}
						else if (signal.Acknowledged && signal.Timeout < DateTime.UtcNow) {
							signal.Acknowledged = false;
							signal.Save();
						}
					}
				);

				double balance = 0f;
				credentials.ForEach(
					delegate (Credential credential) {
						if (credential.Enabled)
							balance += credential.Balance;
					}
				);

				// Use oldest LastUpdated among credentials as queue age
				DateTime oldestUpdate = credentials.Count > 0
					? credentials.Min(c => c.LastUpdated)
					: DateTime.UtcNow;

				TimeSpan QueryTime = DateTime.UtcNow.Subtract(oldestUpdate);
				string houndHours = QueryTime.Hours.ToString().PadLeft(2, '0'),
					houndMinutes = QueryTime.Minutes.ToString().PadLeft(2, '0'),
					houndSeconds = QueryTime.Seconds.ToString().PadLeft(2, '0');
				string footer = string.Concat(
					$"------|-{DateTime.Now.ToString("ddd-MM/dd/yyyy-HH:mm:ss").ToUpper()}-",
					$"|-{balance.ToString("F2").PadLeft(9, '-')}-/{totalPotential.ToString("F2").PadRight(11, '-')}|-------------",
					$"|{$"({credentials.Count})".PadLeft(4, '-')}-H0UNDS:{houndHours}:{houndMinutes}:{houndSeconds}----------"
				);
				Console.WriteLine(footer);

				// SANITY CHECK: Periodic health monitoring
				if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5) {
					P4NTH30NSanityChecker.PerformHealthCheck(recentJackpots);
					var healthStatus = P4NTH30NSanityChecker.GetSystemHealth();
					Console.WriteLine($"💊 System Health: {healthStatus.Status} | Errors: {healthStatus.ErrorCount} | Repairs: {healthStatus.RepairCount} | Rate: {healthStatus.RepairSuccessRate:P1}");
					lastHealthCheck = DateTime.Now;
				}

				Thread.Sleep(Convert.ToInt32(TimeSpan.FromSeconds(10).TotalMilliseconds));
			}
			catch (Exception ex) {
				StackTrace st = new(ex, true);
				StackFrame? frame = st.GetFrame(0);
				int line = frame != null ? frame.GetFileLineNumber() : 0;
				Console.WriteLine($"[{line}]Processing failed: {ex.Message}");
				Console.WriteLine(ex);
			}
		}
	}
}
