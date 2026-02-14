namespace P4NTH30N.HUN7ER.Domain.ValueObjects;

public enum JackpotTier
{
	Mini = 1,
	Minor = 2,
	Major = 3,
	Grand = 4,
}

public static class JackpotTierExtensions
{
	public static double DefaultThreshold(this JackpotTier tier) =>
		tier switch
		{
			JackpotTier.Grand => 1785,
			JackpotTier.Major => 565,
			JackpotTier.Minor => 117,
			JackpotTier.Mini => 23,
			_ => 0,
		};

	public static double Capacity(this JackpotTier tier) =>
		tier switch
		{
			JackpotTier.Grand => 1500,
			JackpotTier.Major => 500,
			JackpotTier.Minor => 100,
			JackpotTier.Mini => 20,
			_ => 0,
		};

	public static JackpotTier FromString(string category) =>
		category.ToUpperInvariant() switch
		{
			"GRAND" => JackpotTier.Grand,
			"MAJOR" => JackpotTier.Major,
			"MINOR" => JackpotTier.Minor,
			"MINI" => JackpotTier.Mini,
			_ => throw new ArgumentException($"Unknown jackpot category: {category}"),
		};
}
