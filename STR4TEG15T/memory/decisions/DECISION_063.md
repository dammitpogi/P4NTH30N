---
type: decision
id: DECISION_063
category: architecture
status: active
version: 1.0.0
created_at: '2026-02-23T01:31:15.698Z'
last_reviewed: '2026-02-23T01:31:15.698Z'
keywords:
  - decision063
  - rag
  - file
  - watcher
  - windows
  - service
  - executive
  - summary
  - background
  - problem
  - solution
  - specification
  - configuration
  - watched
  - directories
  - features
  - action
  - items
  - dependencies
  - risks
roles:
  - librarian
  - oracle
summary: >-
  Set up the RAG file watcher as a persistent Windows service to ensure
  continuous automatic ingestion of new documents into the RAG knowledge base.
  This eliminates the need for manual intervention and ensures institutional
  memory is always preserved. **Implementation Complete**: - Created Windows
  Scheduled Task `P4NTHE0N-RAG-Watcher` - Task runs at system startup with
  SYSTEM privileges - Runs continuously polling for new files every 5 seconds -
  No agent dependency - pure automation ---
source:
  type: decision
  original_path: ../../../STR4TEG15T/decisions/active/DECISION_063.md
---
# DECISION_063: RAG File Watcher as Windows Service

**Decision ID**: DECISION_063  
**Category**: INFRA  
**Status**: Completed  
**Priority**: Critical  
**Date**: 2026-02-20  
**Oracle Approval**: 100% (Assimilated)  
**Designer Approval**: 100% (Assimilated)

---

## Executive Summary

Set up the RAG file watcher as a persistent Windows service to ensure continuous automatic ingestion of new documents into the RAG knowledge base. This eliminates the need for manual intervention and ensures institutional memory is always preserved.

**Implementation Complete**:
- Created Windows Scheduled Task `P4NTHE0N-RAG-Watcher`
- Task runs at system startup with SYSTEM privileges
- Runs continuously polling for new files every 5 seconds
- No agent dependency - pure automation

---

## Background

### Problem

The RAG file watcher (`Watch-RagIngest.ps1`) was created in DECISION_061 but required manual execution. This created a gap:
- New documents created during sessions might not be ingested if the watcher wasn't running
- Reliance on agents to remember to start the watcher
- No persistence across system restarts

### Solution

Convert the script into a Windows service using Scheduled Tasks (NSSM not available on this system).

---

## Specification

### Service Configuration

**Task Name**: `P4NTHE0N-RAG-Watcher`  
**Trigger**: At system startup  
**User**: SYSTEM (highest privileges)  
**Window Style**: Hidden (no UI)  
**Execution Policy**: Bypass  
**Script**: `C:\P4NTHE0N\STR4TEG15T\tools\rag-watcher\Watch-RagIngest.ps1`

**PowerShell Command**:
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File C:\P4NTHE0N\STR4TEG15T\tools\rag-watcher\Watch-RagIngest.ps1
```

**Task Settings**:
- Allow start if on batteries: Yes
- Don't stop if going on batteries: Yes
- Start when available: Yes
- Run only if network available: Yes

### Watched Directories

| Directory | Document Type | Agent |
|-----------|---------------|-------|
| `STR4TEG15T/decisions/active/` | Decision files | Strategist |
| `STR4TEG15T/decisions/completed/` | Completed decisions | Strategist |
| `STR4TEG15T/speech/` | Speech synthesis logs | Strategist |
| `STR4TEG15T/manifest/` | Narrative manifest | Strategist |
| `OP3NF1XER/deployments/` | Deployment journals | OpenFixer |

### Features

- **Automatic file detection**: Polls every 5 seconds for new files
- **Duplicate prevention**: Content hash tracking in `RAG-watcher-state.json`
- **Metadata extraction**: Automatically determines docType and agent from path
- **State persistence**: Tracks ingested files to avoid re-ingestion
- **Error resilience**: Continues on individual file failures
- **No agent dependency**: Pure PowerShell - works even when agents unavailable

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-063-001 | Create Windows Scheduled Task | Strategist | Completed | Critical |
| ACT-063-002 | Configure startup trigger | Strategist | Completed | Critical |
| ACT-063-003 | Set SYSTEM privileges | Strategist | Completed | Critical |
| ACT-063-004 | Start service immediately | Strategist | Completed | Critical |
| ACT-063-005 | Verify running status | Explorer | Completed | High |
| ACT-063-006 | Document service in AGENTS.md | Strategist | Completed | Medium |

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_061 (RAG File Watcher script)
- **Related**: DECISION_033 (RAG Activation), DECISION_052-054 (RAG Ingestion)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Task fails to start on boot | High | Low | Monitor via Task Scheduler; can start manually |
| RAG server down | Medium | Low | Watcher retries on next poll cycle |
| State file corruption | Low | Low | JSON validation; can delete state to rebuild |
| High CPU from polling | Low | Low | 5-second interval is conservative |

---

## Success Criteria

1. ✅ Scheduled Task `P4NTHE0N-RAG-Watcher` created
2. ✅ Task configured to run at startup
3. ✅ Task running with SYSTEM privileges
4. ✅ Task currently in `Running` state
5. ✅ No manual intervention required
6. ✅ Service persists across reboots

---

## Management Commands

### Check Status
```powershell
Get-ScheduledTask -TaskName "P4NTHE0N-RAG-Watcher" | Get-ScheduledTaskInfo
```

### Start Service
```powershell
Start-ScheduledTask -TaskName "P4NTHE0N-RAG-Watcher"
```

### Stop Service
```powershell
Stop-ScheduledTask -TaskName "P4NTHE0N-RAG-Watcher"
```

### View Logs
The watcher outputs to console (captured by Task Scheduler). Check Task Scheduler history for execution logs.

### Manual Run (One-Time)
```powershell
.\STR4TEG15T\tools\rag-watcher\Watch-RagIngest.ps1 -RunOnce -Verbose
```

---

## Token Budget

- **Estimated**: 5,000 tokens
- **Model**: N/A (infrastructure setup)
- **Budget Category**: Routine (<50K)

---

## Notes

**Why Scheduled Task vs NSSM?**
- NSSM (Non-Sucking Service Manager) not installed on this system
- Windows Scheduled Tasks provide equivalent functionality for this use case
- Runs at startup, hidden window, SYSTEM privileges
- Can be monitored via standard Task Scheduler interface

**Monitoring:**
The service can be monitored via:
- Task Scheduler GUI (`taskschd.msc`)
- PowerShell: `Get-ScheduledTask -TaskName "P4NTHE0N-RAG-Watcher"`
- RAG status: Query `rag_status` to see vector count growth

**Future Enhancements:**
- Add email/notification on ingestion failures
- Add metrics endpoint for monitoring
- Consider migrating to NSSM for true service behavior if needed

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-20
- **Approval**: 100% (assimilated)
- **Key Findings**: Oracle unavailable; Strategist assimilated per canon

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: 100% (assimilated)
- **Key Findings**: Designer unavailable; Strategist assimilated per canon

---

*DECISION_063*  
*RAG File Watcher as Windows Service*  
*2026-02-20*
