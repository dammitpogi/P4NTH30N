# Build Instructions

## Prerequisites

- [Bun](https://bun.sh) v1.0.0 or higher
- Node.js (for compatibility, though Bun is primary)

## Installation

```bash
cd STR4TEG15T/memory/tools
bun install
```

This installs:
- `gray-matter` - YAML frontmatter parsing
- `zod` - Schema validation
- `@types/bun` - Bun type definitions

## Development

### Type Checking

```bash
bun run typecheck
```

Or manually:

```bash
bunx tsc --noEmit
```

### Running Sweep

```bash
# Development mode
bun run sweep

# With options
bun run sweep --full --dry-run
```

### Running Search

```bash
bun run searcher "your query"
```

## Building Executable

Compile to standalone executable:

```bash
bun run build
```

This creates `STR4TEG15T/memory/sweep.exe` (or `sweep` on Unix).

The executable:
- Includes Bun runtime (no external dependencies)
- Size: ~40-50 MB
- Can be run directly: `./sweep.exe --full`

## Project Structure

```
tools/
├── package.json       # Dependencies and scripts
├── tsconfig.json      # TypeScript configuration
├── types.ts           # TypeScript interfaces
├── schema.ts          # Zod validation schemas
├── parser.ts          # YAML frontmatter parser
├── sweep.ts           # Main CLI entry point
├── searcher.ts        # Search CLI
├── normalizers/       # Document normalizers
│   ├── index.ts
│   └── decision.ts
├── indexers/          # Index builders
│   ├── index.ts
│   ├── keyword.ts
│   └── metadata.ts
└── utils/             # Utilities
    ├── logger.ts
    ├── paths.ts
    └── validation.ts
```

## Testing

Run validation to check documents:

```bash
bun run sweep --validate
```

Verify indexes were created:

```bash
ls -la ../indexes/
# Should show: keyword-index.json, metadata-table.csv
```

Test search:

```bash
bun run searcher --keyword mongodb
```

## Troubleshooting

### "Cannot find module"

Make sure dependencies are installed:

```bash
bun install
```

### Permission denied on sweep

Make executable:

```bash
chmod +x sweep.ts
# Or on Windows, use: bun run sweep
```

### Indexes not updating

Force full rebuild:

```bash
bun run sweep --full
```

### Type errors

Check TypeScript version compatibility:

```bash
bunx tsc --version
```

## Deployment

To use in production:

1. Build executable:
   ```bash
   bun run build
   ```

2. Copy to system PATH (optional):
   ```bash
   cp ../sweep.exe /usr/local/bin/
   # Or on Windows, add to PATH
   ```

3. Run from anywhere:
   ```bash
   sweep --full
   ```

## CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Update Memory Indexes

on:
  push:
    paths:
      - 'STR4TEG15T/decisions/**'
      - 'STR4TEG15T/canon/**'

jobs:
  sweep:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: oven-sh/setup-bun@v1
      - run: cd STR4TEG15T/memory/tools && bun install
      - run: bun run sweep
      - run: git add ../indexes/ && git commit -m "Update memory indexes" && git push
```
