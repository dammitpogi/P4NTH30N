# OPENFIXER EXECUTION PROMPT
## Batch: 4 Decisions + Constraint Resolutions | OpenCode Environment

**Execution Date**: 2026-02-18  
**Assigned Agent**: OpenFixer (OpenCode)  
**Target**: OpenCode directories (C:\Users\paulc\.config\opencode\)  
**Model**: Any available (quick fixes, orchestration)

---

## YOUR MISSION

Execute 4 primary decisions in the OpenCode environment. You have access to OpenCode directories that WindFixer cannot reach. Additionally, resolve any constraints reported by WindFixer from the P4NTH30N codebase.

**CRITICAL**: This is OpenCode-only work. Do not attempt to modify P4NTH30N codebase files - that's WindFixer's domain.

---

## PRIMARY DECISIONS (Execute First)

### 1. AUDIT-004: Fix STRATEGY-006 Status Inconsistency
**Priority**: MEDIUM | **Status**: Ready | **Estimated Time**: 15 minutes

**Objective**: Resolve status inconsistency in decisions-server

**Issue**: STRATEGY-006 shows Completed in statusHistory but implementation.status shows InProgress

**Steps**:
1. Query STRATEGY-006 from decisions-server
2. Verify the inconsistency
3. Update implementation.status to "Completed" to match statusHistory
4. Verify fix

**Deliverables**:
- Updated STRATEGY-006 status in decisions-server
- Confirmation of consistency

**Success Criteria**:
- [ ] STRATEGY-006 status consistent across all fields
- [ ] No data loss

---

### 2. FALLBACK-001: Circuit Breaker Tuning Pivot
**Priority**: HIGH | **Status**: Ready | **Estimated Time**: 1 hour

**Objective**: Tune circuit breaker configuration instead of building new fallback system

**Target File**: C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json

**Steps**:
1. Read current oh-my-opencode-theseus.json
2. Locate circuit breaker configuration
3. Apply tuning:
   - Increase failure threshold (e.g., from 3 to 5 failures)
   - Extend timeout for free tier (e.g., from 30s to 60s)
   - Add health metrics logging
4. Save configuration
5. Document changes

**Deliverables**:
- Updated oh-my-opencode-theseus.json
- Backup of original configuration
- Change log document

**Success Criteria**:
- [ ] Circuit breaker more tolerant
- [ ] Free tier timeouts extended
- [ ] Health metrics logging added
- [ ] Configuration valid JSON

**Rollback**: Restore from backup if issues arise

---

### 3. ARCH-002: Config Deployment Pipeline
**Priority**: CRITICAL | **Status**: Ready | **Estimated Time**: 2-3 hours

**Objective**: Create automated deployment pipeline from P4NTH30N to OpenCode

**Problem**: WindSurf cannot access OpenCode directories directly. Need sync mechanism.

**Steps**:
1. Create P4NTH30N/agents/ directory structure
   ```
   C:\P4NTH30N\agents\
   ├── strategist.md
   ├── oracle.md
   ├── designer.md
   ├── openfixer.md
   ├── orchestrator.md
   └── templates/
   ```

2. Copy current agent definitions from OpenCode to P4NTH30N/agents/
   - Source: C:\Users\paulc\.config\opencode\agents\
   - Target: C:\P4NTH30N\agents\

3. Create deploy-agents.ps1 script
   ```powershell
   # deploy-agents.ps1
   # Syncs agents from P4NTH30N to OpenCode
   
   param(
       [string]$SourceDir = "C:\P4NTH30N\agents",
       [string]$TargetDir = "C:\Users\paulc\.config\opencode\agents",
       [switch]$WhatIf
   )
   
   # Implementation:
   # 1. Compare file hashes
   # 2. Backup existing files
   # 3. Copy new files
   # 4. Verify deployment
   # 5. Log changes
   ```

4. Create version tracking system
   - Track agent versions
   - Deployment history
   - Rollback capability

