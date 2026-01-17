using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using MongoDB.Driver;

namespace P4NTH30N.C0MMON;

public static class ReceivedRecordExtensions {
	public static void Receive(this SignalRecord signal, double triggered) {
		ReceivedRecord? dto = ReceivedRecord.GetOpen(signal);
		if (dto == null) {
			dto = new(signal, triggered);
		} else {
			dto.Acknowledged = DateTime.UtcNow;
			dto.Priority = signal.Priority;
			dto.Triggered = triggered;
		}
		dto.Save();
	}

	public static void Close(this SignalRecord signal, double threshold) {
		ReceivedRecord? dto = ReceivedRecord.GetOpen(signal);
		if (dto != null) {
			dto.Rewarded = DateTime.UtcNow;
			dto.Threshold = threshold;
			dto.Save();
		}
	}
}

[method: SetsRequiredMembers]
public class ReceivedRecord(SignalRecord signal, double triggered) {
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

	public static List<ReceivedRecord> GetAll() {
		return new Database()
			.IO.GetCollection<ReceivedRecord>("REC31VED")
			.Find(Builders<ReceivedRecord>.Filter.Empty)
			.ToList();
	}

	public static ReceivedRecord? GetOpen(SignalRecord signal) {
		FilterDefinitionBuilder<ReceivedRecord> builder = Builders<ReceivedRecord>.Filter;
		FilterDefinition<ReceivedRecord> filter =
			builder.Eq("House", signal.House)
			& builder.Eq("Game", signal.Game)
			& builder.Eq("Username", signal.Username)
			& builder.Eq("Rewarded", BsonNull.Value);
		List<ReceivedRecord> dto = new Database()
			.IO.GetCollection<ReceivedRecord>("REC31VED")
			.Find(filter)
			.ToList();
		return dto.Count.Equals(0) ? null : dto[0];
	}

	public void Save() {
		if (_id == null) {
			_id = ObjectId.GenerateNewId();
			new Database().IO.GetCollection<ReceivedRecord>("REC31VED").InsertOne(this);
		} else {
			new Database()
				.IO.GetCollection<ReceivedRecord>("REC31VED")
				.ReplaceOne(Builders<ReceivedRecord>.Filter.Eq("_id", _id), this);
		}
	}

	// public static Received? Get(string house, string game, string username) {
	//     FilterDefinitionBuilder<Received> builder = Builders<Received>.Filter;
	//     FilterDefinition<Signal> filter = builder.Eq("House", house) & builder.Eq("Game", game) & builder.Eq("Username", username);
	//     List<Signal> dto = new Database().IO.GetCollection<Signal>("SIGN4L").Find(Builders<Signal>.Filter.Eq("Acknowledged", false)).SortByDescending(g => g.Priority).Limit(1).ToList();
	//     return dto.Count.Equals(0) ? null : dto[0];
	// }

	// public static Signal? GetOne(Game game) {
	//     FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
	//     FilterDefinition<Signal> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name);
	//     List<Signal> dto = new Database().IO.GetCollection<Signal>("SIGN4L").Find(filter).ToList();
	//     return dto.Count.Equals(0) ? null : dto[0];
	// }
	// public static Signal? GetNext() {
	//     List<Signal> dto = new Database().IO.GetCollection<Signal>("SIGN4L").Find(Builders<Signal>.Filter.Eq("Acknowledged", false)).SortByDescending(g => g.Priority).Limit(1).ToList();
	//     return dto.Count.Equals(0) ? null : dto[0];
	// }

	// public static void DeleteAll(Game game) {
	//     FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
	//     FilterDefinition<Signal> filter = builder.Eq("House", game.House) & builder.Eq("Game", game.Name);
	//     new Database().IO.GetCollection<Signal>("SIGN4L").DeleteMany(filter);
	// }

	// public bool Check() {
	//     FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
	//     FilterDefinition<Signal> filter = builder.Eq("House", House) & builder.Eq("Game", Game) & builder.Eq("Username", Username);
	//     List<Signal> dto = new Database().IO.GetCollection<Signal>("SIGN4L").Find(filter).ToList();
	//     return dto.Count.Equals(0) == false;
	// }

	// public void Acknowledge() {
	//     FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
	//     FilterDefinition<Signal> filter = builder.Eq("House", House) & builder.Eq("Game", Game) & builder.Eq("Username", Username);
	//     List<Signal> dto = new Database().IO.GetCollection<Signal>("SIGN4L").Find(filter).ToList();
	//     if (dto.Count.Equals(0) == false) {
	//         _id = dto[0]._id;
	//         Acknowledged = true;
	//         Timeout = DateTime.UtcNow.AddMinutes(1);
	//         new Database().IO.GetCollection<Signal>("SIGN4L").ReplaceOne(filter, this);
	//     }
	// }

	// public void Delete() {
	//     FilterDefinitionBuilder<Signal> builder = Builders<Signal>.Filter;
	//     FilterDefinition<Signal> filter = builder.Eq("House", House) & builder.Eq("Game", Game) & builder.Eq("Username", Username);
	//     new Database().IO.GetCollection<Signal>("SIGN4L").DeleteOne(filter);
	// }
}
