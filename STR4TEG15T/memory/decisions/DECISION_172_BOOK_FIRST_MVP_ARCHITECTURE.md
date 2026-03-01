---
type: decision
id: DECISION_172
category: ARCH
status: drafted
version: 1.0.0
created_at: '2026-02-28T14:00:00Z'
last_reviewed: '2026-02-28T14:00:00Z'
priority: Critical
keywords:
  - book-first
  - mvp
  - qmd
  - nextjs
  - railway
  - pivot
  - alma
  - nate
  - openclaw
  - architecture
roles:
  - strategist
  - oracle
  - designer
  - openfixer
  - windfixer
supersedes:
  - DECISION_146
  - DECISION_165
  - DECISION_168
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_172_BOOK_FIRST_MVP_ARCHITECTURE.md
---

# DECISION_172: Book-First MVP Architecture - Full Pivot to QMD (v1.0.0)

**Decision ID**: DECISION_172  
**Version**: 1.0.0  
**Category**: ARCH (Architecture)  
**Status**: Drafted  
**Priority**: Critical  
**Date**: 2026-02-28  
**Supersedes**: DECISION_146, DECISION_165, DECISION_168

---

## Executive Summary

This decision marks a **full architectural pivot** from "ALMA as OpenClaw agent" to "Book-First MVP with Next.js frontend and QMD backend." The product is now **education + playbook guidance** centered on a structured "Book" corpus, not an agent-centric conversation interface.

**Core Thesis**: The product serves traders learning SPY listed options (mostly 0DTE/weekly, defined-risk spreads only) through a reading/learning environment with "book + agent panel + playbooks + notes."

**Non-Goal**: No trade execution UX (no "place trade", no broker order entry).

---

## The Pivot: What Changed

| Aspect | Old Approach (DECISION_146/165/168) | New Approach (This Decision) |
|--------|-------------------------------------|------------------------------|
| **Primary Interface** | OpenClaw WebChat + Control UI | Next.js App Router website |
| **User Experience** | Agent-centric conversation | Book-first reading + learning |
| **Public Entry Point** | OpenClaw on Railway | Next.js on Railway |
| **OpenClaw Role** | Primary runtime/orchestration | Internal service (Core container) - **Client Choice** |
| **RAG Implementation** | OpenClaw built-in memory/retrieval | QMD via internal API |
| **Target User** | Alma (agent operator) | Options traders learning SPY 0DTE |
| **Product Focus** | Agent capabilities + stock tools | Education + playbook guidance |
| **Trade Execution** | Not excluded | Explicitly out of scope |

---

## Intake

Nexus has designed and documented a complete Book-First MVP specification suite in `OP3NF1XER/nate-alma/specs/`:

- **00-DECISION_UI_FOUNDATION.md**: Non-negotiable UI governance
- **01-SPEC_RAILWAY_ARCHITECTURE.md**: 3-service Railway deployment
- **02-SPEC_NETWORKING_SECURITY.md**: Public/private boundaries
- **03-SPEC_MONGO_SCHEMA.md**: Data model for Book/Notes/Playbooks
- **04-TECHP_DESIGN_SYSTEM.md**: "Calm Research UI" design tokens
- **05-TECHP_STYLE_GUIDE.md**: Typography, spacing, color
- **06-SPEC_UI_LAYOUTS.md**: Wireframe-level layouts
- **07-08-SPEC_UI_CONSULTATION_*.md**: Deep Research outputs
- **09-SPEC_ENDPOINT_CONTRACT.md**: API boundaries

**Key Directives from Nexus**:
1. ✅ Pivot to QMD (not OpenClaw RAG)
2. ✅ `deploy/` will be created from scratch; `dev/` still contains the recovered working directory
3. ✅ MVP is outlined in specs - full pivot
4. ✅ OpenClaw is **Client Choice** (optional internal service)
5. ✅ DECISION_164 is already complete (workspace rename finished by OpenFixer)

---

## Frame (Bounded Scope)

1. **Objective**: Deploy Book-First MVP with Next.js frontend, QMD retrieval backend, and optional OpenClaw agent runtime
2. **Constraints**: 
   - Only Next.js is public; all other services internal
   - Railway deployment with sleep/scale-to-zero tolerance
   - No trade execution features
   - OpenClaw is optional (client choice)
3. **Evidence targets**: All specs in `nate-alma/specs/` are canonical
4. **Risk ceiling**: Medium - new architecture but well-documented
5. **Finish criteria**: 
   - All 3 services deployed and communicating
   - Book Reader functional with TOC, content, agent panel
   - Notes, highlights, bookmarks working
   - Playbooks (draft + published) functional
   - Admin minimal (reindex + status)

---

## Service Topology (3 Services)

