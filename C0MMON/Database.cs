using System;
using System.Dynamic;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public class Database {
    public IMongoDatabase IO { get; set; }

    public Database() {
        IO = new MongoClient("mongodb://192.168.223.1:27017/").GetDatabase("P4NTH30N");
    }
}
