# Operations Runbook

## 1) Detect

- SSH probe fails.
- `openclaw status` reports degraded channels.
- `/setup/api/status` is not `configured:true`.
- gateway log reports `gateway already running` / lock timeout.

## 2) Diagnose

1. Run:
   - `openclaw --version`
   - `openclaw status`
   - `openclaw doctor`
2. Check logs in `../srv/logs` by TraceId.
3. Identify failure phase from continuity file:
   - `../srv/state/continuity.json`
4. For gateway lock contention, run:
   - `powershell -NoProfile -File dev/tools/openclaw-config-over-ssh.ps1 -Action gateway-probe -TraceId "gw-probe-<id>"`

## 3) Recover

1. Pull fresh snapshot first.
2. Use config helper for controlled key-level fixes.
3. If state drift is broad, apply a known-good tar bundle via push helper.
4. Re-run health probes.
5. For lock contention specifically:
   - If probe shows gateway reachable, do not start again.
   - If restart is required, run `gateway-stop`, then re-check `status`.
   - Note: in non-systemd environments, `gateway-stop` may report service-stop
     failure; tooling now treats that as an allowed failure and immediately
     runs `gateway-probe` for effective state confirmation.

## 4) Verify

- `openclaw --version` succeeds.
- `openclaw status` shows Telegram enabled/OK.
- `/setup/api/status` returns `configured:true`.

## 5) Record

- Update Decision file.
- Update deployment journal.
- Write learning delta to knowledge/patterns.

Do not close while any validation gate fails.
