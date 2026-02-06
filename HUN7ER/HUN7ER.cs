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
                
	List<Game> games = Game.GetAll()
					.FindAll(x =>
						credentials.Any(y => x.House.Equals(y.House) && x.Name.Equals(y.Game))
					);

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
                    
                    credentials = [.. credentials.Where(x => x.Banned == false)];

					if (games.Any(y => y.House.Equals(x.House) && y.Name.Equals(x.Game)) == false) {
						Game newGame = new Game(x.House, x.Game);
						games.Add(newGame);
						newGame.Save();
					}
				});

				games.ForEach(
					delegate (Game game) {
						if (game.Enabled == true) {
							House house = House.Get(game.House);
							if (game.Unlocked == false && DateTime.UtcNow > game.UnlockTimeout)
								game.Unlock();

							double previousGrand =
								game.DPD.Data.Count > 0 ? game.DPD.Data[^1].Grand : 0;

							// SANITY CHECK: Validate jackpot progression with embedded validation
							var jackpotValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", game.Jackpots.Grand, game.Thresholds.Grand);
							if (!jackpotValidation.IsValid)
							{
								Console.WriteLine($"🔴 Invalid Grand jackpot detected for {game.Name}: {string.Join(", ", jackpotValidation.Errors)}");
								continue; // Skip this iteration for corrupted data
							}
							
							// Use validated values
							var validatedGrandValue = jackpotValidation.ValidatedValue;
							var validatedGrandThreshold = jackpotValidation.ValidatedThreshold;
							
							// Update game with validated values if repairs were made
							if (jackpotValidation.WasRepaired)
							{
								game.Jackpots.Grand = validatedGrandValue;
								game.Thresholds.Grand = validatedGrandThreshold;
								Console.WriteLine($"🔧 Repaired Grand jackpot for {game.Name}: {string.Join(", ", jackpotValidation.RepairActions)}");
							}

if (validatedGrandValue != previousGrand) {
								if (validatedGrandValue > previousGrand && validatedGrandValue >= 0 && validatedGrandValue <= 10000) {
									game.DPD.Data.Add(new DPD_Data(validatedGrandValue));
									if (game.DPD.Data.Count > 2) {
										float minutes = Convert.ToSingle(
											game.DPD.Data[game.DPD.Data.Count - 1]
												.Timestamp.Subtract(game.DPD.Data[0].Timestamp)
												.TotalMinutes
										);
										double dollars =
											game.DPD.Data[game.DPD.Data.Count - 1].Grand
											- game.DPD.Data[0].Grand;
										float days =
											minutes
											/ Convert.ToSingle(TimeSpan.FromDays(1).TotalMinutes);
										double dollarsPerDay = dollars / days;

										// SANITY CHECK: Validate DPD rate before using it
										var dpdValidation = P4NTH30NSanityChecker.ValidateDPD(dollarsPerDay, game.Name);
										if (!dpdValidation.IsValid)
										{
											Console.WriteLine($"🔴 Invalid DPD rate for {game.Name}: {string.Join(", ", dpdValidation.Errors)}");
											dollarsPerDay = 0; // Use safe fallback
										}
										else if (dpdValidation.WasRepaired)
										{
											dollarsPerDay = dpdValidation.ValidatedRate;
											Console.WriteLine($"🔧 Repaired DPD rate for {game.Name}: {string.Join(", ", dpdValidation.RepairActions)}");
										}

										if (
											dollarsPerDay > 5
											&& game.DPD.History.Count.Equals(0) == false
										)
											game.DPD.Average = game.DPD.History.Average(x =>
												x.Average
											);
										else
											game.DPD.Average = dollarsPerDay;
									}
								} else {
if (
	game.DPD.History.Count.Equals(0).Equals(false)
	&& game.DPD.History[^1].Data.Count > 0
	&& game.DPD.History[^1].Data[^1].Grand <= previousGrand
) {
										game.DPD.Data = [];
										// SANITY CHECK: Validate reset values before using
										var resetValidation = P4NTH30NSanityChecker.ValidateJackpot("Grand", game.Jackpots.Grand, game.Thresholds.Grand);
										if (resetValidation.IsValid && resetValidation.ValidatedValue >= 0 && resetValidation.ValidatedValue <= 10000) {
											game.DPD.Data.Add(new DPD_Data(resetValidation.ValidatedValue));
											if (resetValidation.WasRepaired) {
												game.Jackpots.Grand = resetValidation.ValidatedValue;
												Console.WriteLine($"🔧 Repaired Grand during reset for {game.Name}");
											}
										}
										game.DPD.Average = 0F;
									} else {
										game.DPD.History.Add(
											new DPD_History(game.DPD.Average, game.DPD.Data)
										);
									}
								}
								game.Save();
							}

							if (
								game.DPD.Average.Equals(0)
								&& game.DPD.History.Count > 0
								&& game.DPD.History[^1].Average > 0.1
							) {
								game.DPD.Average = game.DPD.History[^1].Average;
							}

							if (game.DPD.Average > 0.1) {
								// SANITY CHECK: Comprehensive validation of all game jackpots and thresholds
								var gameStateValidation = P4NTH30NSanityChecker.ValidateGameState(
									game.Jackpots.Grand, game.Thresholds.Grand,
									game.Jackpots.Major, game.Thresholds.Major,
									game.Jackpots.Minor, game.Thresholds.Minor,
									game.Jackpots.Mini, game.Thresholds.Mini,
									game.DPD.Average, game.Name
								);

								if (!gameStateValidation.IsValid) {
									Console.WriteLine($"🔴 Game state validation failed for {game.Name}");
									continue; // Skip processing for invalid game state
								}

								// Apply any repairs made during validation
								if (gameStateValidation.GrandResult.WasRepaired) {
									game.Jackpots.Grand = gameStateValidation.GrandResult.ValidatedValue;
									game.Thresholds.Grand = gameStateValidation.GrandResult.ValidatedThreshold;
								}
								if (gameStateValidation.MajorResult.WasRepaired) {
									game.Jackpots.Major = gameStateValidation.MajorResult.ValidatedValue;
									game.Thresholds.Major = gameStateValidation.MajorResult.ValidatedThreshold;
								}
								if (gameStateValidation.MinorResult.WasRepaired) {
									game.Jackpots.Minor = gameStateValidation.MinorResult.ValidatedValue;
									game.Thresholds.Minor = gameStateValidation.MinorResult.ValidatedThreshold;
								}
								if (gameStateValidation.MiniResult.WasRepaired) {
									game.Jackpots.Mini = gameStateValidation.MiniResult.ValidatedValue;
									game.Thresholds.Mini = gameStateValidation.MiniResult.ValidatedThreshold;
								}
								if (gameStateValidation.DPDResult.WasRepaired) {
									game.DPD.Average = gameStateValidation.DPDResult.ValidatedRate;
								}

								// Track for health monitoring
								recentJackpots.Add(("Grand", game.Jackpots.Grand, game.Thresholds.Grand));
								recentJackpots.Add(("Major", game.Jackpots.Major, game.Thresholds.Major));
								recentJackpots.Add(("Minor", game.Jackpots.Minor, game.Thresholds.Minor));
								recentJackpots.Add(("Mini", game.Jackpots.Mini, game.Thresholds.Mini));

								// Limit tracking to last 20 entries per tier
								if (recentJackpots.Count > 80) {
									recentJackpots.RemoveRange(0, 20);
								}

								// Continue with validated values
								double validatedDPM = gameStateValidation.DPDResult.ValidatedRate / TimeSpan.FromDays(1).TotalMinutes;
								// game.Thresholds.Grand -= 1F; game.Thresholds.Major -= 0.5F;
								// game.Thresholds.Minor -= 0.25F; game.Thresholds.Mini -= 0.1F;

								double DPM = validatedDPM;
								double estimatedGrowth =
									DateTime.Now.Subtract(game.LastUpdated).TotalMinutes * DPM;

								double MinutesToGrand = Math.Max(
									(
										game.Thresholds.Grand
										- (game.Jackpots.Grand + estimatedGrowth)
									) / DPM,
									0
								);
								double MinutesToMajor = Math.Max(
									(
										game.Thresholds.Major
										- (game.Jackpots.Major + estimatedGrowth)
									) / DPM,
									0
								);
								double MinutesToMinor = Math.Max(
									(
										game.Thresholds.Minor
										- (game.Jackpots.Minor + estimatedGrowth)
									) / DPM,
									0
								);
								double MinutesToMini = Math.Max(
									(game.Thresholds.Mini - (game.Jackpots.Mini + estimatedGrowth))
										/ DPM,
									0
								);

								if (game.Settings.SpinGrand)
									new Jackpot(
										game,
										"Grand",
										game.Jackpots.Grand,
										game.Thresholds.Grand,
										4,
										DateTime.UtcNow.AddMinutes(MinutesToGrand)
									).Save();

								if (game.Settings.SpinMajor)
									new Jackpot(
										game,
										"Major",
										game.Jackpots.Major,
										game.Thresholds.Major,
										3,
										DateTime.UtcNow.AddMinutes(MinutesToMajor)
									).Save();

								if (game.Settings.SpinMinor)
									new Jackpot(
										game,
										"Minor",
										game.Jackpots.Minor,
										game.Thresholds.Minor,
										2,
										DateTime.UtcNow.AddMinutes(MinutesToMinor)
									).Save();

								if (game.Settings.SpinMini)
									new Jackpot(
										game,
										"Mini",
										game.Jackpots.Mini,
										game.Thresholds.Mini,
										1,
										DateTime.UtcNow.AddMinutes(MinutesToMini)
									).Save();
							}
						}
					}
				);

				List<Jackpot> jackpots = Jackpot
					.GetAll()
					.FindAll(x => x.EstimatedDate < DateLimit)
					.FindAll(x =>
						games.Any(y =>
							y.Enabled && x.Game.Equals(y.Name) && x.House.Equals(y.House)
						)
					);

				List<Signal> qualified = [];
				List<Jackpot> predictions = [];
				foreach (Jackpot jackpot in jackpots) {
					Game game = games.FindAll(g =>
						g.Name == jackpot.Game && g.House == jackpot.House
					)[0];
					if (game.Settings.SpinGrand.Equals(false) && jackpot.Category.Equals("Grand"))
						continue;
					if (game.Settings.SpinMajor.Equals(false) && jackpot.Category.Equals("Major"))
						continue;
					if (game.Settings.SpinMinor.Equals(false) && jackpot.Category.Equals("Minor"))
						continue;
					if (game.Settings.SpinMini.Equals(false) && jackpot.Category.Equals("Mini"))
						continue;

					// Console.WriteLine(game.House);
					if (game.DPD.Average > 0.01) {
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
						double daysToAdd = capacity / game.DPD.Average;
						int iterations = 1;
						for (
							DateTime i = jackpot.EstimatedDate.AddDays(daysToAdd);
							i < DateLimit;
							i = i.AddDays(daysToAdd)
						) {
							predictions.Add(
								new Jackpot(
									game,
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

						List<Credential> gameCredentials = Credential
							.GetAllEnabledFor(game)
							.FindAll(x => x.CashedOut.Equals(false));
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
						// Console.WriteLine($"{house} : $ {potential:F2}");
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
								Game game = games.FindAll(g =>
									g.Name == jackpot.Game && g.House == jackpot.House
								)[0];
								int accounts = credentials
									.FindAll(c =>
										c.House == jackpot.House && c.Game == jackpot.Game
									)
									.Count;
								if (
									game.Settings.Hidden.Equals(false)
                                    && (jackpot.Category.Equals("Mini") == false)
									// && (jackpot.Category.Equals("Mini") && accounts.Equals(0)).Equals(false)
								)
									Console.WriteLine(
										$"{(jackpot.Category.Equals("Mini") ? "----- " : jackpot.Category + " ").ToUpper()}| {jackpot.EstimatedDate.ToLocalTime().ToString("ddd MM/dd/yyyy HH:mm:ss").ToUpper()} | {game.Name.Substring(0, 9)} | {game.DPD.Average:F2} /day |{current} /{threshold}| ({accounts}) {jackpot.House}"
									);
								// Console.WriteLine($"{jackpot.Category.ToUpper(),5} | {jackpot.EstimatedDate.ToLocalTime().ToString("ddd MM/dd/yyyy HH:mm:ss").ToUpper()} | {game.DPD.Average:F2} /day | {potentials[game.House],7:F2} | {current} /{threshold} | ({accounts}/{recommendation}) {jackpot.House}");
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
						} else if (signal.Acknowledged && signal.Timeout < DateTime.UtcNow) {
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
				// DateTime OldestUpdate = Game.QueueAge();

				TimeSpan QueryTime = DateTime.UtcNow.Subtract(Game.QueueAge());
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
			} catch (Exception ex) {
				StackTrace st = new(ex, true);
				StackFrame? frame = st.GetFrame(0);
				int line = frame != null ? frame.GetFileLineNumber() : 0;
				Console.WriteLine($"[{line}]Processing failed: {ex.Message}");
				Console.WriteLine(ex);
			}
		}
	}
}
