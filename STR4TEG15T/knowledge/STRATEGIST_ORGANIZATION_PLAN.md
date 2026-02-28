# Strategist Organization Plan

Decision link: `DECISION_125`

## Objective

Reduce strategist directory ambiguity while preserving historical continuity.

## Canonical Rules

1. Decision source of truth: `STR4TEG15T/memory/decisions`.
2. Strategy overlays: `actions/`, `handoffs/`, `consultations/`, `intel/`.
3. Large tool codebases in `tools/` are excluded from default decision search.

## Cleanup Strategy

- Non-destructive organization only.
- Normalize active docs to `P4NTHE0N` naming.
- Add governance docs rather than rewriting historical decision records.
- Require decision-search step before implementation plan issuance.

## Verification

- `dotnet sln C:\P4NTH30N\P4NTHE0N.slnx list`
- `dotnet build C:\P4NTH30N\STR4TEG15T\STR4TEG15T.csproj -nologo`
