# TECH-004: Decisions-Server Tool Enhancement

**Oracle Approval**: 60% (Conditional) → 85% with safeguards  
**Designer Approval**: Pending  
**Status**: Ready for Fixer with conditions

---

## Summary

Decision TECH-004 created to enhance the decisions-server MCP tool with:
- Batch operations (create decisions, add action items)
- Dependency management (circular detection, visual trees)
- Automated reporting (Fixer briefs, markdown export)
- Validation framework (completeness checks)

---

## Oracle Assessment

**Approval**: 60% conditional

**Key Concerns Addressed**:
1. ✅ **Security**: Path validation, file export restrictions
2. ✅ **Data Corruption**: Transaction simulation, atomic writes
3. ✅ **Validation Rigidity**: Severity tiers (Blocking/Warning/Info)
4. ✅ **Persistence**: JSON file storage, not database

**Action Items Added** (5 tasks):
- JSON persistence with atomic writes
- Path validation for security
- Severity-tiered validation
- Transaction simulation
- Unit tests before enhancement

**Oracle Conditions for 85% Approval**:
- Use JSON persistence (not database)
- Implement transaction safety
- Restrict file exports to user directory
- Add severity-tiered validation
- Include unit tests

---

## Designer Assessment

**Status**: Consultation initiated, awaiting response

**Questions Asked**:
1. Architectural alignment with strategic workflow
2. Reporting tool integration approach
3. Dependency tree export format
4. Essential vs nice-to-have features
5. Blind spots in enhancement plan

---

## Implementation for Fixer

**Decision ID**: TECH-004  
**Priority**: Medium (after FourEyes implementation)  
**Effort**: 3-5 days

**Start After**:
- FourEyes system fully operational
- Current decisions-server stable
- Unit tests in place

**Order of Implementation**:
1. Persistence layer (JSON storage)
2. Security layer (path validation)
3. Batch operations API
4. Dependency management
5. Reporting generation
6. Validation framework

---

## Total Decisions

- **46 total decisions** (45 + TECH-004)
- **76 action items** (71 + 5 new)
- **Oracle Approval**: 87% (FourEyes), 60% (Tool Enhancement)

---

**Fixer Can Query**: TECH-004 via decisions-server for full specifications
