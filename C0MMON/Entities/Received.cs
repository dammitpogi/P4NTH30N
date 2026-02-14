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

[method: SetsRequiredMembers]
public class Received(Signal signal, double triggered)
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Acknowledged { get; set; } = DateTime.UtcNow;
	public DateTime? Rewarded { get; set; } = null;
	public required string House { get; set; } = signal.House;
	public required string Game { get; set; } = signal.Game;
	public required string Username { get; set; } = signal.Username;
	public required string Password { get; set; } = signal.Password;
	public float Priority { get; set; } = signal.Priority;
	public double Triggered { get; set; } = triggered;
	public double? Threshold { get; set; } = null;
}
