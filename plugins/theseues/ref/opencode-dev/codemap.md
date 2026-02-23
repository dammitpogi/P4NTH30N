# opencode-dev/

## Responsibility

**OpenCode** is an AI-powered coding assistant that combines AI agents with traditional development tools (LSP, debuggers, Git) to help developers write, understand, and debug code. This is the main OpenCode repository containing the core application, SDKs, infrastructure, and GitHub Actions integration.

## System Overview

OpenCode is a modern AI coding assistant that:
- Combines AI agents with development tools (LSP, Git, debuggers)
- Provides real-time code intelligence through Language Server Protocol
- Supports multiple programming languages via LSP adapters
- Offers GitHub integration for issue tracking and PR management
- Enables plugin extensions for custom functionality
- Uses a session-based workflow for persistent context

## Architecture

### Core Components

| Component | Purpose | Key Files |
|-----------|---------|-----------|
| `packages/app/` | Main OpenCode desktop/web application | React UI, session management |
| `packages/sdk/` | SDK for plugin development | TypeScript SDK, language support |
| `packages/opencode/` | Core runtime | Agent orchestration, tool execution |
| `packages/plugin/` | Plugin system | Plugin loading, skill management |
| `github/` | GitHub Actions integration | Issue triage, PR workflows |
| `infra/` | Infrastructure as Code | SST configurations, deployments |
| `sdks/vscode/` | VS Code extension | Editor integration |

### Package Structure

```
packages/
├── app/           # Main OpenCode application (Electron/web)
├── console/       # Console UI components
├── containers/    # Container definitions
├── desktop/       # Desktop-specific code
├── docs/          # Documentation
├── enterprise/    # Enterprise features
├── extensions/    # VS Code extensions
├── function/      # Serverless functions
├── identity/      # Authentication/authorization
├── opencode/      # Core OpenCode runtime
├── plugin/        # Plugin system
├── script/        # Script utilities
├── sdk/           # Software Development Kit
├── slack/         # Slack integration
├── ui/            # Shared UI components
├── util/          # Utilities
└── web/          # Web application
```

## Design Patterns

### Agent System
- **Orchestrator**: Central coordination agent
- **Specialized Agents**: Explorer, Librarian, Oracle, Designer, Fixer
- **Agent Delegation**: Task-based subagent spawning
- **Permission System**: Granular tool access control

### Session Management
- **Persistent Sessions**: Maintains context across interactions
- **Background Tasks**: Async task execution with result streaming
- **Session State**: Cursor position, file edits, tool outputs

### Tool Integration
- **LSP Tools**: Definitions, references, diagnostics, rename
- **Git Integration**: Branch management, commit history
- **Search Tools**: Grep, AST-grep for code search
- **MCP Tools**: External service integration (web search, docs)

### Plugin Architecture
- **Skill System**: Custom capability definitions
- **MCP Servers**: Model Context Protocol connectors
- **Hook System**: Lifecycle event interception
- **Configuration**: JSON-based plugin configuration

## Flow

### User Request Flow

```
User Input
    ↓
Session Management (context, cursor)
    ↓
Orchestrator Agent (understands intent)
    ↓
Path Analysis (quality, speed, cost)
    ↓
Delegation (subagents as needed)
    ↓
Tool Execution (LSP, git, search)
    ↓
Result Synthesis
    ↓
Response Generation
    ↓
Session Update
```

### Plugin Loading Flow

```
OpenCode Startup
    ↓
Load Configuration (opencode.json)
    ↓
Discover Plugins (file://, npm:)
    ↓
Initialize Plugins
    ↓
Register Tools, Agents, Hooks
    ↓
Ready for User Input
```

### Tool Execution Flow

```
Tool Call Request
    ↓
Permission Check
    ↓
Tool Implementation
    ↓
Result Formatting
    ↓
Return to Agent
```

## Integration

### External Integrations

| Service | Integration Type | Purpose |
|---------|-----------------|---------|
| GitHub | MCP, Actions | Issue/PR management, CI |
| VS Code | Extension | Editor integration |
| LSP Servers | Protocol | Language intelligence |
| Web | HTTP API | Cloud features |

### Internal Dependencies

- **Bun**: Runtime and package manager
- **React**: UI framework
- **Drizzle**: Database ORM
- **SST**: Infrastructure as Code
- **TypeScript**: Language

## Development

### Building

```bash
# Install dependencies
bun install

# Build all packages
turbo build

# Build specific package
turbo build --filter=@opencodeai/app
```

### Testing

```bash
# Run all tests
bun test

# Run e2e tests
bun test packages/app/e2e

# Run specific test
bun test -t "test-name"
```

### Code Style

- **Formatter**: Prettier (inherited from root)
- **Linter**: Biome (project-specific)
- **TypeScript**: Strict mode enabled
- **Testing**: Avoid mocks, test actual implementation

## Repository Structure

| Directory | Purpose |
|-----------|---------|
| `github/` | GitHub Actions workflows, issue triage |
| `infra/` | SST infrastructure definitions |
| `packages/` | Core application packages |
| `sdks/` | SDKs for external integration |
| `specs/` | Protocol specifications |
| `script/` | Build and deployment scripts |

## Extension Points

### Adding New Tools
1. Implement tool in appropriate package
2. Register in plugin system
3. Configure agent permissions

### Creating Plugins
1. Create plugin package
2. Define skills and tools
3. Register in opencode.json

### Extending Agents
1. Add agent definition in packages/opencode
2. Configure permissions and tools
3. Add to agent delegation rules

## Key Files

| File | Purpose |
|------|---------|
| `package.json` | Monorepo root with turbo configuration |
| `turbo.json` | Turborepo build orchestration |
| `AGENTS.md` | Agent coding guidelines |
| `CONTRIBUTING.md` | Contribution guidelines |
| `STATS.md` | Usage statistics |
