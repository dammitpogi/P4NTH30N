using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
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
}
