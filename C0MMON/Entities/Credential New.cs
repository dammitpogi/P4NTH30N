using System;
using System.Diagnostics.CodeAnalysis;
using System.Security.Cryptography.X509Certificates;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public class NewCredential(string game) {
    public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
    public ObjectId? PROF3T_id { get; set; } = null;
    public required string Game { get; set; }
    public required string House { get; set; }
    public string URL { get; set; } = string.Empty;
    public required string Username { get; set; }
    public required string Password { get; set; }
    public NewJackpots Jackpots { get; set; } = new NewJackpots();
    public NewGameSettings Settings { get; set; } = new NewGameSettings(game);
    public Toggles Toggles { get; set; } = new Toggles();
    public Dates Dates { get; set; } = new Dates();
    public double Balance { get; set; } = 0;
    
    public static List<NewCredential> Database() {
        return new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").Find(Builders<NewCredential>.Filter.Empty).ToList();
    }
	public static DateTime QueueAge() {
		return (DateTime)
			new Database()
				.IO.GetCollection<BsonDocument>("M47URITY")
				.Find(Builders<BsonDocument>.Filter.Empty)
				.ToList()[0]["Updated"]
				.AsBsonDateTime;
	}
    
    public static void IntroduceProperties() {
        Database database = new();
        FilterDefinitionBuilder<NewCredential> builder = Builders<NewCredential>.Filter;
        IMongoCollection<NewCredential> collection = database.IO.GetCollection<NewCredential>("CRED3N7IAL");
        FilterDefinition<NewCredential> filter = builder.Exists(x => x.Toggles.Enabled, false);
        collection.Find(filter).ToList().ForEach(Newcredential => Newcredential.Save());
    }

    public static List<NewCredential> GetAll() {
        Database database = new();
        IMongoCollection<NewCredential> collection = database.IO.GetCollection<NewCredential>("CRED3N7IAL");
        // List<NewCredential> Newcredentials = collection.Find(Builders<NewCredential>.Filter.Eq("Banned", false)).SortByDescending(c => c.Balance).ToList();
        List<NewCredential> Newcredentials = collection.Find(Builders<NewCredential>.Filter.Empty).SortByDescending(c => c.Balance).ToList();
        return Newcredentials;
    }

    public static NewCredential GetNext() {
        return new Database().IO.GetCollection<NewCredential>("SUCC3SSION").Find(Builders<NewCredential>.Filter.Empty).First();
    }

    public void Delete() {
        FilterDefinition<NewCredential> filter = Builders<NewCredential>.Filter.Eq(x => x._id, _id);
        new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").DeleteOne(filter);
    }

	public void Unlock() {
		Dates.LastUpdated = DateTime.UtcNow;
		Toggles.Unlocked = true;
		Save();
	}

	public void Lock() {
		Dates.UnlockTimeout = DateTime.UtcNow.AddMinutes(1.5);
		Toggles.Unlocked = false;
		Save();
	}

    public void Save() {
        FilterDefinition<NewCredential> filter = Builders<NewCredential>.Filter.Eq("_id", _id);
        List<NewCredential> dto = new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").Find(filter).ToList();
        if (dto.Count.Equals(0)) {
            new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").InsertOne(this);
        } else {
            _id = dto[0]._id;
            new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").ReplaceOne(filter, this);
        }
    }

    public static class GetBy {
        public static NewCredential Username(string game, string username) {
            FilterDefinitionBuilder<NewCredential> builder = Builders<NewCredential>.Filter;
            FilterDefinition<NewCredential> filter = builder.Eq("Game", game) & builder.Eq("Username", username) & builder.Eq("Banned", false);
            return new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").Find(filter).First();
        }
    }
    // public static List<NewCredential> GetBy(Game game) {
    //     FilterDefinitionBuilder<NewCredential> builder = Builders<NewCredential>.Filter;
    //     FilterDefinition<NewCredential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name) & builder.Eq("Banned", false);
    //     return new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    // }

    // public static List<NewCredential> GetAllEnabledFor(Game game) {
    //     FilterDefinitionBuilder<NewCredential> builder = Builders<NewCredential>.Filter;
    //     FilterDefinition<NewCredential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name) & builder.Eq("Enabled", true) & builder.Eq("Banned", false);
    //     return new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    // }

    // public static NewCredential? GetBy(Game game, string username) {
    //     FilterDefinitionBuilder<NewCredential> builder = Builders<NewCredential>.Filter;
    //     FilterDefinition<NewCredential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name) & builder.Eq("Username", username);
    //     List<NewCredential> dto = new Database().IO.GetCollection<NewCredential>("CRED3N7IAL").Find(filter).ToList();
    //     if (dto.Count == 0)
    //         return null;
    //     else
    //         return dto[0];
    // }

    // public static List<NewCredential> GetBy(House house)
    // {
    //     Database database = new();
    //     FilterDefinitionBuilder<NewCredential> builder = Builders<NewCredential>.Filter;
    //     FilterDefinition<NewCredential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name);
    //     return database.IO.GetCollection<NewCredential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    // }

}

