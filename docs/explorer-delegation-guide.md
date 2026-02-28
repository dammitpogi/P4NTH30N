# Explorer-Enhanced Workflows Guide
## STRATEGY-007 Phase 1 - Pattern Matching & Codebase Discovery

**Decision ID**: STRATEGY-007  
**Phase**: 1 (WindFixer - Documentation)  
**Status**: Complete

---

## Purpose

Explorer agents perform codebase discovery and context gathering before implementation work begins. This guide documents proven patterns for delegating exploration tasks to maximize efficiency across multi-agent workflows.

---

## Delegation Patterns

### Pattern 1: Targeted File Discovery

**When**: You need to find specific implementations, interfaces, or patterns.

**Template**:
```
EXPLORER TASK: Locate all implementations of [interface/pattern]
SCOPE: [directory scope, e.g., C0MMON/, H0UND/]
OUTPUT: List of files, line ranges, and brief purpose of each
CONSTRAINTS: Do not modify files. Report only.
```

**Example**:
```
EXPLORER TASK: Locate all IReceiveSignals implementations
SCOPE: C0MMON/, H0UND/, H4ND/
OUTPUT: File paths, class names, method signatures
CONSTRAINTS: Read-only exploration
```

### Pattern 2: Dependency Mapping

**When**: Understanding how components connect before making changes.

**Template**:
```
EXPLORER TASK: Map dependencies for [component]
SCOPE: Full solution
OUTPUT: Dependency graph (who calls what, who references what)
CONSTRAINTS: Include both direct and transitive dependencies
```

**Example**:
```
EXPLORER TASK: Map all consumers of CRED3N7IAL collection
SCOPE: C0MMON/, H0UND/, H4ND/
OUTPUT: Which files read/write CRED3N7IAL, what operations they perform
```

### Pattern 3: Pattern Extraction

**When**: Need to understand existing conventions before writing new code.

**Template**:
```
EXPLORER TASK: Extract coding patterns for [feature type]
SCOPE: [reference implementations]
OUTPUT: Pattern template with annotated examples
CONSTRAINTS: Focus on style, error handling, naming conventions
```

**Example**:
```
EXPLORER TASK: Extract MongoDB repository pattern
SCOPE: C0MMON/Infrastructure/Persistence/
OUTPUT: Repository class template, CRUD patterns, error handling conventions
```

### Pattern 4: Impact Analysis

**When**: Assessing what a proposed change will affect.

**Template**:
```
EXPLORER TASK: Analyze impact of changing [component/interface]
SCOPE: Full solution
OUTPUT: Affected files, breaking changes, migration steps needed
CONSTRAINTS: Do not make changes, report only
```

---

## Codebase Discovery Templates

### Template: New Feature Discovery

```markdown
## Discovery Request: [Feature Name]

### Questions to Answer
1. Does similar functionality already exist?
2. What patterns should the new feature follow?
3. What dependencies will it need?
4. What tests exist for related features?

### Search Strategy
1. Grep for related keywords: [keyword list]
2. Check existing implementations: [directory list]
3. Review test coverage: UNI7T35T/Tests/
4. Check decision records: T4CT1CS/decisions/

### Expected Output
- [ ] Related existing files (with line ranges)
- [ ] Applicable patterns/conventions
- [ ] Required dependencies (NuGet, project refs)
- [ ] Existing test patterns to follow
- [ ] Potential conflicts or overlaps
```

### Template: Bug Investigation

```markdown
## Investigation Request: [Bug Description]

### Reproduction Context
- Error message: [exact error]
- Stack trace: [if available]
- Affected component: [H0UND/H4ND/C0MMON]

### Search Strategy
1. Search for error text in codebase
2. Trace call stack from entry point
3. Check ERR0R collection for similar patterns
4. Review recent changes to affected files

### Expected Output
- [ ] Root cause identification
- [ ] Affected code paths (file:line)
- [ ] Related error patterns from ERR0R collection
- [ ] Suggested fix approach (do not implement)
```

### Template: Architecture Review

```markdown
## Architecture Review: [Component]

### Review Scope
- Component: [name]
- Files: [list or directory]
- Focus: [performance/security/correctness/style]

### Checklist
1. Does it follow project conventions? (AGENTS.md)
2. Are there missing null checks? (nullable enabled)
3. Is error handling consistent? (StackTrace pattern)
4. Are there performance concerns?
5. Is the code testable?

### Expected Output
- [ ] Conformance score (0-10)
- [ ] Specific issues with file:line references
- [ ] Recommended improvements (prioritized)
```

---

## Best Practices

### For Delegators (Strategist/Fixer agents)
- **Be specific**: Narrow the search scope to relevant directories
- **Set constraints**: Clearly state read-only vs. modification allowed
- **Define output format**: Specify what the discovery report should contain
- **Time-box**: Set reasonable limits for exploration depth

### For Explorers
- **Use codemap.md files**: Check existing codemaps before deep exploration
- **Report uncertainty**: Flag areas where findings are ambiguous
- **Include context**: Always include file paths and line numbers
- **Stay in scope**: Don't explore beyond the requested scope

### Anti-Patterns to Avoid
- **Boiling the ocean**: Exploring the entire codebase when only one directory matters
- **Modifying during discovery**: Explorer tasks should be read-only unless explicitly stated
- **Missing citations**: Always reference specific files and line numbers
- **Ignoring existing maps**: Check codemap.md and cartography.json first

---

## Integration with P4NTHE0N Workflow

### Pre-Implementation Discovery
```
1. Strategist creates decision
2. Explorer discovers codebase context (this guide)
3. Designer reviews architecture
4. Oracle assesses risk
5. Fixer implements
```

### Context Handoff Format
```json
{
  "discoveryId": "EXPLORE-001",
  "requestedBy": "Strategist",
  "scope": "C0MMON/Infrastructure/",
  "findings": [
    {
      "file": "C0MMON/Infrastructure/Persistence/Repositories.cs",
      "lines": "1-50",
      "relevance": "high",
      "summary": "Base repository pattern with MongoDB driver"
    }
  ],
  "recommendations": [
    "Follow existing Repository<T> pattern",
    "Use IMongoCollection<BsonDocument> for new collections"
  ],
  "blockers": []
}
```

---

**Phase 2 (OpenFixer)**: Update AGENTS.md files with explorer delegation instructions for each agent.
