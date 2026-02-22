# DECISION_077 Directory Structure

## Overview
Navigation Workflow Architecture session recordings for systematic Canvas typing investigation.

## Directory Layout

```
DECISION_077/
├── sessions/                          # Per-session data storage
│   └── firekirin-{timestamp}/         # Example: firekirin-2026-02-21T12-22-45
│       ├── session-meta.json          # Session configuration and metadata
│       ├── session.ndjson             # Machine-readable log (line-delimited JSON)
│       ├── session.md                 # Human-readable narrative report
│       └── screenshots/               # Captured screenshots per step
│           ├── 001.png                # Step 1: Login screen
│           ├── 002.png                # Step 2: Game selection
│           └── 003.png                # Step 3: Spin ready
├── codemap.md                         # This file
└── README.md                          # Decision context and execution guide
```

## Session Structure

### session-meta.json
```json
{
  "sessionId": "firekirin-2026-02-21T12-22-45",
  "platform": "firekirin",
  "decisionId": "DECISION_077",
  "startTime": "2026-02-21T12:22:45Z",
  "workingDir": "C:\\P4NTH30N\\DECISION_077\\sessions\\firekirin-2026-02-21T12-22-45"
}
```

### session.ndjson (Machine-Readable)
Line-delimited JSON, one record per step:
```json
{"stepId":1,"phase":"Login","timestamp":"2026-02-21T12:30:00Z","screenshot":{"path":"screenshots/001.png","hash":"a1b2c3d4..."},"action":{"tool":"t00l5et-diag","args":[],"stdout":"CDP connected...","stderr":"","exitCode":0},"result":{"status":"success","durationMs":1500},"verification":{"entryGate":"Login form visible","exitGate":"CDP responsive","matched":true}}
```

### session.md (Human-Readable)
Markdown narrative with screenshots and analysis.

## Related Components

- **Recorder Tool**: `H4ND/tools/recorder/` - TypeScript CLI for session management
- **Phase Definitions**: `H4ND/config/firekirin/phase-definitions.json` - UI coordinates
- **T00L5ET Tools**: `T00L5ET/` - Diagnostic and navigation primitives
- **Decision Document**: `STR4TEG15T/decisions/active/DECISION_077.md` - Full specification

## Usage

### Initialize New Session
```bash
cd C:\P4NTH30N\H4ND\tools\recorder
bun run recorder.ts --init --platform=firekirin --decision=DECISION_077
```

### Record Navigation Step
```bash
bun run recorder.ts --step \
  --phase=Login \
  --screenshot=001.png \
  --session-dir="C:\P4NTH30N\DECISION_077\sessions\firekirin-{timestamp}" \
  --run-tool=diag
```

## Platform Investigation Sequence

1. **FireKirin** (Current) - Canvas typing works, establish baseline
2. **OrionStars** (Next) - Canvas typing broken, investigate alternatives

## Output

- Verified navigation maps per platform
- Canvas typing strategy effectiveness report
- Decision-ready documentation for DECISION_047 fix
