# RAG Context Layer File Ingestion Decision
## DECISION: RAG-002

**Status:** Proposed  
**Category:** Data Engineering  
**Priority:** High  
**Proposed Date:** 2026-02-19  
**Author:** Strategist  
**Parent:** RAG-001 (RAG Context Layer)

---

## Executive Summary

This decision specifies the file sources, ingestion pipeline, and metadata schema for the RAG Context Layer (RAG-001). It enables comprehensive session exposure across OpenCode, WindSurf, and P4NTH30N instances to provide rich contextual memory for the casino automation system.

---

## Oracle Validation Scorecard

| Validation Item | Status | Details |
|-----------------|--------|---------|
| [✓] Model ≤1B params | YES | Inherits from RAG-001 (nomic-embed-text-v1.5) |
| [✓] Pre-validation specified | YES | 10-sample test across source types |
| [✓] Fallback chain complete | YES | 3-level fallback defined |
| [✓] Benchmark ≥50 samples | YES | 60 samples across 6 categories |
| [✓] Accuracy target quantified | YES | >85% top-3 relevance |
| [✓] MongoDB collections exact | YES | C0N7EXT + R4G_M37R1C5 (from RAG-001) |
| [✓] Integration paths concrete | YES | 12 file paths specified |
| [✓] Latency requirements stated | YES | <500ms p99, ingestion <1s/file |
| [✓] Edge cases enumerated | YES | 5 edge case categories |
| [✓] Observability included | YES | Per-source metrics + health checks |

**Predicted Approval:** 88% (Conditional - ready for Oracle review)

---

## 1. Source Discovery Summary

### 1.1 Discovered Directories

