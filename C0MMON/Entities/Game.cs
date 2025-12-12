// using System;
// using System.Diagnostics;
// using System.Diagnostics.CodeAnalysis;
// using MongoDB.Bson;
// using MongoDB.Driver;

// namespace P4NTH30N.C0MMON;

// [method: SetsRequiredMembers]
// public class Game(string house, string game) {
// 	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
// 	public bool Enabled { get; set; } = true;
// 	public bool Unlocked { get; set; } = true;
// 	public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
// 	public required string House { get; set; } = house;
// 	public required string Name { get; set; } = game;
// 	public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
// 	public bool Updated { get; set; } = false;
// 	public Timers? Timers { get; set; } = new Timers();
// 	public required Jackpots Jackpots { get; set; } = new Jackpots();
// 	public required Thresholds Thresholds { get; set; } = new Thresholds();
// 	public GameSettings Settings { get; set; } = new GameSettings(game);
// 	public required DPD DPD { get; set; } = new DPD();

// 	public static void UpdatesComplete() {
// 		GetAll()
// 			.ForEach(game => {
// 				if (game.Updated) {
// 					game.Updated = false;
// 					game.Save();
// 				}
// 			});
// 	}

// 	public static Game? Get(string house, string game, bool insert = true) {
// 		Database database = new();
// 		IMongoCollection<Game> collection = database.IO.GetCollection<Game>("G4ME");
// 		FilterDefinition<Game> filter =
// 			Builders<Game>.Filter.Eq(x => x.House, house)
// 			& Builders<Game>.Filter.Eq(x => x.Name, game);
// 		Game? dto = null;
// 		while (true) {
// 			List<Game> result = collection.Find(filter).ToList();
// 			if (result.Count.Equals(0)) {
//                 if (insert) {
//                     collection.InsertOne(new Game(house, game));
//                 } else return null;
// 			} else {
// 				dto = result[0];
// 				break;
// 			}
// 		}
// 		return dto;
// 	}

// 	public static List<Game> GetAll() {
// 		return new Database()
// 			.IO.GetCollection<Game>("G4ME")
// 			.Find(Builders<Game>.Filter.Empty)
// 			.ToList();
// 	}

// 	public static DateTime QueueAge() {
// 		return (DateTime)
// 			new Database()
// 				.IO.GetCollection<BsonDocument>("M47URITY")
// 				.Find(Builders<BsonDocument>.Filter.Empty)
// 				.ToList()[0]["Updated"]
// 				.AsBsonDateTime;
// 	}

// 	public static Game GetNext() {
// 		return new Database()
// 			.IO.GetCollection<Game>("N3XT")
// 			.Find(Builders<Game>.Filter.Empty)
// 			.First();
// 	}

// 	// public static Game? GetNext() {
// 	//     FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
// 	//     FilterDefinition<Game> filter = builder.Eq("Unlocked", true) & builder.Eq("Enabled", true) & builder.Or([builder.Eq("Updated", false), builder.Eq("Updated", BsonNull.Value)]);
// 	//     List<Game> games = new Database().IO.GetCollection<Game>("G4ME").Find(filter).SortBy(g => g.LastUpdated).Limit(1).ToList();
// 	//     return games.Count > 0 ? games[0] : null;
// 	// }

// 	public static Game? GetNext(string Name) {
// 		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
// 		FilterDefinition<Game> filter =
// 			builder.Eq("Name", Name)
// 			& builder.Eq("Unlocked", true)
// 			& builder.Eq("Enabled", true)
// 			& builder.Or([builder.Eq("Updated", false), builder.Eq("Updated", BsonNull.Value)]);
// 		List<Game> games = new Database()
// 			.IO.GetCollection<Game>("G4ME")
// 			.Find(filter)
// 			.SortBy(g => g.LastUpdated)
// 			.Limit(1)
// 			.ToList();
// 		return games.Count > 0 ? games[0] : null;
// 	}

// 	public static class GetBy {
// 		public static Game House(string house) {
// 			return new Database()
// 				.IO.GetCollection<Game>("G4ME")
// 				.Find(Builders<Game>.Filter.Eq("House", house))
// 				.ToList()[0];
// 		}
// 	}

// public static List<Game> GetVerified(string Name, string Slots) {
// 		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
// 		FilterDefinition<Game> filter = Slots switch {
// 			"Gold777" => builder.Eq("Name", Name)
// 				& builder.Eq("Settings.Gold777.ButtonVerified", true),
// 			"FortunePiggy" => builder.Eq("Name", Name)
// 				& builder.Eq("Settings.FortunePiggy.ButtonVerified", true),
// 			_ => builder.Eq("Name", "UNDEFINED")
// 		};
// 		return new Database()
// 			.IO.GetCollection<Game>("G4ME")
// 			.Find(filter)
// 			.Sort(Builders<Game>.Sort.Ascending(x => x.LastUpdated))
// 			.ToList();
// 	}

// 	public static List<Game> GetUnverified(string Name, string Slots) {
// 		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
// 		FilterDefinition<Game> filter = Slots switch {
// 			"Gold777" => builder.Eq("Name", Name)
// 				& builder.Eq("Settings.Gold777.ButtonVerified", false),
// 			"FortunePiggy" => builder.Eq("Name", Name)
// 				& builder.Eq("Settings.FortunePiggy.ButtonVerified", false),
// 			_ => builder.Eq("Name", "UNDEFINED")
// 		};
// 		return new Database()
// 			.IO.GetCollection<Game>("G4ME")
// 			.Find(filter)
// 			.Sort(Builders<Game>.Sort.Ascending(x => x.LastUpdated))
// 			.ToList();
// 	}

// 	public void Unlock() {
// 		LastUpdated = DateTime.UtcNow;
// 		Unlocked = true;
// 		Save();
// 	}

