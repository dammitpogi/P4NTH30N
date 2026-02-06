using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON.SanityCheck;

namespace P4NTH30N.C0MMON;

[method: SetsRequiredMembers]
public class Game(string house, string game) {
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public bool Enabled { get; set; } = true;
	public bool Unlocked { get; set; } = true;
	public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
	public required string House { get; set; } = house;
	public required string Name { get; set; } = game;
	public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
	public bool Updated { get; set; } = false;
	public Timers? Timers { get; set; } = new Timers();
	public required Jackpots Jackpots { get; set; } = new Jackpots();
	public required Thresholds Thresholds { get; set; } = new Thresholds();
	public GameSettings Settings { get; set; } = new GameSettings(game);
	public required DPD DPD { get; set; } = new DPD();

	public static void UpdatesComplete() {
		GetAll()
			.ForEach(game => {
				if (game.Updated) {
					game.Updated = false;
					game.Save();
				}
			});
	}

	public static Game? Get(string house, string game, bool insert = true) {
		Database database = new();
		IMongoCollection<Game> collection = database.IO.GetCollection<Game>("G4ME");
		FilterDefinition<Game> filter =
			Builders<Game>.Filter.Eq(x => x.House, house)
			& Builders<Game>.Filter.Eq(x => x.Name, game);
		Game? dto = null;
		while (true) {
			List<Game> result = collection.Find(filter).ToList();
			if (result.Count.Equals(0)) {
                if (insert) {
                    collection.InsertOne(new Game(house, game));
                } else return null;
			} else {
				dto = result[0];
				break;
			}
		}
		return dto;
	}

	public static List<Game> GetAll() {
		return new Database()
			.IO.GetCollection<Game>("G4ME")
			.Find(Builders<Game>.Filter.Empty)
			.ToList();
	}

	public static DateTime QueueAge() {
		List<BsonDocument> results = new Database()
			.IO.GetCollection<BsonDocument>("M47URITY")
			.Find(Builders<BsonDocument>.Filter.Empty)
			.ToList();
		
		if (results.Count == 0) {
			Console.WriteLine($"{DateTime.Now} - WARNING: M47URITY view is empty, returning DateTime.MinValue");
			return DateTime.MinValue;
		}
		
		return (DateTime)results[0]["Updated"].AsBsonDateTime;
	}

	public static Game GetNext() {
		return new Database()
			.IO.GetCollection<Game>("N3XT")
			.Find(Builders<Game>.Filter.Empty)
			.First();
	}

	// public static Game? GetNext() {
	//     FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
	//     FilterDefinition<Game> filter = builder.Eq("Unlocked", true) & builder.Eq("Enabled", true) & builder.Or([builder.Eq("Updated", false), builder.Eq("Updated", BsonNull.Value)]);
	//     List<Game> games = new Database().IO.GetCollection<Game>("G4ME").Find(filter).SortBy(g => g.LastUpdated).Limit(1).ToList();
	//     return games.Count > 0 ? games[0] : null;
	// }

	public static Game? GetNext(string Name) {
		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
		FilterDefinition<Game> filter =
			builder.Eq("Name", Name)
			& builder.Eq("Unlocked", true)
			& builder.Eq("Enabled", true)
			& builder.Or([builder.Eq("Updated", false), builder.Eq("Updated", BsonNull.Value)]);
		List<Game> games = new Database()
			.IO.GetCollection<Game>("G4ME")
			.Find(filter)
			.SortBy(g => g.LastUpdated)
			.Limit(1)
			.ToList();
		return games.Count > 0 ? games[0] : null;
	}

	public static class GetBy {
		public static Game House(string house) {
			return new Database()
				.IO.GetCollection<Game>("G4ME")
				.Find(Builders<Game>.Filter.Eq("House", house))
				.ToList()[0];
		}
	}

public static List<Game> GetVerified(string Name, string Slots) {
		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
		FilterDefinition<Game> filter = Slots switch {
			"Gold777" => builder.Eq("Name", Name)
				& builder.Eq("Settings.Gold777.ButtonVerified", true),
			"FortunePiggy" => builder.Eq("Name", Name)
				& builder.Eq("Settings.FortunePiggy.ButtonVerified", true),
			_ => builder.Eq("Name", "UNDEFINED")
		};
		return new Database()
			.IO.GetCollection<Game>("G4ME")
			.Find(filter)
			.Sort(Builders<Game>.Sort.Ascending(x => x.LastUpdated))
			.ToList();
	}

	public static List<Game> GetUnverified(string Name, string Slots) {
		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
		FilterDefinition<Game> filter = Slots switch {
			"Gold777" => builder.Eq("Name", Name)
				& builder.Eq("Settings.Gold777.ButtonVerified", false),
			"FortunePiggy" => builder.Eq("Name", Name)
				& builder.Eq("Settings.FortunePiggy.ButtonVerified", false),
			_ => builder.Eq("Name", "UNDEFINED")
		};
		return new Database()
			.IO.GetCollection<Game>("G4ME")
			.Find(filter)
			.Sort(Builders<Game>.Sort.Ascending(x => x.LastUpdated))
			.ToList();
	}

