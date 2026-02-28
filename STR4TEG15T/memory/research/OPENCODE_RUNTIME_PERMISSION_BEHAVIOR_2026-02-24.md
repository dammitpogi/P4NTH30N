# OpenCode Runtime Permission Behavior (2026-02-24)

Operational knowledge captured from Nexus during DECISION_114 permission-gate remediation.

## Observations

- OpenCode permission configuration is cached at runtime and loaded at startup.
- Config changes in `C:\Users\paulc\.config\opencode\opencode.json` may not apply until OpenCode is restarted.
- Deletion ask-permission behavior should be validated after restart when testing new permission rules.

## Reliability Pattern

- Keep two OpenCode instances as resilience pattern during config experimentation:
  - one instance for applying/testing updated config,
  - one fallback cached instance to assist recovery if startup config becomes invalid.

## Decision Impact

- Use startup-aware validation sequencing in permission-gate decisions.
- For permission audits, include explicit "restart then retest" step before determining pass/fail.
- Capture provenance evidence only from OpenCode-originated ask events after runtime refresh.

## Linked Decision

- `STR4TEG15T/decisions/active/DECISION_114.md`
