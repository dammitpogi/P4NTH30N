using System.Text.RegularExpressions;

namespace P4NTH30N.SWE.Validation;

/// <summary>
/// Validates generated C# code against P4NTH30N standards.
/// Enforces size limits, syntax rules, naming conventions, and C# 12 feature usage.
/// </summary>
public sealed class CodeGenerationValidator
{
	private readonly ValidationConfig _config;

	public CodeGenerationValidator(ValidationConfig? config = null)
	{
		_config = config ?? new ValidationConfig();
	}

	/// <summary>
	/// Validates a C# source file against all configured rules.
	/// </summary>
	public CodeValidationResult Validate(string sourceCode, string fileName = "")
	{
		CodeValidationResult result = new() { FileName = fileName };

		// Size checks
		ValidateSize(sourceCode, result);

		// Naming conventions
		ValidateNaming(sourceCode, result);

		// C# 12 feature detection
		DetectModernFeatures(sourceCode, result);

		// Complexity analysis
		AnalyzeComplexity(sourceCode, result);

		// Style checks
		ValidateStyle(sourceCode, result);

		result.IsValid = result.Errors.Count == 0;

		return result;
	}

	/// <summary>
	/// Checks line count and method size limits.
	/// </summary>
	public void ValidateSize(string sourceCode, CodeValidationResult result)
	{
		string[] lines = sourceCode.Split('\n');
		result.TotalLines = lines.Length;

		if (lines.Length > _config.MaxClassLines)
		{
			result.AddError($"File exceeds {_config.MaxClassLines} lines ({lines.Length} lines)");
		}

		// Check individual method sizes
		int methodStartLine = -1;
		string currentMethod = "";
		int braceDepth = 0;
		bool inMethod = false;

		for (int i = 0; i < lines.Length; i++)
		{
			string line = lines[i].Trim();

			if (!inMethod && IsMethodSignature(line))
			{
				methodStartLine = i + 1;
				currentMethod = ExtractMethodName(line);
				inMethod = true;
				braceDepth = 0;
			}

			if (inMethod)
			{
				braceDepth += line.Count(c => c == '{') - line.Count(c => c == '}');
				if (braceDepth <= 0 && methodStartLine > 0)
				{
					int methodLines = (i + 1) - methodStartLine;
					if (methodLines > _config.MaxMethodLines)
					{
						result.AddWarning($"Method '{currentMethod}' at line {methodStartLine} is {methodLines} lines " + $"(max {_config.MaxMethodLines})");
					}
					inMethod = false;
				}
			}
		}

		// Check for lines exceeding max length
		for (int i = 0; i < lines.Length; i++)
		{
			if (lines[i].TrimEnd().Length > _config.MaxLineLength)
			{
				result.AddWarning($"Line {i + 1} exceeds {_config.MaxLineLength} characters");
			}
		}
	}

	/// <summary>
	/// Validates naming conventions (PascalCase for publics, _camelCase for privates).
	/// </summary>
	public static void ValidateNaming(string sourceCode, CodeValidationResult result)
	{
		// Check private field naming (_camelCase)
		MatchCollection privateFields = Regex.Matches(sourceCode, @"private\s+(?:readonly\s+)?(?:\w+)\s+(\w+)\s*[;=]");
		foreach (Match match in privateFields)
		{
			string fieldName = match.Groups[1].Value;
			if (!fieldName.StartsWith('_') && !fieldName.StartsWith("s_"))
			{
				result.AddWarning($"Private field '{fieldName}' should use _camelCase naming");
			}
		}

		// Check public method naming (PascalCase)
		MatchCollection publicMethods = Regex.Matches(sourceCode, @"public\s+(?:static\s+)?(?:async\s+)?(?:\w+(?:<[^>]+>)?)\s+(\w+)\s*\(");
		foreach (Match match in publicMethods)
		{
			string methodName = match.Groups[1].Value;
			if (methodName.Length > 0 && char.IsLower(methodName[0]))
			{
				result.AddWarning($"Public method '{methodName}' should use PascalCase naming");
			}
		}
	}

	/// <summary>
	/// Detects usage of modern C# 12 features.
	/// </summary>
	public static void DetectModernFeatures(string sourceCode, CodeValidationResult result)
	{
		// File-scoped namespaces
		if (Regex.IsMatch(sourceCode, @"^namespace\s+[\w.]+;", RegexOptions.Multiline))
		{
			result.ModernFeatures.Add("file_scoped_namespace");
		}

		// Primary constructors
		if (Regex.IsMatch(sourceCode, @"(?:class|struct|record)\s+\w+\s*\([^)]+\)\s*(?::|{|where)"))
		{
			result.ModernFeatures.Add("primary_constructor");
		}

		// Pattern matching
		if (sourceCode.Contains(" is ") && Regex.IsMatch(sourceCode, @"\bis\s+\w+\s+\w+"))
		{
			result.ModernFeatures.Add("pattern_matching");
		}

		// Null propagation
		if (sourceCode.Contains("?."))
		{
			result.ModernFeatures.Add("null_propagation");
		}

		// Expression-bodied members
		if (Regex.IsMatch(sourceCode, @"=>\s*[^{].*;"))
		{
			result.ModernFeatures.Add("expression_bodied");
		}

		// Raw string literals
		if (sourceCode.Contains("\"\"\""))
		{
			result.ModernFeatures.Add("raw_string_literal");
		}

		// Collection expressions
		if (Regex.IsMatch(sourceCode, @"\[\s*\w"))
		{
			result.ModernFeatures.Add("collection_expression");
		}
	}

