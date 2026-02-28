---
name: codemap-management
description: Manage and maintain P4NTH30N codemap documentation system. Use for generating codemaps, updating existing ones, validating consistency, and ensuring documentation stays synchronized with codebase changes. Triggers include questions about codemaps, documentation updates, code structure analysis, or maintaining repository documentation.
---

# Codemap Management

Manage and maintain the comprehensive codemap documentation system for P4NTH30N. Generate new codemaps, update existing ones, validate consistency across the documentation ecosystem, and ensure codemaps stay synchronized with codebase evolution.

## When to Use
- Creating new directories or components that need codemap documentation
- Updating existing codemaps after code changes
- Validating codemap consistency across the repository
- Analyzing codebase structure and dependencies
- Onboarding new developers with repository navigation
- Before major refactoring or architectural changes

## Usage

```markdown
@codemap-management
Action: generate
Target: C:\P4NTH30N\NEW_COMPONENT
```

Or ask Cascade:
"Update the codemap for the H4ND directory after recent changes"

## Codemap System Overview

### Current Codemap Inventory
- **Main Repository**: `codemap.md` (453 lines) - Complete system atlas
- **Documentation**: `docs/codemap.md` (222 lines) - Documentation repository map
- **Component Maps**: 74 total codemaps across all directories
- **Coverage**: C0MMON, H4ND, H0UND, W4TCHD0G, T00L5ET, UNI7T35T, plus subdirectories

### Codemap Structure Template
```markdown
# {DIRECTORY}/
UpdateOn: {TIMESTAMP}

## Responsibility
{Brief description of directory's purpose and role in system}

## Design
{Architecture patterns, key design decisions, structure}

### Key Patterns
{Important implementation patterns and conventions}

### Project Structure
{Directory tree with key files and subdirectories}

## Flow
{Execution flows, data flows, or process flows}

## Integration
{How this component connects to other parts of system}

## Key Files
{Important files and their purposes}

## Recent Changes
{Recent modifications and their impact}

## Dependencies
{External dependencies and requirements}
```

## Step 1: Discover Codemap Status

Scan the repository to identify codemap coverage and gaps:

```bash
# Find all existing codemaps
find . -name "codemap.md" -type f

# Identify directories without codemaps (excluding build artifacts and temp dirs)
find . -type d \( -name "obj" -o -name "bin" -o -name ".git" -o -name "node_modules" -o -name ".vs" -o -name "packages" -o -name "TestResults" -o -name "coverage" -o -name ".pytest_cache" -o -name "__pycache__" \) -prune -o -type d -exec test ! -f "{}/codemap.md" \; -print

# Check codemap consistency
grep -r "UpdateOn:" **/codemap.md | sort
```

## Directory Exclusion Criteria

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

### Conditional Exclusions (Case-by-Case)
- **External Dependencies**: `chrome-devtools-mcp/` (third-party tools)
- **Generated Code**: Auto-generated files or scaffolding
- **Simple Config**: Directories with only configuration files
- **Empty Directories**: Directories with < 3 significant files
- **Test Data**: Test fixtures or mock data directories

### Inclusion Criteria (Codemap Recommended)
- **Source Code**: Directories with .cs, .ts, .js, .py, etc. source files
- **Complex Components**: > 5 files or multiple subdirectories
- **Core Architecture**: Main project directories (C0MMON, H4ND, H0UND, etc.)
- **Infrastructure**: Services, middleware, platform components
- **Business Logic**: Domain-specific code and implementations
- **Integration Points**: Components that connect to other systems

## Step 2: Generate New Codemap

For directories without codemaps or new components:

### Pre-Generation Filtering
Before generating a codemap, apply intelligent filtering:

1. **Check Against Exclusion List**
   - Automatically skip directories matching exclusion criteria
   - Verify directory isn't a build artifact, cache, or temp directory
   - Ensure directory contains meaningful code or configuration

2. **Assess Directory Value**
   - Count significant files (exclude .gitignore, README.md, etc.)
   - Check for source code files (.cs, .ts, .js, .py, etc.)
   - Evaluate complexity (subdirectories, file count, file types)

3. **Determine Necessity**
   - **Skip**: < 3 significant files, only configs, or build artifacts
   - **Consider**: 3-5 files, simple structure, single purpose
   - **Generate**: > 5 files, multiple subdirectories, complex logic

### Analysis Phase
1. **Directory Structure Analysis**
   - List all files and subdirectories
   - Identify primary file types (.cs, .md, .json, etc.)
   - Note any special subdirectories (Infrastructure, Services, etc.)

2. **Code Pattern Analysis**
   - Read key files to understand purpose
   - Identify main classes and their responsibilities
   - Look for dependency injection patterns
   - Note any interfaces or abstractions

3. **Integration Analysis**
   - Check project references (.csproj files)
   - Look for using statements and imports
   - Identify MongoDB collections or external APIs
   - Note configuration files and settings

### Generation Decision Matrix
| Directory Characteristics | Action | Rationale |
|-------------------------|--------|-----------|
| Build artifacts (obj/, bin/) | **Skip** | Generated automatically, no human-maintained code |
| IDE files (.vs/, .vscode/) | **Skip** | Tool-specific configuration, not project logic |
| Package caches (node_modules/) | **Skip** | External dependencies, not part of codebase |
| < 3 files + simple configs | **Skip** | Too simple to warrant documentation |
| 3-5 files, single purpose | **Consider** | Document only if complex or frequently modified |
| > 5 files or multiple subdirs | **Generate** | Complex enough to benefit from navigation aid |
| Core architecture component | **Generate** | Critical for understanding system design |
| External tool integration | **Skip** | Third-party code, not maintained by team |