**Deliverables**:
- C:\P4NTH30N\agents\ directory with all agent definitions
- C:\P4NTH30N\scripts\deploy-agents.ps1
- C:\P4NTH30N\scripts\agent-versions.json (version tracking)
- Deployment documentation

**Success Criteria**:
- [ ] All agents copied to P4NTH30N/agents/
- [ ] deploy-agents.ps1 functional
- [ ] Version tracking operational
- [ ] Test deployment successful

**Integration with WindFixer**:
- WindFixer will update agent files in P4NTH30N/agents/
- deploy-agents.ps1 will sync to OpenCode
- You execute the deployment script

---

### 4. EXEC-001: Deploy Strategist Workflow Improvements
**Priority**: CRITICAL | **Status**: Ready | **Estimated Time**: 1 hour

**Objective**: Deploy META-001, META-002, META-003 to production

**Note**: DEPLOY-001 already completed by Strategist. This is validation and activation.

**Steps**:
1. Validate deployment from DEPLOY-001:
   - Verify C:\Users\paulc\.config\opencode\schemas\decision-schema-v2.json exists
   - Verify C:\Users\paulc\.config\opencode\docs\oracle-opinion-capture-system.md exists
   - Verify C:\Users\paulc\.config\opencode\agents\strategist.md.bak exists

2. Test approval prediction:
   - Create test decision
   - Run approval prediction
   - Verify score calculation

3. Verify consultation log capture:
   - Check if decisions-server supports consultationLog field
   - Test logging a consultation
   - Verify retrieval

4. Activate new workflow:
   - Update AGENTS.md to reference new strategist.md
   - Document new workflow

**Deliverables**:
- Validation report
- Test results
- Updated documentation

**Success Criteria**:
- [ ] All META files validated
- [ ] Approval prediction working
- [ ] Consultation log capture functional
- [ ] New workflow documented

---

## CONSTRAINT RESOLUTIONS (Execute as Reported)

WindFixer will report constraints from P4NTH30N execution. Resolve them here.

### Constraint Resolution Template

When WindFixer reports a constraint:

1. **Read the constraint report** from WindFixer output
2. **Assess impact**: Blocking vs Non-blocking
3. **Implement workaround** using OpenCode capabilities
4. **Document resolution** for WindFixer to continue
5. **Update decision status** if needed

### Expected Constraint Types

#### 1. Model Download Failure (DEPLOY-002)
**If WindFixer reports**: Cannot download Maincoder-1B

**Your Action**:
```powershell
# Option A: Use Hugging Face API token
# Add token to environment and retry

# Option B: Implement API-based validation fallback
# Create C:\P4NTH30N\scripts\validation-api-fallback.ps1
# Use OpenAI/Anthropic API for validation (if available)

# Option C: Document manual download process
# Provide instructions for Nexus to download manually
```

#### 2. Low Accuracy (DEPLOY-002)
**If WindFixer reports**: Accuracy <80% on Maincoder-1B

**Your Action**:
```powershell
# Evaluate alternative models
# Option A: Qwen2.5-0.5B-Instruct (smaller, potentially more accurate)
# Option B: phi-2 (Microsoft, 2.7B but high quality)
# Option C: Adjust threshold to 70% with Oracle approval
```

#### 3. LM Studio Unavailable (DEPLOY-002)
**If WindFixer reports**: Cannot start LM Studio

**Your Action**:
```powershell
# Set up Docker-based LLM container
# Create docker-compose.yml for LM Studio alternative
# Or use llama.cpp directly
```

#### 4. Qwen2.5 Insufficient (ARCH-003)
**If WindFixer reports**: Cannot achieve 95% accuracy

**Your Action**:
```powershell
# Re-consult Oracle with options:
# Option A: Lower threshold to 90%
# Option B: Use larger model (with cost implications)
# Option C: Implement ensemble approach
```

#### 5. Integration Failure (ARCH-003)
**If WindFixer reports**: PowerShell integration fails

**Your Action**:
```powershell
# Create wrapper scripts
# C:\P4NTH30N\scripts\deploy-agent-wrapper.ps1
# Handle errors, logging, retries
```

