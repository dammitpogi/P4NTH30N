using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;
using P4NTH30N.C0MMON.Infrastructure.Persistence;

namespace P4NTH30N.C0MMON;

public static class ReceivedExt
{
	public static void Receive(this Signal signal, double triggered, IReceiveSignals received)
	{
		Received? dto = received.GetOpen(signal);
		if (dto == null)
		{
			dto = new Received(signal, triggered) { _id = ObjectId.GenerateNewId() };
		}
		else
		{
			dto.Acknowledged = DateTime.UtcNow;
			dto.Priority = signal.Priority;
			dto.Triggered = triggered;
		}
		received.Upsert(dto);
	}

	public static void Close(this Signal signal, double threshold, IReceiveSignals received)
	{
		Received? dto = received.GetOpen(signal);
		if (dto != null)
		{
			dto.Rewarded = DateTime.UtcNow;
			dto.Threshold = threshold;
			received.Upsert(dto);
		}
	}
}

public class Received
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Acknowledged { get; set; } = DateTime.UtcNow;
	public DateTime? Rewarded { get; set; } = null;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public string Password { get; set; } = string.Empty;
	public float Priority { get; set; }
	public double Triggered { get; set; }
	public double? Threshold { get; set; } = null;

	public Received() { }

	public Received(Signal signal, double triggered)
	{
		House = signal.House;
		Game = signal.Game;
		Username = signal.Username;
		Password = signal.Password;
		Priority = signal.Priority;
		Triggered = triggered;
	}
}