2. **Code Pattern Analysis**
   - Read key files to understand purpose
   - Identify main classes and their responsibilities
   - Look for dependency injection patterns
   - Note any interfaces or abstractions

3. **Integration Analysis**
   - Check project references (.csproj files)
   - Look for using statements and imports
   - Identify MongoDB collections or external APIs
   - Note configuration files and settings

### Generation Phase
1. **Create codemap structure** using template
2. **Fill Responsibility section** with directory purpose
3. **Document Design patterns** observed in code
4. **Map Project Structure** with meaningful descriptions
5. **Describe Integration points** with other components
6. **List Key Files** and their specific roles
7. **Note Dependencies** and requirements

## Step 3: Update Existing Codemaps

When code changes occur:

### Change Detection
1. **Git diff analysis** to identify modified files
2. **New file detection** in directory
3. **Deleted file tracking** for cleanup
4. **Dependency changes** in project files

### Update Process
1. **Update timestamp** in UpdateOn field
2. **Add new files** to Project Structure section
3. **Update descriptions** for modified components
4. **Document new dependencies** or integration points
5. **Update Recent Changes** section with modifications
6. **Validate consistency** with other codemaps

## Step 4: Validate Codemap Consistency

Ensure all codemaps work together as a coherent system:

### Cross-Reference Validation
1. **Dependency consistency** - Check that referenced directories exist
2. **Integration accuracy** - Verify integration descriptions match actual code
3. **Naming consistency** - Ensure component names match across codemaps
4. **Version synchronization** - Check UpdateOn timestamps make sense

### Content Validation
1. **Structure compliance** - All codemaps follow template
2. **Completeness** - All required sections are filled
3. **Accuracy** - Descriptions match actual implementation
4. **Freshness** - Recent changes are documented

### Exclusion Compliance Validation
1. **Verify excluded directories** should not have codemaps
2. **Check for unnecessary codemaps** in build artifacts or temp dirs
3. **Validate inclusion decisions** match criteria
4. **Review edge cases** where decisions might need reconsideration

## Step 5: Synchronize with Documentation

Ensure codemaps align with other documentation:

### Documentation Integration
1. **ADR consistency** - Architecture Decision Records match codemap descriptions
2. **API documentation** - API docs align with codemap integration points
3. **Runbook relevance** - Operational procedures reference correct components
4. **Strategy alignment** - High-level strategy matches documented architecture

### Update Coordination
1. **Update related docs** when codemaps change
2. **Cross-reference codemaps** in relevant documentation
3. **Maintain change logs** for architectural evolution
4. **Notify stakeholders** of significant documentation updates

## Resources

- Template generator: `STR4TEG15T/tools/codemap-generator/`
- Validation scripts: `scripts/docs/validate-codemaps.ps1`
- Change detection: `scripts/docs/detect-codemap-changes.ps1`
- Bulk update tool: `scripts/docs/bulk-update-codemaps.ps1`

## Automation Options

### Git Hook Integration
```bash
# Pre-commit hook to check codemap relevance
#!/bin/bash
if git diff --name-only HEAD | grep -q "\.cs$"; then
    echo "Code changes detected - consider updating relevant codemaps"
fi
```

### Scheduled Validation
```bash
# Weekly codemap consistency check
powershell -File "scripts/docs/validate-codemaps.ps1" --report --email
```

### CI/CD Integration
```yaml
# GitHub Actions workflow
- name: Validate Codemaps
  run: |
    scripts/docs/validate-codemaps.ps1
    scripts/docs/check-codemap-coverage.ps1
```

## Output

Provides:
1. **Generated codemaps** for new directories following established template
2. **Updated codemaps** reflecting recent code changes
3. **Validation reports** identifying inconsistencies or gaps
4. **Coverage analysis** showing codemap completeness across repository
5. **Change recommendations** for documentation improvements

## Quality Standards

### Codemap Quality Criteria
- **Completeness**: All directories with significant code have codemaps
- **Accuracy**: Descriptions match actual implementation
- **Consistency**: All codemaps follow established template
- **Freshness**: Recent changes are documented within 7 days
- **Integration**: Cross-references are accurate and up-to-date

### Maintenance Schedule
- **Real-time updates**: For major architectural changes
- **Weekly reviews**: For routine code changes
- **Monthly audits**: For comprehensive validation
- **Quarterly overhauls**: For template improvements and standards updates

## Example Workflows

### New Component Addition
```
@codemap-management
Action: generate
Target: C:\P4NTH30H\NEW_SERVICE
Template: standard
Analyze: deep
Filter: auto-exclude
```

### Bulk Update After Refactoring
```
@codemap-management
Action: bulk-update
Scope: H4ND/Parallel/
Changes: "Added parallel execution workers"
Validation: cross-reference
Exclude: build-artifacts,temp-files
```

### Repository Health Check
```
@codemap-management
Action: validate
Scope: entire-repository
Report: detailed
Recommendations: true
Filter: intelligent
Check-exclusions: true
```

### Selective Generation
```
@codemap-management
Action: generate-missing
Scope: C:\P4NTH30N/
Min-files: 5
Exclude-patterns: "obj/,bin/,git/,vs/,node_modules/"
Include-only: source-code,infrastructure
```

### Cleanup Unnecessary Codemaps
```
@codemap-management
Action: cleanup
Target: build-artifacts,ide-files,temp-dirs
Confirm: true
Backup: false
```

### Coverage Analysis
```
@codemap-management
Action: analyze-coverage
Scope: full-repository
Report: summary
Gap-analysis: true
Exclusion-report: true
```