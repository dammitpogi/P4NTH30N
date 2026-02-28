---
name: codemap-cartography
description: Repository understanding and hierarchical codemap generation for WindSurf. Analyzes codebase structure, generates codemap documentation, and maintains repository atlas. Use for understanding unfamiliar codebases, documenting architecture, or creating comprehensive repository maps.
---

# Codemap Cartography Skill

You help users understand and map repositories by creating hierarchical codemaps using WindSurf's tool ecosystem.

## When to Use

- User asks to understand/map a repository
- User wants codebase documentation  
- Starting work on an unfamiliar codebase
- Need to update repository documentation after changes
- Creating onboarding materials for new developers

## Workflow

## Hard Requirements (Non-Optional)

1. **You must use WindSurf tools for codemap authoring.**
   - Use `find_by_name`, `grep_search`, `read_file` for analysis
   - Use `write_to_file` or `edit` for creating/updating codemaps
   - No external agent delegation required
2. **Do not claim a codemap is populated unless it was actually written in this run** (or already contained non-template content that you verified).
3. **Do not stop at analysis**. Cartography is not complete until affected `codemap.md` files are filled and the root atlas is updated.
4. **Always report evidence**: number of directories analyzed, files read, and codemaps updated.
5. **Use WindSurf's built-in tools** for all operations - no external script dependencies.
6. **Complete verification before completion** - all targeted codemaps must pass content validation.
7. **No placeholders allowed at completion.** Any targeted `codemap.md` that still contains template markers means the run is incomplete.
8. **Directory-scoped accuracy is mandatory.** A codemap may describe only code/config that actually exists in that directory subtree.

### Step 1: Repository Analysis

**First, analyze the repository structure using WindSurf tools.**

1. **Get directory overview**:
   ```bash
   find_by_name --SearchDirectory="./" --Pattern="*" --Type="directory"
   ```

2. **Identify existing codemaps**:
   ```bash
   find_by_name --SearchDirectory="./" --Pattern="**/codemap.md"
   ```

3. **Check for state tracking** (optional):
   - Look for `.slim/cartography.json` or similar tracking files
   - If present, use for change detection
   - If not present, proceed with full analysis

### Step 2: Discover Code Structure

1. **Analyze repository structure** - Use `find_by_name` to understand directories
2. **Identify key file patterns** for core code/config files:
   - **Include**: `src/**/*.cs`, `**/*.csproj`, `**/*.ts`, `**/*.js`, etc.
   - **Exclude (MANDATORY)**: 
     - Tests: `**/*.test.cs`, `**/*.Tests.cs`, `tests/**`, `**/Test*/**`
     - Build artifacts: `bin/**`, `obj/**`, `dist/**`, `build/**`
     - Version control: `.git/**`
     - IDE files: `.vs/**`, `.vscode/**`
     - Dependencies: `node_modules/**`, `packages/**`
3. **Create target directory list** - Focus on directories with significant code
4. **Generate empty codemaps** - Create `codemap.md` files in target directories that don't have them

### Step 3: Analyze Each Directory

For each target directory:

1. **Read directory contents**:
   ```bash
   list_dir --DirectoryPath="<directory_path>"
   ```

2. **Analyze key files**:
   ```bash
   read_file --file_path="<directory_path>/important_file.cs"
   ```

3. **Search for patterns**:
   ```bash
   grep_search --SearchPath="<directory_path>" --Query="class|interface|namespace" --Includes="*.cs"
   ```

4. **Generate codemap content** based on analysis:
   - **Responsibility** - What this directory does
   - **Design** - Patterns and architecture used  
   - **Flow** - How data/control moves through
   - **Integration** - How it connects to other parts
   - **Key Files** - Important files and their purposes

### Step 4: Finalize Repository Atlas (Root Codemap)

Once all specific directories are mapped, create or update the root `codemap.md`. This file serves as the **Master Entry Point** for any agent or human entering the repository.

