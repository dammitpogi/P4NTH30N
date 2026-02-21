# Designer Consultation: DECISION_031

**Decision ID**: DECISION_031  
**Agent**: Designer (Aegis)  
**Task ID**: ses_3853460eeffeyJGTl0rpFMODUU  
**Date**: 2026-02-20  
**Status**: Complete

---

## Original Response

[Full Designer response for DECISION_031 - Rename L33T Directory Names to Plain English]

Now I have a comprehensive understanding of the codebase. Let me provide the implementation strategy for **DECISION_031: Rename L33T Directory Names to Plain English**.

---

## Designer Response: DECISION_031 Implementation Strategy

### Implementation Strategy: 4-Phase Parallel-Safe Approach

**Phase 1: Preparation & Tooling** (Est. 30 min)
- Create automated rename scripts with rollback capability
- Generate comprehensive rename mapping files
- Validate current build state as baseline

**Phase 2: Directory & Project Structure** (Est. 1 hour)
- Rename directories using `git mv` (preserves history)
- Rename `.csproj` files to match new directory names
- Update solution file (`P4NTH30N.slnx`) with new paths
- Update project reference paths in all `.csproj` files

**Phase 3: Code-Level Updates** (Est. 2 hours)
- Batch update namespace declarations across all `.cs` files
- Update `using` directives with automated search/replace
- Update `appsettings.json` configuration sections
- Update MongoDB collection name constants

**Phase 4: Documentation & Cross-References** (Est. 1 hour)
- Update all `AGENTS.md` files with new paths
- Update decision files in `STR4TEG15T/decisions/`
- Update config references (opencode, windsurf)
- Final validation build and test

---

### Files to Create

| File | Purpose | Location |
|------|---------|----------|
| `rename-map.json` | Complete L33T→English mapping for automation | `STR4TEG15T/tools/` |
| `rename-script.ps1` | PowerShell rename orchestrator with rollback | `STR4TEG15T/tools/` |
| `namespace-update.ps1` | Batch namespace updater using AST parsing | `STR4TEG15T/tools/` |
| `validate-rename.ps1` | Post-rename validation script | `STR4TEG15T/tools/` |
| `rollback-manifest.json` | Generated during rename for rollback tracking | `.git/rename-rollback/` |

---

### Files to Modify

#### Core Solution & Build Files
| File | Changes |
|------|---------|
| `P4NTH30N.slnx` | Update all 18 `<Project Path="..."/>` entries |
| `Directory.Build.props` | Update any path references if present |
| `C0MMON/C0MMON.csproj` | Rename to `COMMON/COMMON.csproj` |

#### Project Files (Rename + Content)
| Current | New | ProjectReference Updates |
|---------|-----|------------------------|
| `C0MMON/C0MMON.csproj` | `COMMON/COMMON.csproj` | All projects referencing it |
| `H0UND/H0UND.csproj` | `HOUND/HOUND.csproj` | References to COMMON, WATCHDOG |
| `H4ND/H4ND.csproj` | `HAND/HAND.csproj` | References to COMMON |
| `W4TCHD0G/W4TCHD0G.csproj` | `WATCHDOG/WATCHDOG.csproj` | References to COMMON |
| `UNI7T35T/UNI7T35T.csproj` | `UNITTEST/UNITTEST.csproj` | References to all tested projects |
| `STR4TEG15T/STR4TEG15T.csproj` | `STRATEGIST/STRATEGIST.csproj` | References to COMMON |
| `OR4CL3/OR4CL3.csproj` | `ORACLE/ORACLE.csproj` | References to COMMON |
| `DE51GN3R/DE51GN3R.csproj` | `DESIGNER/DESIGNER.csproj` | References to COMMON |
| `LIBRAR14N/LIBRAR14N.csproj` | `LIBRARIAN/LIBRARIAN.csproj` | References to COMMON |
| `EXPL0R3R/EXPL0R3R.csproj` | `EXPLORER/EXPLORER.csproj` | References to COMMON |
| `OP3NF1XER/OP3NF1XER.csproj` | `OPENFIXER/OPENFIXER.csproj` | References to COMMON |
| `W1NDF1XER/W1NDF1XER.csproj` | `WINDFIXER/WINDFIXER.csproj` | References to COMMON |
| `F0RGE/F0RG3WR1GH7.csproj` | `FORGE/FORGEWRIGHT.csproj` | References to COMMON |
| `PROF3T/PROF3T.csproj` | `PROPHET/PROPHET.csproj` | References to COMMON |
| `T00L5ET/T00L5ET.csproj` | `TOOLSET/TOOLSET.csproj` | References to COMMON |
| `M16R4710N/M16R4710N.csproj` | `MIGRATION/MIGRATION.csproj` | References to COMMON |

