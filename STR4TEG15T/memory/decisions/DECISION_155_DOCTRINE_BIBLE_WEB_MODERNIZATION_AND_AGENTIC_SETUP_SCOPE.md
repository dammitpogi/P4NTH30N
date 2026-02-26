---
type: decision
id: DECISION_155
category: FEAT
status: completed
version: 1.0.0
created_at: '2026-02-25T07:20:00Z'
last_reviewed: '2026-02-25T07:28:00Z'
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_155_DOCTRINE_BIBLE_WEB_MODERNIZATION_AND_AGENTIC_SETUP_SCOPE.md
---
# DECISION_155: Doctrine Bible Web Modernization and Agentic Setup Scope

**Decision ID**: DECISION_155  
**Category**: FEAT  
**Status**: Completed  
**Priority**: High  
**Date**: 2026-02-25

## Context

Nexus requested a governance-first modernization plan for the Doctrine Bible website (`OP3NF1XER/nate-alma/dev/memory/doctrine-bible/site`) with web research, explicit layout selection rationale, expanded design concepts, full feature scope including `/setup` capabilities, a locked login posture, a canonical bible endpoint at `/bible`, and a credential tool path for future username/password updates.

## Historical Decision Recall

- `DECISION_140`: webpage + bible visibility gaps and auth-gated runtime expectations.
- `DECISION_142`: textbook explanatory structure, citations, and navigation hardening.
- `DECISION_151`: setup password tooling and auth-gate operations.
- `DECISION_152`: auth-vault mutation discipline and encrypted secret storage.

## Knowledgebase and Historical Assimilation

Assimilated sources:

- `OP3NF1XER/knowledge/DECISION_142_DOCTRINE_BIBLE_TEXTBOOK_EXPLANATORY_SITE_2026_02_25.md`
- `OP3NF1XER/patterns/SOURCE_CHECK_ORDER.md`
- `OP3NF1XER/patterns/WORKFLOW_IMPLEMENTATION_PARITY_AUDIT.md`
- `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/01_OPENFIXER_INTRO_AND_CONTEXT.md`
- `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/02_DECISION_136_137_ASSIMILATION.md`
- `STR4TEG15T/tools/workspace/memory/p4nthe0n-openfixer/NATE_SUBSTACK_TEXTBOOK_v2.md`

## Web Research Findings

Research lane used: ToolHive Tavily MCP search.

Primary references:

- Docusaurus docs intro and docs-only mode: `https://docusaurus.io/docs/docs-introduction`
- Docusaurus sidebar and versioning: `https://docusaurus.io/docs/sidebar`, `https://docusaurus.io/docs/versioning`
- MkDocs Material setup/navigation/search references:
  - `https://squidfunk.github.io/mkdocs-material/setup/`
  - `https://squidfunk.github.io/mkdocs-material/setup/setting-up-navigation/`
  - `https://squidfunk.github.io/mkdocs-material/blog/2021/09/13/search-better-faster-smaller/`
- Nextra docs and search references:
  - `https://nextra.site/`
  - `https://nextra.site/docs/guide/search`
  - `https://nextra.site/docs/file-conventions/meta-file`

## Chosen Layout

Selected layout direction: **Docs-first split layout (left syllabus nav + center lesson page + right "On this page" rail), Docusaurus-style information architecture with MkDocs/Nextra search ergonomics**.

### Why this layout

Top 3 features that stood out:

1. **Hierarchical learning navigation**
   - Docusaurus-grade sidebar structure maps naturally to textbook chapters and lesson archives.
2. **Docs-only operating mode**
   - Documentation becomes the product itself (no competing landing-page complexity).
3. **Fast full-text retrieval model**
   - MkDocs/Nextra patterns validate instant client-side search and keyboard-first navigation for dense knowledge repositories.

## Expanded Design Ideas (Built on Top 3)

1. **Learning-state rail + chapter mastery markers**
   - Preserve chapter hierarchy while adding "Not Started / In Progress / Mastered" state badges.
2. **Evidence-linked callouts**
   - Every doctrinal claim gets a "source citation" block linking to local captured files for provenance.
3. **Agent action dock**
   - Right rail includes "Ask Agent", "Cite This Section", "Open Related Decision", and "Copy Prompt Context" actions.
