using System.Diagnostics;
using System.Linq;
using P4NTH30N.C0MMON;
using P4NTH30N.C0MMON.Persistence;

namespace P4NTH30N;

class PROF3T {
	static void Main() {
		HUN7ER();
	}

	/// <summary>
	/// Validates if a credential has sufficient data points for reliable DPD-based predictions
	/// </summary>
	/// <param name="credential">The credential to validate</param>
	/// <returns>True if the credential is statistically reliable, false otherwise</returns>
	private static bool IsCredentialStatisticallyReliable(Credential credential) {
		// High DPD values require more data points for statistical reliability
		// DPD > 10 requires at least 25 data points for statistical significance
		if (credential.DPD.Average > 10 && credential.DPD.Data.Count < 25) {
			return false;
		}
		return true;
	}

	/// <summary>
	/// Gets validation details for a credential's DPD reliability
	/// </summary>
	private static (bool IsReliable, string Reason) GetCredentialReliabilityDetails(Credential credential) {
		if (credential.DPD.Average > 10 && credential.DPD.Data.Count < 25) {
			return (false, $"DPD={credential.DPD.Average:F2} > 10 but only {credential.DPD.Data.Count} data points (minimum 25 required)");
		}
		return (true, "Statistically reliable for predictions");
	}

	private static void HUN7ER() {
		MongoUnitOfWork uow = new();
		// Health monitoring for sanity checks
		List<(string tier, double value, double threshold)> recentJackpots = new();
		DateTime lastHealthCheck = DateTime.MinValue;

		while (true) {
			try {
				DateTime DateLimit = DateTime.UtcNow.AddDays(5);
				List<Credential> credentials = uow.Credentials.GetAll();
				uow.Credentials.IntroduceProperties();

				// Filter out banned credentials
				credentials = [.. credentials.Where(x => x.Banned == false)];

				// Filter out credentials with insufficient data for high DPD values
				var representatives = credentials
					.GroupBy(c => (c.House, c.Game))
					.Select(g => g.OrderByDescending(c => c.LastUpdated).First()) // Get representative for each game
					.ToList();

				var excludedGames = representatives
					.Where(rep => !IsCredentialStatisticallyReliable(rep))
					.Select(rep => (rep.House, rep.Game))
					.ToHashSet();

				if (excludedGames.Any()) {
					Console.WriteLine($"🚫 Excluding {excludedGames.Count} games from HUN7ER due to insufficient data points for high DPD values:");
					foreach (var (house, game) in excludedGames) {
						var rep = representatives.First(r => r.House == house && r.Game == game);
						var (_, reason) = GetCredentialReliabilityDetails(rep);
						Console.WriteLine($"   - {game} at {house}: {reason}");
					}
				}

				credentials = [.. credentials.Where(x => !excludedGames.Contains((x.House, x.Game)))];

				// Group credentials by House+Game to get game profiles
				var credentialGroups = credentials
					.GroupBy(c => (c.House, c.Game))
					.ToList();

				List<Signal> signals = uow.Signals.GetAll();
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
						uow.Credentials.Upsert(x);
					} else if (x.Balance > 3 && x.CashedOut) {
						// Set to false if balance > 3 and none of the previous conditions apply
						x.CashedOut = false;
						uow.Credentials.Upsert(x);
					}
				});

