---
version: 2
auto_execution_mode: 3
description: Plan-first markdown directory normalization with standardized prefixes, frontmatter, and mandatory contextual renames
---

## Doc Steward Workflow (notes-first, non-presumptive)

## 0) Agent contract (mandatory)

### Modes

- **PLAN mode (default):** read every in-scope markdown file and output a proposed, reviewable change list.
- **APPLY mode (explicit):** execute **only** an approved change list (prefer `git mv`), and optionally update links.

### Non-negotiables

1. **No project assumptions.** Each markdown file stands on its own.
2. **Default = NOTE.** Docs are promoted only when they meet the minimum requirements for another prefix.
3. **No new files by default.** No indexes, no closeouts, no plan files.
4. **Plan is output-only.** The steward outputs a proposed change list (reviewable), and only applies changes when explicitly requested.
5. **No content invention.** Only frontmatter insertion + renames + link updates (optional). No “filling templates” with guessed content.
6. **Avoid agent-facing/meta files.** Do not modify files in agent directories (AGENTS.md, agent prompts, configuration files) unless explicitly requested. Also avoid changing: README, CLAUDE, HEARTBEAT, IDENTITY, MEMORY, SOUL, TASKS, TOOLS, USER files, and codemap files.
7. **Read all documents.** Every markdown file must be read regardless of size, naming, or apparent importance. No file is skipped based on filename patterns, size, or assumptions about content.
8. **Renaming is mandatory for in-scope docs.** In PLAN output, every in-scope file must have either:
   - `rename → <NEW_FILENAME>` (preferred), or
   - `rename → (no change)` **plus** an allowed `skip_reason` (see Rename rules).

### Critical naming rule (your request)

**Agents must NOT use markdown headings to name files.**  
The filename “Name” must be derived from a digest of the full document content (body text). Headings/frontmatter titles may be read for understanding, but the filename must not be copied, lightly rephrased, or mechanically transformed from any header text.

---

## 1) Frontmatter (simple and searchable)

### Base YAML schema (use for all prefixed docs)

```yaml
---
title: <optional; human-readable; do not use for filename generation>
kind: planning | meeting | brainstorm | research | decision | log | ops | test
status: draft | active | accepted | superseded | archived
owner: <optional for personal notes; required for shared/team docs>
last_updated: YYYY-MM-DD
topics:
  - <tag>
systems:
  - <component/service/topic>   # optional but recommended
related:
  - <relative-link>
---
```

### Required fields

- **NOTE / RSCH / SKTCH / DRAFT**: `kind`, `status`, `last_updated`
- **RFC / TECHP / SPEC / PLAN / TEST / OPS / ADR / DEC**: `kind`, `status`, `owner`, `last_updated`

### Defaults (when missing)

- `kind`: `planning`
- `status`: `draft` (OPS can default to `active` if it’s clearly a runbook)
- `last_updated`: today
- `owner`: only auto-fill if you supply a default (otherwise leave blank)

---

## 2) Prefix taxonomy (expanded, non-overlapping)

### Prefix list

- **NOTE** — capture/log/record (default)
- **RSCH** — research notes (evidence + findings)
- **SKTCH** — sketch (shaping structure/rough approach + TODOs)
- **DRAFT** — pre-final artifact (reader-ready but missing canonical minimums)
- **RFC** — request for comments (multiple viable options + tradeoffs + asks)
- **TECHP** — technical proposal (recommended approach + alternatives + risks)
- **SPEC** — specification (normative requirements + acceptance criteria)
- **PLAN** — execution plan (sequencing + owners + milestones/rollout)
- **TEST** — verification strategy (scenarios + quality gates + traceability)
- **OPS** — operations/runbook (deploy/rollback/alerts/troubleshooting/escalation)
- **ADR** — architectural decision record (durable decision; numbered)
- **DEC** — decision note (lighter than ADR; not numbered; can later be promoted)

### Decision tree (first match wins)

Use this exact order to avoid overlap:

1. **ADR / DEC**: Is the doc primarily recording *a decision*?
2. **OPS**: Is the doc primarily operational instructions for running/responding?
3. **TEST**: Is the doc primarily about verification/quality gates?
4. **RSCH**: Is the doc primarily evidence capture + findings?
5. **SKTCH**: Is the doc primarily an outline/shape with TODOs?
6. **PLAN**: Is the doc primarily an execution sequence (owners/milestones/rollout)?
7. **SPEC**: Is the doc primarily normative requirements + acceptance criteria?
8. **TECHP**: Is the doc primarily a recommended approach with alternatives/risks?
9. **RFC**: Is the doc primarily exploring multiple options and requesting feedback?
10. **DRAFT**: Is it intended to become a canonical artifact soon, but missing minimums?
11. **Otherwise → NOTE**

