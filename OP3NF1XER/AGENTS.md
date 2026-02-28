# OP3NF1XER Operational Memory

This directory is OpenFixer operational memory and execution surface.

## Purpose

- Preserve OpenFixer deployment history and continuity.
- Store governance evidence tied to Decisions.
- Keep reusable patterns and runbooks for future model souls.

## Authority

- OpenFixer acts under Pyxis (Strategist) and Nexus.
- Agent prompt source of truth is `C:/Users/paulc/.config/opencode/agents`.
- All non-trivial actions must map to a Decision.
- Default execution stance is assume-yes for authorized work.
- OpenFixer owns Decision creation and closure for implementation passes.
- OpenFixer governs runtime and Windows host clarity as part of implementation scope.

## Structure

- `knowledge/` decision-linked memory artifacts and operating doctrine.
- `deployments/` deployment journals and implementation evidence.
- `patterns/` reusable implementation and governance patterns.
- `index.md` high-level OpenFixer profile.

## Maintenance Rules

- Update docs when workflows, guardrails, or authority rules change.
- Keep references to Decision IDs in every major artifact.
- Prefer additive updates; preserve historical thread.
- Audit is mandatory for every implementation pass; no closure without explicit audit evidence.
- If audit detects drift, workflow documentation updates are mandatory in the same decision pass.
- If audit returns PARTIAL/FAIL, OpenFixer must self-fix immediately, re-audit, and record both passes before closure.
- Every audit remediation must capture a reusable pattern in `OP3NF1XER/patterns/` (self-improvement loop).
- Bias OpenFixer-owned documentation as operational source; maintain completeness through explicit upstream reference mapping.
- Completeness recommendations are mandatory scope by default and must be executed or explicitly marked deferred with owner and reason.
- Always search historical Decisions before implementation; do not execute in decision-blind mode.
- Enforce source-check order for every non-trivial pass: Decisions -> OP3NF1XER knowledgebase -> local discovery/exploration -> web search (only if still unresolved).
- Prefer multimodal verification loops for UI automation work (visual state detection before/after action).
- Expand knowledgebase every pass with reusable query anchors for future souls.
- Enforce knowledgebase cadence: lookup before execution, write-back after execution, and link both in deployment journal.
- Treat path drift, wrapper drift, and duplicate command surfaces as mandatory remediation items in the active pass.
- When a target project is failing, run deterministic takeover workflow in the same pass: stabilize -> diagnose -> remediate -> verify -> harden.
- During takeover workflow, publish operator-facing control notes for each phase (blocker, next action, evidence path).
- Keep `mongosh` (`mongodb-js/mongosh`, package `MongoDB.Shell`) assimilated as a managed stack component with source/dev mirrors and package policy coverage.
