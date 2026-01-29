# P4NTH30N Agent Conventions

This file defines project-wide conventions for structure, naming, and behavior. These rules apply to the entire repo unless overridden by a nested `AGENTS.md`.

## 1. Structure & ownership

Prefer **object-centric behavior**:
- Domain entities should contain behavior directly related to their state.
- If behavior grows large, extract **domain services** or **automation services** in a dedicated folder.

Recommended folder layout (when adding new code):

```
/Domain
  /Entities
  /ValueObjects
  /Services
/Application
  /UseCases
  /Selectors
  /Schedulers
/Infrastructure
  /Persistence
  /Automation
  /Integrations
```

> This layout is a guide; reorganization is allowed and encouraged when it improves clarity or maintainability. Document intent, scope, and rollback notes to keep lineage intact.

## 2. Naming conventions

- Avoid ambiguous file names such as `* copy.cs`. Use explicit names:
  - `New*` → place under a `Migration` or `V2` namespace/folder.
  - `Legacy*` → mark deprecated behavior.
- Types should follow **PascalCase**.
- MongoDB collection names should be documented when added or changed.

## 3. Domain boundaries

- **C0MMON** is the shared library for:
  - Entities, storage models, and shared automation helpers.
  - Shared primitives (`Mouse`, `Keyboard`, `Screen`).
- **H4ND / HUN7ER** are app-level processes and should avoid deep domain logic.

## 4. Migration guidance

When introducing new entity models (e.g., `NewCredential`):
- Provide adapters/selectors so old + new can run side-by-side.
- Prefer a **feature flag** or config switch to control cutover.
- Leave legacy code in place until new flow is verified and stable.

## 5. Documentation requirements

When implementing:
- Document **intent** and **edge cases** close to the code.
- If adding new collections or indexes, update schema docs (or create if absent).

## 6. Safety + automation

- Keep all pixel coordinates and UI assumptions close to the owning game helper.
- Never embed secrets in code or docs.
- If a change impacts automated flow, note rollback steps in the commit or PR summary.
