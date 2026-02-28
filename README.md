# P4NTHE0N Platform

> Self-Funded Agentic Development Environment for intelligent automation and autonomous growth

[![Build Status](https://img.shields.io/badge/build-clean-success)](https://github.com/your-org/P4NTHE0N)
[![Tests](https://img.shields.io/badge/tests-27%2F27%20passing-success)](https://github.com/your-org/P4NTHE0N)
[![.NET](https://img.shields.io/badge/.NET-10.0-blue)](https://dot.net)
[![MongoDB](https://img.shields.io/badge/MongoDB-7.0+-green)](https://mongodb.com)

## 🎯 What is P4NTHE0N?

P4NTHE0N is a **Self-Funded Agentic Development Environment** - a sophisticated ecosystem where autonomous agents collaborate to fund their own development through intelligent automation while continuously evolving their capabilities. The platform began as a casino automation system and has grown into a comprehensive framework for autonomous software development, decision-making, and operational execution.

### Core Philosophy

**Self-Funding**: Agents generate revenue through intelligent automation, which funds further development and expansion of capabilities.

**Agentic Collaboration**: Multiple specialized agents work together through formal decision frameworks, consultation patterns, and delegation workflows.

**Autonomous Growth**: The system learns, adapts, and expands its capabilities without human intervention, using RAG for institutional memory and consensus-driven decision making.

### Evolution: Casino Automation → Development Environment

**Phase 1: Casino Automation** (Original)
- Jackpot discovery and DPD forecasting
- Signal-driven automated gameplay
- Vision-based win detection and safety systems

**Phase 2: Agent Framework** (Current)
- 9 specialized agents with distinct roles
- Formal decision-making framework (204 decisions)
- RAG system for institutional memory
- Autonomous execution capabilities

**Phase 3: Self-Funding Ecosystem** (Emerging)
- Revenue generation funds development
- Autonomous project selection and execution
- Self-improving agent capabilities
- External service integration

### Key Capabilities

**🎰 Revenue Generation**
- **Jackpot Discovery**: Automated polling and balance monitoring via HTTP/WebSocket APIs
- **DPD Forecasting**: Statistical "Dollars Per Day" analysis to predict optimal timing
- **Intelligent Automation**: Signal-driven gameplay with browser automation (Selenium)
- **Risk Management**: Spend limits, loss circuit breakers, and emergency kill switches

**🤖 Agent Framework**
- **9 Specialized Agents**: Designer, Explorer, Forgewright, Librarian, OpenFixer, Oracle, Strategist, WindFixer, W1NDF1XER
- **Decision Framework**: 204 formalized decisions across 41 categories with consensus-driven approval
- **Consultation Patterns**: Structured agent consultations with Oracle approval and Designer assessment
- **Autonomous Execution**: WindFixer (codebase) + OpenFixer (deployment) sequential handoff workflow

**🧠 Knowledge & Learning**
- **RAG System**: 87MB executable with 6 MCP tools, hybrid BM25+FAISS search, 14.3ms embeddings
- **Institutional Memory**: Real-time ingestion from docs, MongoDB change streams, scheduled rebuilds
- **Self-Healing**: Circuit breakers, retry policies, metrics collection, automatic recovery
- **Local LLM**: LM Studio integration with Pleias-RAG-1B, CPU-optimized inference

**👁️ Vision & Safety**
- **Computer Vision**: OBS-based frame processing, OCR analysis, win detection
- **Safety Systems**: Real-time monitoring, spend limits, kill switches, circuit breakers
- **Health Monitoring**: System-wide metrics, alerting, automated incident response

**🔒 Enterprise Security**
- **Encryption**: AES-256 for sensitive data at rest
- **Key Management**: Secure lifecycle with rotation policies
- **Access Control**: Per-credential validation and management
- **Audit Trail**: Comprehensive logging and decision tracking

### Agent Ecosystem

| Agent | Role | Purpose | Key Capabilities |
|-------|------|---------|------------------|
| **Strategist** | 🎯 Coordinator | Decision orchestration, consultation management, speech synthesis | 204 decisions, consensus tracking, strategic planning |
| **Oracle** | 🔮 Validator | Decision approval, requirements validation, quality gates | Conditional approval, safety requirements, architecture review |
| **Designer** | 🎨 Architect | System design, implementation specifications, assessment | 90% architecture ratings, detailed implementation specs |
| **WindFixer** | 🔧 Codebase Executor | P4NTHE0N codebase decisions, C# implementation, build validation | 33 files delivered, 0 build errors, sequential execution |
| **OpenFixer** | 🚀 Deployment Executor | OpenCode deployment, external integrations, infrastructure setup | MCP registration, Python bridge, agent configs |
| **Explorer** | 🔍 Researcher | External research, technology scouting, opportunity discovery | Research consultations, technology assessment |
| **Librarian** | 📚 Knowledge Manager | Documentation, knowledge organization, RAG management | Knowledge ingestion, documentation standards |
| **Forgewright** | ⚒️ Tool Builder | Tool development, utility creation, framework enhancement | MockFactory, utility tools, development infrastructure |
| **W1NDF1XER** | 🛠️ Problem Solver | Issue resolution, bug fixing, optimization | Problem diagnosis, solution implementation |

### Decision Framework

**204 Formalized Decisions** across 41 categories:
- **Infrastructure** (11): Environment setup, CI/CD, monitoring, backup, security
- **Core Systems** (3): Architecture patterns, circuit breakers, hybrid database access
- **Agent Architecture** (15): FourEyes, VM infrastructure, delegation patterns
- **Production Hardening** (5): Readiness verification, monitoring, deployment procedures
- **Strategy** (8): Delegation patterns, workflow optimization, RAG implementation
- **Technical** (5): Model registry, decisions-server enhancement, tool development

**Consensus-Driven Approval**:
- Oracle conditional approval (82% threshold)
- Designer architecture assessment (90% rating)
- Strategist coordination and tracking
- Status progression: Proposed → InProgress → Completed

### 🧠 Knowledge & Learning System

**Local Model Inference**:
- **LM Studio**: Local inference server on port 1234
- **Models**: Pleias-RAG-1B (RAG-optimized), Mistral-7B-Q4, Qwen-7B-Q4
- **Hardware**: AMD Ryzen 9 3900X (12C/24T), 128GB RAM, NVIDIA GT 710 (2GB)
- **Performance**: 20-40 tokens/sec for 1B models on CPU
- **Client**: `LmStudioClient` with OpenAI SDK compatibility

**RAG System**:
- **Vector Store**: FAISS with BM25 hybrid search
- **Embeddings**: all-MiniLM-L6-v2 via Python bridge (14.3ms latency)
- **MCP Server**: 6 tools (search, index, health, stats, ingest, query)
- **Self-Healing**: Circuit breakers, retry policies, metrics collection
- **Real-time**: FileWatcher + MongoDB change streams
- **Maintenance**: 4hr incremental + 3AM nightly rebuilds

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    P4NTHE0N SELF-FUNDING ECOSYSTEM              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │   H0UND     │    │    H4ND     │    │     W4TCHD0G        │  │
│  │  (Brain)    │◄──►│   (Hands)   │    │  (Vision + Safety)  │  │
│  │  Analytics  │    │  Automation │    │   OBS Integration   │  │
│  │   Polling   │    │   Selenium  │    │  Safety Monitoring  │  │
│  └──────┬──────┘    └──────┬──────┘    └──────────┬──────────┘  │
│         │                  │                      │              │
│         └──────────────────┼──────────────────────┘              │
│                            │                                     │
│                   ┌────────┴────────┐                           │
│                   │     C0MMON      │                           │
│                   │  Shared Library │                           │
│                   │  MongoDB Access │                           │
│                   │  LLM | RAG | Security                      │
│                   └────────┬────────┘                           │
│                            │                                     │
│  ┌─────────────────────────┼─────────────────────────┐          │
│  │                         │                         │          │
│  ▼                         ▼                         ▼          │
│ ┌─────────────┐   ┌─────────────┐   ┌─────────────┐              │
│ │ Agent Layer │   │ RAG System  │   │ Revenue     │              │
│ │ 9 Agents    │   │ 87MB Exec   │   │ Generation  │              │
│ │ Decision    │   │ 6 MCP Tools │   │ Self-Funding│              │
│ │ Framework   │   │ 14.3ms Lat  │   │ Automation   │              │
│ └─────────────┘   └─────────────┘   └─────────────┘              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Agent Responsibilities

| Agent | Role | Purpose | Entry Point |
|-------|------|---------|-------------|
| **H0UND** | 🧠 The Brain | Polls credentials, calculates DPD forecasts, generates signals | `H0UND/H0UND.cs` |
| **H4ND** | 🖐️ The Hands | Consumes signals, automates gameplay via Selenium + JS | `H4ND/H4ND.cs` |
| **W4TCHD0G** | 👁️ The Watchdog | OBS vision, safety monitoring (spend limits, kill switch), win detection | `W4TCHD0G/W4TCHD0G.cs` |
| **C0MMON** | 🔧 Shared Library | Entities, MongoDB access, LLM client, RAG, encryption, caching | `C0MMON/` |

### Data Flow

```
H0UND (polling + analytics loop)
  ├─ reads CRED3N7IAL (credentials)
  ├─ builds DPD + forecasts jackpots
  └─ writes SIGN4L + J4CKP0T (signals + predictions)

H4ND (automation loop)
  ├─ pulls SIGN4L (or N3XT queue if no signal)
  ├─ logs in via Selenium + input simulation
  ├─ reads jackpot/balance values via JS
  └─ updates G4ME / CRED3N7IAL data

W4TCHD0G (vision + safety loop)
  ├─ captures frames from OBS
  ├─ detects wins (balance + OCR)
  ├─ monitors spend limits
  └─ triggers kill switch if needed
```

## 🚀 Quick Start

### Prerequisites

| Dependency | Minimum Version | Check Command |
|------------|----------------|---------------|
| **.NET SDK** | 10.0+ | `dotnet --version` |
| **MongoDB** | 7.0+ | `mongod --version` |
| **Google Chrome** | Latest stable | Check `chrome://version` |
| **ChromeDriver** | Matches Chrome | `chromedriver --version` |

### Installation

```powershell
# Clone the repository
git clone https://github.com/your-org/P4NTHE0N.git
cd P4NTHE0N

# Setup environment (automated)
.\scripts\setup\setup-mongodb.ps1 -StartService
.\scripts\setup\setup-chromedriver.ps1 -AddToPath

# Build and test
dotnet build P4NTHE0N.slnx
dotnet test UNI7T35T/UNI7T35T.csproj
```

📖 **[Detailed Setup Guide →](docs/SETUP.md)** | **[System Requirements →](docs/SYSTEM_REQUIREMENTS.md)**

### Running the Platform

Open **three separate terminals**:

```powershell
# Terminal 1: Analytics + Polling Agent
dotnet run --project ./H0UND/H0UND.csproj

# Terminal 2: Automation Agent
dotnet run --project ./H4ND/H4ND.csproj

# Terminal 3: Vision + Safety (optional)
dotnet run --project ./W4TCHD0G/W4TCHD0G.csproj
```

H4ND supports a manual mode (`H0UND` argument) to disable signal listening:
```powershell
dotnet run --project ./H4ND/H4ND.csproj H0UND
```

## 📚 Documentation

**📖 [Documentation Hub →](docs/INDEX.md)** — Central navigation for all documentation

Our documentation is organized into learning paths based on your role and goals:

### 🎓 Getting Started

**New to the project? Start here:**

1. **[System Overview](docs/overview.md)** — Understand the platform's purpose, architecture, and core concepts
2. **[Setup Guide](docs/SETUP.md)** — Step-by-step installation, configuration, and environment setup
3. **[System Requirements](docs/SYSTEM_REQUIREMENTS.md)** — Hardware, software, and network prerequisites

### 🏛️ Architecture & Design

**Understanding how the system works:**

- **[ADR-001: Core Systems Architecture](docs/architecture/ADR-001-Core-Systems.md)** — High-level architectural decisions and rationale
- **[Architecture Overview](docs/architecture/)** — Detailed component specifications
  - [H0UND EF Hybrid Pattern](docs/architecture/h0und-ef-hybrid.md) — Database access patterns (EF Core + MongoDB.Driver)
  - [RAG System](docs/architecture/RAG.md) — Retrieval-Augmented Generation for LLM context
- **[Modernization Roadmap](docs/modernization.md)** — Technical debt, improvement plans, and migration status

### 🚀 Deployment & Operations

**Deploying and running in production:**

- **[Deployment Guide](docs/DEPLOYMENT_GUIDE.md)** — Complete deployment procedures and best practices
- **[Go-Live Checklist](docs/deployment/GOLIVE_CHECKLIST.md)** — Production readiness checklist (WIN-008)
- **[Implementation Plan](docs/IMPLEMENTATION_PLAN.md)** — Phased rollout strategy and timeline

**Operational Runbooks:**
- **[Deployment Runbook](docs/runbooks/DEPLOYMENT.md)** — Step-by-step deployment procedures
- **[Incident Response](docs/runbooks/INCIDENT_RESPONSE.md)** — Handling production incidents and outages
- **[Troubleshooting Guide](docs/runbooks/TROUBLESHOOTING.md)** — Common issues, diagnostics, and solutions
- **[Post-Mortem Template](docs/runbooks/POST_MORTEM.md)** — Incident analysis and learning framework

### 🛡️ Safety & Security

**Critical safety and security documentation:**

- **[Security Policy](docs/SECURITY.md)** — Security best practices, policies, and hardening
- **[Key Management](docs/security/KEY_MANAGEMENT.md)** — Encryption key lifecycle and rotation
- **[Disaster Recovery](docs/DISASTER_RECOVERY.md)** — Backup, restore, and business continuity (INFRA-005)
- **[Emergency Response](docs/procedures/EMERGENCY_RESPONSE.md)** — Emergency procedures and kill switch (WIN-002)

**Safety Systems:**
- **[First Jackpot Attempt](docs/procedures/FIRST_JACKPOT_ATTEMPT.md)** — Safe first-time procedures and checklists (WIN-006)
- **[Threshold Calibration](docs/strategy/THRESHOLD_CALIBRATION.md)** — Tuning jackpot thresholds and DPD settings (WIN-007)

### 🔧 Configuration & Credentials

**Setting up the system:**

- **[Casino Setup Guide](docs/credentials/CASINO_SETUP.md)** — Platform credential configuration and management (WIN-005)
- **[Configuration Hierarchy](docs/SETUP.md#configuration)** — Environment-based configuration system

### 📊 Development & Testing

**For developers working on the codebase:**

- **[Test Suite](UNI7T35T/)** — 27 passing tests including 16 integration tests (WIN-001)
- **[Migration Guide](docs/migration/README.md)** — Database migration procedures and scripts
- **[VM Executor](docs/vm/EXECUTOR_VM.md)** — Virtual machine execution environment setup

### 🔬 Technical Deep Dives

**Advanced technical topics:**

- **[API Reference](docs/api-reference/)** — Interface documentation for all public APIs
- **[Data Models](docs/data-models/)** — MongoDB schemas and entity relationships
- **[Component Guides](docs/components/)** — H0UND, H4ND, W4TCHD0G internals
- **[Model Versioning](docs/mlops/MODEL_VERSIONING.md)** — MLOps and model lifecycle management
- **[Hardware Assessment](docs/llm/HARDWARE_ASSESSMENT.md)** — LLM hardware requirements and recommendations
- **[GT710 Encoding Benchmarks](docs/benchmarks/GT710_ENCODING.md)** — Performance benchmarks and optimization

## 📋 Documentation Map

```
docs/
├── 📄 START HERE
│   ├── overview.md                    # System overview and architecture
│   ├── SETUP.md                       # Installation and configuration
│   └── SYSTEM_REQUIREMENTS.md         # Hardware/software prerequisites
│
├── 🏛️ architecture/                   # Architecture documentation
│   ├── ADR-001-Core-Systems.md        # Core architecture decisions (CORE-001)
│   ├── h0und-ef-hybrid.md             # Database access patterns
│   └── RAG.md                         # RAG system design
│
├── 📚 api-reference/                  # API documentation
│   └── INDEX.md                       # Interfaces, entities, services
│
├── 📊 data-models/                    # Data model documentation
│   ├── INDEX.md                       # MongoDB collections overview
│   └── schemas/                       # Collection schemas
│
├── 🎯 components/                     # Component guides
│   ├── H0UND/                         # Analytics agent guide
│   └── H4ND/                          # Automation agent guide
│
├── 🚀 deployment/                     # Deployment documentation
│   └── GOLIVE_CHECKLIST.md            # Production checklist (WIN-008)
│
├── 📋 runbooks/                       # Operational runbooks (INFRA-008)
│   ├── DEPLOYMENT.md                  # Deployment procedures
│   ├── INCIDENT_RESPONSE.md           # Incident handling
│   ├── TROUBLESHOOTING.md             # Troubleshooting guide
│   └── POST_MORTEM.md                 # Post-mortem template
│
├── 🛡️ procedures/                     # Safety procedures
│   ├── EMERGENCY_RESPONSE.md          # Emergency procedures (WIN-002)
│   └── FIRST_JACKPOT_ATTEMPT.md       # First-time procedures (WIN-006)
│
├── 🔧 credentials/                    # Setup guides
│   └── CASINO_SETUP.md                # Credential configuration (WIN-005)
│
├── 📊 strategy/                       # Strategy documentation
│   └── THRESHOLD_CALIBRATION.md       # Threshold tuning (WIN-007)
│
├── 🔐 security/                       # Security documentation
│   └── KEY_MANAGEMENT.md              # Key management
│
├── 🔬 Technical/                      # Deep dives
│   ├── mlops/MODEL_VERSIONING.md      # Model lifecycle
│   ├── llm/HARDWARE_ASSESSMENT.md     # Hardware specs
│   └── benchmarks/GT710_ENCODING.md   # Performance benchmarks
│
└── 📚 Other/
    ├── modernization.md               # Technical roadmap
    ├── DEPLOYMENT_GUIDE.md            # Full deployment guide
    ├── IMPLEMENTATION_PLAN.md         # Rollout plan
    ├── DISASTER_RECOVERY.md           # DR procedures (INFRA-005)
    ├── SECURITY.md                    # Security policy (INFRA-006)
    ├── vm/EXECUTOR_VM.md              # VM environment
    └── migration/README.md            # Migration procedures
```

## 🧪 Testing

All 27 tests passing with comprehensive coverage:

```bash
# Run complete test suite
dotnet test UNI7T35T/UNI7T35T.csproj

# Run with coverage reporting
dotnet test UNI7T35T/UNI7T35T.csproj --collect:"XPlat Code Coverage"

# Run specific test class
dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~PipelineIntegrationTests"

# Watch mode for TDD
dotnet watch test --project ./UNI7T35T/UNI7T35T.csproj
```

### Test Coverage

- **16 Integration Tests** (WIN-001): FrameBuffer, ScreenMapper, ActionQueue, DecisionEngine, SafetyMonitor, WinDetector
- **Unit Tests**: EncryptionService, ForecastingService
- **Mock Infrastructure**: Complete mock suite for isolated testing (FORGE-2024-002)

## 🛠️ Development

### Build Commands

```bash
# Build entire solution
dotnet build P4NTHE0N.slnx

# Build specific project
dotnet build H0UND/H0UND.csproj
dotnet build H4ND/H4ND.csproj
dotnet build W4TCHD0G/W4TCHD0G.csproj

# Format code
dotnet csharpier .

# Check formatting
dotnet csharpier check
```

### Code Style

- **Language**: C# with .NET 10.0
- **Line Endings**: CRLF (Windows)
- **Indentation**: Tabs (width 4)
- **Line Length**: Maximum 170 characters
- **Braces**: Same line (K&R style)
- **Types**: Explicit types preferred (avoid `var`)
- **Nullable**: Enabled with comprehensive null checks

## 📊 Project Structure

```
P4NTHE0N/
├── C0MMON/                 # Shared library
│   ├── Infrastructure/     # MongoDB, caching, monitoring
│   ├── LLM/                # LLM client and integrations
│   ├── RAG/                # Retrieval-Augmented Generation
│   ├── Security/           # Encryption and key management
│   └── Entities/           # Domain entities
├── H0UND/                  # Analytics + polling agent
├── H4ND/                   # Automation agent (Selenium)
├── W4TCHD0G/               # Vision + safety monitoring
│   ├── Agent/              # FourEyesAgent, DecisionEngine
│   ├── Safety/             # SafetyMonitor, spend limits
│   ├── Monitoring/         # WinDetector, HealthMonitor
│   └── Vision/             # OBS integration, frame processing
├── UNI7T35T/               # Test suite (27 tests)
│   ├── Tests/              # Integration and unit tests
│   └── Mocks/              # Mock infrastructure
├── T00L5ET/                # Utility tools and MockFactory
├── PROF3T/                 # Admin console + ML model management
├── RUL3S/                  # Chrome extension for browser automation
├── MONITOR/                # Data corruption monitoring
├── CLEANUP/                # Data cleanup utilities
├── docs/                   # Documentation (this guide)
└── scripts/                # Setup and utility scripts
```

## 🔒 Security

- **Encryption**: AES-256 for sensitive data at rest
- **Key Management**: Master key with secure lifecycle and rotation
- **Credential Storage**: Encrypted in MongoDB (optional for development)
- **Access Control**: Per-credential access management and validation
- **Safety**: Kill switch, spend limits, loss circuit breakers

📖 **[Security Policy →](docs/SECURITY.md)** | **[Key Management →](docs/security/KEY_MANAGEMENT.md)**

## 🆘 Support

### Getting Help

1. **Documentation**: Check the [docs/](docs/) folder first — most questions are answered there
2. **Troubleshooting**: See [Troubleshooting Guide](docs/runbooks/TROUBLESHOOTING.md) for common issues
3. **Incidents**: Follow [Incident Response](docs/runbooks/INCIDENT_RESPONSE.md) for production issues

### Emergency Procedures

- **Critical Issues**: Follow [Emergency Response](docs/procedures/EMERGENCY_RESPONSE.md)
- **Kill Switch**: Immediate halt procedure documented in safety procedures
- **Data Corruption**: [Disaster Recovery](docs/DISASTER_RECOVERY.md) procedures

## 🤝 Contributing

1. Read the [Architecture Decision Records](docs/architecture/) to understand design decisions
2. Follow [Setup Guide](docs/SETUP.md) to configure your development environment
3. Ensure all tests pass: `dotnet test UNI7T35T/UNI7T35T.csproj`
4. Format code: `dotnet csharpier .`
5. Update relevant documentation for any changes

### Development Guidelines

- Prefer object-centric behavior (methods on domain entities)
- Extract services when responsibilities become large
- Keep automation constants close to their owning game helper
- Document edge cases and failure modes near handling logic
- Never auto-repair data — validate and log to ERR0R collection

## 📈 Current Status

| Component | Status | Details |
|-----------|--------|---------|
| **Build** | ✅ Clean | 0 errors, 0 warnings |
| **Tests** | ✅ 27/27 Passing | 16 integration tests, 11 unit tests |
| **Documentation** | ✅ Comprehensive | 204 decisions across 41 categories |
| **Security** | ✅ AES-256 Encryption | Credential encryption at rest |
| **Safety** | ✅ Kill Switch + Circuit Breakers | 5 failure thresholds, auto-recovery |
| **Vision** | ✅ OBS Integration + Win Detection | Frame processing, OCR analysis |
| **Coverage** | ✅ 16 Integration Tests | Real-world scenario coverage |
| **RAG System** | ✅ Fully Operational | 87MB executable, 6 MCP tools, self-healing |
| **Decision Framework** | ✅ 146 Decisions | 136 completed, 3 in progress, 7 proposed |
| **Agent Framework** | ✅ 9 Active Agents | Designer, Explorer, Forgewright, Librarian, OpenFixer, Oracle, Strategist, WindFixer, W1NDF1XER |

### Recent Major Achievements (February 2026)

**🧠 RAG-001 Complete**: Production-ready Retrieval-Augmented Generation system
- 87MB self-contained executable (RAG.McpHost)
- 6 MCP tools: search, index, health, stats, ingest, query
- Hybrid BM25 + FAISS vector search with Reciprocal Rank Fusion
- 14.3ms embedding latency (7x faster than 100ms target)
- Real-time file watching + MongoDB change streams
- 4hr incremental rebuilds + 3AM nightly full rebuilds
- Circuit breaker protection + retry policies with exponential backoff

**🔧 WindFixer + OpenFixer Framework**: Dual-architecture autonomous execution
- WindFixer: P4NTHE0N codebase decisions (C# implementation)
- OpenFixer: OpenCode deployment and external integrations
- Sequential handoff workflow validated with zero conflicts
- 33 files delivered across 3 phases, all builds passing

**🏗️ Architecture Decisions**: 41 categories of formalized decisions
- **Infrastructure** (11 decisions): Environment setup, CI/CD, monitoring, backup, security

### New Components (2026-02-20)

**C0MMON:**
- Entities: AnomalyEvent, AutomationTrace, TestResult
- Interfaces: IAgent, IRepoTestResults
- Infrastructure: GameSelectorConfig, AgentRegistry
- Support: AtypicalityScore, WagerFeatures
- Services: CdpLifecycleConfig, CdpLifecycleManager

**H0UND:**
- Agents: PredictorAgent
- Services: AnomalyDetector, WagerOptimizer
- Recent: H0UND.cs (v0.8.6.3, AnalyticsIntervalSeconds=10)

**H4ND:**
- Parallel: ParallelH4NDEngine, ParallelMetrics, ParallelSpinWorker, SignalClaimResult, SignalDistributor, SignalWorkItem, WorkerPool
- Services: JackpotReader, SessionPool, SessionRenewalService, SignalGenerator, SystemHealthReport, BurnInController, FirstSpinController, BurnInConfig, FirstSpinConfig, NetworkInterceptor, SignalGenerationResult
- Vision: VisionCommandHandler, VisionCommandPublisher, VisionExecutionTracker
- Agents: ExecutorAgent, MonitorAgent
- EntryPoint: UnifiedEntryPoint
- Infrastructure: ChromeSessionManager, VmHealthMonitor
- Monitoring: AlertNotificationDispatcher, AlertSeverity, BurnInAlertConfig, BurnInAlertEvaluator, BurnInCompletionAnalyzer, BurnInDashboardServer, BurnInHaltDiagnostics, BurnInMonitor, BurnInProgressCalculator, DecisionPromoter, BurnInStatus, OperationalConfig
- Recent: H4ND.cs (RunMode.GenerateSignals, ARCH-055, TECH-H4ND-001, TECH-FE-015, TECH-JP-001, TECH-JP-002, OPS-JP-001), UnifiedEntryPoint.cs (ParseMode)

**W4TCHD0G:**
- Development: ConfirmationGate, DeveloperDashboard, FourEyesDevMode, TrainingDataCapture
- Stream: CDPScreenshotReceiver
- Vision Implementations: HeuristicStateClassifier, TemplateButtonDetector, TesseractJackpotDetector
- Vision Stubs: StubButtonDetector, StubJackpotDetector, StubStateClassifier

**T00L5ET:**
- CdpDiagnostic, CredCheck, FireKirinLogin, GameNavigator, LiveValidator, SessionHarvester

**UNI7T35T:**
- TestHarness: CdpTestClient, GameReadinessChecker, LoginValidator, SpinExecutor, SplashDetector, TestConfiguration, TestFixture, TestOrchestrator, TestReportGenerator, TestSignalInjector, VisionCapture
- Mocks: MockCdpClient, MockFourEyesClient, MockRepoTestResults
- Tests: FourEyesVisionTest, LiveJackpotReaderTest, AnomalyDetectorTests, CdpGameActionsTests, EndToEndTests, FirstSpinControllerTests, ParallelExecutionTests, SessionRenewalTests, SignalGeneratorTests, SystemHealthReportTests, CdpLifecycleManagerTests, BurnInMonitorTests

**publish:**
- TestJackpotReader, TestJackpot
- **Core Systems** (3 decisions): Monolithic vs microservices, circuit breakers
- **Features** (2 decisions): LLM inference strategy, model registry
- **Technical** (5 decisions): Model registry, decisions-server enhancement
- **Production Hardening** (5 decisions): Readiness verification, monitoring, deployment
- **Agent Architecture** (15 decisions): FourEyes, WindFixer, VM infrastructure, delegation
- **Strategy** (8 decisions): Delegation patterns, workflow optimization, RAG implementation

## 📜 License

[Your License Here]

---

## 🗺️ Quick Navigation Guide

| I want to... | Start Here → Next Steps |
|--------------|------------------------|
| **Understand the system** | [Overview](docs/overview.md) → [Architecture](docs/architecture/ADR-001-Core-Systems.md) → [Data Flow](#data-flow) |
| **Install and run locally** | [Setup Guide](docs/SETUP.md) → [System Requirements](docs/SYSTEM_REQUIREMENTS.md) → [Quick Start](#quick-start) |
| **Deploy to production** | [Deployment Guide](docs/DEPLOYMENT_GUIDE.md) → [Go-Live Checklist](docs/deployment/GOLIVE_CHECKLIST.md) → [Runbooks](docs/runbooks/) |
| **Handle an incident** | [Incident Response](docs/runbooks/INCIDENT_RESPONSE.md) → [Troubleshooting](docs/runbooks/TROUBLESHOOTING.md) → [Emergency Response](docs/procedures/EMERGENCY_RESPONSE.md) |
| **Configure credentials** | [Casino Setup](docs/credentials/CASINO_SETUP.md) → [Security](docs/SECURITY.md) → [Key Management](docs/security/KEY_MANAGEMENT.md) |
| **Tune jackpot thresholds** | [Threshold Calibration](docs/strategy/THRESHOLD_CALIBRATION.md) → [First Jackpot Attempt](docs/procedures/FIRST_JACKPOT_ATTEMPT.md) |
| **Emergency / Kill switch** | [Emergency Response](docs/procedures/EMERGENCY_RESPONSE.md) → [Safety Procedures](docs/procedures/) |
| **Development / Contributing** | [Modernization](docs/modernization.md) → [Migration Guide](docs/migration/README.md) → [Test Suite](UNI7T35T/) |
| **Performance / Benchmarks** | [Hardware Assessment](docs/llm/HARDWARE_ASSESSMENT.md) → [GT710 Benchmarks](docs/benchmarks/GT710_ENCODING.md) |
| **ML / Model Management** | [Model Versioning](docs/mlops/MODEL_VERSIONING.md) → [RAG System](docs/architecture/RAG.md) |

---

<p align="center">
  <strong>P4NTHE0N</strong> — Intelligent Automation Platform<br>
  <sub>Built with ❤️ using C# 10, .NET, MongoDB, Selenium, and OBS</sub>
</p>
