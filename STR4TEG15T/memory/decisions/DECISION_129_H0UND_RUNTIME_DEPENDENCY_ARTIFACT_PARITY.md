---
type: decision
id: DECISION_129
category: FORGE
status: completed
version: 1.0.0
created_at: '2026-02-24T23:05:00Z'
last_reviewed: '2026-02-24T23:18:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_129_H0UND_RUNTIME_DEPENDENCY_ARTIFACT_PARITY.md
---
# DECISION_129: H0UND Runtime Dependency Artifact Parity

**Decision ID**: DECISION_129  
**Category**: FORGE  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-24

## Context

Nexus reported `P4NTH30N.exe` failing at launch from `OneDrive/Desktop/build/H0UND/bin/Release/net10.0-windows7.0` with `System.IO.FileNotFoundException` for `MongoDB.Bson, Version=3.6.0.0`.

Historical recall applied before implementation:

- `DECISION_122` runtime startup audit and deterministic path control.
- `DECISION_123` runtime policy hardening and anti-drift expectations.
- `DECISION_126` mandatory source-check order.
- `DECISION_128` environment clarity and confusion-reduction mandate.

## Decision

Restore deterministic runnable artifact parity for H0UND so the canonical build artifact path includes required runtime dependencies, including MongoDB package assemblies.

## Implementation Plan

1. Validate current build/output routing for H0UND and dependency copy behavior.
2. Apply minimal configuration fix to remove artifact-path drift between runnable output and build artifact output.
3. Rebuild and verify `MongoDB.Bson.dll` presence and executable startup behavior in the OneDrive build path.

## Implementation

- Updated output-routing policy to remove H0UND-only local output override that diverged from canonical build artifact path:
  - `Directory.Build.props`
- Pinned dependency copy behavior at project level for H0UND executable output:
  - `H0UND/H0UND.csproj` with `<CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>`
- Rebuilt H0UND release and validated dependency presence in:
  - `C:/Users/paulc/OneDrive/Desktop/build/H0UND/bin/Release/net10.0-windows7.0`

## Validation Evidence

- Build command completed successfully for H0UND release.
- `MongoDB.Bson.dll` present in OneDrive artifact path.
- `MongoDB.Driver.dll` present in OneDrive artifact path.
- Smoke launch of `P4NTHE0N.exe` from OneDrive artifact path reached runtime dashboard (no `MongoDB.Bson` load failure).

## Execution Notes (Source-Check Order)

1. Decisions recalled first: `DECISION_122`, `DECISION_123`, `DECISION_126`, `DECISION_128`.
2. Knowledgebase/pattern lookup completed before local discovery:
   - `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`
   - `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
3. Local discovery executed after recall/lookup (project output routing + runtime dependency checks).
4. Post-implementation write-back completed:
   - `OP3NF1XER/knowledge/RUNTIME_CONTROL_BASELINE.md`
   - `OP3NF1XER/patterns/ENVIRONMENT_CLARITY_LOOP.md`

## Decision Parity Matrix

- Runtime executable in OneDrive artifact path must include MongoDB dependency assemblies: **PASS**
- Launch from OneDrive artifact path must not throw `MongoDB.Bson` `FileNotFoundException`: **PASS**
- Environment clarity (single canonical runnable artifact path for H0UND release): **PASS**

## Closure Recommendation

`Close` - no blocker remains for the reported startup failure.
