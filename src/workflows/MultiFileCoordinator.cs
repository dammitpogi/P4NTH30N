using System.Collections.Concurrent;

namespace P4NTH30N.SWE.Workflows;

/// <summary>
/// Coordinates 5-7 file edits per turn with cross-reference validation,
/// consistency checking, and file locking to prevent race conditions.
/// </summary>
public sealed class MultiFileCoordinator {
	private readonly ConcurrentDictionary<string, SemaphoreSlim> _fileLocks = new();
	private readonly MultiFileConfig _config;
	private readonly List<FileEdit> _pendingEdits = new();
	private readonly List<FileEditResult> _completedEdits = new();

	public MultiFileCoordinator(MultiFileConfig? config = null) {
		_config = config ?? new MultiFileConfig();
	}

	/// <summary>
	/// Queues a file edit for coordinated execution.
	/// </summary>
	public void QueueEdit(FileEdit edit) {
		if (_pendingEdits.Count >= _config.MaxEditsPerTurn) {
			throw new InvalidOperationException(
				$"Maximum edits per turn ({_config.MaxEditsPerTurn}) exceeded. " +
				"Flush current batch before adding more.");
		}
		_pendingEdits.Add(edit);
	}

	/// <summary>
	/// Executes all queued edits with file locking and consistency validation.
	/// </summary>
	public async Task<CoordinationResult> FlushAsync(CancellationToken cancellationToken = default) {
		CoordinationResult result = new() {
			BatchId = Guid.NewGuid().ToString("N")[..8],
			TotalEdits = _pendingEdits.Count,
		};

		// Pre-flight: cross-reference validation
		List<string> validationErrors = ValidateCrossReferences(_pendingEdits);
		if (validationErrors.Count > 0) {
			result.ValidationErrors = validationErrors;
			result.Status = CoordinationStatus.ValidationFailed;
			return result;
		}

		// Execute edits with file locking
		foreach (FileEdit edit in _pendingEdits) {
			cancellationToken.ThrowIfCancellationRequested();

			SemaphoreSlim fileLock = _fileLocks.GetOrAdd(
				NormalizePath(edit.FilePath),
				_ => new SemaphoreSlim(1, 1));

			await fileLock.WaitAsync(cancellationToken);
			try {
				FileEditResult editResult = await ExecuteEditAsync(edit, cancellationToken);
				_completedEdits.Add(editResult);
				result.EditResults.Add(editResult);
			}
			finally {
				fileLock.Release();
			}
		}

		// Post-flight: consistency check
		List<string> consistencyErrors = CheckConsistency(_completedEdits);
		result.ConsistencyErrors = consistencyErrors;

		result.SucceededCount = result.EditResults.Count(r => r.Succeeded);
		result.FailedCount = result.EditResults.Count(r => !r.Succeeded);
		result.Status = result.FailedCount == 0 && consistencyErrors.Count == 0
			? CoordinationStatus.Succeeded
			: CoordinationStatus.PartialFailure;

		_pendingEdits.Clear();

		return result;
	}

	/// <summary>
	/// Validates cross-references between pending edits.
	/// Ensures edits don't conflict (e.g., two edits to same line range).
	/// </summary>
	public static List<string> ValidateCrossReferences(List<FileEdit> edits) {
		List<string> errors = new();

		// Check for duplicate file+range conflicts
		IEnumerable<IGrouping<string, FileEdit>> groupedByFile = edits.GroupBy(e => NormalizePath(e.FilePath));
		foreach (IGrouping<string, FileEdit> group in groupedByFile) {
			List<FileEdit> fileEdits = group.ToList();
			if (fileEdits.Count <= 1) continue;

			for (int i = 0; i < fileEdits.Count; i++) {
				for (int j = i + 1; j < fileEdits.Count; j++) {
					if (RangesOverlap(fileEdits[i], fileEdits[j])) {
						errors.Add(
							$"Conflicting edits on {fileEdits[i].FilePath}: " +
							$"edit '{fileEdits[i].Description}' overlaps with '{fileEdits[j].Description}'");
					}
				}
			}
		}

		// Check for circular references (edit A references file from edit B and vice versa)
		foreach (FileEdit edit in edits) {
			foreach (string refPath in edit.ReferencedFiles) {
				FileEdit? conflicting = edits.FirstOrDefault(e =>
					NormalizePath(e.FilePath) == NormalizePath(refPath) &&
					e.ReferencedFiles.Any(r => NormalizePath(r) == NormalizePath(edit.FilePath)));

				if (conflicting != null) {
					errors.Add(
						$"Circular reference between {edit.FilePath} and {conflicting.FilePath}");
				}
			}
		}

		return errors;
	}

