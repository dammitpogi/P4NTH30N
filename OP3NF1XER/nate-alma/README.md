# Nate-Alma Control Plane

This directory is the local control plane for maintaining Nate's OpenClaw Railway deployment without redeploys.

## Layout

- `dev/config/railway-target.json` - pinned Railway target IDs.
- `tools/railway-ssh.ps1` - SSH entrypoint.
- `tools/openclaw-config-over-ssh.ps1` - OpenClaw config operations over SSH.
- `tools/pull-remote-state.ps1` - environment pull (snapshot archive).
- `tools/push-remote-bundle.ps1` - environment push (bundle import).
- `docs/` - full operator and governance documentation set.
- `srv/pulls/` - pulled archives from remote.
- `srv/push/` - prepared bundles to apply to remote.
- `srv/logs/` - per-run trace logs keyed by `TraceId`.
- `srv/state/` - continuity checkpoint for next-session resume.

## Quick Start

```powershell
# command probe
powershell -NoProfile -File tools/railway-ssh.ps1 -Command "openclaw --version"

# config check
powershell -NoProfile -File tools/openclaw-config-over-ssh.ps1 -Action get -Path channels.telegram

# pull state snapshot
powershell -NoProfile -File tools/pull-remote-state.ps1 -Label pre-change

# push bundle (dry-run)
powershell -NoProfile -File tools/push-remote-bundle.ps1 -Bundle srv/push/example.tar.gz

# push bundle (apply)
powershell -NoProfile -File tools/push-remote-bundle.ps1 -Bundle srv/push/example.tar.gz -Apply
```

## Operating Rule

Always pull a snapshot before any remote mutation and keep artifacts in `srv/pulls/`.

## Documentation

- `docs/INDEX.md`
- `docs/SETUP_AND_COMMANDS.md`
- `docs/OPERATIONS_RUNBOOK.md`
- `docs/FAILURE_TRACEABILITY.md`
- `docs/SESSION_CONTINUITY.md`
- `docs/DECISION_142_GOVERNANCE.md`
