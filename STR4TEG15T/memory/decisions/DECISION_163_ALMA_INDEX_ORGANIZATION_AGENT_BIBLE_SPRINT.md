# DECISION_163: Alma Teachings Index Organization (Agent Bible Sprint)

**Decision ID**: DECISION_163  
**Category**: ARCH  
**Status**: Approved  
**Priority**: High  
**Date**: 2026-02-27  
**Mission Shape**: Failure Investigation + Architecture Inspection  
**Owners**: Strategist (Pyxis) -> OpenFixer (implementation)  

**Lock Statement**: Index v4 contract is locked for implementation; future changes require a new versioned decision companion.

**Supersession Notice (Paths Only)**: DECISION_164 supersedes DECISION_163 for on-disk root paths and removes the shim requirement. All other Index v4 schema/contract semantics remain authoritative from this decision.

---

## Objective

Organize `C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\alma-teachings\index` into an **append-safe, shardable, schema-governed index** that ALMA (agent) can navigate and extend without ingestion truncation, while supporting burn-in as the Book is written.

This decision is **index-only**: it governs file layout, schemas, and update workflows. RAG + MongoDB are expected post-deployment, so the index must be **portable** into those systems.

---

## Constraints

- **Avoid ingestion truncation**: no single “primary” index artifact should grow unbounded.
- **Append-first**: ALMA must be able to add new facts/links without rewriting huge files.
- **Deterministic citations**: every retrieval result must cite stable sources (`bible/*.md`, `substack/*.md`, Book section ids).
- **No RAG dependency now**: design for later ingestion into a vector DB + MongoDB.
- **Idempotent builds**: rebuild jobs produce the same outputs from the same inputs.

---

## Evidence (Discovery)

Index directory currently contains:

- `ALMA_TEACHINGS_BIBLE_COMPLETE.md`
- `ALMA_TEACHINGS_COMPLETE_340_ARTICLES.md`
- `alma-teachings-combined.json`
- `alma-teachings-part-1.json`
- `alma-teachings-part-2.json`
- `digest.json`
- `index.json` (v3, includes tokenSet/topTerms/headings; 899 lines)
- `substack-semantic-index.json` (very large; ~68k lines; ingestion risk)
- `weights.json` (ontology enums + semantic weights)

Observations:
- We already have multiple parallel index representations (`digest.json`, `alma-teachings-*.json`, `index.json`).
- `substack-semantic-index.json` is structurally useful but too large for frequent ingestion.
- We need a **single canonical manifest** that points to **sharded** views.

Relationship:
- `DECISION_162_FIX_BOOK_PARTS_JSON.md` remains valid as a repair/consolidation tactic, but **DECISION_163 is the authoritative index organization contract** going forward.

---

## Scope

**In scope**
- Directory structure redesign for `index/`
- Canonical schemas for:
  - bible document records
  - substack document records
  - teachings “atoms” (smallest semantic units)
  - book section mappings
  - ontology tags (weights)
- Sharding strategy + size caps
- Append protocol for ALMA
- Build protocol to derive “views” (searchable indexes) from append logs

**Out of scope (this decision)**
- Implementing actual RAG / vector DB pipelines
- MongoDB schema + sync jobs
- Editing the underlying `bible/` or `substack/` corpora content

---

## Implementation Defaults (Resolved Consultation Questions)

1. **JSONL shard cap**: keep **5 MB per shard** (monthly rollover remains default).
2. **Atom confidence field**: **defer** for v1 (not required; may be added as optional in a later schema version).
3. **Sprint scope**: **bible + book section mappings first**. Substack doc sharding/migration is deferred to Sprint 2, but schemas and layout remain in place.

---

## Target Information Architecture

### Canonical Layout (Index v4)

All new files live under:
`C:\P4NTH30N\OP3NF1XER\nate-alma\dev\memory\alma-teachings\index`

