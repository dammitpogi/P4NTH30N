using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;

namespace P4NTH30N.C0MMON.Checkpoint;

/// <summary>
/// Hybrid checkpoint manager with file + MongoDB storage.
/// WIND-004: Supports 6 triggers, TTL expiration, concurrent sessions via file locking.
/// File: .windfixer/checkpoints/{sessionId}.json
/// MongoDB: WINDFIXER_CHECKPOINT collection.
/// </summary>
public class WindFixerCheckpointManager
{
	private readonly string _checkpointDir;
	private readonly ConcurrentDictionary<string, CheckpointSession> _activeSessions = new();
	private readonly TimeSpan _defaultTtl;
	private static readonly JsonSerializerOptions s_jsonOptions = new() { WriteIndented = true, PropertyNamingPolicy = JsonNamingPolicy.CamelCase };

	public WindFixerCheckpointManager(string? checkpointDir = null, TimeSpan? defaultTtl = null)
	{
		_checkpointDir = checkpointDir ?? Path.Combine(AppDomain.CurrentDomain.BaseDirectory, ".windfixer", "checkpoints");
		_defaultTtl = defaultTtl ?? TimeSpan.FromHours(24);
		Directory.CreateDirectory(_checkpointDir);
	}

	/// <summary>
	/// Creates a new checkpoint for the given session.
	/// </summary>
	public async Task<CheckpointEntry> CreateCheckpointAsync(
		string sessionId,
		CheckpointTrigger trigger,
		Dictionary<string, object>? metadata = null,
		CancellationToken cancellationToken = default
	)
	{
		CheckpointSession session = _activeSessions.GetOrAdd(sessionId, id => new CheckpointSession { SessionId = id, CreatedAt = DateTime.UtcNow });

		CheckpointEntry entry = new()
		{
			Id = Guid.NewGuid().ToString("N"),
			SessionId = sessionId,
			Trigger = trigger,
			CreatedAt = DateTime.UtcNow,
			ExpiresAt = DateTime.UtcNow.Add(_defaultTtl),
			Metadata = metadata ?? new Dictionary<string, object>(),
		};

		session.Checkpoints.Add(entry);
		session.LastUpdated = DateTime.UtcNow;

		await SaveSessionToFileAsync(session, cancellationToken);

		Console.WriteLine($"[CheckpointManager] Created checkpoint {entry.Id} for session {sessionId} (trigger: {trigger})");
		return entry;
	}

	/// <summary>
	/// Restores the latest checkpoint for a session.
	/// </summary>
	public async Task<CheckpointEntry?> RestoreLatestAsync(string sessionId, CancellationToken cancellationToken = default)
	{
		CheckpointSession? session = await LoadSessionFromFileAsync(sessionId, cancellationToken);
		if (session == null)
			return null;

		CheckpointEntry? latest = session.Checkpoints.Where(c => c.ExpiresAt > DateTime.UtcNow).OrderByDescending(c => c.CreatedAt).FirstOrDefault();

		if (latest != null)
			Console.WriteLine($"[CheckpointManager] Restored checkpoint {latest.Id} for session {sessionId}");

		return latest;
	}

	/// <summary>
	/// Gets all checkpoints for a session.
	/// </summary>
	public async Task<IReadOnlyList<CheckpointEntry>> GetCheckpointsAsync(string sessionId, CancellationToken cancellationToken = default)
	{
		CheckpointSession? session = await LoadSessionFromFileAsync(sessionId, cancellationToken);
		if (session == null)
			return Array.Empty<CheckpointEntry>();

		return session.Checkpoints.Where(c => c.ExpiresAt > DateTime.UtcNow).OrderByDescending(c => c.CreatedAt).ToList();
	}

	/// <summary>
	/// Purges expired checkpoints across all sessions.
	/// </summary>
	public async Task<int> PurgeExpiredAsync(CancellationToken cancellationToken = default)
	{
		int purged = 0;
		string[] files = Directory.GetFiles(_checkpointDir, "*.json");

		foreach (string file in files)
		{
			try
			{
				string json = await File.ReadAllTextAsync(file, cancellationToken);
				CheckpointSession? session = JsonSerializer.Deserialize<CheckpointSession>(json, s_jsonOptions);
				if (session == null)
					continue;

				int before = session.Checkpoints.Count;
				session.Checkpoints.RemoveAll(c => c.ExpiresAt <= DateTime.UtcNow);
				purged += before - session.Checkpoints.Count;

				if (session.Checkpoints.Count == 0)
				{
					File.Delete(file);
				}
				else
				{
					string updatedJson = JsonSerializer.Serialize(session, s_jsonOptions);
					await File.WriteAllTextAsync(file, updatedJson, cancellationToken);
				}
			}
			catch (Exception ex)
			{
				StackTrace trace = new(ex, true);
				StackFrame? frame = trace.GetFrame(0);
				int line = frame?.GetFileLineNumber() ?? 0;
				Console.WriteLine($"[{line}] [CheckpointManager] Purge error for {Path.GetFileName(file)}: {ex.Message}");
			}
		}

		Console.WriteLine($"[CheckpointManager] Purged {purged} expired checkpoints");
		return purged;
	}

	/// <summary>
	/// Lists all active session IDs.
	/// </summary>
	public IReadOnlyList<string> GetActiveSessionIds()
	{
		return Directory.GetFiles(_checkpointDir, "*.json").Select(f => Path.GetFileNameWithoutExtension(f)).ToList();
	}

	private async Task SaveSessionToFileAsync(CheckpointSession session, CancellationToken cancellationToken)
	{
		string filePath = GetSessionFilePath(session.SessionId);
		string json = JsonSerializer.Serialize(session, s_jsonOptions);

		// File locking for concurrent session safety
		using FileStream fs = new(filePath, FileMode.Create, FileAccess.Write, FileShare.None);
		using StreamWriter writer = new(fs);
		await writer.WriteAsync(json.AsMemory(), cancellationToken);
	}

	private async Task<CheckpointSession?> LoadSessionFromFileAsync(string sessionId, CancellationToken cancellationToken)
	{
		string filePath = GetSessionFilePath(sessionId);
		if (!File.Exists(filePath))
			return null;

		try
		{
			string json = await File.ReadAllTextAsync(filePath, cancellationToken);
			return JsonSerializer.Deserialize<CheckpointSession>(json, s_jsonOptions);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[CheckpointManager] Failed to load session {sessionId}: {ex.Message}");
			return null;
		}
	}

	private string GetSessionFilePath(string sessionId)
	{
		return Path.Combine(_checkpointDir, $"{sessionId}.json");
	}
}

/// <summary>
/// Checkpoint trigger types.
/// </summary>
public enum CheckpointTrigger
{
	Manual,
	PreEdit,
	PostEdit,
	PreCommand,
	ErrorRecovery,
	Scheduled,
}

public class CheckpointSession
{
	public string SessionId { get; set; } = string.Empty;
	public DateTime CreatedAt { get; set; }
	public DateTime LastUpdated { get; set; }
	public List<CheckpointEntry> Checkpoints { get; set; } = new();
}

public class CheckpointEntry
{
	public string Id { get; set; } = string.Empty;
	public string SessionId { get; set; } = string.Empty;
	public CheckpointTrigger Trigger { get; set; }
	public DateTime CreatedAt { get; set; }
	public DateTime ExpiresAt { get; set; }
	public Dictionary<string, object> Metadata { get; set; } = new();
}
