# src/shared/

## Responsibility

Holds small, dependency-light helpers intended for use across plugin modules. Currently this directory provides utilities for parsing and summarizing `codemap.md` content.

## Design

- `codemap-utils.ts` defines a Zod-backed `Codemap` schema for structured codemap data.
- Parsing strategy:
  - Prefer a fenced JSON block inside markdown (```json ... ```).
  - Otherwise fall back to a minimal "sections found" heuristic.
- Summary helpers focus on extracting architecture-relevant fields for downstream injection or UI hints.

## Flow

1. Caller reads a `codemap.md` file.
2. `parseCodemap(content)` attempts JSON extraction + Zod validation.
3. If parsed, `extractArchitecturalSummary(codemap)` returns a short, architecture-focused string.
4. `hasArchitecturalContent(codemap)` gates whether the codemap is meaningful.

## Integration

- Not currently imported elsewhere in `src/` (as of this snapshot), but designed to support features like codemap summarization/injection.
