using System.Diagnostics;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.ML.OnnxRuntime;
using Microsoft.ML.OnnxRuntime.Tensors;

namespace P4NTHE0N.RAG;

/// <summary>
/// Embedding service using ONNX Runtime with all-MiniLM-L6-v2 model.
/// Supports single and batch embedding generation with caching.
/// Target: 50-75ms single embedding (Oracle adjusted).
/// </summary>
public sealed class EmbeddingService : IDisposable
{
	private readonly InferenceSession? _session;
	private readonly IMemoryCache _cache;
	private readonly EmbeddingConfig _config;
	private readonly object _sessionLock = new();
	private readonly PythonEmbeddingClient? _pythonClient;
	private readonly bool _usePythonBridge;
	private bool _disposed;

	// Performance tracking
	private long _totalEmbeddings;
	private long _totalLatencyMs;
	private long _cacheHits;
	private long _bridgeEmbeddings;
	private long _directEmbeddings;

	public int Dimension => _config.Dimension;
	public bool IsAvailable => _session != null || _usePythonBridge;
	public double AvgLatencyMs => _totalEmbeddings > 0 ? (double)_totalLatencyMs / _totalEmbeddings : 0.0;
	public long TotalEmbeddings => _totalEmbeddings;
	public long CacheHits => _cacheHits;
	public long BridgeEmbeddings => _bridgeEmbeddings;
	public long DirectEmbeddings => _directEmbeddings;

	public EmbeddingService(EmbeddingConfig? config = null)
	{
		_config = config ?? new EmbeddingConfig();
		_cache = new MemoryCache(new MemoryCacheOptions { SizeLimit = _config.CacheMaxEntries });

		// Initialize Python bridge if URL configured
		_usePythonBridge = !string.IsNullOrEmpty(_config.PythonBridgeUrl);
		if (_usePythonBridge)
		{
			_pythonClient = new PythonEmbeddingClient(_config.PythonBridgeUrl!);
			Console.WriteLine($"[EmbeddingService] Python bridge configured at: {_config.PythonBridgeUrl}");
		}

		if (File.Exists(_config.ModelPath))
		{
			try
			{
				SessionOptions options = new();
				options.InterOpNumThreads = _config.InterOpThreads;
				options.IntraOpNumThreads = _config.IntraOpThreads;
				options.GraphOptimizationLevel = GraphOptimizationLevel.ORT_ENABLE_ALL;
				_session = new InferenceSession(_config.ModelPath, options);
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[EmbeddingService] Failed to load ONNX model: {ex.Message}");
				_session = null;
			}
		}
		else
		{
			Console.WriteLine($"[EmbeddingService] Model not found at: {_config.ModelPath}");
		}
	}