```
index/
  _manifest/
    manifest.json              # canonical entrypoint (small)
    checksums.json             # file hashes for integrity
    build-state.json           # last build time, tool versions
    build-report.json          # machine-readable build report
    salvage/                   # salvage outputs (truncated-tail repair)

  _schemas/
    manifest.schema.json
    build-report.schema.json
    checksums.schema.json
    build-state.schema.json
    teaching-atom.schema.json
    bible-doc.schema.json
    substack-doc.schema.json
    book-section.schema.json
    view-by-section.schema.json
    view-by-doc.schema.json
    atom-lookup.schema.json
    view-by-tag.schema.json
    view-by-ontology.schema.json

  ontology/
    weights.json               # existing ontology (source of truth)
    ontology-map.json          # optional: synonym/group expansions

  corpus/
    bible/
      docs.jsonl               # one record per bible file (JSONL)
      shards/                  # optional sharding if docs.jsonl grows
    substack/
      docs.jsonl
      shards/

  atoms/
    teachings/
      YYYY-MM.jsonl            # append-only semantic atoms (small, time-sharded)

  mappings/
    book-sections.json         # stable list of 62 sections + metadata
    bible-to-sections.jsonl    # append-only mapping updates
    substack-to-sections.jsonl # append-only mapping updates

  views/
    atom-lookup/
      aa.json                  # sharded atomId -> location
    by-section/
      part-i-ch-1-voting-machine.json  # sectionId -> atomIds/docIds
    by-doc/
      aa.json                  # sharded docId -> atomIds
    by-tag/
      YYYY-MM.json             # derived, compact tag index (sharded)
    by-ontology/
      TopicEnum.json
      MechanismEnum.json
      ...
    search/
      bible-tokens.json        # derived token index (bounded)
      substack-tokens.json

  legacy/
    (moved old files here, read-only)
```

### Size Caps (Anti-Truncation)

- `manifest.json` <= 200 KB
- Any single JSON file in `views/` <= 2 MB (shard above this)
- Any single JSONL shard <= 5 MB (rollover by month)
- Never store the full token list for every doc in a single monolith file; store per-doc or per-shard.

Compatibility shim:
- keep a small `index/index.json` (<= 50 KB) that points to `_manifest/manifest.json` for any legacy consumer.

### Consumption Contract (Anti-Truncation at Use Time)

Even if files are sharded, truncation can still happen if a consumer loads everything.

Hard rules for ALMA + tools:
- Always start from `_manifest/manifest.json`
- Fetch at most:
  - `<= 3` shards per request OR `<= 300 KB` total bytes (whichever hits first)
- Prefer `views/` (by-section/by-doc/by-tag/by-ontology) to locate relevant shards, then open only the specific atom/doc shards required.

---

## Data Model (Core)

This section defines the artifact types and their minimum invariants. Detailed validation is enforced by the JSON Schemas under `index/_schemas/`.

Artifact -> schema -> file patterns:

| Artifact | Schema ID | Pattern |
|---|---|---|
| Manifest | `manifest` | `_manifest/manifest.json` |
| Checksums | `checksums` | `_manifest/checksums.json` |
| Build State | `build-state` | `_manifest/build-state.json` |
| Build Report | `build-report` | `_manifest/build-report.json` |
| Bible Doc Record | `bible-doc` | `corpus/bible/docs.jsonl` + `corpus/bible/shards/*.jsonl` |
| Substack Doc Record | `substack-doc` | `corpus/substack/docs.jsonl` + `corpus/substack/shards/*.jsonl` |
| Teaching Atom | `teaching-atom` | `atoms/teachings/YYYY-MM.jsonl` |
| Book Sections | `book-section` | `mappings/book-sections.json` |
| View: By Section | `view-by-section` | `views/by-section/**/*.json` |
| View: By Doc | `view-by-doc` | `views/by-doc/*.json` |
| View: Atom Lookup | `atom-lookup` | `views/atom-lookup/*.json` |
| View: By Tag | `view-by-tag` | `views/by-tag/*.json` |
| View: By Ontology | `view-by-ontology` | `views/by-ontology/*.json` |

Minimum invariants:
- all JSON objects include `schemaVersion`
- all persisted paths are relative to index root
- all ids follow the ID Contract

## ID Contract (Governance)

### docKey vs docId

- `docKey`: stable identifier for “the doc as a name”, derived from normalized relative path.
  - `docKey = kind + ':' + normalize(relativePath)`
- `docId`: content identifier for “the doc as bytes”, derived from current bytes.
  - `docId = 'sha256:' + sha256(file_bytes)`

Normalization for `relativePath`:
- forward slashes only
- lowercased drive letters are not allowed (no absolute paths)
- no `..` segments

