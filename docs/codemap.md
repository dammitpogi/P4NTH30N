# docs/

## Responsibility

Comprehensive documentation repository for P4NTHE0N platform architecture, migration plans, operational procedures, and development guides. Serves as the single source of truth for system design, modernization roadmap, security policies, and runbooks. Contains Architecture Decision Records (ADRs), operational runbooks, security documentation, and migration guides.

## Design

**Documentation Structure**: Hierarchical organization by topic
- **Architecture**: System design, ADRs, component specifications
- **Migration**: Data migration scripts and procedures
- **Operations**: Runbooks, procedures, and checklists
- **Security**: Policies, credentials setup, disaster recovery
- **Strategy**: Threshold calibration, deployment strategies

### Directory Structure

```
docs/
├── architecture/           # System architecture documentation
│   ├── ADR-001-Core-Systems.md        # Architecture Decision Record (CORE-001)
│   ├── CODEX_of_Provenance_v1.0.3.json # Comprehensive system spec
│   ├── refactor_questions.json        # Design decision records
│   └── CODEX_questions_suggestions    # Community feedback
├── credentials/            # Credential management docs
│   └── CASINO_SETUP.md    # Casino setup guide (WIN-005)
├── deployment/             # Deployment documentation
│   └── GOLIVE_CHECKLIST.md # Production go-live checklist (WIN-008)
├── migration/              # Migration guides and scripts
│   ├── README.md          # Migration strategy overview
│   ├── preflight.js       # Pre-migration validation
│   ├── quick-check.js     # Readiness verification
│   ├── deduplicate-qu3ue.js # Data cleanup
│   ├── embed-game-into-queue.js # Game data migration
│   └── recreate-n3xt-view.js # View regeneration
├── procedures/             # Operational procedures
│   ├── EMERGENCY_RESPONSE.md   # Emergency procedures (WIN-002)
│   └── FIRST_JACKPOT_ATTEMPT.md # First jackpot guide (WIN-006)
├── runbooks/               # Operational runbooks (INFRA-008)
│   ├── DEPLOYMENT.md      # Deployment procedures
│   ├── INCIDENT_RESPONSE.md # Incident handling
│   ├── TROUBLESHOOTING.md # Troubleshooting guide
│   └── POST_MORTEM.md     # Post-incident analysis
├── strategy/               # Strategy documentation
│   └── THRESHOLD_CALIBRATION.md # Threshold tuning guide (WIN-007)
├── DISASTER_RECOVERY.md    # DR procedures (INFRA-005)
├── modernization.md        # Technical debt roadmap
├── overview.md            # High-level system overview
├── SECURITY.md            # Security policies (INFRA-006)
└── TECH-001/              # Technical specifications
    ├── model-versioning.md # Model versioning (TECH-001)
    ├── hardware-assessment.md # Hardware requirements (TECH-002)
    └── GT710-benchmark.md # GPU benchmarks (TECH-003)
```

## Flow

### Documentation Usage Flow
1. **New Developer Onboarding**: Start with `overview.md` for system context
2. **Architecture Deep Dive**: Reference `architecture/ADR-001-Core-Systems.md` and `CODEX_of_Provenance`
3. **Development Tasks**: Consult `modernization.md` for coding standards
4. **Deployment**: Follow `deployment/GOLIVE_CHECKLIST.md` and `runbooks/DEPLOYMENT.md`
5. **Emergency**: Reference `procedures/EMERGENCY_RESPONSE.md` and `runbooks/INCIDENT_RESPONSE.md`
6. **Migration Work**: Execute scripts from `migration/` following README

### Architecture Decision Flow
```
New Decision Required
    ↓
Draft ADR in architecture/
    ↓
Review with team
    ↓
Update ADR-001-Core-Systems.md (CORE-001)
    ↓
Implement decision
    ↓
Update relevant codemaps
```

### Emergency Response Flow
```
Incident Detected
    ↓
Consult procedures/EMERGENCY_RESPONSE.md
    ↓
Follow runbooks/INCIDENT_RESPONSE.md
    ↓
Execute procedures
    ↓
Document in runbooks/POST_MORTEM.md
```

## Integration

### Related to Code
- `C0MMON/`: Security.md explains encryption patterns
- `H0UND/`: ADRs document analytics algorithms and forecasting models
- `H4ND/`: Procedures cover automation patterns and Selenium usage
- `RUL3S/`: Architecture specifies resource override requirements
- `W4TCHD0G/`: Runbooks include safety monitoring procedures
- `UNI7T35T/`: Testing procedures in runbooks

### Development Workflow
- Guides coding standards in `modernization.md`
- Informs refactoring priorities and approach
- Provides context for design decisions (refactor_questions.json)
- Establishes patterns for new component development

