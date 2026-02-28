using System.Text.Json;
using P4NTHE0N.C0MMON.Security;

namespace P4NTHE0N.C0MMON.Infrastructure.Configuration;

/// <summary>
/// Provides encrypted secrets storage for local development and production use.
/// Secrets are stored in a JSON file with values encrypted via INFRA-009 EncryptionService.
/// </summary>
/// <remarks>
/// DESIGN: Two-tier secrets approach:
/// - Development: Local encrypted JSON file (secrets.enc.json)
/// - Production: Same mechanism, with master key on a secured server
///
/// Secrets file format:
/// {
///   "Database:ConnectionString": "nonce:ciphertext:tag",
///   "Casino:Password": "nonce:ciphertext:tag"
/// }
///
/// DECISION: Using local encrypted file rather than Azure Key Vault for zero recurring cost.
/// Migration to Azure Key Vault is planned post-revenue (see INFRA-009 roadmap).
/// </remarks>
public sealed class SecretsProvider
{
	/// <summary>
	/// Default secrets file name.
	/// </summary>
	private const string DefaultSecretsFileName = "secrets.enc.json";

	/// <summary>
	/// The encryption service for decrypting secret values.
	/// </summary>
	private readonly IEncryptionService _encryption;

	/// <summary>
	/// Path to the encrypted secrets file.
	/// </summary>
	private readonly string _secretsFilePath;

	/// <summary>
	/// In-memory cache of decrypted secrets (cleared on disposal).
	/// </summary>
	private Dictionary<string, string>? _decryptedCache;

	/// <summary>
	/// Raw encrypted values from the secrets file.
	/// </summary>
	private Dictionary<string, string>? _encryptedValues;

	/// <summary>
	/// Creates a SecretsProvider instance.
	/// </summary>
	/// <param name="encryption">Initialized encryption service (INFRA-009).</param>
	/// <param name="secretsFilePath">Path to the encrypted secrets file. Defaults to secrets.enc.json in app directory.</param>
	public SecretsProvider(IEncryptionService encryption, string? secretsFilePath = null)
	{
		_encryption = encryption ?? throw new ArgumentNullException(nameof(encryption));
		_secretsFilePath = secretsFilePath ?? Path.Combine(AppContext.BaseDirectory, DefaultSecretsFileName);
	}

	/// <summary>
	/// Loads the encrypted secrets file into memory.
	/// Does not decrypt values until they are requested.
	/// </summary>
	/// <returns>True if the secrets file was loaded, false if it doesn't exist.</returns>
	public bool Load()
	{
		if (!File.Exists(_secretsFilePath))
		{
			Console.WriteLine($"[SecretsProvider] No secrets file found at: {_secretsFilePath}");
			return false;
		}

		try
		{
			string json = File.ReadAllText(_secretsFilePath);
			JsonSerializerOptions jsonOptions = new() { PropertyNameCaseInsensitive = true, ReadCommentHandling = JsonCommentHandling.Skip };
			_encryptedValues = JsonSerializer.Deserialize<Dictionary<string, string>>(json, jsonOptions) ?? new Dictionary<string, string>();
			_decryptedCache = new Dictionary<string, string>();

			Console.WriteLine($"[SecretsProvider] Loaded {_encryptedValues.Count} encrypted secrets.");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SecretsProvider] Failed to load secrets: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Retrieves a decrypted secret by key. Results are cached in memory.
	/// </summary>
	/// <param name="key">The secret key (e.g., "Database:ConnectionString").</param>
	/// <returns>The decrypted secret value, or null if the key is not found.</returns>
	public string? GetSecret(string key)
	{
		if (string.IsNullOrWhiteSpace(key))
			return null;

		// Check decrypted cache first
		if (_decryptedCache is not null && _decryptedCache.TryGetValue(key, out string? cached))
			return cached;

		// Decrypt from encrypted values
		if (_encryptedValues is null || !_encryptedValues.TryGetValue(key, out string? encryptedValue))
			return null;

		if (!_encryption.IsInitialized)
		{
			Console.WriteLine("[SecretsProvider] Cannot decrypt: encryption service not initialized.");
			return null;
		}

		try
		{
			string decrypted = _encryption.DecryptFromString(encryptedValue);
			_decryptedCache ??= new Dictionary<string, string>();
			_decryptedCache[key] = decrypted;
			return decrypted;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SecretsProvider] Failed to decrypt secret '{key}': {ex.Message}");
			return null;
		}
	}

