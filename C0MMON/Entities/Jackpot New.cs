using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public class NewJackpot {
    public ObjectId _id { get; set; }
    public double DPM { get; set; }
    public NewDPD DPD { get; set; } = new NewDPD();
    public DateTime LastUpdated { get; set; }
    public DateTime EstimatedDate { get; set; }
    public required string Username { get; set; }
    public required string Game { get; set; }
    public required string Category { get; set; }
    public double Current { get; set; }
    public double Threshold { get; set; }
    public int Priority { get; set; }

    [method: SetsRequiredMembers]
    public NewJackpot(
        NewCredential credential,
        string category,
        double current,
        double threshold,
        int priority,
        DateTime eta
    ) {
        Category = category;
        Username = credential.Username;
        Game = credential.Game;
        Priority = priority;
        DPM = DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
        Current = current;
        Threshold = threshold;
        _id = ObjectId.GenerateNewId();
        LastUpdated = DateTime.UtcNow;
        EstimatedDate = eta;
        double estimatedGrowth = DateTime.UtcNow.Subtract(credential.Dates.LastUpdated).TotalMinutes * DPM;

        // List<DPD_Data> dataZoom = game.DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-7)).OrderBy(x => x.Timestamp).ToList();
        // if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
        //     double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
        //     double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
        //     DPM = dollars / minutes;

        //     estimatedGrowth = DateTime.UtcNow.Subtract(game.LastUpdated).TotalMinutes * DPM;
        //     double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
        //     EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
        // }

        List<NewDPD_Data> dataZoom = DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-1))
            .OrderBy(x => x.Timestamp)
            .ToList();
        if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
            double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
            double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
            DPM = dollars / minutes;

            estimatedGrowth = DateTime.UtcNow.Subtract(credential.Dates.LastUpdated).TotalMinutes * DPM;
            double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
            EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
        }

        dataZoom = DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddHours(-8))
            .OrderBy(x => x.Timestamp)
            .ToList();
        if (eta < DateTime.UtcNow.AddHours(4) && dataZoom.Count >= 2) {
            double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
            double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
            DPM = dollars / minutes;

            estimatedGrowth = DateTime.UtcNow.Subtract(credential.Dates.LastUpdated).TotalMinutes * DPM;
            double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
            EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
        }

        current += estimatedGrowth;
    }

    public static List<NewJackpot> GetAll() {
        return new Database()
            .IO.GetCollection<NewJackpot>("J4CKP0TNew")
            .Find(Builders<NewJackpot>.Filter.Empty)
            .SortByDescending(x => x.EstimatedDate)
            .ToList();
    }

    public void Save() {
        FilterDefinitionBuilder<NewJackpot> builder = Builders<NewJackpot>.Filter;
        FilterDefinition<NewJackpot> filter =
            builder.Eq("Username", Username)
            & builder.Eq("Game", Game)
            & builder.Eq("Category", Category);
        List<NewJackpot> dto = new Database()
            .IO.GetCollection<NewJackpot>("J4CKP0TNew")
            .Find(filter)
            .ToList();
        if (dto.Count.Equals(0))
            new Database().IO.GetCollection<NewJackpot>("J4CKP0TNew").InsertOne(this);
        else {
            _id = dto[0]._id;
            new Database().IO.GetCollection<NewJackpot>("J4CKP0TNew").ReplaceOne(filter, this);
        }
    }
}


[method: SetsRequiredMembers]
public class NewDPD() {
    public double Average { get; set; } = 0F;
    public required List<NewDPD_History> History { get; set; } = [];
    public required List<NewDPD_Data> Data { get; set; } = [];
}

[method: SetsRequiredMembers]
public class NewDPD_History(double average, List<NewDPD_Data> data) {
    public double Average { get; set; } = average;
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public required List<NewDPD_Data> Data { get; set; } = data;
}

public class NewDPD_Data(double grand) {
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    public double Grand { get; set; } = grand;
}