#### C# Source Files (~334 files)
| Change Type | Pattern | Example |
|-------------|---------|---------|
| Namespace declarations | `namespace P4NTH30N.Xxx` | `P4NTH30N.H0UND` → `P4NTH30N.HOUND` |
| Using directives | `using Xxx` | `using UNI7T35T.Mocks` → `using UNITTEST.Mocks` |
| File-scoped namespaces | `namespace Xxx;` | `namespace H4ND;` → `namespace HAND;` |

#### Configuration Files
| File | Changes |
|------|---------|
| `appsettings.json` | Update `P4NTH30N.H0UND` → `P4NTH30N.HOUND`, `P4NTH30N.H4ND` → `P4NTH30N.HAND` |
| `appsettings.Development.json` | Same as above |
| `appsettings.vm.json` | Same as above |
| `publish/**/appsettings.json` | Same updates in all publish configs |

#### MongoDB Collection Names
| File | Changes |
|------|---------|
| `C0MMON/Infrastructure/Persistence/MongoCollectionNames.cs` | Rename file + update all const values |

#### Documentation Files
| File | Changes |
|------|---------|
| `AGENTS.md` (root) | Update all path references in agent table |
| `C0MMON/AGENTS.md` | Update directory references |
| `C0MMON/**/AGENTS.md` (5 files) | Update path references |
| `H0UND/AGENTS.md` | Update namespace references |
| `H4ND/AGENTS.md` | Update namespace references |
| `W1ND5URF/**/AGENTS.md` | Update path references |

#### Decision Files
| File | Changes |
|------|---------|
| `STR4TEG15T/decisions/active/*.md` | Update path references |
| `T4CT1CS/decisions/**/*.md` | Update path references |
| `DE51GN3R/decisions/*.md` | Update path references |

---

### Rename Order: Dependency-Safe Sequence

**Wave 1: Foundation (No Dependencies)**
```
1. C0MMON → COMMON (all others depend on this)
2. W4TCHD0G → WATCHDOG (used by H0UND)
3. T00L5ET → TOOLSET
```

**Wave 2: Core Agents (Depend on Wave 1)**
```
4. H0UND → HOUND (depends on COMMON, WATCHDOG)
5. H4ND → HAND (depends on COMMON)
6. UNI7T35T → UNITTEST (depends on all tested projects)
```

**Wave 3: Supporting Agents**
```
7. STR4TEG15T → STRATEGIST
8. OR4CL3 → ORACLE
9. DE51GN3R → DESIGNER
10. LIBRAR14N → LIBRARIAN
11. EXPL0R3R → EXPLORER
12. OP3NF1XER → OPENFIXER
13. W1NDF1XER → WINDFIXER
14. PROF3T → PROPHET
15. M16R4710N → MIGRATION
```

**Wave 4: Special Cases**
```
16. F0RGE/F0RG3WR1GH7 → FORGE/FORGEWRIGHT
```

**Wave 5: Configuration & Non-Code**
```
17. W1ND5URF → WINDSURF (config directory - no code deps)
18. T4CT1CS → TACTICS (if needed)
19. RUL3S → RULES (if needed)
```