	/// <summary>
	/// Sets or updates an encrypted secret. Persists to disk immediately.
	/// </summary>
	/// <param name="key">The secret key.</param>
	/// <param name="plaintext">The plaintext secret value to encrypt and store.</param>
	public void SetSecret(string key, string plaintext)
	{
		if (string.IsNullOrWhiteSpace(key))
			throw new ArgumentException("Secret key cannot be null or empty.", nameof(key));
		if (string.IsNullOrEmpty(plaintext))
			throw new ArgumentException("Secret value cannot be null or empty.", nameof(plaintext));

		if (!_encryption.IsInitialized)
			throw new InvalidOperationException("Encryption service must be initialized before setting secrets.");

		_encryptedValues ??= new Dictionary<string, string>();
		_decryptedCache ??= new Dictionary<string, string>();

		// Encrypt and store
		string encrypted = _encryption.EncryptToString(plaintext);
		_encryptedValues[key] = encrypted;
		_decryptedCache[key] = plaintext;

		// Persist to disk
		SaveToDisk();
	}

	/// <summary>
	/// Removes a secret by key. Persists to disk immediately.
	/// </summary>
	/// <param name="key">The secret key to remove.</param>
	/// <returns>True if the secret was found and removed.</returns>
	public bool RemoveSecret(string key)
	{
		bool removed = false;

		if (_encryptedValues is not null)
			removed = _encryptedValues.Remove(key);

		_decryptedCache?.Remove(key);

		if (removed)
			SaveToDisk();

		return removed;
	}

	/// <summary>
	/// Returns all secret keys (without decrypting values).
	/// </summary>
	public IReadOnlyList<string> ListKeys()
	{
		return _encryptedValues?.Keys.ToList() ?? new List<string>();
	}

	/// <summary>
	/// Applies secrets as overrides to a P4NTHE0NOptions instance.
	/// Known secret keys are mapped to their corresponding options properties.
	/// </summary>
	/// <param name="options">The options to apply secrets to.</param>
	public void ApplyTo(P4NTHE0NOptions options)
	{
		if (options is null || _encryptedValues is null || _encryptedValues.Count == 0)
			return;

		// Map well-known secret keys to options properties
		string? dbConnStr = GetSecret("Database:ConnectionString");
		if (dbConnStr is not null)
			options.Database.ConnectionString = dbConnStr;

		string? masterKeyPath = GetSecret("Security:MasterKeyPath");
		if (masterKeyPath is not null)
			options.Security.MasterKeyPath = masterKeyPath;

		Console.WriteLine("[SecretsProvider] Applied secrets to configuration.");
	}

	/// <summary>
	/// Persists the encrypted values dictionary to the secrets file.
	/// </summary>
	private void SaveToDisk()
	{
		if (_encryptedValues is null)
			return;

		try
		{
			string? directory = Path.GetDirectoryName(_secretsFilePath);
			if (!string.IsNullOrEmpty(directory) && !Directory.Exists(directory))
				Directory.CreateDirectory(directory);

			JsonSerializerOptions jsonOptions = new() { WriteIndented = true };
			string json = JsonSerializer.Serialize(_encryptedValues, jsonOptions);
			File.WriteAllText(_secretsFilePath, json);
		}
		catch (Exception ex)
		{
			Console.WriteLine($"[SecretsProvider] Failed to save secrets: {ex.Message}");
		}
	}
}
