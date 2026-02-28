# STRATEGY-008: Librarian Workflow Strategy

> **Status**: APPROVED (92% Oracle approval)
> **Created**: 2026-02-18
> **Owner**: Oracle
> **Staleness**: 90 days (architecture-tier)

---

## 1. Overview

The Librarian is responsible for documentation currency, cross-referencing, and context injection across the P4NTHE0N codebase. This strategy defines protocols for how documentation stays synchronized with code changes.

---

## 2. Context Injection Protocol

### 2.1 Injection Sources

| Source | Injected Into | Trigger |
|--------|--------------|---------|
| `AGENTS.md` (root) | All agent sessions | Session start |
| `*/AGENTS.md` (per-project) | Agent working in that project | Directory entry |
| `*/codemap.md` | Agent exploring that directory | Directory entry |
| `docs/GOVERNANCE.md` | Decision-making sessions | Oracle escalation |
| `docs/components/*/AGENT_MANIFEST.md` | Agent behavior verification | Agent startup, incident review |
| `docs/runbooks/*.md` | Operational sessions | Troubleshooting, deployment |

### 2.2 Injection Rules

1. **Always inject**: Root `AGENTS.md` — provides build commands, code style, architecture overview
2. **Directory-scoped**: `codemap.md` and project `AGENTS.md` injected only when agent operates in that directory
3. **On-demand**: Runbooks and manifests injected when context matches (troubleshooting, deployment, review)
4. **Never inject**: Raw source code, binary files, `.git/` internals, `bin/`/`obj/` directories

### 2.3 Injection Priority (when context window is constrained)

```
Priority 1: Root AGENTS.md (always)
Priority 2: Active project AGENTS.md + codemap.md
Priority 3: Relevant docs/ files for current task
Priority 4: Cross-referenced docs from bidirectional links
Priority 5: Historical decisions from T4CT1CS/
```

---

## 3. Cross-Reference Contract

### 3.1 Bidirectional Link Format

Every documentation file that references another MUST use bidirectional links:

```markdown
<!-- Forward reference -->
See [H0UND Agent Manifest](docs/components/H0UND/AGENT_MANIFEST.md) for behavior specification.

<!-- Back-reference (in the target file) -->
Referenced by: [GOVERNANCE.md](docs/GOVERNANCE.md), [OPERATIONS.md](docs/runbooks/OPERATIONS.md)
```

### 3.2 Link Registry

| Document | References | Referenced By |
|----------|-----------|---------------|
| `AGENTS.md` (root) | All project AGENTS.md, GOVERNANCE.md | — (entry point) |
| `docs/GOVERNANCE.md` | Agent manifests, runbooks | Root AGENTS.md, decision docs |
| `docs/components/H0UND/AGENT_MANIFEST.md` | CircuitBreaker.cs, SignalService.cs, ForecastingService.cs | GOVERNANCE.md, OPERATIONS.md |
| `docs/components/H4ND/AGENT_MANIFEST.md` | H4ND.cs, Login.cs, Spin.cs | GOVERNANCE.md, OPERATIONS.md |
| `docs/runbooks/OPERATIONS.md` | Agent manifests, CI_HEALTH.md | GOVERNANCE.md |
| `docs/runbooks/CI_HEALTH.md` | UNI7T35T test suites | OPERATIONS.md |
| `UNI7T35T/AGENTS.md` | Test files, mock files | Root AGENTS.md |

### 3.3 Orphan Detection

A document is **orphaned** if:
- It has zero incoming references (no other doc links to it)
- It is not a root entry point (`AGENTS.md`, `README.md`, `INDEX.md`)

Orphaned docs should be either linked or archived during review cycles.

---

## 4. Update Trigger Events

### 4.1 File Modified Trigger

```
IF file in [C0MMON/, H0UND/, H4ND/] is modified
  AND change > 10 lines
  THEN flag associated codemap.md for regeneration
  AND flag associated AGENTS.md for review
```

**Cartography integration**:
```powershell
# Detect which maps need updating after code changes
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py changes --root ./

# Update all affected codemaps
python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update --root ./
```

### 4.2 Time Elapsed Trigger

| Document Tier | Max Age | Action |
|--------------|---------|--------|
| Runbooks | 30 days | Flag for review, notify Oracle |
| Components | 60 days | Flag for review |
| Architecture | 90 days | Schedule Oracle review session |

**Staleness check** (manual or CI):
```powershell
# Check Last Reviewed dates in doc headers
Get-ChildItem -Recurse -Filter "*.md" docs/ | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match "Last Reviewed:\s*(\d{4}-\d{2}-\d{2})") {
        $reviewed = [DateTime]::Parse($matches[1])
        $age = (Get-Date) - $reviewed
        if ($age.Days -gt 30) {
            Write-Host "STALE ($($age.Days)d): $($_.FullName)"
        }
    }
}
```

### 4.3 Dependency Change Trigger

```
IF NuGet package updated (major version)
  THEN flag docs/SYSTEM_REQUIREMENTS.md for review
  AND flag affected component AGENTS.md

IF new MongoDB collection added
  THEN update root AGENTS.md data model table
  AND update GOVERNANCE.md ownership matrix

IF new test suite added
  THEN update docs/runbooks/CI_HEALTH.md test coverage table
  AND wire into UNI7T35T/Program.cs
```

### 4.4 Decision Completion Trigger

```
IF T4CT1CS decision status → COMPLETED
  THEN update affected documentation per decision scope
  AND update cross-reference links if new docs created
  AND verify bidirectional links are intact
```

---

## 5. Version Pinning Strategy

### 5.1 Documentation Versions

Each document carries a version via its **Last Reviewed** date in the YAML-style header:

```markdown
> **Last Reviewed**: 2026-02-18
> **Next Review**: 2026-03-20
```

### 5.2 Pinning Rules

| Rule | Description |
|------|-------------|
| **Pin to code version** | Agent manifests pin to the git commit hash of last verified behavior |
| **Pin to test baseline** | CI_HEALTH.md pins to current test count (88 as of PROD-003) |
| **Pin to dependency versions** | SYSTEM_REQUIREMENTS.md pins to NuGet package versions in .csproj files |
| **Pin to decision ID** | Changes driven by Oracle decisions reference the decision ID (e.g., PROD-003) |

### 5.3 Version Drift Detection

A document has **version drift** if:
- Its pinned code reference points to a commit >30 days old AND the code has changed since
- Its pinned test count differs from actual test count
- Its pinned dependency versions differ from .csproj files

**Detection query** (CI integration):
```powershell
# Compare pinned test count vs actual
$actual = (dotnet run --project UNI7T35T/UNI7T35T.csproj 2>&1 | Select-String "TEST SUMMARY").ToString()
# Parse and compare against CI_HEALTH.md pinned value
```

---

## 6. Implementation Checklist

- [x] Define context injection protocol (Section 2)
- [x] Define cross-reference contract with bidirectional links (Section 3)
- [x] Define update trigger events (Section 4)
- [x] Define version pinning strategy (Section 5)
- [ ] Implement automated staleness checker in CI
- [ ] Implement orphan detection script
- [ ] Integrate version drift detection into PR validation
