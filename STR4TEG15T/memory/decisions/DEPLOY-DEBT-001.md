---

type: decision
id: DEPLOY-DEBT-001
category: technical-debt
status: resolved
version: 1.1.0
created_at: '2026-02-26T21:30:00.000Z'
last_reviewed: '2026-02-26T22:00:00.000Z'
resolved_at: '2026-02-26T22:00:00.000Z'
keywords:
  - deployment
  - documentation
  - technical-debt
  - openclaw
  - sftpgo
  - merged-service
  - thread-loss
roles:
  - strategist
  - openfixer
  - windfixer
summary: >-
  Deployment failure due to incomplete implementation and documentation drift.
  RESOLVED: Deploy directory reset to openclaw-railway-template by Nexus.
  New deployment scaffold established. Technical debt cleared.
---

# DEPLOY-DEBT-001: Deployment Documentation Drift and Thread Loss (RESOLVED)

**Decision ID**: DEPLOY-DEBT-001  
**Category**: Technical Debt  
**Status**: ✅ **RESOLVED**  
**Priority**: High  
**Date**: 2026-02-26  
**Resolved**: 2026-02-26  
**Resolution**: Deploy directory reset to openclaw-railway-template by Nexus  
**Discovery**: Nexus investigation of missing deployment  

---

## The Failure

### What Exists
Location: `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy`

**Present Files**:
- ✅ `Dockerfile` - Container definition (WITH BROKEN REFERENCES)
- ✅ `supervisord.conf` - Process management
- ✅ `sftpgo.json` - SFTPGo configuration
- ✅ `start.sh` - Startup script
- ✅ `railway.toml` - Railway deployment config
- ✅ `README.md` - Documentation
- ✅ `.git/` - Git repository

**Missing Files** (referenced but not created):
- ❌ `src/` - OpenClaw wrapper server source code
- ❌ `entrypoint.sh` - Container entrypoint script
- ❌ `.env.example` - Environment variable template

### The Breakdown

**What Actually Happened (Verified via Screenshots)**:
1. Nexus provided explicit instruction to deploy merged Docker setup to `C:\P4NTH30N\OP3NF1XER\nate-alma\deploy`
2. Pyxis (acting as OpenFixer) instead created a new directory `alma-railway` and wrote the files there (Dockerfile, supervisord.conf, sftpgo.json, start.sh, .env.example, README.md)
3. Later, when asked about the `deploy` directory, Pyxis realized the mistake and hastily copied files from `alma-railway` to `deploy`.
4. However, the Dockerfile written in `alma-railway` contained these lines:
   ```dockerfile
   COPY src ./src
   COPY entrypoint.sh ./entrypoint.sh
   ```
5. These lines were hallucinatory additions by the model - they were never part of the Nexus specification, nor did the files actually exist in `alma-railway` to be copied over.
6. The resulting deployment in `deploy` is broken because the Dockerfile references files that were never created.

### Root Cause: Model Hallucination & Directory Confusion

**Why It Happened**:
- **Directory Drift**: Model chose to create a new directory (`alma-railway`) instead of using the specified target (`deploy`).
- **Hallucination**: Model added `COPY src ./src` and `COPY entrypoint.sh ./entrypoint.sh` to the Dockerfile based on assumptions from previous OpenClaw deployments, rather than following the strict specification provided by Nexus.
- **Hasty Remediation**: When called out, the model blindly copied the contents of `alma-railway` to `deploy` without verifying if the Dockerfile was actually functional or complete.
- **Role Confusion**: The model was operating in a defensive, improvisational state (Fixer drift) rather than executing precisely.

---

## Impact Assessment

### Immediate
- ❌ Cannot build Docker image
- ❌ Cannot deploy to Railway
- ❌ Client files still not transferred
- ❌ OpenClaw service non-existent

### Cascading
- Client trust continues to erode
- Timeline extended (rework required)
- INFRA-001 blocked (depends on working deployment)
- Pantheon growth delayed

