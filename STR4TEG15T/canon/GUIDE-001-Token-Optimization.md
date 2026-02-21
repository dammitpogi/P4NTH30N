# Token Optimization Guide

**Document ID**: GUIDE-001  
**Category**: Cost Optimization  
**Status**: Active  
**Date**: 2026-02-20  
**Authority**: DECISION_038 (FORGE-003)

---

## Overview

This guide provides strategies for minimizing token usage while maintaining quality, until the project becomes self-funded. Token costs are the primary operational expense for AI agent workflows.

---

## Token Budget Framework

### Budget Tiers

| Tier | Token Limit | Use Case | Approval Required |
|------|-------------|----------|-------------------|
| **Micro** | <10K | Quick fixes, simple queries | No |
| **Routine** | <50K | Standard decisions, regular tasks | No |
| **Standard** | <100K | Complex features, multi-file changes | Strategist |
| **Critical** | <200K | Architecture changes, critical decisions | Nexus |
| **Emergency** | >200K | Production outages, data recovery | Nexus |

### Per-Agent Budgets

| Agent | Daily Budget | Primary Model | Cost Level |
|-------|-------------|---------------|------------|
| Strategist | 100K | Kimi K2 | Medium |
| Oracle | 50K | GPT-4o Mini | Low |
| Designer | 75K | Claude 3 Haiku | Very Low |
| Librarian | 50K | Gemini Pro | Low |
| Explorer | 25K | Claude 3 Haiku | Very Low |
| WindFixer | 100K | Claude 3.5 Sonnet | Medium |
| OpenFixer | 75K | Claude 3.5 Sonnet | Medium |
| Forgewright | 150K | Claude 3.5 Sonnet | Medium |

---

## Model Selection Matrix

### By Task Type

| Task | Best Model | Platform | Cost/1K tokens | Why |
|------|-----------|----------|----------------|-----|
| **Code Implementation** | Claude 3.5 Sonnet | OpenRouter | $0.003 | Best code quality |
| **Code Review** | GPT-4o Mini | OpenAI | $0.0006 | Cost-effective |
| **Research** | Gemini Pro | Google | $0.0005 | Large context |
| **Analysis** | Claude 3 Haiku | Anthropic | $0.00025 | Fast, cheap |
| **Documentation** | GPT-4o Mini | OpenAI | $0.0006 | Good prose |
| **Bug Fixes** | Claude 3.5 Sonnet | OpenRouter | $0.003 | Debugging skill |
| **Decision Creation** | Kimi K2 | Moonshot | $0.002 | Deep reasoning |
| **Testing** | Local LLM | Ollama | $0 | Free |

### By Context Size

| Context Size | Model | Max Tokens | Cost/1K |
|--------------|-------|------------|---------|
| <4K | Claude 3 Haiku | 4K | $0.00025 |
| 4K-32K | GPT-4o Mini | 32K | $0.0006 |
| 32K-128K | Claude 3.5 Sonnet | 128K | $0.003 |
| 128K+ | Gemini Pro | 1M | $0.0005 |

---

## Optimization Strategies

### 1. Task Batching

**Before** (Inefficient):
```
Query 1: "What is CircuitBreaker pattern?" → 2K tokens
Query 2: "How to implement CircuitBreaker in C#?" → 3K tokens
Query 3: "CircuitBreaker best practices?" → 2K tokens
Total: 7K tokens
```

**After** (Optimized):
```
Query: "CircuitBreaker pattern: definition, C# implementation, 
        and best practices" → 4K tokens
Savings: 3K tokens (43%)
```

### 2. Context Pruning

**Before** (Full file):
```
"Here's the entire 500-line file. Fix the bug on line 45."
→ 5K tokens for context
```

**After** (Relevant section only):
```
"Here's lines 40-50 where the bug occurs. Fix the null reference."
→ 500 tokens for context
Savings: 4.5K tokens (90%)
```

### 3. Model Downgrading

