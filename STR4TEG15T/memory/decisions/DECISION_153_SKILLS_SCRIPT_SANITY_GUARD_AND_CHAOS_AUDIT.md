---
type: decision
id: DECISION_153
category: INFRA
status: completed
version: 1.0.0
created_at: '2026-02-25T01:10:00Z'
last_reviewed: '2026-02-25T01:40:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_153_SKILLS_SCRIPT_SANITY_GUARD_AND_CHAOS_AUDIT.md
---
# DECISION_153: Skills Script Sanity Guard and Chaos Audit

**Decision ID**: DECISION_153  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-25

## Context

Nexus requested full skills-directory analysis for script chaos and runtime hardening so scripts emit verbose debug signals and expose mangled data/mutations before breaking.

## Historical Decision Recall

- `DECISION_150`: deployment/audit evidence contract.
- `DECISION_152`: auth-vault linkage and encryption expansion.

## Decision

1. Build a deterministic runtime guard wrapper for scripts in `OP3NF1XER/nate-alma/dev/skills`.
2. Build a chaos audit scanner across all scripts that emits `[PASS]/[WARNING]` findings.
3. Add preflight sanity checks (syntax/readability/shebang/executable/relative-path risk) and mutation detection evidence.
4. Document operator usage so Alma can run guardrails before executing any skill script.

## Acceptance Requirements

1. A reusable sanity runner exists and prints verbose `[PASS]/[WARNING]` checks.
2. A full-directory chaos audit tool exists and reports findings for all scripts.
3. Tools run successfully against the current `skills/` tree and produce evidence outputs.
4. AGENTS/skill docs include usage guidance for debug and preflight workflows.

## Implementation

- Added new skill: `OP3NF1XER/nate-alma/dev/skills/script-sanity-kit/SKILL.md`.
- Added runtime guard wrapper:
  - `OP3NF1XER/nate-alma/dev/skills/script-sanity-kit/scripts/run_with_sanity.py`
  - preflight checks: readability, hash fingerprint, syntax check by extension, command echo, runtime stream capture, mutation detection.
- Added full chaos scanner:
  - `OP3NF1XER/nate-alma/dev/skills/script-sanity-kit/scripts/chaos_audit.py`
  - scans all scripts under `skills/` and emits `[PASS]/[WARNING]` findings.
  - writes machine-readable report artifact via `--json-out`.
- Updated operator docs to enforce usage:
  - `OP3NF1XER/nate-alma/dev/AGENTS.md`
  - `OP3NF1XER/nate-alma/dev/TOOLS.md`

## Validation Evidence

- `python -m py_compile skills/script-sanity-kit/scripts/chaos_audit.py` -> pass
- `python -m py_compile skills/script-sanity-kit/scripts/run_with_sanity.py` -> pass
- `python skills/script-sanity-kit/scripts/chaos_audit.py --json-out skills/script-sanity-kit/reports/latest-chaos-audit.json`
  - scripts scanned: `70`
  - pass checks: `158`
  - warning checks: `116`
  - report path: `skills/script-sanity-kit/reports/latest-chaos-audit.json`
- `python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/auth-vault/scripts/vault.py -- doctor` -> child exit `0`
- `python skills/script-sanity-kit/scripts/run_with_sanity.py --script skills/model-switcher/scripts/switch.sh -- sonnet` -> child exit `0`

## Decision Parity Matrix

- Reusable sanity runner with verbose PASS/WARNING output: **PASS**
- Full-directory chaos audit reporting all scripts: **PASS**
- Runtime evidence generated against current skills tree: **PASS**
- AGENTS/skill docs updated for operator debug workflows: **PASS**

## Closure Recommendation

`Close` - runtime sanity tooling and full skills-lane chaos audit are operational.
