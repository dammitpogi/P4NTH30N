using System;
using System.Diagnostics.CodeAnalysis;
using System.Security.Cryptography.X509Certificates;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public class CredentialRecord(string game) {
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public ObjectId? PROF3T_id { get; set; } = null;
	public bool Enabled { get; set; } = true;
	public double Balance { get; set; } = 0;
	public string Game { get; set; } = game;
	public string House { get; set => field = value.TrimEnd('0', '1', '2', '3', '4', '5', '6', '7', '8', '9').TrimEnd('#').Trim(); } = "";
	public string URL { get; set => field = value.TrimEnd('#').TrimEnd('/'); } = "";
	public string Username { get; set; } = "";
	public string Password { get; set; } = "";
	public CredentialJackpots Jackpots { get; set; } = new CredentialJackpots();
	public CredentialGameSettings Settings { get; set; } = new CredentialGameSettings(game);
	public CredentialToggles Toggles { get; set; } = new CredentialToggles();
	public CredentialDates Dates { get; set; } = new CredentialDates();


	private static readonly IMongoCollection<CredentialRecord> Database =
		 new Database().IO.GetCollection<CredentialRecord>("CRED3N7IAL_New");

	// Central credential collection backing the "iterate credentials" flow (replacing Game-level iteration).
	public static List<CredentialRecord> GetAll() {
		return Database.Find(Builders<CredentialRecord>.Filter.Empty).ToList();
	}

	// Pulls the next unlocked, enabled credential to work on, ordered by least-recently-updated.
	// This mirrors the old "Game.GetNext()" queue semantics but operates at the credential level.
	public static CredentialRecord GetNext() {
		FilterDefinitionBuilder<CredentialRecord> builder = Builders<CredentialRecord>.Filter;
		FilterDefinition<CredentialRecord> filter =
			builder.Eq("Enabled", true)
			& builder.Eq("Toggles.Banned", false)
			& builder.Eq("Toggles.Unlocked", true);
		return Database
			.Find(filter)
			.SortBy(credential => credential.Dates.LastUpdated)
			.First();
	}

	public static class GetBy {
		public static CredentialRecord? Username(string game, string username) {
			FilterDefinitionBuilder<CredentialRecord> builder = Builders<CredentialRecord>.Filter;
			FilterDefinition<CredentialRecord> query = builder.Eq("Game", game) & builder.Eq("Username", username);
			List<CredentialRecord> results = Database.Find(query).ToList();
			return results.Count.Equals(0) ? null : results[0];
		}
	}
	public void Lock() {
		// Credential-level lock mirrors the old Game lock, but applies to a single account instead.
		Dates.UnlockTimeout = DateTime.UtcNow.AddMinutes(1.5);
		Toggles.Unlocked = false;
		Save();
	}
	public void Unlock() {
		// Unlocking re-enables this credential for iteration after the session finishes.
		Toggles.Unlocked = true;
		Save();
	}
	public void Save() {
		FilterDefinitionBuilder<CredentialRecord> builder = Builders<CredentialRecord>.Filter;
		FilterDefinition<CredentialRecord> query = builder.Eq("Game", Game) & builder.Eq("Username", Username);
		List<CredentialRecord> results = Database.Find(query).ToList();
		CredentialRecord? existing = results.Count.Equals(0) ? null : results[0];
		if (existing != null) {
			_id = existing._id; Database.ReplaceOne(query, this);
		} else {
			Database.InsertOne(this);
		}
	}
}

public class CredentialDates() {
	public DateTime CreateDate { get; set; } = DateTime.UtcNow;
	public DateTime LastUpdated { get; set; } = DateTime.UtcNow.AddDays(-1);
	public DateTime UnlockTimeout { get; set; } = DateTime.MinValue;
	public DateTime LastDepositDate { get; set; } = DateTime.UtcNow.AddDays(-1);
}
public class CredentialToggles() {
	public bool Banned { get; set; } = false;
	public bool Unlocked { get; set; } = true;
	public bool CashedOut { get; set; } = true;
}
public class CredentialJackpots {
	public double Grand { get; set; } = 0;
	public double Major { get; set; } = 0;
	public double Minor { get; set; } = 0;
	public double Mini { get; set; } = 0;
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

public class CredentialGameSettings(string game) {
	public FortunePiggySettings FortunePiggy { get; set; } = new FortunePiggySettings(game);
	public Quintuple5XSettings Quintuple5X { get; set; } = new Quintuple5XSettings();
	public Gold777Settings Gold777 { get; set; } = new Gold777Settings();
	public bool SpinGrand { get; set; } = true;
	public bool SpinMajor { get; set; } = true;
	public bool SpinMinor { get; set; } = true;
	public bool SpinMini { get; set; } = true;
	public bool Hidden { get; set; } = false;
}

public class Gold777Settings {
	public int Page { get; set; } = 10;

	// public int Button_X { get; set; } = 603;
	// public int Button_Y { get; set; } = 457;
	public int Button_X { get; set; } = 450;
	public int Button_Y { get; set; } = 280;
	public bool ButtonVerified { get; set; } = false;
}

public class FortunePiggySettings {
	public int Page { get; set; } // = game.Equals("FireKirin") ? 7 : 7;
	public int Button_X { get; set; } // = game.Equals("FireKirin") ? 820 : 820;
	public int Button_Y { get; set; } // = game.Equals("FireKirin") ? 450 : 450;
	public bool ButtonVerified { get; set; } = false;

	public FortunePiggySettings(string game) {
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

public class Quintuple5XSettings {
	public int Page { get; set; } = 7;

	// public int Button_X { get; set; } = 603;
	// public int Button_Y { get; set; } = 457;
	public int Button_X { get; set; } = 820;
	public int Button_Y { get; set; } = 450;
	public bool ButtonVerified { get; set; } = false;
}
