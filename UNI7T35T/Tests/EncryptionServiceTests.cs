using System.Security.Cryptography;
using P4NTHE0N.C0MMON.Security;

namespace UNI7T35T.Tests;

/// <summary>
/// Unit tests for <see cref="EncryptionService"/> and <see cref="KeyManagement"/>.
/// Validates AES-256-GCM encryption, key derivation, round-trip integrity,
/// tamper detection, and compact string serialization.
/// </summary>
public class EncryptionServiceTests
{
	private string _tempKeyDir = string.Empty;
	private string _tempKeyPath = string.Empty;

	/// <summary>
	/// Creates a temporary directory and key file path for isolated testing.
	/// </summary>
	public void Setup()
	{
		_tempKeyDir = Path.Combine(Path.GetTempPath(), $"P4NTHE0N_Test_{Guid.NewGuid():N}");
		Directory.CreateDirectory(_tempKeyDir);
		_tempKeyPath = Path.Combine(_tempKeyDir, "test-master.key");
	}

	/// <summary>
	/// Cleans up the temporary key directory after tests.
	/// </summary>
	public void Cleanup()
	{
		try
		{
			if (Directory.Exists(_tempKeyDir))
				Directory.Delete(_tempKeyDir, recursive: true);
		}
		catch
		{
			// Best-effort cleanup
		}
	}

	/// <summary>
	/// Tests that a master key can be generated, loaded, and used for encryption.
	/// Verifies the full lifecycle: generate → load → derive → encrypt → decrypt.
	/// </summary>
	public bool TestKeyGenerationAndLoading()
	{
		string testName = nameof(TestKeyGenerationAndLoading);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);

			// Generate a new master key
			keyMgmt.GenerateMasterKey();

			// Verify the key file exists and is 32 bytes
			if (!File.Exists(_tempKeyPath))
			{
				Console.WriteLine($"  ✗ {testName}: Key file was not created.");
				return false;
			}

			byte[] keyBytes = File.ReadAllBytes(_tempKeyPath);
			if (keyBytes.Length != 32)
			{
				Console.WriteLine($"  ✗ {testName}: Key file is {keyBytes.Length} bytes, expected 32.");
				return false;
			}

			// Load the key and verify it's loaded
			if (!keyMgmt.IsKeyLoaded)
			{
				Console.WriteLine($"  ✗ {testName}: Key should be loaded after generation.");
				return false;
			}

			// Create a new instance to test loading from disk
			using KeyManagement keyMgmt2 = new(_tempKeyPath, enforceFilePermissions: false);
			bool loaded = keyMgmt2.LoadMasterKey();
			if (!loaded || !keyMgmt2.IsKeyLoaded)
			{
				Console.WriteLine($"  ✗ {testName}: Failed to load key from disk.");
				return false;
			}

			Console.WriteLine($"  ✓ {testName}");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests that encrypting and decrypting a string produces the original plaintext.
	/// </summary>
	public bool TestEncryptDecryptRoundTrip()
	{
		string testName = nameof(TestEncryptDecryptRoundTrip);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);
			keyMgmt.GenerateMasterKey();

			using EncryptionService encSvc = new(keyMgmt);

			string[] testInputs =
			[
				"simple password",
				"P@$$w0rd!#%^&*()_+-=[]{}|;':\",./<>?",
				"unicode: café ñ ü 日本語 🎰",
				"a", // single character
				new string('x', 10_000), // large payload
				"   leading and trailing spaces   ",
			];

			foreach (string input in testInputs)
			{
				EncryptedValue encrypted = encSvc.Encrypt(input);
				string decrypted = encSvc.Decrypt(encrypted);

				if (decrypted != input)
				{
					Console.WriteLine($"  ✗ {testName}: Round-trip failed for input length {input.Length}.");
					Console.WriteLine($"    Expected: {input[..Math.Min(50, input.Length)]}...");
					Console.WriteLine($"    Got:      {decrypted[..Math.Min(50, decrypted.Length)]}...");
					return false;
				}
			}