	/// <summary>
	/// Checks consistency of completed edits (e.g., namespace references, using directives).
	/// </summary>
	public static List<string> CheckConsistency(List<FileEditResult> results) {
		List<string> errors = new();

		List<FileEditResult> succeeded = results.Where(r => r.Succeeded).ToList();

		// Check that new files referenced by other edits were actually created
		foreach (FileEditResult result in succeeded) {
			foreach (string dep in result.Edit.ReferencedFiles) {
				bool depExists = succeeded.Any(r =>
					NormalizePath(r.Edit.FilePath) == NormalizePath(dep));
				bool fileExists = File.Exists(dep);

				if (!depExists && !fileExists) {
					errors.Add($"Referenced file {dep} was not created or modified in this batch");
				}
			}
		}

		return errors;
	}

	private static async Task<FileEditResult> ExecuteEditAsync(
		FileEdit edit,
		CancellationToken cancellationToken) {
		try {
			switch (edit.Type) {
				case EditType.Create:
					string? dir = Path.GetDirectoryName(edit.FilePath);
					if (dir != null && !Directory.Exists(dir)) {
						Directory.CreateDirectory(dir);
					}
					await File.WriteAllTextAsync(edit.FilePath, edit.NewContent ?? "", cancellationToken);
					break;

				case EditType.Replace:
					if (!File.Exists(edit.FilePath)) {
						return new FileEditResult {
							Edit = edit,
							Succeeded = false,
							Error = $"File not found: {edit.FilePath}",
						};
					}
					string content = await File.ReadAllTextAsync(edit.FilePath, cancellationToken);
					if (edit.OldContent != null && !content.Contains(edit.OldContent)) {
						return new FileEditResult {
							Edit = edit,
							Succeeded = false,
							Error = "Old content not found in file",
						};
					}
					if (edit.OldContent != null && edit.NewContent != null) {
						content = content.Replace(edit.OldContent, edit.NewContent);
					}
					await File.WriteAllTextAsync(edit.FilePath, content, cancellationToken);
					break;

				case EditType.Append:
					await File.AppendAllTextAsync(edit.FilePath, edit.NewContent ?? "", cancellationToken);
					break;
			}

			return new FileEditResult {
				Edit = edit,
				Succeeded = true,
			};
		}
		catch (Exception ex) {
			return new FileEditResult {
				Edit = edit,
				Succeeded = false,
				Error = ex.Message,
			};
		}
	}

	private static bool RangesOverlap(FileEdit a, FileEdit b) {
		if (a.StartLine == 0 || b.StartLine == 0) return false;
		return a.StartLine <= b.EndLine && b.StartLine <= a.EndLine;
	}

	private static string NormalizePath(string path) {
		return Path.GetFullPath(path).ToLowerInvariant().Replace('/', '\\');
	}
}

/// <summary>
/// Configuration for multi-file coordination.
/// </summary>
public sealed class MultiFileConfig {
	public int MaxEditsPerTurn { get; init; } = 7;
	public int MaxFilesPerTurn { get; init; } = 7;
	public bool EnableFileLocking { get; init; } = true;
}

/// <summary>
/// Represents a single file edit operation.
/// </summary>
public sealed class FileEdit {
	public string FilePath { get; init; } = string.Empty;
	public EditType Type { get; init; }
	public string? OldContent { get; init; }
	public string? NewContent { get; init; }
	public string Description { get; init; } = string.Empty;
	public int StartLine { get; init; }
	public int EndLine { get; init; }
	public List<string> ReferencedFiles { get; init; } = new();
}

/// <summary>
/// Result of a single file edit.
/// </summary>
public sealed class FileEditResult {
	public FileEdit Edit { get; init; } = new();
	public bool Succeeded { get; init; }
	public string? Error { get; init; }
}

/// <summary>
/// Aggregated result of a coordinated edit batch.
/// </summary>
public sealed class CoordinationResult {
	public string BatchId { get; init; } = string.Empty;
	public int TotalEdits { get; init; }
	public int SucceededCount { get; set; }
	public int FailedCount { get; set; }
	public CoordinationStatus Status { get; set; }
	public List<string> ValidationErrors { get; set; } = new();
	public List<string> ConsistencyErrors { get; set; } = new();
	public List<FileEditResult> EditResults { get; } = new();
}

public enum EditType { Create, Replace, Append }
public enum CoordinationStatus { Succeeded, PartialFailure, ValidationFailed }
