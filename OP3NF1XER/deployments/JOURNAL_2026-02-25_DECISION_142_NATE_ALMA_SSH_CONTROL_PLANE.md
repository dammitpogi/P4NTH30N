# JOURNAL_2026-02-25_DECISION_142_NATE_ALMA_SSH_CONTROL_PLANE

## Decision

- `DECISION_142`

## Scope

- Build SSH-first control plane under `OP3NF1XER/nate-alma` for no-redeploy maintenance of Nate's Railway OpenClaw deployment.

## Decision Parity Matrix

- R1 SSH helper can execute remote commands: **PASS**
- R2 Pull helper can export remote deployment state: **PASS**
- R3 Push helper can apply local artifact bundles remotely: **PASS**
- R4 Nate-Alma directory includes operator usage docs: **PASS**
- R5 Governance continuity artifacts are updated: **PASS**
- R6 Verbose console logging at failure points is default methodology: **PASS**
- R7 Session continuity checkpointing for resume is implemented: **PASS**
- R8 Self-learning workflow update mandate is codified: **PASS**

## File-Level Diff Summary

- Added pinned target config at `OP3NF1XER/nate-alma/dev/config/railway-target.json`.
- Added SSH execution helper at `OP3NF1XER/nate-alma/dev/tools/railway-ssh.ps1`.
- Added config operations helper at `OP3NF1XER/nate-alma/dev/tools/openclaw-config-over-ssh.ps1`.
- Added pull helper with base64-safe transport at `OP3NF1XER/nate-alma/dev/tools/pull-remote-state.ps1`.
- Added push helper with chunked base64 upload/apply at `OP3NF1XER/nate-alma/dev/tools/push-remote-bundle.ps1`.
- Added operator docs at `OP3NF1XER/nate-alma/README.md` and `OP3NF1XER/nate-alma/dev/DELIVERABLE_GOVERNANCE.md`.
- Added storage anchors at `OP3NF1XER/nate-alma/srv/pulls/.gitkeep` and `OP3NF1XER/nate-alma/srv/push/.gitkeep`.
- Added verbose trace logging and risk markers to:
  - `OP3NF1XER/nate-alma/dev/tools/railway-ssh.ps1`
  - `OP3NF1XER/nate-alma/dev/tools/openclaw-config-over-ssh.ps1`
  - `OP3NF1XER/nate-alma/dev/tools/pull-remote-state.ps1`
  - `OP3NF1XER/nate-alma/dev/tools/push-remote-bundle.ps1`
- Added session continuity checkpoints under `OP3NF1XER/nate-alma/srv/state/continuity.json`.
- Added reusable pattern: `OP3NF1XER/patterns/NATE_ALMA_SSH_PUSH_PULL_CONTROL_PLANE.md`.
- Added learning write-back: `OP3NF1XER/knowledge/DECISION_142_NATE_ALMA_SSH_CONTROL_PLANE_2026_02_25.md`.
- Updated OpenFixer source-of-truth agent policy with failure-point logging and continuity mandates at `C:/Users/paulc/.config/opencode/agents/openfixer.md`.

## Deployment Usage Guidance

1. Probe SSH:
   - `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/railway-ssh.ps1 -Command "openclaw --version"`
2. Pull snapshot:
   - `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/pull-remote-state.ps1 -Label pre-change`
3. Apply config commands:
   - `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/openclaw-config-over-ssh.ps1 -Action get -Path channels.telegram`
4. Push bundle:
   - Dry-run: `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/push-remote-bundle.ps1 -Bundle <path>`
   - Apply: `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/push-remote-bundle.ps1 -Bundle <path> -Apply`

## Triage and Repair Runbook

- Detect:
  - SSH command fails or setup status degrades.
- Diagnose:
  - Run `openclaw status`, `openclaw doctor`, and `/setup/api/status`.
- Recover:
  - Re-apply known-good bundle or use setup restore path.
  - If push fails, re-run dry-run then apply with smaller probe bundle first.
- Verify:
  - `openclaw --version` succeeds.
  - `/setup/api/status` returns `configured:true`.
  - Telegram channel remains enabled.

## Validation Commands + Results

- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/railway-ssh.ps1 -Command "openclaw --version"` -> `2026.2.9`
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/openclaw-config-over-ssh.ps1 -Action status` -> OpenClaw status table rendered.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/pull-remote-state.ps1 -Label smoke3` -> snapshot archive created.
- `tar -tf OP3NF1XER/nate-alma/srv/pulls/nate-alma-smoke3-20260224-212134.tar.gz` -> archive listing valid.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/push-remote-bundle.ps1 -Bundle OP3NF1XER/nate-alma/srv/push/probe-bundle.tar.gz -Apply` -> completed.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/railway-ssh.ps1 -Command "ls -l /tmp/nate-alma-probe.txt"` -> probe file present remotely.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/railway-ssh.ps1 -Command "openclaw --version" -TraceId "trace-ssh-001"` -> trace log with INFO lifecycle.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/openclaw-config-over-ssh.ps1 -Action get -Path channels.telegram -TraceId "trace-cfg-001"` -> trace log + command pass.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/pull-remote-state.ps1 -Label trace -TraceId "trace-pull-001"` -> trace log + archive output.
- `powershell -NoProfile -File OP3NF1XER/nate-alma/dev/tools/push-remote-bundle.ps1 -Bundle OP3NF1XER/nate-alma/srv/push/probe-bundle.tar.gz -Apply -TraceId "trace-push-apply-001"` -> trace log + remote apply pass.
- `ls OP3NF1XER/nate-alma/srv/logs && ls OP3NF1XER/nate-alma/srv/state` -> trace logs and continuity checkpoint present.

## Closure Recommendation

- **DECISION_142**: `Close`
- Blockers: none.
