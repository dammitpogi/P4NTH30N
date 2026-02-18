using UNI7T35T.Mocks;
using UNI7T35T.Tests;

namespace UNI7T35T;

class Program
{
	static int Main(string[] args)
	{
		Console.WriteLine("╔════════════════════════════════════════════════════════════════════╗");
		Console.WriteLine("║          UNI7T35T - Bug Reproduction Platform                      ║");
		Console.WriteLine("║          H0UND Analytics Engine Test Suite                         ║");
		Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

		int totalTests = 0;
		int passedTests = 0;

		// Run ForecastingService Tests
		Console.WriteLine("Running ForecastingService Tests...\n");
		ForecastingServiceTests forecastingTests = new ForecastingServiceTests();

		// Test 1: Bug Reproduction
		totalTests++;
		forecastingTests.Setup();
		if (forecastingTests.ReproduceDateTimeOverflowBug())
		{
			passedTests++;
		}

		// Test 2: Normal Cases
		totalTests++;
		forecastingTests.Setup();
		if (forecastingTests.TestCalculateMinutesToValue_NormalCases())
		{
			passedTests++;
		}

		// Print Summary
		Console.WriteLine("\n╔════════════════════════════════════════════════════════════════════╗");
		Console.WriteLine($"║  TEST SUMMARY: {passedTests}/{totalTests} tests passed                                   ║");
		Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");

		if (passedTests == totalTests)
		{
			Console.WriteLine("✓ All tests passed! The bug has been fixed.");
			return 0;
		}
		else
		{
			Console.WriteLine("✗ Some tests failed. The bug is still present.");
			return 1;
		}
	}
}
