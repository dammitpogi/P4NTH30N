// DECISION_036: FourEyes Vision Pipeline Test
// Tests CDP screenshot receiver + stub vision processors

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using P4NTHE0N.C0MMON.Infrastructure.Cdp;
using P4NTHE0N.W4TCHD0G.Stream.Alternatives;
using P4NTHE0N.W4TCHD0G.Vision;
using P4NTHE0N.W4TCHD0G.Vision.Stubs;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.UNI7T35T.Tests;

/// <summary>
/// Tests FourEyes vision pipeline using CDP screenshots and stub detectors.
/// Validates DECISION_036 implementation without requiring external dependencies.
/// </summary>
public static class FourEyesVisionTest
{
    /// <summary>
    /// Runs the complete FourEyes vision test against live Chrome CDP.
    /// </summary>
    public static async Task RunAsync()
    {
        Console.WriteLine("=== DECISION_036: FourEyes Vision Pipeline Test ===");
        Console.WriteLine("Using CDP screenshot receiver + stub detectors");
        Console.WriteLine();

        // 1. Connect CDP
        var cdpConfig = new CdpConfig { HostIp = "127.0.0.1", Port = 9222 };
        var cdp = new CdpClient(cdpConfig);

        if (!await cdp.ConnectAsync())
        {
            Console.WriteLine("[FAIL] CDP connection FAILED");
            return;
        }

        Console.WriteLine("[OK] CDP connected");

        // 2. Navigate to FireKirin (already loaded from previous test)
        Console.WriteLine("[INFO] FireKirin should already be loaded from previous test");

        // 3. Set up CDP screenshot receiver
        var screenshotReceiver = new CDPScreenshotReceiver(cdp, targetFps: 2);

        // 4. Set up stub vision processors
        var jackpotDetector = new StubJackpotDetector
        {
            MockJackpots = new()
            {
                ["Grand"] = 1234.56m,
                ["Major"] = 567.89m,
                ["Minor"] = 123.45m,
                ["Mini"] = 67.89m
            },
            MockConfidence = 0.92,
            SimulatedLatencyMs = 30
        };

        var buttonDetector = new StubButtonDetector
        {
            MockButtons = new List<DetectedButton>
            {
                new DetectedButton { Type = ButtonType.Spin, Label = "spin", Confidence = 0.88, CenterX = 640, CenterY = 480, Width = 100, Height = 100 },
                new DetectedButton { Type = ButtonType.Menu, Label = "play", Confidence = 0.91, CenterX = 320, CenterY = 400, Width = 80, Height = 40 }
            }
        };

        var stateClassifier = new StubStateClassifier
        {
            ForcedState = GameState.Idle
        };

        Console.WriteLine("[OK] Vision processors configured (stubs with mock data)");

        // 5. Create vision processor pipeline (uses real VisionProcessor with stubs)
        var visionProcessor = new VisionProcessor(jackpotDetector, buttonDetector, stateClassifier, targetFps: 2);

        // 6. Wire up frame processing
        int framesProcessed = 0;
        int framesWithJackpots = 0;
        int framesWithButtons = 0;

        screenshotReceiver.OnFrameReceived += async (frame) =>
        {
            framesProcessed++;
            Console.WriteLine($"[FRAME] Frame {frame.FrameNumber}: {frame.Data.Length} bytes, IsPng={frame.IsPng}");

            // Process frame through vision pipeline
            var analysis = await visionProcessor.ProcessFrameAsync(frame);

            if (analysis.ExtractedJackpots.Count > 0)
            {
                framesWithJackpots++;
                Console.WriteLine($"[JACKPOT] Jackpots detected: {string.Join(", ", analysis.ExtractedJackpots.Select(kv => $"{kv.Key}={kv.Value:F2}"))}");
            }

            if (analysis.DetectedButtons != null && analysis.DetectedButtons.Count > 0)
            {
                framesWithButtons++;
                Console.WriteLine($"[BUTTON] Buttons detected: {string.Join(", ", analysis.DetectedButtons.Select(b => b.Label ?? b.Type.ToString()))}");
            }

            Console.WriteLine($"[STATE] State: {analysis.GameState} (confidence: {analysis.Confidence:P1})");
            Console.WriteLine();
        };

        // 7. Start capture
        await screenshotReceiver.StartAsync();
        Console.WriteLine("[START] Started CDP screenshot capture (2 FPS)");
        Console.WriteLine("[WAIT] Capturing for 10 seconds...");

        // 8. Capture for 10 seconds
        await Task.Delay(10000);

        // 9. Stop and report
        await screenshotReceiver.StopAsync();

        Console.WriteLine("=== RESULTS ===");
        Console.WriteLine($"Frames captured: {screenshotReceiver.TotalFramesReceived}");
        Console.WriteLine($"Frames dropped: {screenshotReceiver.TotalFramesDropped}");
        Console.WriteLine($"Average latency: {screenshotReceiver.LatencyMs}ms");
        Console.WriteLine($"Frames processed: {framesProcessed}");
        Console.WriteLine($"Frames with jackpots: {framesWithJackpots}");
        Console.WriteLine($"Frames with buttons: {framesWithButtons}");

        // 10. Validation
        bool success = framesProcessed > 0 && framesWithJackpots > 0;
        Console.WriteLine($"Result: {(success ? "[PASS]" : "[FAIL]")}");

        if (success)
        {
            Console.WriteLine("[OK] FourEyes vision pipeline working with CDP screenshots");
            Console.WriteLine("[OK] Stub detectors providing mock data as expected");
            Console.WriteLine("[OK] Frame capture and processing pipeline functional");
        }
        else
        {
            Console.WriteLine("[FAIL] Vision pipeline not processing frames correctly");
        }

        cdp.Dispose();
    }
}