1. **Map Root Assets**: Document the root-level files and the project's overall purpose.
2. **Aggregate Sub-Maps**: Create a "Repository Directory Map" section. For every folder that has a `codemap.md`, extract its **Responsibility** summary and include it in a table.
3. **Cross-Reference**: Ensure that the root map contains the paths to the sub-maps so agents can jump directly to relevant details.

### Step 5: Verification Gate (Must Pass Before Completion)

Before declaring cartography complete, perform all checks below:

1. **Analysis evidence**: confirm directories were analyzed using WindSurf tools.
2. **Content quality**: ensure each updated `codemap.md` contains at least these sections:
   - `## Responsibility`
   - `## Design`
   - `## Flow`
   - `## Integration`
3. **Template detection**: reject placeholder-only content (for example, `TODO`, `Fill in`, empty headings).
4. **Atlas sync**: root `codemap.md` references all updated subdirectory maps.
5. **File verification**: confirm all codemap files were actually written/updated.
6. **Context correctness check**: each codemap must cite concrete, local artifacts (file paths, modules, functions, interfaces) from its own directory tree.
7. **Scope purity check**: remove claims about unrelated directories/providers/frameworks not present in local files.
8. **Placeholder sweep**: perform a final search for template markers across targeted codemaps; any match fails the run.

Completion report format (required):
- Directories analyzed: `<count>`
- Files read: `<count>`
- Codemaps updated: `<count>`
- Root atlas updated: `yes|no`
- Placeholder-free after run: `yes|no`
- Scope/context validation passed: `yes|no`

### Step 6: Deterministic Completion Loop (Required)

Run this loop until all checks pass:

1. Detect targets (user scope or repository analysis).
2. Analyze directories using WindSurf tools.
3. Generate codemap content for each target directory.
4. Validate section completeness + local artifact grounding.
5. Write codemap files using WindSurf tools.
6. Update root atlas references.
7. Verify all files exist and contain proper content.
8. Re-check for placeholders; if any found, repeat.

## Codemap Content

Use WindSurf tools to analyze and document the implementation. Use precise technical terminology based on actual code analysis:

- **Responsibility** - Define the specific role of this directory using standard software engineering terms (e.g., "Service Layer", "Data Access Object", "Middleware").
- **Design Patterns** - Identify and name specific patterns used (e.g., "Observer", "Singleton", "Factory", "Strategy"). Detail the abstractions and interfaces.
- **Data & Control Flow** - Explicitly trace how data enters and leaves the module. Mention specific function call sequences and state transitions.
- **Integration Points** - List dependencies and consumer modules. Use technical names for hooks, events, or API endpoints.

**CRITICAL**: Document what actually exists in the code, not what should exist or what documentation claims. Avoid aspirational architecture descriptions.

Example codemap based on actual code analysis:

```markdown
# C0MMON/Infrastructure/

## Responsibility
Infrastructure layer providing MongoDB persistence, CDP client, caching, configuration, and monitoring for the P4NTH30N ecosystem.

## Design
Basic repository pattern with MongoDB:
- Repository interfaces in IRepo<T> format
- MongoUnitOfWork implements IUnitOfWork for atomic operations
- Validation pattern using IsValid(IStoreErrors?) method
- Configuration via P4NTHE0NOptions and dependency injection

## Flow
1. MongoUnitOfWork created with IMongoDatabaseProvider
2. Repository instances created (RepoCredentials, RepoSignals, etc.)
3. Components use repositories via dependency injection
4. Validation performed via IsValid() methods
5. Errors logged to ERR0R collection via IStoreErrors

## Integration
- Consumed by: H4ND, H0UND, W4TCHD0G (all reference C0MMON)
- Depends on: MongoDB.Driver, MongoDB.EntityFrameworkCore
- Key files: MongoUnitOfWork.cs, Repositories.cs, MongoDatabaseProvider.cs
```

Example **Root Codemap (Atlas)**:

