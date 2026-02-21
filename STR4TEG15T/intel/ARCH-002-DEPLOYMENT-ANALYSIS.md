# ARCH-002: Deployment Automation - Consolidated Analysis

**Date:** 2026-02-18
**Status:** Analysis Complete - Ready for Implementation

---

## Explorer Findings

### Directory Structure

**Source:** `C:\P4NTH30N\agents\`
- Contains: `windfixer.md` (1 file only)

**Target:** `C:\Users\paulc\.config\opencode\agents\`
- Contains: 10 agent files (explorer.md, fixer.md, designer.md, oracle.md, librarian.md, orchestrator.md, strategist.md, forgewright.md, openfixer.md, windfixer.md)

### Critical Finding: NO EXISTING DEPLOYMENT MECHANISM
- No script currently deploys from P4NTH30N/agents/ to OpenCode
- Agent prompts are stored directly in target location
- Manual copying is the only current method

### Existing Deployment Infrastructure
- WindSurf workflows: `deploy.md` (for P4NTH30N app, not agents)
- WindSurf skills: `deployment/SKILL.md` (for P4NTH30N app)
- Scripts: Various setup scripts, none for agent deployment

---

## Oracle Assessment

### Deployment Trigger Options

| Approach | Oracle Rating | Risks |
|----------|--------------|-------|
| Git hook | Medium | Accidental commits, no rollback, invisible failures |
| File watcher | Low-Medium | Misses offline edits, resource-intensive, brittle |
| Scheduled | Low | Stale config, no correlation with decisions |
| **Manual (recommended)** | **85%** | Human error, but auditable and intentional |
| Decision-triggered | Medium-High | Tight coupling, failure cascades |

### Oracle Recommendation
**Manual deployment with scripted validation (85% approval)**

Rationale:
- Low-frequency config changes don't justify automation complexity
- Ensures deployments are intentional and auditable
- Avoids automation failure modes

Requirements:
1. Validate all `.md` files parse correctly
2. Copy with version suffix
3. Log deployment timestamp to audit trail
4. Include `--dry-run` flag
5. Handle file locks (OpenCode may hold files open)
6. Post-deploy health check

---

## Designer Architecture

### Recommended Pattern: Hybrid Hash + Registry

```json
{
  "changeDetection": "SHA-256 file hashing",
  "versioning": "MongoDB DEPLOYMENTS collection",
  "trigger": "external (manual script / Git hooks)",
  "verification": "checksum + schema validation",
  "rollback": "snapshot restore via MongoDB"
}
```

### Key Components

1. **File Hashing (SHA-256)**
   - Efficient change detection
   - Skip deployment if hashes match
   - Prevents redundant copies

2. **MongoDB Deployment Registry**
   - Collection: `DEPLOYMENTS`
   - Schema: agentName, sourceHash, targetHash, timestamp, snapshot
   - Enables rollback to any version
   - Complete audit trail

3. **External Trigger** (NOT H0UND)
   - H0UND should focus on jackpot analytics
   - Use Git hooks, CI/CD, or manual execution
   - Separation of concerns

4. **Verification**
   - Checksum validation (source vs target)
   - Schema validation (required frontmatter)
   - Optional smoke test (load agent in OpenCode)

5. **Rollback**
   - Store complete file snapshots in MongoDB
   - Single-command restore
   - Fast and deterministic

---

## Implementation Plan

### Phase 1: Core Script (Immediate)

**File:** `C:\P4NTH30N\scripts\deploy-agents.ps1`

**Features:**
```powershell
# 1. Compute SHA-256 hashes of source files
# 2. Query MongoDB DEPLOYMENTS for last-deployed hash
# 3. Compare hashes - skip if identical
# 4. Validate markdown frontmatter
# 5. Copy to target with backup
# 6. Store snapshot in MongoDB
# 7. Log deployment
# 8. Verify deployment (checksum)
```

**Parameters:**
- `-DryRun` - Show planned operations without executing
- `-Agent <name>` - Deploy specific agent only
- `-Rollback <timestamp>` - Restore previous version
- `-Verify` - Check deployment health

### Phase 2: MongoDB Schema

**Collection:** `DEPLOYMENTS`
```json
{
  "agentName": "librarian",
  "sourceHash": "a1b2c3...",
  "targetHash": "a1b2c3...",
  "timestamp": "2026-02-18T22:00:00Z",
  "snapshot": "---\ndescription: ...",  // Complete file content
  "deployedBy": "OpenFixer",
  "verificationStatus": "passed"
}
```

### Phase 3: Integration

**Trigger Options:**
1. **Manual** (recommended initially) - OpenFixer executes on request
2. **Git hook** (future) - post-commit hook for P4NTH30N repo
3. **CI/CD** (future) - GitHub Actions workflow

**Execution:**
```powershell
# Manual deployment
.\scripts\deploy-agents.ps1 -Verify

# Dry run
.\scripts\deploy-agents.ps1 -DryRun

# Rollback
.\scripts\deploy-agents.ps1 -Rollback "2026-02-18T21:00:00Z"
```

---

## Deployment Procedure

### When to Deploy

**Manual trigger (Phase 1):**
- After ARCH-002 completes
- When agent definitions are updated in P4NTH30N/agents/
- When Oracle approves agent changes

**Automated trigger (Phase 2):**
- Git post-commit hook (optional)
- CI/CD pipeline (optional)

### Verification Steps

1. **Pre-deployment:**
   ```powershell
   .\scripts\deploy-agents.ps1 -DryRun
   ```

2. **Deployment:**
   ```powershell
   .\scripts\deploy-agents.ps1 -Verify
   ```

3. **Post-deployment:**
   - Check MongoDB DEPLOYMENTS collection
   - Verify agent loads in OpenCode
   - Test agent functionality

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| MongoDB unavailable | Script fails gracefully with file-based fallback |
| Concurrent deployments | Last-write-wins with timestamp logging |
| File locks | Retry with exponential backoff |
| Wrong config deployed | Rollback to previous snapshot |
| Deployment not audited | All deployments logged to MongoDB |

---

## Next Steps

1. **Execute ARCH-002** - Create deploy-agents.ps1 via OpenFixer
2. **Create MongoDB schema** - DEPLOYMENTS collection
3. **Test deployment** - Verify windfixer.md deploys correctly
4. **Document procedure** - Add to runbooks

**Ready to implement?**
