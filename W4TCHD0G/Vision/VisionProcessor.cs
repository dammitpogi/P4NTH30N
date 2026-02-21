using System.Diagnostics;
using P4NTH30N.W4TCHD0G.Models;
using P4NTH30N.W4TCHD0G.Stream;

namespace P4NTH30N.W4TCHD0G.Vision;

/// <summary>
/// Contract for the main vision processing pipeline.
/// Orchestrates frame analysis through OCR, button detection, and state classification.
/// </summary>
public interface IVisionProcessor
{
	/// <summary>
	/// Processes a single frame through the full vision pipeline.
	/// </summary>
	/// <param name="frame">The decoded vision frame to analyze.</param>
	/// <returns>Complete analysis results including jackpots, buttons, and game state.</returns>
	Task<VisionAnalysis> ProcessFrameAsync(VisionFrame frame);

	/// <summary>
	/// Starts continuous processing from a stream receiver at the configured sample rate.
	/// </summary>
	/// <param name="receiver">The RTMP stream receiver providing frames.</param>
	/// <param name="cancellationToken">Token to stop processing.</param>
	Task StartContinuousAsync(IStreamReceiver receiver, CancellationToken cancellationToken = default);

	/// <summary>
	/// Event raised after each frame is processed.
	/// </summary>
	event Action<VisionAnalysis>? OnAnalysisComplete;
}

/// <summary>
/// Main vision processing pipeline for W4TCHD0G.
/// Orchestrates OCR jackpot detection, button detection, and game state classification
/// on decoded RTMP frames at an adaptive sample rate (2-5 FPS).
/// </summary>
/// <remarks>
/// ARCHITECTURE:
/// Frame → Preprocessing → [Parallel: OCR + Button Detection] → State Classification → Output
///
/// PERFORMANCE TARGETS (FOUR-006):
/// - Processing latency: &lt;500ms per frame
/// - Analysis rate: 2-5 FPS (adaptive)
/// - Jackpot OCR accuracy: 95%+
/// </remarks>
public sealed class VisionProcessor : IVisionProcessor
{
	/// <summary>
	/// Jackpot value detector (OCR-based).
	/// </summary>
	private readonly IJackpotDetector _jackpotDetector;

	/// <summary>
	/// UI button detector (template matching).
	/// </summary>
	private readonly IButtonDetector _buttonDetector;

	/// <summary>
	/// Game state classifier (rules-based).
	/// </summary>
	private readonly IStateClassifier _stateClassifier;

	/// <summary>
	/// Target analysis frames per second. Adaptive between min and max.
	/// </summary>
	private readonly int _targetFps;

	/// <summary>
	/// Total frames processed since start.
	/// </summary>
	private long _totalProcessed;

	/// <summary>
	/// Total processing errors encountered.
	/// </summary>
	private long _totalErrors;

	/// <inheritdoc />
	public event Action<VisionAnalysis>? OnAnalysisComplete;

	/// <summary>
	/// Total frames successfully processed.
	/// </summary>
	public long TotalProcessed => Interlocked.Read(ref _totalProcessed);

	/// <summary>
	/// Total processing errors.
	/// </summary>
	public long TotalErrors => Interlocked.Read(ref _totalErrors);

	/// <summary>
	/// Creates a VisionProcessor with the required detectors.
	/// </summary>
	/// <param name="jackpotDetector">Jackpot OCR detector.</param>
	/// <param name="buttonDetector">Button template detector.</param>
	/// <param name="stateClassifier">Game state classifier.</param>
	/// <param name="targetFps">Target analysis FPS. Default: 3.</param>
	public VisionProcessor(IJackpotDetector jackpotDetector, IButtonDetector buttonDetector, IStateClassifier stateClassifier, int targetFps = 3)
	{
		_jackpotDetector = jackpotDetector ?? throw new ArgumentNullException(nameof(jackpotDetector));
		_buttonDetector = buttonDetector ?? throw new ArgumentNullException(nameof(buttonDetector));
		_stateClassifier = stateClassifier ?? throw new ArgumentNullException(nameof(stateClassifier));
		_targetFps = Math.Clamp(targetFps, 1, 10);
	}