	/// <summary>
	/// Analyzes code complexity (nesting depth, cyclomatic complexity estimate).
	/// </summary>
	public void AnalyzeComplexity(string sourceCode, CodeValidationResult result)
	{
		string[] lines = sourceCode.Split('\n');
		int maxNesting = 0;
		int currentNesting = 0;
		int branchPoints = 0;

		foreach (string rawLine in lines)
		{
			string line = rawLine.Trim();

			currentNesting += line.Count(c => c == '{');
			currentNesting -= line.Count(c => c == '}');

			if (currentNesting > maxNesting)
			{
				maxNesting = currentNesting;
			}

			// Count branch points for cyclomatic complexity
			if (Regex.IsMatch(line, @"\b(if|else if|switch|case|for|foreach|while|do|catch|&&|\|\|)\b"))
			{
				branchPoints++;
			}
		}

		result.MaxNestingDepth = maxNesting;
		result.EstimatedCyclomaticComplexity = branchPoints + 1;

		if (maxNesting > _config.MaxNestingDepth)
		{
			result.AddWarning($"Max nesting depth {maxNesting} exceeds limit ({_config.MaxNestingDepth})");
		}

		if (result.EstimatedCyclomaticComplexity > _config.MaxCyclomaticComplexity)
		{
			result.AddWarning($"Estimated cyclomatic complexity {result.EstimatedCyclomaticComplexity} " + $"exceeds limit ({_config.MaxCyclomaticComplexity})");
		}
	}

	/// <summary>
	/// Validates code style (var usage, using directives, etc.).
	/// </summary>
	public static void ValidateStyle(string sourceCode, CodeValidationResult result)
	{
		// Check for var usage (P4NTH30N prefers explicit types)
		MatchCollection varUsages = Regex.Matches(sourceCode, @"\bvar\s+\w+\s*=");
		if (varUsages.Count > 0)
		{
			result.AddInfo($"Found {varUsages.Count} 'var' usage(s) - P4NTH30N prefers explicit types");
		}

		// Check using directives are at top
		string[] lines = sourceCode.Split('\n');
		bool pastUsings = false;
		for (int i = 0; i < lines.Length; i++)
		{
			string line = lines[i].Trim();

			if (line.StartsWith("using ") && !line.Contains('('))
			{
				if (pastUsings)
				{
					result.AddWarning($"Using directive at line {i + 1} should be at the top of the file");
				}
			}
			else if (!string.IsNullOrWhiteSpace(line) && !line.StartsWith("//") && !line.StartsWith("#"))
			{
				pastUsings = true;
			}
		}
	}

	private static bool IsMethodSignature(string line)
	{
		return Regex.IsMatch(line, @"(public|private|protected|internal)\s+(static\s+)?(async\s+)?(override\s+)?\w+.*\(.*\)\s*\{?$");
	}

	private static string ExtractMethodName(string line)
	{
		Match match = Regex.Match(line, @"(\w+)\s*\(");
		return match.Success ? match.Groups[1].Value : "unknown";
	}
}

/// <summary>
/// Configuration for code validation rules.
/// </summary>
public sealed class ValidationConfig
{
	public int MaxClassLines { get; init; } = 800;
	public int MaxMethodLines { get; init; } = 50;
	public int MaxLineLength { get; init; } = 170;
	public int MaxNestingDepth { get; init; } = 5;
	public int MaxCyclomaticComplexity { get; init; } = 20;
}

/// <summary>
/// Result of code validation.
/// </summary>
public sealed class CodeValidationResult
{
	public string FileName { get; init; } = string.Empty;
	public bool IsValid { get; set; }
	public int TotalLines { get; set; }
	public int MaxNestingDepth { get; set; }
	public int EstimatedCyclomaticComplexity { get; set; }
	public List<string> Errors { get; } = new();
	public List<string> Warnings { get; } = new();
	public List<string> Info { get; } = new();
	public List<string> ModernFeatures { get; } = new();

	public void AddError(string message) => Errors.Add(message);

	public void AddWarning(string message) => Warnings.Add(message);

	public void AddInfo(string message) => Info.Add(message);
}
