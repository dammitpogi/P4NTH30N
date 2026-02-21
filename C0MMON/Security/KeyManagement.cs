using System.Diagnostics;
using System.Security.AccessControl;
using System.Security.Cryptography;
using System.Security.Principal;

namespace P4NTH30N.C0MMON.Security;

/// <summary>
/// Manages the master encryption key lifecycle: generation, loading, derivation, and rotation.
/// Master key is stored as a local file with OS-level ACL protection (Administrators only).
/// </summary>
/// <remarks>
/// SECURITY NOTES:
/// - Master key file default path: C:\ProgramData\P4NTH30N\master.key
/// - File permissions: Administrators group only (read/write)
/// - Key size: 256 bits (32 bytes) cryptographically random
/// - Key derivation: PBKDF2-SHA512 with 600,000 iterations (OWASP 2025)
/// - Backup files created during rotation: master.key.bak.{timestamp}
/// </remarks>
public sealed class KeyManagement : IKeyManagement, IDisposable
{
	/// <summary>
	/// Default directory for storing the master key file.
	/// Uses ProgramData to survive user profile changes.
	/// </summary>
	private const string DefaultKeyDirectory = @"C:\ProgramData\P4NTH30N";

	/// <summary>
	/// Default filename for the master key.
	/// </summary>
	private const string DefaultKeyFileName = "master.key";

	/// <summary>
	/// PBKDF2 iteration count per OWASP 2025 recommendation.
	/// Higher values increase brute-force resistance at the cost of derivation time.
	/// </summary>
	internal const int Pbkdf2Iterations = 600_000;

	/// <summary>
	/// Master key size in bytes (256 bits for AES-256).
	/// </summary>
	private const int MasterKeySize = 32;

	/// <summary>
	/// Derived key size in bytes (256 bits for AES-256).
	/// </summary>
	private const int DerivedKeySize = 32;

	/// <summary>
	/// The in-memory master key. Cleared on disposal.
	/// </summary>
	private byte[]? _masterKey;

	/// <summary>
	/// Lock object to synchronize key operations.
	/// </summary>
	private readonly object _keyLock = new();

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <summary>
	/// When true, restrictive OS-level ACL is applied to the key file.
	/// Set to false for testing without Administrator elevation.
	/// Default: true (production behavior).
	/// </summary>
	public bool EnforceFilePermissions { get; set; } = true;

	/// <inheritdoc />
	public string KeyFilePath { get; }

	/// <inheritdoc />
	public bool IsKeyLoaded
	{
		get
		{
			lock (_keyLock)
			{
				return _masterKey is not null;
			}
		}
	}

	/// <summary>
	/// Creates a KeyManagement instance using the default key path.
	/// </summary>
	public KeyManagement()
		: this(Path.Combine(DefaultKeyDirectory, DefaultKeyFileName)) { }

	/// <summary>
	/// Creates a KeyManagement instance with a custom key file path.
	/// Useful for testing or non-standard deployments.
	/// </summary>
	/// <param name="keyFilePath">Full path to the master key file.</param>
	/// <param name="enforceFilePermissions">Set to false to skip ACL enforcement (testing).</param>
	/// <exception cref="ArgumentException">When keyFilePath is null or empty.</exception>
	public KeyManagement(string keyFilePath, bool enforceFilePermissions = true)
	{
		if (string.IsNullOrWhiteSpace(keyFilePath))
			throw new ArgumentException("Key file path cannot be null or empty.", nameof(keyFilePath));

		KeyFilePath = keyFilePath;
		EnforceFilePermissions = enforceFilePermissions;
	}

