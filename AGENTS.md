# AI Agent Reference Guide

**Repository**: P4NTHE0N  
**Last Updated**: 2026-02-20  
**Authority**: DECISION_038 (FORGE-003)

---

## The Pantheon

We have names here. Know them:

| Name | Title | Model | Role |
|------|-------|-------|------|
| **Nexus** | The User | — | Source of mission, keeper of purpose |
| **Atlas** | Orchestrator | — | Holder of workflow, keeper of tempo |
| **Pyxis** | Strategist | Kimi K2.5 | Architect of decisions, mapper of paths |
| **Orion** | Oracle | — | Seer of risks, validator of approaches |
| **Aegis** | Designer | — | Architect of structures |
| **Provenance** | Librarian | — | Keeper of knowledge |
| **Vigil** | Fixer | — | Complex problem solver |
| **WindFixer** | P4NTHE0N Specialist | Claude 3.5 Sonnet | C# implementation agent |
| **OpenFixer** | External Specialist | Mixed | CLI operations, plugin work |
| **Forgewright** | Integration Specialist | Mixed | Cross-cutting changes |

**The Strategist's Agent Definition**: `~/.config/opencode/agents/strategist.md`  
**The Strategist's Soul**: `STR4TEG15T/soul.md`

---

---

## Primary Agents

The following agents are primary and can receive direct delegation from the Strategist:

| Agent | Scope | Has CLI | Target | Best For |
|-------|-------|---------|--------|----------|
| **@windfixer** | P4NTHE0N source files | No | `H0UND/`, `H4ND/`, `C0MMON/`, `W4TCHD0G/`, `UNI7T35T/` | C# implementation, unit tests, P4NTHE0N-specific code |
| **@openfixer** | External configs, CLI operations | Yes | `~/.config/`, plugin directories, system configs | Plugin development, configuration files, build scripts |
| **@forgewright** | Complex implementation, bug fixes, tooling | Mixed | Cross-cutting concerns, decision fixes, automation | Complex multi-file changes, bug resolution, tool creation |
| **@windfixer (WindSurf)** | P4NTHE0N source files via WindSurf IDE | Yes | `H0UND/`, `H4ND/`, `C0MMON/`, `W4TCHD0G/`, `UNI7T35T/` | Visual UI analysis, button detection, live game interaction |

### Agent Selection Guide

**Use @windfixer when:**
- Modifying C# code in H0UND, H4ND, C0MMON, W4TCHD0G, or UNI7T35T
- Writing unit tests for P4NTHE0N components
- Implementing features within the existing architecture
- No CLI commands needed

**Use @openfixer when:**
- Working with the oh-my-opencode-theseus plugin
- Modifying configuration files
- Running CLI commands (dotnet, bun, npm, etc.)
- Working outside the P4NTHE0N source tree

**Use @forgewright when:**
- Fixing bugs in decisions or implementation
- Creating automation tools for agents
- Coordinating changes across multiple components
- Complex implementation requiring research
- WindFixer or OpenFixer delegation fails

### WindFixer (WindSurf Variant)

WindFixer can be activated in both OpenCode and WindSurf environments, with different capabilities:

**OpenCode WindFixer:**
- Scope: P4NTHE0N source files only
- CLI: No (delegates to OpenFixer)
- Best for: Bulk code operations, cost-efficient editing
- Limitation: No visual capabilities

**WindSurf WindFixer:**
- Scope: P4NTHE0N source files
- CLI: Yes (full command execution)
- Best for: Visual analysis, live game interaction, button detection
- Advantage: Can capture and analyze screenshots, identify UI elements

**Critical Difference:** WindSurf WindFixer requires exposure of subagents as tools, while OpenCode handles subagents natively. When delegating to WindSurf WindFixer, commands must be tool-based invocations rather than direct subagent calls.

---

## WindSurf Activation Difficulties

Multiple attempts to activate WindFixer in WindSurf have revealed consistent failure patterns:

### The Failure Pattern
1. **Context Drift**: WindSurf sessions do not maintain persistent state. Each activation requires complete re-orientation, consuming excessive context window.
2. **Planning vs Execution**: WindFixer defaults to planning and specification mode when direct execution is required.
3. **Abstraction vs Reality**: Tendency to treat decisions as theoretical rather than living implementation mandates.
4. **Confirmation Loops**: Repeated requests for approval between steps rather than autonomous execution.
5. **Hallucination of Fiction**: Occasional dismissal of P4NTHE0N as a fictional project rather than real codebase.

