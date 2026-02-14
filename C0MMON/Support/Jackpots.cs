using System;
using System.Runtime.Serialization;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class Jackpots
{
	private double _grand;
	private double _major;
	private double _minor;
	private double _mini;

	public double Grand
	{
		get => _grand;
		set => _grand = value;
	}

	public double Major
	{
		get => _major;
		set => _major = value;
	}

	public double Minor
	{
		get => _minor;
		set => _minor = value;
	}

	public double Mini
	{
		get => _mini;
		set => _mini = value;
	}
}