public class Dates() {
    public DateTime CreateDate { get; set; } = DateTime.UtcNow;
    public DateTime LastUpdated { get; set; } = DateTime.UtcNow.AddDays(-1);
    public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
    public DateTime LastDepositDate { get; set; } = DateTime.UtcNow.AddDays(-1);
}
public class Toggles() {
    public bool Enabled { get; set; } = true;
    public bool Banned { get; set; } = false;
    public bool Unlocked { get; set; } = true;
    public bool CashedOut { get; set; } = true;
    public bool GrandPopped { get; set; } = false;
    public bool MajorPopped { get; set; } = false;
    public bool MinorPopped { get; set; } = false;
    public bool MiniPopped { get; set; } = false;
}
public class NewJackpots {
    public NewJackpot? Grand { get; set; }
    public NewJackpot? Major { get; set; }
    public NewJackpot? Minor { get; set; }
    public NewJackpot? Mini { get; set; }
}

// public class NewThresholds {
//     public double Grand { get; set; } = 1785;
//     public double Major { get; set; } = 565;
//     public double Minor { get; set; } = 117F;
//     public double Mini { get; set; } = 23F;
//     public Thresholds_Data Data { get; set; } = new Thresholds_Data();

//     public void NewGrand(double grand) {
//         Data.Grand.Add(grand);
//         // Grand = grand;
//     }

//     public void NewMajor(double major) {
//         Data.Major.Add(major);
//         // Major = major;
//     }

//     public void NewMinor(double minor) {
//         Data.Minor.Add(minor);
//         // Minor = minor;
//     }

//     public void NewMini(double mini) {
//         Data.Mini.Add(mini);
//         // Mini = mini;
//     }
// }

[method: SetsRequiredMembers]
public class NewThresholds_Data() {
    public required List<double> Grand { get; set; } = [];
    public required List<double> Major { get; set; } = [];
    public required List<double> Minor { get; set; } = [];
    public required List<double> Mini { get; set; } = [];
}


public class NewGameSettings(string game) { //
    public string Preferred { get; set; } = "FortunePiggy";
    public NewFortunePiggy_Settings FortunePiggy { get; set; } = new NewFortunePiggy_Settings(game);
    public NewQuintuple5X_Settings Quintuple5X { get; set; } = new NewQuintuple5X_Settings();
    public NewGold777_Settings Gold777 { get; set; } = new NewGold777_Settings();
    public bool SpinGrand { get; set; } = true;
    public bool SpinMajor { get; set; } = true;
    public bool SpinMinor { get; set; } = true;
    public bool SpinMini { get; set; } = true;
    public bool Hidden { get; set; } = false;
}

public class NewGold777_Settings {
    public int Page { get; set; } = 10;

    // public int Button_X { get; set; } = 603;
    // public int Button_Y { get; set; } = 457;
    public int Button_X { get; set; } = 450;
    public int Button_Y { get; set; } = 280;
    public bool ButtonVerified { get; set; } = false;
}

public class NewFortunePiggy_Settings {
    public int Page { get; set; } // = game.Equals("FireKirin") ? 7 : 7;
    public int Button_X { get; set; } // = game.Equals("FireKirin") ? 820 : 820;
    public int Button_Y { get; set; } // = game.Equals("FireKirin") ? 450 : 450;
    public bool ButtonVerified { get; set; } = false;

    public NewFortunePiggy_Settings(string game) {
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

public class NewQuintuple5X_Settings {
    public int Page { get; set; } = 7;

    // public int Button_X { get; set; } = 603;
    // public int Button_Y { get; set; } = 457;
    public int Button_X { get; set; } = 820;
    public int Button_Y { get; set; } = 450;
    public bool ButtonVerified { get; set; } = false;
}

public class NewTimers {
    public double Grand { get; set; } = 0F;
    public double Major { get; set; } = 0F;
    public double Minor { get; set; } = 0F;
    public double Mini { get; set; } = 0F;
}

