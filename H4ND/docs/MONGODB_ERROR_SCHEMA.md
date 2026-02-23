# H4ND Error & Evidence Capture Schema Architecture

## Executive Summary

Dynamic schema design for `_debug` collection supporting polymorphic error types with strong correlation, versioning, and retention capabilities.

---

## 1. Schema Pattern Analysis

### Option A: Single Collection Polymorphic Documents
```javascript
// All fields optional, type determines shape
db.errors.insert({
  type: "SpinExecutionError",
  spinId: "...",
  jackpotValue: 1234.56
  // ... other type-specific fields
})
```

**Pros:** Ultimate flexibility, no schema enforcement  
**Cons:** Query complexity, index bloat, no field-level validation

### Option B: Envelope + Typed Payload (RECOMMENDED)
```javascript
{
  // Envelope: Common queryable metadata
  _id: ObjectId,
  capturedAt: ISODate,
  component: "SpinExecution",
  severity: "Error",
  
  // Payload: Type-specific evidence
  evidence: {
    type: "SpinExecutionError",
    version: "2.1",
    data: { /* flexible */ }
  }
}
```

**Pros:** Strong correlation queries, flexible payloads, versioned schemas  
**Cons:** Slightly more complex document structure

### Option C: Split Collections
```javascript
db.spin_errors.insert({...})
db.session_errors.insert({...})
```

**Pros:** Type-specific indexes, isolated concerns  
**Cons:** Cross-correlation queries require $unionWith, maintenance overhead

### Decision: Option B (Envelope + Typed Payload)

Rationale:
- Single collection enables efficient correlation across all error types
- Envelope fields provide queryable metadata without index explosion
- Payload versioning allows schema evolution without migrations
- Aligns with MongoDB's document model strengths

---

## 2. Recommended Schema Specification

### 2.1 Envelope Schema (Required Fields)

```javascript
{
  // Identity
  _id: ObjectId,                    // Auto-generated, unique
  
  // Temporal (TTL support)
  capturedAt: ISODate,              // REQUIRED - Evidence timestamp
  expiresAt: ISODate,               // REQUIRED - TTL expiration
  
  // Correlation (Query Dimensions)
  sessionId: String,                // REQUIRED - Session context
  correlationId: String,            // OPTIONAL - Distributed trace ID
  operationId: String,              // OPTIONAL - Specific operation
  
  // Categorization
  component: String,                // REQUIRED - Source component
  severity: String,                 // REQUIRED - Enum: Critical|Error|Warning|Info|Debug
  errorCode: String,                // OPTIONAL - Categorized error type
  
  // Execution Context
  workerId: String,                 // OPTIONAL - Worker instance
  machineName: String,              // OPTIONAL - Host identifier
  processId: Number,                // OPTIONAL - Process ID
  
  // Metadata
  tags: [String],                   // OPTIONAL - Searchable tags
  
  // Evidence Payload
  evidence: {
    schemaVersion: String,          // REQUIRED - Payload schema version (semver)
    evidenceType: String,           // REQUIRED - Type discriminator
    summary: String,                // OPTIONAL - Human-readable summary
    data: Object                    // REQUIRED - Type-specific payload
  }
}
```

### 2.2 Component-Specific Evidence Types

#### Component: LegacyRuntimeHost
```javascript
evidence: {
  schemaVersion: "1.0",
  evidenceType: "LegacyRuntime.HostError",
  summary: "COM interop failure in automation bridge",
  data: {
    hresult: -2147467259,           // Windows HRESULT code
    message: "Unknown error",
    stackTrace: "at LegacyHost...",
    operation: "ClickElement",
    targetSelector: "#spin-button",
    retryCount: 2,
    innerException: { /* nested */ }
  }
}
```

#### Component: ParallelSpinWorker
```javascript
evidence: {
  schemaVersion: "1.2",
  evidenceType: "ParallelSpin.WorkerFault",
  summary: "Worker thread terminated unexpectedly",
  data: {
    workerIndex: 3,
    spinsCompleted: 47,
    spinsQueued: 12,
    queueDepth: 8,
    exception: {
      type: "TaskCanceledException",
      message: "Operation timed out",
      stackTrace: "..."
    },
    circuitBreakerState: "Open",
    lastSpinTimestamp: ISODate("2026-02-23T14:32:01Z")
  }
}
```

#### Component: SpinExecution
```javascript
evidence: {
  schemaVersion: "2.1",
  evidenceType: "Spin.ExecutionFailure",
  summary: "Spin resulted in unexpected state transition",
  data: {
    spinRequest: {
      sessionId: "sess_abc123",
      betAmount: 2.50,
      paylines: 20,
      timestamp: ISODate("2026-02-23T14:32:00Z")
    },
    response: {
      rawHtml: "<div class=\"error\">...",
      statusCode: 200,
      responseTimeMs: 3421
    },
    validationFailures: [
      { field: "jackpotValue", expected: "number", actual: "null" },
      { field: "balance", expected: "> 0", actual: "-5.00" }
    ],
    screenshotRef: "gridfs://screenshots/spin_abc123.png",
    networkLog: [
      { url: "...", duration: 1200, status: 200 }
    ]
  }
}
```

