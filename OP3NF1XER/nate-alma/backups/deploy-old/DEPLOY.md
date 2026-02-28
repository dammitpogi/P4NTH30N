# OpenClaw-Alma-v2 Deployment Guide

## OP3NF1XER Governance
This deployment is managed under P4NTHE0N's OpenFixer governance structure.

## Quick Start

### 1. Create GitHub Repository

Create a new private repository on GitHub named `openclaw-alma-v2`.

### 2. Push Code

```bash
cd C:\P4NTH30N\OP3NF1XER\nate-alma\deploy
git remote add origin https://github.com/YOUR_USERNAME/openclaw-alma-v2.git
git branch -M main
git push -u origin main
```

### 3. Deploy to Railway

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your `openclaw-alma-v2` repository
4. Railway will automatically detect the `railway.toml` configuration

### 4. Configure Environment Variables

In Railway project settings, add:

**Required:**
- `SETUP_PASSWORD` - Your secure password for /setup access

**Optional:**
- `OPENCLAW_GATEWAY_TOKEN` - Secure random token (auto-generated if not set)
- `SSH_KNOWN_HOSTS` - Base64-encoded known_hosts for SSH
- `SSH_PRIVATE_KEY_ED25519` - Base64-encoded private key

### 5. Add Volume

In Railway:
1. Go to your service settings
2. Add a Volume mounted at `/data`
3. This persists OpenClaw state and SSH configuration

## SSH Key Information

**Public Key (add to authorized_keys on target servers):**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHzZLQF//hAbnC6oEBInFcCVyvH2aMsKHjReHDz+gY/ openclaw-alma-v2@op3nf1xer
```

**Private Key Location:** `ssh_key` (keep secure, do not commit to public repos)

## Files Added

- `Dockerfile` - Updated with OpenSSH client
- `scripts/ssh-setup.sh` - SSH configuration script
- `src/server.js` - Integrated SSH setup on startup
- `railway.toml` - Railway deployment configuration
- `.env.template` - Environment variable template
- `ssh_key` / `ssh_key.pub` - Generated SSH key pair

## Verification

After deployment, verify SSH is working:

```bash
# In Railway logs, you should see:
[wrapper] SSH directory: /data/.ssh
[wrapper] SSH ED25519 private key configured

# Check debug endpoint:
curl -u admin:SETUP_PASSWORD https://your-app.up.railway.app/setup/api/debug
```

## Support

- OpenClaw Documentation: https://docs.openclaw.ai
- Railway Documentation: https://docs.railway.app
- OP3NF1XER Governance: See P4NTHE0N/AGENTS.md