```markdown
# Repository Atlas: P4NTH30N Platform

## Project Responsibility
Multi-agent automation platform for online casino game portals. Event-driven system with H0UND polling+analytics and H4ND automation communicating via MongoDB.

## System Entry Points
- `H4ND/`: Automation agent (signal-driven gameplay)
- `H0UND/`: Polling + analytics agent (DPD forecasting)
- `W4TCHD0G/`: Vision system with OBS integration
- `T00L5ET/`: Manual utilities and database operations
- `UNI7T35T/`: Testing platform with comprehensive test suite
- `C0MMON/`: Shared library with MongoDB persistence, monitoring, configuration

## Repository Directory Map
| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `C0MMON/` | Shared infrastructure with MongoDB repositories, CDP client, configuration system | [View Map](C0MMON/codemap.md) |
| `H4ND/` | Browser automation using Chrome DevTools Protocol with signal processing | [View Map](H4ND/codemap.md) |
| `H0UND/` | Analytics agent with polling, forecasting, and jackpot threshold analysis | [View Map](H0UND/codemap.md) |
| `W4TCHD0G/` | Computer vision system with OBS integration and safety monitoring | [View Map](W4TCHD0G/codemap.md) |
```

## Exclusion Criteria

### Automatic Exclusions (No Codemap Needed)
- **Build Artifacts**: `obj/`, `bin/`, `publish/`, `dist/`, `build/`
- **Version Control**: `.git/`, `.gitignore`, `.gitattributes`
- **IDE Files**: `.vs/`, `.vscode/`, `.idea/`, `*.suo`, `*.user`
- **Package Management**: `packages/`, `node_modules/`, `.npm/`
- **Test Results**: `TestResults/`, `coverage/`, `.pytest_cache/`, `__pycache__/`
- **Temporary Files**: `tmp/`, `temp/`, `.tmp/`, `.temp/`
- **Cache Directories**: `.cache/`, `cache/`
- **Log Directories**: `logs/`, `.logs/`
- **Backup Directories**: `.backups/`, `backup/`, `backups/`
- **Configuration**: `.config/` (unless contains project-specific code)
- **Documentation Metadata**: `.windsurf/`, `.slim/` (internal tool files)

### Inclusion Criteria (Codemap Recommended)
- **Source Code**: Directories with .cs, .ts, .js, .py, etc. source files
- **Complex Components**: > 5 files or multiple subdirectories
- **Core Architecture**: Main project directories (C0MMON, H4ND, H0UND, etc.)
- **Infrastructure**: Services, middleware, platform components
- **Business Logic**: Domain-specific code and implementations
- **Integration Points**: Components that connect to other systems

## Quality Standards

### Codemap Quality Criteria
- **Accuracy**: Descriptions match actual implementation, not aspirations
- **Evidence-Based**: All claims supported by concrete file analysis
- **Completeness**: All required sections filled with meaningful content
- **Consistency**: All codemaps follow established template
- **Freshness**: Recent changes documented within 7 days
- **Integration**: Cross-references are accurate and up-to-date

### Anti-Patterns to Avoid
- **Aspirational Documentation**: Describing architecture that "should" exist
- **Template Placeholders**: Leaving TODO or "Fill in" markers
- **Over-Engineering**: Claiming complex patterns not present in code
- **External Claims**: Describing frameworks or patterns not actually used
- **Copy-Paste**: Reusing generic descriptions without local adaptation

## Example Workflows

### Full Repository Analysis
```
@codemap-cartography
Action: full-analysis
Scope: entire-repository
Exclude: build-artifacts,test-results,ide-files
Depth: comprehensive
Validation: strict
```

### Targeted Directory Update
```
@codemap-cartography
Action: update-directories
Targets: H4ND/Parallel/,C0MMON/Infrastructure/
Analysis: deep
Integration: cross-reference
```

### Change Detection
```
@codemap-cartography
Action: detect-changes
Since: 2026-02-20
Scope: modified-directories
Update: affected-codemaps
```

### Quality Audit
```
@codemap-cartography
Action: audit-quality
Check: accuracy,completeness,consistency
Report: detailed
Recommendations: true
```