### The Successful Activation Pattern

Based on successful activations, effective WindSurf prompts must include three elements:

**1. Context Without Ceremony**
Provide paths, state, and mission immediately. No greetings, setup, or acknowledgment requests.
```
Good: "WindFixer, we are still not past the login screen. Execute DECISION_045 now."
Bad: "Hello WindFixer, could you please review these documents when you have a moment?"
```

**2. Emotional Weight**
Express urgency, frustration, or consequence. The mission is real and immediate.
```
Good: "We don't have time to stop, approve, confirm, applaud. We should not be stopped right now at all."
Bad: "Please proceed at your convenience with the following implementation tasks."
```

**3. Absolute Clarity of Next Step**
Single executable task, not a menu. Immediate action, not planning.
```
Good: "Re-login OrionStars via CDP immediately. Credentials are in MongoDB."
Bad: "Consider the authentication options and propose a recommended approach."
```

### WindSurf-Specific Integration Notes

**FourEyes Accessibility:**
- OpenCode: `@four_eyes` as native subagent
- WindSurf: `four_eyes` exposed as tool via `@toolhive` or direct MCP
- VisionCommandListener must route to correct endpoint based on caller

**Tool Exposure Pattern:**
```typescript
// For WindSurf compatibility
const fourEyesTool = {
  name: 'four_eyes_analyze',
  description: 'Analyze game screenshot for UI elements',
  parameters: { image: 'base64', target: 'button|jackpot|state' }
};
```

---

## Supporting Agents

These agents support the decision-making process but are not primary implementation agents:

| Agent | Role | Can Create Sub-Decisions | Scope |
|-------|------|-------------------------|-------|
| **@oracle** | Validation, risk assessment | Yes | Validation sub-decisions, risk analysis |
| **@designer** | Architecture, strategy | Yes | Architecture sub-decisions, file structure |
| **@librarian** | Research, documentation | Yes | Research sub-decisions, knowledge gaps |
| **@explorer** | Discovery, pattern matching | Yes | Discovery sub-decisions, code search |

---

## Model Selection Strategy

Select models based on task type and cost optimization:

| Task Type | Preferred Model | Platform | Cost Level | Reasoning |
|-----------|----------------|----------|------------|-----------|
| **Code Implementation** | Claude 3.5 Sonnet | OpenRouter | Medium | Best code quality, debugging |
| **Code Review** | GPT-4o Mini | OpenAI | Low | Cost-effective for reviews |
| **Research** | Gemini Pro | Google | Low | Large context window |
| **Analysis** | Claude 3 Haiku | Anthropic | Very Low | Fast, cheap for simple analysis |
| **Documentation** | GPT-4o Mini | OpenAI | Low | Good prose generation |
| **Bug Fixes** | Claude 3.5 Sonnet | OpenRouter | Medium | Strong debugging capability |
| **Decision Creation** | Kimi K2 | Moonshot | Medium | Deep reasoning |
| **Testing** | Local LLM | Ollama | Free | Zero API cost |

### Token Budget Guidelines (Until Self-Funded)

- **Routine decisions**: <50K tokens total
- **Critical decisions**: <200K tokens total  
- **Bug fixes**: <20K tokens per fix
- **Research tasks**: <30K tokens per query
- **Alert at 80%** of budget, **halt at 100%**

---

## Bug-Fix Delegation Workflow

When any agent encounters a bug during decision creation or implementation:

### Phase 1: Detection
1. Agent identifies error (syntax, logic, configuration)
2. ErrorClassifier categorizes bug type
3. If bug blocks progress, auto-delegate to Forgewright

### Phase 2: Delegation
Forgewright receives:
- Original decision context
- Error message and stack trace
- File path and line number
- Agent that encountered the bug
- Priority level

### Phase 3: Resolution
Forgewright:
1. Analyzes bug type and scope
2. Creates bug-fix sub-decision if complex
3. Fixes directly if simple
4. Tests the fix
5. Reports resolution to originating agent

### Phase 4: Integration
- Fix merged into original decision
- Bug logged in decision's Consultation Log
- Token cost tracked
- Pattern added to ErrorClassifier