### atomId

Atom IDs must be deterministic for dedupe and stable cross-build:

- `textHash = sha256(utf8(text))`
- `atomId = 'atom_' + sha256(docId + '|' + loc.scheme + '|' + loc.anchorHash + '|' + startLine + '|' + endLine + '|' + textHash).hexdigest()[0:20]`

`contentHash` MUST equal `sha256(text)` and is used for semantic dedupe even if loc changes.

### recordHash

`recordHash` MUST be computed as:
- take the JSON object
- remove the `recordHash` field
- serialize as canonical JSON (sorted keys, UTF-8, no whitespace)
- `recordHash = 'sha256:' + sha256(canonical_json_bytes)`

### Teaching Atom (append-safe)

Each semantic “fact” becomes an atom with stable id and citations.

Minimum fields (required):

```json
{
  "schemaVersion": "1.0.0",
  "id": "atom_...",
  "recordHash": "sha256:...",
  "contentHash": "sha256:...", 
  "createdAt": "2026-02-27T01:23:45Z",
  "source": {
    "kind": "bible|substack",
    "docKey": "bible:bible/2025-01-29-intraday-post-28-feb.md",
    "docId": "sha256:...",
    "relativePath": "bible/2025-01-29-intraday-post-28-feb.md",
    "loc": {
      "scheme": "heading+span.v1",
      "headingPath": ["H1 title", "H2 title"],
      "span": {"startLine": 120, "endLine": 168},
      "anchorHash": "sha256:..."
    }
  },
  "text": "...",
  "summary": "...",
  "tags": ["..."],
  "ontology": {
    "TopicEnum": ["..."],
    "MechanismEnum": ["..."]
  },
  "links": {
    "bookSections": ["part-ii-ch-4-gamma-flip"],
    "relatedAtoms": []
  },
  "status": "active"
}
```

Key properties:
- append-only
- each atom cites the corpus
- small enough to be ingested without truncation

Deterministic citation rule:
- `source.docId` ties the atom to a specific version of the source doc.
- `source.loc` must be resolvable by the build; if it cannot be resolved, mark atom `status=stale` and preserve it.

Append safety rule:
- Every JSONL record must end with `\n`.
- Builder must tolerate a truncated last line by ignoring it and emitting an audit error.

Corruption handling (required):
- If a shard contains an invalid JSON line (including truncated tail), builder must:
  1. write `_manifest/salvage/<shardName>.salvaged.jsonl` containing only valid lines up to last complete newline
  2. write `_manifest/build-report.json` with per-shard metrics: {invalidLineCount, ignoredTailLine, salvagedBytes, recordCountBefore, recordCountAfter}
  3. continue build using the salvaged shard (never silently ignore without reporting)

### Document Record (bible/substack)

```json
{
  "schemaVersion": "1.0.0",
  "docId": "sha256:...",
  "docKey": "bible:bible/2025-01-29-intraday-post-28-feb.md",
  "file": "2025-01-29-intraday-post-28-feb.md",
  "relativePath": "bible/2025-01-29-intraday-post-28-feb.md",
  "title": "...",
  "date": "2025-02-28",
  "sourceUrl": "...",
  "status": "active|deprecated",
  "topTerms": ["..."],
  "headings": [{"line": 1, "title": "..."}]
}
```

`docId` is the content hash. Do not persist a second redundant `hash` field.

Portability rule:
- Persisted records must not store absolute Windows paths; use `relativePath` + `docId`.

---

## Build & Update Workflow

### Append Protocol (ALMA-safe)

ALMA must only ever:
1. append atoms to `atoms/teachings/YYYY-MM.jsonl`
2. append mapping hints to `mappings/*-to-sections.jsonl`
3. never rewrite `views/` directly

Corpus doc records (`corpus/*/docs.jsonl`) are derived by scanner/build tooling (not appended by ALMA).

Append corruption mitigation:
- single-writer expectation (per shard)
- build emits: invalidLineCount, ignoredTailLine (bool)
- optional: `recordHash` per atom and rolling shard hash in `_manifest/checksums.json`

### Build Protocol (human / CI / post-deploy)

