# docs/

## Responsibility
Comprehensive documentation repository for P4NTH30N platform architecture, migration plans, and development guides. Serves as knowledge base for system design, modernization roadmap, and operational procedures.

## Design

### Documentation Structure
- **Architecture-Centric**: Heavy focus on system design and component interactions
- **Migration-Focused**: Detailed plans for transitioning between system versions
- **Process-Oriented**: Guides for development, deployment, and maintenance
- **Historical Context**: Preserves design decisions and evolution timeline

### Core Components

**Architecture Documentation** (`architecture/`):
- `CODEX_of_Provenance_v1.0.3.json`: Comprehensive system architecture specification
  - Component definitions and responsibilities
  - Data flow diagrams and sequence charts
  - API contracts and integration points
  - Technology stack and dependencies
- `refactor_questions.json`: Design decision records and architectural questions
- `CODEX_questions_suggestions`: Community feedback and improvement proposals

**Migration Guides** (`migration/`):
- `README.md`: Overview of migration strategy and timeline
- `preflight.js`: Pre-migration validation and system checks
- `quick-check.js`: Rapid verification of migration readiness
- `deduplicate-qu3ue.js`: Data cleanup for queue structures
- `embed-game-into-queue.js`: Game data migration utilities
- `recreate-n3xt-view.js`: View and projection regeneration

**System Overviews**:
- `overview.md`: High-level platform description and agent interactions
  - HUN7ER (analytics) and H4ND (automation) agent communication
  - MongoDB as asynchronous message bus
  - Event-driven architecture patterns
- `modernization.md`: Technical debt assessment and improvement roadmap
  - Code quality metrics and targets
  - Refactoring priorities and sequencing
  - Technology upgrade paths

## Flow

### Documentation Usage Flow
1. **New Developer Onboarding**: Start with `overview.md` for system context
2. **Architecture Deep Dive**: Reference `CODEX_of_Provenance` for technical details
3. **Development Tasks**: Consult `modernization.md` for coding standards
4. **Migration Work**: Follow `migration/README.md` for step-by-step guides
5. **Design Decisions**: Review `refactor_questions.json` for historical context

### Migration Execution Flow
1. Run `preflight.js` to validate system state
2. Execute `quick-check.js` for readiness verification
3. Run data cleanup scripts (`deduplicate-qu3ue.js`)
4. Execute migration scripts (`embed-game-into-queue.js`)
5. Regenerate views with `recreate-n3xt-view.js`
6. Verify migration success with post-checks

### Architecture Reference Flow
1. Consult `CODEX_of_Provenance` for component definitions
2. Review data flow diagrams for integration understanding
3. Check API contracts for interface implementation
4. Reference technology stack for environment setup
5. Review design decisions for context

## Integration

**Related to Code**:
- `C0MMON/`: Architecture docs explain persistence layer design
- `HUN7ER/`: CODEX details analytics algorithms and forecasting models
- `H4ND/`: Documentation covers automation patterns and Selenium usage
- `RUL3S/`: Architecture specifies resource override requirements

**Development Workflow**:
- Guides coding standards in `modernization.md`
- Informs refactoring priorities and approach
- Provides context for design decisions
- Establishes patterns for new component development

**Operational Procedures**:
- Migration scripts automate deployment tasks
- Preflight checks prevent failed deployments
- Recovery procedures documented in migration guides

## Key Concepts

**Agent Communication**:
- HUN7ER and H4ND communicate via MongoDB collections
- Signals act as asynchronous messages between agents
- Event-driven architecture enables loose coupling

**Data Architecture**:
- MongoDB serves as both database and message bus
- Collections: credentials, signals, eventlogs, jackpots, houses
- DPD data structure enables predictive analytics

**Automation Strategy**:
- Resource overrides enable browser automation
- Selenium for navigation, direct APIs for gameplay
- Stealth techniques to avoid detection

**Quality Assurance**:
- Sanity checking prevents data corruption
- Validation at multiple layers (repository, service, UI)
- Automated repair for common data issues

## Maintenance

**Documentation Updates**:
- Update CODEX when architecture changes
- Record design decisions in `refactor_questions.json`
- Maintain migration scripts for version upgrades
- Keep `modernization.md` current with technical debt status

**Version Control**:
- Architecture docs versioned with code
- Migration scripts tested before commits
- Documentation changes reviewed in PRs
- Historical docs preserved for reference

**Community Contributions**:
- `CODEX_questions_suggestions` captures community input
- Review and incorporate feedback regularly
- Maintain changelog for documentation updates