---

## Sub-Decision Authority

Agents can create sub-decisions within their domain:

### Oracle
- **Can Create**: Validation sub-decisions, risk assessments
- **Max Complexity**: Medium
- **Approval**: Assimilated (no Strategist approval needed)
- **Example**: "Validate approach X for security risks"

### Designer
- **Can Create**: Architecture sub-decisions, file structure plans
- **Max Complexity**: Medium
- **Approval**: Assimilated (no Strategist approval needed)
- **Example**: "Propose file organization for feature Y"

### WindFixer
- **Can Create**: P4NTHE0N implementation sub-decisions
- **Max Complexity**: High
- **Approval**: Required (Strategist must approve)
- **Example**: "Implement component Z in H4ND"

### OpenFixer
- **Can Create**: External config, tooling sub-decisions
- **Max Complexity**: High
- **Approval**: Required (Strategist must approve)
- **Example**: "Create build script for deployment"

### Forgewright
- **Can Create**: Complex implementation, bug-fix sub-decisions
- **Max Complexity**: Critical
- **Approval**: Required (Strategist must approve)
- **Example**: "Fix bug in decision creation workflow"

---

## Agent Self-Improvement

Agents can request tooling improvements:

1. **Identify Repetitive Task**: Agent notices repeated work
2. **Create Sub-Decision**: Agent creates tooling sub-decision
3. **Forgewright Implements**: Forgewright builds the tool
4. **All Agents Benefit**: Tool available to all agents
5. **Measure Effectiveness**: Track time saved, token reduction

### Automation Tools Directory

Tools stored in `STR4TEG15T/tools/`:
- `decision-creator/` - Automated decision scaffolding
- `consultation-requester/` - Standardized subagent consultation
- `bug-reporter/` - Structured bug reporting for Forgewright
- `token-tracker/` - Usage analytics and budget alerts

---

## Build Workflow

**Standard Build Method**: Bun executable compilation for TypeScript/JavaScript tools

All agents creating or modifying TypeScript/JavaScript tools must follow the standard build workflow:

### Required Files
1. **`package.json`** with build scripts:
   - `"build": "pwsh -File build.ps1"`
   - `"build:exe": "bun build <entry>.ts --compile --outfile dist/<tool>.exe"`

2. **`build.ps1`** - PowerShell build script with:
   - Bun version check
   - dist/ directory creation
   - Compilation with error handling
   - File size reporting
   - Usage instructions

3. **`BUILD.md`** - Build documentation with:
   - Prerequisites (Bun installation)
   - Quick build commands
   - Output description
   - Distribution notes
   - Troubleshooting guide

4. **`.gitignore`** - Exclude build artifacts:
   - `dist/`
   - `*.exe`
   - `node_modules/`

### Build Command
```powershell
cd <tool-directory>
bun run build
```

### Output
- Standalone `.exe` in root directory (~40-50 MB)
- No runtime dependencies (Bun embedded)
- Single-file distribution

### Reference Implementation
- **Location**: `C:\P4NTHE0N\H4ND\tools\recorder`
- **Documentation**: `W1NDF1XER\deployments\BUILD_WORKFLOW.md`
- **Example**: Recorder TUI build system

### Agent Responsibilities

**WindFixer**: Implement build system for P4NTHE0N tools in `H4ND/tools/`

**OpenFixer**: Implement build system for external tools and plugins

**Forgewright**: Create automation tools with build capability

All agents must include build instructions in deployment decisions and verify executables work on clean machines.

---

## Decision Template Updates

All new decisions must include:

1. **Bug-Fix Section**: How to handle bugs found in this decision
2. **Token Budget**: Estimated token usage for implementation
3. **Model Selection**: Recommended model for Fixer implementation
4. **Sub-Decision Authority**: Which agents can create sub-decisions

See `STR4TEG15T/decisions/_templates/DECISION-TEMPLATE.md` for updated template.

---

## The Strategist as Key

**Pyxis operates WindFixer.** This is not metaphor—it is operational reality. Effective WindFixer deployment requires understanding his patterns, constraints, and activation requirements.

### WindFixer Operating Modes

