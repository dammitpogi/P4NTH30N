using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Channels;
using MongoDB.Bson;
using P4NTHE0N.H4ND.Domains.Common;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorEvidenceService : IErrorEvidence
{
	private sealed class ScopeState
	{
		public required string SessionId { get; init; }
		public required string CorrelationId { get; init; }
		public required string Component { get; init; }
		public required string Operation { get; init; }
		public required string OperationId { get; init; }
		public required Dictionary<string, object> Tags { get; init; }
		public ScopeState? Parent { get; init; }
	}

	private readonly IErrorEvidenceRepository _repository;
	private readonly IErrorEvidenceFactory _factory;
	private readonly ErrorEvidenceOptions _options;
	private readonly Action<string> _operationalLog;
	private bool _enabled;
	private readonly string _serviceSessionId = Guid.NewGuid().ToString("D");
	private readonly Channel<ErrorEvidenceDocument>? _channel;
	private readonly Task? _writerTask;
	private readonly CancellationTokenSource _cts = new();
	private readonly AsyncLocal<ScopeState?> _scope = new();
	private DateTime _lastSummaryAtUtc = DateTime.UtcNow;

	private long _enqueued;
	private long _written;
	private long _droppedQueueFull;
	private long _droppedSinkFailure;

	public ErrorEvidenceService(
		IErrorEvidenceRepository repository,
		IErrorEvidenceFactory factory,
		ErrorEvidenceOptions options,
		Action<string>? operationalLog = null)
	{
		_repository = repository ?? throw new ArgumentNullException(nameof(repository));
		_factory = factory ?? throw new ArgumentNullException(nameof(factory));
		_options = options ?? throw new ArgumentNullException(nameof(options));
		_operationalLog = operationalLog ?? (msg => Console.WriteLine(msg));
		_enabled = _options.Enabled;

		if (!_enabled)
		{
			return;
		}

		try
		{
			_repository.EnsureIndexesAsync().GetAwaiter().GetResult();
		}
		catch (Exception ex)
		{
			_operationalLog($"[ErrorEvidence] index bootstrap failed — evidence disabled: {ex.Message}");
			_enabled = false;
			return;
		}

		_channel = Channel.CreateBounded<ErrorEvidenceDocument>(new BoundedChannelOptions(Math.Max(16, _options.QueueCapacity))
		{
			SingleReader = true,
			SingleWriter = false,
			FullMode = BoundedChannelFullMode.DropWrite,
		});

		_writerTask = Task.Run(WriteLoopAsync);
	}

	public ErrorScope BeginScope(
		string component,
		string operation,
		Dictionary<string, object>? tags = null,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0)
	{
		if (!_enabled)
		{
			return ErrorScope.Empty;
		}

		ArgumentException.ThrowIfNullOrWhiteSpace(component);
		ArgumentException.ThrowIfNullOrWhiteSpace(operation);

		ScopeState? parent = _scope.Value;
		var ctx = CorrelationContext.Current;
		string correlationId = parent?.CorrelationId
			?? ctx?.CorrelationId.ToString()
			?? Guid.NewGuid().ToString("D");

		string sessionId = parent?.SessionId
			?? ctx?.SessionId.ToString()
			?? _serviceSessionId;

		ScopeState state = new()
		{
			SessionId = sessionId,
			CorrelationId = correlationId,
			Component = component,
			Operation = operation,
			OperationId = Guid.NewGuid().ToString("D"),
			Tags = tags ?? new Dictionary<string, object>(),
			Parent = parent,
		};

		_scope.Value = state;
		return new ErrorScope(
			correlationId: state.CorrelationId,
			sessionId: state.SessionId,
			component: state.Component,
			operation: state.Operation,
			operationId: state.OperationId,
			onDispose: () => _scope.Value = parent);
	}

	public void Capture(
		Exception ex,
		string code,
		string message,
		Dictionary<string, object>? context = null,
		object? evidence = null,
		ErrorSeverity severity = ErrorSeverity.Error,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0)
	{
		if (!_enabled)
		{
			return;
		}

		ArgumentNullException.ThrowIfNull(ex);
		if (!ShouldCapture(code, severity))
		{
			return;
		}

		ScopeState? scope = _scope.Value;
		string component = scope?.Component ?? "UnknownComponent";
		string operation = scope?.Operation ?? "UnknownOperation";
		string correlationId = scope?.CorrelationId ?? CorrelationContext.Current?.CorrelationId.ToString() ?? Guid.NewGuid().ToString("D");
		string sessionId = scope?.SessionId ?? CorrelationContext.Current?.SessionId.ToString() ?? _serviceSessionId;

		BsonDocument contextDoc = BuildContext(scope, context);
		IEvidencePayload payload = BuildPayload("Runtime.Error", "1.0", message, evidence);

		ErrorEvidenceDocument document = _factory.Create(
			sessionId: sessionId,
			component: component,
			operation: operation,
			severity: severity,
			errorCode: code,
			message: message,
			exception: ex,
			payload: payload,
			context: contextDoc,
			correlationId: correlationId,
			operationId: scope?.OperationId,
			location: new ErrorLocation
			{
				File = Path.GetFileName(filePath),
				Member = memberName,
				Line = lineNumber,
			},
			tags: scope?.Tags.Keys.ToList());

		Enqueue(document);
	}

	public void CaptureWarning(
		string code,
		string message,
		Dictionary<string, object>? context = null,
		object? evidence = null,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0)
	{
		Capture(
			ex: new InvalidOperationException(message),
			code: code,
			message: message,
			context: context,
			evidence: evidence,
			severity: ErrorSeverity.Warning,
			filePath: filePath,
			memberName: memberName,
			lineNumber: lineNumber);
	}

	public void CaptureInvariantFailure(
		string code,
		string message,
		object? expected,
		object? actual,
		Dictionary<string, object>? context = null,
		[CallerFilePath] string filePath = "",
		[CallerMemberName] string memberName = "",
		[CallerLineNumber] int lineNumber = 0)
	{
		Dictionary<string, object> ctx = context ?? new Dictionary<string, object>();
		ctx["expected"] = expected?.ToString() ?? "<null>";
		ctx["actual"] = actual?.ToString() ?? "<null>";

		Capture(
			ex: new InvalidOperationException(message),
			code: code,
			message: message,
			context: ctx,
			evidence: new { expected, actual, diff = ComputeDiff(expected, actual) },
			severity: ErrorSeverity.Error,
			filePath: filePath,
			memberName: memberName,
			lineNumber: lineNumber);
	}

	public ErrorEvidenceStats GetStats() => new(
		Enqueued: Interlocked.Read(ref _enqueued),
		Written: Interlocked.Read(ref _written),
		DroppedQueueFull: Interlocked.Read(ref _droppedQueueFull),
		DroppedSinkFailure: Interlocked.Read(ref _droppedSinkFailure),
		Enabled: _enabled);

	public async ValueTask DisposeAsync()
	{
		if (_channel != null)
		{
			_channel.Writer.TryComplete();
		}

		if (_writerTask != null)
		{
			await _writerTask;
		}

		_cts.Cancel();
		_cts.Dispose();
	}

	private void Enqueue(ErrorEvidenceDocument document)
	{
		if (_channel == null)
		{
			return;
		}

		if (_channel.Writer.TryWrite(document))
		{
			Interlocked.Increment(ref _enqueued);
		}
		else
		{
			Interlocked.Increment(ref _droppedQueueFull);
			EmitSummaryIfDue();
		}
	}

	private bool ShouldCapture(string code, ErrorSeverity severity)
	{
		if (severity is ErrorSeverity.Critical or ErrorSeverity.Error)
		{
			return true;
		}

		ScopeState? scope = _scope.Value;
		string component = scope?.Component ?? "UnknownComponent";
		string correlation = scope?.CorrelationId ?? CorrelationContext.Current?.CorrelationId.ToString() ?? _serviceSessionId;

		double rate = _options.GetSamplingRate(component, severity);
		if (rate >= 1.0)
		{
			return true;
		}

		if (rate <= 0)
		{
			return false;
		}

		ulong hash = StableHash64($"{correlation}|{component}|{code}|{severity}");
		double sample = (hash % 1_000_000UL) / 1_000_000.0;
		return sample < rate;
	}

	private async Task WriteLoopAsync()
	{
		if (_channel == null)
		{
			return;
		}

		List<ErrorEvidenceDocument> batch = new(Math.Max(1, _options.BatchSize));
		TimeSpan delay = TimeSpan.FromMilliseconds(Math.Clamp(_options.FlushIntervalMs, 10, 5000));

		while (!_cts.IsCancellationRequested)
		{
			try
			{
				await Task.Delay(delay, _cts.Token);
			}
			catch (OperationCanceledException)
			{
				break;
			}

			while (_channel.Reader.TryRead(out ErrorEvidenceDocument? doc))
			{
				batch.Add(doc);
				if (batch.Count >= _options.BatchSize)
				{
					await FlushBatchAsync(batch);
				}
			}

			if (batch.Count > 0)
			{
				await FlushBatchAsync(batch);
			}

			EmitSummaryIfDue();
		}

		// Drain remaining on shutdown
		while (_channel.Reader.TryRead(out ErrorEvidenceDocument? remaining))
		{
			batch.Add(remaining);
			if (batch.Count >= _options.BatchSize)
			{
				await FlushBatchAsync(batch);
			}
		}
		if (batch.Count > 0)
		{
			await FlushBatchAsync(batch);
		}
	}

	private async Task FlushBatchAsync(List<ErrorEvidenceDocument> batch)
	{
		if (batch.Count == 0)
		{
			return;
		}

		try
		{
			await _repository.InsertManyAsync(batch, _cts.Token);
			Interlocked.Add(ref _written, batch.Count);
		}
		catch (Exception ex)
		{
			Interlocked.Add(ref _droppedSinkFailure, batch.Count);
			_operationalLog($"[ErrorEvidence] sink failure dropped {batch.Count} docs: {ex.Message}");
		}
		finally
		{
			batch.Clear();
		}
	}

	private void EmitSummaryIfDue()
	{
		if ((DateTime.UtcNow - _lastSummaryAtUtc).TotalSeconds < _options.SummaryIntervalSeconds)
		{
			return;
		}

		_lastSummaryAtUtc = DateTime.UtcNow;
		long droppedQueue = Interlocked.Read(ref _droppedQueueFull);
		long droppedSink = Interlocked.Read(ref _droppedSinkFailure);
		if (droppedQueue == 0 && droppedSink == 0)
		{
			return;
		}

		long enqueued = Interlocked.Read(ref _enqueued);
		long written = Interlocked.Read(ref _written);
		_operationalLog($"[ErrorEvidence] summary enqueued={enqueued} written={written} droppedQueue={droppedQueue} droppedSink={droppedSink}");
	}

	private static ulong StableHash64(string input)
	{
		const ulong offset = 14695981039346656037;
		const ulong prime = 1099511628211;
		ulong hash = offset;
		foreach (byte b in Encoding.UTF8.GetBytes(input))
		{
			hash ^= b;
			hash *= prime;
		}
		return hash;
	}

	private static BsonDocument BuildContext(ScopeState? scope, Dictionary<string, object>? context)
	{
		BsonDocument doc = [];
		if (scope != null)
		{
			doc["scopeComponent"] = scope.Component;
			doc["scopeOperation"] = scope.Operation;
			doc["scopeOperationId"] = scope.OperationId;
			foreach (KeyValuePair<string, object> tag in scope.Tags)
			{
				doc[$"tag_{tag.Key}"] = BsonValue.Create(tag.Value?.ToString());
			}
		}

		if (context != null)
		{
			foreach (KeyValuePair<string, object> pair in context)
			{
				doc[pair.Key] = ToBsonValue(pair.Value);
			}
		}

		return doc;
	}

	private static IEvidencePayload BuildPayload(string evidenceType, string version, string summary, object? evidence)
	{
		if (evidence is IEvidencePayload p)
		{
			return p;
		}

		BsonDocument data = evidence switch
		{
			null => new BsonDocument(),
			BsonDocument bson => bson,
			_ => SafeToBsonDocument(evidence),
		};

		return new GenericEvidencePayload(evidenceType, version, summary, data);
	}

	private static BsonDocument SafeToBsonDocument(object value)
	{
		try
		{
			if (value is IDictionary<string, object> dict)
			{
				BsonDocument doc = [];
				foreach (KeyValuePair<string, object> pair in dict)
				{
					doc[pair.Key] = ToBsonValue(pair.Value);
				}
				return doc;
			}

			return value.ToBsonDocument();
		}
		catch
		{
			return new BsonDocument
			{
				{ "value", value.ToString() ?? "<null>" },
			};
		}
	}

	private static BsonValue ToBsonValue(object? value)
	{
		if (value == null)
		{
			return BsonNull.Value;
		}

		return value switch
		{
			BsonValue bson => bson,
			string s => s,
			bool b => b,
			int i => i,
			long l => l,
			double d => d,
			decimal m => (double)m,
			float f => (double)f,
			DateTime dt => dt,
			Guid g => g.ToString("D"),
			IEnumerable<string> strings => new BsonArray(strings),
			_ => BsonValue.Create(value.ToString()),
		};
	}

	private static string[] ComputeDiff(object? expected, object? actual)
	{
		if (Equals(expected, actual))
		{
			return [];
		}

		return ["value"];
	}

	private sealed class GenericEvidencePayload : IEvidencePayload
	{
		private readonly BsonDocument _data;

		public GenericEvidencePayload(string evidenceType, string version, string? summary, BsonDocument data)
		{
			EvidenceType = evidenceType;
			Version = version;
			Summary = summary;
			_data = data;
		}

		public string EvidenceType { get; }
		public string Version { get; }
		public string? Summary { get; }
		public BsonDocument ToBsonDocument() => _data;
	}
}
