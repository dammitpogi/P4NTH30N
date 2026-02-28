# ScopeForge Home — Scope Statement + Non-Goals (v1)

## Purpose
Define the durable scope of “Home” as the canonical governance bundle for ScopeForge.
Home is **not** an app. It is the minimum, enforceable set of artifacts that make behavior replayable, auditable, and hard to supersede.

## Scope (in-scope)
- **Canon + Policy**: Instruction hierarchy, authority boundaries, and non-bypass rules.
- **Forge State**: Operational workflow metadata (plans, proposals, mode transitions).
- **Vault Evidence**: Append-only run evidence for reconstruction and audit.
- **Runner + Tool Gateway**: Execution orchestration with deny-by-default tooling.
- **Distribution/Sync**: File-backed continuity and replayable bundle distribution.

## Non-Goals (out-of-scope)
- Building a monolithic application or platform UI.
- Granting models any persistence or authority.
- Centralizing trust in a single server or cloud service.
- Hidden background data collection or surveillance.
- Mutable history, silent rewrites, or unverifiable edits.

## Core Principles
- **Replayability**: Every run is reconstructable from Vault evidence.
- **Monotonicity**: Versioned, append-only changes; no silent rewrites.
- **Separation of Roles**: Models propose; infra enforces.
- **Deny-by-default**: Tools and persistence are explicitly allowed or rejected.
- **Local truth**: Canon + Forge + Vault are the source of truth, not a server.