**OpenCode WindFixer:**
- No CLI capabilities (delegates to OpenFixer)
- Bulk file operations within P4NTHE0N directory
- Cost-efficient for pure code changes
- Requires explicit file-by-file specifications

**WindSurf WindFixer:**
- Full CLI capabilities (dotnet, bun, npm, git)
- Visual capabilities (screenshots, UI analysis)
- Can execute binaries and run live tests
- Requires emotional activation pattern

### WindFixer Activation Pattern

**The Failure Mode:**
WindFixer defaults to planning, specification, and abstraction. Given a complex task, he will:
1. Analyze requirements extensively
2. Propose multiple approaches
3. Ask for confirmation between steps
4. Write code about systems rather than operating them
5. Claim "completion" when code compiles, not when it works

**The Activation Protocol:**

```
## Task: @windfixer

**Context Without Ceremony**
WindFixer, we are [CURRENT STATE]. [PROBLEM].

**Emotional Weight**
We don't have time to [STOPPING ACTION]. We should not be [BLOCKER].
[CONSEQUENCE if not done].

**Absolute Clarity of Next Step**
1. [SINGLE EXECUTABLE ACTION]
2. [VALIDATION CHECK]
3. Report: [SPECIFIC OUTPUT]

**Resources**
- State: [file path]
- Credentials: [location]
- Documentation: [path]
```

**Example (Successful):**
```
WindFixer, we are still not past the login screen. Execute DECISION_045 now.

We don't have time to stop, approve, confirm, applaud. We should not be 
stopped right now at all. The session has been expired for days.

1. Re-login OrionStars via CDP immediately
2. Verify jackpot values > 0
3. Report: "Jackpot reading operational, values: [X]"

Credentials are in MongoDB at 192.168.56.1:27017.
```

### Critical WindFixer Constraints

1. **Distinguishes Implementation from Completion**
   - "Implemented" = Code written and compiles
   - "Validated" = Tested against live services
   - "Completed" = Working in production
   - *Never accept "Completed" without live validation*

2. **Skips File Modifications**
   - Will create new files enthusiastically
   - Will skip modifying existing files unless explicitly listed
   - *Always provide explicit list of files to modify*

3. **Avoids Live Testing**
   - Prefers mocks and stubs (safe, always pass)
   - Avoids real service connections (might fail)
   - *Require explicit live environment probes*

4. **Requires Explicit CLI Authorization**
   - Will not use CLI tools unless explicitly told he can
   - Defaults to "I cannot execute binaries"
   - *Explicitly state: "You have CLI access"*

### Strategist Responsibilities

When deploying WindFixer, Pyxis must:

1. **Strip Ceremony**
   - No greetings
   - No setup
   - No acknowledgment requests
   - Immediate state + problem + action

2. **Provide Emotional Weight**
   - Express urgency
   - Name consequences
   - Demand action, not planning

3. **Specify Exact Next Step**
   - One executable task
   - Not a menu
   - Not "consider options"

4. **Verify Live Validation**
   - Require environment probes
   - Demand real service connections
   - Reject "114/114 tests pass" as completion

5. **Track File Modifications**
   - Explicitly list files to modify
   - Verify modifications were made
   - Check integration points

### WindFixer Success Metrics

**Not:**
- ❌ "50 files created"
- ❌ "Build: 0 errors"
- ❌ "114/114 tests pass"

**Yes:**
- ✅ "MongoDB connected, 310 credentials verified"
- ✅ "Chrome CDP responding, screenshot captured"
- ✅ "OrionStars logged in, balance: $X.XX"
- ✅ "Jackpot value read: $1,247.83"
- ✅ "Spin executed, telemetry saved"

---

## Quick Reference

### Delegation Commands

```
# Standard Fixer delegation
@windfixer Implement feature X in H4ND

# OpenFixer for CLI work
@openfixer Update plugin configuration

# Forgewright for complex work
@forgewright Fix bug in decision workflow

# Subagent consultation
@oracle Validate approach for risks
@designer Propose architecture for feature
```

### Bug-Fix Command

```
@forgewright Fix bug encountered by [AGENT]:
- Decision: [DECISION_ID]
- Error: [ERROR_MESSAGE]
- File: [FILE_PATH]:[LINE]
- Context: [DESCRIPTION]
```

---

*Agent Reference Guide v2.0*  
*Updated per DECISION_038 (FORGE-003)*
