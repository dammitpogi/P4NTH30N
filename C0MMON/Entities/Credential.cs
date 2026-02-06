using System;
using System.Security.Cryptography.X509Certificates;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON.SanityCheck;

namespace P4NTH30N.C0MMON;

public class Credential(string game) {
    public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
    public ObjectId? PROF3T_id { get; set; } = null;
    public bool Enabled { get; set; } = true;
    public bool Banned { get; set; } = false;
	public bool Unlocked { get; set; } = true;
    public int PROF3T_ID { get; set; } = 1;
    public string URL { get; set; } = string.Empty;
    public required string House { get; set; }
    public required string Game { get; set; }
	public DateTime CreateDate { get; set; } = DateTime.UtcNow;
    public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
	public DateTime LastUpdated { get; set; } = DateTime.UtcNow.AddDays(-1);
    public DateTime? LastDepositDate { get; set; } = DateTime.UtcNow.AddDays(-1);
	public Jackpots Jackpots { get; set; } = new Jackpots();
	public Thresholds Thresholds { get; set; } = new Thresholds();
	public GameSettings Settings { get; set; } = new GameSettings(game);
	public DPD DPD { get; set; } = new DPD();
    public bool CashedOut { get; set; } = true;
    
    private double _balance = 0;
    public double Balance { 
        get => _balance;
        set {
            var validation = P4NTH30NSanityChecker.ValidateBalance(value, Username ?? "Unknown");
            if (!validation.IsValid) {
                Console.WriteLine($"🔴 Invalid balance rejected for {Username}: {value:F2}");
                return;
            }
            if (validation.WasRepaired) {
                Console.WriteLine($"🔧 Balance auto-repaired for {Username}: {value:F2} -> {validation.ValidatedBalance:F2}");
            }
            _balance = validation.ValidatedBalance;
        }
    }
    
    public required string Username { get; set; }
    public required string Password { get; set; }

    public static List<Credential> Database() {
        return new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(Builders<Credential>.Filter.Empty).ToList();
    }

    public static void IntroduceProperties() {
        Database database = new();
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        IMongoCollection<Credential> collection = database.IO.GetCollection<Credential>("CRED3N7IAL");
        FilterDefinition<Credential> filter = builder.Exists(x => x.Enabled, false);
        collection.Find(filter).ToList().ForEach(credential => credential.Save());
    }
    public static List<Credential> GetAll() {
        Database database = new();
        IMongoCollection<Credential> collection = database.IO.GetCollection<Credential>("CRED3N7IAL");
        // List<Credential> credentials = collection.Find(Builders<Credential>.Filter.Eq("Banned", false)).SortByDescending(c => c.Balance).ToList();
        List<Credential> credentials = collection.Find(Builders<Credential>.Filter.Empty).SortByDescending(c => c.Balance).ToList();
        return credentials;
    }

    public static List<Credential> GetBy(Game game) {
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        FilterDefinition<Credential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name) & builder.Eq("Banned", false);
        return new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    }

    public static List<Credential> GetAllEnabledFor(Game game) {
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        FilterDefinition<Credential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name) & builder.Eq("Enabled", true) & builder.Eq("Banned", false);
        return new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    }

    public static Credential? GetBy(Game game, string username) {
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        FilterDefinition<Credential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name) & builder.Eq("Username", username);
        List<Credential> dto = new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).ToList();
        if (dto.Count == 0)
            return null;
        else
            return dto[0];
    }
public void Lock() {
		UnlockTimeout = DateTime.UtcNow.AddMinutes(1.5);
		Unlocked = false;
		Save();
	}
	public void Unlock() {
		Unlocked = true;
		Save();
	}

    // public static List<Credential> GetBy(House house)
    // {
    //     Database database = new();
    //     FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
    //     FilterDefinition<Credential> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name);
    //     return database.IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    // }

    public void Save() {
        FilterDefinition<Credential> filter = Builders<Credential>.Filter.Eq(x => x._id, _id);
        new Database().IO.GetCollection<Credential>("CRED3N7IAL").ReplaceOne(filter, this);
    }
}