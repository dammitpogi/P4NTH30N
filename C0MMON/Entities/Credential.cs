using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON;

public class Credential
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public ObjectId? PROF3T_id { get; set; } = null;
	public bool Enabled { get; set; } = true;
	public bool Banned { get; set; } = false;
	public bool Unlocked { get; set; } = true;
	public int PROF3T_ID { get; set; } = 1;
	public string URL { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public DateTime CreateDate { get; set; } = DateTime.UtcNow;
	public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
	public DateTime LastUpdated { get; set; } = DateTime.UtcNow.AddDays(-1);
	public DateTime? LastDepositDate { get; set; } = DateTime.UtcNow.AddDays(-1);
	public Jackpots Jackpots { get; set; } = new Jackpots();
	public Thresholds Thresholds { get; set; } = new Thresholds();
	public GameSettings Settings { get; set; } = new GameSettings();

	public bool CashedOut { get; set; } = true;
	public bool Updated { get; set; } = false;

	public Credential() { }

	public Credential(string game)
	{
		Game = game;
		Settings = new GameSettings(game);
	}

	private double _balance = 0;
	public double Balance
	{
		get => _balance;
		set
		{
			if (double.IsNaN(value) || double.IsInfinity(value))
			{
				Console.WriteLine($"🔴 Invalid balance rejected for {Username}: {value}");
				return;
			}
			if (value < 0)
			{
				Console.WriteLine($"🔴 Negative balance rejected for {Username}: {value:F2}");
				return;
			}
			_balance = value;
		}
	}

	/// <summary>
	/// Validates credential - returns true if valid. Logs to ERR0R if invalid and errorLogger provided.
	/// </summary>
	public bool IsValid(IStoreErrors? errorLogger = null)
	{
		if (Balance < 0 || double.IsNaN(Balance) || double.IsInfinity(Balance))
		{
			errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError, $"Credential:{Username}@{House}/{Game}", $"Invalid balance: {Balance}", ErrorSeverity.High));
			return false;
		}
		return true;
	}

	public string Username { get; set; } = string.Empty;
	public string Password { get; set; } = string.Empty;
}