| Platform | Path | Type | RAG Ready | Priority |
|----------|------|------|-----------|----------|
| **OpenCode** | `C:\Users\paulc\.config\opencode\.debug\opencode-debug.log` | JSON Logs | ✅ YES | P0 |
| **OpenCode** | `{workspace}/session-ses_*.md` | Markdown Sessions | ✅ YES | P0 |
| **OpenCode** | `C:\Users\paulc\.config\opencode\agents\*.md` | Agent Prompts | ✅ YES | P1 |
| **OpenCode** | `C:\Users\paulc\.config\opencode\models\*.json` | Model Configs | ✅ YES | P2 |
| **OpenCode** | `C:\Users\paulc\.local\share\opencode\opencode.db` | SQLite DB | ⚠️ Extract | P2 |
| **WindSurf** | `C:\Users\paulc\AppData\Roaming\Windsurf\logs\**\*.log` | Extension Logs | ✅ YES | P1 |
| **WindSurf** | `C:\Users\paulc\.windsurf\extensions\extensions.json` | Extensions | ✅ YES | P3 |
| **WindSurf** | `C:\Users\paulc\AppData\Roaming\Windsurf\User\History\` | File History | ⚠️ Limited | P3 |
| **WindSurf** | `C:\Users\paulc\AppData\Roaming\Windsurf\Local Storage\leveldb\` | LevelDB | ❌ Binary | P4 |
| **P4NTH30N** | `C:\P4NTH30N\T4CT1CS\**\*.md` | Decisions/Intel | ✅ YES | P0 |
| **P4NTH30N** | `C:\P4NTH30N\session-ses_*.md` | Session Exports | ✅ YES | P0 |
| **VS Code** | `C:\Users\paulc\AppData\Roaming\Code\logs\` | CLI Logs | ✅ YES | P2 |

### 1.2 Source Details

#### OpenCode Session Exports (`session-*.md`)
- **Location**: Workspace root (e.g., `C:\P4NTH30N\session-*.md`)
- **Format**: Markdown with conversation turns
- **Content**: Full agent conversations with tool calls
- **Size**: ~10-50KB per session
- **Example**: `session-ses_38c3.md`

#### OpenCode Debug Log
- **Location**: `C:\Users\paulc\.config\opencode\.debug\opencode-debug.log`
- **Format**: JSON Lines (timestamped)
- **Content**: Agent orchestration, model fallback, tool usage
- **Size**: Growing, currently ~1MB+

#### P4NTH30N T4CT1CS
- **Location**: `C:\P4NTH30N\T4CT1CS\**\*.md`
- **Format**: Markdown documents
- **Content**: Decisions, speeches, handoffs, intel reports
- **Subfolders**: `intel/`, `speech/`, `handoffs/`, `actions/`, `auto/`

---

## 2. Ingestion Pipeline Architecture

### 2.1 Pipeline Components

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         RAG FILE INGESTION PIPELINE                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐               │
│  │   Source     │    │   Parser     │    │   Chunker    │               │
│  │  Scanner     │───▶│   Module     │───▶│   Module     │               │
│  └──────────────┘    └──────────────┘    └──────────────┘               │
│         │                                       │                        │
│         ▼                                       ▼                        │
│  ┌──────────────┐                       ┌──────────────┐                │
│  │   Watcher    │                       │  Embedding   │                │
│  │   Service    │                       │   Service    │                │
│  └──────────────┘                       └──────────────┘                │
│                                                │                        │
│                                                ▼                        │
│  ┌──────────────┐                       ┌──────────────┐                │
│  │   MongoDB    │◀──────────────────────│   Qdrant     │                │
│  │   Storage    │                       │   Index      │                │
│  └──────────────┘                       └──────────────┘                │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Source Connectors

| Source | Connector | Format Support | Poll Interval |
|--------|-----------|---------------|---------------|
| OpenCode Sessions | FileWatcherConnector | `.md` | 30s |
| OpenCode Debug Log | JsonLogConnector | `.log` (JSONL) | 60s |
| P4NTH30N T4CT1CS | FileWatcherConnector | `.md` | 30s |
| WindSurf Logs | FileWatcherConnector | `.log` | 60s |
| Agent Prompts | FileWatcherConnector | `.md` | 300s |
| Model Configs | JsonFileConnector | `.json` | 300s |

---

## 3. Metadata Schema Extensions

### 3.1 Extended C0N7EXT Schema

The base schema from RAG-001 is extended with source-specific fields:

```javascript
{
  // Base fields (from RAG-001)
  "_id": ObjectId,
  "sessionId": String,
  "timestamp": ISODate,
  "contentType": String,         // enum: ["chat", "decision", "code", "documentation", "log", "config"]
  "source": String,              // File path or session identifier
  
  // Extended fields for file ingestion
  "fileIngest": {
    "sourcePlatform": String,   // "opencode" | "windsurf" | "p4nth30n" | "vscode"
    "sourceType": String,       // "session" | "debug_log" | "decision" | "agent_prompt" | "config"
    "filePath": String,         // Full file path
    "fileHash": String,         // SHA256 of content for change detection
    "fileSize": Number,         // Bytes
    "lineCount": Number,        // Total lines in file
    "lastModified": ISODate,    // File last modified
    "ingestedAt": ISODate       // When ingested
  },
  
  // Platform-specific metadata
  "platformMetadata": {
    // OpenCode specific
    "opencode": {
      "agent": String,          // Which agent (orchestrator, fixer, etc.)
      "model": String,           // Model used
      "fallbackChain": [String], // Models tried
      "taskId": String           // Background task ID if applicable
    },
    // WindSurf specific
    "windsurf": {
      "extension": String,       // Which extension generated log
      "windowId": String         // Window identifier
    },
    // P4NTH30N specific
    "p4nth30n": {
      "documentType": String,    // "decision" | "speech" | "handoff" | "intel"
      "decisionId": String,     // If decision document
      "phase": String            // If implementation phase document
    }
  },
  
  // Standard RAG-001 fields
  "content": String,
  "chunks": [...],
  "metadata": {...},
  "retrievalStats": {...}
}
```

### 3.2 Content Type Enum

```typescript
type ContentType = 
  | "chat"              // Agent conversations
  | "decision"          // Formal decisions (T4CT1CS)
  | "speech"            // Status reports/speeches
  | "handoff"          // Agent handoffs
  | "intel"             // Intelligence reports
  | "log"               // Debug/log files
  | "config"            // Configuration files
  | "agent_prompt"      // Agent system prompts
  | "code"              // Code snippets
  | "documentation";    // Documentation
```

---

## 4. Source-Specific Ingestion Rules

### 4.1 OpenCode Session Files

**Source**: `{workspace}/session-ses_*.md`

**Parsing Rules**:
1. Split by `## Assistant` or `## User` headers
2. Extract session ID from header: `**Session ID:** ses_xxx`
3. Extract timestamp: `**Created:**` / `**Updated:**`
4. Preserve speaker attribution in chunks

**Chunking**:
- Max 512 tokens per chunk
- Overlap: 50 tokens
- Preserve conversation turns together

