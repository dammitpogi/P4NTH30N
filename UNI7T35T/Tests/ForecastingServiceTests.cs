using P4NTHE0N.C0MMON;
using P4NTHE0N.H0UND.Domain.Forecasting;
using UNI7T35T.Mocks;

namespace UNI7T35T.Tests;

public class ForecastingServiceTests
{
	private MockUnitOfWork _uow = new MockUnitOfWork();

	public void Setup()
	{
		_uow.ClearAll();
	}

	/// <summary>
	/// BUG REPRODUCTION TEST: DateTime overflow when adding large minute values
	///
	/// This test reproduces the error: "Value to add was out of range. (Parameter 'value')"
	///
	/// Root Cause: ForecastingService.CalculateMinutesToValue returns up to 52,560,000 minutes
	/// (365 days * 100 years worth of minutes) when DPD is extremely small or zero.
	/// When DateTime.UtcNow.AddMinutes(minutes) is called with this value, it can exceed
	/// DateTime.MaxValue (year 9999), causing an ArgumentOutOfRangeException.
	///
	/// The fix should cap the minutes to a safe maximum that won't overflow DateTime.
	/// </summary>
	public bool ReproduceDateTimeOverflowBug()
	{
		Console.WriteLine("\n=== BUG REPRODUCTION TEST ===");
		Console.WriteLine("Testing ForecastingService with extreme DPD values...\n");

		try
		{
			// Test case 1: Very small DPD (close to zero) - this causes massive minute values
			Console.WriteLine("Test 1: Near-zero DPD (dpd = 1e-10)");
			double dpd1 = 1e-10;
			double threshold1 = 1000;
			double current1 = 100;
			double minutes1 = ForecastingService.CalculateMinutesToValue(threshold1, current1, dpd1);
			Console.WriteLine($"  Result: {minutes1:F0} minutes ({minutes1 / 60 / 24 / 365:F1} years)");

			// This is the problematic line - it can overflow DateTime
			DateTime eta1 = DateTime.UtcNow.AddMinutes(minutes1);
			Console.WriteLine($"  ETA: {eta1:yyyy-MM-dd HH:mm:ss} (UTC)");
			Console.WriteLine("  ✓ No overflow - test passed");
		}
		catch (ArgumentOutOfRangeException ex) when (ex.Message.Contains("Value to add was out of range"))
		{
			Console.WriteLine($"  ✗ BUG REPRODUCED: {ex.Message}");
			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ Unexpected error: {ex.GetType().Name}: {ex.Message}");
			return false;
		}

		try
		{
			// Test case 2: Zero DPD (edge case)
			Console.WriteLine("\nTest 2: Zero DPD (dpd = 0)");
			double dpd2 = 0;
			double threshold2 = 1000;
			double current2 = 100;
			double minutes2 = ForecastingService.CalculateMinutesToValue(threshold2, current2, dpd2);
			Console.WriteLine($"  Result: {minutes2:F0} minutes ({minutes2 / 60 / 24 / 365:F1} years)");

			DateTime eta2 = DateTime.UtcNow.AddMinutes(minutes2);
			Console.WriteLine($"  ETA: {eta2:yyyy-MM-dd HH:mm:ss} (UTC)");
			Console.WriteLine("  ✓ No overflow - test passed");
		}
		catch (ArgumentOutOfRangeException ex) when (ex.Message.Contains("Value to add was out of range"))
		{
			Console.WriteLine($"  ✗ BUG REPRODUCED: {ex.Message}");
			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ Unexpected error: {ex.GetType().Name}: {ex.Message}");
			return false;
		}

		try
		{
			// Test case 3: Negative DPD (invalid data)
			Console.WriteLine("\nTest 3: Negative DPD (dpd = -1)");
			double dpd3 = -1;
			double threshold3 = 1000;
			double current3 = 100;
			double minutes3 = ForecastingService.CalculateMinutesToValue(threshold3, current3, dpd3);
			Console.WriteLine($"  Result: {minutes3:F0} minutes ({minutes3 / 60 / 24 / 365:F1} years)");

			DateTime eta3 = DateTime.UtcNow.AddMinutes(minutes3);
			Console.WriteLine($"  ETA: {eta3:yyyy-MM-dd HH:mm:ss} (UTC)");
			Console.WriteLine("  ✓ No overflow - test passed");
		}
		catch (ArgumentOutOfRangeException ex) when (ex.Message.Contains("Value to add was out of range"))
		{
			Console.WriteLine($"  ✗ BUG REPRODUCED: {ex.Message}");
			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ Unexpected error: {ex.GetType().Name}: {ex.Message}");
			return false;
		}

		try
		{
			// Test case 4: NaN DPD (invalid data)
			Console.WriteLine("\nTest 4: NaN DPD");
			double dpd4 = double.NaN;
			double threshold4 = 1000;
			double current4 = 100;
			double minutes4 = ForecastingService.CalculateMinutesToValue(threshold4, current4, dpd4);
			Console.WriteLine($"  Result: {minutes4:F0} minutes ({minutes4 / 60 / 24 / 365:F1} years)");

			DateTime eta4 = DateTime.UtcNow.AddMinutes(minutes4);
			Console.WriteLine($"  ETA: {eta4:yyyy-MM-dd HH:mm:ss} (UTC)");
			Console.WriteLine("  ✓ No overflow - test passed");
		}
		catch (ArgumentOutOfRangeException ex) when (ex.Message.Contains("Value to add was out of range"))
		{
			Console.WriteLine($"  ✗ BUG REPRODUCED: {ex.Message}");
			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ Unexpected error: {ex.GetType().Name}: {ex.Message}");
			return false;
		}

		try
		{
			// Test case 5: Full integration test with GeneratePredictions
			Console.WriteLine("\nTest 5: Full integration - GeneratePredictions with minimal DPD");

			Credential cred = new Credential("TestGame")
			{
				House = "TestHouse",
				Username = "testuser",
				Password = "testpass",
				Enabled = true,
				Balance = 100,
				Jackpots = new Jackpots
				{
					Grand = 100,
					Major = 50,
					Minor = 25,
					Mini = 10,
				},
				Thresholds = new Thresholds
				{
					Grand = 1785,
					Major = 565,
					Minor = 117,
					Mini = 23,
				},
				Settings = new GameSettings
				{
					SpinGrand = true,
					SpinMajor = true,
					SpinMinor = true,
					SpinMini = true,
				},
			};

			// Pre-populate with jackpot that has extremely low DPD
			Jackpot existingJackpot = new Jackpot(cred, "Grand", 100, 1785, 4, DateTime.UtcNow.AddDays(1))
			{
				DPD = new DPD { Average = 1e-10 }, // Extremely low DPD
			};
			((MockRepoJackpots)_uow.Jackpots).Add(existingJackpot);

			ForecastingService.GeneratePredictions(cred, _uow, DateTime.MaxValue);

			List<Jackpot> resultJackpots = _uow.Jackpots.GetAll();
			Console.WriteLine($"  Generated {resultJackpots.Count} jackpot predictions");

			foreach (Jackpot j in resultJackpots)
			{
				Console.WriteLine($"    {j.Category}: ETA={j.EstimatedDate:yyyy-MM-dd HH:mm:ss}, Current={j.Current:F2}, Threshold={j.Threshold:F0}");
			}

			Console.WriteLine("  ✓ GeneratePredictions completed without overflow");
		}
		catch (ArgumentOutOfRangeException ex) when (ex.Message.Contains("Value to add was out of range"))
		{
			Console.WriteLine($"  ✗ BUG REPRODUCED in GeneratePredictions: {ex.Message}");
			return false;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ Unexpected error in GeneratePredictions: {ex.GetType().Name}: {ex.Message}");
			return false;
		}

		Console.WriteLine("\n=== ALL BUG REPRODUCTION TESTS PASSED ===\n");
		return true;
	}

