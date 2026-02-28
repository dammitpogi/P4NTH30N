---
agent: designer
type: specification
decision: DECISION_051
created: 2026-02-23T12:15:00Z
status: final
tags: [h4nd, mongodb, schema, objects, evidence]
---

# DECISION_051: MongoDB Object Model for Dynamic Error Evidence

Use this object model for `_debug` documents so H4ND can store heterogeneous evidence without frequent schema migrations.

## 1) Root Document (Envelope + Typed Payload)

```csharp
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorEvidenceDocument
{
    [BsonId]
    public ObjectId Id { get; set; } = ObjectId.GenerateNewId();

    [BsonElement("capturedAt")]
    public DateTime CapturedAtUtc { get; set; } = DateTime.UtcNow;

    [BsonElement("expiresAt")]
    public DateTime ExpiresAtUtc { get; set; }

    [BsonElement("sessionId")]
    public string SessionId { get; set; } = string.Empty;

    [BsonElement("correlationId")]
    public string? CorrelationId { get; set; }

    [BsonElement("operationId")]
    public string? OperationId { get; set; }

    [BsonElement("component")]
    public string Component { get; set; } = string.Empty;

    [BsonElement("operation")]
    public string Operation { get; set; } = string.Empty;

    [BsonElement("severity")]
    [BsonRepresentation(BsonType.String)]
    public ErrorSeverity Severity { get; set; } = ErrorSeverity.Error;

    [BsonElement("errorCode")]
    public string? ErrorCode { get; set; }

    [BsonElement("workerId")]
    public string? WorkerId { get; set; }

    [BsonElement("machineName")]
    public string? MachineName { get; set; }

    [BsonElement("processId")]
    public int? ProcessId { get; set; }

    [BsonElement("tags")]
    public List<string> Tags { get; set; } = new();

    [BsonElement("location")]
    public ErrorLocation Location { get; set; } = new();

    [BsonElement("exception")]
    public ErrorExceptionSnapshot? Exception { get; set; }

    [BsonElement("context")]
    public BsonDocument Context { get; set; } = new();

    [BsonElement("evidence")]
    public EvidenceEnvelope Evidence { get; set; } = new();

    [BsonElement("schemaVersion")]
    public int SchemaVersion { get; set; } = 1;
}

public enum ErrorSeverity
{
    Critical,
    Error,
    Warning,
    Info,
    Debug,
}
```

## 2) Shared Sub-Objects

```csharp
public sealed class ErrorLocation
{
    [BsonElement("file")]
    public string? File { get; set; }

    [BsonElement("member")]
    public string? Member { get; set; }

    [BsonElement("line")]
    public int? Line { get; set; }
}

public sealed class ErrorExceptionSnapshot
{
    [BsonElement("type")]
    public string Type { get; set; } = string.Empty;

    [BsonElement("message")]
    public string Message { get; set; } = string.Empty;

    [BsonElement("stackTrace")]
    public string? StackTrace { get; set; }

    [BsonElement("inner")]
    public ErrorExceptionSnapshot? Inner { get; set; }
}

public sealed class EvidenceEnvelope
{
    [BsonElement("schemaVersion")]
    public string SchemaVersion { get; set; } = "1.0";

    [BsonElement("evidenceType")]
    public string EvidenceType { get; set; } = string.Empty;

    [BsonElement("summary")]
    public string? Summary { get; set; }

    // Dynamic payload for component-specific evidence.
    [BsonElement("data")]
    public BsonDocument Data { get; set; } = new();
}
```

## 3) Typed Builders (Readability + Safety)

Use typed evidence DTOs, then serialize to `BsonDocument` for `EvidenceEnvelope.Data`.

```csharp
public interface IEvidencePayload
{
    string EvidenceType { get; }
    string Version { get; }
    string? Summary { get; }
}

public sealed class SpinExecutionFailureEvidence : IEvidencePayload
{
    public string EvidenceType => "Spin.ExecutionFailure";
    public string Version => "2.1";
    public string? Summary { get; init; }

    public string SpinRequestId { get; init; } = string.Empty;
    public decimal BetAmount { get; init; }
    public int StatusCode { get; init; }
    public double ResponseTimeMs { get; init; }
    public List<ValidationFailureItem> ValidationFailures { get; init; } = new();
    public string? ScreenshotRef { get; init; }
}

public sealed class ValidationFailureItem
{
    public string Field { get; init; } = string.Empty;
    public string Expected { get; init; } = string.Empty;
    public string Actual { get; init; } = string.Empty;
}
```

## 4) Factory API (What runtime code should call)

```csharp
using MongoDB.Bson.Serialization;

public interface IErrorEvidenceFactory
{
    ErrorEvidenceDocument Create(
        string sessionId,
        string component,
        string operation,
        ErrorSeverity severity,
        string errorCode,
        Exception? exception,
        IEvidencePayload payload,
        BsonDocument? context = null,
        string? correlationId = null,
        string? operationId = null);
}

public sealed class ErrorEvidenceFactory : IErrorEvidenceFactory
{
    public ErrorEvidenceDocument Create(
        string sessionId,
        string component,
        string operation,
        ErrorSeverity severity,
        string errorCode,
        Exception? exception,
        IEvidencePayload payload,
        BsonDocument? context = null,
        string? correlationId = null,
        string? operationId = null)
    {
        return new ErrorEvidenceDocument
        {
            SessionId = sessionId,
            CorrelationId = correlationId,
            OperationId = operationId,
            Component = component,
            Operation = operation,
            Severity = severity,
            ErrorCode = errorCode,
            Evidence = new EvidenceEnvelope
            {
                EvidenceType = payload.EvidenceType,
                SchemaVersion = payload.Version,
                Summary = payload.Summary,
                Data = payload.ToBsonDocument(),
            },
            Context = context ?? new BsonDocument(),
            Exception = exception is null ? null : MapException(exception),
            ExpiresAtUtc = DateTime.UtcNow.AddDays(14),
        };
    }

    private static ErrorExceptionSnapshot MapException(Exception ex)
        => new()
        {
            Type = ex.GetType().FullName ?? ex.GetType().Name,
            Message = ex.Message,
            StackTrace = ex.StackTrace,
            Inner = ex.InnerException is null ? null : MapException(ex.InnerException),
        };
}
```

## 5) Repository Contract

```csharp
public interface IErrorEvidenceRepository
{
    Task InsertAsync(ErrorEvidenceDocument document, CancellationToken ct = default);

    Task<IReadOnlyList<ErrorEvidenceDocument>> QueryBySessionAsync(
        string sessionId,
        int limit,
        CancellationToken ct = default);

    Task<IReadOnlyList<ErrorEvidenceDocument>> QueryByCorrelationAsync(
        string correlationId,
        int limit,
        CancellationToken ct = default);
}
```

## 6) Minimum Required Indexes

```javascript
db._debug.createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 });
db._debug.createIndex({ sessionId: 1, capturedAt: -1 });
db._debug.createIndex({ correlationId: 1, capturedAt: -1 });
db._debug.createIndex({ component: 1, operation: 1, capturedAt: -1 });
db._debug.createIndex({ errorCode: 1, capturedAt: -1 });
```

## 7) Guidance

- Keep `ErrorEvidenceDocument` stable.
- Let variation live in `EvidenceEnvelope.Data`.
- Introduce new evidence types by adding new payload DTOs only.
- Do not break existing readers; only add optional fields in payload minor versions.