// 	public void Lock() {
// 		UnlockTimeout = DateTime.UtcNow.AddMinutes(1.5);
// 		Unlocked = false;
// 		Save();
// 	}

// 	public void Save() {
// 		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
// 		FilterDefinition<Game> filter = builder.Eq("House", House) & builder.Eq("Name", Name);
// 		List<Game> dto = new Database().IO.GetCollection<Game>("G4ME").Find(filter).ToList();
// 		if (dto.Count.Equals(0)) {
// 			_id = ObjectId.GenerateNewId();
// 			LastUpdated = DateTime.MinValue;
// 			new Database().IO.GetCollection<Game>("G4ME").InsertOne(this);
// 		} else {
// 			_id = dto[0]._id;
// 			new Database().IO.GetCollection<Game>("G4ME").ReplaceOne(filter, this);
// 		}
// 	}
// }

// public class Jackpots {
// 	public double Grand { get; set; } = 0F;
// 	public double Major { get; set; } = 0F;
// 	public double Minor { get; set; } = 0F;
// 	public double Mini { get; set; } = 0F;
// }

// public class Thresholds {
// 	public double Grand { get; set; } = 1785;
// 	public double Major { get; set; } = 565;
// 	public double Minor { get; set; } = 117F;
// 	public double Mini { get; set; } = 23F;
// 	public Thresholds_Data Data { get; set; } = new Thresholds_Data();

// 	public void NewGrand(double grand) {
// 		Data.Grand.Add(grand);
// 		// Grand = grand;
// 	}

// 	public void NewMajor(double major) {
// 		Data.Major.Add(major);
// 		// Major = major;
// 	}

// 	public void NewMinor(double minor) {
// 		Data.Minor.Add(minor);
// 		// Minor = minor;
// 	}

// 	public void NewMini(double mini) {
// 		Data.Mini.Add(mini);
// 		// Mini = mini;
// 	}
// }

// [method: SetsRequiredMembers]
// public class Thresholds_Data() {
// 	public required List<double> Grand { get; set; } = [];
// 	public required List<double> Major { get; set; } = [];
// 	public required List<double> Minor { get; set; } = [];
// 	public required List<double> Mini { get; set; } = [];
// }

// [method: SetsRequiredMembers]
// public class DPD() {
// 	public double Average { get; set; } = 0F;
// 	public required List<DPD_History> History { get; set; } = [];
// 	public required List<DPD_Data> Data { get; set; } = [];
// 	public DPD_Toggles Toggles { get; set; } = new DPD_Toggles();
// }

// [method: SetsRequiredMembers]
// public class DPD_History(double average, List<DPD_Data> data) {
// 	public double Average { get; set; } = average;
// 	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
// 	public required List<DPD_Data> Data { get; set; } = data;
// }

// public class DPD_Data(double grand) {
// 	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
// 	public double Grand { get; set; } = grand;
// }

// public class DPD_Toggles() {
// 	public bool GrandPopped { get; set; } = false;
// 	public bool MajorPopped { get; set; } = false;
// 	public bool MinorPopped { get; set; } = false;
// 	public bool MiniPopped { get; set; } = false;
// }

// public class GameSettings(string game) { //
// 	public string Preferred { get; set; } = "FortunePiggy";
// 	public FortunePiggy_Settings FortunePiggy { get; set; } = new FortunePiggy_Settings(game);
// 	public Quintuple5X_Settings Quintuple5X { get; set; } = new Quintuple5X_Settings();
// 	public Gold777_Settings Gold777 { get; set; } = new Gold777_Settings();
// 	public bool SpinGrand { get; set; } = true;
// 	public bool SpinMajor { get; set; } = true;
// 	public bool SpinMinor { get; set; } = true;
// 	public bool SpinMini { get; set; } = true;
// 	public bool Hidden { get; set; } = false;
// }

// public class Gold777_Settings {
// 	public int Page { get; set; } = 10;

// 	// public int Button_X { get; set; } = 603;
// 	// public int Button_Y { get; set; } = 457;
// 	public int Button_X { get; set; } = 450;
// 	public int Button_Y { get; set; } = 280;
// 	public bool ButtonVerified { get; set; } = false;
// }

// public class FortunePiggy_Settings {
// 	public int Page { get; set; } // = game.Equals("FireKirin") ? 7 : 7;
// 	public int Button_X { get; set; } // = game.Equals("FireKirin") ? 820 : 820;
// 	public int Button_Y { get; set; } // = game.Equals("FireKirin") ? 450 : 450;
// 	public bool ButtonVerified { get; set; } = false;

// 	public FortunePiggy_Settings(string game) {
// 		ButtonVerified = false;
// 		switch (game) {
// 			case "FireKirin":
// 				Page = 2;
// 				Button_X = 290;
// 				Button_Y = 280;
// 				break;

// 			case "OrionStars":
// 				Page = 3;
// 				Button_X = 220;
// 				Button_Y = 460;
// 				break;

// 			default:
// 				Page = 7;
// 				Button_X = 820;
// 				Button_Y = 450;
// 				break;
// 		}
// 	}
// }

// public class Quintuple5X_Settings {
// 	public int Page { get; set; } = 7;

// 	// public int Button_X { get; set; } = 603;
// 	// public int Button_Y { get; set; } = 457;
// 	public int Button_X { get; set; } = 820;
// 	public int Button_Y { get; set; } = 450;
// 	public bool ButtonVerified { get; set; } = false;
// }

// public class Timers {
// 	public double Grand { get; set; } = 0F;
// 	public double Major { get; set; } = 0F;
// 	public double Minor { get; set; } = 0F;
// 	public double Mini { get; set; } = 0F;
// }
