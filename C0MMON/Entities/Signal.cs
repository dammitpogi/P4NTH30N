using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;

namespace P4NTH30N.C0MMON;

public class Signal : ICloneable
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Timeout { get; set; } = DateTime.MinValue;
	public DateTime CreateDate { get; set; } = DateTime.UtcNow;
	public bool Acknowledged { get; set; } = false;
	public string House { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public string Password { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public float Priority { get; set; }
	public string? ClaimedBy { get; set; }
	public DateTime? ClaimedAt { get; set; }

	public Signal() { }

	public Signal(float priority, Credential credential)
	{
		Priority = priority;
		House = credential.House;
		Username = credential.Username;
		Password = credential.Password;
		Game = credential.Game;
	}

	public object Clone()
	{
		return new Signal
		{
			Priority = this.Priority,
			House = this.House,
			Game = this.Game,
			Username = this.Username,
			Password = this.Password,
			Acknowledged = this.Acknowledged,
			CreateDate = this.CreateDate,
			Timeout = this.Timeout,
			ClaimedBy = this.ClaimedBy,
			ClaimedAt = this.ClaimedAt,
		};
	}
}
