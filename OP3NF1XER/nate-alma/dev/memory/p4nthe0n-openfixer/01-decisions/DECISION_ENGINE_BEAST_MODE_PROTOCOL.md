# Strategist Decision Engine Beast Mode Protocol

Decision link: `DECISION_134`

## Objective

Make strategist decision operations fast, auditable, and self-improving for high-variance missions including external codebase inspections.

## Runtime Pipeline

1. Intake
2. Frame
3. Consult
4. Synthesize
5. Contract
6. Audit
7. Learn

## Required Outputs per Pass

- Decision markdown update in `STR4TEG15T/memory/decisions/`.
- Consultation evidence (or explicit assimilation note).
- Handoff contract with file-level target scope.
- Governance report with parity matrix and closure recommendation.
- Learning delta captured in decision or companion docs.

## External Codebase Audit Overlay

For third-party inspections (for example OpenClaw maintained by Alma):

- Run dual-lens analysis (`System Correctness`, `Change Governance`).
- Separate facts, assumptions, and open questions.
- Prefer advisory-first recommendations with reversible remediation stages.

## Efficiency Guardrails

- Default single consultation round.
- Maximum two rounds unless Nexus requests extended deliberation.
- Decision skeleton first, deep detail only when risk/impact requires it.

## Closure Gate

No closure when any requirement is `PARTIAL` or `FAIL` without same-pass remediation and re-audit evidence.
