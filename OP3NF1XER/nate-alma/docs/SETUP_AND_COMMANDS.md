# Setup And Commands

## Prerequisites

- Railway CLI installed and authenticated (`railway whoami`).
- PowerShell available.
- Python available (used by pull decode path).
- Target config present at `../dev/config/railway-target.json`.

## Core Commands

```powershell
# 1) SSH probe
powershell -NoProfile -File dev/tools/railway-ssh.ps1 -Command "openclaw --version"

# 2) OpenClaw status
powershell -NoProfile -File dev/tools/openclaw-config-over-ssh.ps1 -Action status

# 3) Pull snapshot before any mutation
powershell -NoProfile -File dev/tools/pull-remote-state.ps1 -Label pre-change

# 4) Config read
powershell -NoProfile -File dev/tools/openclaw-config-over-ssh.ps1 -Action get -Path channels.telegram

# 5) Config write (high risk)
powershell -NoProfile -File dev/tools/openclaw-config-over-ssh.ps1 -Action set -Path gateway.bind -Value loopback

# 5b) Gateway lock diagnosis (safe)
powershell -NoProfile -File dev/tools/openclaw-config-over-ssh.ps1 -Action gateway-probe -TraceId "gw-probe-001"

# 5c) Gateway lock remediation (only when restart is needed)
powershell -NoProfile -File dev/tools/openclaw-config-over-ssh.ps1 -Action gateway-stop -TraceId "gw-stop-001"

# 6) Push dry-run first
powershell -NoProfile -File dev/tools/push-remote-bundle.ps1 -Bundle srv/push/my-bundle.tar.gz

# 7) Push apply
powershell -NoProfile -File dev/tools/push-remote-bundle.ps1 -Bundle srv/push/my-bundle.tar.gz -Apply
```

## TraceId Usage

Always set a TraceId for auditable operations.

```powershell
powershell -NoProfile -File dev/tools/pull-remote-state.ps1 -Label pre-change -TraceId "incident-20260225-a"
```

Logs are written to `../srv/logs`.