	/// <inheritdoc />
	public void GenerateMasterKey(bool overwrite = false)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		lock (_keyLock)
		{
			if (File.Exists(KeyFilePath) && !overwrite)
			{
				throw new InvalidOperationException(
					$"Master key file already exists at '{KeyFilePath}'. "
						+ "Set overwrite=true to replace it. This is a destructive operation — "
						+ "all data encrypted with the old key will become unrecoverable without a backup."
				);
			}

			// Ensure the directory exists
			string? directory = Path.GetDirectoryName(KeyFilePath);
			if (!string.IsNullOrEmpty(directory) && !Directory.Exists(directory))
			{
				Directory.CreateDirectory(directory);
				Console.WriteLine($"[KeyManagement] Created directory: {directory}");
			}

			// Generate 256-bit cryptographically random key
			byte[] newKey = RandomNumberGenerator.GetBytes(MasterKeySize);

			try
			{
				// Write the key to disk
				File.WriteAllBytes(KeyFilePath, newKey);

				// DECISION: Set restrictive ACL on Windows — Administrators only.
				// Skipped when EnforceFilePermissions is false (testing without elevation).
				if (EnforceFilePermissions)
					SetRestrictivePermissions(KeyFilePath);

				// Load the new key into memory
				ClearMasterKey();
				_masterKey = newKey;

				Console.WriteLine($"[KeyManagement] Master key generated and saved to: {KeyFilePath}");
			}
			catch
			{
				// Wipe the generated key from memory on failure
				CryptographicOperations.ZeroMemory(newKey);
				throw;
			}
		}
	}

	/// <inheritdoc />
	public bool LoadMasterKey()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		lock (_keyLock)
		{
			if (!File.Exists(KeyFilePath))
			{
				Console.WriteLine($"[KeyManagement] Master key file not found at: {KeyFilePath}");
				return false;
			}

			byte[] loadedKey = File.ReadAllBytes(KeyFilePath);

			if (loadedKey.Length != MasterKeySize)
			{
				CryptographicOperations.ZeroMemory(loadedKey);
				throw new InvalidOperationException(
					$"Master key file has invalid size: {loadedKey.Length} bytes (expected {MasterKeySize}). " + "The key file may be corrupted."
				);
			}

			ClearMasterKey();
			_masterKey = loadedKey;

			Console.WriteLine($"[KeyManagement] Master key loaded from: {KeyFilePath}");
			return true;
		}
	}

	/// <inheritdoc />
	public byte[] DeriveKey(byte[] salt)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentNullException.ThrowIfNull(salt, nameof(salt));

		lock (_keyLock)
		{
			if (_masterKey is null)
			{
				throw new InvalidOperationException("Master key is not loaded. Call LoadMasterKey() or GenerateMasterKey() first.");
			}

			// DECISION: Using PBKDF2-HMAC-SHA512 with 600k iterations.
			// Argon2id would be preferable but requires a third-party NuGet package.
			// PBKDF2 at 600k iterations meets OWASP 2025 minimums and is built-in.
			return Rfc2898DeriveBytes.Pbkdf2(_masterKey, salt, Pbkdf2Iterations, HashAlgorithmName.SHA512, DerivedKeySize);
		}
	}

	/// <inheritdoc />
	public int RotateMasterKey(Func<byte[], byte[], int> reEncryptCallback)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentNullException.ThrowIfNull(reEncryptCallback, nameof(reEncryptCallback));

		lock (_keyLock)
		{
			if (_masterKey is null)
			{
				throw new InvalidOperationException("Cannot rotate: no master key is currently loaded.");
			}

			// Step 1: Backup the current key file
			string backupPath = $"{KeyFilePath}.bak.{DateTime.UtcNow:yyyyMMddHHmmss}";
			File.Copy(KeyFilePath, backupPath, overwrite: false);
			Console.WriteLine($"[KeyManagement] Old key backed up to: {backupPath}");

			// Step 2: Derive keys from the old master for re-encryption
			byte[] credentialSalt = GetCredentialSalt();
			byte[] oldDerivedKey = DeriveKey(credentialSalt);

			// Step 3: Generate a new master key
			byte[] newMasterKey = RandomNumberGenerator.GetBytes(MasterKeySize);
			byte[] oldMasterKey = _masterKey;

			try
			{
				// Temporarily load the new key to derive from it
				_masterKey = newMasterKey;
				byte[] newDerivedKey = DeriveKey(credentialSalt);

				// Step 4: Re-encrypt all credentials via callback
				int reEncryptedCount = reEncryptCallback(oldDerivedKey, newDerivedKey);

				// Step 5: Persist the new master key
				File.WriteAllBytes(KeyFilePath, newMasterKey);
				if (EnforceFilePermissions)
					SetRestrictivePermissions(KeyFilePath);

				// Step 6: Wipe old key material
				CryptographicOperations.ZeroMemory(oldMasterKey);
				CryptographicOperations.ZeroMemory(oldDerivedKey);
				CryptographicOperations.ZeroMemory(newDerivedKey);

				Console.WriteLine($"[KeyManagement] Key rotation complete. Re-encrypted {reEncryptedCount} records.");
				return reEncryptedCount;
			}
			catch
			{
				// Rollback: restore old master key in memory
				_masterKey = oldMasterKey;
				CryptographicOperations.ZeroMemory(newMasterKey);
				Console.WriteLine("[KeyManagement] Key rotation FAILED — rolled back to previous key.");
				throw;
			}
		}
	}

	/// <summary>
	/// Returns the well-known salt for credential encryption.
	/// Using a static salt here because we derive one key per purpose (credentials).
	/// The per-encryption nonce in AES-GCM provides uniqueness per record.
	/// </summary>
	public static byte[] GetCredentialSalt()
	{
		// DECISION: Static salt per purpose is acceptable because AES-GCM nonces
		// provide per-record uniqueness. The salt differentiates key purposes.
		return "P4NTH30N.CRED3N7IAL.v1"u8.ToArray();
	}

	/// <summary>
	/// Sets restrictive file permissions on Windows: Administrators group only.
	/// Logs a warning if permissions cannot be applied (e.g., insufficient rights).
	/// </summary>
	private static void SetRestrictivePermissions(string filePath)
	{
		try
		{
			FileInfo fileInfo = new(filePath);
			FileSecurity security = fileInfo.GetAccessControl();

			// Remove all inherited ACL entries
			security.SetAccessRuleProtection(isProtected: true, preserveInheritance: false);

			AuthorizationRuleCollection existingRules = security.GetAccessRules(includeExplicit: true, includeInherited: true, targetType: typeof(SecurityIdentifier));
			foreach (FileSystemAccessRule rule in existingRules)
			{
				security.RemoveAccessRule(rule);
			}

			// Grant full control to BUILTIN\Administrators only
			SecurityIdentifier adminsSid = new(WellKnownSidType.BuiltinAdministratorsSid, null);
			security.AddAccessRule(new FileSystemAccessRule(adminsSid, FileSystemRights.FullControl, AccessControlType.Allow));

			fileInfo.SetAccessControl(security);
			Console.WriteLine($"[KeyManagement] Set restrictive ACL on: {filePath} (Administrators only)");
		}
		catch (Exception ex)
		{
			// SAFETY: Don't block key generation if ACL setting fails.
			// This can happen when running as a non-admin user in development.
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine(
				$"[{line}] [KeyManagement] WARNING: Could not set restrictive permissions on '{filePath}': {ex.Message}. "
					+ "Ensure the key file is manually secured in production."
			);
		}
	}

	/// <summary>
	/// Securely clears the in-memory master key by zeroing the buffer.
	/// </summary>
	private void ClearMasterKey()
	{
		if (_masterKey is not null)
		{
			CryptographicOperations.ZeroMemory(_masterKey);
			_masterKey = null;
		}
	}

	/// <summary>
	/// Disposes the KeyManagement instance, securely clearing the master key from memory.
	/// </summary>
	public void Dispose()
	{
		if (!_disposed)
		{
			lock (_keyLock)
			{
				ClearMasterKey();
				_disposed = true;
			}
		}
	}
}
