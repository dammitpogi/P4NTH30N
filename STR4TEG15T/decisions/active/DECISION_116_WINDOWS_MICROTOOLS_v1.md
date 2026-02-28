# DECISION_116 Windows Micro-Tools Strategy v1

**Version**: v1  
**Parent Decision**: `STR4TEG15T/decisions/active/DECISION_116.md`  
**Date**: 2026-02-23

## Strategic Question

What are the best ways to build micro tools for workflow assistance in a Windows environment that provide flexibility for agents, with easy debugging and scope expansion?

## Recommended Stack (Practical Baseline)

1. **TypeScript + Bun for orchestration CLIs**
   - Fast iteration, strong typing, easy JSON/file processing, consistent with existing repo tooling.
   - Good for indexers, report generators, decision validators, and migration planners.

2. **PowerShell for Windows-native automation boundaries**
   - Best for filesystem/admin integration, scheduled tasks, process control, and deployment glue.
   - Keep PS scripts thin and delegate logic to TS binaries where possible.

3. **C# only when runtime/perf or deep Windows integration is required**
   - Use for long-running services, heavy concurrency, or integration with existing C# systems.
   - Avoid for small workflow helpers where script/binary overhead is not justified.

## Development Philosophy

- **Hexagonal micro-tooling**: separate command interface, domain logic, and adapters.
- **Single-purpose tools**: each tool solves one workflow unit (index, validate, compact, reconcile).
- **Composable chain**: tools should be pipeable and JSON-first for agent-to-agent interoperability.
- **Observable by default**: structured logs, dry-run mode, deterministic exit codes.
- **Idempotent operations**: reruns should be safe.

## Debug and Expansion Model

- Include `--dry-run`, `--verbose`, and `--trace-id` in every operational tool.
- Use schema validation (zod or equivalent) at tool boundaries.
- Maintain small golden test fixtures for decisions/manifest samples.
- Emit machine-readable reports (`.json`) and human summaries (`.md`).
- Version behavior flags to allow incremental expansion without breaking old flows.

## Agent Flexibility Patterns

- Prefer file-path and stdin/stdout interfaces over hardcoded env dependencies.
- Keep config in declarative JSON/TOML files under `STR4TEG15T/memory/`.
- Design tools to run in three modes:
  - `check` (audit only),
  - `plan` (proposed changes),
  - `apply` (actual changes).

## Governance Safeguards

- Add a pre-deploy benefit check: expected token/time savings vs maintenance burden.
- If ROI is unclear, keep solution in inquiry mode and defer build action.
- Require companion decision notes for any tool expected to become long-lived infra.

## Suggested First Micro-Tools

1. `decision-status-indexer` (build status index from decision files)
2. `manifest-compactor` (snapshot + archive + checksum catalog)
3. `manifest-integrity-check` (replay vs materialized view diff)
4. `decision-audit-packager` (collect closure evidence paths)