Build steps:
1. validate JSONL shards against schemas
2. recompute derived `views/` (tags, ontology, token indexes)
3. update `_manifest/checksums.json`
4. update `_manifest/manifest.json` pointers + versions
5. write `_manifest/build-report.json` (machine-readable)

Idempotence gate:
- rebuild twice without input changes must yield identical `_manifest/checksums.json`.

---

## Migration Plan (from Current Index)

1. Move current index files into `index/legacy/` (no deletion)
2. Treat `weights.json` as the ontology source of truth; copy to `index/ontology/weights.json`
3. Convert `digest.json` + `alma-teachings-*.json` into teaching atoms (JSONL)
4. Split `substack-semantic-index.json` into month-sharded `corpus/substack/shards/YYYY-MM.jsonl` (or a bounded doc-record representation)
5. Generate initial `views/` from atoms + doc records

Sprint boundary:
- Sprint 1: bible + book mappings + atoms + required views
- Sprint 2: substack sharding/migration + NO_MONOLITH enforcement for substack semantic monolith

Migration parity report (required):
- counts: docs, atoms, mappings
- dropped/unknown fields list
- collisions list (same docId from different inputs)

Migration parity gates (enforceable):
- zero silent drops (any dropped/unknown field must be listed)
- collisions must be explicitly resolved or the migration fails
- migration tool must exit non-zero on gate failure

---

## Locator Schemes (Normative)

Atoms MUST use one of these `source.loc.scheme` values:

1. `heading+span.v1` (preferred for markdown)
   - Extract headings from markdown lines matching `^#{1,6} `
   - `headingPath`: list of heading titles from H1..Hx containing the span
   - `span.startLine/endLine`: 1-based line numbers captured at atom creation time
   - `anchorHash`: `sha256('headingPath:' + normalize(join(headingPath,'>')))`
   - Resolution algorithm:
     - load doc bytes for `docId`
     - verify headings still contain `headingPath` in order
     - verify `span` is within doc line count
     - if any check fails: mark atom `status=stale` (do not delete)

2. `contenthash-span.v1` (fallback for unstable heading docs)
   - `anchorHash`: `sha256('contentHash:' + contentHash)`
   - `span` remains best-effort
   - Resolution algorithm:
     - if docId matches and contentHash found in doc text neighborhood, keep active
     - else mark stale

Normalization rule for heading titles:
- trim, collapse whitespace, preserve ASCII punctuation, do not lowercase

---

## Sharding Rules (Deterministic)

All sharding MUST be deterministic so tools can route queries without scanning:

- `atoms/teachings/YYYY-MM.jsonl`: shard key = month of `createdAt`

- `views/atom-lookup/<aa>.json`:
  - `aa = first2Hex(atomId after 'atom_')`
  - entry shape: `{ "atomId": {"relativePath": "atoms/teachings/YYYY-MM.jsonl", "line": 123} }`

- `views/by-doc/<aa>.json`:
  - `aa = first2Hex(docId after 'sha256:')`
  - value: list of atomIds (or compact records)

- `views/by-section/<sectionId>.json`:
  - default: one file per sectionId (62 bounded)
  - if file exceeds 2 MB: split into `views/by-section/<sectionId>/YYYY-MM.json`

- `views/by-tag/YYYY-MM.json`:
  - shard key = month

---

## Build Artifacts (Required)

`index/_manifest/build-report.json` MUST include:
- overall: buildId, generatedAt, schemaBundleHash
- per-shard: {relativePath, sha256, byteSize, recordCount, invalidLineCount, ignoredTailLine, salvagedBytes}

`index/_manifest/build-state.json` MUST include:
- tool versions
- decision id (`DECISION_163`)
- command line / mode

`schemaBundleHash` definition (deterministic):
- compute sha256 over a UTF-8 string formed by joining lines:
  - for each schema id in sorted order: `<schemaId> <sha256>`

---

## Acceptance Requirements

### REQ-163-MANIFEST
- `index/_manifest/manifest.json` exists and is <= 200 KB
- It references every shard used for bible/substack docs and atoms

### REQ-163-MANIFEST_SCHEMA
- `_schemas/manifest.schema.json` exists
- `manifest.json` includes `schemaVersion` and validates against it
- each `shards[]` entry includes: {type, schemaId, schemaVersion, relativePath, sha256, byteSize, recordCount}
- time bounds are required only for record-bearing shards:
  - for `atoms/teachings/*.jsonl`: require `dataTimeMin`, `dataTimeMax` (min/max record.createdAt)
  - for view shards: `dataTimeMin/dataTimeMax` optional