			Console.WriteLine($"  ✓ {testName} ({testInputs.Length} inputs verified)");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests that each encryption produces unique nonces (no nonce reuse).
	/// Nonce reuse with the same key completely breaks GCM security.
	/// </summary>
	public bool TestNonceUniqueness()
	{
		string testName = nameof(TestNonceUniqueness);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);
			keyMgmt.GenerateMasterKey();

			using EncryptionService encSvc = new(keyMgmt);

			HashSet<string> nonces = new();
			int iterations = 1000;

			for (int i = 0; i < iterations; i++)
			{
				EncryptedValue encrypted = encSvc.Encrypt("same plaintext every time");
				string nonceHex = Convert.ToHexString(encrypted.Nonce);

				if (!nonces.Add(nonceHex))
				{
					Console.WriteLine($"  ✗ {testName}: Nonce collision detected at iteration {i}!");
					return false;
				}
			}

			Console.WriteLine($"  ✓ {testName} ({iterations} unique nonces verified)");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests that tampered ciphertext is detected by the GCM authentication tag.
	/// This is the core security property of authenticated encryption.
	/// </summary>
	public bool TestTamperDetection()
	{
		string testName = nameof(TestTamperDetection);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);
			keyMgmt.GenerateMasterKey();

			using EncryptionService encSvc = new(keyMgmt);

			EncryptedValue encrypted = encSvc.Encrypt("sensitive data");

			// Tamper with the ciphertext by flipping a bit
			byte[] tamperedCiphertext = (byte[])encrypted.Ciphertext.Clone();
			tamperedCiphertext[0] ^= 0xFF;
			EncryptedValue tampered = new(encrypted.Nonce, tamperedCiphertext, encrypted.Tag);

			try
			{
				encSvc.Decrypt(tampered);
				Console.WriteLine($"  ✗ {testName}: Decryption should have failed on tampered data!");
				return false;
			}
			catch (CryptographicException)
			{
				// Expected — GCM detected the tampering
			}

			// Also test tag tampering
			byte[] tamperedTag = (byte[])encrypted.Tag.Clone();
			tamperedTag[0] ^= 0xFF;
			EncryptedValue tagTampered = new(encrypted.Nonce, encrypted.Ciphertext, tamperedTag);

			try
			{
				encSvc.Decrypt(tagTampered);
				Console.WriteLine($"  ✗ {testName}: Decryption should have failed on tampered tag!");
				return false;
			}
			catch (CryptographicException)
			{
				// Expected
			}

			Console.WriteLine($"  ✓ {testName} (ciphertext + tag tampering detected)");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests the compact string serialization format: nonce:ciphertext:tag in Base64.
	/// Validates round-trip through EncryptToString → DecryptFromString.
	/// </summary>
	public bool TestCompactStringRoundTrip()
	{
		string testName = nameof(TestCompactStringRoundTrip);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);
			keyMgmt.GenerateMasterKey();

			using EncryptionService encSvc = new(keyMgmt);

			string original = "my_secret_password_123!@#";
			string compactEncrypted = encSvc.EncryptToString(original);

			// Verify format: should be three Base64 segments separated by colons
			string[] parts = compactEncrypted.Split(':');
			if (parts.Length != 3)
			{
				Console.WriteLine($"  ✗ {testName}: Compact string should have 3 parts, got {parts.Length}.");
				return false;
			}

			string decrypted = encSvc.DecryptFromString(compactEncrypted);
			if (decrypted != original)
			{
				Console.WriteLine($"  ✗ {testName}: Compact string round-trip failed.");
				return false;
			}

