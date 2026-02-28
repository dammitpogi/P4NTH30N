using System;
using P4NTHE0N.C0MMON;
using P4NTHE0N.C0MMON.Interfaces;
using P4NTHE0N.C0MMON.Infrastructure.Persistence;

namespace P4NTHE0N.H0UND.Domain.Forecasting;

// DECISION_085: Post-processing pipeline for forecast ETAs
// Based on Klee & Xia (2025) post-processing rules and Hu et al. (2025) data quality assessment
public static class ForecastPostProcessor
{
	public const double MinReasonableDPD = DPD.MinReasonableDPD;
	public const double MaxReasonableDPD = DPD.MaxReasonableDPD;
	public static readonly TimeSpan DefaultEstimateHorizon = TimeSpan.FromDays(7);

	// DECISION_085: Post-process ETA with validation rules from Klee & Xia (2025)
	public static DateTime PostProcessETA(double minutes, IStoreErrors? errorLogger = null)
	{
		// Rule 1: Handle NaN/Infinity
		if (double.IsNaN(minutes) || double.IsInfinity(minutes))
		{
			errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError,
				"ForecastingService", $"Invalid minutes value: {minutes}", ErrorSeverity.Medium));
			return DateTime.UtcNow.Add(DefaultEstimateHorizon);
		}

		// Rule 2: Replace negative forecasts (Klee & Xia)
		if (minutes < 0)
		{
			errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError,
				"ForecastingService", $"Negative ETA minutes: {minutes:F2}", ErrorSeverity.Medium));
			return DateTime.UtcNow.Add(DefaultEstimateHorizon);
		}

		// Rule 3: Round to nearest minute
		minutes = Math.Round(minutes);

		DateTime eta = DateTime.UtcNow.AddMinutes(minutes);

		// Rule 4: Final guard - never allow past dates
		if (eta < DateTime.UtcNow)
		{
			errorLogger?.Insert(ErrorLog.Create(ErrorType.ValidationError,
				"ForecastingService", $"ETA resolved to past date after rounding: {eta:O}", ErrorSeverity.Medium));
			return DateTime.UtcNow.Add(DefaultEstimateHorizon);
		}

		return eta;
	}

	// DECISION_085: Validate DPD value is within research-backed bounds (Hu et al. 2025)
	public static bool IsDpdWithinBounds(double dpd)
	{
		if (double.IsNaN(dpd) || double.IsInfinity(dpd))
			return false;
		return dpd >= MinReasonableDPD && dpd <= MaxReasonableDPD;
	}
}
