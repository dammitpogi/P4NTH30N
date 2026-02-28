using System.Diagnostics;
using System.Text;
using MongoDB.Bson;

namespace P4NTHE0N.H4ND.Infrastructure.Logging.ErrorEvidence;

public sealed class ErrorEvidenceFactory : IErrorEvidenceFactory
{
	private const string Redacted = "***REDACTED***";
	private readonly ErrorEvidenceOptions _options;

	public ErrorEvidenceFactory(ErrorEvidenceOptions options)
	{
		_options = options ?? throw new ArgumentNullException(nameof(options));
	}

	public ErrorEvidenceDocument Create(
		string sessionId,
		string component,
		string operation,
		ErrorSeverity severity,
		string errorCode,
		string message,
		Exception? exception,
		IEvidencePayload payload,
		BsonDocument? context = null,
		string? correlationId = null,
		string? operationId = null,
		ErrorLocation? location = null,
		IReadOnlyCollection<string>? tags = null)
	{
		ArgumentException.ThrowIfNullOrWhiteSpace(sessionId);
		ArgumentException.ThrowIfNullOrWhiteSpace(component);
		ArgumentException.ThrowIfNullOrWhiteSpace(operation);
		ArgumentException.ThrowIfNullOrWhiteSpace(errorCode);
		ArgumentException.ThrowIfNullOrWhiteSpace(message);
		ArgumentNullException.ThrowIfNull(payload);

		BsonDocument safeContext = RedactDocument(context ?? new BsonDocument());
		BsonDocument payloadData = RedactDocument(payload.ToBsonDocument());

		int originalBytes = GetBsonSize(payloadData);
		bool truncated = originalBytes > _options.MaxEvidenceBytes;
		if (truncated)
		{
			payloadData = TruncatePayload(payloadData, originalBytes, _options.MaxEvidenceBytes);
		}

		return new ErrorEvidenceDocument
		{
			CapturedAtUtc = DateTime.UtcNow,
			ExpiresAtUtc = DateTime.UtcNow.AddDays(Math.Max(1, _options.RetentionDays)),
			SessionId = sessionId,
			CorrelationId = correlationId,
			OperationId = operationId,
			Component = component,
			Operation = operation,
			Severity = severity,
			ErrorCode = errorCode,
			Message = message,
			WorkerId = TryGetWorkerId(),
			MachineName = Environment.MachineName,
			ProcessId = Environment.ProcessId,
			Tags = tags?.Where(t => !string.IsNullOrWhiteSpace(t)).Distinct(StringComparer.OrdinalIgnoreCase).ToList() ?? [],
			Location = location ?? new ErrorLocation(),
			Exception = exception is null ? null : MapException(exception),
			Context = safeContext,
			Evidence = new EvidenceEnvelope
			{
				EvidenceType = payload.EvidenceType,
				SchemaVersion = payload.Version,
				Summary = payload.Summary,
				Data = payloadData,
				IsTruncated = truncated,
				OriginalBytes = originalBytes,
			},
		};
	}

	private ErrorExceptionSnapshot MapException(Exception ex)
	{
		return new ErrorExceptionSnapshot
		{
			Type = ex.GetType().FullName ?? ex.GetType().Name,
			Message = ex.Message,
			StackTrace = _options.CaptureStack ? ex.StackTrace : null,
			Inner = ex.InnerException is null ? null : MapException(ex.InnerException),
		};
	}

	private BsonDocument RedactDocument(BsonDocument input)
	{
		BsonDocument output = [];
		foreach (BsonElement e in input)
		{
			bool redact = ShouldRedact(e.Name);
			output[e.Name] = redact ? Redacted : RedactValue(e.Name, e.Value);
		}
		return output;
	}

	private BsonValue RedactValue(string key, BsonValue value)
	{
		if (ShouldRedact(key))
		{
			return Redacted;
		}

		if (value.IsBsonDocument)
		{
			return RedactDocument(value.AsBsonDocument);
		}

		if (value.IsBsonArray)
		{
			BsonArray arr = [];
			foreach (BsonValue item in value.AsBsonArray)
			{
				arr.Add(item.IsBsonDocument ? RedactDocument(item.AsBsonDocument) : item);
			}
			return arr;
		}

		if (value.IsString)
		{
			string s = value.AsString;
			if (LooksSensitiveString(s))
			{
				return Redacted;
			}
		}

		return value;
	}

	private bool ShouldRedact(string key)
	{
		foreach (string pattern in _options.SecretKeyPatterns)
		{
			if (key.Contains(pattern, StringComparison.OrdinalIgnoreCase))
			{
				return true;
			}
		}
		return false;
	}

	private static bool LooksSensitiveString(string value)
	{
		if (string.IsNullOrWhiteSpace(value))
		{
			return false;
		}

		string lower = value.ToLowerInvariant();
		return lower.Contains("bearer ")
			|| lower.Contains("session=")
			|| lower.Contains("token=")
			|| lower.Contains("password=");
	}

	private static int GetBsonSize(BsonDocument doc)
	{
		try
		{
			return doc.ToBson().Length;
		}
		catch
		{
			return Encoding.UTF8.GetByteCount(doc.ToJson());
		}
	}

	private static BsonDocument TruncatePayload(BsonDocument original, int originalBytes, int maxBytes)
	{
		string json = original.ToJson();
		int maxChars = Math.Max(256, Math.Min(json.Length, maxBytes / 2));
		string preview = json.Length > maxChars ? json[..maxChars] + "...<truncated>" : json;

		return new BsonDocument
		{
			{ "_truncated", true },
			{ "_originalBytes", originalBytes },
			{ "_maxBytes", maxBytes },
			{ "_preview", preview },
		};
	}

	private static string? TryGetWorkerId()
	{
		try
		{
			return Thread.CurrentThread.Name;
		}
		catch
		{
			return null;
		}
	}
}