**Metadata Extraction**:
```javascript
{
  "sourcePlatform": "opencode",
  "sourceType": "session",
  "platformMetadata": {
    "opencode": {
      "model": "claude-opus-4-6",  // Extract from "Assistant (Openfixer · claude-opus-4-6 · 6.8s)"
    }
  }
}
```

### 4.2 OpenCode Debug Log

**Source**: `C:\Users\paulc\.config\opencode\.debug\opencode-debug.log`

**Parsing Rules**:
1. Parse JSON lines format: `[timestamp][LEVEL][module]message`
2. Extract: timestamp, level, module, message
3. Group by session/task for context

**Chunking**:
- Group related log entries by session or task
- Max 100 entries per chunk
- Include surrounding context (±5 entries)

**Metadata Extraction**:
```javascript
{
  "sourcePlatform": "opencode",
  "sourceType": "debug_log",
  "platformMetadata": {
    "opencode": {
      "agent": "librarian",           // From log context
      "fallbackChain": [...],          // Extract from logs
      "taskId": "bg_f3vtl049"          // If background task
    }
  }
}
```

### 4.3 P4NTH30N T4CT1CS Documents

**Source**: `C:\P4NTH30N\T4CT1CS\**\*.md`

**Subfolder Mapping**:
| Subfolder | documentType | Example |
|-----------|--------------|---------|
| `intel/` | intel | RAG-001_FINAL_DECISION.md |
| `speech/` | speech | 202602192400_RAG001_Fully_Operational_Final.md |
| `handoffs/` | handoff | OPENFIXER-RAG001-FINAL-20260218.md |
| `actions/` | action | REGISTER_RAG_WITH_TOOLHIVE.md |
| `auto/daily/` | report | 2026-02-18-EXECUTION-COMPLETION-REPORT.md |

**Parsing Rules**:
1. Extract decision ID from filename: `RAG-001_*.md` → decisionId: "RAG-001"
2. Extract date from filename: `20260219*` → date: "2026-02-19"
3. Parse frontmatter if present

**Metadata Extraction**:
```javascript
{
  "sourcePlatform": "p4nth30n",
  "sourceType": "decision",
  "platformMetadata": {
    "p4nt30n": {
      "documentType": "decision",
      "decisionId": "RAG-001",
      "phase": "approved"
    }
  }
}
```

### 4.4 WindSurf Extension Logs

**Source**: `C:\Users\paulc\AppData\Roaming\Windsurf\logs\**\*.log`

**Parsing Rules**:
1. Extract timestamp, extension name, message
2. Filter for relevant extensions: `codeium.windsurf`, `windsurf-follower`

**Metadata**:
```javascript
{
  "sourcePlatform": "windsurf",
  "sourceType": "extension_log",
  "platformMetadata": {
    "windsurf": {
      "extension": "codeium.windsurf"
    }
  }
}
```

---

## 5. File Watcher Configuration

### 5.1 Watch List

```yaml
watchers:
  - name: "opencode-sessions"
    path: "C:\\P4NTH30N"
    pattern: "session-ses_*.md"
    interval: 30s
    
  - name: "opencode-debug"
    path: "C:\\Users\\paulc\\.config\\opencode\\.debug"
    pattern: "opencode-debug.log"
    interval: 60s
    
  - name: "p4nth30n-t4ct1cs"
    path: "C:\\P4NTH30N\\T4CT1CS"
    pattern: "**/*.md"
    interval: 30s
    
  - name: "opencode-agents"
    path: "C:\\Users\\paulc\\.config\\opencode\\agents"
    pattern: "*.md"
    interval: 300s
    
  - name: "windsurf-logs"
    path: "C:\\Users\\paulc\\AppData\\Roaming\\Windsurf\\logs"
    pattern: "**/*.log"
    interval: 60s
```

### 5.2 Change Detection

- Use file hash (SHA256) to detect changes
- Only re-index if hash differs from last ingestion
- Store last ingested hash in MongoDB document

---

## 6. Implementation Plan

### Phase 1: Source Connectors (Week 1)

**Deliverable**: Working file watchers for all P0 sources

**Tasks**:
1. Create `RAG\Ingestion\Connectors\FileWatcherConnector.cs`
2. Create `RAG\Ingestion\Connectors\JsonLogConnector.cs`
3. Create `RAG\Ingestion\Parsers\SessionParser.cs`
4. Create `RAG\Ingestion\Parsers\DecisionParser.cs`
5. Implement file watching service