### REQ-163-SCHEMA_ENFORCEMENT
- every JSONL record includes `schemaVersion`
- build fails on unknown `schemaVersion`
- build validates records against referenced schema

### REQ-163-BUILD_REPORT
- `_manifest/build-report.json` exists after build
- includes per-shard validation + salvage metrics

### REQ-163-INDEX_SHIM
- `index/index.json` exists, <= 50 KB
- contains a single pointer to `_manifest/manifest.json` (relative path) and the active `indexVersion`

### REQ-163-MIGRATION_PARITY_GATES
- migration writes `_manifest/migration-parity.json`
- build fails if:
  - `silentDropCount > 0`
  - `collisionCount > 0` AND `collisionsResolved=false`
  - any legacy input file is not listed under `legacyInputs[]`

### REQ-163-APPEND_SAFE
- All ALMA write operations are append-only to JSONL shards
- No view file requires manual editing

### REQ-163-REQUIRED_VIEWS
- derived views exist and validate:
  - `views/by-section/`
  - `views/by-doc/`
  - `views/atom-lookup/`
- spot-check: one `atomId` resolves via atom-lookup and appears in its doc + section view

### REQ-163-NO_MONOLITH
- `substack-semantic-index.json` is replaced by sharded or bounded representations

Note: This requirement is enforced in Sprint 2. In Sprint 1, `substack-semantic-index.json` may remain in `legacy/` but must not be used as an ingestion entrypoint.

### REQ-163-PORTABLE
- Index can be ingested into MongoDB later by reading `manifest.json`
- Index can be vectorized later by reading the atom shards

### REQ-163-PORTABLE_PATHS
- no absolute paths appear in any non-legacy record/artifact

### REQ-163-BOOK_LINKS
- Mappings exist so Book writing can cite and enrich atoms continuously

### REQ-163-ID_CONTRACT
- `mappings/book-sections.json` defines the canonical immutable `sectionId` list
- any mapping referencing sectionId not in the list fails build
- `docKey`, `docId`, `atomId` follow the ID Contract

Enforcement (minimum):
- `docId` matches `^sha256:[0-9a-f]{64}$`
- `atomId` matches `^atom_[0-9a-f]{20}$`
- `docKey == kind + ':' + relativePath`

`sectionId` format constraint (regex):
- `^part-(i|ii|iii|iv|v)-ch-[0-9]{1,2}-[a-z0-9-]+$`

### REQ-163-SIZE_CAPS_ENFORCED
- build fails (non-zero) if any size cap is exceeded:
  - manifest > 200 KB
  - any single JSON in `views/` > 2 MB (unless sharded per rules)
  - any single JSONL shard > 5 MB

---

## View Payload Shapes (Minimal Examples)

### views/atom-lookup/aa.json
```json
{
  "schemaVersion": "1.0.0",
  "shard": "aa",
  "atoms": {
    "atom_deadbeefdeadbeefdead": {"relativePath": "atoms/teachings/2026-02.jsonl", "line": 123}
  }
}
```

### views/by-doc/aa.json
```json
{
  "schemaVersion": "1.0.0",
  "shard": "aa",
  "docs": {
    "sha256:aaaaaaaa...": ["atom_deadbeefdeadbeefdead"]
  }
}
```

### views/by-section/<sectionId>.json
```json
{
  "schemaVersion": "1.0.0",
  "sectionId": "part-ii-ch-4-gamma-flip",
  "atomIds": ["atom_deadbeefdeadbeefdead"],
  "docIds": ["sha256:aaaaaaaa..."]
}
```

Ordering rules for idempotence:
- `manifest.shards[]` sorted by `type`, then `relativePath`
- maps in views are written with keys sorted lexicographically
- arrays are written sorted (atomIds/docIds)

---

## Manifest Payload Shape (Minimal Example)

`index/_manifest/manifest.json`

