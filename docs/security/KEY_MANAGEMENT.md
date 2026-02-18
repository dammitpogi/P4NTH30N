# P4NTH30N Key Management Guide (INFRA-009)

## Overview

P4NTH30N uses **AES-256-GCM** authenticated encryption with a locally stored master key to protect credentials at rest in MongoDB. Zero cloud dependencies, zero recurring costs.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Master Key File                          │
│  C:\ProgramData\P4NTH30N\master.key (32 bytes, ACL locked) │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼  PBKDF2-SHA512 (600k iterations)
┌─────────────────────────────────────────────────────────────┐
│              Derived Encryption Key (32 bytes)              │
│         Salt: "P4NTH30N.CRED3N7IAL.v1" (per purpose)       │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼  AES-256-GCM
┌─────────────────────────────────────────────────────────────┐
│   Encrypted Credential in MongoDB (CRED3N7IAL collection)   │
│   Format: { nonce: 12B, ciphertext: NB, tag: 16B }         │
│   Or compact string: Base64(nonce):Base64(ct):Base64(tag)   │
└─────────────────────────────────────────────────────────────┘
```

## Security Properties

| Property | Value | Standard |
|----------|-------|----------|
| **Algorithm** | AES-256-GCM | NIST SP 800-38D |
| **Key Size** | 256 bits (32 bytes) | AES maximum |
| **Nonce Size** | 96 bits (12 bytes) | NIST recommended |
| **Tag Size** | 128 bits (16 bytes) | GCM maximum |
| **KDF** | PBKDF2-HMAC-SHA512 | OWASP 2025 |
| **KDF Iterations** | 600,000 | OWASP 2025 minimum |
| **Key Storage** | Local file + OS ACL | Windows DACL |

## File Locations

| File | Path | Purpose |
|------|------|---------|
| Master Key | `C:\ProgramData\P4NTH30N\master.key` | Production master key |
| Key Generator | `scripts/security/generate-master-key.ps1` | Key creation script |
| Encryption Service | `C0MMON/Security/EncryptionService.cs` | AES-256-GCM operations |
| Key Management | `C0MMON/Security/KeyManagement.cs` | Key lifecycle management |
| Tests | `UNI7T35T/Tests/EncryptionServiceTests.cs` | 9 security tests |

## Quick Start

### 1. Generate Master Key

```powershell
# First-time setup (run as Administrator)
.\scripts\security\generate-master-key.ps1

# Custom path (development)
.\scripts\security\generate-master-key.ps1 -KeyPath "C:\Dev\P4NTH30N\test.key"
```

### 2. Use in Code

```csharp
// Initialize key management and encryption
using KeyManagement keyMgmt = new();
keyMgmt.LoadMasterKey();  // Loads from C:\ProgramData\P4NTH30N\master.key

using EncryptionService encSvc = new(keyMgmt);

// Encrypt a password
string encrypted = encSvc.EncryptToString("my_secret_password");
// Result: "AAAA...==:BBBB...==:CCCC...=="

// Decrypt it back
string password = encSvc.DecryptFromString(encrypted);
```

### 3. Run Tests

```powershell
dotnet test UNI7T35T\UNI7T35T.csproj
```

## Key Rotation

Key rotation re-encrypts all credentials with a new master key while backing up the old one.

```csharp
using KeyManagement keyMgmt = new();
keyMgmt.LoadMasterKey();

int rotated = keyMgmt.RotateMasterKey((oldKey, newKey) =>
{
    // Re-encrypt all credentials in MongoDB here
    // Return count of re-encrypted records
    return reEncryptedCount;
});
```

Backup files are created at: `master.key.bak.{yyyyMMddHHmmss}`

## Security Checklist

- [ ] Master key file exists at configured path
- [ ] File ACL restricts access to Administrators only
- [ ] Master key backup stored in secure offline location
- [ ] Key file is NOT in source control (.gitignore includes `*.key`)
- [ ] EncryptionService tests pass (9/9)
- [ ] Encrypted credentials verified in MongoDB

## Threat Model

| Threat | Mitigation |
|--------|------------|
| Key file stolen | OS-level ACL (Administrators only) |
| Ciphertext tampering | GCM authentication tag (16 bytes) |
| Nonce reuse | Cryptographically random 12-byte nonce per encryption |
| Brute force on derived key | PBKDF2 with 600k iterations |
| Memory exposure | CryptographicOperations.ZeroMemory on disposal |
| Accidental key overwrite | GenerateMasterKey(overwrite: false) by default |

## Future Enhancements

- **Argon2id**: Replace PBKDF2 with Argon2id when `Isopoh.Cryptography.Argon2` is vetted
- **HSM**: Hardware security module for master key storage post-revenue
- **Azure Key Vault**: Managed secrets for cloud deployment phase
- **Envelope encryption**: Per-credential keys wrapped by master key