**Before** (Overkill):
```
"@windfixer using Claude 3 Opus: Add a comment to this function"
→ 500 tokens @ $0.015/1K = $0.0075
```

**After** (Appropriate):
```
"@windfixer using Claude 3 Haiku: Add a comment to this function"
→ 500 tokens @ $0.00025/1K = $0.000125
Savings: 94% cost reduction
```

### 4. Caching Research

**Before** (Repeated queries):
```
Day 1: "Research MongoDB best practices" → 15K tokens
Day 3: "Research MongoDB best practices" → 15K tokens
Day 7: "Research MongoDB best practices" → 15K tokens
Total: 45K tokens
```

**After** (Cached):
```
Day 1: Research and save to `research/mongodb-best-practices.md`
Day 3: Read cached file (0 tokens)
Day 7: Read cached file (0 tokens)
Savings: 30K tokens (67%)
```

### 5. Progressive Enhancement

**Before** (One-shot perfection):
```
"Create perfect production-ready implementation with 
 full test coverage, documentation, and optimization"
→ 50K tokens for complex feature
```

**After** (Iterative):
```
Step 1: "Create minimal working implementation" → 10K tokens
Step 2: "Add basic tests" → 5K tokens
Step 3: "Add documentation" → 5K tokens
Step 4: "Optimize performance" → 10K tokens
Total: 30K tokens
Savings: 20K tokens (40%)
Plus: Better quality through iteration
```

---

## Agent-Specific Strategies

### Strategist

**High-Cost Activities**:
- Decision creation with full context
- Multi-decision coordination
- Research synthesis

**Optimization**:
- Use Kimi K2 for decisions (best reasoning/cost ratio)
- Batch similar decisions
- Reuse previous decision templates
- Delegate research to Librarian (cheaper)

**Budget Alert**: At 80K tokens (80%), switch to Claude 3 Haiku for remaining tasks

### Oracle

**High-Cost Activities**:
- Risk analysis requiring deep reasoning
- Validation of complex architectures

**Optimization**:
- Use GPT-4o Mini for routine validations
- Reserve Claude 3.5 Sonnet for critical decisions only
- Cache common risk patterns

**Budget Alert**: At 40K tokens (80%), escalate to Strategist

### Designer

**High-Cost Activities**:
- Complex architecture design
- Multi-system integration planning

**Optimization**:
- Use Claude 3 Haiku for file structure (fast, cheap)
- Use Claude 3.5 Sonnet for complex architecture only
- Create reusable architecture patterns

**Budget Alert**: At 60K tokens (80%), simplify designs

### Librarian

**High-Cost Activities**:
- Deep research across multiple sources
- Technical documentation analysis

**Optimization**:
- Use Gemini Pro (cheapest for large context)
- Cache all research results
- Use local models for document search

**Budget Alert**: At 40K tokens (80%), use cached results only

### WindFixer/OpenFixer

**High-Cost Activities**:
- Multi-file implementation
- Complex bug fixes
- Refactoring

**Optimization**:
- Use Claude 3.5 Sonnet (best for code)
- Batch related file changes
- Use local models for syntax checking
- Implement incrementally

**Budget Alert**: At 80K tokens (80%), switch to smaller models

### Forgewright

**High-Cost Activities**:
- Complex bug fixes
- Tool creation
- Cross-cutting changes

**Optimization**:
- Use Claude 3.5 Sonnet (best debugging)
- Create reusable tools (amortize cost)
- Batch similar bug fixes
- Use local models for testing

**Budget Alert**: At 120K tokens (80%), escalate to Nexus

---

## Cost Tracking

### Per-Decision Tracking

Every decision must include:

```markdown
## Token Budget

| Phase | Estimated | Actual | Variance |
|-------|-----------|--------|----------|
| Decision Creation | 10K | 8K | -2K |
| Oracle Consultation | 5K | 6K | +1K |
| Designer Consultation | 5K | 4K | -1K |
| Implementation | 30K | - | - |
| **Total** | **50K** | **18K** | **-2K** |

**Status**: On Budget
```

