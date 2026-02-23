---
description: DEPRECATED - Use @openfixer instead. This prompt is no longer active. - CODEMAP (DEPRECATED)
mode: subagent
codemapVersion: "1.0"
directory: DEPRECATED
deprecated: true
replacement: openfixer
---

# DEPRECATED Codemap - Fixer

## ⚠️ DEPRECATED

This agent has been deprecated per **DECISION_087 Phase 2**.

## Replacement

Use **@openfixer** for all implementation tasks:
- External directory edits
- CLI operations (dotnet, npm, git)
- Configuration updates
- System-level changes

## Migration Path

All references to @fixer should be updated to @openfixer.
See `agents/openfixer.md` for current implementation agent documentation.

## Historical Directory

This was previously mapped to the Fixer agent domain:
- Original scope: General implementation tasks
- Replaced by: @openfixer (external/CLI), @windfixer (bulk P4NTH30N)

---

*Deprecated: 2026-02-22*
*Per: DECISION_087 Phase 2 - Agent Prompt Enhancement*

This Fixer prompt has been deprecated per DECISION_087 Phase 2.

## Replacement

Use **@openfixer** for all implementation tasks:
- External directory edits
- CLI operations (dotnet, npm, git)
- Configuration updates
- System-level changes

## Migration

All references to @fixer should be updated to @openfixer.
Orchestrator has been updated to use OpenFixer exclusively.

## Directory, Documentation, and RAG Policy

- This prompt is deprecated and must not be used for new work.
- Active replacement is `@openfixer` with outputs under `OP3NF1XER/`.
- Documentation and RAG ingestion requirements are enforced by `agents/openfixer.md`.

---

*Deprecated: 2026-02-22*
*Per: DECISION_087 Phase 2 - Agent Prompt Enhancement*