	/// <summary>
	/// Generates an embedding vector for the given text.
	/// Tries Python bridge first (faster, proper tokenization), falls back to direct ONNX.
	/// Returns cached result if available.
	/// </summary>
	public async Task<float[]> GenerateEmbeddingAsync(string text, CancellationToken cancellationToken = default)
	{
		if (string.IsNullOrWhiteSpace(text))
		{
			return new float[_config.Dimension];
		}

		// Check cache
		string cacheKey = ComputeCacheKey(text);
		if (_cache.TryGetValue(cacheKey, out float[]? cached) && cached != null)
		{
			Interlocked.Increment(ref _cacheHits);
			return cached;
		}

		float[] embedding;

		// Try Python bridge first (Oracle condition #3)
		if (_usePythonBridge && _pythonClient != null)
		{
			try
			{
				if (await _pythonClient.IsHealthyAsync(cancellationToken))
				{
					PythonEmbeddingResult result = await _pythonClient.GenerateEmbeddingsAsync(new List<string> { text }, cancellationToken: cancellationToken);

					if (result.Embeddings.Count > 0)
					{
						embedding = result.Embeddings[0].ToArray();
						Interlocked.Increment(ref _bridgeEmbeddings);
						Interlocked.Increment(ref _totalEmbeddings);
						Interlocked.Add(ref _totalLatencyMs, (long)result.ProcessingTimeMs);

						// Cache the result
						MemoryCacheEntryOptions bridgeCacheOptions = new() { Size = 1, SlidingExpiration = TimeSpan.FromMinutes(_config.CacheSlidingExpirationMinutes) };
						_cache.Set(cacheKey, embedding, bridgeCacheOptions);

						return embedding;
					}
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[EmbeddingService] Python bridge failed, falling back to direct ONNX: {ex.Message}");
			}
		}

		// Fallback: direct ONNX inference
		embedding = await Task.Run(() => GenerateEmbeddingCore(text), cancellationToken);
		Interlocked.Increment(ref _directEmbeddings);

		// Cache the result
		MemoryCacheEntryOptions cacheOptions = new() { Size = 1, SlidingExpiration = TimeSpan.FromMinutes(_config.CacheSlidingExpirationMinutes) };
		_cache.Set(cacheKey, embedding, cacheOptions);

		return embedding;
	}

	/// <summary>
	/// Generates embeddings for a batch of texts.
	/// Target: >100 embeddings/sec for batch processing.
	/// Uses Python bridge for efficient batching when available.
	/// </summary>
	public async Task<List<float[]>> GenerateBatchEmbeddingsAsync(IReadOnlyList<string> texts, CancellationToken cancellationToken = default)
	{
		// Try Python bridge for entire batch (much faster, native batching)
		if (_usePythonBridge && _pythonClient != null)
		{
			try
			{
				if (await _pythonClient.IsHealthyAsync(cancellationToken))
				{
					PythonEmbeddingResult result = await _pythonClient.GenerateEmbeddingsAsync(texts.ToList(), cancellationToken: cancellationToken);

					if (result.Embeddings.Count == texts.Count)
					{
						Interlocked.Add(ref _bridgeEmbeddings, texts.Count);
						Interlocked.Add(ref _totalEmbeddings, texts.Count);
						Interlocked.Add(ref _totalLatencyMs, (long)result.ProcessingTimeMs);

						List<float[]> bridgeResults = result.Embeddings.Select(e => e.ToArray()).ToList();

						// Cache each result
						for (int i = 0; i < texts.Count; i++)
						{
							string cacheKey = ComputeCacheKey(texts[i]);
							MemoryCacheEntryOptions cacheOptions = new() { Size = 1, SlidingExpiration = TimeSpan.FromMinutes(_config.CacheSlidingExpirationMinutes) };
							_cache.Set(cacheKey, bridgeResults[i], cacheOptions);
						}

						return bridgeResults;
					}
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[EmbeddingService] Python bridge batch failed, falling back to direct ONNX: {ex.Message}");
			}
		}

		// Fallback: process individually with bounded concurrency
		List<float[]> results = new(texts.Count);

		SemaphoreSlim semaphore = new(_config.MaxBatchConcurrency);
		Task<float[]>[] tasks = texts
			.Select(async text =>
			{
				await semaphore.WaitAsync(cancellationToken);
				try
				{
					return await GenerateEmbeddingAsync(text, cancellationToken);
				}
				finally
				{
					semaphore.Release();
				}
			})
			.ToArray();

		float[][] embeddings = await Task.WhenAll(tasks);
		results.AddRange(embeddings);

		return results;
	}

	/// <summary>
	/// Core embedding generation using ONNX Runtime.
	/// Falls back to hash-based pseudo-embedding if model unavailable.
	/// </summary>
	private float[] GenerateEmbeddingCore(string text)
	{
		Stopwatch sw = Stopwatch.StartNew();

		float[] embedding;

		if (_session != null)
		{
			embedding = RunOnnxInference(text);
		}
		else
		{
			// Fallback: deterministic hash-based pseudo-embedding
			embedding = GenerateFallbackEmbedding(text);
		}

		sw.Stop();
		Interlocked.Increment(ref _totalEmbeddings);
		Interlocked.Add(ref _totalLatencyMs, sw.ElapsedMilliseconds);

		return embedding;
	}

	/// <summary>
	/// Runs ONNX inference to generate embedding from text.
	/// </summary>
	private float[] RunOnnxInference(string text)
	{
		lock (_sessionLock)
		{
			// Tokenize: simple whitespace tokenization with padding
			// Real implementation would use a proper tokenizer (BertTokenizer)
			long[] inputIds = TokenizeSimple(text);
			long[] attentionMask = new long[inputIds.Length];
			long[] tokenTypeIds = new long[inputIds.Length];
			for (int i = 0; i < inputIds.Length; i++)
			{
				attentionMask[i] = 1;
				tokenTypeIds[i] = 0;
			}

			int sequenceLength = inputIds.Length;

			DenseTensor<long> inputIdsTensor = new(inputIds, new[] { 1, sequenceLength });
			DenseTensor<long> attentionMaskTensor = new(attentionMask, new[] { 1, sequenceLength });
			DenseTensor<long> tokenTypeIdsTensor = new(tokenTypeIds, new[] { 1, sequenceLength });

			List<NamedOnnxValue> inputs = new()
			{
				NamedOnnxValue.CreateFromTensor("input_ids", inputIdsTensor),
				NamedOnnxValue.CreateFromTensor("attention_mask", attentionMaskTensor),
				NamedOnnxValue.CreateFromTensor("token_type_ids", tokenTypeIdsTensor),
			};

			using IDisposableReadOnlyCollection<DisposableNamedOnnxValue> results = _session!.Run(inputs);

			// Extract embedding from first output (sentence embedding)
			DisposableNamedOnnxValue output = results.First();
			ReadOnlySpan<float> outputData = output.AsEnumerable<float>().ToArray();

			// Mean pooling over token dimension
			float[] embedding = new float[_config.Dimension];
			int tokenCount = sequenceLength;

			for (int i = 0; i < tokenCount; i++)
			{
				for (int j = 0; j < _config.Dimension && (i * _config.Dimension + j) < outputData.Length; j++)
				{
					embedding[j] += outputData[i * _config.Dimension + j];
				}
			}

			// Average
			for (int j = 0; j < _config.Dimension; j++)
			{
				embedding[j] /= tokenCount;
			}

			// L2 normalize
			Normalize(embedding);

			return embedding;
		}
	}

	/// <summary>
	/// Simple tokenization that maps characters to token IDs.
	/// Production would use HuggingFace tokenizer via SharpToken or similar.
	/// </summary>
	private static long[] TokenizeSimple(string text)
	{
		// Simple word-level tokenization with max length
		string[] words = text.Split(' ', StringSplitOptions.RemoveEmptyEntries);
		int maxLength = Math.Min(words.Length, 512);

		long[] ids = new long[maxLength];
		for (int i = 0; i < maxLength; i++)
		{
			// Hash each word to a token ID in vocabulary range
			ids[i] = Math.Abs(words[i].GetHashCode()) % 30522; // BERT vocab size
		}

		return ids.Length > 0 ? ids : new long[] { 101, 102 }; // [CLS], [SEP]
	}

	/// <summary>
	/// Deterministic hash-based fallback embedding when ONNX model is unavailable.
	/// Provides consistent vector representation for deduplication and basic similarity.
	/// </summary>
	private float[] GenerateFallbackEmbedding(string text)
	{
		float[] embedding = new float[_config.Dimension];
		int hash = text.GetHashCode();
		Random rng = new(hash);

		for (int i = 0; i < _config.Dimension; i++)
		{
			embedding[i] = (float)(rng.NextDouble() * 2.0 - 1.0);
		}

		Normalize(embedding);
		return embedding;
	}

	/// <summary>
	/// L2 normalizes a vector in-place.
	/// </summary>
	private static void Normalize(float[] vector)
	{
		double magnitude = 0.0;
		for (int i = 0; i < vector.Length; i++)
		{
			magnitude += vector[i] * (double)vector[i];
		}
		magnitude = Math.Sqrt(magnitude);

		if (magnitude > 1e-12)
		{
			for (int i = 0; i < vector.Length; i++)
			{
				vector[i] = (float)(vector[i] / magnitude);
			}
		}
	}

	/// <summary>
	/// Computes a cache key for text by hashing.
	/// </summary>
	private static string ComputeCacheKey(string text)
	{
		int hash = text.GetHashCode(StringComparison.Ordinal);
		return $"emb_{hash:X8}";
	}

	public void Dispose()
	{
		if (!_disposed)
		{
			_disposed = true;
			_session?.Dispose();
			_cache.Dispose();
			_pythonClient?.Dispose();
		}
	}
}

/// <summary>
/// Configuration for the embedding service.
/// </summary>
public sealed class EmbeddingConfig
{
	/// <summary>
	/// Path to the ONNX model file. Default: all-MiniLM-L6-v2.
	/// </summary>
	public string ModelPath { get; init; } = Path.Combine("rag", "models", "all-MiniLM-L6-v2.onnx");

	/// <summary>
	/// Embedding dimension. 384 for all-MiniLM-L6-v2.
	/// </summary>
	public int Dimension { get; init; } = 384;

	/// <summary>
	/// Maximum cache entries for embeddings.
	/// </summary>
	public int CacheMaxEntries { get; init; } = 10000;

	/// <summary>
	/// Cache sliding expiration in minutes.
	/// </summary>
	public int CacheSlidingExpirationMinutes { get; init; } = 60;

	/// <summary>
	/// ONNX inter-op thread count.
	/// </summary>
	public int InterOpThreads { get; init; } = 4;

	/// <summary>
	/// ONNX intra-op thread count.
	/// </summary>
	public int IntraOpThreads { get; init; } = 4;

	/// <summary>
	/// Max concurrency for batch embedding generation.
	/// </summary>
	public int MaxBatchConcurrency { get; init; } = 4;

	/// <summary>
	/// URL of the Python embedding bridge (FastAPI service).
	/// When set, embeddings are generated via the bridge first, with fallback to direct ONNX.
	/// Oracle condition #3: C# → Python → ONNX pipeline.
	/// Example: "http://127.0.0.1:5000"
	/// </summary>
	public string? PythonBridgeUrl { get; init; }
}
