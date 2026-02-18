# P4NTH30N Platform

> Multi-agent automation platform for intelligent game analytics and automated gameplay

[![Build Status](https://img.shields.io/badge/build-clean-success)](https://github.com/your-org/P4NTH30N)
[![Tests](https://img.shields.io/badge/tests-27%2F27%20passing-success)](https://github.com/your-org/P4NTH30N)
[![.NET](https://img.shields.io/badge/.NET-10.0-blue)](https://dot.net)
[![MongoDB](https://img.shields.io/badge/MongoDB-7.0+-green)](https://mongodb.com)

## 🎯 What is P4NTH30N?

P4NTH30N is a sophisticated, multi-agent automation platform built in C# that coordinates **jackpot discovery**, **signal generation**, and **automated gameplay** for supported casino game portals. The system uses statistical forecasting and computer vision to optimize timing and ensure safety.

### Key Capabilities

- **🔍 Jackpot Discovery**: Automated polling and balance monitoring via HTTP/WebSocket APIs
- **📊 DPD Forecasting**: Statistical "Dollars Per Day" analysis to predict jackpot timing
- **🤖 Intelligent Automation**: Signal-driven gameplay with browser automation (Selenium)
- **🛡️ Safety Systems**: Spend limits, loss circuit breakers, and emergency kill switches
- **👁️ Vision Integration**: OBS-based computer vision for win detection and monitoring
- **🔒 Security**: AES-256 encryption, secure credential management, key rotation
- **🧠 ML Integration**: Local model inference, RAG system, autonomous learning

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         P4NTH30N PLATFORM                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐ │
│  │   H0UND     │    │    H4ND     │    │     W4TCHD0G        │ │
│  │  (Brain)    │◄──►│   (Hands)   │    │  (Vision + Safety)  │ │
│  │  Analytics  │    │  Automation │    │   OBS Integration   │ │
│  │   Polling   │    │   Selenium  │    │  Safety Monitoring  │ │
│  └──────┬──────┘    └──────┬──────┘    └──────────┬──────────┘ │
│         │                  │                      │             │
│         └──────────────────┼──────────────────────┘             │
│                            │                                    │
│                   ┌────────┴────────┐                          │
│                   │     C0MMON      │                          │
│                   │  Shared Library │                          │
│                   │  MongoDB Access │                          │
│                   │  LLM | RAG | Security                     │ │
│                   └────────┬────────┘                          │
│                            │                                    │
│                   ┌────────┴────────┐                          │
│                   │    MongoDB      │                          │
│                   │   P4NTH30N      │                          │
│                   └─────────────────┘                          │
│                                                                   │
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
git clone https://github.com/your-org/P4NTH30N.git
cd P4NTH30N

# Setup environment (automated)
.\scripts\setup\setup-mongodb.ps1 -StartService
.\scripts\setup\setup-chromedriver.ps1 -AddToPath

# Build and test
dotnet build P4NTH30N.slnx
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
dotnet build P4NTH30N.slnx

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
P4NTH30N/
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

| Component | Status |
|-----------|--------|
| **Build** | ✅ Clean |
| **Tests** | ✅ 27/27 Passing |
| **Documentation** | ✅ Comprehensive (37/39 decisions) |
| **Security** | ✅ AES-256 Encryption |
| **Safety** | ✅ Kill Switch + Circuit Breakers |
| **Vision** | ✅ OBS Integration + Win Detection |
| **Coverage** | ✅ 16 Integration Tests |

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
  <strong>P4NTH30N</strong> — Intelligent Automation Platform<br>
  <sub>Built with ❤️ using C# 10, .NET, MongoDB, Selenium, and OBS</sub>
</p>
