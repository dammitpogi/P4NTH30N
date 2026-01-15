using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;

namespace P4NTH30N.C0MMON;

public class NewJackpot(string category, NewCredential credential) {
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public ObjectId Credential_id { get; set; } = credential._id;
	public string House { get; set; } = credential.House;
	public string Game { get; set; } = credential.Game;
	public string Category { get; set; } = category;
	public bool Enabled { get; set; } = true;
    #pragma warning disable format
    public int Priority { get; set; } = category switch { 
        "Grand" => 4, "Major" => 3, "Minor" => 2, "Mini" => 1, _ => 0
        #pragma warning restore format
    };
	public double Current { get; set; } = 0;
	public double Threshold { get; set; } = 0;
	public double DPM { get; set; } = 0;
	public JackpotToggles Toggles { get; set; } = new JackpotToggles();
	public JackpotDates Dates { get; set; } = new JackpotDates();
	public NewDPD DPD { get; set; } = new NewDPD();


	private static readonly IMongoCollection<NewJackpot> Database =
		new Database().IO.GetCollection<NewJackpot>("J4CKP0T_New");

	public static List<NewJackpot> GetBy(NewCredential credential) {
		return Database.Find(Builders<NewJackpot>.Filter.Eq("_id", credential._id)).ToList();
	}

	public void Save() {
		FilterDefinitionBuilder<NewJackpot> builder = Builders<NewJackpot>.Filter;
		FilterDefinition<NewJackpot> query = builder.Eq("Credential_id", Credential_id) & builder.Eq("Category", Category);
		List<NewJackpot> results = Database.Find(query).ToList();
		NewJackpot? existing = results.Count.Equals(0) ? null : results[0];
		if (existing != null) {
			_id = existing._id; Database.ReplaceOne(query, this);
		} else {
			Database.InsertOne(this);
		}
	}
}

public class JackpotEstimated {
	public bool ToPopThisWeek { get; set; } = false;
	public bool SometimeToday { get; set; } = false;
	public bool Within12H { get; set; } = false;
	public bool Within3H { get; set; } = false;
}
public class JackpotToggles {
	public bool AccountFunded { get; set; } = false;
	public bool WeekSinceReset { get; set; } = false;
	public bool OverdueForUpdate { get; set; } = false;
	public bool EnoughDataCollected { get; set; } = false;
	public JackpotEstimated Estimated { get; set; } = new JackpotEstimated();
}

public class JackpotDates {
	public DateTime UpdateBy { get; set; } = DateTime.MaxValue;
	public DateTime ResetDate { get; set; } = DateTime.UtcNow;
	public DateTime LastUpdated { get; set; } = DateTime.UtcNow;
	public DateTime EstimatedDate { get; set; } = DateTime.MaxValue;
}
public class NewDPD() {
	public double Average { get; set; } = 0F;
	public List<NewDPD_History> History { get; set; } = [];
	public List<NewDPD_Data> Data { get; set; } = [];
}

public class NewDPD_History(double average, List<NewDPD_Data> data) {
	public double Average { get; set; } = average;
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public List<NewDPD_Data> Data { get; set; } = data;
}

public class NewDPD_Data(double value) {
	public DateTime Timestamp { get; set; } = DateTime.UtcNow;
	public double Value { get; set; } = value;
}


// [method: SetsRequiredMembers]
// public NewJackpot(
//     NewCredential credential,
//     string category,
//     double current,
//     double threshold,
//     int priority,
//     DateTime eta
// ) {
//     Category = category;
//     Username = credential.Username;
//     Game = credential.Game;
//     Priority = priority;
//     DPM = DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
//     Current = current;
//     Threshold = threshold;
//     _id = ObjectId.GenerateNewId();
//     Dates.LastUpdated = DateTime.UtcNow;
//     Dates.EstimatedDate = eta;
//     double estimatedGrowth = DateTime.UtcNow.Subtract(credential.Dates.LastUpdated).TotalMinutes * DPM;

//     // List<DPD_Data> dataZoom = game.DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-7)).OrderBy(x => x.Timestamp).ToList();
//     // if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
//     //     double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
//     //     double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
//     //     DPM = dollars / minutes;

//     //     estimatedGrowth = DateTime.UtcNow.Subtract(game.LastUpdated).TotalMinutes * DPM;
//     //     double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
//     //     EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
//     // }

//     List<NewDPD_Data> dataZoom = DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-1))
//         .OrderBy(x => x.Timestamp)
//         .ToList();
//     if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
//         double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
//         double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
//         DPM = dollars / minutes;

//         estimatedGrowth = DateTime.UtcNow.Subtract(credential.Dates.LastUpdated).TotalMinutes * DPM;
//         double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
//         Dates.EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
//     }

//     dataZoom = DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddHours(-8))
//         .OrderBy(x => x.Timestamp)
//         .ToList();
//     if (eta < DateTime.UtcNow.AddHours(4) && dataZoom.Count >= 2) {
//         double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
//         double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
//         DPM = dollars / minutes;

//         estimatedGrowth = DateTime.UtcNow.Subtract(credential.Dates.LastUpdated).TotalMinutes * DPM;
//         double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
//         Dates.EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
//     }

//     current += estimatedGrowth;
// }

// public static List<NewJackpot> GetAll() {
//     return new Database()
//         .IO.GetCollection<NewJackpot>("J4CKP0TNew")
//         .Find(Builders<NewJackpot>.Filter.Empty)
//         .SortByDescending(x => x.Dates.EstimatedDate)
//         .ToList();
// }

// public void Save() {
//     FilterDefinitionBuilder<NewJackpot> builder = Builders<NewJackpot>.Filter;
//     FilterDefinition<NewJackpot> filter =
//         builder.Eq("Username", Username)
//         & builder.Eq("Game", Game)
//         & builder.Eq("Category", Category);
//     List<NewJackpot> dto = new Database()
//         .IO.GetCollection<NewJackpot>("J4CKP0TNew")
//         .Find(filter)
//         .ToList();
//     if (dto.Count.Equals(0))
//         new Database().IO.GetCollection<NewJackpot>("J4CKP0TNew").InsertOne(this);
//     else {
//         _id = dto[0]._id;
//         new Database().IO.GetCollection<NewJackpot>("J4CKP0TNew").ReplaceOne(filter, this);
//     }
// }