#### Component: SessionRenewalService
```javascript
evidence: {
  schemaVersion: "1.0",
  evidenceType: "Session.RenewalFailure",
  summary: "Session refresh exceeded maximum retry attempts",
  data: {
    sessionState: "Expired",
    renewalAttempts: [
      { 
        attempt: 1, 
        timestamp: ISODate("..."), 
        result: "NetworkError",
        latencyMs: 5000
      },
      { 
        attempt: 2, 
        timestamp: ISODate("..."), 
        result: "InvalidCredentials",
        latencyMs: 1200
      },
      { 
        attempt: 3, 
        timestamp: ISODate("..."), 
        result: "SessionNotFound",
        latencyMs: 800
      }
    ],
    credentialSource: "MongoDB",
    credentialAge: 86400,           // seconds since credential created
    fallbackActivated: true
  }
}
```

#### Component: SignalGenerator
```javascript
evidence: {
  schemaVersion: "1.3",
  evidenceType: "Signal.GenerationError",
  summary: "Jackpot analysis failed - insufficient sample data",
  data: {
    analysisWindow: {
      startTime: ISODate("2026-02-23T13:00:00Z"),
      endTime: ISODate("2026-02-23T14:32:00Z"),
      durationMinutes: 92
    },
    sampleSize: 12,
    minimumRequired: 50,
    jackpotReadings: [
      { timestamp: ISODate("..."), value: 1234.56, machine: "A1" },
      { timestamp: ISODate("..."), value: 1235.12, machine: "A2" }
    ],
    calculationParameters: {
      trendWindow: 10,
      thresholdPercent: 5.0,
      volatilityModel: "EWMA"
    },
    failureReason: "INSUFFICIENT_SAMPLES"
  }
}
```

---

## 3. Versioning Strategy

### 3.1 Semantic Versioning for Payloads

```
evidence.schemaVersion = "{major}.{minor}"

major: Breaking changes (field removal, type changes)
minor: Additive changes (new optional fields)
```

### 3.2 Version Compatibility Matrix

| Reader Version | Can Read v1.0 | Can Read v1.1 | Can Read v2.0 |
|----------------|---------------|---------------|---------------|
| v1.0 Client    | ✓             | ✓ (ignore new)| ✗             |
| v1.1 Client    | ✓             | ✓             | ✗             |
| v2.0 Client    | ✓ (defaults)  | ✓ (defaults)  | ✓             |

### 3.3 Migration Strategy

**No migrations required** - documents are immutable once written.

**Forward Compatibility:**
- Readers must tolerate unknown fields (standard JSON/MongoDB behavior)
- Use defensive coding: `if (data.newField) { ... }`

**Backward Compatibility:**
- Writers populate all fields for current version
- Readers provide sensible defaults for missing fields

**Schema Registry:**
```javascript
// _evidenceSchemas collection (optional)
db._evidenceSchemas.insert({
  evidenceType: "Spin.ExecutionFailure",
  version: "2.1",
  schema: { /* JSON Schema */ },
  introducedAt: ISODate("2026-02-23"),
  deprecatedAt: null,
  migrationNotes: "Added networkLog field"
})
```

---

## 4. Validation Strategy

### 4.1 MongoDB JSON Schema Validation

```javascript
db.createCollection("_debug", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["capturedAt", "expiresAt", "component", "severity", "evidence"],
      properties: {
        capturedAt: { bsonType: "date" },
        expiresAt: { bsonType: "date" },
        component: { 
          enum: [
            "LegacyRuntimeHost",
            "ParallelSpinWorker", 
            "SpinExecution",
            "SessionRenewalService",
            "SignalGenerator",
            "Unknown"
          ]
        },
        severity: { enum: ["Critical", "Error", "Warning", "Info", "Debug"] },
        sessionId: { bsonType: "string" },
        correlationId: { bsonType: "string" },
        evidence: {
          bsonType: "object",
          required: ["schemaVersion", "evidenceType", "data"],
          properties: {
            schemaVersion: { 
              bsonType: "string",
              pattern: "^\\d+\\.\\d+$"
            },
            evidenceType: { bsonType: "string" },
            summary: { bsonType: "string" },
            data: { bsonType: "object" }
          }
        }
      }
    }
  },
  validationLevel: "moderate",  // Allow existing invalid docs
  validationAction: "warn"      // Log violations, don't reject
})
```

### 4.2 Runtime Validators (C#)