```json
{
  "schemaVersion": "1.0.0",
  "indexVersion": "4.0.0",
  "generatedAt": "2026-02-27T00:00:00Z",
  "schemas": [
    {"id": "teaching-atom", "relativePath": "_schemas/teaching-atom.schema.json", "sha256": "sha256:...", "version": "1.0.0"}
  ],
  "shards": [
    {
      "type": "atoms-teachings",
      "schemaId": "teaching-atom",
      "schemaVersion": "1.0.0",
      "relativePath": "atoms/teachings/2026-02.jsonl",
      "sha256": "sha256:...",
      "byteSize": 12345,
      "recordCount": 321,
      "dataTimeMin": "2026-02-01T00:00:00Z",
      "dataTimeMax": "2026-02-27T23:59:59Z"
    }
  ]
}
```

---

## Legacy Shim Payload (Minimal Example)

`index/index.json`

```json
{
  "indexVersion": "4.0.0",
  "manifest": "_manifest/manifest.json"
}
```

---

## Bug-Fix Section

If build/migration fails:
- preserve all inputs under `index/legacy/` and all attempted outputs under `index/_manifest/salvage/`
- do not delete or overwrite shards; write new shards with new filenames
- produce `_manifest/build-report.json` and `_manifest/migration-parity.json` even on failure
- smallest-step rollback: point `index/index.json` back to prior manifest

---

## Token Budget

- Strategy work (this decision): already complete
- Implementation (OpenFixer): ~20-40K tokens (scripts + schemas + migration tooling)
- Consultation loops: ~10-20K tokens per round

---

## Model Selection

- **OpenFixer** implementation: Claude Sonnet-class model recommended for scripting + JSON schema work
- **Oracle/Designer** reviews: low/medium cost models acceptable; keep structured JSON output

---

## Sub-Decision Authority

- Oracle/Designer may create sub-decisions for validation/IA refinements (assimilated)
- OpenFixer/WindFixer implementation sub-decisions require Strategist approval

---

## Risks & Mitigations

- **Risk**: uncontrolled growth of tag/token views
  - **Mitigation**: shard views monthly; maintain “top-N terms” only; keep full tokens per-doc or per-shard.

- **Risk**: schema drift as agents append
  - **Mitigation**: schema version field + strict validation; reject invalid atoms during build.

- **Risk**: duplicate atoms for same concept
  - **Mitigation**: content-hash field (optional) + dedupe step in build.

---

## Consultation Questions (Resolved)

These were resolved under `## Implementation Defaults (Resolved Consultation Questions)`:
- JSONL shard cap: 5 MB
- confidence: deferred
- Sprint scope: bible first; substack deferred to Sprint 2

---

## Implementation Status

**Status**: ✅ **SKELETON COMPLETE** (Structure deployed, content deferred)

**Completed by**: OpenFixer (Opus) as part of DECISION_164 workspace remediation

**Evidence**: See `OP3NF1XER/nate-alma/dev/memory/alma-teachings/bible/` structure

### What Was Built

**Index v4 Skeleton** (all present and conformant):
- `_manifest/manifest.json` - Index manifest
- `_schemas/` (8 schema files) - Validation schemas
- `corpus/substack/docs.jsonl` - 340 records
- `atoms/teachings/` - Empty, append-ready
- `mappings/book-sections.json` - 62 sections mapped
- `ontology/weights.json` - Semantic weights
- `views/` - Empty subdirectories (ready for Sprint 2)
- `index.json` - Shim for compatibility

### What Was Deferred

Per Sprint 1 scope decision:
- **Atoms population**: Deferred to Sprint 2 (requires content processing)
- **Views generation**: Deferred to Sprint 2 (requires atom processing)
- **Build pipeline**: Not implemented (manual updates currently)

### Current State

The Index v4 **structure is complete and schema-compliant**. The skeleton provides:
- ✅ Append-safe JSONL storage
- ✅ Deterministic citation paths
- ✅ Schema validation ready
- ✅ Shardable architecture

Content population requires Sprint 2 (separate decision).

---

## Handoff Contract (for OpenFixer)

Implement ONLY index organization + migration scripts. Do not edit bible/substack content.

**File targets**:
- create `index/_manifest/*`, `index/_schemas/*`, `index/atoms/*`, `index/corpus/*`, `index/views/*`, `index/legacy/*`

**Validation**:
- schema validation command(s)
- manifest size check
- view shard size checks

---