	public void Unlock() {
		LastUpdated = DateTime.UtcNow;
		Unlocked = true;
		Save();
	}

	public void Lock() {
		UnlockTimeout = DateTime.UtcNow.AddMinutes(1.5);
		Unlocked = false;
		Save();
	}

	public void Save() {
		FilterDefinitionBuilder<Game> builder = Builders<Game>.Filter;
		FilterDefinition<Game> filter = builder.Eq("House", House) & builder.Eq("Name", Name);
		List<Game> dto = new Database().IO.GetCollection<Game>("G4ME").Find(filter).ToList();
		if (dto.Count.Equals(0)) {
			_id = ObjectId.GenerateNewId();
			LastUpdated = DateTime.MinValue;
			new Database().IO.GetCollection<Game>("G4ME").InsertOne(this);
		} else {
			_id = dto[0]._id;
			new Database().IO.GetCollection<Game>("G4ME").ReplaceOne(filter, this);
		}
	}
}

public class Jackpots {
	private double _grand = 0F;
	private double _major = 0F;
	private double _minor = 0F;
	private double _mini = 0F;

	public double Grand { 
		get => _grand;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Grand", value, 2000);
			if (!validation.IsValid) {
				Console.WriteLine($"🔴 Invalid Grand jackpot value rejected: {value:F2}");
				return; // Don't update with invalid value
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Grand jackpot auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_grand = validation.ValidatedValue;
		}
	}

