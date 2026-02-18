namespace P4NTH30N.C0MMON.Security;

/// <summary>
/// Contract for master key lifecycle management.
/// Handles key generation, loading, derivation, and rotation.
/// </summary>
/// <remarks>
/// The master key is stored as a local file protected by OS-level permissions.
/// Encryption keys are derived from the master key using PBKDF2 with a high iteration count.
/// </remarks>
public interface IKeyManagement
{
	/// <summary>
	/// Generates a new cryptographically random master key and persists it to the configured path.
	/// Sets restrictive file permissions (Administrators only).
	/// </summary>
	/// <param name="overwrite">If false, throws when a key file already exists to prevent accidental overwrites.</param>
	/// <exception cref="InvalidOperationException">When a key file already exists and overwrite is false.</exception>
	void GenerateMasterKey(bool overwrite = false);

	/// <summary>
	/// Loads the master key from the configured file path into memory.
	/// Must be called before any encryption/decryption operations.
	/// </summary>
	/// <returns>True if the key was loaded successfully, false if the key file does not exist.</returns>
	/// <exception cref="UnauthorizedAccessException">When the process lacks permissions to read the key file.</exception>
	bool LoadMasterKey();

	/// <summary>
	/// Derives a 256-bit encryption key from the master key using PBKDF2.
	/// Uses 600,000 iterations per OWASP 2025 guidelines.
	/// </summary>
	/// <param name="salt">Per-purpose salt to produce distinct derived keys.</param>
	/// <returns>A 32-byte derived key suitable for AES-256.</returns>
	/// <exception cref="InvalidOperationException">When the master key has not been loaded.</exception>
	byte[] DeriveKey(byte[] salt);

	/// <summary>
	/// Rotates the master key: generates a new key, re-encrypts all credentials,
	/// backs up the old key, and persists the new key.
	/// </summary>
	/// <param name="reEncryptCallback">
	/// Callback that receives (oldDerivedKey, newDerivedKey) and must re-encrypt all stored data.
	/// Returns the count of re-encrypted records.
	/// </param>
	/// <returns>The number of records re-encrypted during rotation.</returns>
	int RotateMasterKey(Func<byte[], byte[], int> reEncryptCallback);

	/// <summary>
	/// Returns true if a master key is currently loaded in memory.
	/// </summary>
	bool IsKeyLoaded { get; }

	/// <summary>
	/// Returns the configured master key file path.
	/// </summary>
	string KeyFilePath { get; }
}
