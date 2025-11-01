using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.C0MMON;

namespace P4NTH30N.C0MMON;

[method: SetsRequiredMembers]
public class House(string name)
{
    public ObjectId? _id { get; set; } = ObjectId.GenerateNewId();
    public required string Name { get; set; } = name;
    public string[] Accounts { get; set; } = [];
    public bool Enabled { get; set; } = true;
    public string Facebook { get; set; } = "";
    public string Comments { get; set; } = "";

    public static House Get(string name)
    {
        Database database = new();
        IMongoCollection<House> collection = database.IO.GetCollection<House>("H0USE");
        FilterDefinition<House> filter = Builders<House>.Filter.Eq(x => x.Name, name);
        House? dto = null;
        while (true)
        {
            List<House> result = collection.Find(filter).ToList();
            if (result.Count.Equals(0))
            {
                collection.InsertOne(new House(name));
            }
            else
            {
                dto = result[0];
                break;
            }
        }
        return dto;
    }

    public void Save()
    {
        Database database = new();
        IMongoCollection<House> collection = database.IO.GetCollection<House>("H0USE");
        FilterDefinition<House> filter = Builders<House>.Filter.Eq(x => x._id, _id);
        collection.ReplaceOne(filter, this);
    }
}
