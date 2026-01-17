using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public static class ReceivedExt {
	public static void Receive(this Signal signal, double triggered) {
		Received? dto = Received.GetOpen(signal);
		if (dto == null) {
			dto = new(signal, triggered);
		} else {
			dto.Acknowledged = DateTime.UtcNow;
			dto.Priority = signal.Priority;
			dto.Triggered = triggered;
		}
		dto.Save();
	}

	public static void Close(this Signal signal, double threshold) {
		Received? dto = Received.GetOpen(signal);
		if (dto != null) {
			dto.Rewarded = DateTime.UtcNow;
			dto.Threshold = threshold;
			dto.Save();
		}
	}
}

[method: SetsRequiredMembers]
public class Received(Signal signal, double triggered) {
	public ObjectId? _id { get; set; } = null;
	public DateTime Acknowledged { get; set; } = DateTime.UtcNow;
	public DateTime? Rewarded { get; set; } = null;
	public required string House { get; set; } = signal.House;
	public required string Game { get; set; } = signal.Game;
	public required string Username { get; set; } = signal.Username;
	public required string Password { get; set; } = signal.Password;
	public float Priority { get; set; } = signal.Priority;
	public double Triggered { get; set; } = triggered;
	public double? Threshold { get; set; } = null;

	public static List<Received> GetAll() {
		return new Database()
			.IO.GetCollection<Received>("REC31VED")
			.Find(Builders<Received>.Filter.Empty)
			.ToList();
	}

	public static Received? GetOpen(Signal signal) {
		FilterDefinitionBuilder<Received> builder = Builders<Received>.Filter;
		FilterDefinition<Received> filter =
			builder.Eq("House", signal.House)
			& builder.Eq("Game", signal.Game)
			& builder.Eq("Username", signal.Username)
			& builder.Eq("Rewarded", BsonNull.Value);
		List<Received> dto = new Database()
			.IO.GetCollection<Received>("REC31VED")
			.Find(filter)
			.ToList();
		return dto.Count.Equals(0) ? null : dto[0];
	}

	public void Save() {
		if (_id == null) {
			_id = ObjectId.GenerateNewId();
			new Database().IO.GetCollection<Received>("REC31VED").InsertOne(this);
		} else {
			new Database()
				.IO.GetCollection<Received>("REC31VED")
				.ReplaceOne(Builders<Received>.Filter.Eq("_id", _id), this);
		}
	}
}
