using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Driver;
using P4NTH30N.H4ND.Domains.Common;

namespace P4NTH30N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Concrete structured logger backed by 4 BufferedLogWriters.
/// Each writer targets a separate MongoDB collection with independent backpressure.
/// </summary>
public sealed class StructuredLogger : IStructuredLogger
{
	private readonly BufferedLogWriter<OperationalLogEntry> _operationalWriter;
	private readonly BufferedLogWriter<AuditLogEntry> _auditWriter;
	private readonly BufferedLogWriter<PerformanceLogEntry> _performanceWriter;
	private readonly BufferedLogWriter<DomainLogEntry> _domainWriter;

	public TelemetryLossCounters OperationalCounters { get; }
	public TelemetryLossCounters AuditCounters { get; }
	public TelemetryLossCounters PerformanceCounters { get; }
	public TelemetryLossCounters DomainCounters { get; }

	public StructuredLogger(
		IMongoCollection<OperationalLogEntry> operationalCollection,
		IMongoCollection<AuditLogEntry> auditCollection,
		IMongoCollection<PerformanceLogEntry> performanceCollection,
		IMongoCollection<DomainLogEntry> domainCollection,
		int bufferCapacity = 4096,
		int batchSize = 64,
		TimeSpan? flushInterval = null,
		Action<string>? errorLogger = null)
	{
		OperationalCounters = new TelemetryLossCounters();
		AuditCounters = new TelemetryLossCounters();
		PerformanceCounters = new TelemetryLossCounters();
		DomainCounters = new TelemetryLossCounters();

		_operationalWriter = new BufferedLogWriter<OperationalLogEntry>(
			operationalCollection, OperationalCounters, bufferCapacity, batchSize, flushInterval, errorLogger);
		_auditWriter = new BufferedLogWriter<AuditLogEntry>(
			auditCollection, AuditCounters, bufferCapacity, batchSize, flushInterval, errorLogger);
		_performanceWriter = new BufferedLogWriter<PerformanceLogEntry>(
			performanceCollection, PerformanceCounters, bufferCapacity, batchSize, flushInterval, errorLogger);
		_domainWriter = new BufferedLogWriter<DomainLogEntry>(
			domainCollection, DomainCounters, bufferCapacity, batchSize, flushInterval, errorLogger);
	}

	public void LogOperational(
		StructuredLogLevel level,
		string source,
		string message,
		Dictionary<string, object>? properties = null,
		Exception? exception = null)
	{
		var ctx = CorrelationContext.Current;
		var entry = new OperationalLogEntry
		{
			Level = level,
			Source = source,
			Message = message,
			Properties = properties,
			CorrelationId = ctx?.CorrelationId.ToString() ?? string.Empty,
			SessionId = ctx?.SessionId.ToString() ?? string.Empty,
			WorkerId = ctx?.WorkerId,
			OperationName = ctx?.OperationName?.ToString(),
		};

		if (exception != null)
		{
			entry.ExceptionType = exception.GetType().FullName;
			entry.ExceptionMessage = exception.Message;
			entry.StackTrace = exception.StackTrace;
		}

		_operationalWriter.TryWrite(entry);
	}

	public void LogAudit(
		string action,
		string actor,
		string? target = null,
		string? outcome = null,
		string? reason = null,
		Dictionary<string, object>? details = null)
	{
		var ctx = CorrelationContext.Current;
		var entry = new AuditLogEntry
		{
			Action = action,
			Actor = actor,
			Target = target,
			Outcome = outcome,
			Reason = reason,
			Details = details,
			CorrelationId = ctx?.CorrelationId.ToString() ?? string.Empty,
			SessionId = ctx?.SessionId.ToString() ?? string.Empty,
			WorkerId = ctx?.WorkerId,
		};

		_auditWriter.TryWrite(entry);
	}

	public void LogPerformance(
		string operationName,
		double durationMs,
		bool success,
		string? source = null,
		string? errorMessage = null)
	{
		var ctx = CorrelationContext.Current;
		var entry = new PerformanceLogEntry
		{
			OperationName = operationName,
			DurationMs = durationMs,
			Success = success,
			Source = source,
			ErrorMessage = errorMessage,
			CorrelationId = ctx?.CorrelationId.ToString() ?? string.Empty,
			SessionId = ctx?.SessionId.ToString() ?? string.Empty,
			WorkerId = ctx?.WorkerId,
			MemoryBytesUsed = GC.GetTotalMemory(false),
			ActiveThreads = System.Diagnostics.Process.GetCurrentProcess().Threads.Count,
		};

		_performanceWriter.TryWrite(entry);
	}

	public void LogDomainEvent(
		string eventType,
		string source,
		BsonDocument? payload = null)
	{
		var ctx = CorrelationContext.Current;
		var entry = new DomainLogEntry
		{
			EventType = eventType,
			Source = source,
			Payload = payload,
			CorrelationId = ctx?.CorrelationId.ToString() ?? string.Empty,
			SessionId = ctx?.SessionId.ToString() ?? string.Empty,
			WorkerId = ctx?.WorkerId,
			OperationName = ctx?.OperationName?.ToString(),
		};

		_domainWriter.TryWrite(entry);
	}

	public async ValueTask DisposeAsync()
	{
		await _operationalWriter.DisposeAsync();
		await _auditWriter.DisposeAsync();
		await _performanceWriter.DisposeAsync();
		await _domainWriter.DisposeAsync();
	}
}
