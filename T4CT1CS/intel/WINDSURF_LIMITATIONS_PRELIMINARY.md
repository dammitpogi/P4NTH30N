# WindSurf Model Limitations - Preliminary Research Summary

## Research Date: 2026-02-18
## Source: Web search of current documentation and community reports

---

## Critical Limitations Discovered

### 1. Context Window Reality Gap

**Documented vs Actual:**
| Model | Documented Limit | Community Reported | Effective Limit |
|-------|-----------------|-------------------|-----------------|
| Claude 4 Sonnet | 200K tokens | ~115K input | Unknown compression |
| GPT-4/GPT-5 | 32K-64K | 32K typical | 4K output cap |
| WindSurf Cascade | 200K | 200-line reading limit | 50 lines at a time |
| SWE-1.5 | Not specified | Unknown | Optimized for speed |

**Key Finding:** WindSurf's 200-line documented limit with community reports of 50-line incremental reading suggests severe context limitations for large codebases.

### 2. Memory Management Issues

**AI Drift Phenomenon:**
- Models lose track of guidelines over long sessions
- Recency bias: newer instructions weighted more heavily
- Memory compression leads to detail loss
- Prompt interference: new instructions may contradict previous ones

**WindSurf Specific:**
- Context window indicator added in recent versions
- Cascade summarizes messages and clears history automatically
- Earlier context can be dropped without warning
- Performance degrades as context grows

### 3. Code Generation Constraints

**Output Limitations:**
- Output typically capped at 4K tokens even with larger input context
- Large generations may stop mid-file
- Multi-file edits require manual coordination
- Complex refactoring may need to be broken into chunks

**SWE-1.5 Specific:**
- 950 tokens/sec generation speed (14x faster than Claude)
- Near Claude 4.5-level performance
- Optimized for agentic coding tasks
- May sacrifice depth for speed

### 4. Resource Consumption

**Memory Usage:**
- WindSurf can consume 10GB+ RAM in large projects
- Aggressive context handling and indexing
- Long sessions require restart to restore performance
- Lower-end systems may struggle

**Credit Costs:**
- Different models consume different credit amounts
- BYOK (Bring Your Own Key) available for Claude models
- SWE-1.5: 1.0 user prompt credits + 1.0 flow action credits per tool call
- Claude 3.7 Sonnet (Thinking): 1.5x credit multiplier

### 5. Model-Specific Characteristics

**SWE-1.5:**
- Fastest generation (950 tok/s)
- Near-SOTA performance
- Built specifically for software engineering
- May have different context handling than general models

**Claude 4 Sonnet:**
- 200K context window (BYOK)
- Strong reasoning capabilities
- Zero Data Retention (ZDR) privacy mode
- SOC2 Type II certified

**GPT-5.2:**
- SWE-bench: ~75% verified
- Terminal-Bench: 43.8%
- Medium reasoning effort configuration
- Available in Copilot, Cursor, WindSurf

**Cascade Base (Free Tier):**
- Llama 3.1 70B locally optimized
- For 8-16GB RAM machines
- Limited context vs Pro tier
- 25 credits/month free tier

### 6. Tool Use Limitations

**Cascade Specific:**
- Tool calls consume flow action credits
- Rate limiting on free tiers
- Complex multi-tool workflows may need decomposition
- Context retrieval via swe-grep for Fast Context

**MCP Integration:**
- Model Context Protocol allows external tool access
- Can draw from local codebase, web docs, private KBs
- Per-repository indexing required (O(n) complexity)
- Cross-repository context requires separate indexing

### 7. Error Patterns

**Common Failures:**
- "No response requested" (SWE-1.5)
- Internal Cascade errors (Gemini 3 Pro)
- Markdown file creation spam (Sonnet 4.5)
- Context window exceeded without clear warning
- Tool call failures without clear error messages

**Recovery Strategies:**
- Start fresh chat when context grows too long
- Use branch-based working for isolation
- Regular memory check and cleanup
- Periodic repetition of critical guidelines

### 8. Optimization Strategies

**Prompt Engineering:**
- Detailed specifications before development
- Clear outlines of what to build
- Robust rule definitions in global_rules.md
- Contextual refresher for critical guidelines

**Session Management:**
- Monitor context size with visual indicator
- Start new sessions before hitting limits
- Use Flow for persistent context across sessions
- Plan Mode for smarter task planning

**Workflow Design:**
- Break large tasks into smaller chunks
- Prefer end-to-end tests over unit tests
- Early and frequent testing
- Continuous testing for deviation detection

---

## Model Selection Matrix (Preliminary)

| Task Type | Recommended Model | Rationale |
|-----------|------------------|-----------|
| Fast prototyping | SWE-1.5 | 950 tok/s speed |
| Complex reasoning | Claude 4 Opus | 200K context, deep analysis |
| Balanced work | Claude 4 Sonnet | Good performance/cost |
| General coding | GPT-5.2 | Broad capability |
| Free tier work | Cascade Base | Local execution, no cost |
| Multi-file refactor | SWE-1.5 or Claude 4 | Agentic capabilities |
| Architecture decisions | Claude 4 Opus | Best reasoning |
| Quick fixes | SWE-1.5-mini | Real-time latency |

---

## Key Questions for Model Query

1. What is the practical context limit before performance degrades?
2. How do you handle conversations that exceed your context window?
3. What causes you to "forget" earlier instructions?
4. What is the maximum code you can generate reliably?
5. How should large refactoring tasks be structured?
6. What are your most common failure modes?
7. How do you signal when you've reached a limitation?
8. What prompt patterns maximize your effectiveness?

---

## Next Steps

1. Execute the comprehensive prompt across all 8 models
2. Document model-specific responses
3. Create comparative analysis
4. Establish selection criteria
5. Update AGENTS.md with findings
6. Create model selection decision tree

---

## Risk Mitigation

**Context Loss:**
- Design workflows with context refresh points
- Use persistent storage for critical state
- Implement checkpoint/resume patterns

**Model Unavailability:**
- Maintain fallback model chains
- Design model-agnostic prompts
- Cache model-specific optimizations

**Credit Exhaustion:**
- Monitor credit usage per model
- Use BYOK for high-volume models
- Implement credit-aware routing

---

*This document will be updated with findings from the comprehensive model query.*
