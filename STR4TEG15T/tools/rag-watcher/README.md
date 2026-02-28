# RAG Watcher

File watcher and RAG ingestion system for Pantheon agent documentation. Automatically watches for changes in decision files and ingests them into the RAG knowledge base.

## Overview

RAG Watcher implements Phase 0 of DECISION_086 (Agent Documentation & RAG Integration System). It provides:

- **File Watching**: Monitors `STR4TEG15T/decisions/*.md` for changes
- **YAML Frontmatter Parsing**: Extracts metadata from markdown documents
- **Schema Validation**: Validates documents against agent-doc-schema.json
- **RAG Ingestion**: Automatically ingests valid documents into the RAG system
- **Git Integration**: Tracks git commit hashes for document versioning

## Installation

```bash
cd STR4TEG15T/tools/rag-watcher

# Install dependencies
npm install

# Or with Bun
bun install
```

## Building

```bash
# Compile TypeScript
npm run build

# Or with Bun
bun run build
```

## Usage

### Batch Ingestion (Default)

Process all decision files once:

```bash
npm start

# Or with explicit path
P4NTHE0N_ROOT=/path/to/P4NTHE0N npm start
```

### Watch Mode

Continuously watch for file changes:

```bash
npm run watch

# Or
npm start -- --watch
```

### Validation Only

Validate all decision files without ingesting:

```bash
npm run validate

# Or
npm start -- --validate
```

### Manual Ingestion

Ingest specific files or all files:

```bash
npm run ingest
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `P4NTHE0N_ROOT` | Path to P4NTHE0N repository | `c:\P4NTHE0N` |
| `LOG_LEVEL` | Logging level (debug, info, warn, error) | `info` |

### Directory Structure

The watcher expects the following structure:

```
P4NTHE0N/
├── STR4TEG15T/
│   ├── decisions/
│   │   ├── active/
│   │   ├── completed/
│   │   └── _templates/
│   └── tools/
│       └── rag-watcher/
│           ├── src/
│           ├── dist/
│           └── package.json
```

## Document Format

Documents must include YAML frontmatter:

```markdown
---
agent: strategist
type: decision
decision: DECISION-086
created: 2026-02-21T00:00:00Z
updated: 2026-02-21T00:00:00Z
status: active
tags: [strategy, documentation, rag]
priority: high
schemaVer: 1.0.0
---

# Document Title

Content here...
```

### Required Fields

- `agent`: The agent role (strategist, oracle, designer, librarian, fixer, etc.)
- `type`: Document type (decision, assessment, architecture, research, etc.)
- `created`: ISO 8601 timestamp
- `status`: Document status (draft, active, archived, deleted, canon)

### Optional Fields

- `decision`: Associated decision ID (e.g., DECISION-086)
- `updated`: Last modification timestamp
- `tags`: Array of lowercase hyphenated tags
- `priority`: critical, high, medium, low
- `schemaVer`: Schema version (default: 1.0.0)
- `gitCommit`: Git commit hash (auto-populated)
- `source`: File path (auto-populated)

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      RAG Watcher                            │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐ │
│  │ Watcher  │──▶│  Parser  │──▶│ Validator│──▶│ Ingester │ │
│  │ (chokidar)│   │  (yaml)  │   │ (schema) │   │  (RAG)   │ │
│  └──────────┘   └──────────┘   └──────────┘   └──────────┘ │
│        │                                            │       │
│        ▼                                            ▼       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Git Integration                         │  │
│  │         (simple-git for commit tracking)             │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │   RAG Server     │
                    │ (rag-server MCP) │
                    └──────────────────┘
```

## Modules

### `watcher.ts`
File system watcher using chokidar. Supports debouncing (500ms) to batch rapid changes.

### `parser.ts`
YAML frontmatter parser. Extracts metadata and body content from markdown files.

### `validator.ts`
JSON Schema validation. Ensures documents meet the required format.

### `ingester.ts`
RAG ingestion pipeline. Prepares and sends documents to the RAG server.

### `git.ts`
Git integration using simple-git. Tracks commit hashes for document versioning.

### `logger.ts`
Structured logging utility with configurable log levels.

## Development

```bash
# Run in development mode with auto-rebuild
bun run dev

# Run tests
bun test
```

## Templates

Documentation templates are available in `../templates/`:

- `strategist-output.md` - Decision documents
- `oracle-assessment.md` - Risk assessments and validations
- `designer-architecture.md` - System architecture specifications
- `librarian-research.md` - Research briefs and findings
- `fixer-implementation.md` - Implementation reports
- `agent-handoff.md` - Agent-to-agent handoff documents

## Validation Schema

The JSON Schema for document validation is located at `../agent-doc-schema.json`.

## Integration with RAG Server

RAG Watcher integrates with the RAG server via ToolHive MCP tools:

- `rag-server_rag_ingest` - Ingest documents
- `rag-server_rag_query` - Query ingested documents
- `rag-server_rag_status` - Check RAG server health

## Troubleshooting

### Common Issues

**Watcher not detecting changes:**
- Check that the decisions path is correct
- Verify file permissions
- Ensure the file has `.md` extension

**Validation failures:**
- Check that all required frontmatter fields are present
- Verify timestamps are in ISO 8601 format
- Ensure agent and type values are from the allowed list

**Ingestion failures:**
- Verify RAG server is running
- Check network connectivity
- Review logs for specific error messages

### Debug Mode

Enable debug logging:

```bash
LOG_LEVEL=debug npm start
```

## License

MIT

## See Also

- DECISION_086: Agent Documentation & RAG Integration System
- AGENTS.md: Pantheon Agent Reference Guide
- `../agent-doc-schema.json`: Document validation schema
