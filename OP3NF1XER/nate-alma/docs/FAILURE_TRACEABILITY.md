# Failure Traceability

## Logging Standard

All tools use severity-tagged traces:

- `INFO` - normal lifecycle progress.
- `WARN` - non-fatal condition.
- `ERROR` - hard failure with immediate stop.
- `RISK` - high-impact mutation point.

Each run should include a `TraceId`.

## High-Risk Failure Points

1. **Wrong Railway target**
   - Symptom: command executes against wrong service.
   - Control: startup logs print project/service/environment IDs.

2. **Pull corruption over SSH transport**
   - Symptom: invalid tar/gzip on local machine.
   - Control: marker-framed base64 payload with explicit decode gate.

3. **Partial push upload**
   - Symptom: apply fails mid-transfer.
   - Control: chunked upload + progress logs + fail-fast chunk index.

4. **Remote extract side effects**
   - Symptom: unexpected runtime state changes.
   - Control: dry-run first, explicit `RISK` markers before apply.

5. **Session interruption**
   - Symptom: unclear restart point in next session.
   - Control: continuity checkpoint writes phase/status/details.

## Log Locations

- Trace logs: `../srv/logs`
- Continuity: `../srv/state/continuity.json`
