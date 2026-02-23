using System.Collections.Concurrent;
using System.Linq;
using System.Text.Json;

namespace P4NTH30N.H4ND.Navigation;

/// <summary>
/// ARCH-098: Loads and caches NavigationMap objects from step-config JSON files.
/// Thread-safe via ConcurrentDictionary — parse once, use by all parallel workers.
/// </summary>
public sealed class NavigationMapLoader
{
	private sealed record CacheEntry(NavigationMap Map, string SourcePath, DateTime LastWriteUtc);

	private readonly ConcurrentDictionary<string, CacheEntry> _cache = new(StringComparer.OrdinalIgnoreCase);
	private readonly string _mapsDirectory;

	private static readonly JsonSerializerOptions _jsonOptions = new()
	{
		PropertyNameCaseInsensitive = true,
		ReadCommentHandling = JsonCommentHandling.Skip,
		AllowTrailingCommas = true,
	};

	/// <summary>
	/// Create a loader that reads step-config files from the specified directory.
	/// Default: H4ND/tools/recorder/ (where the recorder writes its maps).
	/// </summary>
	public NavigationMapLoader(string? mapsDirectory = null)
	{
		_mapsDirectory = mapsDirectory ?? GetDefaultMapsDirectory();
	}

	/// <summary>
	/// Load a navigation map for the given platform. Cached after first load.
	/// Tries platform-specific file first (step-config-firekirin.json), falls back to generic (step-config.json).
	/// Returns null if no map file exists (caller should fall back to hardcoded CdpGameActions).
	/// </summary>
	public NavigationMap? Load(string platform)
	{
		string key = NormalizePlatformKey(platform);
		if (string.IsNullOrWhiteSpace(key))
		{
			Console.WriteLine("[NavigationMapLoader] Platform is empty; cannot resolve map path");
			return null;
		}

		string? resolvedPath = ResolveMapPath(key);
		if (resolvedPath == null)
		{
			Console.WriteLine(
				$"[NavigationMapLoader] No map found for '{platform}' (normalized: '{key}') in {_mapsDirectory}"
			);
			return null;
		}

		DateTime lastWriteUtc = File.GetLastWriteTimeUtc(resolvedPath);

		if (_cache.TryGetValue(key, out var cached)
			&& string.Equals(cached.SourcePath, resolvedPath, StringComparison.OrdinalIgnoreCase)
			&& cached.LastWriteUtc >= lastWriteUtc)
		{
			return cached.Map;
		}

		var map = ParseFile(resolvedPath, key);
		if (map != null)
		{
			_cache[key] = new CacheEntry(map, resolvedPath, lastWriteUtc);
		}
		return map;
	}

	/// <summary>
	/// Async wrapper for Load — the actual I/O is synchronous (small JSON files).
	/// </summary>
	public Task<NavigationMap?> LoadAsync(string platform, CancellationToken ct = default)
	{
		ct.ThrowIfCancellationRequested();
		return Task.FromResult(Load(platform));
	}

	/// <summary>
	/// Invalidate cached map for a platform (e.g., after config update).
	/// </summary>
	public void InvalidateCache(string? platform = null)
	{
		if (platform != null)
		{
			string key = NormalizePlatformKey(platform);
			if (!string.IsNullOrWhiteSpace(key))
			{
				_cache.TryRemove(key, out _);
			}
		}
		else
		{
			_cache.Clear();
		}
	}

	/// <summary>
	/// Get all cached platform names.
	/// </summary>
	public IReadOnlyCollection<string> CachedPlatforms => _cache.Keys.ToList();

	private string? ResolveMapPath(string platform)
	{
		var platformSpecificNames = new List<string>();
		switch (platform)
		{
			case "firekirin":
				platformSpecificNames.Add("step-config-firekirin.json");
				break;
			case "orionstars":
				platformSpecificNames.Add("step-config-orionstars.json");
				break;
		}

		string normalizedName = $"step-config-{platform}.json";
		if (!platformSpecificNames.Contains(normalizedName, StringComparer.OrdinalIgnoreCase))
		{
			platformSpecificNames.Add(normalizedName);
		}

		foreach (string fileName in platformSpecificNames)
		{
			string specificPath = Path.Combine(_mapsDirectory, fileName);
			if (File.Exists(specificPath))
			{
				return specificPath;
			}
		}

		// Fix B: Always check absolute paths as fallback (even if _mapsDirectory is different)
		foreach (string absolutePath in GetAbsolutePlatformPaths(platform))
		{
			if (File.Exists(absolutePath))
			{
				Console.WriteLine($"[NavigationMapLoader] Resolved via absolute path: {absolutePath}");
				return absolutePath;
			}
		}

		// Fallback to generic step-config.json
		string genericPath = Path.Combine(_mapsDirectory, "step-config.json");
		if (File.Exists(genericPath))
		{
			return genericPath;
		}

		return null;
	}

