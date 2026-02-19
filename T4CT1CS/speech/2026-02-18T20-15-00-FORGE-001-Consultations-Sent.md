# Consultations Dispatched: FORGE-001 Directory Architecture

**Date**: 2026-02-18 20:15:00  
**Topic**: FORGE-001 Directory Architecture Standardization  
**Status**: Consultations Requested  
**Sent To**: Oracle, Designer (parallel)

---

## Summary

FORGE-001 Decision for T4CT1CS Directory Architecture Standardization has been created and consultations have been dispatched in parallel to Oracle and Designer.

## Decision Overview

**FORGE-001** establishes a complete standardized directory architecture for the Strategist platform:

- **Hierarchical structure** with strict content-type separation
- **Standardized naming conventions** enforced by convention
- **Clear read/write permissions** per directory for subagents
- **Automated indexing** via `.index/` directory
- **Validation gates** for file placement

## Key Architectural Changes

1. **`.index/`** - Master registries (read-only for subagents)
2. **`decisions/`** - Split into templates, archive, active, clusters
3. **`actions/`** - Workflow states: ready → in-progress → done
4. **`consultations/`** - Separate oracle/ and designer/ directories
5. **`intelligence/`** - Categorized: gaps, risks, opportunities, patterns
6. **`context/`** - Shared briefs, sessions, references

## Consultation Requests

### Oracle (Risk Assessment)
**File**: `consultations/oracle/2026-02-18T20-15-00-FORGE-001.md`

Key questions:
- Risks of restructure during active development
- 48-hour migration window feasibility
- Permission matrix validation
- Fallback mechanisms

### Designer (Implementation Planning)
**File**: `consultations/designer/2026-02-18T20-15-00-FORGE-001.md`

Key questions:
- Implementation feasibility
- Migration strategy and phasing
- Subagent experience (Fixer usability)
- WindSurf integration guidance

## Files Created

1. **Decision**: `decisions/active/FORGE-001-Directory-Architecture.md`
2. **Oracle Request**: `consultations/oracle/2026-02-18T20-15-00-FORGE-001.md`
3. **Designer Request**: `consultations/designer/2026-02-18T20-15-00-FORGE-001.md`
4. **Quick Reference**: `context/references/SUBAGENT-QUICK-REFERENCE.md`
5. **Index Schemas**: `.index/decisions.json`, `.index/actions.json`, `.index/speech.json`
6. **Templates**: `decisions/_templates/DECISION-TEMPLATE.md`, `decisions/_templates/CLUSTER-TEMPLATE.json`, `actions/_templates/ACTION-TEMPLATE.md`
7. **Updated README**: `README.md`

## Next Steps

1. Await Oracle consultation response
2. Await Designer consultation response
3. Synthesize findings into final Decision
4. Execute migration if approved
5. Brief all subagents on new structure

## Migration Scope (Pending Approval)

- **Decisions**: 8+ files to migrate with new naming
- **Actions**: 10+ files to relocate and rename
- **Speech**: 50+ files to normalize timestamps
- **Directories**: audit/, intel/ to consolidate into intelligence/

---

*Parallel consultation request sent*  
*Awaiting Oracle and Designer assessment*
