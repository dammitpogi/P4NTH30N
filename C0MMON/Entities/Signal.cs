using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;

namespace P4NTH30N.C0MMON;

[method: SetsRequiredMembers]
public class Signal(float priority, Credential credential) : ICloneable {
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Timeout { get; set; } = DateTime.MinValue;
	public DateTime CreateDate { get; set; } = DateTime.UtcNow;
	public bool Acknowledged { get; set; } = false;
	public required string House { get; set; } = credential.House;
	public required string Username { get; set; } = credential.Username;
	public required string Password { get; set; } = credential.Password;
	public required string Game { get; set; } = credential.Game;
	public float Priority { get; set; } = priority;

	public object Clone() {
		return new Signal(this.Priority, new Credential(this.Game) { House = this.House, Game = this.Game, Username = this.Username, Password = this.Password }) {
			Acknowledged = this.Acknowledged,
			CreateDate = this.CreateDate,
			Timeout = this.Timeout,
		};
	}
}
