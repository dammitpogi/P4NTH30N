using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Models;
using P4NTHE0N.W4TCHD0G.Vision;

namespace P4NTHE0N.W4TCHD0G.Development;

/// <summary>
/// FEAT-036: Captures and labels vision frames for training data collection.
/// Stores frames with metadata (game state, jackpot values, button positions)
/// for future ML model training.
/// </summary>
public sealed class TrainingDataCapture
{
	private readonly string _outputDirectory;
	private readonly List<TrainingFrame> _captured = new();
	private readonly object _lock = new();
	private long _frameCount;

	/// <summary>
	/// Total frames captured.
	/// </summary>
	public long FrameCount => Interlocked.Read(ref _frameCount);

	/// <summary>
	/// All captured training frames.
	/// </summary>
	public IReadOnlyList<TrainingFrame> CapturedFrames
	{
		get
		{
			lock (_lock) { return _captured.ToList(); }
		}
	}

	public TrainingDataCapture(string outputDirectory)
	{
		_outputDirectory = outputDirectory;
		if (!Directory.Exists(_outputDirectory))
			Directory.CreateDirectory(_outputDirectory);
	}

	/// <summary>
	/// Captures a frame with its analysis results as training data.
	/// </summary>
	/// <param name="frame">The raw vision frame.</param>
	/// <param name="analysis">The vision analysis results for labeling.</param>
	/// <param name="ct">Cancellation token.</param>
	/// <returns>The training frame metadata.</returns>
	public async Task<TrainingFrame> CaptureAsync(VisionFrame frame, VisionAnalysis analysis, CancellationToken ct = default)
	{
		long index = Interlocked.Increment(ref _frameCount);

		TrainingFrame trainingFrame = new()
		{
			Index = index,
			Timestamp = frame.Timestamp,
			GameState = analysis.GameState.ToString(),
			Confidence = analysis.Confidence,
			JackpotValues = analysis.ExtractedJackpots ?? new Dictionary<string, double>(),
			InferenceTimeMs = analysis.InferenceTimeMs,
			ErrorDetected = analysis.ErrorDetected,
		};

		// Save raw frame data if available
		if (frame.Data != null && frame.Data.Length > 0)
		{
			string fileName = $"frame_{index:D6}_{analysis.GameState}_{DateTime.UtcNow:yyyyMMdd_HHmmss}.raw";
			string filePath = Path.Combine(_outputDirectory, fileName);

			try
			{
				await File.WriteAllBytesAsync(filePath, frame.Data, ct);
				trainingFrame.FilePath = filePath;
				trainingFrame.Width = frame.Width;
				trainingFrame.Height = frame.Height;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[TrainingDataCapture] Frame save failed: {ex.Message}");
			}
		}

		// Save metadata JSON
		string metaFileName = $"frame_{index:D6}_meta.json";
		string metaPath = Path.Combine(_outputDirectory, metaFileName);
		try
		{
			string json = System.Text.Json.JsonSerializer.Serialize(trainingFrame, new System.Text.Json.JsonSerializerOptions { WriteIndented = true });
			await File.WriteAllTextAsync(metaPath, json, ct);
			trainingFrame.MetadataPath = metaPath;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[TrainingDataCapture] Metadata save failed: {ex.Message}");
		}

		lock (_lock) { _captured.Add(trainingFrame); }
		return trainingFrame;
	}
}

/// <summary>
/// Metadata for a captured training frame.
/// </summary>
public sealed class TrainingFrame
{
	public long Index { get; set; }
	public DateTime Timestamp { get; set; }
	public string GameState { get; set; } = string.Empty;
	public double Confidence { get; set; }
	public Dictionary<string, double> JackpotValues { get; set; } = new();
	public long InferenceTimeMs { get; set; }
	public bool ErrorDetected { get; set; }
	public string? FilePath { get; set; }
	public string? MetadataPath { get; set; }
	public int Width { get; set; }
	public int Height { get; set; }
}
