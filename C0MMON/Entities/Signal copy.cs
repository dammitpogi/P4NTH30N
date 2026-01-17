// using System;
// using System.Diagnostics.CodeAnalysis;
// using MongoDB.Bson;
// using MongoDB.Driver;

// namespace P4NTH30N.C0MMON;

// [method: SetsRequiredMembers]
// public class NewSignal(float priority, NewCredential credential) : ICloneable {
//     public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
//     public DateTime Timeout { get; set; } = DateTime.MinValue;
//     public DateTime CreateDate { get; set; } = DateTime.UtcNow;
//     public bool Acknowledged { get; set; } = false;
//     public required string House { get; set; } = credential.House;
//     public required string Username { get; set; } = credential.Username;
//     public required string Password { get; set; } = credential.Password;
//     public required string Game { get; set; } = credential.Game;
//     public float Priority { get; set; } = priority;

//     public static List<NewSignal> GetAll() {
//         return new Database()
//             .IO.GetCollection<NewSignal>("SIGN4L")
//             .Find(Builders<NewSignal>.Filter.Empty)
//             .ToList();
//     }

//     public static NewSignal? Get(string house, string game, string username) {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter =
//             builder.Eq("House", house)
//             & builder.Eq("Game", game)
//             & builder.Eq("Username", username);
//         List<NewSignal> dto = new Database()
//             .IO.GetCollection<NewSignal>("SIGN4L")
//             .Find(Builders<NewSignal>.Filter.Eq("Acknowledged", false))
//             .SortByDescending(g => g.Priority)
//             .Limit(1)
//             .ToList();
//         return dto.Count.Equals(0) ? null : dto[0];
//     }

//     public static NewSignal? Get(NewCredential credential) {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter = builder.Eq("Game", credential.Game) & builder.Eq("Username", credential.Username);
//         List<NewSignal> dto = new Database().IO.GetCollection<NewSignal>("SIGN4L").Find(filter).ToList();
//         return dto.Count.Equals(0) ? null : dto[0];
//     }

//     public static NewSignal? GetNext() {
//         List<NewSignal> dto = new Database()
//             .IO.GetCollection<NewSignal>("SIGN4L")
//             .Find(Builders<NewSignal>.Filter.Eq("Acknowledged", false))
//             .SortByDescending(g => g.Priority)
//             .Limit(1)
//             .ToList();
//         return dto.Count.Equals(0) ? null : dto[0];
//     }

//     public static void DeleteAll(NewCredential credential) {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter =
//             builder.Eq("Username", credential.Username) & builder.Eq("Game", credential.Game);
//         new Database().IO.GetCollection<NewSignal>("SIGN4L").DeleteMany(filter);
//     }

//     public bool Check() {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter =
//             builder.Eq("House", House)
//             & builder.Eq("Game", Game)
//             & builder.Eq("Username", Username);
//         List<NewSignal> dto = new Database().IO.GetCollection<NewSignal>("SIGN4L").Find(filter).ToList();
//         return dto.Count.Equals(0) == false;
//     }

//     public void Acknowledge() {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter =
//             builder.Eq("House", House)
//             & builder.Eq("Game", Game)
//             & builder.Eq("Username", Username);
//         List<NewSignal> dto = new Database().IO.GetCollection<NewSignal>("SIGN4L").Find(filter).ToList();
//         if (dto.Count.Equals(0) == false) {
//             _id = dto[0]._id;
//             Acknowledged = true;
//             Timeout = DateTime.UtcNow.AddMinutes(1);
//             new Database().IO.GetCollection<NewSignal>("SIGN4L").ReplaceOne(filter, this);
//         }
//     }

//     public void Save() {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter =
//             builder.Eq("House", House)
//             & builder.Eq("Game", Game)
//             & builder.Eq("Username", Username);
//         List<NewSignal> dto = new Database().IO.GetCollection<NewSignal>("SIGN4L").Find(filter).ToList();
//         if (dto.Count.Equals(0))
//             new Database().IO.GetCollection<NewSignal>("SIGN4L").InsertOne(this);
//         else {
//             _id = dto[0]._id;
//             new Database().IO.GetCollection<NewSignal>("SIGN4L").ReplaceOne(filter, this);
//         }
//     }

//     public void Delete() {
//         FilterDefinitionBuilder<NewSignal> builder = Builders<NewSignal>.Filter;
//         FilterDefinition<NewSignal> filter =
//             builder.Eq("House", House)
//             & builder.Eq("Game", Game)
//             & builder.Eq("Username", Username);
//         new Database().IO.GetCollection<NewSignal>("SIGN4L").DeleteOne(filter);
//     }

//     public object Clone() {
//         return new NewSignal(this.Priority, new NewCredential(this.Game) { House = this.House, Game = this.Game, Username = this.Username, Password = this.Password} ) {
//             Acknowledged = this.Acknowledged,
//             CreateDate = this.CreateDate,
//             Timeout = this.Timeout,
//         };
//     }
// }