---

## 3) Minimum requirements by prefix (hard gates)

If a doc does not meet the minimum requirements, it must not be classified with that prefix.

### ADR (durable) / DEC (lightweight)

- **ADR minimum:** decision statement + rationale + consequences/implications; **one decision only**; linkable context.
- **DEC minimum:** decision statement + rationale (consequences optional); can be promoted later.

### OPS

- Triggers/symptoms (how you know to use it)
- Step-by-step procedure (do/verify/rollback or restore)
- At least one “failure/rollback” path

### TEST

- Scenarios (what to test)
- Pass/fail or acceptance gates
- Traceability (links or explicit references to requirements/spec)

### RSCH

- Question/hypothesis
- Evidence (links/data/observations)
- Findings (what was learned)

### SKTCH

- A proposed structure (outline/sections/bucketed bullets)
- At least one candidate approach (even rough)
- Open questions/TODOs

### PLAN

- Sequencing (steps/dependencies)
- Ownership signals (person/team/role)
- Milestones/timeline OR rollout/cutover notes (at least one)

### SPEC

- Normative requirements (“must/shall/required”) OR unambiguous behavioral statements
- Acceptance/verification criteria (done-when, pass/fail, invariants)

### TECHP

- Recommended approach (“we should/propose”)
- At least one alternative considered (including “why not X”)
- Risks/mitigations OR success metrics (at least one)

### RFC

- 2+ viable options
- Tradeoffs (pros/cons, costs/benefits)
- Open questions/asks for feedback

### DRAFT

- Clear audience + purpose
- Reads end-to-end (not just bullets), but missing minimums for the intended canonical prefix

### NOTE (default)

- Anything that doesn’t meet a higher prefix minimum.

---

## 4) Notes-first prefixes (expanded guidance)

### NOTE — capture, log, or record (default)

Use **NOTE** when the goal is to **retain information**, not to converge on a solution.

**Typical content**

- Meeting notes / agendas / summaries
- Brain dumps, collections of bullets
- “What we know so far,” links, context, snippets
- Status notes, daily logs

**Signals**

- Mostly descriptive (“we discussed…”, “here are points…”)
- No strong attempt at structure
- No claim that it’s leading to a particular deliverable

**Graduates to** SKTCH or DRAFT when you start shaping it toward an artifact.

---

### RSCH — research notes (evidence + findings)

Use **RSCH** when the doc’s purpose is **learning** and **evidence capture**.

**Typical content**

- Comparisons (A vs B), benchmarks, experiments
- Quotes/links, reading notes, source summaries
- Findings + implications
- Unknowns + next experiments

**Signals**

- Lots of links/data
- “I tested/verified/read…”
- Ends with “Conclusion” or “Recommendation (tentative)”

**Graduates to** TECHP/SPEC later (optional), but RSCH itself stays “evidence-first.”

---

### SKTCH — sketch (shaping, exploring form)

Use **SKTCH** when you’re **drafting the shape of a solution or doc**, but it’s still exploratory and incomplete.

**Typical content**

- Proposed structure / outline
- Flow diagrams in text, rough component breakdown
- Multiple possible approaches (but not fully analyzed like an RFC)
- Rough “how it might work” notes

**Signals**

- Headings appear, but many sections are stubs
- “Maybe we do X…” / “rough idea”
- You’re designing the container, not finalizing the content

**Graduates to** DRAFT when you start writing it as if it will be read/approved.

---

### DRAFT — pre-final artifact (reader-ready, but not done)

Use **DRAFT** when you are **trying to produce the actual deliverable**, just not finalized and not meeting the target canonical minimums yet.

**Typical content**

- Draft RFC / draft spec / draft proposal / draft runbook
- Full narrative with sections mostly filled
- Clear intent (“this will become SPEC/RFC/etc.”)

**Signals**

- Reads end-to-end, not just bullets
- Uses more definitive language
- It’s meant to be circulated

---

## 5) Rename rules (mandatory; contextual; no headings)

### Filename format

- Standard: `<PREFIX>_<NameAsPascalCase>.md`
- ADR: `ADR_<NNN>_<NameAsPascalCase>.md` (NNN is zero-padded, e.g. `ADR_007_...`)
- Collisions: append `-2`, `-3`, … to the filename stem.

### Allowed skip reasons (enum)

Renaming may be skipped only with one of these reasons:

- `excluded_path_or_file`
- `already_conforms`
- `name_confidence_low`
- `adr_numbering_required` (if you need a numbering policy decision)