### Service A — `web` (Next.js)
**Type**: Next.js App Router (public)

**Responsibilities**:
- Public UI (Library, Reader, Notes, Playbooks, Admin)
- Authentication/session management (identity boundary)
- API routes (`/api/*`) for browser requests
- Server-to-server calls to internal services (Core container)
- Reads/writes MongoDB for Book sections, notes, playbooks, audit log

**Exposure**: Public HTTP enabled (the ONLY public entry point)

**Key Environment Variables**:
- `MONGODB_URI`
- `INTERNAL_CORE_BASE_URL` (internal URL for Service B)
- `INTERNAL_SERVICE_TOKEN` or `INTERNAL_JWT_SIGNING_KEY`
- Auth variables (`AUTH_SECRET`, `AUTH_URL`, provider creds)

---

### Service B — `core` (OpenClaw + QMD + SFTPGo)
**Type**: Docker container (internal)

**Responsibilities**:
- Internal agent execution endpoint(s): `/internal/agent/run`
- Internal retrieval endpoint(s): `/internal/search` (QMD)
- Indexing/reindex jobs: `/internal/index/rebuild`, `/internal/index/status`
- SFTP-based content/persistence workflows

**Exposure**: Internal only. No public HTTP.

**Key Environment Variables**:
- `INTERNAL_SERVICE_TOKEN` (must match Web for verification)
- QMD index/config vars
- Storage paths / SFTPGo config vars

**Security**: All endpoints require `Authorization: Bearer <service token>`

---

### Service C — `mongo` (MongoDB)
**Type**: MongoDB (internal)

**Responsibilities**:
- Persistent storage for Book-first MVP entities
- Optional indexes for fallback search (QMD remains primary)

**Exposure**: Internal only (no public DB port)

**Backups**: Scheduled logical dump/export minimum

---

## Network Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Public Internet                      │
│                              │                               │
│                              ▼                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Service A: Next.js (web)                 │   │
│  │         Public HTTPS - Identity Boundary              │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                    │
│              ┌──────────┴──────────┐                        │
│              │ Internal Railway     │                        │
│              │ Network              │                        │
│              ▼                      ▼                        │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │ Service B: Core  │  │ Service C: Mongo │                 │
│  │ (OpenClaw+QMD)   │  │                  │                 │
│  │ Internal only    │  │ Internal only    │                 │
│  └──────────────────┘  └──────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

---

## MongoDB Schema (10 Collections)

Per **03-SPEC_MONGO_SCHEMA.md**:

| Collection | Purpose |
|------------|---------|
| `users` | Identity, roles, onboarding preferences |
| `book_sections` | Canonical book content for Reader |
| `book_toc` | Cached TOC tree for fast Library rendering |
| `notes` | User notes linked to sections and anchors |
| `highlights` | Text highlights in Reader |
| `bookmarks` | Quick save points in the book |
| `reading_progress` | "Continue" and progress bars |
| `playbooks` | Playbook drafts + published playbooks |
| `agent_runs` | Audit + replay of agent outputs |
| `audit_log` | Admin actions, indexing, config changes |

---

## UI Foundation (Non-Negotiable)

Per **00-DECISION_UI_FOUNDATION.md**:

### Stable 3-Column Shell
- **Left rail**: Book TOC / navigation (Parts → Chapters → Sections)
- **Center**: Reader / content (editorial typography)
- **Right rail**: Agent panel (skills/actions)

### Required MVP Skills (Agent Panel)
1. Explain/Rephrase (simple/technical/analogy)
2. Socratic Tutor (3–5 questions; track missed concepts)
3. Flashcards/Quiz (5–10)
4. Checklist builder (pre/during/post)
5. Scenario tree builder (If/Then → save as Playbook draft)
6. Notes assistant (create note, tag concepts, link to anchors)

### Canonical Page Set (MVP)
1. **Library** (Book index)
2. **Reader** (Section view)
3. **Playbooks** (list + detail)
4. **Notes** (filters/tags/backlinks)
5. **Admin minimal** (reindex + status)
6. **Login + onboarding**

---

## Endpoint Contract

Per **09-SPEC_ENDPOINT_CONTRACT.md**:

### Public API (Browser → Next.js)
- `POST /api/auth/login|logout`
- `GET /api/auth/me`
- `GET /api/book/toc`
- `GET /api/book/section?slug=...`
- `GET /api/book/search?q=...`
- `POST|GET|PATCH|DELETE /api/notes`
- `POST /api/highlights`
- `POST /api/bookmarks/toggle`
- `POST|GET /api/progress`
- `GET|POST|PATCH /api/playbooks`
- `POST /api/playbooks/:id/publish|archive`
- `POST /api/agent/skill`
- `GET|POST /api/admin/status|book/reindex|config`