```csharp
public interface IEvidenceValidator
{
    bool Validate(string evidenceType, string schemaVersion, BsonDocument data);
    ValidationResult GetValidationDetails(BsonDocument evidence);
}

public class EvidenceValidator : IEvidenceValidator
{
    private readonly Dictionary<string, JsonSchema> _schemas;
    
    public bool Validate(string evidenceType, string version, BsonDocument data)
    {
        var key = $"{evidenceType}:{version}";
        if (!_schemas.TryGetValue(key, out var schema))
            return true; // Unknown schema = permissive
            
        var json = data.ToJson();
        return schema.Validate(json).IsValid;
    }
}
```

### 4.3 Validation Layers

```
┌─────────────────────────────────────┐
│ Layer 1: Application (Strong Types) │ ← C# models enforce structure
├─────────────────────────────────────┤
│ Layer 2: Runtime Validator          │ ← Schema validation before insert
├─────────────────────────────────────┤
│ Layer 3: MongoDB JSON Schema        │ ← Database-level enforcement (warn)
└─────────────────────────────────────┘
```

---

## 5. Index Strategy

### 5.1 Core Indexes (Required)

```javascript
// TTL index - automatic expiration
db._debug.createIndex(
  { "expiresAt": 1 }, 
  { expireAfterSeconds: 0 }
)

// Primary correlation queries
db._debug.createIndex(
  { "sessionId": 1, "capturedAt": -1 }
)

db._debug.createIndex(
  { "correlationId": 1, "capturedAt": -1 }
)

// Component analysis
db._debug.createIndex(
  { "component": 1, "severity": 1, "capturedAt": -1 }
)

// Error code investigation
db._debug.createIndex(
  { "errorCode": 1, "capturedAt": -1 }
)
```

### 5.2 Optional Indexes (Query Pattern Dependent)

```javascript
// Worker-specific debugging
db._debug.createIndex(
  { "workerId": 1, "capturedAt": -1 }
)

// Evidence type queries
db._debug.createIndex(
  { "evidence.evidenceType": 1, "capturedAt": -1 }
)

// Tag-based search
db._debug.createIndex(
  { "tags": 1, "capturedAt": -1 }
)

// Compound for dashboard queries
db._debug.createIndex(
  { "component": 1, "severity": 1, "errorCode": 1, "capturedAt": -1 }
)
```

### 5.3 Index Tradeoff Analysis

| Index | Size Impact | Query Speed | Use Case |
|-------|-------------|-------------|----------|
| sessionId + capturedAt | Medium | Fast | Session debugging |
| correlationId | Medium | Fast | Distributed tracing |
| component + severity | Low | Fast | Dashboard filters |
| evidence.evidenceType | Medium | Medium | Type-specific analysis |
| tags | High (multi-key) | Medium | Ad-hoc investigation |

**Recommendation:** Start with Core indexes, add Optional indexes based on actual query patterns.

---

## 6. Example Documents

### 6.1 Critical: SpinExecution with Jackpot Anomaly

```javascript
{
  "_id": ObjectId("67bb2f90e3b2a1b3c4d5e6f7"),
  "capturedAt": ISODate("2026-02-23T14:32:15.847Z"),
  "expiresAt": ISODate("2026-03-25T14:32:15.847Z"),
  "sessionId": "sess_orion_abc123",
  "correlationId": "corr_spin_batch_47",
  "operationId": "spin_78345",
  "component": "SpinExecution",
  "severity": "Critical",
  "errorCode": "JACKPOT_VALIDATION_FAILED",
  "workerId": "worker_3",
  "machineName": "H4ND-PROD-03",
  "processId": 8742,
  "tags": ["jackpot", "validation", "urgent"],
  "evidence": {
    "schemaVersion": "2.1",
    "evidenceType": "Spin.ExecutionFailure",
    "summary": "Jackpot reading shows impossible negative value",
    "data": {
      "spinRequest": {
        "sessionId": "sess_orion_abc123",
        "betAmount": 2.50,
        "paylines": 20,
        "timestamp": ISODate("2026-02-23T14:32:00Z")
      },
      "response": {
        "rawHtml": "<span class='jackpot'>-$1,234.56</span>",
        "statusCode": 200,
        "responseTimeMs": 1847
      },
      "validationFailures": [
        {
          "field": "jackpotValue",
          "expected": ">= 0",
          "actual": "-1234.56",
          "severity": "Critical"
        }
      ],
      "previousJackpotValue": 15432.78,
      "expectedRange": { "min": 15000, "max": 16000 },
      "screenshotRef": "gridfs://screenshots/err_67bb2f90.png",
      "parsedElements": {
        "jackpotElement": "span.jackpot",
        "balanceElement": "span.balance",
        "spinButton": "button#spin"
      }
    }
  }
}
```

### 6.2 Error: SessionRenewalService Max Retries