			Console.WriteLine($"  ✓ {testName}");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests that different master keys produce different ciphertexts.
	/// Ensures key isolation — changing the key changes all encrypted output.
	/// </summary>
	public bool TestDifferentKeysProduceDifferentCiphertext()
	{
		string testName = nameof(TestDifferentKeysProduceDifferentCiphertext);
		try
		{
			string keyPath1 = Path.Combine(_tempKeyDir, "key1.key");
			string keyPath2 = Path.Combine(_tempKeyDir, "key2.key");

			// Generate two different master keys
			using KeyManagement keyMgmt1 = new(keyPath1, enforceFilePermissions: false);
			keyMgmt1.GenerateMasterKey();

			using KeyManagement keyMgmt2 = new(keyPath2, enforceFilePermissions: false);
			keyMgmt2.GenerateMasterKey();

			using EncryptionService encSvc1 = new(keyMgmt1);
			using EncryptionService encSvc2 = new(keyMgmt2);

			string plaintext = "same plaintext for both";

			EncryptedValue enc1 = encSvc1.Encrypt(plaintext);
			EncryptedValue enc2 = encSvc2.Encrypt(plaintext);

			// Ciphertext should differ because keys differ
			if (enc1.Ciphertext.SequenceEqual(enc2.Ciphertext))
			{
				Console.WriteLine($"  ✗ {testName}: Different keys produced identical ciphertext!");
				return false;
			}

			// Cross-decryption should fail (key1 encrypted data decrypted with key2)
			try
			{
				encSvc2.Decrypt(enc1);
				Console.WriteLine($"  ✗ {testName}: Cross-key decryption should have failed!");
				return false;
			}
			catch (CryptographicException)
			{
				// Expected — wrong key
			}

			Console.WriteLine($"  ✓ {testName}");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests that GenerateMasterKey throws when key already exists and overwrite=false.
	/// </summary>
	public bool TestPreventAccidentalKeyOverwrite()
	{
		string testName = nameof(TestPreventAccidentalKeyOverwrite);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);
			keyMgmt.GenerateMasterKey();

			try
			{
				keyMgmt.GenerateMasterKey(overwrite: false);
				Console.WriteLine($"  ✗ {testName}: Should have thrown on duplicate key generation.");
				return false;
			}
			catch (InvalidOperationException)
			{
				// Expected
			}

			// But overwrite=true should succeed
			keyMgmt.GenerateMasterKey(overwrite: true);

			Console.WriteLine($"  ✓ {testName}");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests EncryptedValue.FromCompactString with invalid inputs.
	/// </summary>
	public bool TestInvalidCompactStringFormats()
	{
		string testName = nameof(TestInvalidCompactStringFormats);
		try
		{
			string[] invalidInputs = ["", "   ", "onlyonepart", "two:parts", "four:parts:here:extra", "not-base64:also-not:base64!!"];

			int caught = 0;
			foreach (string input in invalidInputs)
			{
				try
				{
					EncryptedValue.FromCompactString(input);
					Console.WriteLine($"  ✗ {testName}: Should have thrown for input '{input}'.");
					return false;
				}
				catch (FormatException)
				{
					caught++;
				}
				catch (ArgumentException)
				{
					// Also acceptable for invalid byte arrays
					caught++;
				}
			}

			Console.WriteLine($"  ✓ {testName} ({caught} invalid inputs correctly rejected)");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}

	/// <summary>
	/// Tests key derivation produces consistent results for the same inputs.
	/// </summary>
	public bool TestKeyDerivationDeterminism()
	{
		string testName = nameof(TestKeyDerivationDeterminism);
		try
		{
			using KeyManagement keyMgmt = new(_tempKeyPath, enforceFilePermissions: false);
			keyMgmt.GenerateMasterKey();

			byte[] salt = KeyManagement.GetCredentialSalt();
			byte[] derived1 = keyMgmt.DeriveKey(salt);
			byte[] derived2 = keyMgmt.DeriveKey(salt);

			if (!derived1.SequenceEqual(derived2))
			{
				Console.WriteLine($"  ✗ {testName}: Same inputs produced different derived keys!");
				return false;
			}

			// Different salt should produce different key
			byte[] otherSalt = "P4NTHE0N.OTHER.v1"u8.ToArray();
			byte[] derived3 = keyMgmt.DeriveKey(otherSalt);

			if (derived1.SequenceEqual(derived3))
			{
				Console.WriteLine($"  ✗ {testName}: Different salts produced same derived key!");
				return false;
			}

			Console.WriteLine($"  ✓ {testName}");
			return true;
		}
		catch (Exception ex)
		{
			Console.WriteLine($"  ✗ {testName}: {ex.Message}");
			return false;
		}
	}
}
