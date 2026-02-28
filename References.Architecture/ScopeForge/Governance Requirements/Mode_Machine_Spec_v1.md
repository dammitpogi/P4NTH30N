# Mode Machine Spec (v1)

## Modes
- **Normal**: Standard execution with allowlisted tools.
- **Constrained**: Read-only mode; no writes or external calls.
- **Evidence**: Capture-only; emit capsule and stop.

## Transition Triggers
- **Normal → Constrained**: policy risk, failed validation, or rate-limit breach.
- **Normal → Evidence**: blocked action or non-bypass rule triggered.
- **Constrained → Evidence**: repeated violations or unresolvable block.
- **Constrained → Normal**: explicit approval + cleared risk.

## Invariants
- Mode changes are logged to Vault with timestamp and actor.
- Evidence mode terminates further tool execution.
- Blocked actions **must** emit a Revision Capsule before stopping.

## Output Requirements
- Every mode transition includes: `from`, `to`, `trigger`, `ruleId`, and `evidenceRefs`.
