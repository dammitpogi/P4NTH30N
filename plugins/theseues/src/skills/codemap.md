# src/skills/

## Responsibility

Holds skill assets that ship with the plugin repository (markdown skill definitions and any bundled helper scripts). These files are intended to be copied/installed into an OpenCode skills directory so the Orchestrator can follow deterministic workflows (for example: cartography).

## Design

- Each skill lives in its own subdirectory and typically includes:
  - `SKILL.md`: machine-readable skill entrypoint (frontmatter + workflow).
  - `README.md`: human-facing overview and usage examples.
  - `scripts/`: optional helpers executed via the Orchestrator (e.g., `cartographer.py`).
- Skill content is documentation/data; it is not part of the plugin runtime TypeScript execution path.

## Flow

1. A user invokes a skill by name.
2. OpenCode loads the matching `SKILL.md` content.
3. The Orchestrator runs any prescribed commands (often via `bash`) and coordinates any agent delegation required by the workflow.

## Integration

- Skills are consumed by OpenCode at runtime via the skills loader (external to this repository).
- This repository bundles a cartography skill under `src/skills/cartography/`.
