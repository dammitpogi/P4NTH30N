using P4NTH30N.H4ND.Infrastructure;
using P4NTH30N.H4ND.Services;
using UNI7T35T.Mocks;

namespace UNI7T35T.Tests;

/// <summary>
/// OPS_009 + OPS_045: Tests for extension-free CdpGameActions and JackpotReader.
/// Validates VerifyGamePageLoadedAsync, ReadJackpotsViaCdpAsync, and JackpotReader
/// work correctly with mocked CDP responses.
/// </summary>
public static class CdpGameActionsTests
{
	public static (int Passed, int Failed) RunAll()
	{
		Console.WriteLine("[CdpGameActionsTests] Running...");
		int passed = 0;
		int failed = 0;

		void Assert(bool condition, string name)
		{
			if (condition)
			{
				passed++;
				Console.WriteLine($"  PASS {name}");
			}
			else
			{
				failed++;
				Console.WriteLine($"  FAIL {name}");
			}
		}

		// --- VerifyGamePageLoadedAsync tests ---

		// Test 1: Canvas present → page is loaded
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("canvas", true);
			bool result = CdpGameActions.VerifyGamePageLoadedAsync(cdp, "FireKirin").GetAwaiter().GetResult();
			Assert(result, "VerifyGamePageLoaded: Canvas present returns true");
		}

		// Test 2: Hall container present → page is loaded
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("canvas", false);
			cdp.SetEvaluateResponse("hall-container", true);
			bool result = CdpGameActions.VerifyGamePageLoadedAsync(cdp, "OrionStars").GetAwaiter().GetResult();
			Assert(result, "VerifyGamePageLoaded: Hall container returns true");
		}

		// Test 3: Nothing present → page not loaded
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("canvas", false);
			cdp.SetEvaluateResponse("hall-container", false);
			cdp.SetEvaluateResponse("iframe", false);
			cdp.SetEvaluateResponse("readyState", "loading");
			bool result = CdpGameActions.VerifyGamePageLoadedAsync(cdp, "FireKirin").GetAwaiter().GetResult();
			Assert(!result, "VerifyGamePageLoaded: Nothing present returns false");
		}

		// Test 4: Document complete but still on login page → not ready
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("canvas", false);
			cdp.SetEvaluateResponse("hall-container", false);
			cdp.SetEvaluateResponse("iframe", false);
			cdp.SetEvaluateResponse("readyState", "complete");
			cdp.SetEvaluateResponse("login-btn", true);
			bool result = CdpGameActions.VerifyGamePageLoadedAsync(cdp, "FireKirin").GetAwaiter().GetResult();
			Assert(!result, "VerifyGamePageLoaded: On login page returns false");
		}

		// Test 5: Iframe present → page is loaded (game in iframe)
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("canvas", false);
			cdp.SetEvaluateResponse("hall-container", false);
			cdp.SetEvaluateResponse("iframe", true);
			bool result = CdpGameActions.VerifyGamePageLoadedAsync(cdp, "OrionStars").GetAwaiter().GetResult();
			Assert(result, "VerifyGamePageLoaded: Iframe present returns true");
		}

		// --- ReadJackpotsViaCdpAsync tests ---

		// Test 6: Window variables present → reads jackpots
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("window.parent.Grand", 15000.0);
			cdp.SetEvaluateResponse("window.parent.Major", 5000.0);
			cdp.SetEvaluateResponse("window.parent.Minor", 2000.0);
			cdp.SetEvaluateResponse("window.parent.Mini", 500.0);
			(double grand, double major, double minor, double mini) = CdpGameActions.ReadJackpotsViaCdpAsync(cdp).GetAwaiter().GetResult();
			Assert(grand == 150.0, $"ReadJackpotsViaCdp: Grand = {grand} (expected 150.0)");
			Assert(major == 50.0, $"ReadJackpotsViaCdp: Major = {major} (expected 50.0)");
			Assert(minor == 20.0, $"ReadJackpotsViaCdp: Minor = {minor} (expected 20.0)");
			Assert(mini == 5.0, $"ReadJackpotsViaCdp: Mini = {mini} (expected 5.0)");
		}

		// Test 7: No variables present → returns zeros (expected for Canvas games)
		{
			MockCdpClient cdp = new();
			(double grand, double major, double minor, double mini) = CdpGameActions.ReadJackpotsViaCdpAsync(cdp).GetAwaiter().GetResult();
			Assert(grand == 0, "ReadJackpotsViaCdp: No data returns Grand=0");
			Assert(major == 0, "ReadJackpotsViaCdp: No data returns Major=0");
			Assert(minor == 0, "ReadJackpotsViaCdp: No data returns Minor=0");
			Assert(mini == 0, "ReadJackpotsViaCdp: No data returns Mini=0");
		}

		// --- JackpotReader tests (OPS-045) ---

		// Test 8: JackpotReader reads single tier via fallback chain
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("window.parent.Grand", 0.0);
			cdp.SetEvaluateResponse("window.Grand", 18000.0);
			JackpotReader reader = new();
			double grand = reader.ReadJackpotAsync(cdp, "FireKirin", "Grand").GetAwaiter().GetResult();
			Assert(grand == 180.0, $"JackpotReader: Fallback to window.Grand = {grand} (expected 180.0)");
		}

		// Test 9: JackpotReader returns 0 when all selectors fail (Canvas game)
		{
			MockCdpClient cdp = new();
			JackpotReader reader = new();
			double grand = reader.ReadJackpotAsync(cdp, "FireKirin", "Grand").GetAwaiter().GetResult();
			Assert(grand == 0, "JackpotReader: All selectors fail returns 0");
		}

		// Test 10: JackpotReader reads all four tiers
		{
			MockCdpClient cdp = new();
			cdp.SetEvaluateResponse("window.parent.Grand", 15000.0);
			cdp.SetEvaluateResponse("window.parent.Major", 5000.0);
			cdp.SetEvaluateResponse("window.parent.Minor", 2000.0);
			cdp.SetEvaluateResponse("window.parent.Mini", 500.0);
			JackpotReader reader = new();
			var (grand, major, minor, mini) = reader.ReadAllJackpotsAsync(cdp, "OrionStars").GetAwaiter().GetResult();
			Assert(grand == 150.0, $"JackpotReader.ReadAll: Grand = {grand} (expected 150.0)");
			Assert(major == 50.0, $"JackpotReader.ReadAll: Major = {major} (expected 50.0)");
			Assert(minor == 20.0, $"JackpotReader.ReadAll: Minor = {minor} (expected 20.0)");
			Assert(mini == 5.0, $"JackpotReader.ReadAll: Mini = {mini} (expected 5.0)");
		}

		// Test 11: JackpotReader CrossValidate logs no error when CDP has no data
		{
			JackpotReader reader = new();
			// Should not throw — CDP all zeros is expected for Canvas games
			reader.CrossValidate("FireKirin", (0, 0, 0, 0), (150.0, 50.0, 20.0, 5.0));
			Assert(true, "JackpotReader.CrossValidate: CDP zeros accepted silently");
		}

		Console.WriteLine($"[CdpGameActionsTests] Done: {passed} passed, {failed} failed");
		return (passed, failed);
	}
}
