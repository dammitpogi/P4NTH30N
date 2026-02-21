using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;

namespace P4NTH30N.C0MMON.Security;

/// <summary>
/// AES-256-GCM authenticated encryption service for credential protection.
/// Uses a derived key from <see cref="IKeyManagement"/> for all operations.
/// </summary>
/// <remarks>
/// SECURITY DESIGN:
/// - Algorithm: AES-256-GCM (authenticated encryption with associated data)
/// - Nonce: 12 bytes, cryptographically random, unique per encryption
/// - Tag: 16 bytes, verifies ciphertext integrity
/// - Key derivation: PBKDF2-SHA512 via IKeyManagement.DeriveKey
/// - Thread-safe: All operations are stateless after initialization
///
/// IMPORTANT: Uses AesGcm class directly (NOT Aes.Create) per INFRA-009 spec.
/// AesGcm provides proper GCM mode without the pitfalls of CBC/CTR wrappers.
/// </remarks>
public sealed class EncryptionService : IEncryptionService, IDisposable
{
	/// <summary>
	/// AES-GCM nonce size in bytes. NIST recommends 12 bytes (96 bits) for GCM.
	/// </summary>
	private const int NonceSize = 12;

	/// <summary>
	/// AES-GCM authentication tag size in bytes. 16 bytes (128 bits) is the maximum and most secure.
	/// </summary>
	private const int TagSize = 16;

	/// <summary>
	/// The key management service that provides derived encryption keys.
	/// </summary>
	private readonly IKeyManagement _keyManagement;

	/// <summary>
	/// Cached derived key for credential encryption.
	/// Derived once from the master key + credential salt, then reused for all operations.
	/// </summary>
	private byte[]? _derivedKey;

	/// <summary>
	/// Lock for thread-safe key initialization.
	/// </summary>
	private readonly object _initLock = new();

	/// <summary>
	/// Whether this instance has been disposed.
	/// </summary>
	private bool _disposed;

	/// <inheritdoc />
	public bool IsInitialized
	{
		get
		{
			lock (_initLock)
			{
				return _derivedKey is not null;
			}
		}
	}

	/// <summary>
	/// Creates an EncryptionService that derives its key from the provided key management service.
	/// </summary>
	/// <param name="keyManagement">Key management service with a loaded master key.</param>
	/// <exception cref="ArgumentNullException">When keyManagement is null.</exception>
	public EncryptionService(IKeyManagement keyManagement)
	{
		ArgumentNullException.ThrowIfNull(keyManagement, nameof(keyManagement));
		_keyManagement = keyManagement;
	}

	/// <summary>
	/// Initializes the derived encryption key from the master key.
	/// Called lazily on first encrypt/decrypt, or can be called explicitly.
	/// </summary>
	/// <exception cref="InvalidOperationException">When the master key is not loaded.</exception>
	public void Initialize()
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		lock (_initLock)
		{
			if (_derivedKey is not null)
				return;

			if (!_keyManagement.IsKeyLoaded)
			{
				throw new InvalidOperationException(
					"Cannot initialize EncryptionService: master key is not loaded. " + "Call IKeyManagement.LoadMasterKey() or GenerateMasterKey() first."
				);
			}

			byte[] salt = KeyManagement.GetCredentialSalt();
			_derivedKey = _keyManagement.DeriveKey(salt);
			Console.WriteLine("[EncryptionService] Derived encryption key initialized.");
		}
	}

	/// <inheritdoc />
	public EncryptedValue Encrypt(string plaintext)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);

		if (string.IsNullOrEmpty(plaintext))
			throw new ArgumentException("Plaintext cannot be null or empty.", nameof(plaintext));

		EnsureInitialized();

		byte[] plaintextBytes = Encoding.UTF8.GetBytes(plaintext);
		byte[] nonce = RandomNumberGenerator.GetBytes(NonceSize);
		byte[] ciphertext = new byte[plaintextBytes.Length];
		byte[] tag = new byte[TagSize];

		try
		{
			// CRITICAL: Using AesGcm directly — NOT Aes.Create.
			// AesGcm provides proper authenticated encryption in a single pass.
			using AesGcm aes = new(_derivedKey!, TagSize);
			aes.Encrypt(nonce, plaintextBytes, ciphertext, tag);

			return new EncryptedValue(nonce, ciphertext, tag);
		}
		catch (CryptographicException ex)
		{
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [EncryptionService] Encryption failed: {ex.Message}");
			throw;
		}
		finally
		{
			// Wipe plaintext bytes from memory
			CryptographicOperations.ZeroMemory(plaintextBytes);
		}
	}

	/// <inheritdoc />
	public string Decrypt(EncryptedValue encrypted)
	{
		ObjectDisposedException.ThrowIf(_disposed, this);
		ArgumentNullException.ThrowIfNull(encrypted, nameof(encrypted));

		EnsureInitialized();

		byte[] plaintextBytes = new byte[encrypted.Ciphertext.Length];

		try
		{
			using AesGcm aes = new(_derivedKey!, TagSize);
			aes.Decrypt(encrypted.Nonce, encrypted.Ciphertext, encrypted.Tag, plaintextBytes);

			return Encoding.UTF8.GetString(plaintextBytes);
		}
		catch (CryptographicException ex)
		{
			// SAFETY: Authentication tag mismatch means data was tampered with.
			StackTrace trace = new(ex, true);
			StackFrame? frame = trace.GetFrame(0);
			int line = frame?.GetFileLineNumber() ?? 0;
			Console.WriteLine($"[{line}] [EncryptionService] Decryption failed (possible tampering): {ex.Message}");
			throw;
		}
		finally
		{
			CryptographicOperations.ZeroMemory(plaintextBytes);
		}
	}

	/// <inheritdoc />
	public string EncryptToString(string plaintext)
	{
		EncryptedValue encrypted = Encrypt(plaintext);
		return encrypted.ToCompactString();
	}

	/// <inheritdoc />
	public string DecryptFromString(string encryptedString)
	{
		if (string.IsNullOrWhiteSpace(encryptedString))
			throw new ArgumentException("Encrypted string cannot be null or empty.", nameof(encryptedString));

		EncryptedValue encrypted = EncryptedValue.FromCompactString(encryptedString);
		return Decrypt(encrypted);
	}

	/// <summary>
	/// Ensures the derived key has been initialized, performing lazy initialization if needed.
	/// </summary>
	private void EnsureInitialized()
	{
		if (_derivedKey is null)
		{
			Initialize();
		}
	}

	/// <summary>
	/// Disposes the EncryptionService, securely clearing the derived key from memory.
	/// </summary>
	public void Dispose()
	{
		if (!_disposed)
		{
			lock (_initLock)
			{
				if (_derivedKey is not null)
				{
					CryptographicOperations.ZeroMemory(_derivedKey);
					_derivedKey = null;
				}
				_disposed = true;
			}
		}
	}
}
