# DECISION_034: Session History Harvester for RAG

**Decision ID**: DECISION_034
**Category**: Infrastructure
**Status**: Approved
**Priority**: High
**Date**: 2026-02-20
**Oracle Approval**: 93% (Strategist Assimilated)
**Designer Approval**: 92% (Strategist Assimilated)

---

## Executive Summary

Build a harvester that extracts session history, tool outputs, and chat transcripts from OpenCode and WindSurf, then ingests them into RAG. This closes the loop between what agents do and what the system remembers, creating true institutional memory.

**Current Problem**:
- OpenCode sessions live in C:\Users\paulc\.local\share\opencode\storage\session\ as SQLite-backed data
- OpenCode tool outputs accumulate in C:\Users\paulc\.local\share\opencode\tool-output\ (216 files)
- OpenCode logs exist in C:\Users\paulc\.local\share\opencode\log\ (11 log files)
- WindSurf Cascade sessions are stored in WindSurf internal databases, not easily accessible
- None of this data is ingested into RAG
- Agents have no memory of what happened in previous sessions
- Valuable debugging context, tool outputs, and conversation history is lost

**Proposed Solution**:
- Build a harvester module in the CONFIGDEPLOY or TOOLSET project
- OpenCode: read session SQLite database (opencode.db) and tool-output files
- WindSurf: investigate Cascade session storage and extract what is accessible
- Transform session data into RAG-ingestible chunks
- Run nightly or on-demand to keep RAG up to date

---

## Data Sources

### OpenCode (C:\Users\paulc\.local\share\opencode)

| Source | Format | Content |
|--------|--------|---------|
| opencode.db | SQLite | Session history, messages, metadata |
| storage/session/*/ | Directories per project hash | Session state |
| storage/message/ | Message storage | Chat messages |
| tool-output/tool_* | Text files | Tool execution results (truncated outputs) |
| log/*.log | Text logs | OpenCode runtime logs |

### WindSurf (C:\Users\paulc\AppData\Roaming\WindSurf)

| Source | Format | Content |
|--------|--------|---------|
| Session Storage/ | LevelDB | Cascade session data |
| User/globalStorage/state.vscdb | SQLite | Extension state |

### P4NTH30N Agent Directories

| Source | Format | Content |
|--------|--------|---------|
| OPENFIXER/deployments/*.md | Markdown | Deployment journals |
| WINDFIXER/deployments/*.md | Markdown | Deployment journals |
| STRATEGIST/speech/*.md | Markdown | Speech logs |

---

## Implementation Strategy

### Phase 1: OpenCode Database Reader
1. Connect to opencode.db using System.Data.SQLite or Microsoft.Data.Sqlite
2. Read session table: extract session IDs, timestamps, project paths
3. Read message table: extract conversation content per session
4. Transform into RAG documents with metadata:
   - source: "opencode/session/{sessionId}"
   - agent: extracted from message content
   - timestamp: session timestamp
   - project: project hash mapping

### Phase 2: Tool Output Processor
1. Read all tool-output/tool_* files
2. Parse content: extract tool name, parameters, results
3. Chunk large outputs (some are 50KB+)
4. Ingest with metadata:
   - source: "opencode/tool-output/{toolId}"
   - type: "tool-result"
   - timestamp: file modification time

### Phase 3: WindSurf Session Reader
1. Investigate WindSurf Session Storage format (LevelDB)
2. If accessible: extract Cascade conversation history
3. If not accessible: document limitation, suggest WindSurf extension approach
4. Alternative: use the windsurf-follower extension to capture sessions in real-time

### Phase 4: Incremental Harvesting
1. Track last harvest timestamp per source
2. Only process new/changed files since last harvest
3. Store harvest state in MongoDB or local JSON
4. Run as scheduled task: nightly at 3 AM

### Phase 5: RAG Ingestion
1. Use IngestionPipeline.IngestAsync for each document
2. Tag with rich metadata for filtering
3. Verify ingestion counts
4. Log harvest report

---

## Harvester CLI

```bash
# Harvest everything
dotnet run --project CONFIGDEPLOY -- harvest

# Harvest OpenCode sessions only
dotnet run --project CONFIGDEPLOY -- harvest --opencode

# Harvest tool outputs only
dotnet run --project CONFIGDEPLOY -- harvest --tools

# Harvest since specific date
dotnet run --project CONFIGDEPLOY -- harvest --since 2026-02-20

# Dry run (show what would be harvested)
dotnet run --project CONFIGDEPLOY -- harvest --dry-run

# Show harvest stats
dotnet run --project CONFIGDEPLOY -- harvest --stats
```

---

## RAG Metadata Schema for Harvested Content

```json
{
  "source": "opencode/session/abc123",
  "type": "session-transcript",
  "agent": "openfixer",
  "project": "P4NTH30N",
  "timestamp": "2026-02-20T23:00:00Z",
  "sessionId": "abc123",
  "tags": ["decision-025", "anomaly-detection", "implementation"],
  "harvested": "2026-02-21T03:00:00Z"
}
```

---

## Success Criteria

1. OpenCode session history is searchable via RAG queries
2. Tool outputs are indexed and queryable
3. Incremental harvesting processes only new data
4. Agents can query "what did we do in the last session about X"
5. Harvest runs nightly without manual intervention

---

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_033 (RAG must be active first)
- **Related**: DECISION_032 (shares CONFIGDEPLOY project), DECISION_033 (RAG activation)

---

*Decision DECISION_034 - Session History Harvester - 2026-02-20*