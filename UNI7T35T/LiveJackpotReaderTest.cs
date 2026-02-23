// Test DECISION_045: JackpotReader against live CDP
using System;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using P4NTH30N.C0MMON.Infrastructure.Cdp;
using P4NTH30N.H4ND.Services;

public class LiveJackpotReaderTest {
    public static async Task RunAsync() {
        Console.WriteLine("=== DECISION_045: Live JackpotReader Test ===");
        
        var cdpConfig = new CdpConfig { HostIp = "127.0.0.1", Port = 9222 };
        var cdp = new CdpClient(cdpConfig);
        
        if (!await cdp.ConnectAsync()) {
            Console.WriteLine("CDP connection FAILED");
            return;
        }
        
        Console.WriteLine("CDP connected successfully");
        
        var reader = new JackpotReader();
        Console.WriteLine("Testing against FireKirin (loaded in Chrome)...");
        
        // Test single tier
        double? grand = await reader.ReadJackpotAsync(cdp, "FireKirin", "Grand");
        Console.WriteLine($"Grand jackpot: {grand?.ToString() ?? "null"}");
        
        // Test all tiers
        var all = await reader.ReadAllJackpotsAsync(cdp, "FireKirin");
        Console.WriteLine($"All jackpots: Grand={all.Grand}, Major={all.Major}, Minor={all.Minor}, Mini={all.Mini}");
        
        // Expected result: All null for Canvas game (no readable selectors)
        bool allNull = all.Grand == null && all.Major == null && all.Minor == null && all.Mini == null;
        Console.WriteLine($"Result: {(allNull ? "NULL (expected for Canvas game)" : "NON-NULL (has data)")}");
        
        cdp.Dispose();
    }
}