```javascript
{
  "_id": ObjectId("67bb2fa0e3b2a1b3c4d5e6f8"),
  "capturedAt": ISODate("2026-02-23T14:28:03.221Z"),
  "expiresAt": ISODate("2026-03-25T14:28:03.221Z"),
  "sessionId": "sess_orion_xyz789",
  "correlationId": "corr_renewal_attempt",
  "component": "SessionRenewalService",
  "severity": "Error",
  "errorCode": "SESSION_RENEWAL_EXHAUSTED",
  "workerId": "worker_1",
  "machineName": "H4ND-PROD-01",
  "tags": ["session", "renewal", "auth"],
  "evidence": {
    "schemaVersion": "1.0",
    "evidenceType": "Session.RenewalFailure",
    "summary": "Session refresh exceeded maximum retry attempts (3)",
    "data": {
      "sessionState": "Expired",
      "renewalAttempts": [
        {
          "attempt": 1,
          "timestamp": ISODate("2026-02-23T14:27:00Z"),
          "result": "NetworkError",
          "latencyMs": 5002,
          "error": "Request timeout after 5000ms"
        },
        {
          "attempt": 2,
          "timestamp": ISODate("2026-02-23T14:27:30Z"),
          "result": "InvalidCredentials",
          "latencyMs": 1247,
          "error": "401 Unauthorized"
        },
        {
          "attempt": 3,
          "timestamp": ISODate("2026-02-23T14:28:03Z"),
          "result": "SessionNotFound",
          "latencyMs": 823,
          "error": "Session ID not found in database"
        }
      ],
      "credentialSource": "MongoDB",
      "credentialAge": 172800,
      "fallbackActivated": true,
      "fallbackResult": "PARTIAL_RECOVERY"
    }
  }
}
```

### 6.3 Warning: SignalGenerator Insufficient Data

```javascript
{
  "_id": ObjectId("67bb2fb0e3b2a1b3c4d5e6f9"),
  "capturedAt": ISODate("2026-02-23T14:15:00.000Z"),
  "expiresAt": ISODate("2026-03-25T14:15:00.000Z"),
  "sessionId": "sess_analysis_bulk_12",
  "correlationId": "corr_signal_gen_15min",
  "component": "SignalGenerator",
  "severity": "Warning",
  "errorCode": "INSUFFICIENT_SAMPLE_DATA",
  "machineName": "H4ND-ANALYTICS-01",
  "tags": ["signal", "analysis", "sample-size"],
  "evidence": {
    "schemaVersion": "1.3",
    "evidenceType": "Signal.GenerationError",
    "summary": "Jackpot trend analysis skipped - insufficient sample data",
    "data": {
      "analysisWindow": {
        "startTime": ISODate("2026-02-23T14:00:00Z"),
        "endTime": ISODate("2026-02-23T14:15:00Z"),
        "durationMinutes": 15
      },
      "sampleSize": 12,
      "minimumRequired": 50,
      "jackpotReadings": [
        { "timestamp": ISODate("2026-02-23T14:00:00Z"), "value": 1234.56, "machine": "M1-A" },
        { "timestamp": ISODate("2026-02-23T14:01:15Z"), "value": 1235.12, "machine": "M1-B" },
        { "timestamp": ISODate("2026-02-23T14:02:30Z"), "value": 1235.89, "machine": "M2-A" }
      ],
      "calculationParameters": {
        "trendWindow": 10,
        "thresholdPercent": 5.0,
        "volatilityModel": "EWMA",
        "confidenceLevel": 0.95
      },
      "failureReason": "INSUFFICIENT_SAMPLES",
      "recommendation": "Extend analysis window or reduce minimum sample requirement",
      "nextAttemptScheduled": ISODate("2026-02-23T14:30:00Z")
    }
  }
}
```

### 6.4 Info: ParallelSpinWorker Circuit Breaker Open

```javascript
{
  "_id": ObjectId("67bb2fc0e3b2a1b3c4d5e6fa"),
  "capturedAt": ISODate("2026-02-23T14:10:45.332Z"),
  "expiresAt": ISODate("2026-03-25T14:10:45.332Z"),
  "sessionId": "sess_batch_spin_847",
  "correlationId": "corr_worker_pool_3",
  "component": "ParallelSpinWorker",
  "severity": "Info",
  "errorCode": "CIRCUIT_BREAKER_OPENED",
  "workerId": "worker_3",
  "machineName": "H4ND-PROD-03",
  "processId": 8742,
  "tags": ["worker", "circuit-breaker", "resilience"],
  "evidence": {
    "schemaVersion": "1.2",
    "evidenceType": "ParallelSpin.WorkerFault",
    "summary": "Circuit breaker opened due to consecutive failures",
    "data": {
      "workerIndex": 3,
      "spinsCompleted": 47,
      "spinsQueued": 12,
      "queueDepth": 8,
      "circuitBreakerState": "Open",
      "failureThreshold": 5,
      "consecutiveFailures": 5,
      "openDurationSeconds": 30,
      "halfOpenMaxCalls": 3,
      "exception": {
        "type": "TaskCanceledException",
        "message": "Spin operation timed out after 10000ms",
        "stackTrace": "at H4ND.ParallelSpinWorker.ExecuteSpinAsync(...)"
      },
      "lastSpinTimestamp": ISODate("2026-02-23T14:10:35Z"),
      "recoveryScheduledAt": ISODate("2026-02-23T14:11:15Z")
    }
  }
}
```

