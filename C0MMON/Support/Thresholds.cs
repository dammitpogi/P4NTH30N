using System;
using System.Runtime.Serialization;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class Thresholds
{
	private double _grand = 1785;
	private double _major = 565;
	private double _minor = 117;
	private double _mini = 23;

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

	public void NewGrand(double priorJackpot)
	{
		if (priorJackpot > Grand)
		{
			Grand = priorJackpot;
		}
	}

	public void NewMajor(double priorJackpot)
	{
		if (priorJackpot > Major)
		{
			Major = priorJackpot;
		}
	}

	public void NewMinor(double priorJackpot)
	{
		if (priorJackpot > Minor)
		{
			Minor = priorJackpot;
		}
	}

	public void NewMini(double priorJackpot)
	{
		if (priorJackpot > Mini)
		{
			Mini = priorJackpot;
		}
	}
}
