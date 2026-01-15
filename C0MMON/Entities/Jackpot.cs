using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;

namespace P4NTH30N.C0MMON;

public class Jackpot {
    public ObjectId _id { get; set; }
    public double DPM { get; set; }
    public DateTime LastUpdated { get; set; }
    public DateTime EstimatedDate { get; set; }
    public required string House { get; set; }
    public required string Game { get; set; }
    public required string Category { get; set; }
    public double Current { get; set; }
    public double Threshold { get; set; }
    public int Priority { get; set; }

    [method: SetsRequiredMembers]
    public Jackpot(
        Game game,
        string category,
        double current,
        double threshold,
        int priority,
        DateTime eta
    ) {
        Category = category;
        House = game.House;
        Game = game.Name;
        Priority = priority;
        DPM = game.DPD.Average / TimeSpan.FromDays(1).TotalMinutes;
        Current = current;
        Threshold = threshold;
        _id = ObjectId.GenerateNewId();
        LastUpdated = DateTime.UtcNow;
        EstimatedDate = eta;
        double estimatedGrowth = DateTime.UtcNow.Subtract(game.LastUpdated).TotalMinutes * DPM;

        // List<DPD_Data> dataZoom = game.DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-7)).OrderBy(x => x.Timestamp).ToList();
        // if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
        //     double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
        //     double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
        //     DPM = dollars / minutes;

        //     estimatedGrowth = DateTime.UtcNow.Subtract(game.LastUpdated).TotalMinutes * DPM;
        //     double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
        //     EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
        // }

        List<DPD_Data> dataZoom = game
            .DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddDays(-1))
            .OrderBy(x => x.Timestamp)
            .ToList();
        if (eta < DateTime.UtcNow.AddDays(3) && dataZoom.Count >= 2) {
            double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
            double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
            DPM = dollars / minutes;

            estimatedGrowth = DateTime.UtcNow.Subtract(game.LastUpdated).TotalMinutes * DPM;
            double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
            EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
        }

        dataZoom = game
            .DPD.Data.FindAll(x => x.Timestamp > DateTime.UtcNow.AddHours(-8))
            .OrderBy(x => x.Timestamp)
            .ToList();
        if (eta < DateTime.UtcNow.AddHours(4) && dataZoom.Count >= 2) {
            double minutes = dataZoom[^1].Timestamp.Subtract(dataZoom[0].Timestamp).TotalMinutes;
            double dollars = dataZoom[^1].Grand - dataZoom[0].Grand;
            DPM = dollars / minutes;

            estimatedGrowth = DateTime.UtcNow.Subtract(game.LastUpdated).TotalMinutes * DPM;
            double MinutesToJackpot = Math.Max((threshold - (current + estimatedGrowth)) / DPM, 0);
            EstimatedDate = DateTime.UtcNow.AddMinutes(MinutesToJackpot);
        }

        current += estimatedGrowth;
    }

	public static Jackpot? Get(string category, string house, string game) {
		FilterDefinitionBuilder<Jackpot> builder = Builders<Jackpot>.Filter;
		FilterDefinition<Jackpot> query = builder.Eq("Category", category) & builder.Eq("House", house) & builder.Eq("Game", game);
		List<Jackpot> results = new Database().IO.GetCollection<Jackpot>("J4CKP0T").Find(query).ToList();
		return results.Count.Equals(0) ? null : results[0];
	}
    public static List<Jackpot> GetAll() {
        return new Database()
            .IO.GetCollection<Jackpot>("J4CKP0T")
            .Find(Builders<Jackpot>.Filter.Empty)
            .SortByDescending(x => x.EstimatedDate)
            .ToList();
    }

    public void Save() {
        FilterDefinitionBuilder<Jackpot> builder = Builders<Jackpot>.Filter;
        FilterDefinition<Jackpot> filter =
            builder.Eq("House", House)
            & builder.Eq("Game", Game)
            & builder.Eq("Category", Category);
        List<Jackpot> dto = new Database()
            .IO.GetCollection<Jackpot>("J4CKP0T")
            .Find(filter)
            .ToList();
        if (dto.Count.Equals(0))
            new Database().IO.GetCollection<Jackpot>("J4CKP0T").InsertOne(this);
        else {
            _id = dto[0]._id;
            new Database().IO.GetCollection<Jackpot>("J4CKP0T").ReplaceOne(filter, this);
        }
    }
}