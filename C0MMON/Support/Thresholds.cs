using System;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class Thresholds {
	private double _grand = 1785;
	private double _major = 565;
	private double _minor = 117;
	private double _mini = 23;

	public double Grand {
		get => _grand;
		set => _grand = Sanitize(value);
	}

	public double Major {
		get => _major;
		set => _major = Sanitize(value);
	}

	public double Minor {
		get => _minor;
		set => _minor = Sanitize(value);
	}

	public double Mini {
		get => _mini;
		set => _mini = Sanitize(value);
	}

	public void NewGrand(double priorJackpot) {
		Grand = Math.Min(Math.Max(priorJackpot + 0.2, 0), 10000);
	}

	public void NewMajor(double priorJackpot) {
		Major = Math.Min(Math.Max(priorJackpot + 0.2, 0), 10000);
	}

	public void NewMinor(double priorJackpot) {
		Minor = Math.Min(Math.Max(priorJackpot + 0.2, 0), 10000);
	}

	public void NewMini(double priorJackpot) {
		Mini = Math.Min(Math.Max(priorJackpot + 0.2, 0), 10000);
	}

	private static double Sanitize(double value) {
		if (double.IsNaN(value) || double.IsInfinity(value))
			return 0;
		if (value < 0)
			return 0;
		if (value > 10000)
			return 10000;
		return value;
	}
}
