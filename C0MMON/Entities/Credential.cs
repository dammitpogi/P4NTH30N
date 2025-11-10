using System;
using System.Security.Cryptography.X509Certificates;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public class Credential {
    public ObjectId _id { get; set; }
    public bool Enabled { get; set; }
    public bool Banned { get; set; }
    public int PROF3T_ID { get; set; }
    public required string House { get; set; }
    public required string Game { get; set; }
    public DateTime? LastUpdated { get; set; }
    public DateTime? LastDepositDate { get; set; }
    public bool CashedOut { get; set; }
    public double Balance { get; set; }
    public required string Username { get; set; }
    public required string Password { get; set; }

    public static List<Credential> Database() {
        return new Database().IO.GetCollection<Credential>("CRED3N7IAL").Find(Builders<Credential>.Filter.Empty).ToList();
    }

    public static List<Credential> GetAll() {
        Database database = new();
        IMongoCollection<Credential> collection = database.IO.GetCollection<Credential>("CRED3N7IAL");
        List<Credential> credentials = collection.Find(Builders<Credential>.Filter.Eq("Banned", false)).SortByDescending(c => c.Balance).ToList();
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