	/// <inheritdoc />
	public async Task<VisionAnalysis> ProcessFrameAsync(VisionFrame frame)
	{
		ArgumentNullException.ThrowIfNull(frame, nameof(frame));

		Stopwatch sw = Stopwatch.StartNew();

		VisionAnalysis analysis = new() { Timestamp = frame.Timestamp };

		try
		{
			// Run OCR and button detection in parallel for better throughput
			Task<Dictionary<string, decimal>> jackpotTask = _jackpotDetector.DetectAsync(frame);
			Task<List<DetectedButton>> buttonTask = _buttonDetector.DetectAsync(frame);

			await Task.WhenAll(jackpotTask, buttonTask);

			Dictionary<string, decimal> jackpots = jackpotTask.Result;
			List<DetectedButton> buttons = buttonTask.Result;

			// Populate analysis with detection results
			analysis.ExtractedJackpots = jackpots.ToDictionary(kv => kv.Key, kv => (double)kv.Value);
			// FEAT-036: Pass detected buttons through to DecisionEngine
			analysis.DetectedButtons = buttons;

			// Classify game state using all detection data
			GameState gameState = await _stateClassifier.ClassifyAsync(frame, buttons, jackpots);
			analysis.GameState = MapToAnimationState(gameState);

			// Set confidence based on detection quality
			analysis.Confidence = CalculateConfidence(jackpots, buttons, gameState);

			Interlocked.Increment(ref _totalProcessed);
		}
		catch (Exception ex)
		{
			Interlocked.Increment(ref _totalErrors);
			analysis.ErrorDetected = true;
			analysis.ErrorMessage = ex.Message;

			StackTrace trace = new(ex, true);
			StackFrame? errorFrame = trace.GetFrame(0);
			int line = errorFrame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [VisionProcessor] Frame processing error: {ex.Message}");
		}

		sw.Stop();
		analysis.InferenceTimeMs = sw.ElapsedMilliseconds;

		// Raise completion event
		OnAnalysisComplete?.Invoke(analysis);

		return analysis;
	}

	/// <inheritdoc />
	public async Task StartContinuousAsync(IStreamReceiver receiver, CancellationToken cancellationToken = default)
	{
		ArgumentNullException.ThrowIfNull(receiver, nameof(receiver));

		int frameIntervalMs = 1000 / _targetFps;
		Console.WriteLine($"[VisionProcessor] Starting continuous processing at {_targetFps} FPS (interval: {frameIntervalMs}ms)");

		while (!cancellationToken.IsCancellationRequested)
		{
			try
			{
				VisionFrame? frame = receiver.GetLatestFrame();
				if (frame is not null)
				{
					await ProcessFrameAsync(frame);
				}

				// Wait for next analysis slot
				await Task.Delay(frameIntervalMs, cancellationToken);
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[VisionProcessor] Continuous processing error: {ex.Message}");
				// Brief pause on error before retrying
				await Task.Delay(1000, cancellationToken);
			}
		}

		Console.WriteLine($"[VisionProcessor] Stopped. Processed: {TotalProcessed}, Errors: {TotalErrors}");
	}

	/// <summary>
	/// Maps the detailed GameState enum to the existing AnimationState enum
	/// for backward compatibility with VisionAnalysis.
	/// </summary>
	private static AnimationState MapToAnimationState(GameState gameState)
	{
		return gameState switch
		{
			GameState.Idle => AnimationState.Idle,
			GameState.Spinning => AnimationState.Spinning,
			GameState.WinAnimation => AnimationState.Idle,
			GameState.BonusGame => AnimationState.Bonus,
			GameState.FreeSpins => AnimationState.Bonus,
			GameState.Error => AnimationState.Error,
			GameState.SessionEnded => AnimationState.Error,
			GameState.Loading => AnimationState.Idle,
			_ => AnimationState.Idle,
		};
	}

	/// <summary>
	/// Calculates overall analysis confidence based on detection results.
	/// </summary>
	private static double CalculateConfidence(Dictionary<string, decimal> jackpots, List<DetectedButton> buttons, GameState gameState)
	{
		double confidence = 0.0;
		int factors = 0;

		// Jackpot detection confidence
		if (jackpots.Count > 0)
		{
			confidence += 0.8; // High confidence if any jackpot detected
			factors++;
		}

		// Button detection confidence (average of individual confidences)
		if (buttons.Count > 0)
		{
			double avgButtonConf = buttons.Average(b => b.Confidence);
			confidence += avgButtonConf;
			factors++;
		}

		// State classification confidence
		if (gameState != GameState.Unknown)
		{
			confidence += 0.7;
			factors++;
		}

		return factors > 0 ? confidence / factors : 0.0;
	}
}