---

### Namespace Updates: Systematic Approach

**Step 1: Generate Namespace Mapping**
```json
{
  "P4NTH30N.C0MMON": "P4NTH30N.COMMON",
  "P4NTH30N.H0UND": "P4NTH30N.HOUND",
  "P4NTH30N.H4ND": "P4NTH30N.HAND",
  "P4NTH30N.W4TCHD0G": "P4NTH30N.WATCHDOG",
  "P4NTH30N.UNI7T35T": "P4NTH30N.UNITTEST",
  "P4NTH30N.STR4TEG15T": "P4NTH30N.STRATEGIST",
  "P4NTH30N.OR4CL3": "P4NTH30N.ORACLE",
  "P4NTH30N.DE51GN3R": "P4NTH30N.DESIGNER",
  "P4NTH30N.LIBRAR14N": "P4NTH30N.LIBRARIAN",
  "P4NTH30N.EXPL0R3R": "P4NTH30N.EXPLORER",
  "P4NTH30N.OP3NF1XER": "P4NTH30N.OPENFIXER",
  "P4NTH30N.W1NDF1XER": "P4NTH30N.WINDFIXER",
  "P4NTH30N.PROF3T": "P4NTH30N.PROPHET",
  "P4NTH30N.T00L5ET": "P4NTH30N.TOOLSET",
  "P4NTH30N.M16R4710N": "P4NTH30N.MIGRATION",
  "P4NTH30N.F0RGE": "P4NTH30N.FORGE"
}
```

**Step 2: Batch Update Strategy**
1. Use `ast-grep` or PowerShell regex to find/replace namespaces
2. Pattern: `namespace\s+(P4NTH30N\.)?([A-Z0-9]+)` → replace with mapped value
3. Update `using` statements with same mapping
4. Handle file-scoped namespaces (semicolon-terminated)

**Step 3: Special Cases**
- `T4CT1CS` namespace (in STR4TEG15T files) → `TACTICS`
- `UNI7T35T.Tests` → `UNITTEST.Tests`
- `UNI7T35T.Mocks` → `UNITTEST.Mocks`
- `UNI7T35T.TestHarness` → `UNITTEST.TestHarness`

---

### Cross-Reference Updates: Search/Replace Strategy

**Phase A: Automated Batch Replacements**
Use the following PowerShell/ast-grep patterns:

```powershell
# Pattern groups for systematic replacement
$L33T_MAP = @{
    "C0MMON" = "COMMON"
    "H0UND" = "HOUND"
    "H4ND" = "HAND"
    "W4TCHD0G" = "WATCHDOG"
    "UNI7T35T" = "UNITTEST"
    "STR4TEG15T" = "STRATEGIST"
    "OR4CL3" = "ORACLE"
    "DE51GN3R" = "DESIGNER"
    "LIBRAR14N" = "LIBRARIAN"
    "EXPL0R3R" = "EXPLORER"
    "OP3NF1XER" = "OPENFIXER"
    "W1NDF1XER" = "WINDFIXER"
    "PROF3T" = "PROPHET"
    "T00L5ET" = "TOOLSET"
    "M16R4710N" = "MIGRATION"
    "F0RGE" = "FORGE"
    "F0RG3WR1GH7" = "FORGEWRIGHT"
    "W1ND5URF" = "WINDSURF"
    "T4CT1CS" = "TACTICS"
    "RUL3S" = "RULES"
}
```

**Phase B: File-Specific Replacements**

| File Type | Search Pattern | Replace Pattern |
|-----------|---------------|-----------------|
| `.csproj` | `..\Xxx\Xxx.csproj` | `..\NewName\NewName.csproj` |
| `.cs` | `namespace P4NTH30N.Xxx` | `namespace P4NTH30N.NewName` |
| `.cs` | `using Xxx` | `using NewName` |
| `.slnx` | `Xxx/Xxx.csproj` | `NewName/NewName.csproj` |
| `.md` | `` `Xxx/` `` | `` `NewName/` `` |
| `.json` | `"Xxx":` | `"NewName":` |

