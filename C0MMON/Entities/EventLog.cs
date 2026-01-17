using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

[method: SetsRequiredMembers]
public class ProcessEvent(string process, string description) {
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Date { get; set; } = DateTime.Now;
	public string Process { get; set; } = process;
	public string Description { get; set; } = description;
    public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
    public string Username { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;

    public static ProcessEvent Log(string process, string description) {
        Console.WriteLine($"({DateTime.Now}) {description}");
        return new ProcessEvent(process, description);
    }
    public ProcessEvent Record(CredentialRecord credential) {
        House = credential.House;
        Game = credential.Game;
        return this;
    }
    public ProcessEvent Record(SignalRecord signal) {
        Username = signal.Username;
        Password = signal.Password;
        House = signal.House;
        Game = signal.Game;
        return this;
    }
	public void Save() {
        new Database().IO.GetCollection<ProcessEvent>("EV3NT").InsertOne(this);
	}
}