---

## 7. C# Model/Interface Specification

### 7.1 Core Abstractions

```csharp
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace H4ND.Diagnostics.Evidence;

/// <summary>
/// Base interface for all evidence documents
/// </summary>
public interface IEvidenceDocument
{
    ObjectId Id { get; }
    DateTime CapturedAt { get; }
    DateTime ExpiresAt { get; }
    string SessionId { get; }
    string? CorrelationId { get; }
    string Component { get; }
    ErrorSeverity Severity { get; }
    string? ErrorCode { get; }
    IReadOnlyList<string> Tags { get; }
    EvidencePayload Evidence { get; }
}

/// <summary>
/// Evidence payload container with versioning
/// </summary>
public sealed class EvidencePayload
{
    [BsonElement("schemaVersion")]
    public required string SchemaVersion { get; init; }
    
    [BsonElement("evidenceType")]
    public required string EvidenceType { get; init; }
    
    [BsonElement("summary")]
    public string? Summary { get; init; }
    
    [BsonElement("data")]
    public required BsonDocument Data { get; init; }
}

/// <summary>
/// Strongly-typed evidence payload interface
/// </summary>
public interface ITypedEvidence<out TData> where TData : class
{
    string SchemaVersion { get; }
    string EvidenceType { get; }
    string? Summary { get; }
    TData Data { get; }
}

/// <summary>
/// Error severity levels
/// </summary>
public enum ErrorSeverity
{
    Debug = 0,
    Info = 1,
    Warning = 2,
    Error = 3,
    Critical = 4
}

/// <summary>
/// Well-known component identifiers
/// </summary>
public static class KnownComponents
{
    public const string LegacyRuntimeHost = "LegacyRuntimeHost";
    public const string ParallelSpinWorker = "ParallelSpinWorker";
    public const string SpinExecution = "SpinExecution";
    public const string SessionRenewalService = "SessionRenewalService";
    public const string SignalGenerator = "SignalGenerator";
}
```

### 7.2 MongoDB Document Model

```csharp
/// <summary>
/// MongoDB document for _debug collection
/// </summary>
[BsonCollection("_debug")]
public sealed class ErrorEvidenceDocument : IEvidenceDocument
{
    [BsonId]
    public ObjectId Id { get; init; } = ObjectId.GenerateNewId();
    
    [BsonElement("capturedAt")]
    public DateTime CapturedAt { get; init; } = DateTime.UtcNow;
    
    [BsonElement("expiresAt")]
    public DateTime ExpiresAt { get; init; }
    
    [BsonElement("sessionId")]
    public required string SessionId { get; init; }
    
    [BsonElement("correlationId")]
    public string? CorrelationId { get; init; }
    
    [BsonElement("operationId")]
    public string? OperationId { get; init; }
    
    [BsonElement("component")]
    public required string Component { get; init; }
    
    [BsonElement("severity")]
    [BsonRepresentation(BsonType.String)]
    public ErrorSeverity Severity { get; init; }
    
    [BsonElement("errorCode")]
    public string? ErrorCode { get; init; }
    
    [BsonElement("workerId")]
    public string? WorkerId { get; init; }
    
    [BsonElement("machineName")]
    public string? MachineName { get; init; }
    
    [BsonElement("processId")]
    public int? ProcessId { get; init; }
    
    [BsonElement("tags")]
    public IReadOnlyList<string> Tags { get; init; } = Array.Empty<string>();
    
    [BsonElement("evidence")]
    public required EvidencePayload Evidence { get; init; }
}
```

### 7.3 Type-Specific Evidence Builders

