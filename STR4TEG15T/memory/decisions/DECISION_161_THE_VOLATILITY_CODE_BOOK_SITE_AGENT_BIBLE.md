# DECISION_161: The Volatility Code - Book, Site, and Agent Bible

**Decision ID**: DECISION_161  
**Category**: FEAT  
**Status**: Draft  
**Priority**: High  
**Date**: 2026-02-26  
**Oracle Approval**: Pending  
**Designer Approval**: Pending

---

## Executive Summary

Build three integrated deliverables from Alma's teachings corpus:

1. **Book** ("The Volatility Code") - A structured 250-350 page exposition for Nate, organized in 5 Parts with 17 chapters and 52+ sections
2. **Site** - Public-facing web presence generated from Book content with search, navigation, and interactive features
3. **Agent Bible** - ALMA's operational reference: a condensed, query-optimized knowledge base for deterministic retrieval

This decision governs content architecture, production workflow, and the semantic retrieval system that connects all three deliverables.

---

## Companion Documents

- **Book Writing Plan (Part I)**: `DECISION_161_v1.1_BOOK_WRITING_PLAN.md` - Detailed fixer instructions with narrative arcs, source mapping, and Agent Bible integration specifications for Part I (Foundations)
- **Complete Section Specs**: `DECISION_161_v1.2_COMPLETE_SECTION_SPECS.md` - Narrative arcs and source mappings for all 62 sections (Parts II-V), plus narrative continuity map

## Scope Boundaries

**In Scope:**
- Book content production and organization
- Site generation pipeline from Book source
- Agent Bible compilation and indexing
- Unified semantic retrieval system
- Citation integrity across all deliverables

**Out of Scope (Parallel Work):**
- Railway deployment infrastructure (separate track)
- AnythingLLM integration (external system)
- OpenClaw/Chat widget deployment (DECISION_155)

---

## Deliverable 1: The Book (For Nate)

### Structure (from Book/*.json)

```
The Volatility Code/
├── Part I: Foundations (3 chapters, 14 sections)
│   ├── Ch 1: Why Fundamentals Mislead
│   ├── Ch 2: The Volatility Framework
│   └── Ch 3: Liquidity Is Everything
├── Part II: Microstructure and Dealer Flows (4 chapters, 17 sections)
│   ├── Ch 4: Gamma: The Market's Gravity
│   ├── Ch 5: Vanna and Speed Profiles
│   ├── Ch 6: Charm, Color and Dealer Hedging
│   └── Ch 7: The Intraday Playbook
├── Part III: Macro and Geopolitical Engine (3 chapters, 13 sections)
│   ├── Ch 8: Geopolitics and Volatility Regimes
│   ├── Ch 9: Financing the Bubble
│   └── Ch 10: The Hidden Left Tail
├── Part IV: Crisis Architecture (2 chapters, 8 sections)
│   ├── Ch 11: The Crisis Blueprint
│   └── Ch 12: Managed Stability
└── Part V: The Trader Mind (3 chapters, 12 sections)
    ├── Ch 13: The Wall Street Casino
    ├── Ch 14: Probability Over Prediction
    └── Ch 15: Do Not Marry a Side
```

### Content Production Workflow

