# Security Hardening (INFRA-006)

## Current Security Posture

| Area | Status | Implementation |
|------|--------|---------------|
| **Credential encryption at rest** | ✅ Done | AES-256-GCM via INFRA-009 EncryptionService |
| **Master key management** | ✅ Done | ACL-protected file, admin-only |
| **No plaintext passwords in code** | ✅ Done | All encrypted in MongoDB |
| **Audit logging** | ✅ Done | ERR0R collection + file logs |
| **SSL/TLS on MongoDB** | 📋 Planned | Enable when going to production |
| **Secrets rotation** | 📋 Planned | Monthly rotation procedure documented |
| **Network segmentation** | ✅ Done | VM isolated via Hyper-V virtual switch |

## Encryption Architecture

```
Master Key (master.key)
    │
    ├── ACL: Admin-only read
    ├── Location: C:\ProgramData\P4NTH30N\master.key
    └── Generated: scripts/security/generate-master-key.ps1

    │ HKDF derivation
    ▼
Encryption Key (derived, in-memory only)
    │
    ├── Algorithm: AES-256-GCM
    ├── Nonce: 12 bytes, unique per encryption
    └── Tag: 16 bytes authentication

    │ Encrypts
    ▼
Credential Passwords (MongoDB CRED3N7IAL)
    Format: "base64(nonce):base64(ciphertext):base64(tag)"
```

## Security Checklist for Production

- [ ] Master key backed up to separate secure location
- [ ] MongoDB authentication enabled (username/password)
- [ ] MongoDB SSL/TLS enabled
- [ ] Firewall rules: MongoDB port 27017 only from localhost
- [ ] Firewall rules: Synergy port 24800 only from VM subnet
- [ ] Firewall rules: RTMP port 1935 only from VM subnet
- [ ] Windows Defender real-time protection enabled
- [ ] Audit logging active for all credential access
- [ ] No sensitive data in console output (passwords masked)
- [ ] Git history clean of any plaintext secrets

## Secrets Rotation Procedure

### Monthly Rotation
1. Generate new casino password on casino website
2. Encrypt new password: `encryptionService.EncryptToString("new_password")`
3. Update MongoDB CRED3N7IAL document
4. Verify login with new credentials
5. Document rotation date

### Master Key Rotation (Annual or On Compromise)
1. Generate new master key
2. Decrypt all credentials with old key
3. Re-encrypt all credentials with new key
4. Replace master.key file
5. Verify all credentials accessible
6. Secure-delete old master key

## Audit Logging

All security-relevant events are logged:

| Event | Destination | Fields |
|-------|-------------|--------|
| Credential access | Console + ERR0R | Username, timestamp, source |
| Login attempt | EV3NT | Username, success/fail, IP |
| Kill switch activation | Console + file | Reason, timestamp |
| Safety alert | Console + file + webhook | Metric, severity, value |
| Win detection | Console + file + webhook | Amount, tier, timestamp |

## Network Security

```
Host Machine (192.168.1.x)
├── MongoDB: 27017 (localhost only)
├── RTMP: 1935 (VM subnet only)
└── Synergy: 24800 (VM subnet only)

VM (192.168.1.y)
├── OBS: Streams to host:1935
├── Synergy Client: Connects to host:24800
└── Chrome: Casino sites (outbound HTTPS only)
```