```csharp
/// <summary>
/// Builder for creating type-safe evidence documents
/// </summary>
public interface IEvidenceBuilder<out TData> where TData : class
{
    IEvidenceBuilder<TData> WithSession(string sessionId, string? correlationId = null);
    IEvidenceBuilder<TData> WithSeverity(ErrorSeverity severity);
    IEvidenceBuilder<TData> WithErrorCode(string errorCode);
    IEvidenceBuilder<TData> WithContext(string workerId, string machineName, int? processId = null);
    IEvidenceBuilder<TData> WithTags(params string[] tags);
    IEvidenceBuilder<TData> WithTTL(TimeSpan retention);
    ErrorEvidenceDocument Build(TData data);
}

/// <summary>
/// Evidence data for SpinExecution failures
/// </summary>
public sealed class SpinExecutionEvidence
{
    public required SpinRequestInfo SpinRequest { get; init; }
    public required SpinResponseInfo Response { get; init; }
    public IReadOnlyList<ValidationFailure>? ValidationFailures { get; init; }
    public decimal? PreviousJackpotValue { get; init; }
    public JackpotRange? ExpectedRange { get; init; }
    public string? ScreenshotRef { get; init; }
    public IReadOnlyList<NetworkLogEntry>? NetworkLog { get; init; }
    
    public sealed class SpinRequestInfo
    {
        public required string SessionId { get; init; }
        public required decimal BetAmount { get; init; }
        public required int Paylines { get; init; }
        public DateTime Timestamp { get; init; }
    }
    
    public sealed class SpinResponseInfo
    {
        public required string RawHtml { get; init; }
        public required int StatusCode { get; init; }
        public required long ResponseTimeMs { get; init; }
    }
    
    public sealed class ValidationFailure
    {
        public required string Field { get; init; }
        public required string Expected { get; init; }
        public required string Actual { get; init; }
        public ErrorSeverity Severity { get; init; } = ErrorSeverity.Error;
    }
    
    public sealed class JackpotRange
    {
        public decimal Min { get; init; }
        public decimal Max { get; init; }
    }
    
    public sealed class NetworkLogEntry
    {
        public required string Url { get; init; }
        public required long Duration { get; init; }
        public required int Status { get; init; }
    }
}

/// <summary>
/// Evidence data for Session renewal failures
/// </summary>
public sealed class SessionRenewalEvidence
{
    public required string SessionState { get; init; }
    public required IReadOnlyList<RenewalAttempt> RenewalAttempts { get; init; }
    public required string CredentialSource { get; init; }
    public required long CredentialAge { get; init; }
    public required bool FallbackActivated { get; init; }
    public string? FallbackResult { get; init; }
    
    public sealed class RenewalAttempt
    {
        public required int Attempt { get; init; }
        public required DateTime Timestamp { get; init; }
        public required string Result { get; init; }
        public required long LatencyMs { get; init; }
        public string? Error { get; init; }
    }
}

/// <summary>
/// Evidence data for ParallelSpinWorker faults
/// </summary>
public sealed class WorkerFaultEvidence
{
    public required int WorkerIndex { get; init; }
    public required int SpinsCompleted { get; init; }
    public required int SpinsQueued { get; init; }
    public required int QueueDepth { get; init; }
    public required string CircuitBreakerState { get; init; }
    public ExceptionInfo? Exception { get; init; }
    public DateTime? LastSpinTimestamp { get; init; }
    
    public sealed class ExceptionInfo
    {
        public required string Type { get; init; }
        public required string Message { get; init; }
        public string? StackTrace { get; init; }
    }
}

/// <summary>
/// Evidence data for Signal generation errors
/// </summary>
public sealed class SignalGenerationEvidence
{
    public required AnalysisWindowInfo AnalysisWindow { get; init; }
    public required int SampleSize { get; init; }
    public required int MinimumRequired { get; init; }
    public IReadOnlyList<JackpotReading>? JackpotReadings { get; init; }
    public CalculationParameters? Parameters { get; init; }
    public required string FailureReason { get; init; }
    public string? Recommendation { get; init; }
    public DateTime? NextAttemptScheduled { get; init; }
    
    public sealed class AnalysisWindowInfo
    {
        public required DateTime StartTime { get; init; }
        public required DateTime EndTime { get; init; }
        public int DurationMinutes { get; init; }
    }
    
    public sealed class JackpotReading
    {
        public required DateTime Timestamp { get; init; }
        public required decimal Value { get; init; }
        public required string Machine { get; init; }
    }
    
    public sealed class CalculationParameters
    {
        public int TrendWindow { get; init; }
        public double ThresholdPercent { get; init; }
        public string? VolatilityModel { get; init; }
        public double? ConfidenceLevel { get; init; }
    }
}
```

### 7.4 Fluent Builder Implementation