### Internal API (Next.js → Core)
- `POST /internal/search` (QMD)
- `POST /internal/agent/run` (OpenClaw - optional)
- `POST /internal/index/rebuild|/index/status`
- `GET /internal/health`

---

## Design System

Per **04-TECHP_DESIGN_SYSTEM.md**:

**Stack**: Next.js + Tailwind + shadcn/ui + Lucide icons

**Visual Principles**:
- Editorial first: typography and rhythm carry the design
- Calm density: lots of information, but never cramped
- Quiet chrome: minimal borders, subtle surfaces
- One accent color: used for focus, links, active states

**Layout**:
- Max width container: 1200–1280px
- Reader column: ~680–760px for comfort
- Three-zone layout: left TOC (260–300px), center content, right agent (320–380px)

---

## Deployment Structure

```
OP3NF1XER/nate-alma/
├── dev/                          # Existing workspace (DECISION_164 complete)
│   ├── memory/alma-teachings/
│   │   ├── bible/               # Index v4 root (empty, ready)
│   │   ├── substack/            # 341 markdown corpus files
│   │   └── legacy/              # Backup + old artifacts
│   ├── AGENTS.md, SOUL.md, etc. # OpenClaw bootstrap files
│   └── ...
│
├── deploy/                       # NEW: Deployment artifacts (created from scratch)
│   ├── web/                     # Next.js Dockerfile + config
│   ├── core/                    # OpenClaw+QMD+SFTPGo Dockerfile
│   ├── mongo/                   # MongoDB config (if needed)
│   ├── railway.toml             # Railway deployment config
│   └── docker-compose.yml       # Local development
│
├── specs/                        # Canonical specification suite
│   ├── 00-DECISION_UI_FOUNDATION.md
│   ├── 01-SPEC_RAILWAY_ARCHITECTURE.md
│   └── ...
│
└── secrets/                      # Encrypted secrets vault
```

---

## OpenClaw Status: Client Choice

**OpenClaw is optional** in this architecture:

- **If client wants OpenClaw**: Deploy in Core container, expose `/internal/agent/run`, use for agent skills
- **If client doesn't want OpenClaw**: Core container runs only QMD + SFTPGo; agent skills implemented differently or deferred

**Current posture**: Design for OpenClaw availability, but don't block on it. The Book-First MVP works without agent runtime (reading, notes, playbooks are sufficient for MVP).

---

## Routes (Primary + Fallback)

### Primary Route: Full 3-Service Deployment
1. Build Next.js app with all MVP pages
2. Build Core container (OpenClaw+QMD+SFTPGo)
3. Deploy MongoDB via Railway template
4. Configure service-to-service auth
5. Deploy to Railway with internal networking
6. Validate all endpoint contracts

**Validation Commands**:
```bash
# Health checks
curl https://$DOMAIN/api/health
curl https://$DOMAIN/api/book/toc
curl -X POST https://$DOMAIN/api/agent/skill -H "Authorization: Bearer $TOKEN"

# Internal service reachability (from Next.js container)
curl http://core:8080/internal/health
```

### Fallback Route: Static-First MVP
If full deployment is blocked:
1. Build static Next.js site with Book content baked in
2. Deploy to Railway (or Vercel/Netlify)
3. Add MongoDB later for dynamic features
4. Add Core container later for agent skills

**Validation**:
```bash
# Static build
cd deploy/web && npm run build
# Verify output in .next/
```

---

## Audit Matrix (Current Pass)

| Requirement | Status | Evidence |
|-------------|--------|----------|
| Spec suite complete and canonical | ✅ PASS | `nate-alma/specs/*.md` (10 files) |
| Service topology defined | ✅ PASS | 01-SPEC_RAILWAY_ARCHITECTURE.md |
| MongoDB schema specified | ✅ PASS | 03-SPEC_MONGO_SCHEMA.md |
| UI foundation established | ✅ PASS | 00-DECISION_UI_FOUNDATION.md |
| Endpoint contract defined | ✅ PASS | 09-SPEC_ENDPOINT_CONTRACT.md |
| Design system documented | ✅ PASS | 04-TECHP_DESIGN_SYSTEM.md |
| DECISION_164 workspace complete | ✅ PASS | DECISION_164_COMPLETION_REPORT.md |
| OpenClaw marked as client choice | ✅ PASS | This decision |
| Deployment structure planned | ✅ PASS | dev/ + deploy/ separation |

---

## Supersession Notice

**This decision supersedes the following decisions:**

| Decision | Reason for Supersession |
|----------|------------------------|
| **DECISION_146** | Single merged container architecture replaced by 3-service topology |
| **DECISION_165** | Success criteria based on OpenClaw public exposure; new architecture has Next.js as public entry |
| **DECISION_168** | QMD deployment approach differs; Next.js is now primary service |

