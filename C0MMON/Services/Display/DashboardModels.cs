namespace P4NTHE0N.C0MMON.Services.Display;

/// <summary>
/// Upcoming jackpot in the schedule, sorted by ETA.
/// </summary>
public sealed record ScheduleEntry(
	string House,
	string Game,
	string Tier,
	DateTime ETA,
	double Current,
	double Threshold,
	int Priority)
{
	public TimeSpan TimeUntil => ETA > DateTime.UtcNow ? ETA - DateTime.UtcNow : TimeSpan.Zero;
	public double Remaining => Math.Max(Threshold - Current, 0);
	public double PercentComplete => Threshold > 0 ? Math.Min((Current / Threshold) * 100, 100) : 0;

	/// <summary>Urgency color based on time remaining.</summary>
	public string UrgencyStyle => TimeUntil.TotalHours switch
	{
		< 3 => "bold red",
		< 12 => "yellow",
		< 72 => "cyan",
		_ => "grey",
	};

	/// <summary>Human-readable ETA string.</summary>
	public string ETADisplay
	{
		get
		{
			TimeSpan t = TimeUntil;
			if (t.TotalMinutes < 1) return "NOW";
			if (t.TotalHours < 1) return $"{t.Minutes}m";
			if (t.TotalHours < 24) return $"{(int)t.TotalHours}h{t.Minutes:D2}m";
			if (t.TotalDays < 7) return $"{(int)t.TotalDays}d{t.Hours}h";
			return $"{(int)t.TotalDays}d";
		}
	}

	/// <summary>Short tier abbreviation.</summary>
	public string TierShort => Tier switch
	{
		"Grand" => "GRD",
		"Major" => "MAJ",
		"Minor" => "MIN",
		"Mini" => "MNI",
		_ => Tier[..3].ToUpper(),
	};
}

/// <summary>
/// Account with balance info for withdraw/deposit tracking.
/// </summary>
public sealed record AccountEntry(
	string Username,
	string House,
	string Game,
	double Balance,
	bool CashedOut,
	DateTime? LastDeposit)
{
	/// <summary>Short house abbreviation.</summary>
	public string HouseShort => House switch
	{
		"FireKirin" => "FK",
		"OrionStars" => "OS",
		_ => House.Length > 4 ? House[..4] : House,
	};
}

/// <summary>
/// Recently won jackpot event.
/// </summary>
public sealed record WonEntry(
	string House,
	string Game,
	string Tier,
	double PreviousValue,
	DateTime WonAt)
{
	public string HouseShort => House switch
	{
		"FireKirin" => "FK",
		"OrionStars" => "OS",
		_ => House.Length > 4 ? House[..4] : House,
	};
}

/// <summary>
/// Deposit recommendation based on upcoming schedule.
/// </summary>
public sealed record DepositEntry(
	string Username,
	string House,
	string Game,
	string Tier,
	TimeSpan TimeUntilJackpot)
{
	public string HouseShort => House switch
	{
		"FireKirin" => "FK",
		"OrionStars" => "OS",
		_ => House.Length > 4 ? House[..4] : House,
	};

	public string Deadline
	{
		get
		{
			if (TimeUntilJackpot.TotalMinutes < 1) return "NOW";
			if (TimeUntilJackpot.TotalHours < 1) return $"{TimeUntilJackpot.Minutes}m";
			if (TimeUntilJackpot.TotalHours < 24) return $"{(int)TimeUntilJackpot.TotalHours}h{TimeUntilJackpot.Minutes:D2}m";
			return $"{(int)TimeUntilJackpot.TotalDays}d{TimeUntilJackpot.Hours}h";
		}
	}
}
