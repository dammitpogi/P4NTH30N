using System;
using System.Dynamic;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTHE0N.C0MMON;

public class Database
{
	public IMongoDatabase IO { get; set; }

	public Database()
	{
#if DEBUG
		//IO = new MongoClient("mongodb://192.168.223.1:27017/").GetDatabase("P4NTHE0N");
		//IO = new MongoClient("mongodb://100.105.201.51:27017/").GetDatabase("P4NTHE0N");
		IO = new MongoClient("mongodb://localhost:27017/").GetDatabase("P4NTHE0N");
#else
		IO = new MongoClient("mongodb://localhost:27017/").GetDatabase("P4NTHE0N");
#endif
	}
}
