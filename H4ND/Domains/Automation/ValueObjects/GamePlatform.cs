using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Domains.Automation.ValueObjects;

public enum GamePlatform
{
	FireKirin,
	OrionStars,
	Gold777,
}

public static class GamePlatformParser
{
	public static GamePlatform Parse(string raw)
	{
		var normalized = Guard.NotNullOrWhiteSpace(raw).Trim();
		return normalized switch
		{
			"FireKirin" => GamePlatform.FireKirin,
			"OrionStars" => GamePlatform.OrionStars,
			"Gold777" => GamePlatform.Gold777,
			_ => throw new DomainException(
				$"Unsupported platform '{normalized}'.",
				"GamePlatform.Parse",
				context: normalized),
		};
	}
}