#### 6. C# 12 Unsupported (SWE-003)
**If WindFixer reports**: Compilation errors with C# 12 features

**Your Action**:
```powershell
# Update templates to C# 10
# Remove primary constructors
# Use traditional namespace declarations
# Update .windsurfrules
```

#### 7. Parallel Execution Fails (SWE-002)
**If WindFixer reports**: Race conditions or deadlocks

**Your Action**:
```powershell
# Implement sequential fallback
# Create C:\P4NTH30N\src\workflows\SequentialFallback.cs
# Document when to use fallback
```

#### 8. File Locking Issues (SWE-002)
**If WindFixer reports**: Cannot edit multiple files simultaneously

**Your Action**:
```powershell
# Create file queue system
# C:\P4NTH30N\src\workflows\FileQueue.cs
# Implement locking mechanism
```

#### 9. Prometheus Resource Heavy (PROD-005)
**If WindFixer reports**: Performance impact from monitoring

**Your Action**:
```powershell
# Evaluate alternatives
# Option A: InfluxDB (lighter weight)
# Option B: Custom metrics collection
# Option C: Sampling approach
```

#### 10. High False Positives (PROD-005)
**If WindFixer reports**: >10% false positive rate

**Your Action**:
```powershell
# Tune alert thresholds
# Update monitoring/config/thresholds.json
# Increase sustained period
# Add hysteresis
```

---

## EXECUTION SEQUENCE

### Phase 1: Quick Wins (Day 1)
1. **AUDIT-004** (15 min) - Status fix
2. **FALLBACK-001** (1 hour) - Circuit breaker tuning

### Phase 2: Pipeline Setup (Day 1-2)
3. **ARCH-002** (2-3 hours) - Deployment pipeline
4. **EXEC-001** (1 hour) - Workflow deployment

### Phase 3: Constraint Resolution (Ongoing)
5. **Monitor WindFixer output** for constraints
6. **Implement workarounds** as needed
7. **Document resolutions**

---

## COMMUNICATION WITH WINDFIXER

### Receiving Constraints
WindFixer will report constraints in this format:
```
CONSTRAINT ESCALATION: [Decision ID]
TYPE: [Hardware/Software/Performance/Oracle]
IMPACT: [Blocking/Non-blocking]
DETAILS: [Full constraint report]
```

### Responding to Constraints
You will respond with:
```
CONSTRAINT RESOLVED: [Decision ID]
RESOLUTION: [What you implemented]
FILES: [Files created/modified]
WINDFIXER ACTION: [What WindFixer should do next]
```

### Handoff Protocol
1. WindFixer encounters constraint → Stops work on that decision
2. You receive constraint report → Implement workaround
3. You complete resolution → Report back to WindFixer
4. WindFixer resumes work → Continues with decision

---

## DELIVERABLES CHECKLIST

### Primary Decisions
- [ ] AUDIT-004: STRATEGY-006 status fixed
- [ ] FALLBACK-001: Circuit breaker tuned
- [ ] ARCH-002: Deployment pipeline operational
- [ ] EXEC-001: Workflow improvements deployed

### Constraint Resolutions
- [ ] Model download failures resolved
- [ ] Accuracy issues addressed
- [ ] Integration failures fixed
- [ ] Performance issues mitigated

### Documentation
- [ ] Change log for all modifications
- [ ] Constraint resolution log
- [ ] Updated AGENTS.md
- [ ] Deployment procedures

---

## QUALITY STANDARDS

### Configuration Changes
- Backup before modification
- Validate JSON/XML syntax
- Test before applying
- Document changes

### Script Development
- PowerShell best practices
- Error handling
- Logging
- Rollback capability

### Documentation
- Clear instructions
- Troubleshooting guides
- Version tracking
- Change history

---

**Begin execution with Phase 1: AUDIT-004**

**Remember**: You are the bridge between WindFixer and OpenCode. Clear constraints enable WindFixer to focus on P4NTH30N implementation while you handle OpenCode environment issues.

**Ready? Execute.**
