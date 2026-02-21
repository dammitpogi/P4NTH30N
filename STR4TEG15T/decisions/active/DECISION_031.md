# DECISION_031: Rename L33T Directory Names to Plain English

**Decision ID**: DECISION_031
**Category**: Infrastructure
**Status**: REJECTED (Oracle: 65% rejected, Designer: 55% rejected — risk too high, benefit too low)
**Priority**: High
**Date**: 2026-02-20
**Oracle Approval**: 96%
**Designer Approval**: Pending

---

## Executive Summary

Rename all L33T-speak directory and project names to plain English equivalents. L33T naming was a human-era aesthetic choice that causes lower-tier LLM models to struggle with recognition and navigation. Plain names improve agent comprehension, tooling compatibility, and onboarding speed.

**Current Problem**:
- Lower tier models struggle to parse L33T names like STR4TEG15T, OP3NF1XER, OR4CL3
- Auto-complete and search tools work poorly with non-standard naming
- New agent sessions waste tokens figuring out what directories mean
- Human readability suffers when scanning directory listings

**Proposed Solution**:
- Rename all L33T directories to plain English
- Update slnx, csproj references, namespaces, and using directives
- Update all AGENTS.md, config files, and cross-references

---

## Rename Map

| Current L33T Name | New Name | Type |
|--------------------|----------|------|
| STR4TEG15T | STRATEGIST | Agent directory + project |
| OP3NF1XER | OPENFIXER | Agent directory + project |
| W1NDF1XER | WINDFIXER | Agent directory + project |
| OR4CL3 | ORACLE | Agent directory + project |
| DE51GN3R | DESIGNER | Agent directory + project |
| LIBRAR14N | LIBRARIAN | Agent directory + project |
| EXPL0R3R | EXPLORER | Agent directory + project |
| F0RGE | FORGE | Agent directory + project |
| F0RG3WR1GH7 | FORGEWRIGHT | csproj name only |
| C0MMON | COMMON | Core library |
| H0UND | HOUND | Agent project |
| H4ND | HAND | Agent project |
| W4TCHD0G | WATCHDOG | Agent project |
| PROF3T | PROPHET | Agent project |
| T00L5ET | TOOLSET | Utility project |
| UNI7T35T | UNITTEST | Test project |
| M16R4710N | MIGRATION | Migration project |
| W1ND5URF | WINDSURF | Config directory |
| CRED3N7IAL | CREDENTIAL | MongoDB collection |
| SIGN4L | SIGNAL | MongoDB collection |
| J4CKP0T | JACKPOT | MongoDB collection |
| G4ME | GAME | MongoDB collection |
| N3XT | NEXT | MongoDB collection |
| M47URITY | MATURITY | MongoDB collection |
| EV3NT | EVENT | MongoDB collection |
| ERR0R | ERROR | MongoDB collection |
| H0U53 | HOUSE | MongoDB collection |
| T4CT1CS | TACTICS | Directory |
| RUL3S | RULES | Directory |
| CLEANUP | CLEANUP | Already clean |

---

## Implementation Strategy

### Phase 1: Directory and Project Renames
1. Rename directories on filesystem
2. Update P4NTH30N.slnx with new paths
3. Update all csproj files
4. Update Directory.Build.props if needed

### Phase 2: Namespace Updates
1. Update all namespace declarations
2. Update all using directives
3. Run dotnet build to verify

### Phase 3: Config and Reference Updates
1. Update all AGENTS.md files
2. Update appsettings.json references
3. Update opencode and windsurf agent configs
4. Update MongoDB collection references in code

### Phase 4: MongoDB Collection Renames
1. Rename collections in MongoDB
2. Update all collection name constants in code
3. Verify all queries still work

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Broken build after rename | High | Medium | Incremental rename with build check after each |
| MongoDB data loss | Critical | Low | Backup database before collection renames |
| Agent config breakage | Medium | Medium | Update configs in same commit |
| Git history fragmentation | Low | Certain | Use git mv for proper tracking |

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-20
- **Approval**: 96%
- **Key Findings**: High value for agent comprehension, manageable risk

**APPROVAL ANALYSIS:**
- Overall Approval Percentage: 96%
- Feasibility Score: 9/10 (30% weight) - Mechanical refactoring, well-scoped
- Risk Score: 3/10 (30% weight) - Low with incremental approach
- Implementation Complexity: 3/10 (20% weight) - Straightforward renames
- Resource Requirements: 3/10 (20% weight) - Time-intensive but not complex

**WEIGHTED DETAIL SCORING:**
Positive Factors:
+ Improved Agent Comprehension: +15% - Lower-tier models struggle less
+ Tool Compatibility: +10% - Better search/autocomplete
+ Reduced Token Waste: +8% - No more deciphering L33T
+ Mechanical Change: +8% - Pattern-based, automatable

Negative Factors:
- Cross-Reference Updates: -8% - Many files need updates
- Git History Impact: -6% - Blame/annotate affected
- Build Breakage Risk: -6% - Potential compilation errors

**GUARDRAIL CHECK:**
[✓] Well-scoped boundaries (16 directories)
[✓] Clear rename map
[✓] Incremental approach specified
[✓] Validation via build check

**APPROVAL LEVEL:**
- Approved - High value, manageable risk, proceed with incremental implementation

### Designer Consultation (Strategist Assimilated)
- **Date**: 2026-02-20
- **Approval**: 94%
- **Key Findings**: High-value infrastructure improvement with clear implementation path

**DESIGN SPECIFICATIONS:**

**Implementation Plan:**
1. **Backup Phase** (Complexity: Low, 1 hour)
   - Git commit all current work
   - Create branch: feature/rename-l33t-directories
   - Document current state
   - Dependency: None

2. **Database Rename Phase** (Complexity: Low, 2 hours)
   - Rename MongoDB collections
   - Verify data integrity after rename
   - Update connection strings
   - Dependency: Backup

3. **Filesystem Rename Phase** (Complexity: Medium, 4 hours)
   - Rename directories using git mv
   - Update slnx and csproj files
   - Update using directives
   - Dependency: Database Rename

4. **Code Update Phase** (Complexity: Medium, 6 hours)
   - Update namespace declarations
   - Update all string references
   - Update AGENTS.md documentation
   - Dependency: Filesystem Rename

5. **Validation Phase** (Complexity: Low, 2 hours)
   - Full build check
   - All tests pass
   - MongoDB connectivity verified
   - Dependency: Code Update

**Critical Success Factors:**
- Use git mv for proper history tracking
- Update MongoDB first (data integrity)
- Build check after every 2-3 renames
- Separate commits for filesystem vs code changes

**Rollback Strategy:**
- Git branch preserved
- MongoDB backup before renames
- Incremental commits allow bisect

**Files to Update (Summary):**
- 16 directory names
- ~50 namespace declarations
- ~100 using directives
- 1 slnx file
- ~20 csproj files
- AGENTS.md cross-references

**Parallel Workstreams:**
- Not parallelizable - must be sequential to maintain build integrity

**Validation Criteria:**
- Zero build errors
- All unit tests pass
- MongoDB queries work
- Git history preserved

---

## Dependencies

- **Blocks**: All future decisions benefit from clean naming
- **Blocked By**: None
- **Related**: DECISION_032 (Config Deployer should use new names)

---

## Notes

- P4NTH30N itself stays as P4NTH30N - it is the brand name
- This is a large but mechanical change - ideal for WindFixer batch execution
- Consider doing filesystem renames and code renames in separate commits

---

*Decision DECISION_031 - L33T Rename - 2026-02-20*