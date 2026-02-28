# WindSurf Model Query - Prompt Variants

## Variant 1: Quick Discovery (5-Minute Response)

Use this when you need rapid intelligence without overwhelming detail.

```
Quick Model Capability Assessment for P4NTHE0N Platform

Please provide concise answers (1-2 sentences each):

1. CONTEXT: What is your practical context limit before performance degrades?
2. MEMORY: How many turns before you start losing earlier context?
3. CODE GEN: What is the largest file you can generate reliably?
4. MULTI-FILE: How many files can you edit in one session?
5. TOOLS: How many tool calls can you make per turn?
6. ERRORS: What is your most common failure mode?
7. STRENGTH: What task type do you excel at most?
8. WEAKNESS: What should users avoid asking you to do?
9. OPTIMIZATION: One tip for maximizing your effectiveness?
10. COMPARISON: When should users choose a different model over you?

Format: Numbered list, brief answers only.
```

---

## Variant 2: Technical Deep Dive (For Engineers)

Use this when you need detailed technical specifications.

```
Technical Model Specification for P4NTHE0N C# Development

Provide detailed technical specifications:

## Architecture
- Model architecture (transformer type, parameters if known)
- Training data cutoff date
- Fine-tuning for code vs general purpose

## Tokenization
- Tokenizer type and vocabulary size
- Approximate tokens per line of C# code
- Special token handling

## Context Management
- Exact context window size (input + output)
- Attention mechanism (full, sparse, sliding window)
- Context eviction strategy
- System prompt overhead

## Generation Parameters
- Max output tokens per response
- Temperature/repetition penalty defaults
- Stop sequences and special handling
- Streaming support

## Tool Use Specifications
- Tool calling protocol
- Parallel tool execution capability
- Tool result context window usage
- Error handling in tool chains

## Performance Metrics
- Time to first token
- Tokens per second (sustained)
- Latency under different context sizes
- Memory usage patterns

## Failure Modes
- Specific error types and codes
- Recovery mechanisms
- Retry strategies that work best
- Known bug workarounds

Provide specific numbers, not general descriptions.
```

---

## Variant 3: Workflow Optimization (For Process Design)

Use this when designing agent workflows and need to know interaction patterns.

```
Workflow Design Intelligence for Multi-Agent System

We're designing agent workflows for a C# automation platform. Help us optimize:

## Session Design
- Ideal session length (in messages or time)
- When to start fresh vs continue
- How to maintain context across sessions
- Checkpoint strategies

## Task Decomposition
- Optimal task granularity for you
- How to break down large refactoring jobs
- Multi-step workflow patterns that work
- When to parallelize vs sequence

## Context Strategy
- What to include in initial prompt vs discover
- How to reference previous work
- File selection for maximum relevance
- Context refresh intervals

## Error Handling
- How you signal task failure
- Recovery patterns that work
- When to escalate vs retry
- Fallback strategies

## Tool Integration
- Ideal tool call patterns
- How to chain tool calls effectively
- Result processing strategies
- Tool result summarization

## Human Collaboration
- When to ask for clarification
- How to present options vs decide
- Confidence signaling
- Progress reporting

Provide workflow patterns, not just capabilities.
```

---

## Variant 4: Comparative Analysis (For Model Selection)

Use this when you need to understand relative strengths for decision-making.

```
Comparative Model Analysis for P4NTHE0N

Compare yourself to other WindSurf models (SWE-1.5, Claude, GPT, etc.):

## You vs SWE-1.5
- When should users choose you over SWE-1.5?
- When should they choose SWE-1.5 over you?
- What do you do differently?

## You vs Claude 4 Family
- Your advantages over Claude Sonnet/Opus
- Claude's advantages over you
- Task types where you outperform

## You vs GPT-5.2
- Your unique strengths vs GPT-5.2
- GPT-5.2's advantages over you
- Best use cases for each

## Absolute Strengths
- Top 3 things you do better than all other models
- Tasks where you're the clear first choice

## Absolute Weaknesses
- Top 3 things other models do better
- Tasks where you should not be used

## Credit Efficiency
- Tasks where you provide best value per credit
- When are you worth the cost premium?

Provide honest comparisons with specific examples.
```