### Operational Procedures
- Migration scripts automate deployment tasks (migration/)
- Preflight checks prevent failed deployments
- Recovery procedures documented in `DISASTER_RECOVERY.md`
- Go-live checklist in `deployment/GOLIVE_CHECKLIST.md`

## Key Documents

### Architecture (CORE-001)
- **ADR-001-Core-Systems.md**: Architecture Decision Record for core system design
- **CODEX_of_Provenance_v1.0.3.json**: Comprehensive system architecture specification
  - Component definitions and responsibilities
  - Data flow diagrams and sequence charts
  - API contracts and integration points
  - Technology stack and dependencies

### Operations (INFRA-008)
- **runbooks/DEPLOYMENT.md**: Step-by-step deployment procedures
- **runbooks/INCIDENT_RESPONSE.md**: Incident handling procedures
- **runbooks/TROUBLESHOOTING.md**: Common issues and solutions
- **runbooks/POST_MORTEM.md**: Post-incident analysis template
- **DISASTER_RECOVERY.md**: Backup/restore procedures (INFRA-005)

### Security (INFRA-006)
- **SECURITY.md**: Security policies and best practices
- **credentials/CASINO_SETUP.md**: Secure credential setup (WIN-005)

### Procedures
- **procedures/EMERGENCY_RESPONSE.md**: Emergency response procedures (WIN-002)
- **procedures/FIRST_JACKPOT_ATTEMPT.md**: First jackpot guide (WIN-006)
- **deployment/GOLIVE_CHECKLIST.md**: Production deployment checklist (WIN-008)
- **strategy/THRESHOLD_CALIBRATION.md**: Threshold tuning guide (WIN-007)

### Technical Specifications (TECH-001/002/003)
- **TECH-001/model-versioning.md**: Model versioning strategy
- **TECH-002/hardware-assessment.md**: Hardware requirements assessment
- **TECH-003/GT710-benchmark.md**: GPU performance benchmarks

### Migration
- **migration/README.md**: Migration strategy overview
- **migration/preflight.js**: Pre-migration validation
- **migration/quick-check.js**: Readiness verification

## Critical Notes

### Documentation Standards
- Keep ADRs current with system changes
- Update runbooks after incidents
- Version control documentation with code
- Review documentation in PRs

### Maintenance
- Update CODEX when architecture changes
- Record design decisions in `refactor_questions.json`
- Maintain migration scripts for version upgrades
- Keep `modernization.md` current with technical debt status

### Security
- Security policies in `SECURITY.md`
- Credential procedures in `credentials/CASINO_SETUP.md`
- Disaster recovery in `DISASTER_RECOVERY.md`

## Recent Additions (This Session)

**WIN-002: Emergency Response**
- `procedures/EMERGENCY_RESPONSE.md`

**WIN-005: Casino Setup**
- `credentials/CASINO_SETUP.md`

**WIN-006: First Jackpot Guide**
- `procedures/FIRST_JACKPOT_ATTEMPT.md`

**WIN-007: Threshold Calibration**
- `strategy/THRESHOLD_CALIBRATION.md`

**WIN-008: Go-Live Checklist**
- `deployment/GOLIVE_CHECKLIST.md`

**INFRA-005: Disaster Recovery**
- `DISASTER_RECOVERY.md`
- MongoDB backup/restore scripts referenced

**INFRA-006: Security**
- `SECURITY.md`

**INFRA-008: Runbooks**
- `runbooks/DEPLOYMENT.md`
- `runbooks/INCIDENT_RESPONSE.md`
- `runbooks/TROUBLESHOOTING.md`
- `runbooks/POST_MORTEM.md`

**CORE-001: Architecture Decision Records**
- `architecture/ADR-001-Core-Systems.md`

**TECH-001/002/003: Technical Specifications**
- Model versioning, hardware assessment, GPU benchmarks

**New Documentation (2026-02-20)**
- `vm-deployment/`: VM deployment documentation
  - `architecture.md`: VM deployment architecture
  - `network-setup.md`: Network configuration
  - `chrome-cdp-config.md`: Chrome CDP configuration
  - `troubleshooting.md`: VM troubleshooting
- `components/H4ND/AGENT_MANIFEST.md`: H4ND agent manifest
- `components/H0UND/AGENT_MANIFEST.md`: H0UND agent manifest
- `vm/EXECUTOR_VM.md`: VM executor guide

### Recent Modifications (2026-02-20)
- **H0UND/H0UND.cs**: Version 0.8.6.3, AnalyticsIntervalSeconds = 10
- **H4ND/H4ND.cs**: Added RunMode.GenerateSignals support, ARCH-055, TECH-H4ND-001, TECH-FE-015, TECH-JP-001, TECH-JP-002, OPS-JP-001 documentation
- **H4ND/UnifiedEntryPoint.cs**: ParseMode support for different run modes