4. **Progressive search panel**
   - Keep instant results list, then optional "deep search" with chapter filters and doctrine tags.
5. **Semantic breadcrumbs + reading time + key concepts block**
   - Improves textbook scanning and structured review loops.

## Full Implementation Scope (Pre-Go Contract)

### A) Information Architecture and Routes

1. Canonical textbook home route: `/textbook` (existing posture).
2. Canonical bible route: **`/bible`** (hard requirement).
3. Keep chapter routes under `/textbook/chapters/...`.
4. Add bible-specific navigation card on homepage + global header quick link.

### B) Auth and Login Contract

1. Keep dashboard-level auth gate (Basic auth) enforced.
2. Add explicit login screen UX for human-friendly entry before textbook render.
3. Require successful login before `/textbook` and `/bible` content loads.
4. Keep WebSocket auth parity with same credential gate.

### C) `/setup` Endpoint Feature Parity (Must Surface in Website/Agent UX)

All currently implemented setup capabilities must be represented in the website scope:

1. `GET /setup/healthz`
2. `GET /setup`
3. `GET /setup/app.js`
4. `GET /setup/api/status`
5. `GET /setup/api/auth-groups`
6. `POST /setup/api/run`
7. `GET /setup/api/debug`
8. `POST /setup/api/console/run` (gateway lifecycle, status, health, doctor, logs tail, config get, devices list/approve, plugins list/enable)
9. `GET /setup/api/config/raw`
10. `POST /setup/api/config/raw`
11. `POST /setup/api/pairing/approve`
12. `GET /setup/api/devices/pending`
13. `POST /setup/api/devices/approve`
14. `POST /setup/api/reset`
15. `GET /setup/export`
16. `POST /setup/import`

### D) Agentic Features

1. **Persistent Chat Interface (OpenClaw Parity)**
   - Provide a persistent, floating or sidebar chat interface powered by `<openclaw-app>` patterns, maintaining session continuity across page navigations.
   - When Nate opens the chat directly without context, automatically inject the current filename into the prompt (e.g., `[filename_of_page.html]`).
2. **Contextual "[Ask Alma?]" Action Buttons**
   - Embed inline `[Ask Alma?]` buttons next to complex or difficult-to-understand doctrinal concepts.
   - Clicking these buttons injects the specific paragraph/topic context directly into the chat session.
3. "Generate execution checklist" from current chapter.
4. "Cite doctrine" one-click citation snippet from local source files.
5. "Open decision provenance" drill-down by topic keyword.
6. "Export briefing" (short summary, risks, invalidation points) for trade-session prep.

### E) Delivery Guardrails

1. Preserve current static-site compatibility and avoid breaking generated chapter pages.
2. Keep mobile usability with collapsible left nav and sticky right utility rail.
3. Maintain plaintext-free secret handling in memory docs (auth-vault only).

## Credential Provisioning (Completed in This Pass)

Requested easy human credential has been created and stored in auth-vault:

- Record name: `nate-bible-site-login`
- Username: `nate`
- Password: stored in encrypted auth-vault payload (`type=password`)
- Storage: `OP3NF1XER/nate-alma/dev/.secrets/auth-vault/nate-bible-site-login.dpapi`

## Credential Update Tool (Completed in This Pass)

Added dedicated helper tool for agents to rotate/update this website login without ad-hoc commands:

- `OP3NF1XER/nate-alma/dev/skills/auth-vault/scripts/update_bible_login.py`

Usage:

- `python skills/auth-vault/scripts/update_bible_login.py --username "nate" --password "NewPassword123!"`
- If `--password` is omitted, the tool prompts securely.

## Decision Parity Matrix

- Governance + historical assimilation performed before web research: **PASS**
- Web research completed and captured in decision: **PASS**
- Layout selected with narrow rationale and top 3 features: **PASS**
- Expanded design ideas documented: **PASS**
- Full implementation scope including `/setup` endpoint features documented: **PASS**
- Login lock requirement captured: **PASS**
- `/bible` endpoint contract captured: **PASS**
- Username/password created in password tool lane (`.secrets/auth-vault`): **PASS**
- Agent credential-update tool provided: **PASS**

## Closure Recommendation

`Close` - discovery, scope, credential setup, and operator tooling are complete. Implementation build-out is ready for explicit "go" execution.
