using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

[method: SetsRequiredMembers]
public class SignalRecord(float priority, CredentialRecord credential) : ICloneable {
    public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
    public DateTime Timeout { get; set; } = DateTime.MinValue;
    public DateTime CreateDate { get; set; } = DateTime.UtcNow;
    public bool Acknowledged { get; set; } = false;
    public required string House { get; set; } = credential.House;
    public required string Username { get; set; } = credential.Username;
    public required string Password { get; set; } = credential.Password;
    public required string Game { get; set; } = credential.Game;
    public float Priority { get; set; } = priority;

    public static List<SignalRecord> GetAll() {
        return new Database()
            .IO.GetCollection<SignalRecord>("SIGN4L")
            .Find(Builders<SignalRecord>.Filter.Empty)
            .ToList();
    }

    public static SignalRecord? Get(string house, string game, string username) {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter =
            builder.Eq("House", house)
            & builder.Eq("Game", game)
            & builder.Eq("Username", username);
        List<SignalRecord> dto = new Database()
            .IO.GetCollection<SignalRecord>("SIGN4L")
            .Find(Builders<SignalRecord>.Filter.Eq("Acknowledged", false))
            .SortByDescending(g => g.Priority)
            .Limit(1)
            .ToList();
        return dto.Count.Equals(0) ? null : dto[0];
    }

    public static SignalRecord? Get(CredentialRecord credential) {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter = builder.Eq("Game", credential.Game) & builder.Eq("Username", credential.Username);
        List<SignalRecord> dto = new Database().IO.GetCollection<SignalRecord>("SIGN4L").Find(filter).ToList();
        return dto.Count.Equals(0) ? null : dto[0];
    }

    public static SignalRecord? GetNext() {
        List<SignalRecord> dto = new Database()
            .IO.GetCollection<SignalRecord>("SIGN4L")
            .Find(Builders<SignalRecord>.Filter.Eq("Acknowledged", false))
            .SortByDescending(g => g.Priority)
            .Limit(1)
            .ToList();
        return dto.Count.Equals(0) ? null : dto[0];
    }

    public static void DeleteAll(CredentialRecord credential) {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter =
            builder.Eq("Username", credential.Username) & builder.Eq("Game", credential.Game);
        new Database().IO.GetCollection<SignalRecord>("SIGN4L").DeleteMany(filter);
    }

    public bool Check() {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter =
            builder.Eq("House", House)
            & builder.Eq("Game", Game)
            & builder.Eq("Username", Username);
        List<SignalRecord> dto = new Database().IO.GetCollection<SignalRecord>("SIGN4L").Find(filter).ToList();
        return dto.Count.Equals(0) == false;
    }

    public void Acknowledge() {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter =
            builder.Eq("House", House)
            & builder.Eq("Game", Game)
            & builder.Eq("Username", Username);
        List<SignalRecord> dto = new Database().IO.GetCollection<SignalRecord>("SIGN4L").Find(filter).ToList();
        if (dto.Count.Equals(0) == false) {
            _id = dto[0]._id;
            Acknowledged = true;
            Timeout = DateTime.UtcNow.AddMinutes(1);
            new Database().IO.GetCollection<SignalRecord>("SIGN4L").ReplaceOne(filter, this);
        }
    }

    public void Save() {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter =
            builder.Eq("House", House)
            & builder.Eq("Game", Game)
            & builder.Eq("Username", Username);
        List<SignalRecord> dto = new Database().IO.GetCollection<SignalRecord>("SIGN4L").Find(filter).ToList();
        if (dto.Count.Equals(0))
            new Database().IO.GetCollection<SignalRecord>("SIGN4L").InsertOne(this);
        else {
            _id = dto[0]._id;
            new Database().IO.GetCollection<SignalRecord>("SIGN4L").ReplaceOne(filter, this);
        }
    }

    public void Delete() {
        FilterDefinitionBuilder<SignalRecord> builder = Builders<SignalRecord>.Filter;
        FilterDefinition<SignalRecord> filter =
            builder.Eq("House", House)
            & builder.Eq("Game", Game)
            & builder.Eq("Username", Username);
        new Database().IO.GetCollection<SignalRecord>("SIGN4L").DeleteOne(filter);
    }

    public object Clone() {
        return new SignalRecord(this.Priority, new CredentialRecord(this.Game) { House = this.House, Game = this.Game, Username = this.Username, Password = this.Password} ) {
            Acknowledged = this.Acknowledged,
            CreateDate = this.CreateDate,
            Timeout = this.Timeout,
        };
    }
}
