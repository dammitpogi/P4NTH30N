using System.Text.Json;
using P4NTH30N.C0MMON.Infrastructure.Cdp;

namespace P4NTH30N.T00L5ET;

/// <summary>
/// Navigate to the correct game after login: Fortune Piggy (primary) → Gold777 (fallback).
/// Uses CDP to go back to lobby and select the target game.
/// </summary>
public static class GameNavigator
{
	// Fortune Piggy = gid 2104, Gold777 = gid 2607 (from config.json)
	private static readonly (int Gid, string Name, string GameName)[] TargetGames =
	[
		(2104, "Fortune Piggy", "SanQiZhuZai_2104"),
		(2607, "GOLD 777", "SanQiBaoTiao3_2607"),
	];

	public static async Task RunAsync()
	{
		Console.WriteLine("\n=== Game Navigator → Fortune Piggy ===");

		var cdpConfig = new CdpConfig { HostIp = "127.0.0.1", Port = 9222 };
		using var cdp = new CdpClient(cdpConfig);
		if (!await cdp.ConnectAsync())
		{
			Console.WriteLine("[FAIL] CDP connect failed");
			return;
		}

		// Step 1: Close SHARE dialog if present (X button at ~750, 240)
		Console.WriteLine("  Closing SHARE dialog...");
		await cdp.ClickAtAsync(750, 240);
		await Task.Delay(1000);
		await SaveScreenshot(cdp, "01_dialog_closed");

		// Step 2: Click SLOT category on left sidebar (~37, 513)
		Console.WriteLine("  Clicking SLOT category...");
		await cdp.ClickAtAsync(37, 513);
		await Task.Delay(2000);

		// Step 3: Navigate to page 1 first (click left arrow several times)
		Console.WriteLine("  Going to page 1...");
		for (int i = 0; i < 5; i++)
		{
			await cdp.ClickAtAsync(810, 255); // Left arrow
			await Task.Delay(400);
		}
		await Task.Delay(1000);
		await SaveScreenshot(cdp, "02_page1");

		// Step 4: Click right arrow once → Fortune Piggy visible on left edge of page 2
		Console.WriteLine("  Scrolling right to Fortune Piggy...");
		await cdp.ClickAtAsync(845, 255); // Right arrow
		await Task.Delay(1500);
		await SaveScreenshot(cdp, "03_page2");

		// Step 5: Click Fortune Piggy — bottom-left of page 2 (~80, 510)
		Console.WriteLine("  Clicking Fortune Piggy...");
		await cdp.ClickAtAsync(80, 510);
		await Task.Delay(5000);
		await SaveScreenshot(cdp, "04_game_loading");

		// Check if game loaded
		Console.WriteLine("  Waiting for game to load...");
		await Task.Delay(5000);
		await SaveScreenshot(cdp, "05_game_loaded");

		Console.WriteLine("\n=== Navigator Complete ===");
	}

	private static async Task SaveScreenshot(CdpClient cdp, string label)
	{
		try
		{
			JsonElement ssResult = await cdp.SendCommandAsync("Page.captureScreenshot", new { format = "png", quality = 80 });
			if (ssResult.TryGetProperty("result", out var res) && res.TryGetProperty("data", out var data))
			{
				byte[] bytes = Convert.FromBase64String(data.GetString() ?? "");
				string path = Path.Combine("C:\\P4NTH30N", "test-results", $"nav_{label}_{DateTime.UtcNow:HHmmss}.png");
				Directory.CreateDirectory(Path.GetDirectoryName(path)!);
				await File.WriteAllBytesAsync(path, bytes);
				Console.WriteLine($"  Screenshot: {path} ({bytes.Length:N0} bytes)");
			}
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  Screenshot failed: {ex.Message}");
		}
	}
}
