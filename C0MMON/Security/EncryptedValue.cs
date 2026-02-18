using MongoDB.Bson.Serialization.Attributes;

namespace P4NTH30N.C0MMON.Security;

/// <summary>
/// Immutable container for AES-256-GCM encrypted data.
/// Stores the nonce (IV), ciphertext, and authentication tag as separate byte arrays.
/// All three components are required for decryption and tamper verification.
/// </summary>
/// <remarks>
/// BSON-serializable for direct storage in MongoDB documents.
/// The authentication tag ensures data integrity — any modification to ciphertext
/// or nonce will cause decryption to fail with a CryptographicException.
/// </remarks>
[BsonIgnoreExtraElements]
public sealed class EncryptedValue
{
	/// <summary>
	/// The 12-byte nonce (initialization vector) used during encryption.
	/// Must be unique per encryption operation — never reuse with the same key.
	/// </summary>
	[BsonElement("nonce")]
	public byte[] Nonce { get; init; }

	/// <summary>
	/// The encrypted payload (same length as original plaintext bytes).
	/// </summary>
	[BsonElement("ciphertext")]
	public byte[] Ciphertext { get; init; }

	/// <summary>
	/// The 16-byte GCM authentication tag.
	/// Verifies that neither the ciphertext nor the nonce have been tampered with.
	/// </summary>
	[BsonElement("tag")]
	public byte[] Tag { get; init; }

	/// <summary>
	/// Constructs an EncryptedValue with all required components.
	/// </summary>
	/// <param name="nonce">12-byte nonce/IV</param>
	/// <param name="ciphertext">Encrypted payload bytes</param>
	/// <param name="tag">16-byte GCM authentication tag</param>
	/// <exception cref="ArgumentNullException">When any parameter is null.</exception>
	/// <exception cref="ArgumentException">When nonce is not 12 bytes or tag is not 16 bytes.</exception>
	public EncryptedValue(byte[] nonce, byte[] ciphertext, byte[] tag)
	{
		ArgumentNullException.ThrowIfNull(nonce, nameof(nonce));
		ArgumentNullException.ThrowIfNull(ciphertext, nameof(ciphertext));
		ArgumentNullException.ThrowIfNull(tag, nameof(tag));

		if (nonce.Length != 12)
			throw new ArgumentException("AES-GCM nonce must be exactly 12 bytes.", nameof(nonce));
		if (tag.Length != 16)
			throw new ArgumentException("AES-GCM tag must be exactly 16 bytes.", nameof(tag));

		Nonce = nonce;
		Ciphertext = ciphertext;
		Tag = tag;
	}

	/// <summary>
	/// Parameterless constructor for BSON deserialization.
	/// Do not use directly — fields will be populated by the serializer.
	/// </summary>
	[BsonConstructor]
	public EncryptedValue()
	{
		Nonce = Array.Empty<byte>();
		Ciphertext = Array.Empty<byte>();
		Tag = Array.Empty<byte>();
	}

	/// <summary>
	/// Converts this encrypted value to a compact colon-delimited Base64 string.
	/// Format: {Base64(nonce)}:{Base64(ciphertext)}:{Base64(tag)}
	/// </summary>
	public string ToCompactString()
	{
		return $"{Convert.ToBase64String(Nonce)}:{Convert.ToBase64String(Ciphertext)}:{Convert.ToBase64String(Tag)}";
	}

	/// <summary>
	/// Parses a compact colon-delimited Base64 string back into an EncryptedValue.
	/// </summary>
	/// <param name="compact">The string produced by <see cref="ToCompactString"/>.</param>
	/// <returns>A reconstructed <see cref="EncryptedValue"/>.</returns>
	/// <exception cref="FormatException">When the string format is invalid.</exception>
	public static EncryptedValue FromCompactString(string compact)
	{
		if (string.IsNullOrWhiteSpace(compact))
			throw new FormatException("Encrypted string cannot be null or empty.");

		string[] parts = compact.Split(':');
		if (parts.Length != 3)
			throw new FormatException($"Encrypted string must have exactly 3 colon-separated parts, got {parts.Length}.");

		try
		{
			byte[] nonce = Convert.FromBase64String(parts[0]);
			byte[] ciphertext = Convert.FromBase64String(parts[1]);
			byte[] tag = Convert.FromBase64String(parts[2]);
			return new EncryptedValue(nonce, ciphertext, tag);
		}
		catch (Exception ex) when (ex is not FormatException)
		{
			throw new FormatException($"Failed to parse encrypted string components: {ex.Message}", ex);
		}
	}
}