				// Process each credential group (represents a game)
				credentialGroups.ForEach(group => {
					// Pick representative credential (most recent LastUpdated) for game profile
					Credential representative = group.OrderByDescending(c => c.LastUpdated).First();
					List<Credential> gameCredentials = group.ToList();

					if (representative.Enabled == true) {
						// VALIDATION: Check DPD reliability before processing
						if (!IsCredentialStatisticallyReliable(representative)) {
							var (_, reason) = GetCredentialReliabilityDetails(representative);
							Console.WriteLine($"⚠️  {representative.Game}: {reason} (processing for data collection only)");
							// Still allow processing for data collection but mark as statistically unreliable
						}

						// Handle unlock timeout - use representative credential's lock/unlock
						if (representative.Unlocked == false && DateTime.UtcNow > representative.UnlockTimeout)
							uow.Credentials.Unlock(representative);

					double previousGrand =
						representative.DPD.Data.Count > 0 ? representative.DPD.Data[^1].Grand : 0;

					// Validate jackpot values using entity IsValid()
					bool jackpotsValid = 
						!double.IsNaN(representative.Jackpots.Grand) && !double.IsInfinity(representative.Jackpots.Grand) && representative.Jackpots.Grand >= 0 &&
						!double.IsNaN(representative.Jackpots.Major) && !double.IsInfinity(representative.Jackpots.Major) && representative.Jackpots.Major >= 0 &&
						!double.IsNaN(representative.Jackpots.Minor) && !double.IsInfinity(representative.Jackpots.Minor) && representative.Jackpots.Minor >= 0 &&
						!double.IsNaN(representative.Jackpots.Mini) && !double.IsInfinity(representative.Jackpots.Mini) && representative.Jackpots.Mini >= 0;

					if (!jackpotsValid) {
						Console.WriteLine($"🔴 Invalid jackpot values detected for {representative.Game}");
						uow.Errors.Insert(ErrorLog.Create(
							ErrorType.ValidationError,
							"HUN7ER",
							$"Invalid jackpot values for {representative.Game}: Grand={representative.Jackpots.Grand}, Major={representative.Jackpots.Major}, Minor={representative.Jackpots.Minor}, Mini={representative.Jackpots.Mini}",
							ErrorSeverity.High
						));
						return; // Skip this game for corrupted data
					}

					// Use values directly (no repair - validate but don't mutate)
					var validatedGrandValue = representative.Jackpots.Grand;
					var validatedMajorValue = representative.Jackpots.Major;
					var validatedMinorValue = representative.Jackpots.Minor;
					var validatedMiniValue = representative.Jackpots.Mini;

					if (validatedGrandValue != previousGrand && validatedGrandValue < 100000) {
						if (validatedGrandValue > previousGrand && validatedGrandValue >= 0 && validatedGrandValue <= 100000) {
							// Add DPD_Data with all tier values
							representative.DPD.Data.Add(new DPD_Data(
								validatedGrandValue,
								validatedMajorValue,
								validatedMinorValue,
								validatedMiniValue
							));
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

								// Validate DPD rate
								bool dpdValid = !double.IsNaN(dollarsPerDay) && !double.IsInfinity(dollarsPerDay) && dollarsPerDay >= 0;
								if (!dpdValid) {
									Console.WriteLine($"🔴 Invalid DPD rate for {representative.Game}");
									uow.Errors.Insert(ErrorLog.Create(
										ErrorType.ValidationError,
										"HUN7ER",
										$"Invalid DPD rate: {dollarsPerDay}",
										ErrorSeverity.High
									));
									dollarsPerDay = 0;
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
									// Validate reset values
									bool resetValid = 
										!double.IsNaN(representative.Jackpots.Grand) && !double.IsInfinity(representative.Jackpots.Grand) && representative.Jackpots.Grand >= 0 && representative.Jackpots.Grand <= 10000 &&
										!double.IsNaN(representative.Jackpots.Major) && !double.IsInfinity(representative.Jackpots.Major) && representative.Jackpots.Major >= 0 &&
										!double.IsNaN(representative.Jackpots.Minor) && !double.IsInfinity(representative.Jackpots.Minor) && representative.Jackpots.Minor >= 0 &&
										!double.IsNaN(representative.Jackpots.Mini) && !double.IsInfinity(representative.Jackpots.Mini) && representative.Jackpots.Mini >= 0;

									if (resetValid) {
										representative.DPD.Data.Add(new DPD_Data(
											representative.Jackpots.Grand,
											representative.Jackpots.Major,
											representative.Jackpots.Minor,
											representative.Jackpots.Mini
										));
									} else {
										uow.Errors.Insert(ErrorLog.Create(
											ErrorType.ValidationError,
											"HUN7ER",
											$"Invalid reset values for {representative.Game}",
											ErrorSeverity.High
										));
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
							uow.Credentials.Upsert(cred);
						}
					}

						if (representative.DPD.Average.Equals(0) && representative.DPD.History is { Count: > 0 }) {
							double lastAverage = representative.DPD.History[^1].Average;
							if (lastAverage > 0.1)
								representative.DPD.Average = lastAverage;
						}

						if (representative.DPD.Average > 0.1) {
							// Validate all jackpot tiers and DPD
							bool gameStateValid = 
								!double.IsNaN(representative.Jackpots.Grand) && !double.IsInfinity(representative.Jackpots.Grand) && representative.Jackpots.Grand >= 0 &&
								!double.IsNaN(representative.Jackpots.Major) && !double.IsInfinity(representative.Jackpots.Major) && representative.Jackpots.Major >= 0 &&
								!double.IsNaN(representative.Jackpots.Minor) && !double.IsInfinity(representative.Jackpots.Minor) && representative.Jackpots.Minor >= 0 &&
								!double.IsNaN(representative.Jackpots.Mini) && !double.IsInfinity(representative.Jackpots.Mini) && representative.Jackpots.Mini >= 0 &&
								!double.IsNaN(representative.DPD.Average) && !double.IsInfinity(representative.DPD.Average) && representative.DPD.Average >= 0;

							if (!gameStateValid) {
								Console.WriteLine($"🔴 Game state validation failed for {representative.Game}");
								uow.Errors.Insert(ErrorLog.Create(
									ErrorType.ValidationError,
									"HUN7ER",
									$"Invalid game state for {representative.Game}",
									ErrorSeverity.High
								));
								return; // Skip processing for invalid game state
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

							// Use DPD average for calculations
							double validatedDPM = representative.DPD.Average / TimeSpan.FromDays(1).TotalMinutes;

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
								uow.Jackpots.Upsert(new Jackpot(
									representative,
									"Grand",
									representative.Jackpots.Grand,
									representative.Thresholds.Grand,
									4,
									DateTime.UtcNow.AddMinutes(MinutesToGrand)
							));

							if (representative.Settings.SpinMajor)
								uow.Jackpots.Upsert(new Jackpot(
									representative,
									"Major",
									representative.Jackpots.Major,
									representative.Thresholds.Major,
									3,
									DateTime.UtcNow.AddMinutes(MinutesToMajor)
							));

							if (representative.Settings.SpinMinor)
								uow.Jackpots.Upsert(new Jackpot(
									representative,
									"Minor",
									representative.Jackpots.Minor,
									representative.Thresholds.Minor,
									2,
									DateTime.UtcNow.AddMinutes(MinutesToMinor)
							));

							if (representative.Settings.SpinMini)
								uow.Jackpots.Upsert(new Jackpot(
									representative,
									"Mini",
									representative.Jackpots.Mini,
									representative.Thresholds.Mini,
									1,
									DateTime.UtcNow.AddMinutes(MinutesToMini)
							));
						}
					}
				});

				// Get all jackpots for enabled games (where we have credentials)
				var gameKeys = credentialGroups.Select(g => (House: g.Key.House, Game: g.Key.Game)).ToHashSet();
				List<Jackpot> jackpots = uow.Jackpots
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
						// VALIDATION: Exclude credentials with high DPD but insufficient data points
						// This ensures statistical reliability for predictions
						if (!IsCredentialStatisticallyReliable(representative)) {
							var (_, reason) = GetCredentialReliabilityDetails(representative);
							Console.WriteLine($"🚫 Excluding {representative.Game} from HUN7ER: {reason}");
							continue;
						}
						
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

						// Guard against zero or extremely small DPD to prevent overflow
						if (representative.DPD.Average <= 0.01)
						{
							continue;
						}

						double daysToAdd = capacity / representative.DPD.Average;

						// Cap daysToAdd to reasonable max (1 year)
						const double maxDaysToAdd = 365;
						if (daysToAdd > maxDaysToAdd)
						{
							daysToAdd = maxDaysToAdd;
						}

						int maxIterations = (int)((DateLimit - jackpot.EstimatedDate).TotalDays / daysToAdd) + 1;
						maxIterations = Math.Min(maxIterations, 100); // Prevent excessive loops

						for (int iter = 0; iter < maxIterations; iter++)
						{
							// For first iteration, use NOW as base to avoid showing past/present times
							// For subsequent iterations, project forward from original estimated date
							DateTime i = iter == 0
								? DateTime.UtcNow.AddDays(daysToAdd)
								: jackpot.EstimatedDate.AddDays(daysToAdd * iter);
							if (i >= DateLimit || i > DateTime.MaxValue.AddDays(-1))
								break;

							predictions.Add(
								new Jackpot(
									representative,
									jackpot.Category,
									jackpot.Current,
									jackpot.Threshold + (capacity * (iter + 1)),
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
								uow.Signals.Upsert(signal);
							else if (signal.Priority > dto.Priority) {
								signal.Acknowledged = dto.Acknowledged;
								uow.Signals.Upsert(signal);
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
							uow.Signals.Delete(signal);
						}
						else if (signal.Acknowledged && signal.Timeout < DateTime.UtcNow) {
							signal.Acknowledged = false;
							uow.Signals.Upsert(signal);
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

				// Periodic health monitoring
				if ((DateTime.Now - lastHealthCheck).TotalMinutes >= 5) {
					var recentErrors = uow.Errors.GetBySource("HUN7ER").Take(10).ToList();
					string status = recentErrors.Any(e => e.Severity == ErrorSeverity.Critical) ? "CRITICAL" : "HEALTHY";
					Console.WriteLine($"💊 HUN7ER Health: {status} | Recent Errors: {recentErrors.Count}");
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