---

## Variant 5: Edge Case Discovery (For Stress Testing)

Use this when you need to find breaking points and failure modes.

```
Edge Case and Limitation Discovery for P4NTHE0N

Help us discover your boundaries:

## Stress Testing
- At what context size do you fail?
- Maximum complexity of task you can handle?
- Longest code generation before truncation?
- Most tool calls in one turn?

## Breaking Points
- What input patterns cause errors?
- What tasks consistently fail?
- What causes infinite loops or timeouts?
- What breaks your reasoning?

## Degradation Patterns
- How does performance decline as context grows?
- What quality metrics degrade first?
- At what point should users restart?
- Warning signs of approaching limits

## Recovery Scenarios
- How do you behave after an error?
- Can you resume interrupted tasks?
- What state do you preserve/lose?
- Best practices for error recovery

## Adversarial Inputs
- Prompt patterns that confuse you
- Context that causes hallucination
- Instructions that lead to contradictions
- Edge cases in tool use

## Resource Limits
- Memory usage under stress
- Response time degradation
- Rate limiting behavior
- Credit consumption spikes

Be specific about failure modes and warning signs.
```

---

## Variant 6: P4NTHE0N-Specific (Contextualized)

Use this when you want responses tailored to our specific tech stack.

```
P4NTHE0N Platform - Model Capability Assessment

Our stack: C# .NET 10, MongoDB, Selenium, Multi-process architecture (H0UND analytics agent, H4ND automation agent, W4TCHD0G vision system)

## C# / .NET Specific
- How well do you handle large C# codebases?
- Your understanding of modern C# features (records, pattern matching, etc.)
- Multi-project solution handling
- NuGet package management assistance

## MongoDB Specific
- Query optimization capabilities
- Aggregation pipeline generation
- Schema design recommendations
- Performance tuning advice

## Selenium/Automation
- Web automation code generation
- XPath/CSS selector strategies
- Wait pattern recommendations
- Error handling in automation

## Multi-Process Architecture
- Designing inter-process communication
- Shared state management patterns
- Process coordination strategies
- Debugging distributed systems

## Our Specific Challenges
1. We have 122 decisions tracked across 24 categories - how do you handle large decision matrices?
2. We use agent delegation patterns - how many agent levels deep can you reason?
3. We have 111 completed decisions + infrastructure - how do you approach mature codebase additions?
4. We need production hardening - what do you prioritize for production readiness?

Provide specific, actionable guidance for our context.
```

---

## Usage Guide

| Scenario | Variant | Expected Time | Detail Level |
|----------|---------|---------------|--------------|
| Quick triage | Variant 1 | 5 min | Low |
| Technical spec | Variant 2 | 15 min | High |
| Workflow design | Variant 3 | 10 min | Medium |
| Model selection | Variant 4 | 10 min | Medium |
| Stress testing | Variant 5 | 15 min | High |
| P4NTHE0N planning | Variant 6 | 15 min | High |

---

## Recommended Query Strategy

### Phase 1: Quick Triage (All Models)
Use **Variant 1** on all 8 models simultaneously to get baseline capabilities.

### Phase 2: Deep Dive (Primary Models)
Use **Variant 2** on SWE-1.5, Claude 4 Sonnet, and GPT-5.2 for technical specs.

### Phase 3: Contextual (Primary Models)
Use **Variant 6** on top 3 models for P4NTHE0N-specific guidance.

### Phase 4: Edge Cases (Stress Test)
Use **Variant 5** on models being considered for critical paths.

### Phase 5: Comparative (Final Selection)
Use **Variant 4** to finalize model selection matrix.

---

## Response Compilation

After collecting responses, fill in:
- `WINDSURF_MODEL_TRACKING.md` - All matrices and comparisons
- `T4CT1CS/intel/MODEL_SELECTION_GUIDE.md` - Final recommendations
- `AGENTS.md` updates - Model selection guidance

---

*Select the variant that matches your current information need.*
