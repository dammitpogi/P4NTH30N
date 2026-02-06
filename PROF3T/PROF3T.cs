using System.Diagnostics;
using System.Drawing;
using System.Text.Json;
using MongoDB.Bson;
using MongoDB.Driver;
using OpenQA.Selenium.Chrome;
using P4NTH30N.C0MMON;
using static System.Runtime.InteropServices.JavaScript.JSType;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.Rebar;

namespace P4NTH30N;

class PROF3T {
	static void Main() {
		// ===========================================================================================================
		//  SAFETY FIRST: READ BEFORE RUNNING
		// -----------------------------------------------------------------------------------------------------------
		//  1) This file contains ADMIN COMMANDS that can mutate or wipe data (ex: ResetGames, ClearBalances, etc.).
		//  2) Default state must keep ALL admin commands commented out.
		//  3) If you are running a test, uncomment ONLY the single intended test call.
		//  4) After the run, re-comment the test call immediately.
		//  5) If you are unsure whether a call is safe, DO NOT run it.
		// ===========================================================================================================

		// ===========================================
		// SAFE TESTS (read-only or low-risk)
		// -------------------------------------------
		// Uncomment ONLY ONE test below at a time.
		// ===========================================
		// FireKirinBalanceTest();
		// OrionStarsBalanceTest();
		// LaunchBrowser();
		// TestSignals("FireKirin");
		//AnalyzeBiggestAccounts();
		// PrioritizeTesting("OrionStars");
		// InspectN3XT();

		//         // UpdateN3XT();

		// ===========================================
		// ADMIN / DATA-MUTATING COMMANDS (DANGEROUS)
		// -------------------------------------------
		// These can change or wipe data. Keep OFF unless explicitly requested.
		// ===========================================
		// Test2();
		// CreateHouses();
		// SeperateAllGames();
		// DisableEmptyGames();
		// UpdateCredentials();
		ResetGames();
		// sandbox();
		// BurnAccount("ShariNor55", "123qwe");
		// ResetSignalsTest("FireKirin");

		// Sandbox();C:\OneDrive\Auto-Firekirin\resource_override_rules.json


		// RemoveInvalidDPD_Date();
		// CheckSignals();
		// SetThresholdsToDefault();
		// GamesWithNoCredentials();
		// ClearBalances();
		// ResetDPD();
		// FixDPD();
		// Fix();p
	}

	private static void UpdateN3XT() {
		try {
			Console.WriteLine("Updating N3XT view...");
			var db = new Database().IO;
			
			// Drop existing view
			try {
				db.DropCollection("N3XT");
				Console.WriteLine("Dropped existing N3XT view.");
			} catch (Exception ex) {
				Console.WriteLine($"Error dropping view (might not exist): {ex.Message}");
			}

			// Define pipeline
			var pipeline = new BsonDocument[] {
				BsonDocument.Parse("{ $match: { Unlocked: true } }"),
				// Lookup G4ME
				BsonDocument.Parse(@"{ $lookup: {
					from: 'G4ME',
					let: { qHouse: '$House', qGame: '$Game' },
					pipeline: [ { $match: { $expr: { $and: [ { $eq: ['$House', '$$qHouse'] }, { $eq: ['$Name', '$$qGame'] } ] } } } ],
					as: 'G'
				}}"),
				BsonDocument.Parse("{ $unwind: '$G' }"),
				// PRUNE: Exclude disabled games
				BsonDocument.Parse("{ $match: { 'G.Enabled': true } }"),
				// CALCULATE URGENCY
				BsonDocument.Parse(@"{ $addFields: {
					Urgency: {
						$add: [
							1,
							{ $cond: ['$Jackpot3H', 100, 0] },
							{ $cond: ['$Jackpot12H', 20, 0] },
							{ $cond: ['$JackpotDay', 5, 0] },
							{ $cond: ['$Overdue', 2, 0] }
						]
					}
				}}"),
				// CALCULATE SORT KEY (Time + Interval / Urgency)
				BsonDocument.Parse(@"{ $addFields: {
					SortKey: {
						$add: [
							'$Updated',
							{ $multiply: [
								3600000,
								{ $divide: [ 
									1, 
									{ $multiply: [
										'$Urgency', 
										{ $add: [ 1, { $divide: [ { $ifNull: ['$G.DPD.Average', 0] }, 100 ] } ] }
									]}
								] }
							]}
						]
					}
				}}"),
				BsonDocument.Parse("{ $sort: { SortKey: 1 } }"),
				BsonDocument.Parse("{ $limit: 1 }"),
				BsonDocument.Parse("{ $replaceRoot: { newRoot: '$G' } }")
			};

            // Attempt to find the queue collection name
            var collections = db.ListCollectionNames().ToList();
            var queueName = collections.FirstOrDefault(c => c.Contains("QU3EU"));
            if (string.IsNullOrEmpty(queueName)) {
                 // Fallback to documented name
                 queueName = " QU3UE"; 
            }
            Console.WriteLine($"Using queue collection: '{queueName}'");

			db.CreateView<BsonDocument, BsonDocument>("N3XT", queueName, pipeline);
			Console.WriteLine("Successfully created N3XT view with DPD priority.");

		} catch (Exception ex) {
			Console.WriteLine($"Failed to update N3XT: {ex}");
		}
	}


	private static void FireKirinBalanceTest() {
		var result = FireKirin.QueryBalances("PaulcelFK", "abc123");
		Console.WriteLine(
			$"Balance={result.Balance}, Grand={result.Grand}, Major={result.Major}, Minor={result.Minor}, Mini={result.Mini}"
		);
	}

	private static void OrionStarsBalanceTest() {
		var result = OrionStars.QueryBalances("PaulCelebrado", "abc12345");
		Console.WriteLine(
			$"Balance={result.Balance}, Grand={result.Grand}, Major={result.Major}, Minor={result.Minor}, Mini={result.Mini}"
		);
	}

