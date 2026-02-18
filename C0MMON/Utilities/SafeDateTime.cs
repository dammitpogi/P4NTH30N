namespace P4NTH30N.C0MMON.Utilities;

/// <summary>
/// Defensive DateTime arithmetic utilities to prevent ArgumentOutOfRangeException
/// when adding large or uncapped time intervals to DateTime values.
/// </summary>
/// <remarks>
/// FORGE-2024-001: Systematic DateTime Overflow Protection.
/// Root cause: ForecastingService returned 52M+ minutes, which when added to
/// DateTime.UtcNow exceeded DateTime.MaxValue, crashing H0UND.
///
/// PATTERN: Always use SafeDateTime.AddMinutes/AddHours instead of raw DateTime.Add*.
/// </remarks>
public static class SafeDateTime
{
	/// <summary>
	/// Maximum safe minutes that can be added to DateTime.UtcNow without overflow.
	/// ~7,969 years from 2026 → caps at year 9999.
	/// </summary>
	public static double GetSafeMaxMinutes()
	{
		return (DateTime.MaxValue - DateTime.UtcNow).TotalMinutes - 1;
	}

	/// <summary>
	/// Maximum safe hours that can be added to DateTime.UtcNow without overflow.
	/// </summary>
	public static double GetSafeMaxHours()
	{
		return (DateTime.MaxValue - DateTime.UtcNow).TotalHours - 1;
	}

	/// <summary>
	/// Maximum safe days that can be added to DateTime.UtcNow without overflow.
	/// </summary>
	public static double GetSafeMaxDays()
	{
		return (DateTime.MaxValue - DateTime.UtcNow).TotalDays - 1;
	}

	/// <summary>
	/// Caps a minutes value to the safe range for DateTime arithmetic.
	/// </summary>
	/// <param name="minutes">Raw minutes value (may be extremely large or NaN).</param>
	/// <returns>Capped minutes value safe for DateTime.AddMinutes().</returns>
	public static double CapMinutesToSafeRange(double minutes)
	{
		if (double.IsNaN(minutes) || double.IsInfinity(minutes) || minutes < 0)
			return GetSafeMaxMinutes();

		return Math.Min(minutes, GetSafeMaxMinutes());
	}

	/// <summary>
	/// Caps an hours value to the safe range for DateTime arithmetic.
	/// </summary>
	public static double CapHoursToSafeRange(double hours)
	{
		if (double.IsNaN(hours) || double.IsInfinity(hours) || hours < 0)
			return GetSafeMaxHours();

		return Math.Min(hours, GetSafeMaxHours());
	}

	/// <summary>
	/// Caps a days value to the safe range for DateTime arithmetic.
	/// </summary>
	public static double CapDaysToSafeRange(double days)
	{
		if (double.IsNaN(days) || double.IsInfinity(days) || days < 0)
			return GetSafeMaxDays();

		return Math.Min(days, GetSafeMaxDays());
	}

	/// <summary>
	/// Safe DateTime.AddMinutes that never throws ArgumentOutOfRangeException.
	/// Returns DateTime.MaxValue if the result would overflow.
	/// </summary>
	/// <param name="dateTime">Base DateTime.</param>
	/// <param name="minutes">Minutes to add.</param>
	/// <returns>Resulting DateTime, capped at DateTime.MaxValue.</returns>
	public static DateTime AddMinutes(DateTime dateTime, double minutes)
	{
		double safeMinutes = CapMinutesToSafeRange(minutes);
		double available = (DateTime.MaxValue - dateTime).TotalMinutes;

		if (safeMinutes >= available)
			return DateTime.MaxValue;

		return dateTime.AddMinutes(safeMinutes);
	}

	/// <summary>
	/// Safe DateTime.AddHours that never throws ArgumentOutOfRangeException.
	/// </summary>
	public static DateTime AddHours(DateTime dateTime, double hours)
	{
		double safeHours = CapHoursToSafeRange(hours);
		double available = (DateTime.MaxValue - dateTime).TotalHours;

		if (safeHours >= available)
			return DateTime.MaxValue;

		return dateTime.AddHours(safeHours);
	}

	/// <summary>
	/// Safe DateTime.AddDays that never throws ArgumentOutOfRangeException.
	/// </summary>
	public static DateTime AddDays(DateTime dateTime, double days)
	{
		double safeDays = CapDaysToSafeRange(days);
		double available = (DateTime.MaxValue - dateTime).TotalDays;

		if (safeDays >= available)
			return DateTime.MaxValue;

		return dateTime.AddDays(safeDays);
	}
}
