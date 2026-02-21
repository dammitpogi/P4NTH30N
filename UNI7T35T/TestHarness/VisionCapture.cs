using System;
using System.Collections.Generic;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using P4NTH30N.C0MMON.Entities;

namespace P4NTH30N.UNI7T35T.TestHarness;

/// <summary>
/// TEST-035: Frame capture and storage for vision training data.
/// Captures screenshots via CDP at intervals and saves them with labels
/// for later use by FourEyes (DECISION_036) training pipeline.
/// </summary>
public sealed class VisionCapture
{
	private readonly CdpTestClient _cdpTest;
	private readonly string _outputDirectory;
	private readonly List<CapturedFrame> _capturedFrames = new();

	/// <summary>
	/// All frames captured in this session.
	/// </summary>
	public IReadOnlyList<CapturedFrame> CapturedFrames => _capturedFrames;

	public VisionCapture(CdpTestClient cdpTest, string outputDirectory)
	{
		_cdpTest = cdpTest ?? throw new ArgumentNullException(nameof(cdpTest));
		_outputDirectory = outputDirectory;

		if (!Directory.Exists(_outputDirectory))
			Directory.CreateDirectory(_outputDirectory);
	}

	/// <summary>
	/// Captures a single frame with a label describing the game state.
	/// </summary>
	/// <param name="label">Label for the frame (e.g., "idle", "spinning", "win_animation").</param>
	/// <param name="gameState">Current game state string.</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>The captured frame metadata, or null if capture failed.</returns>
	public async Task<CapturedFrame?> CaptureFrameAsync(string label, string gameState = "unknown", CancellationToken ct = default)
	{
		try
		{
			string? base64 = await _cdpTest.CaptureScreenshotAsync(ct);
			if (string.IsNullOrEmpty(base64))
			{
				Console.WriteLine("[VisionCapture] Screenshot returned empty");
				return null;
			}

			byte[] imageBytes = Convert.FromBase64String(base64);
			CapturedFrame frame = new()
			{
				CapturedAt = DateTime.UtcNow,
				GameState = gameState,
				Label = label,
				Width = 0, // Will be determined by image decoder if needed
				Height = 0,
			};

			string fileName = $"{frame.FrameId}_{label}_{DateTime.UtcNow:yyyyMMdd_HHmmss}.png";
			string filePath = Path.Combine(_outputDirectory, fileName);
			await File.WriteAllBytesAsync(filePath, imageBytes, ct);
			frame.FilePath = filePath;

			_capturedFrames.Add(frame);
			Console.WriteLine($"[VisionCapture] Frame captured: {fileName} (label: {label}, state: {gameState})");
			return frame;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[VisionCapture] Capture failed: {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Captures a burst of frames at the specified interval.
	/// </summary>
	/// <param name="count">Number of frames to capture.</param>
	/// <param name="intervalMs">Delay between frames in milliseconds.</param>
	/// <param name="label">Label prefix for all frames.</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>Number of frames successfully captured.</returns>
	public async Task<int> CaptureBurstAsync(int count, int intervalMs, string label, CancellationToken ct = default)
	{
		int captured = 0;
		for (int i = 0; i < count && !ct.IsCancellationRequested; i++)
		{
			CapturedFrame? frame = await CaptureFrameAsync($"{label}_{i:D3}", "burst", ct);
			if (frame != null)
				captured++;

			if (i < count - 1)
				await Task.Delay(intervalMs, ct);
		}

		Console.WriteLine($"[VisionCapture] Burst complete: {captured}/{count} frames captured");
		return captured;
	}
}
