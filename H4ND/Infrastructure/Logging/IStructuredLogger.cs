using System;
using System.Collections.Generic;
using MongoDB.Bson;

namespace P4NTHE0N.H4ND.Infrastructure.Logging;

/// <summary>
/// DECISION_110 Phase 2: Structured logger interface for all 4 log sinks.
/// No business logic — pure telemetry surface.
/// </summary>
public interface IStructuredLogger : IAsyncDisposable
{
	// ── Operational ──────────────────────────────────────────────────
	void LogOperational(
		StructuredLogLevel level,
		string source,
		string message,
		Dictionary<string, object>? properties = null,
		Exception? exception = null);

	// ── Audit ────────────────────────────────────────────────────────
	void LogAudit(
		string action,
		string actor,
		string? target = null,
		string? outcome = null,
		string? reason = null,
		Dictionary<string, object>? details = null);

	// ── Performance ──────────────────────────────────────────────────
	void LogPerformance(
		string operationName,
		double durationMs,
		bool success,
		string? source = null,
		string? errorMessage = null);

	// ── Domain Events ────────────────────────────────────────────────
	void LogDomainEvent(
		string eventType,
		string source,
		BsonDocument? payload = null);

	// ── Counters ─────────────────────────────────────────────────────
	TelemetryLossCounters OperationalCounters { get; }
	TelemetryLossCounters AuditCounters { get; }
	TelemetryLossCounters PerformanceCounters { get; }
	TelemetryLossCounters DomainCounters { get; }
}