	private static string NormalizePlatformKey(string? platform)
	{
		if (string.IsNullOrWhiteSpace(platform))
		{
			return string.Empty;
		}

		string compact = new string(platform.Trim().Where(char.IsLetterOrDigit).ToArray()).ToLowerInvariant();
		return compact switch
		{
			"firekirin" => "firekirin",
			"orionstars" => "orionstars",
			"orionstar" => "orionstars",
			"orion" => "orionstars",
			_ => compact,
		};
	}

	private static IEnumerable<string> GetAbsolutePlatformPaths(string platform)
	{
		yield return platform switch
		{
			"firekirin" => @"C:\P4NTH30N\H4ND\tools\recorder\step-config-firekirin.json",
			"orionstars" => @"C:\P4NTH30N\H4ND\tools\recorder\step-config-orionstars.json",
			_ => $@"C:\P4NTH30N\H4ND\tools\recorder\step-config-{platform}.json",
		};
	}

	private static NavigationMap? ParseFile(string filePath, string platform)
	{
		try
		{
			string json = File.ReadAllText(filePath);
			var map = JsonSerializer.Deserialize<NavigationMap>(json, _jsonOptions);

			if (map != null)
			{
				int enabledSteps = map.Steps.Count(s => s.Enabled);
				var phases = map.GetPhases();
				Console.WriteLine($"[NavigationMapLoader] Loaded '{platform}' from {Path.GetFileName(filePath)}: " +
					$"{enabledSteps}/{map.Steps.Count} enabled steps, phases: [{string.Join(", ", phases)}]");
			}

			return map;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[NavigationMapLoader] Failed to parse {filePath}: {ex.Message}");
			return null;
		}
	}

	private static string GetDefaultMapsDirectory()
	{
		// Walk up from current directory to find H4ND/tools/recorder
		string baseDir = AppContext.BaseDirectory;

		// Try common paths.
		// IMPORTANT: Prefer source-of-truth recorder configs in repo root over
		// copied build outputs under bin/*/tools/recorder, which can be stale.
		string[] candidates =
		[
			@"C:\P4NTH30N\H4ND\tools\recorder",
			Path.Combine(baseDir, "tools", "recorder"),
			Path.Combine(baseDir, "..", "tools", "recorder"),
			Path.Combine(baseDir, "..", "..", "tools", "recorder"),
			Path.Combine(baseDir, "..", "..", "..", "H4ND", "tools", "recorder"),
			Path.Combine(baseDir, "..", "..", "..", "..", "H4ND", "tools", "recorder"),
		];

		foreach (string candidate in candidates)
		{
			string resolved = Path.GetFullPath(candidate);

			// Build output mirrors (bin/*/tools/recorder) are convenient fallbacks
			// but should never override live recorder edits in repo root.
			if (resolved.Contains($"{Path.DirectorySeparatorChar}bin{Path.DirectorySeparatorChar}", StringComparison.OrdinalIgnoreCase))
			{
				continue;
			}

			// Fix A: Check for actual config files, not just directory existence
			if (Directory.Exists(resolved) && DirectoryContainsJsonFiles(resolved))
			{
				Console.WriteLine($"[NavigationMapLoader] Selected maps directory: {resolved}");
				return resolved;
			}
		}

		// Fix D: Warning when no config directory found
		Console.WriteLine("[NavigationMapLoader] WARNING: No maps directory with configs found");
		// Default fallback — will cause file-not-found gracefully
		return Path.Combine(baseDir, "navigation-maps");
	}

	private static bool DirectoryContainsJsonFiles(string directory)
	{
		try
		{
			return Directory.EnumerateFiles(directory, "*.json").Any();
		}
		catch
		{
			return false;
		}
	}
}
