# JOURNAL_2026-02-24_DECISION_114_PERMISSION_GATE

Date: 2026-02-24
Mode: Deployment
Decision: `DECISION_114`
Status: HandoffReady (blocked on OpenCode ask-permission provenance)

## Objective

Configure OpenCode permission-gate behavior so strategist deletion tests produce OpenCode-originated ask/allow evidence with minimal workflow disruption.

## Configuration Change

Updated file:
- `C:\Users\paulc\.config\opencode\opencode.json`

Updated node:
- `agent.strategist.permission.bash`

Before:
- `*`: `deny`
- git command allowlist only

After:
- `*`: `deny` (unchanged)
- added deletion ask rules:
  - `rm *`: `ask`
  - `del *`: `ask`
  - `Remove-Item *`: `ask`
- existing git allowlist retained unchanged

## Rationale and Tradeoffs

- Rationale: satisfy DECISION_114 provenance requirement by forcing OpenCode ask events on strategist deletion commands.
- Least-disruptive: retains strict deny-by-default shell policy and current strategist editing workflow.
- Tradeoff: provenance requires deletion attempts through matching shell commands; non-shell deletion paths do not provide the same ask-event guarantee.
- Reversible: remove the three ask-rule entries to revert behavior.

## Deterministic Re-Test Procedure

1. Record target path, reason, and risk in `STR4TEG15T/decisions/active/DECISION_114.md`.
2. Execute deletion attempt with strategist using a matching command (for example `rm "<path>"`).
3. Verify OpenCode emits permission ask prompt (allow/deny gate appears).
4. Capture Nexus decision from that OpenCode prompt.
5. Record result evidence and outcome in decision + journal artifacts.
6. Only then mark deletion provenance gate complete.

## Recommendation

- Keep DECISION_114 as `HandoffReady` until the re-test is executed and OpenCode-originated ask/allow evidence is captured for deletion protocol validation.
