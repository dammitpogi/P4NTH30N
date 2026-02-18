# Casino Credential Management (WIN-005)

## Overview

Real casino credentials are encrypted using the INFRA-009 AES-256-GCM encryption service and stored in MongoDB's `CRED3N7IAL` collection. This document covers secure setup, validation, and rotation procedures.

## Prerequisites

- Master encryption key generated (`scripts/security/generate-master-key.ps1`)
- MongoDB running with P4NTH30N database
- Casino account(s) created and funded

## Credential Encryption

### Encrypt and Store a Credential

```csharp
// Using the SecretsProvider (INFRA-002)
var keyMgmt = new KeyManagement(@"C:\ProgramData\P4NTH30N\master.key");
var encryption = new EncryptionService(keyMgmt);

// Encrypt password
string encryptedPassword = encryption.EncryptToString("actual_casino_password");

// Store in MongoDB CRED3N7IAL collection
// Password field contains the encrypted compact string: "nonce:ciphertext:tag"
```

### Credential Document Structure

```json
{
  "_id": "casino_username",
  "Enabled": true,
  "Banned": false,
  "Username": "casino_username",
  "Password": "base64nonce:base64ciphertext:base64tag",
  "Balance": 100.00,
  "LastUpdated": "2026-01-01T00:00:00Z",
  "House": "casino_name",
  "Category": "slots"
}
```

## Validation Checklist

Before production use, validate each credential:

- [ ] Username/password decrypt correctly
- [ ] Test login succeeds in browser
- [ ] Balance reads correctly via JS extraction
- [ ] Account is not flagged or restricted
- [ ] Sufficient funds for planned session
- [ ] Two-factor authentication disabled (or automated)

## Security Hardening

| Measure | Status | Notes |
|---------|--------|-------|
| AES-256-GCM encryption | ✅ Done | INFRA-009 |
| Master key with ACL | ✅ Done | Admin-only access |
| No plaintext passwords in code | ✅ Done | All encrypted in MongoDB |
| Credential rotation procedure | 📋 Planned | Monthly rotation recommended |
| Audit logging | 📋 Planned | Log all credential access |

## Credential Rotation

1. Generate new casino password on the casino website
2. Encrypt the new password using the encryption service
3. Update the `CRED3N7IAL` document in MongoDB
4. Verify login with new credentials
5. Document rotation date

```powershell
# Future: Automated rotation script
# scripts/credentials/rotate-credential.ps1 -Username "casino_user"
```

## Emergency Procedures

### Credential Compromised
1. Immediately change password on casino website
2. Activate kill switch: `SafetyMonitor.ActivateKillSwitch("Credential compromised")`
3. Re-encrypt and update MongoDB
4. Review access logs for unauthorized use
5. Rotate master key if compromise vector is unclear

### Account Locked
1. Stop automation for affected credential
2. Contact casino support if appropriate
3. Use backup credential if available
4. Update `Enabled: false` in MongoDB
