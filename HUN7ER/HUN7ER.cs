using System.Diagnostics;
using P4NTH30N.C0MMON;

namespace P4NTH30N;

class PROF3T {
	static void Main() {
		HUN7ER();
	}

	private static void HUN7ER() {
		while (true) {
			try {
				DateTime DateLimit = DateTime.UtcNow.AddDays(5);
				List<Credential> credentials = Credential.GetAll();
                Credential.IntroduceProperties();
                
				List<Game> games = Game.GetAll()
					.FindAll(x =>
						credentials.Any(y => x.House.Equals(y.House) && x.Name.Equals(y.Game))
					);

				credentials.ForEach(x => {
					if (x.Balance < 1 && x.CashedOut.Equals(false)) {
						x.CashedOut = true;
						x.Save();
					} else if (x.Balance > 3 && x.CashedOut) {
						x.LastDepositDate = DateTime.UtcNow;
						x.CashedOut = false;
						x.Save();
					} else {
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
							if (game.Jackpots.Grand != previousGrand) {
								if (game.Jackpots.Grand > previousGrand) {
									game.DPD.Data.Add(new DPD_Data(game.Jackpots.Grand));
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
										&& game.DPD.History[^1].Data[^1].Grand <= previousGrand
									) {
										game.DPD.Data = [];
										game.DPD.Data.Add(new DPD_Data(game.Jackpots.Grand));
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
								// game.Thresholds.Grand -= 1F; game.Thresholds.Major -= 0.5F;
								// game.Thresholds.Minor -= 0.25F; game.Thresholds.Mini -= 0.1F;

								double DPM = game.DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
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

				List<Signal> signals = Signal.GetAll();
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