**Phase 1: Source Retrieval (Per Section)**
1. Read section mission from Book/*.json
2. Query bible/ corpus using semantic retrieval
3. Extract relevant passages with citations
4. Map to section tags and anchor terms (from weights.json)

**Phase 2: Draft Composition**
1. Write section following Hybrid style (narrative + analytical)
2. Include inline citations: `bible/<filename>`
3. Add "How To Apply" and "Common Mistakes" subsections
4. End with "Self-Check" questions

**Phase 3: Review & Integration**
1. Verify all citations resolve to bible/ files
2. Check consistency with adjacent sections
3. Update cross-references
4. Mark section complete in tracking index

### Source Authority Chain

```
Primary: bible/*.md (processed teachings)
Secondary: substack/*.md (raw posts, for verification)
Tertiary: parts/*.json (topic index, for coverage validation)
```

---

## Deliverable 2: The Site (Public-Facing)

### Generation Pipeline

**Input**: Book content (markdown or structured JSON)
**Output**: Static HTML site with:
- Chapter/section navigation
- Search functionality (Pagefind or Fuse.js)
- Citation links to bible/ (where public)
- Responsive design

**Build Process**:
```bash
# 1. Process Book content
python site/process_book.py --input Book/ --output site/content/

# 2. Generate search index
python site/build_search_index.py --content site/content/

# 3. Build static site
# (Astro Starlight or custom generator)
```

### Site Structure

```
site/
├── index.html              # Landing + Book overview
├── part-i/
│   ├── index.html          # Part overview
│   ├── ch-1/
│   │   ├── index.html      # Chapter overview
│   │   └── sections/       # Individual sections
│   └── ...
├── part-ii/
├── search/                 # Search interface
├── bible/                  # Public bible excerpts
└── assets/                 # CSS, JS, images
```

### Features

1. **Progressive Reading**: Track reading progress (localStorage)
2. **Citations**: Hover-to-preview bible references
3. **Search**: Full-text across all Book content
4. **Print-Friendly**: CSS for PDF generation per chapter

---

## Deliverable 3: Agent Bible (For ALMA)

### Purpose

A condensed, query-optimized knowledge base that ALMA uses for:
- Answering Nate's trading questions with doctrine-backed precision
- Citing sources deterministically
- Maintaining continuity across sessions

### Structure

```
Agent Bible/
├── index.json              # Master index with section mappings
├── ontology.json           # weights.json enums and term weights
├── sections/               # One file per Book section
│   ├── part-i-ch-1-voting-machine.json
│   ├── part-i-ch-1-narratives.json
│   └── ...
├── quick-reference/
│   ├── gamma-mechanics.json
│   ├── vanna-dynamics.json
│   ├── regime-signals.json
│   └── risk-framework.json
└── citations/
    └── bible-map.json      # bible/ file metadata and hashes
```

### Section File Schema

```json
{
  "sectionId": "part-i-ch-1-voting-machine",
  "title": "Voting machine vs Weighing machine",
  "bookRef": "Part I, Chapter 1, Section 1",
  "mission": "Clarify the distinction between short-term sentiment pricing...",
  "tags": ["sentiment", "valuation", "regime shift"],
  "ontology": {
    "TopicEnum": ["FOUNDATIONS", "VOLATILITY"],
    "MechanismEnum": [],
    "StructurePatternEnum": ["VOTING_VS_WEIGHING"]
  },
  "sourcePassages": [
    {
      "bibleRef": "bible/unknown-date-what-is-volatility.md",
      "relevanceScore": 0.85,
      "excerpt": "Volatility is the annualized standard deviation...",
      "lineNumbers": [10, 25]
    }
  ],
  "keyConcepts": [
    {"term": "voting machine", "weight": 1.0},
    {"term": "weighing machine", "weight": 1.0},
    {"term": "regime shift", "weight": 0.9}
  ],
  "relatedSections": [
    "part-i-ch-2-volatility-framework",
    "part-v-ch-15-volatility-first"
  ]
}
```

---

## Unified Semantic Retrieval System

### Architecture

```
Query (ALMA or Book writer)
    ↓
Intent Classifier
    ↓
┌─────────────────┬─────────────────┬─────────────────┐
│  Book Section   │  Bible Search   │  Quick Ref      │
│  Lookup         │  (semantic)     │  (ontology)     │
└─────────────────┴─────────────────┴─────────────────┘
    ↓
Result Ranking (weighted ensemble)
    ↓
Citations + Context
```

### Components

**1. Intent Classifier**
- Input: Natural language query
- Output: Intent tag + confidence
- Intents: `section_lookup`, `concept_explanation`, `mechanism_detail`, `regime_analysis`, `risk_assessment`

**2. Book Section Lookup**
- Exact match on section titles
- Fuzzy match on mission statements
- Tag-based filtering

**3. Bible Search (Enhanced existing)**
- Token-based BM25 scoring
- Ontology enum expansion (from weights.json)
- Synonym group expansion
- Heading/summary boost

**4. Quick Reference (ontology-driven)**
- Direct enum lookup: "What is GAMMA?"
- Mechanism relationships: "How does VANNA affect SPEED?"
- Pattern matching: "Explain VOTING_VS_WEIGHING"

### API Design

```python
# Unified search interface
search_bible(
    query: str,
    intent: Optional[str] = None,
    book_section: Optional[str] = None,
    top_k: int = 5,
    include_citations: bool = True
) -> SearchResult

# Book-specific retrieval
get_section_sources(
    section_id: str,
    min_relevance: float = 0.6
) -> List[SourcePassage]

# ALMA quick query
ask_doctrine(
    question: str,
    context: Optional[str] = None
) -> DoctrineAnswer
```

---

## Requirements

### REQ-161-BOOK-STRUCTURE
**Book follows defined 5-Part structure with 52+ sections**
- **Acceptance**: All sections from ch_1.json through ch_4_5.json have corresponding content files
- **Validation**: `python scripts/validate_book_structure.py` returns 0 missing sections

### REQ-161-BIBLE-SOURCING
**Every Book section cites at least 2 bible sources**
- **Acceptance**: Each section file includes `sourcePassages` array with ≥2 entries
- **Validation**: Citation audit shows >95% coverage

### REQ-161-SITE-GENERATION
**Site builds automatically from Book content**
- **Acceptance**: `python site/build.py` generates complete static site
- **Validation**: Site passes HTML validation, all internal links resolve

### REQ-161-AGENT-BIBLE-INDEX
**Agent Bible provides <500ms query responses**
- **Acceptance**: Average query time <500ms for 100 test queries
- **Validation**: Benchmark script shows p95 <800ms

### REQ-161-CITATION-INTEGRITY
**All citations resolve to existing bible files**
- **Acceptance**: No broken bible/ references in any deliverable
- **Validation**: `python scripts/audit_citations.py` returns 0 errors

### REQ-161-ONTOLOGY-ALIGNMENT
**All content tagged with weights.json enums**
- **Acceptance**: Every section has TopicEnum + at least one MechanismEnum or StructurePatternEnum
- **Validation**: Ontology coverage report shows 100% tagging

---

## Implementation Phases

### Phase 1: Foundation (Week 1)
- [ ] Finalize Book/*.json section schemas with full metadata
- [ ] Build unified semantic retrieval core (`search_unified.py`)
- [ ] Create section-to-bible mapping for Part I (14 sections)
- [ ] Draft Part I content

### Phase 2: Content Production (Weeks 2-4)
- [ ] Write Part II (Microstructure) - 17 sections
- [ ] Write Part III (Macro) - 13 sections
- [ ] Build Agent Bible index incrementally
- [ ] Generate Site for completed Parts

### Phase 3: Completion (Week 5)
- [ ] Write Part IV (Crisis) - 8 sections
- [ ] Write Part V (Mind) - 12 sections
- [ ] Full citation audit and repair
- [ ] Final Site build with search index
- [ ] Agent Bible validation and optimization

### Phase 4: Integration (Week 6)
- [ ] ALMA integration testing
- [ ] End-to-end workflow validation
- [ ] Documentation and handoff

---

## File Locations

```
OP3NF1XER/nate-alma/dev/memory/alma-teachings/
├── Book/                           # Source of truth
│   ├── the_volatility_code.json    # Master manifest
│   ├── weights.json                # Ontology and semantic weights
│   ├── ch_1.json                   # Part I structure
│   ├── ch_2.json                   # Part II structure
│   ├── ch_3.json                   # Part III structure
│   ├── ch_4_5.json                 # Parts IV-V structure
│   └── content/                    # Generated/written content
│       ├── part-i/
│       │   ├── ch-1/
│       │   │   ├── 01-voting-machine.md
│       │   │   ├── 02-narratives.md
│       │   │   └── ...
│       │   └── ...
│       └── ...
├── bible/                          # Source corpus (existing)
│   └── *.md                        # 100+ teaching files
├── index/                          # Generated indexes
│   ├── bible-index.json
│   ├── semantic-index.json
│   └── agent-bible/
│       ├── index.json
│       ├── ontology.json
│       └── sections/
├── site/                           # Generated site (existing + new)
│   ├── content/                    # Book-derived content
│   ├── build.py                    # Site generator
│   └── ...
└── skills/
    └── doctrine-engine/
        ├── scripts/
        │   ├── search_unified.py   # NEW: Unified retrieval
        │   ├── build_agent_bible.py # NEW: Agent Bible compiler
        │   ├── validate_book.py    # NEW: Structure validator
        │   └── audit_citations.py  # NEW: Citation checker
        └── SKILL.md                # Updated with new tools
```

---

## Validation Commands

```bash
# Validate Book structure
python skills/doctrine-engine/scripts/validate_book.py

# Run citation audit
python skills/doctrine-engine/scripts/audit_citations.py --fix

# Test semantic retrieval
python skills/doctrine-engine/scripts/search_unified.py \
  --query "gamma flip zones" \
  --book-section "part-ii-ch-4"

# Build Agent Bible
python skills/doctrine-engine/scripts/build_agent_bible.py

# Full site build
python site/build.py --book Book/content/ --output site/dist/

# Performance benchmark
python skills/doctrine-engine/scripts/benchmark_retrieval.py --queries 100
```

---

## Closure Criteria

- [ ] All 62 sections written and cited
- [ ] Site builds without errors
- [ ] Agent Bible responds to 100 test queries with >90% relevance
- [ ] Citation audit: 0 broken references
- [ ] Ontology coverage: 100% of sections tagged
- [ ] ALMA can answer "What does Alma say about X?" for any core concept

---

## Questions to Harden

1. **Book format**: Should sections be markdown files or remain in JSON with content fields?
2. **Citation granularity**: File-level or line-range-level citations?
3. **Agent Bible updates**: Rebuild on every bible/ change, or scheduled?
4. **Site deployment**: Auto-deploy on Book update, or manual trigger?
5. **ALMA integration**: Should the search tool be exposed as MCP or CLI-only?

---

## Consultation Log

*Pending Oracle and Designer review*

---

## Audit

*To be completed after implementation*

---

## Closure Recommendation

*Pending audit results*
