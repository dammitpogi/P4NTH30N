using System;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON;

[BsonIgnoreExtraElements]
public class Jackpots {
	private double _grand;
	private double _major;
	private double _minor;
	private double _mini;

	public double Grand {
		get => _grand;
		set => _grand = SanitizeTierValue("Grand", value);
	}

	public double Major {
		get => _major;
		set => _major = SanitizeTierValue("Major", value);
	}

	public double Minor {
		get => _minor;
		set => _minor = SanitizeTierValue("Minor", value);
	}

	public double Mini {
		get => _mini;
		set => _mini = SanitizeTierValue("Mini", value);
	}

	private static double SanitizeTierValue(string tier, double value) {
		if (double.IsNaN(value) || double.IsInfinity(value))
			return 0;

		if (value < 0)
			return 0;

		double max = tier switch {
			"Mini" => 50.0,
			"Minor" => 200.0,
			"Major" => 1000.0,
			"Grand" => 10000.0,
			_ => 10000.0,
		};

		// Common corruption: values captured without cents normalization.
		// Prefer a correction that brings the value back into the expected tier range.
		if (value > max) {
			double dividedBy100 = value / 100.0;
			if (dividedBy100 <= max)
				return dividedBy100;

			double dividedBy1000 = value / 1000.0;
			if (dividedBy1000 <= max)
				return dividedBy1000;

			return max;
		}

		return value;
	}
}
