using P4NTH30N.HUN7ER.Domain.ValueObjects;

namespace P4NTH30N.HUN7ER.Domain.Entities;

/// <summary>
/// Domain entity representing a game account credential
/// </summary>
public class GameCredential
{
	public string Id { get; set; } = string.Empty;
	public required string Username { get; set; }
	public required string Password { get; set; }
	public required string House { get; set; }
	public required string Game { get; set; }

	public double Balance { get; set; }
	public JackpotValues Jackpots { get; set; } = new();
	public Thresholds Thresholds { get; set; } = new();
	public DollarsPerDay DPD { get; set; } = new();

	public bool Enabled { get; set; } = true;
	public bool Banned { get; set; }
	public bool Unlocked { get; set; } = true;
	public bool CashedOut { get; set; }
	public DateTime? LastDepositDate { get; set; }
	public DateTime LastUpdated { get; set; }
	public DateTime UnlockTimeout { get; set; }

	// Game settings for which tiers to spin
	public bool SpinGrand { get; set; } = true;
	public bool SpinMajor { get; set; } = true;
	public bool SpinMinor { get; set; } = true;
	public bool SpinMini { get; set; } = true;
	public bool Hidden { get; set; } = false;

	public GameCredential() { }

	public GameCredential(string username, string password, string house, string game)
	{
		Username = username;
		Password = password;
		House = house;
		Game = game;
	}

	/// <summary>
	/// Validates the credential's state
	/// </summary>
	public bool IsValid => !string.IsNullOrEmpty(Username) && !string.IsNullOrEmpty(House) && !string.IsNullOrEmpty(Game) && Jackpots.IsValid && Balance >= 0;

	/// <summary>
	/// Checks if credential is statistically reliable for predictions
	/// </summary>
	public bool IsStatisticallyReliable()
	{
		return !DPD.IsHighDpdWithLowData;
	}

	/// <summary>
	/// Detects and processes jackpot changes
	/// </summary>
	public JackpotTier? DetectJackpotPop(JackpotValues previous, JackpotValues current)
	{
		// Grand
		if (current.Grand < previous.Grand && previous.Grand - current.Grand > 0.1)
		{
			if (DPD.Toggles.IsPopped(JackpotTier.Grand))
			{
				DPD.Toggles.MarkResolved(JackpotTier.Grand);
				Thresholds.NewGrand(previous.Grand);
				Jackpots.Grand = current.Grand;
				return JackpotTier.Grand;
			}
			DPD.Toggles.MarkPopped(JackpotTier.Grand);
		}
		else if (current.Grand >= 0 && current.Grand <= 10000)
		{
			Jackpots.Grand = current.Grand;
		}

		// Major
		if (current.Major < previous.Major && previous.Major - current.Major > 0.1)
		{
			if (DPD.Toggles.IsPopped(JackpotTier.Major))
			{
				DPD.Toggles.MarkResolved(JackpotTier.Major);
				Thresholds.NewMajor(previous.Major);
				Jackpots.Major = current.Major;
				return JackpotTier.Major;
			}
			DPD.Toggles.MarkPopped(JackpotTier.Major);
		}
		else if (current.Major >= 0 && current.Major <= 10000)
		{
			Jackpots.Major = current.Major;
		}

		// Minor
		if (current.Minor < previous.Minor && previous.Minor - current.Minor > 0.1)
		{
			if (DPD.Toggles.IsPopped(JackpotTier.Minor))
			{
				DPD.Toggles.MarkResolved(JackpotTier.Minor);
				Thresholds.NewMinor(previous.Minor);
				Jackpots.Minor = current.Minor;
				return JackpotTier.Minor;
			}
			DPD.Toggles.MarkPopped(JackpotTier.Minor);
		}
		else if (current.Minor >= 0 && current.Minor <= 10000)
		{
			Jackpots.Minor = current.Minor;
		}

		// Mini
		if (current.Mini < previous.Mini && previous.Mini - current.Mini > 0.1)
		{
			if (DPD.Toggles.IsPopped(JackpotTier.Mini))
			{
				DPD.Toggles.MarkResolved(JackpotTier.Mini);
				Thresholds.NewMini(previous.Mini);
				Jackpots.Mini = current.Mini;
				return JackpotTier.Mini;
			}
			DPD.Toggles.MarkPopped(JackpotTier.Mini);
		}
		else if (current.Mini >= 0 && current.Mini <= 10000)
		{
			Jackpots.Mini = current.Mini;
		}

		return null;
	}

	/// <summary>
	/// Updates DPD based on current jackpot values
	/// </summary>
	public void UpdateDPD()
	{
		if (!Jackpots.IsValid)
			return;

		if (DPD.Data.Count == 0)
		{
			DPD.Data.Add(new DpdDataPoint(Jackpots.Grand, Jackpots.Major, Jackpots.Minor, Jackpots.Mini));
			return;
		}

		double previousGrand = DPD.Data[^1].Grand;

		if (Jackpots.Grand != previousGrand && Jackpots.Grand < 100000)
		{
			if (Jackpots.Grand > previousGrand)
			{
				DPD.AddDataPoint(new DpdDataPoint(Jackpots.Grand, Jackpots.Major, Jackpots.Minor, Jackpots.Mini));
			}
			else
			{
				// Jackpot reset detected
				DPD.RecordHistory();
				DPD.Data.Add(new DpdDataPoint(Jackpots.Grand, Jackpots.Major, Jackpots.Minor, Jackpots.Mini));
				DPD.Average = 0;
			}
		}

		// Restore from history if needed
		if (DPD.Average == 0 && DPD.History.Count > 0)
		{
			DPD.RestoreFromHistory();
		}
	}
}
