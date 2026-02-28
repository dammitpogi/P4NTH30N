# SSH Key Reference

## OP3NF1XER Governance - Key Storage

**IMPORTANT**: The SSH private key is stored OUTSIDE this deploy directory for security.

## Key Location

Keys are stored in the parent directory:
- Private Key: `C:\P4NTH30N\OP3NF1XER\nate-alma\ssh_key`
- Public Key: `C:\P4NTH30N\OP3NF1XER\nate-alma\ssh_key.pub`

## Public Key (for authorized_keys)

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHzZLQF//hAbnC6oEBInFcCVyvH2aMsKHjReHDz+gY/ openclaw-alma-v2@op3nf1xer
```

## Deployment Instructions

When deploying to Railway, you need to base64-encode the private key:

```bash
# From the parent directory (C:\P4NTH30N\OP3NF1XER\nate-alma)
base64 -w 0 ssh_key
```

Then set the output as the `SSH_PRIVATE_KEY_ED25519` environment variable in Railway.

## Security Notes

- The private key (`ssh_key`) is listed in `.gitignore` and will NOT be committed
- Always use the public key (`ssh_key.pub`) for `authorized_keys` on target servers
- The key is backed up in the parent directory under OP3NF1XER governance
- Never share or expose the private key

## Generated

- Date: 2026-02-25
- Type: ED25519
- Comment: openclaw-alma-v2@op3nf1xer
- Authority: OP3NF1XER / P4NTHE0N