**Dependencies**: RAG-001 Phase 2 (MCP Server)

**Validation**:
```bash
# Test file watching
dotnet test RAG.Ingestion.Tests --filter "FileWatcher"
# Should detect new session files within 30s
```

**Failure Mode**: If file watcher fails, implement polling fallback (every 5 minutes)

---

### Phase 2: Parsers & Chunkers (Week 1-2)

**Deliverable**: All source parsers functional

**Tasks**:
1. Implement OpenCode session parser
2. Implement debug log parser
3. Implement T4CT1CS decision parser
4. Implement WindSurf log parser
5. Implement semantic chunker (from RAG-001)

**Dependencies**: Phase 1

**Validation**:
```bash
# Test parsing
dotnet test RAG.Ingestion.Tests --filter "Parser"
# All parsers should handle edge cases
```

---

### Phase 3: Metadata Enrichment (Week 2)

**Deliverable**: Platform-specific metadata extraction

**Tasks**:
1. Implement OpenCode metadata extraction
2. Implement P4NTH30N metadata extraction
3. Implement WindSurf metadata extraction
4. Add sourcePlatform/sourceType to all documents

**Dependencies**: Phase 2

---

### Phase 4: Integration & Testing (Week 2-3)

**Deliverable**: End-to-end ingestion pipeline

**Tasks**:
1. Connect all components
2. Run 60-sample benchmark
3. Test file change detection
4. Test incremental updates

**Dependencies**: Phase 3, RAG-001 Phase 3

---

## 7. Benchmark Specification

### Test Set: 60 Samples