	/// <summary>
	/// Tests that CalculateMinutesToValue returns sane values for normal inputs
	/// </summary>
	public bool TestCalculateMinutesToValue_NormalCases()
	{
		Console.WriteLine("\n=== NORMAL CASE TESTS ===");
		bool allPassed = true;

		// Test 1: Normal DPD - should calculate reasonable ETA
		double dpd1 = 100; // $100 per day
		double threshold1 = 1000;
		double current1 = 100;
		double minutes1 = ForecastingService.CalculateMinutesToValue(threshold1, current1, dpd1);
		Console.WriteLine($"Test 1: DPD=$100/day, remaining=$900");
		Console.WriteLine($"  Result: {minutes1:F0} minutes ({minutes1 / 60:F1} hours, {minutes1 / 60 / 24:F1} days)");
		allPassed &= minutes1 > 0 && minutes1 < TimeSpan.FromDays(365 * 100).TotalMinutes;

		// Test 2: Already at threshold
		double dpd2 = 100;
		double threshold2 = 100;
		double current2 = 100;
		double minutes2 = ForecastingService.CalculateMinutesToValue(threshold2, current2, dpd2);
		Console.WriteLine($"\nTest 2: Already at threshold");
		Console.WriteLine($"  Result: {minutes2:F0} minutes");
		allPassed &= Math.Abs(minutes2) < 0.001;

		// Test 3: Exceeded threshold
		double dpd3 = 100;
		double threshold3 = 100;
		double current3 = 150;
		double minutes3 = ForecastingService.CalculateMinutesToValue(threshold3, current3, dpd3);
		Console.WriteLine($"\nTest 3: Exceeded threshold");
		Console.WriteLine($"  Result: {minutes3:F0} minutes");
		allPassed &= Math.Abs(minutes3) < 0.001;

		// Test 4: Very large DPD
		double dpd4 = 10000; // $10k per day
		double threshold4 = 1000;
		double current4 = 100;
		double minutes4 = ForecastingService.CalculateMinutesToValue(threshold4, current4, dpd4);
		Console.WriteLine($"\nTest 4: High DPD=$10k/day");
		Console.WriteLine($"  Result: {minutes4:F0} minutes ({minutes4:F1} minutes = {minutes4 / 60:F2} hours)");
		allPassed &= minutes4 > 0 && minutes4 < TimeSpan.FromDays(1).TotalMinutes;

		if (allPassed)
		{
			Console.WriteLine("\n✓ All normal case tests passed\n");
		}
		else
		{
			Console.WriteLine("\n✗ Some normal case tests failed\n");
		}

		return allPassed;
	}
}