	public double Major { 
		get => _major;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Major", value, 1000);
			if (!validation.IsValid) {
				Console.WriteLine($"🔴 Invalid Major jackpot value rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Major jackpot auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_major = validation.ValidatedValue;
		}
	}

	public double Minor { 
		get => _minor;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Minor", value, 200);
			if (!validation.IsValid) {
				Console.WriteLine($"🔴 Invalid Minor jackpot value rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Minor jackpot auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_minor = validation.ValidatedValue;
		}
	}

	public double Mini { 
		get => _mini;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Mini", value, 50);
			if (!validation.IsValid) {
				Console.WriteLine($"🔴 Invalid Mini jackpot value rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Mini jackpot auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_mini = validation.ValidatedValue;
		}
	}
}

public class Thresholds {
	private double _grand = 1785;
	private double _major = 565;
	private double _minor = 117F;
	private double _mini = 23F;

	public double Grand { 
		get => _grand;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Grand", value, 10000);
			if (!validation.IsValid || validation.ValidatedValue > 2000) {
				Console.WriteLine($"🔴 Invalid Grand threshold rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Grand threshold auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_grand = validation.ValidatedValue;
		}
	}

	public double Major { 
		get => _major;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Major", value, 1000);
			if (!validation.IsValid || validation.ValidatedValue > 600) {
				Console.WriteLine($"🔴 Invalid Major threshold rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Major threshold auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_major = validation.ValidatedValue;
		}
	}

	public double Minor { 
		get => _minor;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Minor", value, 200);
			if (!validation.IsValid || validation.ValidatedValue > 150) {
				Console.WriteLine($"🔴 Invalid Minor threshold rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Minor threshold auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_minor = validation.ValidatedValue;
		}
	}

	public double Mini { 
		get => _mini;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Mini", value, 50);
			if (!validation.IsValid || validation.ValidatedValue > 40) {
				Console.WriteLine($"🔴 Invalid Mini threshold rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Mini threshold auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_mini = validation.ValidatedValue;
		}
	}

	public Thresholds_Data Data { get; set; } = new Thresholds_Data();

	public void NewGrand(double grand) {
		// Validate before adding to data
		var validation = P4NTH30NSanityChecker.ValidateJackpot("Grand", grand, _grand);
		if (validation.IsValid) {
			Data.Grand.Add(validation.ValidatedValue);
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Grand data entry repaired: {grand:F2} -> {validation.ValidatedValue:F2}");
			}
		} else {
			Console.WriteLine($"🔴 Invalid Grand data entry rejected: {grand:F2}");
		}
	}

	public void NewMajor(double major) {
		var validation = P4NTH30NSanityChecker.ValidateJackpot("Major", major, _major);
		if (validation.IsValid) {
			Data.Major.Add(validation.ValidatedValue);
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Major data entry repaired: {major:F2} -> {validation.ValidatedValue:F2}");
			}
		} else {
			Console.WriteLine($"🔴 Invalid Major data entry rejected: {major:F2}");
		}
	}

	public void NewMinor(double minor) {
		var validation = P4NTH30NSanityChecker.ValidateJackpot("Minor", minor, _minor);
		if (validation.IsValid) {
			Data.Minor.Add(validation.ValidatedValue);
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Minor data entry repaired: {minor:F2} -> {validation.ValidatedValue:F2}");
			}
		} else {
			Console.WriteLine($"🔴 Invalid Minor data entry rejected: {minor:F2}");
		}
	}

	public void NewMini(double mini) {
		var validation = P4NTH30NSanityChecker.ValidateJackpot("Mini", mini, _mini);
		if (validation.IsValid) {
			Data.Mini.Add(validation.ValidatedValue);
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 Mini data entry repaired: {mini:F2} -> {validation.ValidatedValue:F2}");
			}
		} else {
			Console.WriteLine($"🔴 Invalid Mini data entry rejected: {mini:F2}");
		}
	}
}

[method: SetsRequiredMembers]
public class Thresholds_Data() {
	public required List<double> Grand { get; set; } = [];
	public required List<double> Major { get; set; } = [];
	public required List<double> Minor { get; set; } = [];
	public required List<double> Mini { get; set; } = [];
}

[method: SetsRequiredMembers]
public class DPD() {
	private double _average = 0F;
	
	public double Average { 
		get => _average;
		set {
			var validation = P4NTH30NSanityChecker.ValidateDPD(value, "DPD_Average");
			if (!validation.IsValid) {
				Console.WriteLine($"🔴 Invalid DPD average rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 DPD average auto-repaired: {value:F2} -> {validation.ValidatedRate:F2}");
			}
			_average = validation.ValidatedRate;
		}
	}
	
	public required List<DPD_History> History { get; set; } = [];
	public required List<DPD_Data> Data { get; set; } = [];
	public DPD_Toggles Toggles { get; set; } = new DPD_Toggles();
}

[method: SetsRequiredMembers]
public class DPD_History(double average, List<DPD_Data> data) {
	public double Average { get; set; } = average;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public required List<DPD_Data> Data { get; set; } = data;
}

public class DPD_Data(double grand) {
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	private double _grand = grand;
	
	public double Grand { 
		get => _grand;
		set {
			var validation = P4NTH30NSanityChecker.ValidateJackpot("Grand", value, 10000);
			if (!validation.IsValid) {
				Console.WriteLine($"🔴 Invalid DPD Grand data rejected: {value:F2}");
				return;
			}
			if (validation.WasRepaired) {
				Console.WriteLine($"🔧 DPD Grand data auto-repaired: {value:F2} -> {validation.ValidatedValue:F2}");
			}
			_grand = validation.ValidatedValue;
		}
	}
}

public class DPD_Toggles() {
	public bool GrandPopped { get; set; } = false;
	public bool MajorPopped { get; set; } = false;
	public bool MinorPopped { get; set; } = false;
	public bool MiniPopped { get; set; } = false;
}

public class GameSettings(string game) { //
	public string Preferred { get; set; } = "FortunePiggy";
	public FortunePiggy_Settings FortunePiggy { get; set; } = new FortunePiggy_Settings(game);
	public Quintuple5X_Settings Quintuple5X { get; set; } = new Quintuple5X_Settings();
	public Gold777_Settings Gold777 { get; set; } = new Gold777_Settings();
	public bool SpinGrand { get; set; } = true;
	public bool SpinMajor { get; set; } = true;
	public bool SpinMinor { get; set; } = true;
	public bool SpinMini { get; set; } = true;
	public bool Hidden { get; set; } = false;
}

public class Gold777_Settings {
	public int Page { get; set; } = 10;

	// public int Button_X { get; set; } = 603;
	// public int Button_Y { get; set; } = 457;
	public int Button_X { get; set; } = 450;
	public int Button_Y { get; set; } = 280;
	public bool ButtonVerified { get; set; } = false;
}

public class FortunePiggy_Settings {
	public int Page { get; set; } // = game.Equals("FireKirin") ? 7 : 7;
	public int Button_X { get; set; } // = game.Equals("FireKirin") ? 820 : 820;
	public int Button_Y { get; set; } // = game.Equals("FireKirin") ? 450 : 450;
	public bool ButtonVerified { get; set; } = false;

	public FortunePiggy_Settings(string game) {
		ButtonVerified = false;
		switch (game) {
			case "FireKirin":
				Page = 2;
				Button_X = 290;
				Button_Y = 280;
				break;

			case "OrionStars":
				Page = 3;
				Button_X = 220;
				Button_Y = 460;
				break;

			default:
				Page = 7;
				Button_X = 820;
				Button_Y = 450;
				break;
		}
	}
}

public class Quintuple5X_Settings {
	public int Page { get; set; } = 7;

	// public int Button_X { get; set; } = 603;
	// public int Button_Y { get; set; } = 457;
	public int Button_X { get; set; } = 820;
	public int Button_Y { get; set; } = 450;
	public bool ButtonVerified { get; set; } = false;
}

public class Timers {
	public double Grand { get; set; } = 0F;
	public double Major { get; set; } = 0F;
	public double Minor { get; set; } = 0F;
	public double Mini { get; set; } = 0F;
}