**Historical Value**: These decisions captured the OpenClaw-first approach and Railway deployment patterns. Lessons learned (config remediation, dependency management, rollback procedures) are preserved in deployment journals.

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-172-01 | Create `deploy/` directory structure | @openfixer | Pending | Critical |
| ACT-172-02 | Build Next.js Dockerfile | @windfixer | Pending | Critical |
| ACT-172-03 | Build Core container Dockerfile (QMD + optional OpenClaw) | @openfixer | Pending | Critical |
| ACT-172-04 | Create Railway deployment config (railway.toml) | @openfixer | Pending | High |
| ACT-172-05 | Implement MongoDB connection layer | @windfixer | Pending | High |
| ACT-172-06 | Build Library page (Book TOC) | @windfixer | Pending | High |
| ACT-172-07 | Build Reader page (section view) | @windfixer | Pending | High |
| ACT-172-08 | Build Agent panel with 6 MVP skills | @windfixer | Pending | Medium |
| ACT-172-09 | Implement Notes/Highlights/Bookmarks | @windfixer | Pending | Medium |
| ACT-172-10 | Implement Playbooks (draft + published) | @windfixer | Pending | Medium |
| ACT-172-11 | Build Admin minimal (reindex + status) | @windfixer | Pending | Medium |
| ACT-172-12 | Deploy to Railway and validate | @openfixer | Pending | Critical |

---

## Consultation Results

### Designer Consultation - COMPLETED
**File**: `STR4TEG15T/memory/consultations/DECISION_172_DESIGNER.md`  
**Approval Score**: **88/100** (Conditional Approval)  
**Status**: ✅ Approved with recommendations

#### Scoring Breakdown
| Criterion | Score | Max | Rationale |
|-----------|-------|-----|-----------|
| Architecture coherence | 18/20 | 20 | Clean 3-service topology with clear boundaries |
| Component feasibility | 19/20 | 20 | All shadcn/ui components available |
| Layout viability | 16/20 | 20 | 3-column shell works but responsive strategy underspecified |
| Data flow correctness | 18/20 | 20 | Solid endpoint contracts, proper auth boundary |
| Implementation clarity | 17/20 | 20 | Well-specified but Core container complexity needs detail |

#### Key Findings

**✅ Strengths:**
- All shadcn/ui components available (NavigationMenu, ScrollArea, CommandDialog, Accordion, etc.)
- Strong "Calm Research UI" design system with clear tokens
- Clean architecture with proper service separation
- Comprehensive MongoDB schema supports all MVP flows

**⚠️ Must Address (4 items):**
1. **Responsive breakpoints** - 3-column layout (1400px min) exceeds common laptop screens (1366px)
2. **Core container startup order** - OpenClaw + QMD + SFTPGo bundling needs initialization sequence
3. **MongoDB connection pooling** - Guidance needed for Railway deployment
4. **Sleep/scale-to-zero UX** - Loading states when Core container is sleeping

**📋 Component Gaps Requiring Custom Build:**
- Highlight Tool (text selection → floating toolbar)
- Agent Output Renderer (structured display for skill outputs)
- Scenario Tree Visualizer (If/Then playbook builder)
- Flashcard/Quiz Renderer

### Oracle Consultation - PENDING
**Scope**: Validate security boundaries and risk posture for 3-service architecture

## Consultation Plan

**Oracle**: Validate security boundaries and risk posture for 3-service architecture

Consultation to run with 15-minute timeout.

---

## Pass Questions (Harden / Expand / Narrow)

- **Harden**: What is the fallback if QMD indexing fails? Do we have a Mongo text search fallback ready?
- **Expand**: Should we add a 4th "jobs" service for background indexing, or keep it in Core?
- **Narrow**: For MVP, can we defer OpenClaw integration entirely and launch with static agent responses?

---

## Closure Checklist Draft

- [ ] All 3 services deployed to Railway
- [ ] Service-to-service auth working
- [ ] Book Reader functional (TOC + content)
- [ ] Notes/Highlights/Bookmarks working
- [ ] Playbooks functional
- [ ] Admin minimal working
- [ ] All specs compliance verified
- [ ] Deployment journals captured
- [ ] Manifest updated

---

## Strategist Retrospective

**What worked**: Nexus provided comprehensive spec suite covering all architectural layers
**What drifted**: Prior decisions assumed OpenClaw-first; new specs pivot to Book-first
**What to automate**: Generate endpoint contract validation tests from spec files
**What to enforce next**: Spec-driven development - all implementation must trace to spec

---

*Decision DECISION_172*  
*Book-First MVP Architecture - Full Pivot to QMD*  
*2026-02-28*