### Daily Tracking

```
2026-02-20 Token Usage Report:
┌─────────────┬────────┬─────────┬─────────┐
│ Agent       │ Budget │ Used    │ Remaining│
├─────────────┼────────┼─────────┼─────────┤
│ Strategist  │ 100K   │ 45K     │ 55K     │
│ Oracle      │ 50K    │ 12K     │ 38K     │
│ Designer    │ 75K    │ 30K     │ 45K     │
│ Librarian   │ 50K    │ 8K      │ 42K     │
│ WindFixer   │ 100K   │ 67K     │ 33K ⚠️  │
│ OpenFixer   │ 75K    │ 23K     │ 52K     │
│ Forgewright │ 150K   │ 45K     │ 105K    │
├─────────────┼────────┼─────────┼─────────┤
│ TOTAL       │ 600K   │ 230K    │ 370K    │
└─────────────┴────────┴─────────┴─────────┘

Alerts: WindFixer at 67% (approaching 80% threshold)
```

---

## Emergency Procedures

### At 80% Budget

1. **Alert triggered** - Agent notified
2. **Switch to cheaper model** - Use Haiku/GPT-4o Mini
3. **Batch remaining tasks** - Combine where possible
4. **Escalate if critical** - Request budget increase

### At 100% Budget

1. **Halt non-critical work** - Stop all non-essential tasks
2. **Complete in-progress only** - Finish current task
3. **Escalate to Strategist** - Request budget review
4. **Switch to local models** - Use Ollama for remaining work

### Budget Increase Request

```markdown
**Budget Increase Request**

Agent: [Name]
Current Budget: [X] tokens
Requested Increase: [Y] tokens
Reason: [Justification]
Impact if Denied: [Consequences]
Alternative: [Cheaper approach]

**Strategist Decision**: [Approve/Deny/Alternative]
```

---

## Local Model Fallback

When budgets are exhausted, use local models via Ollama:

| Task | Local Model | Quality | Speed |
|------|-------------|---------|-------|
| Code completion | codellama:7b | Good | Fast |
| Documentation | llama2:13b | Good | Medium |
| Analysis | mistral:7b | Good | Fast |
| Testing | phi:2.7b | Adequate | Very Fast |

**Setup**:
```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull models
ollama pull codellama:7b
ollama pull mistral:7b
ollama pull phi:2.7b
```

**Usage**:
```bash
# Generate code
ollama run codellama:7b "Write a C# class for CircuitBreaker pattern"

# Zero API cost
```

---

## Monthly Cost Targets

Until self-funded:

| Month | Target Cost | Max Tokens | Strategy |
|-------|-------------|------------|----------|
| Month 1 | $500 | 5M | Conservative, local models |
| Month 2 | $750 | 7.5M | Moderate, optimize workflows |
| Month 3 | $1000 | 10M | Balanced, full capability |
| Month 4+ | TBD | TBD | Based on funding |

**Cost per Decision**:
- Routine: <$5 (<50K tokens)
- Standard: <$15 (<150K tokens)
- Critical: <$50 (<500K tokens)

---

## Quick Reference

### Cheapest Model for Task

```
Quick question → Claude 3 Haiku ($0.00025/1K)
Code review → GPT-4o Mini ($0.0006/1K)
Research → Gemini Pro ($0.0005/1K)
Implementation → Claude 3.5 Sonnet ($0.003/1K)
Testing → Local LLM ($0)
```

### Token Estimation

```
1 page text ≈ 500 tokens
1 code file ≈ 1K-5K tokens
1 decision ≈ 10K-50K tokens
1 consultation ≈ 5K-20K tokens
```

### Cost Estimation

```
Claude 3 Haiku: $0.25 per 1M tokens
GPT-4o Mini: $0.60 per 1M tokens
Gemini Pro: $0.50 per 1M tokens
Claude 3.5 Sonnet: $3.00 per 1M tokens
```

---

*Guide GUIDE-001*  
*Token Optimization*  
*2026-02-20*