```csharp
/// <summary>
/// Factory for creating evidence builders
/// </summary>
public sealed class EvidenceBuilderFactory
{
    private readonly string _component;
    private readonly string _schemaVersion;
    private readonly TimeSpan _defaultTtl;
    
    public EvidenceBuilderFactory(
        string component, 
        string schemaVersion = "1.0",
        TimeSpan? defaultTtl = null)
    {
        _component = component;
        _schemaVersion = schemaVersion;
        _defaultTtl = defaultTtl ?? TimeSpan.FromDays(30);
    }
    
    public IEvidenceBuilder<T> CreateBuilder<T>(string evidenceType) 
        where T : class
    {
        return new EvidenceBuilder<T>(_component, evidenceType, _schemaVersion, _defaultTtl);
    }
}

/// <summary>
/// Internal builder implementation
/// </summary>
internal sealed class EvidenceBuilder<TData> : IEvidenceBuilder<TData> 
    where TData : class
{
    private readonly string _component;
    private readonly string _evidenceType;
    private readonly string _schemaVersion;
    private readonly TimeSpan _defaultTtl;
    
    private string? _sessionId;
    private string? _correlationId;
    private ErrorSeverity _severity = ErrorSeverity.Error;
    private string? _errorCode;
    private string? _workerId;
    private string? _machineName;
    private int? _processId;
    private List<string> _tags = new();
    private TimeSpan _ttl;
    
    internal EvidenceBuilder(
        string component, 
        string evidenceType, 
        string schemaVersion,
        TimeSpan defaultTtl)
    {
        _component = component;
        _evidenceType = evidenceType;
        _schemaVersion = schemaVersion;
        _defaultTtl = defaultTtl;
        _ttl = defaultTtl;
    }
    
    public IEvidenceBuilder<TData> WithSession(string sessionId, string? correlationId = null)
    {
        _sessionId = sessionId;
        _correlationId = correlationId;
        return this;
    }
    
    public IEvidenceBuilder<TData> WithSeverity(ErrorSeverity severity)
    {
        _severity = severity;
        return this;
    }
    
    public IEvidenceBuilder<TData> WithErrorCode(string errorCode)
    {
        _errorCode = errorCode;
        return this;
    }
    
    public IEvidenceBuilder<TData> WithContext(string workerId, string machineName, int? processId = null)
    {
        _workerId = workerId;
        _machineName = machineName;
        _processId = processId;
        return this;
    }
    
    public IEvidenceBuilder<TData> WithTags(params string[] tags)
    {
        _tags.AddRange(tags);
        return this;
    }
    
    public IEvidenceBuilder<TData> WithTTL(TimeSpan retention)
    {
        _ttl = retention;
        return this;
    }
    
    public ErrorEvidenceDocument Build(TData data)
    {
        if (string.IsNullOrEmpty(_sessionId))
            throw new InvalidOperationException("SessionId is required");
        
        var capturedAt = DateTime.UtcNow;
        
        return new ErrorEvidenceDocument
        {
            CapturedAt = capturedAt,
            ExpiresAt = capturedAt.Add(_ttl),
            SessionId = _sessionId,
            CorrelationId = _correlationId,
            Component = _component,
            Severity = _severity,
            ErrorCode = _errorCode,
            WorkerId = _workerId,
            MachineName = _machineName,
            ProcessId = _processId,
            Tags = _tags.ToArray(),
            Evidence = new EvidencePayload
            {
                SchemaVersion = _schemaVersion,
                EvidenceType = _evidenceType,
                Data = data.ToBsonDocument()
            }
        };
    }
}
```

### 7.5 Usage Examples

```csharp
// Example 1: Spin execution error
var builderFactory = new EvidenceBuilderFactory(
    KnownComponents.SpinExecution, 
    schemaVersion: "2.1");

var spinBuilder = builderFactory.CreateBuilder<SpinExecutionEvidence>(
    "Spin.ExecutionFailure");

var document = spinBuilder
    .WithSession("sess_orion_abc123", correlationId: "corr_batch_47")
    .WithSeverity(ErrorSeverity.Critical)
    .WithErrorCode("JACKPOT_VALIDATION_FAILED")
    .WithContext("worker_3", "H4ND-PROD-03", processId: 8742)
    .WithTags("jackpot", "validation", "urgent")
    .WithTTL(TimeSpan.FromDays(30))
    .Build(new SpinExecutionEvidence
    {
        SpinRequest = new()
        {
            SessionId = "sess_orion_abc123",
            BetAmount = 2.50m,
            Paylines = 20,
            Timestamp = DateTime.UtcNow.AddMinutes(-1)
        },
        Response = new()
        {
            RawHtml = "<span class='jackpot'>-$1,234.56</span>",
            StatusCode = 200,
            ResponseTimeMs = 1847
        },
        ValidationFailures = new[]
        {
            new SpinExecutionEvidence.ValidationFailure
            {
                Field = "jackpotValue",
                Expected = ">= 0",
                Actual = "-1234.56",
                Severity = ErrorSeverity.Critical
            }
        },
        PreviousJackpotValue = 15432.78m,
        ExpectedRange = new() { Min = 15000m, Max = 16000m },
        ScreenshotRef = "gridfs://screenshots/err_67bb2f90.png"
    });

await _debugCollection.InsertOneAsync(document);

// Example 2: Session renewal failure
var sessionFactory = new EvidenceBuilderFactory(
    KnownComponents.SessionRenewalService, 
    schemaVersion: "1.0");

var sessionDoc = sessionFactory
    .CreateBuilder<SessionRenewalEvidence>("Session.RenewalFailure")
    .WithSession("sess_orion_xyz789")
    .WithSeverity(ErrorSeverity.Error)
    .WithErrorCode("SESSION_RENEWAL_EXHAUSTED")
    .WithContext("worker_1", "H4ND-PROD-01")
    .WithTags("session", "renewal")
    .Build(new SessionRenewalEvidence
    {
        SessionState = "Expired",
        RenewalAttempts = new[]
        {
            new SessionRenewalEvidence.RenewalAttempt
            {
                Attempt = 1,
                Timestamp = DateTime.UtcNow.AddMinutes(-2),
                Result = "NetworkError",
                LatencyMs = 5002,
                Error = "Request timeout after 5000ms"
            }
        },
        CredentialSource = "MongoDB",
        CredentialAge = 172800,
        FallbackActivated = true
    });

await _debugCollection.InsertOneAsync(sessionDoc);
```