static void ResetGames()
    {
        List<Credential> cr = Credential.GetAll();
        foreach (Credential credential in cr)
        {
            credential.DPD.Average = 0;
            credential.DPD.History = [];
            
            // Target specific elements within DPD.Data array
            if (credential.DPD.Data != null)
            {
                // Remove elements with insane values, keep original timestamps
                credential.DPD.Data = credential.DPD.Data
                    .Where(dpd => dpd.Grand >= 0 && dpd.Grand <= 10000) // Filter out insane values
                    .ToList();
            }
            
            credential.Balance = 0;
            credential.Save();
        }
        
        List<Game> games = Game.GetAll();
        foreach (Game game in games)
        {
            game.DPD.Average = 0;
            game.DPD.History = [];
            
            // Target specific elements within DPD.Data array
            if (game.DPD.Data != null)
            {
                // Remove elements with insane values, keep original timestamps
                game.DPD.Data = game.DPD.Data
                    .Where(dpd => dpd.Grand >= 0 && dpd.Grand <= 10000) // Filter out insane values
                    .ToList();
            }
            
            game.Save();
        }
    }
	private static void Test2() {
		//List<House> houses = House.GetAll();
		//foreach (House house in houses.ToList()) {
		//	house.Name = house.Name.TrimEnd('0', '1', '2', '3', '4', '5', '6', '7', '8', '9').TrimEnd('#').Trim();
		//	house.URL = house.URL.TrimEnd('#').TrimEnd('/');

		//	List<House> duplicates = houses.FindAll(x => x.URL == house.URL && x._id != house._id).ToList();
		//	if (duplicates.Count > 0 && house.Description == "") {
		//		houses.RemoveAll(x => x._id == house._id);
		//		house.Delete();
		//	} else {!
		//		house.Save();
		//	}
		//}

		List<Credential> oldCredentials = Credential.Database();
		foreach (Credential oldCredential in oldCredentials) {
			if (!oldCredential.URL.Equals(string.Empty)) {
				NewCredential? credential =
					NewCredential.GetBy.Username(oldCredential.Game, oldCredential.Username);
				Game? game = Game.Get(oldCredential.House, oldCredential.Game);

				if (game != null) {
					if (credential == null) {
						credential = new NewCredential(oldCredential.Game) {
							URL = oldCredential.URL,
							House = oldCredential.House,
							Username = oldCredential.Username,
							Password = oldCredential.Password,
							Enabled = oldCredential.Enabled,
							Balance = oldCredential.Balance
						};

						credential.Toggles.Banned = oldCredential.Banned;
						credential.Toggles.CashedOut = credential.Toggles.CashedOut;

						credential.Jackpots.Grand = oldCredential.Jackpots.Grand;
						credential.Jackpots.Major = oldCredential.Jackpots.Major;
						credential.Jackpots.Minor = oldCredential.Jackpots.Minor;
						credential.Jackpots.Mini = oldCredential.Jackpots.Mini;

						credential.Dates.CreateDate = oldCredential.CreateDate;
						credential.Dates.LastUpdated = oldCredential.LastUpdated;
						credential.Dates.UnlockTimeout = oldCredential.UnlockTimeout;
						credential.Dates.LastDepositDate = oldCredential.LastDepositDate ?? DateTime.MinValue;

						credential.Settings.FortunePiggy.Page = oldCredential.Settings.FortunePiggy.Page;
						credential.Settings.FortunePiggy.Button_X = oldCredential.Settings.FortunePiggy.Button_X;
						credential.Settings.FortunePiggy.Button_Y = oldCredential.Settings.FortunePiggy.Button_Y;
						credential.Settings.FortunePiggy.ButtonVerified = oldCredential.Settings.FortunePiggy.ButtonVerified;

						credential.Settings.Quintuple5X.Page = oldCredential.Settings.Quintuple5X.Page;
						credential.Settings.Quintuple5X.Button_X = oldCredential.Settings.Quintuple5X.Button_X;
						credential.Settings.Quintuple5X.Button_Y = oldCredential.Settings.Quintuple5X.Button_Y;
						credential.Settings.Quintuple5X.ButtonVerified = oldCredential.Settings.Quintuple5X.ButtonVerified;

						credential.Settings.Gold777.Page = oldCredential.Settings.Gold777.Page;
						credential.Settings.Gold777.Button_X = oldCredential.Settings.Gold777.Button_X;
						credential.Settings.Gold777.Button_Y = oldCredential.Settings.Gold777.Button_Y;
						credential.Settings.Gold777.ButtonVerified = oldCredential.Settings.Gold777.ButtonVerified;

						credential.Settings.SpinGrand = oldCredential.Settings.SpinGrand;
						credential.Settings.SpinMajor = oldCredential.Settings.SpinMajor;
						credential.Settings.SpinMinor = oldCredential.Settings.SpinMinor;
						credential.Settings.SpinMini = oldCredential.Settings.SpinMini;
						credential.Settings.Hidden = oldCredential.Settings.Hidden;

						credential.Save();
					}


					House? house = House.Get(credential.URL);
					if (house == null) {
						house = new(credential.House, credential.URL);
					} else {
						house.Name = credential.House;
					}
					house.Save();


					if (credential.Enabled) {
						if (credential.Settings.SpinGrand) {
							NewJackpot grand = new("Grand", credential);
							Jackpot? oldGrand = Jackpot.Get("Grand", credential.House, credential.Game);
							if (oldGrand != null) {
								grand.DPM = oldGrand.DPM;
								grand.Dates.EstimatedDate = oldGrand.EstimatedDate;
							}
							grand.DPD.Average = game.DPD.Average;
							grand.Threshold = game.Thresholds.Grand;
							grand.Current = credential.Jackpots.Grand;
							game.DPD.Data.ForEach(dpd_data => grand.DPD.Data.Add(new(dpd_data.Grand) { Timestamp = dpd_data.Timestamp }));
							foreach (DPD_History history in game.DPD.History) {
								List<NewDPD_Data> data = [];
								foreach (DPD_Data dpd_data in history.Data) {
									data.Add(new(dpd_data.Grand) { Timestamp = dpd_data.Timestamp });
								}
								grand.DPD.History.Add(new(history.Average, data));
							}
							grand.Toggles.EnoughDataCollected = true;
							grand.Dates.LastUpdated = game.LastUpdated;
							grand.Dates.ResetDate = game.DPD.Data.Count > 0 ? game.DPD.Data[0].Timestamp : game.LastUpdated;
							grand.Save();
						}

						if (credential.Settings.SpinMajor) {
							NewJackpot major = new("Major", credential);
							Jackpot? oldMajor = Jackpot.Get("Major", credential.House, credential.Game);
							if (oldMajor != null) {
								major.Dates.EstimatedDate = oldMajor.EstimatedDate;
							}
							major.DPD.Data.Add(new(credential.Jackpots.Major) { Timestamp = game.LastUpdated });
							major.Dates.LastUpdated = game.LastUpdated;
							major.Current = credential.Jackpots.Major;
							major.Dates.ResetDate = game.LastUpdated;
							major.Threshold = game.Thresholds.Major;
							major.Save();
						}

						if (credential.Settings.SpinMinor) {
							NewJackpot minor = new("Minor", credential);
							Jackpot? oldMinor = Jackpot.Get("Minor", credential.House, credential.Game);
							if (oldMinor != null) {
								minor.Dates.EstimatedDate = oldMinor.EstimatedDate;
							}
							minor.DPD.Data.Add(new(credential.Jackpots.Minor) { Timestamp = game.LastUpdated });
							minor.Dates.LastUpdated = game.LastUpdated;
							minor.Current = credential.Jackpots.Minor;
							minor.Dates.ResetDate = game.LastUpdated;
							minor.Threshold = game.Thresholds.Minor;
							minor.Save();
						}

						if (credential.Settings.SpinMini) {
							NewJackpot mini = new("Mini", credential);
							Jackpot? oldMini = Jackpot.Get("Mini", credential.House, credential.Game);
							if (oldMini != null) {
								mini.Dates.EstimatedDate = oldMini.EstimatedDate;
							}
							mini.DPD.Data.Add(new(credential.Jackpots.Mini) { Timestamp = game.LastUpdated });
							mini.Dates.LastUpdated = game.LastUpdated;
							mini.Current = credential.Jackpots.Mini;
							mini.Dates.ResetDate = game.LastUpdated;
							mini.Threshold = game.Thresholds.Mini;
							mini.Save();
						}
					}
				}
			}
		}
	}

	// private static void Test() {
	//     Signal? signal = Signal.GetNext();
	//     Game game = (signal == null) ? Game.GetNext() : Game.Get(signal.House, signal.Game);
	//     Credential? credential = (signal == null) ? Credential.GetBy(game)[0] : Credential.GetBy(game, signal.Username);
	//     Console.WriteLine(credential);
	// }

	// private static void CreateHouses() {
	//     // List<House> houses = House.GetAll();
	//     // Console.WriteLine($"{houses.Count} Houses retrieved and removed.");
	//     // House.DeleteAll();

	//     List<Credential> credentials = Credential.GetAll();
	//     foreach (Credential credential in credentials) {
	//         if (credential.Enabled && (credential.URL != null || credential.URL != string.Empty)) {
	//             if (House.Get(credential.URL) == null) {
	//                 Console.WriteLine($"{credential.House} Created.");
	//                 House dto = new House(credential.House, credential.URL);

	//                 // List<House> oldHouse = houses.FindAll(x => x.URL == dto.URL).ToList();
	//                 // if (oldHouse.Count == 0) oldHouse = houses.FindAll(x => x.Name == dto.Name).ToList();
	//                 // if (oldHouse.Count > 0) {
	//                 //     dto.Description = oldHouse[0].Description;
	//                 //     dto.Redemption = oldHouse[0].Redemption;
	//                 //     dto.OffLimits = oldHouse[0].OffLimits;
	//                 //     dto.Comments = oldHouse[0].Comments;
	//                 //     dto.Lifespan = oldHouse[0].Lifespan;
	//                 // }

	//                 dto.Save();
	//             }
	//         }
	//     }
	// }

	// private static void UpdateCredentials() {
	//     List<Credential> credentials = Credential.GetAll();
	//     foreach (Credential credential in credentials) {
	//         Game? game = Game.GetBy.House(credential.House);
	//         if (game != null) {
	//             // if (credential.Jackpots == null || (credential.Jackpots.Grand != game.Jackpots.Grand)) {
	//             Credential dto = new Credential() {
	//                 _id = ObjectId.GenerateNewId(),
	//                 Game = credential.Game,
	//                 House = credential.House,
	//                 URL = string.Empty,
	//                 CreateDate = credential.CreateDate,
	//                 LastUpdated = game.LastUpdated,
	//                 LastDepositDate = credential.LastDepositDate,
	//                 Username = credential.Username,
	//                 Password = credential.Password,
	//                 Thresholds = game.Thresholds,
	//                 Jackpots = game.Jackpots,
	//                 Settings = game.Settings,
	//                 CashedOut = credential.CashedOut,
	//                 Unlocked = credential.Unlocked,
	//                 Banned = credential.Banned,
	//                 Enabled = credential.Enabled,
	//                 DPD = game.DPD,
	//                 Balance = credential.Balance
	//             };
	//             // House? house = House.Get(credential.House);
	//             // if (house != null) dto.URL = house.FacebookURL;
	//             credential.Delete();
	//             dto.Save();
	//         }
	//     }
	// }
	// private static void DisableEmptyGames() {
	//     List<Game> games = Game.GetAll();
	//     foreach (Game game in games) {
	//         List<Credential> credentials = Credential.GetBy(game);
	//         if (credentials.FindAll(c => c.Enabled).Count == 0) {
	//             game.Enabled = false;
	//             game.Save();
	//         }
	//     }
	// }
	// private static void SeperateAllGames() {
	//     List<Game> games = Game.GetAll();
	//     foreach (Game game in games) {
	//         List<Credential> credentials = Credential.GetBy(game);
	//         int offSet = 1;
	//         for (int i = 1; i < credentials.Count; i++) {

	//             Credential dto = credentials[i];
	//             string newHouse = $"{dto.House} {i + 1}";
	//             while (Game.Get(newHouse, dto.Game, false) != null) {
	//                 newHouse = $"{dto.House} {i + 1 + offSet++}";
	//             }

	//             dto.House = newHouse; dto.Save();
	//             game.House = newHouse; game.Save();
	//         }
	//     }
	// }

	// private static void ResetSignalsTest(string Platform) {
	//     List<Game> games = Game.GetAll();
	//     games.ForEach(
	//         delegate (Game game) {
	//             //if (game.Settings.Gold777 == null) game.Settings.Gold777 = new Gold777_Settings();
	//             //if (game.Settings.Gold777.ButtonVerified == false) {
	//             if (game.Name == Platform) {
	//                 //Gold777_Settings x = game.Settings.Gold777;
	//                 //if (x.Page == 10 && x.Button_X == 440 && x.Button_Y == 280) {
	//                 //game.Settings.Gold777.Button_X = 860;
	//                 //game.Settings.Gold777.Button_Y = 280;
	//                 //game.Settings.Gold777.Page = 10;
	//                 game.Settings.Gold777.ButtonVerified = false;
	//                 game.Save();
	//                 //}
	//             }
	//             //}
	//         }
	//     );
	// }

	// private static void TestSignals(string Platform) {
	//     while (true) {
	//         List<Game> games = Game.GetAll().FindAll(x => x.Name.Equals(Platform));
	//         games.OrderBy(game => game.LastUpdated);
	//         // double lastRetrievedGrand = 0.0;

	//         Mouse.Click(1279, 180);
	//         ChromeDriver driver = new();
	//         Mouse.Click(1024, 121);

	//         switch (Platform) {
	//             case "FireKirin":
	//                 driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
	//                 break;
	//             case "OrionStars":
	//                 driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
	//                 if (Screen.WaitForColor(new Point(510, 110), Color.FromArgb(255, 2, 119, 2), 60) == false)
	//                     throw new Exception("Took too long to load.");
	//                 Mouse.Click(535, 615);
	//                 break;
	//         }

	//         int iteration = 0;
	//         // Game lastGame = games[^1];
	//         foreach (Game game in games) {
	//             Console.WriteLine($"{DateTime.UtcNow} - Retrieving Game");
	//             Game retrievedGame = Game.Get(game.House, game.Name);
	//             // retrievedGame = Game.Get("Playing Bar", "FireKirin");
	//             // retrievedGame.Settings.Gold777.ButtonVerified = false;

	//             if (retrievedGame.Settings.Gold777.ButtonVerified == false && retrievedGame.Unlocked) {
	//                 Console.WriteLine($"{DateTime.UtcNow} - Retrieving Credential");
	//                 List<Credential> gameCredentials = Credential.GetBy(retrievedGame).Where(x => x.Enabled && x.Banned == false).ToList();
	//                 Credential? credential = gameCredentials.Count.Equals(0) ? null : gameCredentials[0];
	//                 Console.WriteLine($"{DateTime.UtcNow} - {retrievedGame.House}/{credential?.Username}");
	//                 if (credential != null) {
	//                     retrievedGame.Lock();
	//                     switch (retrievedGame.Name) {
	//                         case "FireKirin":
	//                             if (Screen.WaitForColor(new Point(999, 128), Color.FromArgb(255, 2, 125, 51), 30) == false) {
	//                                 throw new Exception("Took too long to load.");
	//                             }
	//                             bool loggedIn = false;
	//                             while (loggedIn == false) {
	//                                 loggedIn = driver.Login(credential.Username, credential.Password);
	//                             }

	//                             Color firstHallScreen = Screen.GetColorAt(new Point(293, 179));
	//                             while (firstHallScreen.Equals(Color.FromArgb(255, 253, 252, 253)) == false) {
	//                                 Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {firstHallScreen}");
	//                                 Thread.Sleep(500);
	//                                 firstHallScreen = Screen.GetColorAt(new Point(293, 179));
	//                             }
	//                             Mouse.Click(81, 233);
	//                             Thread.Sleep(800);
	//                             for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++) {
	//                                 Mouse.Click(937, 177);
	//                                 Thread.Sleep(800);
	//                             }
	//                             break;

	//                         case "OrionStars":
	//                             if (OrionStars.Login(driver, credential.Username, credential.Password) == false) {
	//                                 break;
	//                             }
	//                             Mouse.Click(80, 218);
	//                             for (int i = 1; i < retrievedGame.Settings.Gold777.Page; i++) {
	//                                 Mouse.Click(995, 375);
	//                                 Thread.Sleep(800);
	//                             }
	//                             break;
	//                     }

	//                     // Mouse.Move(retrievedGame.Settings.Gold777.Button_X, retrievedGame.Settings.Gold777.Button_Y);

	//                     // retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
	//                     Mouse.Click(retrievedGame.Settings.Gold777.Button_X, retrievedGame.Settings.Gold777.Button_Y);
	//                     Mouse.Click(retrievedGame.Settings.Gold777.Button_X, retrievedGame.Settings.Gold777.Button_Y);

	//                     int checkAttempts = 0;
	//                     bool buttonVerified = false;
	//                     while (checkAttempts <= 20 && buttonVerified == false) {
	//                         // Color splashScreen = Screen.GetColorAt(new Point(620, 305)); // FortunePiggy
	//                         // buttonVerified = splashScreen.Equals(Color.FromArgb(255, 252, 227, 227)); // FortunePiggy
	//                         Color splashScreen = Color.White;
	//                         switch (Platform) {
	//                             case "FireKirin":
	//                                 splashScreen = Screen.GetColorAt(new Point(316, 434)); // Gold777
	//                                 buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 183));
	//                                 break;
	//                             case "OrionStars":
	//                                 splashScreen = Screen.GetColorAt(new Point(314, 432)); // Gold777
	//                                 buttonVerified = splashScreen.Equals(Color.FromArgb(255, 255, 255, 194));
	//                                 break;
	//                         }
	//                         Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {splashScreen}");
	//                         Thread.Sleep(500);
	//                         checkAttempts++;
	//                     }

	//                     if (buttonVerified) {
	//                         retrievedGame = Game.Get(retrievedGame.House, retrievedGame.Name);
	//                         retrievedGame.Settings.Gold777.ButtonVerified = true;
	//                         retrievedGame.Save();
	//                     }
	//                     switch (Platform) {
	//                         case "FireKirin":
	//                             driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
	//                             Screen.WaitForColor(new Point(293, 179), Color.FromArgb(255, 253, 252, 253));
	//                             break;
	//                         case "OrionStars":
	//                             driver.Navigate().GoToUrl("http://web.orionstars.org/hot_play/orionstars/");
	//                             Screen.WaitForColor(new Point(715, 128), Color.FromArgb(255, 254, 242, 181));
	//                             break;
	//                     }

	//                     Color hallScreen = Screen.GetColorAt(new Point(294, 171));
	//                     while (hallScreen.Equals(Color.FromArgb(255, 0, 130, 55)) == false) {
	//                         Console.WriteLine($"{iteration + 1} {retrievedGame.House} - {hallScreen}");
	//                         Thread.Sleep(500);
	//                         hallScreen = Screen.GetColorAt(new Point(294, 171));
	//                     }

	//                     // int grandChecked = 0;
	//                     // double currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;

	//                     // while (currentGrand.Equals(0) || (lastRetrievedGrand.Equals(currentGrand) && game.Name != lastGame.Name && game.House != lastGame.House)) {
	//                     //     Thread.Sleep(500);
	//                     //     if (grandChecked++ > 40) {
	//                     //         throw new Exception("Extension failure.");
	//                     //     }
	//                     //     currentGrand = Convert.ToDouble(driver.ExecuteScript("return window.parent.Grand")) / 100;
	//                     // }

	//                     // double currentMajor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Major")) / 100;
	//                     // double currentMinor = Convert.ToDouble(driver.ExecuteScript("return window.parent.Minor")) / 100;
	//                     // double currentMini = Convert.ToDouble(driver.ExecuteScript("return window.parent.Mini")) / 100;

	//                     // if ((lastRetrievedGrand.Equals(currentGrand) && game.Name != lastGame.Name && game.House != lastGame.House) == false) {
	//                     //     Signal? gameSignal = Signal.GetOne(game);
	//                     //     if (currentGrand < game.Jackpots.Grand && (game.Jackpots.Grand - currentGrand) > 0.1) {
	//                     //         if (game.DPD.Toggles.GrandPopped == true) {
	//                     //             game.Jackpots.Grand = currentGrand;
	//                     //             game.DPD.Toggles.GrandPopped = false;
	//                     //             game.Thresholds.NewGrand(game.Jackpots.Grand);
	//                     //             if (gameSignal != null && gameSignal.Priority.Equals(4))
	//                     //                 Signal.DeleteAll(game);
	//                     //         } else game.DPD.Toggles.GrandPopped = true;
	//                     //     } else game.Jackpots.Grand = currentGrand;

	//                     //     if (currentMajor < game.Jackpots.Major && (game.Jackpots.Major - currentMajor) > 0.1) {
	//                     //         if (game.DPD.Toggles.MajorPopped == true) {
	//                     //             game.Jackpots.Major = currentMajor;
	//                     //             game.DPD.Toggles.MajorPopped = false;
	//                     //             game.Thresholds.NewMajor(game.Jackpots.Major);
	//                     //             if (gameSignal != null && gameSignal.Priority.Equals(3))
	//                     //                 Signal.DeleteAll(game);
	//                     //         } else game.DPD.Toggles.MajorPopped = true;
	//                     //     } else game.Jackpots.Major = currentMajor;

	//                     //     if (currentMinor < game.Jackpots.Minor && (game.Jackpots.Minor - currentMinor) > 0.1) {
	//                     //         if (game.DPD.Toggles.MinorPopped == true) {
	//                     //             game.Jackpots.Minor = currentMinor;
	//                     //             game.DPD.Toggles.MinorPopped = false;
	//                     //             game.Thresholds.NewMinor(game.Jackpots.Minor);
	//                     //             if (gameSignal != null && gameSignal.Priority.Equals(2))
	//                     //                 Signal.DeleteAll(game);
	//                     //         } else game.DPD.Toggles.MinorPopped = true;
	//                     //     } else game.Jackpots.Minor = currentMinor;

	//                     //     if (currentMini < game.Jackpots.Mini && (game.Jackpots.Mini - currentMini) > 0.1) {
	//                     //         if (game.DPD.Toggles.MiniPopped == true) {
	//                     //             game.Jackpots.Mini = currentMini;
	//                     //             game.DPD.Toggles.MiniPopped = false;
	//                     //             game.Thresholds.NewMini(game.Jackpots.Mini);
	//                     //             if (gameSignal != null && gameSignal.Priority.Equals(1))
	//                     //                 Signal.DeleteAll(game);
	//                     //         } else game.DPD.Toggles.MiniPopped = true;
	//                     //     } else game.Jackpots.Mini = currentMini;

	//                     // } else {
	//                     //     throw new Exception("Invalid grand retrieved.");
	//                     // }

	//                     // credential.Balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
	//                     // credential.LastUpdated = DateTime.UtcNow;
	//                     // lastRetrievedGrand = currentGrand;

	//                     // credential.Save();
	//                     // retrievedGame.Unlock();
	//                     // lastGame = retrievedGame;

	//                     switch (Platform) {
	//                         case "FireKirin":
	//                             // for (int i = 0; i < retrievedGame.Settings.Gold777.Page; i++) {
	//                             //     Mouse.Click(880, 177); Thread.Sleep(800);
	//                             // }
	//                             Mouse.Click(81, 233);
	//                             Thread.Sleep(800);
	//                             FireKirin.Logout();
	//                             break;
	//                         case "OrionStars":
	//                             Mouse.Click(80, 218);
	//                             Thread.Sleep(800);
	//                             OrionStars.Logout(driver);
	//                             break;
	//                     }
	//                 }
	//             }
	//         }
	//         ;
	//         driver.Quit();
	//     }
	// }

	private static void LaunchBrowser() {
		ChromeDriver driver = Actions.Launch();
	}

	private static void AnalyzeBiggestAccounts() {
		Console.WriteLine("=== P4NTH30N BIGGEST ACCOUNTS ANALYSIS ===");
		Console.WriteLine($"Analysis Date: {DateTime.Now:yyyy-MM-dd HH:mm:ss} UTC");
		Console.WriteLine();

		// 1. TOP ACCOUNTS BY BALANCE
		Console.WriteLine("=== TOP 20 ACCOUNTS BY BALANCE ===");
		List<Credential> topAccounts = Credential.GetAll().Take(20).ToList();
		for (int i = 0; i < topAccounts.Count; i++) {
			var cred = topAccounts[i];
			Console.WriteLine($"{i + 1,2}. Balance: {cred.Balance,8:F2} | House: {cred.House,-20} | Game: {cred.Game,-12} | User: {cred.Username,-15} | Enabled: {cred.Enabled,5} | Banned: {cred.Banned,5}");
		}
		Console.WriteLine();

		// 2. HOUSE-LEVEL ACCOUNT DISTRIBUTION
		Console.WriteLine("=== ACCOUNT DISTRIBUTION BY HOUSE ===");
		var houseGroups = Credential.GetAll()
			.GroupBy(c => c.House)
			.Select(g => new {
				House = g.Key,
				TotalAccounts = g.Count(),
				EnabledAccounts = g.Count(c => c.Enabled && !c.Banned),
				TotalBalance = g.Sum(c => c.Balance),
				AvgBalance = g.Average(c => c.Balance),
				MaxBalance = g.Max(c => c.Balance)
			})
			.OrderByDescending(h => h.TotalBalance)
			.ToList();

		foreach (var house in houseGroups) {
			Console.WriteLine($"House: {house.House,-25} | Total: {house.TotalAccounts,3} | Active: {house.EnabledAccounts,3} | Balance: {house.TotalBalance,10:F2} | Avg: {house.AvgBalance,7:F2} | Max: {house.MaxBalance,8:F2}");
		}
		Console.WriteLine();

		// 3. GAME-LEVEL ANALYSIS
		Console.WriteLine("=== GAME PLATFORM ANALYSIS ===");
		var gameGroups = Credential.GetAll()
			.GroupBy(c => c.Game)
			.Select(g => new {
				Game = g.Key,
				TotalAccounts = g.Count(),
				EnabledAccounts = g.Count(c => c.Enabled && !c.Banned),
				TotalBalance = g.Sum(c => c.Balance),
				AvgBalance = g.Average(c => c.Balance),
				MaxBalance = g.Max(c => c.Balance)
			})
			.OrderByDescending(g => g.TotalBalance)
			.ToList();

		foreach (var game in gameGroups) {
			Console.WriteLine($"Game: {game.Game,-15} | Total: {game.TotalAccounts,3} | Active: {game.EnabledAccounts,3} | Balance: {game.TotalBalance,10:F2} | Avg: {game.AvgBalance,7:F2} | Max: {game.MaxBalance,8:F2}");
		}
		Console.WriteLine();

		// 4. HIGH-VALUE ACCOUNTS (Balance > $100)
		Console.WriteLine("=== HIGH-VALUE ACCOUNTS (Balance > $100) ===");
		var highValueAccounts = Credential.GetAll().Where(c => c.Balance > 100).OrderByDescending(c => c.Balance).ToList();
		Console.WriteLine($"Total High-Value Accounts: {highValueAccounts.Count}");
		Console.WriteLine($"Total Value in High-Value Accounts: ${highValueAccounts.Sum(c => c.Balance):F2}");
		Console.WriteLine();

		for (int i = 0; i < Math.Min(10, highValueAccounts.Count); i++) {
			var cred = highValueAccounts[i];
			Console.WriteLine($"{i + 1,2}. Balance: ${cred.Balance,8:F2} | House: {cred.House,-20} | Game: {cred.Game,-12} | User: {cred.Username,-15}");
		}
		Console.WriteLine();

		// 5. DPD GROWTH ANALYSIS
		Console.WriteLine("=== DPD GROWTH LEADERS ===");
		var dpdLeaders = Credential.GetAll()
			.Where(c => c.DPD.Average > 0)
			.OrderByDescending(c => c.DPD.Average)
			.Take(15)
			.ToList();

		Console.WriteLine("Top 15 Accounts by DPD Growth Rate:");
		for (int i = 0; i < dpdLeaders.Count; i++) {
			var cred = dpdLeaders[i];
			Console.WriteLine($"{i + 1,2}. DPD: {cred.DPD.Average,8:F2}/day | Balance: ${cred.Balance,8:F2} | House: {cred.House,-20} | Game: {cred.Game,-12} | User: {cred.Username,-15}");
		}
		Console.WriteLine();

		// 6. JACKPOT POTENTIAL ANALYSIS
		Console.WriteLine("=== JACKPOT POTENTIAL BY HOUSE ===");
		var jackpotData = Game.GetAll()
			.GroupBy(g => g.House)
			.Select(g => new {
				House = g.Key,
				TotalGrandPotential = g.Sum(x => x.Thresholds.Grand),
				TotalMajorPotential = g.Sum(x => x.Thresholds.Major),
				TotalMinorPotential = g.Sum(x => x.Thresholds.Minor),
				TotalMiniPotential = g.Sum(x => x.Thresholds.Mini),
				CurrentGrand = g.Sum(x => x.Jackpots.Grand),
				CurrentMajor = g.Sum(x => x.Jackpots.Major),
				AvgDPD = g.Average(x => x.DPD.Average)
			})
			.OrderByDescending(h => h.TotalGrandPotential)
			.ToList();

		foreach (var house in jackpotData) {
			double totalPotential = house.TotalGrandPotential + house.TotalMajorPotential + house.TotalMinorPotential + house.TotalMiniPotential;
			Console.WriteLine($"House: {house.House,-25} | Potential: ${totalPotential,8:F2} | Grand: ${house.TotalGrandPotential,7:F2} | Major: ${house.TotalMajorPotential,6:F2} | Minor: ${house.TotalMinorPotential,6:F2} | Mini: ${house.TotalMiniPotential,5:F2} | DPD: {house.AvgDPD,6:F2}/day");
		}
		Console.WriteLine();

		// 7. SUMMARY STATISTICS
		Console.WriteLine("=== SUMMARY STATISTICS ===");
		var allCredentials = Credential.GetAll();
		var enabledCredentials = allCredentials.Where(c => c.Enabled && !c.Banned).ToList();
		Console.WriteLine($"Total Accounts: {allCredentials.Count}");
		Console.WriteLine($"Enabled/Active Accounts: {enabledCredentials.Count}");
		Console.WriteLine($"Total Balance Across All Accounts: ${allCredentials.Sum(c => c.Balance):F2}");
		Console.WriteLine($"Average Balance Per Account: ${allCredentials.Average(c => c.Balance):F2}");
		Console.WriteLine($"Total Houses: {houseGroups.Count}");
		Console.WriteLine($"Total Games: {gameGroups.Count}");
		Console.WriteLine($"Accounts with DPD Growth: {allCredentials.Count(c => c.DPD.Average > 0)}");
		Console.WriteLine($"Average DPD Growth: ${allCredentials.Average(c => c.DPD.Average):F2}/day");
		Console.WriteLine();

		Console.WriteLine("=== ANALYSIS COMPLETE ===");
	}
	// private static void sandbox() {
	//     List<Game> games = Game.GetAll();
	//     foreach (Game game in games) {
	//         game.Thresholds.Grand = game.Thresholds.Grand - 0.2;
	//         game.Save();
	//     }

	//     // List<int> History = [];
	//     // Dictionary<int, int> Occurences = [];
	//     // History =
	//     // [
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     0,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     1,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     2,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     3,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     4,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     5,
	//     //     6,
	//     //     6,
	//     //     6,
	//     //     6,
	//     //     6,
	//     //     6,
	//     //     7,
	//     //     7,
	//     //     7,
	//     //     7,
	//     //     8,
	//     //     8,
	//     //     8,
	//     //     8,
	//     //     9,
	//     //     9,
	//     //     9,
	//     //     10,
	//     //     10,
	//     //     11,
	//     //     12,
	//     //     12,
	//     //     12,
	//     //     12,
	//     //     14,
	//     //     14,
	//     //     14,
	//     // ];
	//     // History.ForEach(Spins => {
	//     //     if (Occurences.Any(x => x.Key == Spins))
	//     //         Occurences[Spins] = Occurences[Spins] + 1;
	//     //     else
	//     //         Occurences.Add(Spins, 1);
	//     // });
	//     // List<string> log = [];
	//     // int y = 0,
	//     //     rows = 4;
	//     // for (int i = 0; i < rows; i++) {
	//     //     log.Add("");
	//     // }
	//     // Occurences
	//     //     .ToList()
	//     //     .ForEach(x => {
	//     //         log[y] = log[y] = $"{(log[y].Length.Equals(0) ? "" : log[y] + " | ")}{x.Key,2}: {x.Value,-3}";
	//     //         y++;
	//     //         if (y.Equals(rows))
	//     //             y = 0;
	//     //     });
	//     // log.ToList().ForEach(Console.WriteLine);
	//     // Console.WriteLine();
	// }

	// private static void BurnAccount(string Username, string Password) {
	//     ChromeDriver driver = Actions.Launch();
	//     Mouse.Click(1026, 122);
	//     driver.Navigate().GoToUrl("http://play.firekirin.in/web_mobile/firekirin/");
	//     Mouse.RtClick(182, 30);
	//     Mouse.Click(243, 268);
	//     Color loginScreen = Screen.GetColorAt(new Point(999, 128));
	//     while (loginScreen.Equals(Color.FromArgb(255, 2, 125, 51)) == false) {
	//         Thread.Sleep(500);
	//         loginScreen = Screen.GetColorAt(new Point(999, 128));
	//     }
	//     bool loggedIn = false;
	//     while (loggedIn == false) {
	//         loggedIn = driver.Login(Username, Password);
	//     }
	//     for (int i = 1; i < 10; i++) {
	//         Mouse.Click(937, 177);
	//         Thread.Sleep(800);
	//     }
	//     Mouse.Click(450, 450);
	//     Screen.WaitForColor(new Point(929, 612), Color.FromArgb(255, 253, 253, 14));
	//     double balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
	//     while (balance.Equals(0)) {
	//         Thread.Sleep(300);
	//         balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
	//     }

	//     bool Raised = false;
	//     int BadSpins = 0,
	//         AvgSpinsFTW = 0,
	//         Increase = 5,
	//         Capacity = 12;
	//     List<int> History =
	//     [
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         0,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         1,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         2,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         3,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         4,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         5,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         6,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         7,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         8,
	//         9,
	//         9,
	//         9,
	//         9,
	//         9,
	//         9,
	//         10,
	//         10,
	//         11,
	//         11,
	//         11,
	//         12,
	//         12,
	//         12,
	//         12,
	//         13,
	//         14,
	//         14,
	//         14,
	//         15,
	//         16,
	//         16,
	//         16,
	//         16,
	//         17,
	//         18,
	//     ];
	//     List<int> WorkingSet = [];

	//     //Console.WriteLine(balance);
	//     while (balance > 400 && balance < 600) {
	//         if (BadSpins.Equals(AvgSpinsFTW) && Raised.Equals(false) && WorkingSet.Count > Capacity) {
	//             for (int i = 1; i < Increase; i++) {
	//                 Mouse.Click(843, 623);
	//                 Thread.Sleep(400);
	//             }
	//             Raised = true;
	//         }

	//         double priorBalance = balance;
	//         Mouse.Click(877, 623);
	//         Thread.Sleep(300);
	//         Screen.WaitForColor(new Point(996, 614), Color.FromArgb(255, 244, 253, 7));
	//         Mouse.Click(877, 623);
	//         Thread.Sleep(300);
	//         Screen.WaitForColor(new Point(929, 612), Color.FromArgb(255, 253, 253, 14));
	//         balance = Convert.ToDouble(driver.ExecuteScript("return window.parent.Balance")) / 100;
	//         //Console.WriteLine($"                                                                                                                                                                                                                         {balance}");

	//         int logSpins = BadSpins;
	//         if (balance > priorBalance) {
	//             History.Add(BadSpins);
	//             WorkingSet.Add(BadSpins);
	//             AvgSpinsFTW = WorkingSet.GroupBy(i => i).OrderByDescending(grp => grp.Count()).Select(grp => grp.Key).First();
	//             if (WorkingSet.Count > 24)
	//                 WorkingSet.RemoveAt(0);
	//             BadSpins = 0;
	//         } else {
	//             BadSpins++;
	//         }

	//         Console.WriteLine($"Spins:{logSpins}, BetRaise: {Raised}, Bal:{balance}, Backup: {JsonSerializer.Serialize(History.Order())};");
	//         Dictionary<int, int> Occurences = [];
	//         if (BadSpins.Equals(0)) {
	//             History.ForEach(Spins => {
	//                 if (Occurences.Any(x => x.Key == Spins))
	//                     Occurences[Spins] = Occurences[Spins] + 1;
	//                 else
	//                     Occurences.Add(Spins, 1);
	//             });
	//             List<string> log = [];
	//             int y = 0,
	//                 rows = 4;
	//             for (int i = 0; i < rows; i++) {
	//                 log.Add("");
	//             }
	//             Occurences
	//                 .ToList()
	//                 .ForEach(x => {
	//                     log[y] = log[y] = $"{(log[y].Length.Equals(0) ? "" : log[y] + " | ")}{x.Key,2}: {x.Value,-3}";
	//                     y++;
	//                     if (y.Equals(rows))
	//                         y = 0;
	//                 });
	//             log.Sort();
	//             log.ToList().ForEach(Console.WriteLine);
	//             Console.WriteLine($"RaiseOn:{AvgSpinsFTW}, WorkingSet:{WorkingSet.Count}, History:{History.Count} ");
	//             Console.WriteLine();
	//         }

	//         if (Raised) {
	//             for (int i = 1; i < Increase; i++) {
	//                 Mouse.Click(702, 623);
	//                 Thread.Sleep(200);
	//             }
	//             Raised = false;
	//         }
	//     }
	//     driver.Quit();
	// }

	// private static void PrioritizeTesting(string Platform) {
	//     while (true) {
	//         List<Game> games = Game.GetAll();
	//         games.ForEach(
	//             delegate (Game game) {
	//                 game.Updated = game.Name.Equals(Platform).Equals(false);
	//                 game.Save();
	//             }
	//         );
	//         Thread.Sleep(TimeSpan.FromSeconds(60));
	//     }
	// }

	// private static void ResetDPD() {
	//     // var x = Game.GetNext();
	//     // var y = Credential.GetBy(x);
	//     // Console.WriteLine(y);
	//     // List<Game> games = Game.GetAll();
	//     // games.ForEach(delegate (Game game) {
	//     //     game.DPD = new DPD();
	//     //     game.Save();
	//     // });
	// }

	// private static void CheckSignals() {
	//     Game game = Game.GetNext();
	//     Credential credential = Credential.GetBy(game)[0];
	//     Signal signal = new Signal(100, credential);
	//     signal.Save();
	// }

	// private static void Fix() {
	//     List<Game> games = Game.GetAll();
	//     games.ForEach(
	//         delegate (Game game) {
	//             if (game.House.Equals("Candies GameRoom")) {
	//                 List<DPD_Data> data = game.DPD.History[^1].Data;
	//                 // game.DPD.Data.RemoveAt(0);
	//                 data.AddRange(game.DPD.Data);
	//                 game.DPD.Data = data;
	//                 game.Save();
	//             }
	//         }
	//     );
	// }

	// private static void Sandbox() {
	//     int dataCount = 0;
	//     List<Game> games = Game.GetAll();
	//     games.ForEach(
	//         delegate (Game game) {
	//             int count = game.DPD.Data.Count;
	//             dataCount = count > dataCount ? count : dataCount;
	//         }
	//     );
	//     Console.WriteLine(dataCount);
	// }

	// private static void GamesWithNoCredentials() {
	//     List<Game> games = Game.GetAll();
	//     List<Credential> gamesWithNoCredentials = [];
	//     List<Credential> credentials = Credential.Database();
	//     credentials.ForEach(
	//         delegate (Credential credential) {
	//             if (games.FindAll(c => c.House.Equals(credential.House)).Count.Equals(0)) {
	//                 Console.WriteLine($"[{gamesWithNoCredentials.Count}] - {credential.Username}");
	//                 Console.WriteLine($"[{credential.House}]");
	//                 gamesWithNoCredentials.Add(credential);
	//                 Console.WriteLine();
	//             }
	//         }
	//     );
	//     Console.WriteLine(gamesWithNoCredentials.Count);
	// }

	// private static void RemoveInvalidDPD_Date() {
	//     List<Game> games = Game.GetAll();
	//     // games.RemoveAll(game => game.DPD.Data[0].Grand < 0);
	//     games.ForEach(
	//         delegate (Game game) {
	//             if (game.DPD.Data[0].Grand < 0) {
	//                 game.DPD.Data.RemoveAll(Data => Data.Grand < 0);
	//                 game.Save();
	//             }
	//         }
	//     );
	// }

	// static void ClearBalances() {
	//     List<Credential> credentials = Credential.GetAll();
	//     credentials.ForEach(
	//         delegate (Credential credential) {
	//             credential.Balance = 0F;
	//             credential.Save();
	//         }
	//     );
	// }

	// static void SetThresholdsToDefault() {
	//     List<Game> games = Game.GetAll();
	//     games.ForEach(
	//         delegate (Game game) {
	//             game.Thresholds.Grand = 1785F;
	//             game.Thresholds.Major = 565F;
	//             game.Thresholds.Minor = 117F;
	//             game.Thresholds.Mini = 23F;
	//             // game.Thresholds.Data = new Thresholds_Data();
	//             game.Save();
	//         }
	//     );
	// }

	// static void FixDPD() {
	//     // Game game = Game.GetBy.House(house);
	//     List<Game> games = Game.GetAll();
	//     games.RemoveAll(game => game.House != "Lucky Heart Gameroom");

	//     games.ForEach(
	//         delegate (Game game) {
	//             // List<DPD_Data> archive = new List<DPD_Data>();
	//             // game.DPD.History.ForEach(delegate (DPD_History dto) {
	//             //     archive.AddRange(dto.Data);
	//             // });
	//             //archive.AddRange(game.DPD.Data);

	//             game.DPD.Data = game.DPD.History[^1].Data;
	//             game.DPD.Average = game.DPD.History[^1].Average;
	//             game.Jackpots.Grand = game.DPD.Data[^1].Grand;
	//             // game.Unlock();
	//             // game.DPD.Average = 0F;
	//             // game.DPD.Data = [];
	//             // game.DPD.History = [];

	//             // for (int i = 0; i < archive.Count; i++) {
	//             //     DPD_Data dto = archive[i];
	//             //     float currentGrand = dto.Grand;
	//             //     if (game.DPD.Data.Count == 0) game.DPD.Data.Add(dto);
	//             //     else {
	//             //         float previousGrand = game.DPD.Data[game.DPD.Data.Count - 1].Grand;
	//             //         if (currentGrand != previousGrand) {
	//             //             if (currentGrand > previousGrand) {
	//             //                 game.DPD.Data.Add(dto);
	//             //                 float minutes = Convert.ToSingle((game.DPD.Data[game.DPD.Data.Count - 1].Timestamp - game.DPD.Data[0].Timestamp).TotalMinutes);
	//             //                 float dollars = game.DPD.Data[game.DPD.Data.Count - 1].Grand - game.DPD.Data[0].Grand;
	//             //                 float MinutesInADay = Convert.ToSingle(TimeSpan.FromDays(1).TotalMinutes);
	//             //                 float days = minutes / MinutesInADay;
	//             //                 float dollarsPerDay = dollars / days;
	//             //                 game.DPD.Average = dollarsPerDay;
	//             //                 Console.WriteLine("[" + i + "] DPD: " + game.DPD.Average);
	//             //             } else {
	//             //                 // game.DPD.History.Add(new DPD_History(game.DPD.Average, game.DPD.Data));
	//             //                 // game.DPD.Data = [];
	//             //                 // game.DPD.Average = 0F;
	//             //                 // game.DPD.Data.Add(dto);
	//             //             }
	//             //         }
	//             //     }
	//             // }
	//             // game.DPD.History[0].Timestamp = DateTime.Now;
	//             // game.Unlocked = true;
	//             game.Save();
	//         }
	//     );
	// }
}
