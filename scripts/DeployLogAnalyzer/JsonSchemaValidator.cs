using System.Diagnostics;
using System.Reflection;
using System.Text.Json;
using NJsonSchema;
using NJsonSchema.Validation;

namespace P4NTHE0N.DeployLogAnalyzer;

/// <summary>
/// Deterministic JSON Schema validator for credential configurations.
/// ARCH-003-PIVOT Stage 1: Handles structure, types, required fields, patterns, and ranges.
/// Performance target: &lt;5ms per validation.
/// </summary>
public sealed class JsonSchemaValidator
{
	private JsonSchema? _schema;
	private bool _initialized;

	/// <summary>
	/// Loads the JSON Schema from the embedded schemas/credential.json file.
	/// Must be called before Validate(). Safe for repeated calls.
	/// </summary>
	public async Task InitializeAsync(CancellationToken cancellationToken = default)
	{
		if (_initialized)
			return;

		string schemaPath = FindSchemaPath();
		string schemaJson = await File.ReadAllTextAsync(schemaPath, cancellationToken);
		_schema = await JsonSchema.FromJsonAsync(schemaJson, cancellationToken);
		_initialized = true;
	}

	/// <summary>
	/// Initializes from a schema JSON string directly (for testing).
	/// </summary>
	public async Task InitializeFromJsonAsync(string schemaJson, CancellationToken cancellationToken = default)
	{
		_schema = await JsonSchema.FromJsonAsync(schemaJson, cancellationToken);
		_initialized = true;
	}

	/// <summary>
	/// Validates a configuration JSON string against the credential schema.
	/// Returns structured validation result with all errors.
	/// </summary>
	public SchemaValidationOutput Validate(string configJson)
	{
		if (!_initialized)
		{
			throw new InvalidOperationException("JsonSchemaValidator not initialized. Call InitializeAsync() first.");
		}

		Stopwatch sw = Stopwatch.StartNew();

		try
		{
			ICollection<ValidationError> errors = _schema!.Validate(configJson);
			sw.Stop();

			if (errors.Count == 0)
			{
				return new SchemaValidationOutput
				{
					IsValid = true,
					Errors = new List<SchemaError>(),
					LatencyMs = sw.ElapsedMilliseconds,
				};
			}

			List<SchemaError> schemaErrors = errors
				.Select(e => new SchemaError
				{
					Property = e.Property ?? string.Empty,
					Path = e.Path ?? string.Empty,
					Kind = e.Kind.ToString(),
					Message = FormatValidationError(e),
				})
				.ToList();

			return new SchemaValidationOutput
			{
				IsValid = false,
				Errors = schemaErrors,
				LatencyMs = sw.ElapsedMilliseconds,
			};
		}
		catch (Exception ex) when (ex is JsonException || ex is Newtonsoft.Json.JsonException)
		{
			sw.Stop();
			return new SchemaValidationOutput
			{
				IsValid = false,
				Errors = new List<SchemaError>
				{
					new()
					{
						Property = string.Empty,
						Path = "#",
						Kind = "JsonParseError",
						Message = $"Invalid JSON: {ex.Message}",
					},
				},
				LatencyMs = sw.ElapsedMilliseconds,
			};
		}
	}

	private static string FormatValidationError(ValidationError error)
	{
		return error.Kind switch
		{
			ValidationErrorKind.StringTooShort => $"String too short at '{error.Property}' (minimum length required)",
			ValidationErrorKind.StringTooLong => $"String too long at '{error.Property}'",
			ValidationErrorKind.PatternMismatch => $"Pattern mismatch at '{error.Property}': value does not match required pattern",
			ValidationErrorKind.NotInEnumeration => $"Invalid value at '{error.Property}': must be one of the allowed values",
			ValidationErrorKind.PropertyRequired => $"Missing required property: '{error.Property}'",
			ValidationErrorKind.NumberTooSmall => $"Value too small at '{error.Property}'",
			ValidationErrorKind.NumberTooBig => $"Value too large at '{error.Property}'",
			ValidationErrorKind.IntegerExpected => $"Integer expected at '{error.Property}'",
			ValidationErrorKind.NumberExpected => $"Number expected at '{error.Property}'",
			ValidationErrorKind.StringExpected => $"String expected at '{error.Property}'",
			ValidationErrorKind.BooleanExpected => $"Boolean expected at '{error.Property}'",
			ValidationErrorKind.ObjectExpected => $"Object expected at '{error.Property}'",
			_ => $"Validation error at '{error.Property}': {error.Kind}",
		};
	}

	private static string FindSchemaPath()
	{
		// Try relative to executing assembly
		string? assemblyDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
		if (assemblyDir != null)
		{
			string path = Path.Combine(assemblyDir, "schemas", "credential.json");
			if (File.Exists(path))
				return path;
		}

		// Try relative to current directory
		string cwdPath = Path.Combine(Directory.GetCurrentDirectory(), "schemas", "credential.json");
		if (File.Exists(cwdPath))
			return cwdPath;

		// Try relative to project structure
		string projectPath = Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "schemas", "credential.json");
		if (File.Exists(projectPath))
			return projectPath;

		// Try absolute known path
		string absolutePath = @"C:\P4NTHE0N\scripts\DeployLogAnalyzer\schemas\credential.json";
		if (File.Exists(absolutePath))
			return absolutePath;

		throw new FileNotFoundException("Could not find schemas/credential.json. Ensure the schema file is deployed alongside the application.");
	}
}

/// <summary>
/// Result of JSON Schema validation.
/// </summary>
public sealed class SchemaValidationOutput
{
	public bool IsValid { get; init; }
	public List<SchemaError> Errors { get; init; } = new();
	public long LatencyMs { get; init; }

	/// <summary>
	/// Returns a flat list of error messages for logging.
	/// </summary>
	public IReadOnlyList<string> GetErrorMessages() => Errors.Select(e => e.Message).ToList().AsReadOnly();
}

/// <summary>
/// Individual schema validation error with path and kind.
/// </summary>
public sealed class SchemaError
{
	public string Property { get; init; } = string.Empty;
	public string Path { get; init; } = string.Empty;
	public string Kind { get; init; } = string.Empty;
	public string Message { get; init; } = string.Empty;
}