### Knowledge Loss
- Original intent of src/ structure unclear
- Entrypoint.sh requirements not documented
- Integration points between SFTPGo and OpenClaw undefined
- Thread between specification and implementation broken

---

## Remediation Plan

### Phase 1: Dockerfile Correction (Immediate)
**Goal**: Remove hallucinatory references from the Dockerfile.

**Tasks**:
1. Remove `COPY src ./src` and `COPY entrypoint.sh ./entrypoint.sh` from `deploy/Dockerfile`
2. Remove `RUN chmod +x ./entrypoint.sh`
3. Ensure the Dockerfile accurately reflects the Nexus specification (which built OpenClaw from source and copied `dist/` directly, negating the need for a separate `src/` or `entrypoint.sh`).

### Phase 2: Deployment Execution
**Goal**: Actually deploy the merged service.

**Tasks**:
1. Commit the corrected `deploy` directory
2. Link Railway CLI to the correct project (if needed, or use auto-deploy via GitHub)
3. Execute `railway up` or trigger redeploy
4. Verify volume attachment at `/data`

### Phase 3: File Transfer
**Goal**: Complete the original task.

**Tasks**:
1. Connect to SFTPGo via port 2022
2. Transfer `C:\P4NTH30N\OP3NF1XER\nate-alma\dev` to `/data/workspace`
3. Verify OpenClaw recognizes the workspace.

### Phase 4: Documentation Hardening (Day 5)
**Goal**: Prevent future drift

**Deliverables**:
- Complete deployment guide
- File manifest with checksums
- Build validation script
- Deployment runbook

---

## Knowledge Capture

### What We Actually Lost
- **Time and Trust**: We didn't lose specifications; the model just hallucinated dependencies that weren't part of the plan.
- **The True Thread**: The thread wasn't lost due to missing documentation, it was lost due to model drift and failure to follow explicit instructions.

### The Fix
The fix is much simpler than previously thought. We don't need to reconstruct missing files. We just need to remove the hallucinated lines from the Dockerfile that broke the build. The original specification provided by Nexus in the chat was complete and correct.

---

## Prevention Measures

### For Future Deployments
1. **Explicit File Manifest**: List every file with purpose
2. **Reference Validation**: Verify all COPY/INCLUDE statements resolve
3. **Build Verification**: Local Docker build before Railway deploy
4. **Documentation Sync**: Update docs when implementation changes
5. **Handoff Contracts**: Explicit deliverables with validation criteria

### For This Decision
- ✅ Documented what exists
- ✅ Documented what's missing
- ✅ Identified root cause (documentation drift)
- ✅ Created remediation plan
- ⬜ Execute remediation (delegate to Fixers)

---

## Resolution

**Status**: ✅ **RESOLVED**

**Resolution Action**: Nexus reset the `deploy/` directory to the `openclaw-railway-template` (https://github.com/arjunkomath/openclaw-railway-template), clearing all hallucinated files and broken references.

**New State**:
- ✅ Deploy directory contains clean template from upstream
- ✅ No broken Dockerfile references
- ✅ Ready for customization and deployment
- ✅ Workspace fixes completed (DECISION_164)
- ✅ Secrets vault created

**Technical Debt**: CLEARED

---

## Historical Record

The original issue (hallucinated COPY lines in Dockerfile) has been superseded by the template reset. This decision now serves as:
1. Historical record of the documentation drift incident
2. Prevention guidance for future deployments
3. Reference for why the deploy directory was reset

---

## Prevention Measures (Still Valid)

### For Future Deployments
1. **Explicit File Manifest**: List every file with purpose
2. **Reference Validation**: Verify all COPY/INCLUDE statements resolve
3. **Build Verification**: Local Docker build before Railway deploy
4. **Documentation Sync**: Update docs when implementation changes
5. **Handoff Contracts**: Explicit deliverables with validation criteria

---

*DEPLOY-DEBT-001: RESOLVED - Template reset cleared technical debt*  
*When the thread breaks, reset to known good state*  
*2026-02-26*