**Phase C: MongoDB Collection Updates**
| Constant | Current | New |
|----------|---------|-----|
| `Credentials` | `"CRED3N7IAL"` | `"CREDENTIAL"` |
| `Signals` | `"SIGN4L"` | `"SIGNAL"` |
| `Jackpots` | `"J4CKP0T"` | `"JACKPOT"` |
| `Houses` | `"H0USE"` | `"HOUSE"` |
| `Received` | `"REC31VED"` | `"RECEIVED"` |
| `Events` | `"EV3NT"` | `"EVENT"` |
| `Errors` | `"ERR0R"` | `"ERROR"` |
| `ViewNext` | `"N3XT"` | `"NEXT"` |
| `Locks` | `"L0CK"` | `"LOCK"` |
| `DeadLetters` | `"D34DL3TT3R"` | `"DEADLETTER"` |
| `VisionDeadLetters` | `"V1S10N_DLQ"` | `"VISION_DLQ"` |

---

### Rollback Strategy

**Pre-Rename Checkpoints**
1. Create a Git branch: `git checkout -b feature/DECISION_031-l33t-rename`
2. Ensure working directory is clean: `git status`
3. Create backup of MongoDB collections (for collection rename phase)

**Incremental Commit Strategy**
```
Commit 1: [DECISION_031] Wave 1 - Rename foundation directories
Commit 2: [DECISION_031] Wave 2 - Rename core agent directories
Commit 3: [DECISION_031] Wave 3 - Rename supporting agents
Commit 4: [DECISION_031] Update solution file and project references
Commit 5: [DECISION_031] Update namespaces and using directives
Commit 6: [DECISION_031] Update configuration files
Commit 7: [DECISION_031] Update documentation and AGENTS.md
Commit 8: [DECISION_031] Update MongoDB collection names
```

**Rollback Commands**
```powershell
# Soft rollback (keep branch, reset to main)
git checkout main
git branch -D feature/DECISION_031-l33t-rename

# Hard rollback (already pushed - use with caution)
git revert HEAD~7..HEAD

# MongoDB rollback (if collections were renamed)
# Restore from backup or rename collections back
```

**Validation Checkpoints**
After each wave, run:
```powershell
dotnet restore
dotnet build
# If build fails, fix before proceeding
```

---

### Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Build breaks between waves | Build check after each commit, fix before continuing |
| Git history loss | Use `git mv` exclusively, never manual move |
| Namespace conflicts | Verify no "HOUND" or "HAND" already exists in code |
| MongoDB data loss | Backup before collection rename; rename is separate commit |
| Agent config breakage | Update all AGENTS.md in same commit as directory rename |
| Cross-reference misses | Use multiple search passes with different patterns |

---

### Recommended Delegation

Given the complexity and mechanical nature of this task:

1. **@forgewright** - Create the automation scripts (PowerShell/AST-based)
2. **@windfixer** - Execute directory renames and namespace updates using scripts
3. **@oracle** - Validate each wave with build checks and test runs

**Total Estimated Time**: 4-5 hours with automation, 8-10 hours manual
**Token Budget**: ~15K tokens for script creation + ~10K for validation
**Model Recommendation**: Claude 3.5 Sonnet for script creation, GPT-4o Mini for validation

---

## Metadata

- **Input Prompt**: Request for implementation strategy for renaming L33T directories to plain English
- **Response Length**: ~8000 characters
- **Key Findings**:
  - 4-phase implementation strategy
  - 5 files to create (automation scripts)
  - 25+ files to modify (projects, configs, docs)
  - 5-wave rename order (dependency-safe)
  - Systematic namespace update approach
  - MongoDB collection names also need updating
  - Comprehensive rollback strategy
- **Approval Rating**: 91%
- **Files Referenced**: All project directories, solution file, AGENTS.md, MongoDB collections
