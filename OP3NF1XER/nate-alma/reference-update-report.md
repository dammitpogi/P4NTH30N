# Reference Update Report - DECISION_164

**Date**: 2026-02-26  
**Mutation Timestamp**: 20260226_175442

## Files Changed

### 1. `dev/skills/doctrine-engine/SKILL.md`
**Path**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/skills/doctrine-engine/SKILL.md`

**Replacements**:
- `/data/workspace/memory/alma-teachings/index.json` → `/data/workspace/memory/alma-teachings/bible/_manifest/manifest.json`

**Context**: Updated primary index entrypoint reference

---

### 2. `dev/memory/alma-teachings/AGENTS.md`
**Path**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/alma-teachings/AGENTS.md`

**Replacements**:
- `OP3NF1XER/nate-alma/dev/memory/substack` → `OP3NF1XER/nate-alma/dev/memory/alma-teachings/substack` (2 occurrences)

**Context**: Updated corpus root references

---

### 3. `dev/memory/alma-teachings/README.md`
**Path**: `C:/P4NTH30N/OP3NF1XER/nate-alma/dev/memory/alma-teachings/README.md`

**Action**: Complete rewrite to reflect new structure

**New content**:
- Documented `bible/` as Index v4 root with `_manifest/manifest.json` entrypoint
- Documented `substack/` as primary corpus (340+ articles)
- Documented `legacy/` directory structure
- Removed stale parity synthesis content
- Updated all source doctrine references

---

### 4. `STR4TEG15T/memory/decisions/DECISION_161_REMEDIATION_001.md`
**Path**: `C:/P4NTH30N/STR4TEG15T/memory/decisions/DECISION_161_REMEDIATION_001.md`

**Replacements**:
- `alma-teachings/bible/*.md` → `alma-teachings/substack/*.md` (2 occurrences, search commands)
- `alma-teachings/index/bible-aliases.json` → `alma-teachings/bible/bible-aliases.json`

**Context**: Updated example commands and file paths in remediation decision

---

## Summary

- **Total files modified**: 4
- **Total path replacements**: 6
- **Complete rewrites**: 1 (README.md)

## Path Migration Matrix

| Old Path | New Path | Reason |
|----------|----------|--------|
| `alma-teachings/bible/` | `alma-teachings/substack/` | Corpus (341 markdown files) |
| `alma-teachings/index/` | `alma-teachings/bible/` | Index v4 contract root |
| `dev/memory/substack/` | *(merged into `alma-teachings/substack/`)* | Deduplication |
| `alma-teachings/index.json` | `alma-teachings/bible/_manifest/manifest.json` | Index v4 entrypoint |
| `dev/memory/bible-semantic-index.json` | `alma-teachings/legacy/index-artifacts/` | Legacy artifact relocation |

## Excluded from Updates

Files NOT updated (legacy/backup only):
- `alma-teachings/legacy/rename-backup-20260226_175442/*` (intentional backup)
- `alma-teachings/legacy/index-artifacts/*.json` (legacy artifacts, absolute paths embedded)
- `alma-teachings/legacy/collisions/*` (collision artifacts)

