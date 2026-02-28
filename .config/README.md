# P4NTHE0N Universal Configuration

**Location**: `C:\P4NTHE0N\.config`  
**Purpose**: Source of truth for all P4NTHE0N configurations  
**Deploy Target**: `~/.config/opencode/`  
**Decision**: DECISION_100

---

## Directory Structure

```
P4NTHE0N/.config/
├── manifest.json                          # This manifest
├── README.md                              # This file
│
├── opencode/
│   ├── oh-my-opencode.json               # Provider configurations
│   ├── oh-my-opencode-theseus.json       # Oracle resilience + fallback chains
│   └── agents/                           # Agent prompt overrides
│       ├── oracle.md
│       ├── strategist.md
│       ├── explorer.md
│       ├── designer.md
│       ├── librarian.md
│       └── fixer.md
│
└── p4nth30n/
    ├── decisions/                        # Decision-specific configs
    │   └── DECISION_100/
    │       ├── oracle-resilience.yaml
    │       └── fallback-chains.json
    └── skills/                           # Skill configurations
        └── update-agent-models/
            └── config.json
```

---

## Configuration Files

### 1. oh-my-opencode.json
**Purpose**: OpenCode provider API configurations  
**Contains**: API keys, base URLs, provider settings  
**Do not commit**: Contains sensitive API key references

### 2. oh-my-opencode-theseus.json
**Purpose**: Theseus plugin with Oracle resilience  
**Contains**:
- Extended fallback chains (11+ models across 4 tiers)
- Circuit breaker settings
- Error classification patterns
- Triage scorecard configuration
- Agent-specific resilience settings

**Key Features**:
- **Oracle**: 11-model extended chain (Premium → Standard → Alternative → Local)
- **Triage**: SQLite persistence with JSON export
- **Scorecard**: End-game analytics with model rankings
- **Resilience**: Automatic fallback, context compaction, health monitoring

---

## Deployment

### Manual Deploy

```powershell
# Copy to OpenCode config directory
Copy-Item -Path "C:\P4NTHE0N\.config\opencode\oh-my-opencode-theseus.json" `
          -Destination "$env:USERPROFILE\.config\opencode\oh-my-opencode-theseus.json" `
          -Force

# Verify deployment
Get-Content "$env:USERPROFILE\.config\opencode\oh-my-opencode-theseus.json" | Select-Object -First 20
```

### Automated Deploy (Future)

```powershell
# Deploy all configs
.\deploy-configs.ps1 -Environment development

# Deploy specific config
.\deploy-configs.ps1 -Config theseus -Environment production
```

---

## Configuration Versioning

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-22 | Initial Oracle resilience config with extended fallback chains |

---

## Validation

```powershell
# Validate JSON syntax
Get-Content ".config\opencode\oh-my-opencode-theseus.json" | ConvertFrom-Json

# Check for required fields
$config = Get-Content ".config\opencode\oh-my-opencode-theseus.json" | ConvertFrom-Json
$config.agents.oracle.models.Count  # Should be 11+
$config.agents.oracle.fallback.extendedChain.enabled  # Should be true
```

---

## Source of Truth

This directory (`C:\P4NTHE0N\.config`) is the **source of truth** for all configurations.

**Workflow**:
1. Edit configs in `C:\P4NTHE0N\.config`
2. Test locally
3. Deploy to `~/.config/opencode/`
4. Restart OpenCode to pick up changes

**Never edit** `~/.config/opencode/` directly - changes will be lost on next deploy.

---

## Related Decisions

- **DECISION_100**: Integrate Theseus Plugin Fallback System for Oracle Repair
- **DECISION_099**: FireKirin Login Smoke Test
- **DECISION_047**: 24-Hour Burn-In Validation

---

## Maintenance

**Update Schedule**:
- **Weekly**: Review triage scorecard, adjust fallback chains
- **Monthly**: Update model list based on benchmarks
- **Quarterly**: Full config review and optimization

**Responsible**: Strategist (Pyxis)  
**Approved by**: Oracle (Orion), Designer (Aegis)
