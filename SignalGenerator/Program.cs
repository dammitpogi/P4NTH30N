using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;

class Program
{
    static void Main(string[] args)
    {
        try
        {
            Console.WriteLine("Connecting to MongoDB at 192.168.56.1:27017...");
            
            var client = new MongoClient("mongodb://192.168.56.1:27017");
            var database = client.GetDatabase("p4nth30n");
            
            var credentialsCollection = database.GetCollection<BsonDocument>("CRED3N7IAL");
            var signalsCollection = database.GetCollection<BsonDocument>("SIGN4L");
            
            Console.WriteLine("Reading credentials...");
            var credentials = credentialsCollection.Find(new BsonDocument()).ToList();
            
            Console.WriteLine($"Found {credentials.Count} credentials");
            
            var signals = new List<BsonDocument>();
            var random = new Random();
            
            foreach (var credential in credentials)
            {
                var signal = new BsonDocument
                {
                    { "credentialId", credential["_id"] },
                    { "signalType", "ACCESSIBLE" },
                    { "signalValue", random.Next(1, 101) },
                    { "timestamp", DateTime.UtcNow },
                    { "platform", "INTERNAL" },
                    { "status", "SUCCESS" }
                };
                
                signals.Add(signal);
            }
            
            Console.WriteLine($"Generated {signals.Count} signals");
            
            Console.WriteLine("Inserting signals into database...");
            signalsCollection.InsertMany(signals);
            
            Console.WriteLine("Signal generation completed successfully!");
            Console.WriteLine($"Total signals generated: {signals.Count}");
            
            // Verify insertion
            var signalCount = signalsCollection.Find(new BsonDocument()).CountDocuments();
            Console.WriteLine($"Total signals in database: {signalCount}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error: {ex.Message}");
            Console.WriteLine(ex.StackTrace);
        }
    }
}

