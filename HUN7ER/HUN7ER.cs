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

                // Set CashedOut Toggle
                foreach (Credential credential in credentials) {
                    if (credential.Balance < 1 && credential.CashedOut.Equals(false)) {
                        credential.CashedOut = true;
                        credential.Save();
                    } else if (credential.Balance > 3 && credential.CashedOut) {
                        credential.LastDepositDate = DateTime.UtcNow;
                        credential.CashedOut = false;
                        credential.Save();
                    } else {
                        credential.Save();
                    }

                    if (credential.Enabled == true) {
                        // House house = House.Get(game.House);
                        if (credential.Unlocked == false && DateTime.UtcNow > credential.UnlockTimeout)
                            credential.Unlock();

                        double previousGrand = credential.DPD.Data.Count > 0 ? credential.DPD.Data[^1].Grand : 0;
                        if (credential.Jackpots.Grand != previousGrand) {
                            if (credential.Jackpots.Grand > previousGrand) {
                                credential.DPD.Data.Add(new DPD_Data(credential.Jackpots.Grand));
                                if (credential.DPD.Data.Count > 2) {
                                    float minutes = Convert.ToSingle(credential.DPD.Data[credential.DPD.Data.Count - 1].Timestamp.Subtract(credential.DPD.Data[0].Timestamp).TotalMinutes);
                                    double dollars = credential.DPD.Data[credential.DPD.Data.Count - 1].Grand - credential.DPD.Data[0].Grand;
                                    float days = minutes / Convert.ToSingle(TimeSpan.FromDays(1).TotalMinutes);
                                    double dollarsPerDay = dollars / days;

                                    if (dollarsPerDay > 5 && credential.DPD.History.Count.Equals(0) == false)
                                        credential.DPD.Average = credential.DPD.History.Average(x => x.Average);
                                    else
                                        credential.DPD.Average = dollarsPerDay; // Set the DPD for each Credential
                                }
                            } else {
                                if (credential.DPD.History.Count.Equals(0).Equals(false) && credential.DPD.History[^1].Data[^1].Grand <= previousGrand) {
                                    credential.DPD.Data = [];
                                    credential.DPD.Data.Add(new DPD_Data(credential.Jackpots.Grand));
                                    credential.DPD.Average = 0F;
                                } else {
                                    credential.DPD.History.Add(new DPD_History(credential.DPD.Average, credential.DPD.Data));
                                } // Resets the DPD
                            }
                            credential.Save();
                        }

                        if (credential.DPD.Average.Equals(0) && credential.DPD.History.Count > 0 && credential.DPD.History[^1].Average > 0.1) {
                            credential.DPD.Average = credential.DPD.History[^1].Average;
                        }

                        if (credential.DPD.Average > 0.1) {
                            // game.Thresholds.Grand -= 1F; game.Thresholds.Major -= 0.5F;
                            // game.Thresholds.Minor -= 0.25F; game.Thresholds.Mini -= 0.1F;

                            double DPM = credential.DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
                            double estimatedGrowth = DateTime.Now.Subtract(credential.LastUpdated).TotalMinutes * DPM;

                            if (credential.Settings.SpinGrand) {
                                double MinutesToGrand = Math.Max((credential.Thresholds.Grand - (credential.Jackpots.Grand + estimatedGrowth)) / DPM, 0);
                                new Jackpot(credential, "Grand", credential.Jackpots.Grand, credential.Thresholds.Grand, 4, DateTime.UtcNow.AddMinutes(MinutesToGrand)).Save();
                            }

                            if (credential.Settings.SpinMajor) {
                                double MinutesToMajor = Math.Max((credential.Thresholds.Major - (credential.Jackpots.Major + estimatedGrowth)) / DPM, 0);
                                new Jackpot(credential, "Major", credential.Jackpots.Major, credential.Thresholds.Major, 3, DateTime.UtcNow.AddMinutes(MinutesToMajor)).Save();
                            }

                            if (credential.Settings.SpinMinor) {
                                double MinutesToMinor = Math.Max((credential.Thresholds.Minor - (credential.Jackpots.Minor + estimatedGrowth)) / DPM, 0);
                                new Jackpot(credential, "Minor", credential.Jackpots.Minor, credential.Thresholds.Minor, 3, DateTime.UtcNow.AddMinutes(MinutesToMinor)).Save();
                            }

                            if (credential.Settings.SpinMini) {
                                double MinutesToMini = Math.Max((credential.Thresholds.Mini - (credential.Jackpots.Mini + estimatedGrowth)) / DPM, 0);
                                new Jackpot(credential, "Mini", credential.Jackpots.Mini, credential.Thresholds.Mini, 3, DateTime.UtcNow.AddMinutes(MinutesToMini)).Save();
                            }
                        }
                    }
                }

                List<Signal> signals = Signal.GetAll();
                List<Jackpot> jackpots = Jackpot
                    .GetAll()
                    .FindAll(x => x.EstimatedDate < DateLimit)
                    .FindAll(x =>
                        credentials.Any(y =>
                            y.Enabled && x.Game.Equals(y.Game) && x.Username.Equals(y.Username)
                        )
                    );

                List<Signal> qualified = [];
                List<Jackpot> predictions = [];
                foreach (Jackpot jackpot in jackpots) {
                    Credential credential = credentials.FindAll(g =>
                        g.Game == jackpot.Game && g.Username == jackpot.Username
                    )[0];
                    if (credential.Settings.SpinGrand.Equals(false) && jackpot.Category.Equals("Grand"))
                        continue;
                    if (credential.Settings.SpinMajor.Equals(false) && jackpot.Category.Equals("Major"))
                        continue;
                    if (credential.Settings.SpinMinor.Equals(false) && jackpot.Category.Equals("Minor"))
                        continue;
                    if (credential.Settings.SpinMini.Equals(false) && jackpot.Category.Equals("Mini"))
                        continue;

                    // Console.WriteLine(game.House);
                    if (credential.DPD.Average > 0.01) {
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
                        double daysToAdd = capacity / credential.DPD.Average;
                        int iterations = 1;
                        for (
                            DateTime i = jackpot.EstimatedDate.AddDays(daysToAdd);
                            i < DateLimit;
                            i = i.AddDays(daysToAdd)
                        ) {
                            predictions.Add(
                                new Jackpot(
                                    credential,
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

                        // List<Credential> gameCredentials = Credential
                        //     .GetAllEnabledFor(game)
                        //     .FindAll(x => x.CashedOut.Equals(false));
                        // double avgBalance =
                        //     gameCredentials.Count > 0 ? gameCredentials.Average(x => x.Balance) : 0;


                        if (
                            (
                                jackpot.Priority >= 2
                                && DateTime.UtcNow.AddHours(6) > jackpot.EstimatedDate
                                && jackpot.Threshold - jackpot.Current < 0.1
                                && credential.Balance >= 6
                            )
                            || (
                                jackpot.Priority >= 2
                                && DateTime.UtcNow.AddHours(4) > jackpot.EstimatedDate
                                && jackpot.Threshold - jackpot.Current < 0.1
                                && credential.Balance >= 4
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
                    }
                }

                Dictionary<string, double> potentials = [];
                Dictionary<string, int> recommendations = [];
                predictions.ForEach(
                    delegate (Jackpot jackpot) {
                        if (potentials.ContainsKey(jackpot.Username))
                            potentials[jackpot.Username] += jackpot.Threshold;
                        else
                            potentials.Add(jackpot.Username, jackpot.Threshold);
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
                            if (recommendations.TryGetValue(jackpot.Username, out int recommendation)) {
                                string current = string.Format($"{jackpot.Current:F2}").PadLeft(7);
                                string threshold = string.Format($"{jackpot.Threshold:F0}")
                                    .PadRight(4);
                                totalPotential += recommendations[jackpot.Username].Equals(0)
                                    ? 0
                                    : jackpot.Threshold;
                                Credential credential = credentials.FindAll(g =>
                                    g.Game == jackpot.Game && g.Username == jackpot.Username
                                )[0];
                                int accounts = credentials
                                    .FindAll(c =>
                                        c.Username == jackpot.Username && c.Game == jackpot.Game
                                    )
                                    .Count;
                                if (
                                    credential.Settings.Hidden.Equals(false)
                                    && (jackpot.Category.Equals("Mini") == false)
                                // && (jackpot.Category.Equals("Mini") && accounts.Equals(0)).Equals(false)
                                )
                                    Console.WriteLine(
                                        $"{(jackpot.Category.Equals("Mini") ? "----- " : jackpot.Category + " ").ToUpper()}| {jackpot.EstimatedDate.ToLocalTime().ToString("ddd MM/dd/yyyy HH:mm:ss").ToUpper()} | {credential.Game.Substring(0, 9)} | {credential.DPD.Average:F2} /day |{current} /{threshold}| ({accounts}) {credential.House}"
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

                TimeSpan QueryTime = DateTime.UtcNow.Subtract(Credential.QueueAge());
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
