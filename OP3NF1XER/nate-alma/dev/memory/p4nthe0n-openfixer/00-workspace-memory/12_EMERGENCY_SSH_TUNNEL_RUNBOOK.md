# Emergency SSH Tunnel Runbook

Primary access is now Railway SSH (no redeploy required). The `tmate` path remains a fallback pattern for future images.

## Why this exists

We need direct operator shell access to apply OpenClaw configuration changes without triggering new deploys.

## Preconfigured direct SSH (active)

Use the helper script with pinned IDs:

`scripts/railway-ssh.ps1`

- Project: `1256dcd2-0929-417a-8f32-39137ffa523b`
- Service: `2224d9e4-80a7-49d5-b2d4-cf37385fc843`
- Environment: `3ba89542-4d69-44cf-9a98-92f0058c30aa`

Examples:

```powershell
# interactive shell
powershell -File scripts/railway-ssh.ps1

# run one command remotely
powershell -File scripts/railway-ssh.ps1 -Command "openclaw --version"

# persistent tmux session on Railway side
powershell -File scripts/railway-ssh.ps1 -Session -SessionName ops
```

For common config operations, use:

`scripts/openclaw-config-over-ssh.ps1`

```powershell
# check status
powershell -File scripts/openclaw-config-over-ssh.ps1 -Action status

# get a config key
powershell -File scripts/openclaw-config-over-ssh.ps1 -Action get -Path channels.telegram

# set a scalar config key
powershell -File scripts/openclaw-config-over-ssh.ps1 -Action set -Path gateway.bind -Value loopback

# set a JSON config key
powershell -File scripts/openclaw-config-over-ssh.ps1 -Action set-json -Path gateway.trustedProxies -Value '["127.0.0.1"]'
```

## tmate fallback (requires image support)

If Railway SSH is unavailable in a future incident, use the Setup UI `ssh.tmate.*` flow after an image that includes `tmate` is deployed.

## How to use (tmate fallback)

1. Open `/setup` and authenticate.
2. In **Debug console**, run `ssh.tmate.start`.
3. Copy the returned command (`ssh ...@...`) and run it locally.
4. When done, run `ssh.tmate.stop`.

## Console commands (tmate fallback)

- `ssh.tmate.start` - starts or reuses a relay session.
- `ssh.tmate.status` - prints current SSH/Web endpoints.
- `ssh.tmate.stop` - terminates relay session.

## Security posture

- Access is protected behind `SETUP_PASSWORD` auth.
- Railway SSH is authenticated through Railway account access control.
- Session is ephemeral and not started automatically.
- Explicit stop command is provided for teardown.
