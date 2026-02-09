using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON;

namespace P4NTH30N.C0MMON;

// [method: SetsRequiredMembers]
// public class House(string name) {
//     public ObjectId? _id { get; set; } = ObjectId.GenerateNewId();
//     public string URL { get; set; } = "";
//     public required string Name { get; set; } = name;
//     public string FacebookURL { get; set; } = "";
//     public string Description { get; set; } = "";
//     public string Redemption { get; set; } = "";
//     public string OffLimits { get; set; } = "";
//     public string Comments { get; set; } = "";
//     public string Website { get; set; } = "";
//     public bool Enabled { get; set; } = true;
//     public int Lifespan { get; set; } = 7;

//     public static House Get(string name) {
//         Database database = new();
//         IMongoCollection<House> collection = database.IO.GetCollection<House>("H0USE");
//         House? dto = null;
//         while (true) {
//             List<House> result = collection
//                 .Find(Builders<House>.Filter.Eq(x => x.Name, name))
//                 .ToList();
//             if (result.Count.Equals(0))
//                 collection.InsertOne(new House(name));
//             else {
//                 dto = result[0];
//                 break;
//             }
//         }
//         return dto;
//     }

//     public static List<House> GetAll() {
//         return Database.Find(Builders<House>.Filter.Empty).ToList();
//     }

//     public static void DeleteAll() {
//         Database.DeleteMany(Builders<House>.Filter.Empty);
//     }
//     public void Delete() {
//         FilterDefinition<House> filter = Builders<House>.Filter.Eq(x => x._id, _id);
//         Database.DeleteOne(filter);
//     }

//     public void Save() {
//         Database database = new();
//         IMongoCollection<House> collection = database.IO.GetCollection<House>("H0USE");
//         FilterDefinition<House> filter = Builders<House>.Filter.Eq(x => x._id, _id);
//         collection.ReplaceOne(filter, this);
//     }
// }


[method: SetsRequiredMembers]
public class House(string name, string? uRL = null) {
	public ObjectId? _id { get; set; } = ObjectId.GenerateNewId();
	// URL is user-facing metadata; allow null/blank.
	public string? URL { get; set; } = uRL;
	public required string Name { get; set; } = name;
    public string Description { get; set; } = "";
    public string Redemption { get; set; } = "";
    public string OffLimits { get; set; } = "";
    public string Comments { get; set; } = "";
    public int Lifespan { get; set; } = 7;

	private static readonly IMongoCollection<House> Database =
		 new Database().IO.GetCollection<House>("H0USE");
	public static List<House> GetAll() {
		return Database.Find(Builders<House>.Filter.Empty).ToList();
	}
	public static House? Get(string name) {
		if (string.IsNullOrWhiteSpace(name))
			return null;

		House? dto = Database.Find(Builders<House>.Filter.Eq("Name", name)).FirstOrDefault();
		if (dto is not null)
			return dto;

		// House docs are allowed to exist without a URL; create stub record on demand.
		House house = new(name, "");
		Database.InsertOne(house);
		return house;
	}
	public void Delete() {
		Database.DeleteOne(Builders<House>.Filter.Eq("_id", _id));
	}
    public void Save() {
        FilterDefinition<House> filter = Builders<House>.Filter.Eq("_id", _id);
        List<House> dto = Database.Find(filter).ToList();
        if (dto.Count.Equals(0)) {
            Database.InsertOne(this);
        } else {
            _id = dto[0]._id;
            Database.ReplaceOne(filter, this);
        }
    }
}
