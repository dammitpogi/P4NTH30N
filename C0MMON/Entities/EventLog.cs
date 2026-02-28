using System;
using System.Diagnostics.CodeAnalysis;
using MongoDB.Bson;

namespace P4NTHE0N.C0MMON;

public enum EventType
{
	SignalTriggered,
	LoginAttempt,
	JackpotPopped,
	JackpotWon,
	CashedOut,
	Other,
}

public class ProcessEvent
{
	public ObjectId _id { get; set; } = ObjectId.GenerateNewId();
	public DateTime Date { get; set; } = DateTime.Now;
	public EventType EventType { get; set; } = EventType.Other;
	public string Process { get; set; } = string.Empty;
	public string Description { get; set; } = string.Empty;
	public string House { get; set; } = string.Empty;
	public string Game { get; set; } = string.Empty;
	public string Username { get; set; } = string.Empty;
	public string Password { get; set; } = string.Empty;

	public ProcessEvent() { }

	public ProcessEvent(string process, string description)
	{
		Process = process;
		Description = description;
	}

	public static ProcessEvent Log(string process, string description)
	{
		Console.WriteLine($"({DateTime.Now}) {description}");
		return new ProcessEvent(process, description);
	}

	public ProcessEvent Record(Credential credential)
	{
		Username = credential.Username;
		Password = credential.Password;
		House = credential.House;
		Game = credential.Game;
		return this;
	}

	public ProcessEvent Record(Signal signal)
	{
		Username = signal.Username;
		Password = signal.Password;
		House = signal.House;
		Game = signal.Game;
		return this;
	}
}
