using System;
using System.Security.Cryptography.X509Certificates;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
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
    public bool Updated { get; set; } = false;
    
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

    public static List<Credential> GetBy(string house, string game) {
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        FilterDefinition<Credential> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Banned", false);
        return new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    }

    public static List<Credential> GetAllEnabledFor(string house, string game) {
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        FilterDefinition<Credential> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Enabled", true) & builder.Eq("Banned", false);
        return new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).SortBy(g => g.LastUpdated).ToList();
    }

    public static Credential? GetBy(string house, string game, string username) {
        FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
        FilterDefinition<Credential> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Username", username);
        List<Credential> dto = new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(filter).ToList();
        if (dto.Count == 0)
            return null;
        else
            return dto[0];
    }

public static Credential GetNext() {
		return GetNext(false);
	}
	
	public static Credential GetNext(bool usePriorityCalculation) {
		Database database = new();
		IMongoCollection<Credential> collection = database.IO.GetCollection<Credential>("CRED3N7IAL");
		
		// Get all enabled, non-banned credentials
		FilterDefinitionBuilder<Credential> builder = Builders<Credential>.Filter;
		FilterDefinition<Credential> filter = builder.Eq(c => c.Enabled, true) & builder.Eq(c => c.Banned, false);
		List<Credential> credentials = collection.Find(filter).ToList();
		
		if (credentials.Count == 0)
			throw new InvalidOperationException("No enabled, non-banned credentials found.");
		
		// Simple mode: full sweep of unlocked credentials (for when priority calculation is disabled)
		if (!usePriorityCalculation) {
			// Find first unlocked credential, sorted by LastUpdated (oldest first)
			var unlockedCredentials = credentials
				.Where(c => c.Unlocked)
				.OrderBy(c => c.LastUpdated)
				.ToList();
				
			if (unlockedCredentials.Count == 0)
				throw new InvalidOperationException("No unlocked credentials available.");
				
			return unlockedCredentials.First();
		}
		
		// Priority mode: calculate priorities for each credential
		List<(Credential credential, int priority, DateTime by, bool overdue)> prioritized = new();
		IMongoCollection<Jackpot> jackpotCollection = database.IO.GetCollection<Jackpot>("J4CKP0T");
		
		foreach (Credential cred in credentials) {
			// Calculate created/updated dates
			DateTime created = cred.CreateDate;
			DateTime updated = cred.LastUpdated > DateTime.MinValue ? cred.LastUpdated : created;
			bool funded = !cred.CashedOut;
			double dpdAverage = cred.DPD.Average;
			
			// Get jackpot estimations
			List<Jackpot> estimations = jackpotCollection
				.Find(Builders<Jackpot>.Filter.And(
					Builders<Jackpot>.Filter.Eq(j => j.House, cred.House),
					Builders<Jackpot>.Filter.Eq(j => j.Game, cred.Game),
					Builders<Jackpot>.Filter.Gte(j => j.Priority, 2)
				))
				.SortBy(j => j.EstimatedDate)
				.ToList();
			
			// Get mini jackpot (priority 1)
			Jackpot? mini = jackpotCollection
				.Find(Builders<Jackpot>.Filter.And(
					Builders<Jackpot>.Filter.Eq(j => j.House, cred.House),
					Builders<Jackpot>.Filter.Eq(j => j.Game, cred.Game),
					Builders<Jackpot>.Filter.Eq(j => j.Priority, 1)
				))
				.FirstOrDefault();
			
			// Calculate time-based flags
			bool leastWeekOld = created < DateTime.UtcNow.AddDays(-7);
			DateTime now = DateTime.UtcNow;
			Jackpot? latestEstimation = estimations.FirstOrDefault();
			
			bool jackpotWeek = latestEstimation == null || latestEstimation.EstimatedDate > now.AddDays(7);
			bool jackpotDay = latestEstimation == null || latestEstimation.EstimatedDate > now.AddDays(1);
			bool jackpot12H = latestEstimation == null || latestEstimation.EstimatedDate > now.AddHours(12);
			bool jackpot3H = latestEstimation == null || latestEstimation.EstimatedDate > now.AddHours(3);
			
			// Calculate differences
			double miniDiff = mini != null ? mini.Threshold - mini.Current : 0;
			double jackpotDiff = latestEstimation != null ? latestEstimation.Threshold - latestEstimation.Current : 0;
			
			// Calculate priority (1-7 scale, lower is higher priority)
			int priority = 7;
			if (jackpotDiff != 0) {
				if ((jackpotDiff <= 0.12 || (miniDiff <= 0.07 && funded))) {
					priority = 1;
				} else if (jackpot3H || jackpotDiff <= 0.3 || (miniDiff <= 0.15 && funded)) {
					priority = 2;
				} else if (jackpot12H) {
					priority = 3;
				} else if (!leastWeekOld && latestEstimation == null) {
					priority = 4;
				} else if (jackpotDay) {
					priority = 5;
				} else if (jackpotWeek) {
					priority = 6;
				}
			}
			
			// Calculate "by" time based on priority
			DateTime by = priority switch {
				1 => updated.AddMinutes(4),
				2 => updated.AddMinutes(8),
				3 => updated.AddMinutes(16),
				4 => updated.AddHours(1),
				5 => updated.AddHours(3),
				6 => updated.AddHours(6),
				_ => updated.AddDays(1)
			};
			
			bool overdue = now > by;
			
			prioritized.Add((cred, priority, by, overdue));
		}
		
		// Sort by priority (ascending), then by overdue (descending), then by updated (ascending)
		var sorted = prioritized
			.OrderBy(p => p.priority)
			.ThenByDescending(p => p.overdue)
			.ThenBy(p => p.credential.LastUpdated)
			.ToList();
		
		// Filter to only unlocked credentials and get the first one
		var nextCredential = sorted
			.Where(p => p.credential.Unlocked)
			.FirstOrDefault();
		
		if (nextCredential.credential == null)
			throw new InvalidOperationException("No unlocked credentials available.");
			
		return nextCredential.credential;
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
