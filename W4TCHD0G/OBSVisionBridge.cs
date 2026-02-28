using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using P4NTHE0N.W4TCHD0G.Configuration;
using P4NTHE0N.W4TCHD0G.Models;

namespace P4NTHE0N.W4TCHD0G;

public class OBSVisionBridge : IDisposable
{
	private readonly IOBSClient _obsClient;
	private readonly ILMStudioClient _lmClient;
	private readonly ModelRouter _router;
	private readonly VisionConfig _config;
	private readonly List<VisionFrame> _frameBuffer = new();
	private readonly object _bufferLock = new();
	private CancellationTokenSource? _cts;
	private bool _disposed;

	public VisionAnalysis? LatestAnalysis { get; private set; }
	public int BufferedFrameCount
	{
		get
		{
			lock (_bufferLock)
			{
				return _frameBuffer.Count;
			}
		}
	}
	public bool IsRunning => _cts != null && !_cts.IsCancellationRequested;

	public OBSVisionBridge(IOBSClient obsClient, ILMStudioClient lmClient, ModelRouter router, VisionConfig? config = null)
	{
		_obsClient = obsClient;
		_lmClient = lmClient;
		_router = router;
		_config = config ?? new VisionConfig();
	}

	public async Task StartAsync(string sourceName)
	{
		_cts = new CancellationTokenSource();
		CancellationToken token = _cts.Token;

		if (!_obsClient.IsConnected)
			await _obsClient.ConnectAsync();

		int delayMs = 1000 / _config.FrameRate;

		while (!token.IsCancellationRequested)
		{
			try
			{
				VisionFrame? frame = await _obsClient.CaptureFrameAsync(sourceName);
				if (frame != null)
				{
					lock (_bufferLock)
					{
						_frameBuffer.Add(frame);
						while (_frameBuffer.Count > _config.BufferSize)
							_frameBuffer.RemoveAt(0);
					}

					string modelId = _router.GetModelForTask("frame_analysis");
					if (!string.IsNullOrEmpty(modelId))
					{
						VisionAnalysis analysis = await _lmClient.AnalyzeFrameAsync(frame, modelId);
						LatestAnalysis = analysis;

						_router.RecordPerformance(modelId, "frame_analysis", !analysis.ErrorDetected, analysis.InferenceTimeMs);
					}
				}
			}
			catch (OperationCanceledException)
			{
				break;
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[OBSVisionBridge] Frame processing error: {ex.Message}");
			}

			try
			{
				await Task.Delay(delayMs, token);
			}
			catch (OperationCanceledException)
			{
				break;
			}
		}
	}

	public void Stop()
	{
		_cts?.Cancel();
	}

	public VisionFrame? GetLatestFrame()
	{
		lock (_bufferLock)
		{
			return _frameBuffer.Count > 0 ? _frameBuffer[_frameBuffer.Count - 1] : null;
		}
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_cts?.Cancel();
			_cts?.Dispose();
			_disposed = true;
		}
	}
}