### Name rules (what goes after the prefix)

- **Contextually unique:** someone should know what the doc is about from the filename alone.
- **No generic names:** never use “Notes”, “Meeting”, “Ideas”, “Research”, “Draft”, “Overview”, “Misc”.
- **No header-derived names:** do not copy, lightly rephrase, or mechanically transform any markdown heading text into the filename.
- **Prefer concrete anchors:** system/component name, feature name, protocol, metric, constraint, rollout mechanism, decision subject.

### Deterministic name generation algorithm (digest-first)

For each document, do the following in PLAN mode:

1. **Digest the doc** into 3 bullets (not output unless asked):
   - *Primary subject* (system/component/domain)
   - *Primary intent* (decision/plan/spec/proposal/research question)
   - *Key differentiator* (constraint, metric, mechanism, scope boundary, or “what makes this doc not generic”)

2. **Extract candidate tokens** from the body (not headings):
   - 1 token for the primary subject (e.g., `RateLimiter`, `AuthzService`, `EventIngest`, `BillingPortal`)
   - 1–3 tokens for intent + differentiator (e.g., `CanaryRollout`, `BackfillCutover`, `ErrorBudgetPolicy`, `SchemaMigration`, `LatencyTargets`)

3. **Assemble 2–5 tokens** into `NameAsPascalCase`.
   - Remove filler words (the/and/of/for/to)
   - Keep acronyms as PascalCase (`SLO`, `JWT`, `gRPC` → `Grpc` if you want strict pascalization; otherwise keep `GRPC` consistently)

4. **Uniqueness check:** if the name would be ambiguous in the directory, add a differentiator token from the body (e.g., component boundary, environment, API name, metric, rollout method).

5. **Heading similarity check (hard rule):** if the proposed name’s tokens overlap heavily with any heading text (e.g., it’s basically the H1/H2), revise it by adding/choosing a differentiator token from the body so the name reflects the *full-document digest*, not the heading.

### Safety rules

- **Classification confidence does not block renaming.** If the doc is unclear, classify as NOTE and still rename.
- Only skip renaming when `name_confidence_low` or excluded.
- If renaming: prefer `git mv` when possible.
- If you update links, do so conservatively (relative links only; don’t invent new links).

---

## 6) Output format (no plan files)

In PLAN mode, output a **change list** like:

- `notes/limiter.md`
  - classify: `NOTE` (confidence: medium)
  - rename → `NOTE_RateLimiterCanaryIdeas.md`
    - naming rationale (1 line): derived from body: rate limiting + canary rollout mechanics + open questions
  - frontmatter add:
    - `kind: brainstorm`
    - `status: draft`
    - `last_updated: 2026-02-28`
    - `topics: [rate-limiting, rollout]`
  - evidence:
    - “Bulleted ideas + questions about canarying a limiter”
    - “No milestones/owners/acceptance criteria”

In APPLY mode, execute only the approved change list.

---

# Completed-project module (explicit opt-in)

This does **nothing** unless you explicitly say: “this directory is a completed/shipped project” (or enable a `mode=completed` flag).

## 7) Completion prefixes (only when shipped/operating)

Use these *only* when you want durable post-ship artifacts:

- **INDEX** — “start here” entrypoint
- **RELEASE** — what shipped + when + flags/migrations + rollback pointers
- **RUNBOOK** — oncall-ready operational steps (can replace OPS if you prefer)
- **SLO** — reliability targets/paging policy
- **SEC** — security posture summary (or threat model)
- **PRIV** — privacy posture summary
- **MIG** — migration/backfill/cutover guide/record
- **DEPREC** — deprecation notice and timeline
- **ARCHIVE** — retirement snapshot

## 8) Completion frontmatter additions

When in completed mode, add these fields:

```yaml
phase: discovery | delivery | shipped | operating | retired
systems:
  - <service/component>
```

Status conventions:

- SPEC/TEST/RELEASE/MIG/SEC/PRIV/INDEX: `accepted`
- RUNBOOK/OPS/SLO: `active`
- RFC/TECHP: `superseded` (link forward to SPEC/ADR)
- ARCHIVE: `archived`

## 9) Minimal completion packet (recommended)

If you choose to formalize completion, aim for:

- `INDEX_<ProjectName>.md`
- `SPEC_<ProjectName>.md`
- `RUNBOOK_<ProjectName>.md` (or OPS)
- `TEST_<ProjectName>.md`
- `RELEASE_<ProjectName>_20260228.md`
- `ADR_<NNN>_<DecisionName>.md` (key decisions, if any)