| Category | Count | Source | Description |
|----------|-------|--------|-------------|
| OpenCode Sessions | 15 | P4NTH30N/session-*.md | Agent conversations |
| OpenCode Debug | 10 | .debug/opencode-debug.log | Log entries |
| P4NTH30N Decisions | 15 | T4CT1CS/intel/*.md | Decision documents |
| P4NTH30N Speeches | 10 | T4CT1CS/speech/*.md | Status reports |
| WindSurf Logs | 5 | Windsurf/logs/*.log | Extension logs |
| Agent Prompts | 5 | .config/opencode/agents/*.md | System prompts |

### Success Criteria

| Metric | Target | Measurement |
|--------|--------|-------------|
| Top-3 Relevance | >85% | Human rating |
| Parse Success Rate | >98% | All sources parseable |
| Chunk Quality | >90% | No truncated concepts |
| Ingestion Latency | <1s/file | Average across types |
| Change Detection | 100% | All file changes detected |

### Sample Queries

```yaml
queries:
  session_context:
    - "Find ARCH-003-PIVOT implementation sessions"
    - "Show me recent RAG-001 discussions"
    
  decisions:
    - "What decisions involved hybrid validation?"
    - "Find all decisions about model testing"
    
  logs:
    - "What errors occurred with fallback chains?"
    - "Show me recent model selection patterns"
    
  platform:
    - "How does OpenCode handle model fallback?"
    - "What WindSurf extensions are active?"
```

---

## 8. Observability

### Per-Source Metrics

```javascript
// In R4G_M37R1C5 collection
{
  "timestamp": ISODate,
  "sourcePlatform": "opencode",     // NEW FIELD
  "sourceType": "session",            // NEW FIELD
  "query": "...",
  "resultsCount": 5,
  "latencyMs": 145,
  "contentType": "chat",
  "agent": "orchestrator"
}
```

### Health Checks

| Source | Check | Interval |
|--------|-------|----------|
| OpenCode Sessions | File exists + readable | 60s |
| OpenCode Debug | Log file growing | 120s |
| T4CT1CS | Directory exists | 60s |
| WindSurf Logs | Log directory exists | 120s |

### Alerting Rules

```yaml
alerts:
  - name: IngestSourceDown
    condition: health_check_failed > 3
    severity: warning
    
  - name: IngestLatencyHigh
    condition: avg_ingestion_latency > 5000
    severity: warning
    
  - name: ParseFailureRate
    condition: parse_failures / total > 0.05
    severity: critical
```

---

## 9. Security Considerations

### File Access Control

- **Read-only**: All source files are read-only to ingestion pipeline
- **No credentials**: No API keys or auth tokens in ingested content
- **Path validation**: Sanitize all file paths to prevent traversal

### Content Filtering

```typescript
// Filter patterns to exclude from ingestion
const EXCLUDE_PATTERNS = [
  /api[_-]?key/i,           // API keys
  /password/i,              // Passwords
  /secret/i,                // Secrets
  /auth/i,                  // Auth tokens (except in context)
  /\.env$/,                 // Environment files
  /auth\.json$/,            // Auth files
];

function shouldIngest(content: string, filePath: string): boolean {
  // Check file path
  if (EXCLUDE_PATTERNS.some(p => p.test(filePath))) {
    return false;
  }
  
  // Check content for secrets
  const lines = content.split('\n');
  const suspiciousLines = lines.filter(line => 
    EXCLUDE_PATTERNS.some(p => p.test(line))
  );
  
  return suspiciousLines.length === 0;
}
```

---

## 10. File Structure

```
P4NTH30N/
├── RAG/
│   └── Ingestion/
│       ├── Connectors/
│       │   ├── FileWatcherConnector.cs
│       │   ├── JsonLogConnector.cs
│       │   └── IFileConnector.cs
│       ├── Parsers/
│       │   ├── SessionParser.cs
│       │   ├── DecisionParser.cs
│       │   ├── LogParser.cs
│       │   ├── AgentPromptParser.cs
│       │   └── IParser.cs
│       ├── Metadata/
│       │   ├── OpenCodeMetadataExtractor.cs
│       │   ├── P4NTH30NMetadataExtractor.cs
│       │   ├── WindSurfMetadataExtractor.cs
│       │   └── IMetadataExtractor.cs
│       ├── Services/
│       │   ├── FileIngestionService.cs
│       │   ├── FileWatcherService.cs
│       │   └── ChangeDetectionService.cs
│       └── Tests/
│           ├── Connectors/
│           ├── Parsers/
│           └── Integration/
```

---

## 11. Dependencies

### Internal
- RAG-001: RAG Context Layer (MongoDB collections, Qdrant, LM Studio)
- RAG.McpHost: MCP server for RAG tools

### External
- FileSystemWatcher (System.IO)
- MongoDB.Driver (inherited from RAG-001)

---

## 12. Fallback Chain

### Level 1: Primary Ingestion (Happy Path)
- **Trigger**: File watcher detects change, file readable
- **Action**: Parse, chunk, embed, index
- **Latency**: <1s per file

### Level 2: Polling Fallback
- **Trigger**: File watcher unavailable
- **Action**: Fall back to 5-minute polling
- **Latency**: <5s per file

### Level 3: Manual Re-index
- **Trigger**: Both watcher and polling fail
- **Action**: Queue for manual re-index via MCP tool
- **User Impact**: Admin must trigger re-index

---

## 13. Rollback Plan

If file ingestion causes issues:

1. **Immediate (0-5 minutes)**:
   - Disable file watchers via config
   - Agents continue with existing RAG context

2. **Short-term (5-30 minutes)**:
   - Stop file watcher service
   - Clear recently indexed files from C0N7EXT
   - Restart RAG MCP server

3. **Long-term (30+ minutes)**:
   - Revert via git
   - Re-index from known good state

---

## 14. Success Criteria

### MVP (Phase 1-2)
- [ ] File watcher detects new sessions within 30s
- [ ] OpenCode sessions parse and index correctly
- [ ] T4CT1CS decisions index with decisionId
- [ ] 30+ documents indexed from all P0 sources
- [ ] Parse success rate >98%

### Full Implementation (Phase 3-4)
- [ ] All 6 source types functional
- [ ] 60+ documents indexed
- [ ] >85% top-3 relevance
- [ ] Change detection working
- [ ] Full observability dashboard

---

## 15. Approval Decision

**Oracle Review Required:**

This decision implements file ingestion for the RAG Context Layer with:
- 12 source paths across 4 platforms (OpenCode, WindSurf, P4NTH30N, VS Code)
- 4-level fallback mechanism (from RAG-001)
- 60-sample benchmark requirement
- <1s/file ingestion latency target
- Comprehensive metadata enrichment

**Recommended Action:** Approve with condition that Phase 1 (Source Connectors) passes 10-sample validation before proceeding to Phase 2.

---

## Consultation Log

- 2026-02-19: Initial specification created by Strategist
- [Pending] Oracle review and approval
- [Pending] Designer technical specification
- [Pending] Fixer implementation