### 7.6 Repository Interface

```csharp
/// <summary>
/// Repository for error evidence queries
/// </summary>
public interface IErrorEvidenceRepository
{
    Task InsertAsync(ErrorEvidenceDocument document, CancellationToken ct = default);
    Task<IReadOnlyList<ErrorEvidenceDocument>> FindBySessionAsync(
        string sessionId, 
        int limit = 100,
        CancellationToken ct = default);
    Task<IReadOnlyList<ErrorEvidenceDocument>> FindByCorrelationAsync(
        string correlationId,
        CancellationToken ct = default);
    Task<IReadOnlyList<ErrorEvidenceDocument>> FindByComponentAsync(
        string component,
        ErrorSeverity? minSeverity = null,
        DateTime? since = null,
        int limit = 100,
        CancellationToken ct = default);
    Task<IReadOnlyList<ErrorEvidenceDocument>> FindByErrorCodeAsync(
        string errorCode,
        DateTime? since = null,
        int limit = 100,
        CancellationToken ct = default);
    Task<IReadOnlyDictionary<string, long>> GetErrorCountsByComponentAsync(
        TimeSpan window,
        CancellationToken ct = default);
    IAsyncEnumerable<ErrorEvidenceDocument> StreamRecentAsync(
        TimeSpan window,
        CancellationToken ct = default);
}
```

---

## 8. Performance Considerations

### 8.1 Write Path Optimization

```csharp
// Use WriteConcern.W1 for hot loops (fastest, acknowledges primary only)
var hotLoopCollection = _database
    .GetCollection<ErrorEvidenceDocument>("_debug")
    .WithWriteConcern(WriteConcern.W1);

// Unordered bulk inserts for batch scenarios
var models = evidenceDocs.Select(d => new InsertOneModel<ErrorEvidenceDocument>(d));
await hotLoopCollection.BulkWriteAsync(models, ordered: false);

// For non-critical logs, use fire-and-forget
_ = hotLoopCollection.InsertOneAsync(document)
    .ContinueWith(t => 
    {
        if (t.IsFaulted) _logger.LogWarning("Evidence log failed: {Error}", t.Exception);
    });
```

### 8.2 Read Path Optimization

```csharp
// Projection to avoid fetching large evidence.data payloads
var projection = Builders<ErrorEvidenceDocument>.Projection
    .Include(d => d.Id)
    .Include(d => d.CapturedAt)
    .Include(d => d.Severity)
    .Include(d => d.ErrorCode)
    .Include(d => d.Evidence.Summary);

var summaries = await collection
    .Find(filter)
    .Project<ErrorSummary>(projection)
    .ToListAsync();
```

### 8.3 Storage Optimization

- **Large binary data**: Store in GridFS, reference via `screenshotRef`
- **Deeply nested evidence**: Use capped depth (max 3-4 levels)
- **High-frequency errors**: Consider sampling (log 1 in N) for known non-critical patterns

---

## 9. Deployment Checklist

- [ ] Create `_debug` collection with JSON Schema validator
- [ ] Create TTL index on `expiresAt`
- [ ] Create Core indexes (sessionId, correlationId, component, errorCode)
- [ ] Configure retention policies per environment:
  - Production: 30 days
  - Staging: 7 days
  - Development: 1 day
- [ ] Implement `IEvidenceRepository` in H4ND
- [ ] Add component-specific builders for each known error type
- [ ] Set up monitoring dashboard queries
- [ ] Document error codes and severity guidelines

---

## Appendix: Quick Reference

### MongoDB Queries

```javascript
// Find all errors for a session (newest first)
db._debug.find({ sessionId: "sess_abc123" }).sort({ capturedAt: -1 })

// Count errors by component in last hour
db._debug.aggregate([
  { $match: { capturedAt: { $gte: new Date(Date.now() - 3600000) } } },
  { $group: { _id: "$component", count: { $sum: 1 } } }
])

// Find all Critical errors with jackpot issues
db._debug.find({
  severity: "Critical",
  "evidence.evidenceType": "Spin.ExecutionFailure",
  "evidence.data.validationFailures.field": "jackpotValue"
})

// Correlation trace across all errors
db._debug.find({
  correlationId: "corr_batch_47"
}).sort({ capturedAt: 1 })
```

### C# Quick Start

```csharp
// 1. Create factory for your component
var factory = new EvidenceBuilderFactory(
    KnownComponents.SpinExecution, 
    schemaVersion: "2.1");

// 2. Create builder for specific error type
var builder = factory.CreateBuilder<SpinExecutionEvidence>(
    "Spin.ExecutionFailure");

// 3. Configure context and build
var doc = builder
    .WithSession(sessionId, correlationId)
    .WithSeverity(ErrorSeverity.Critical)
    .Build(evidenceData);

// 4. Persist
await repository.InsertAsync(doc);
```
