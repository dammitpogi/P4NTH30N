namespace P4NTH30N.C0MMON.Security;

/// <summary>
/// Contract for encryption/decryption operations using AES-256-GCM.
/// All implementations must use authenticated encryption to prevent tampering.
/// </summary>
public interface IEncryptionService
{
	/// <summary>
	/// Encrypts a plaintext string using AES-256-GCM with the derived encryption key.
	/// Returns a self-contained <see cref="EncryptedValue"/> with nonce, ciphertext, and tag.
	/// </summary>
	/// <param name="plaintext">The plaintext string to encrypt. Must not be null or empty.</param>
	/// <returns>An <see cref="EncryptedValue"/> containing the encrypted payload.</returns>
	/// <exception cref="ArgumentException">When plaintext is null or empty.</exception>
	/// <exception cref="InvalidOperationException">When the encryption key is not initialized.</exception>
	EncryptedValue Encrypt(string plaintext);

	/// <summary>
	/// Decrypts an <see cref="EncryptedValue"/> back to plaintext using AES-256-GCM.
	/// Validates the authentication tag to detect tampering.
	/// </summary>
	/// <param name="encrypted">The encrypted value containing nonce, ciphertext, and tag.</param>
	/// <returns>The original plaintext string.</returns>
	/// <exception cref="ArgumentNullException">When encrypted is null.</exception>
	/// <exception cref="System.Security.Cryptography.CryptographicException">When the authentication tag is invalid (data tampered).</exception>
	string Decrypt(EncryptedValue encrypted);

	/// <summary>
	/// Encrypts a plaintext string and returns a compact Base64-encoded representation.
	/// Format: {nonce}:{ciphertext}:{tag} all Base64-encoded.
	/// Convenient for storing in MongoDB string fields.
	/// </summary>
	/// <param name="plaintext">The plaintext string to encrypt.</param>
	/// <returns>A colon-delimited Base64 string: nonce:ciphertext:tag</returns>
	string EncryptToString(string plaintext);

	/// <summary>
	/// Decrypts a compact Base64-encoded string back to plaintext.
	/// Expects format: {nonce}:{ciphertext}:{tag} all Base64-encoded.
	/// </summary>
	/// <param name="encryptedString">The colon-delimited Base64 string produced by <see cref="EncryptToString"/>.</param>
	/// <returns>The original plaintext string.</returns>
	/// <exception cref="FormatException">When the encrypted string format is invalid.</exception>
	string DecryptFromString(string encryptedString);

	/// <summary>
	/// Returns true if the encryption service is properly initialized with a valid key.
	/// </summary>
	bool IsInitialized { get; }
}
