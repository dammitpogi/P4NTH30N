# WindSurf Model Limitations Intelligence Gathering Prompt

## Purpose
Gather comprehensive intelligence on model-specific limitations, capabilities, and optimization strategies from multiple WindSurf Cascade models to inform P4NTHE0N development decisions.

## Prompt to Send to Each Model

```
I am conducting a comprehensive analysis of AI model limitations and capabilities for the P4NTHE0N platform, a multi-process automation system built in C#. I need you to provide detailed intelligence on your specific limitations, strengths, and optimization strategies.

Please provide a comprehensive response covering:

### 1. CONTEXT WINDOW & TOKEN LIMITATIONS
- What is your exact context window size (in tokens)?
- At what point do you begin experiencing context compression or loss?
- How do you handle conversations that exceed your context window?
- What is your output token limit per response?
- Do you have different limits for different modes (chat vs agentic)?

### 2. MEMORY & STATE MANAGEMENT
- How do you maintain context across long sessions?
- What causes you to "forget" earlier parts of a conversation?
- How should users structure prompts to maximize your memory retention?
- Do you have any known issues with context drift over time?

### 3. CODE GENERATION LIMITATIONS
- What is the maximum size of code you can generate in a single response?
- Do you have limitations on multi-file edits?
- How do you handle large refactoring tasks across many files?
- What causes you to stop mid-generation or truncate output?
- How should large tasks be broken down for optimal results?

### 4. REASONING & ANALYSIS CAPABILITIES
- What types of reasoning tasks do you excel at?
- What types of tasks cause you difficulty or errors?
- How do you handle complex multi-step logic?
- Do you have any known blind spots in analysis?

### 5. TOOL USE & AGENTIC BEHAVIOR
- How many tool calls can you make in a single turn?
- Do you have rate limiting or throttling considerations?
- What causes you to fail or error during agentic workflows?
- How should complex multi-tool workflows be structured?

### 6. PERFORMANCE CHARACTERISTICS
- What is your typical response time for different task types?
- Do you have different performance modes (speed vs quality)?
- How does context size affect your response time?
- What tasks cause you to slow down significantly?

### 7. ERROR PATTERNS & FAILURE MODES
- What are your most common failure modes?
- How do you signal when you've reached a limitation?
- What errors should users watch for?
- How can users recover from your limitations?

### 8. OPTIMIZATION STRATEGIES
- How should users structure large projects for best results with you?
- What prompt patterns maximize your effectiveness?
- How should complex tasks be decomposed?
- What context should be provided upfront vs discovered?

### 9. COMPARATIVE ADVANTAGES
- What do you do better than other models?
- What tasks should users specifically choose you for?
- What are your unique strengths?

### 10. KNOWN ISSUES & WORKAROUNDS
- What known bugs or issues exist?
- Are there any documented workarounds?
- What should users avoid asking you to do?

Please be specific, technical, and honest about your limitations. This intelligence will be used to optimize our development workflows and select appropriate models for different tasks.
```

## Models to Query

Based on research, query these WindSurf models:

### Tier 1: Primary Models (Query First)
1. **SWE-1.5** - WindSurf's flagship agentic coding model
   - 950 tokens/sec generation speed
   - Near Claude 4.5-level performance
   - Optimized for software engineering tasks

2. **Claude 4 Sonnet** - Balanced performance/cost
   - 200K context window (BYOK)
   - Strong reasoning capabilities
   - Good for complex analysis

3. **GPT-5.2** - Latest OpenAI model
   - Strong code generation
   - Good tool use capabilities
   - Medium reasoning effort option

### Tier 2: Specialized Models (Query Second)
4. **Claude 4 Opus** - Deep reasoning
   - Largest context window (BYOK)
   - Best for complex architecture decisions
   - Higher credit cost

5. **Gemini 3 Pro** - Google's latest
   - Different architectural approach
   - May have different limitations
   - Good for comparison

6. **DeepSeek-V3/R1** - Alternative architecture
   - Open weights model
   - May have unique characteristics
   - Cost-effective option

### Tier 3: Baseline Models (Query for Comparison)
7. **Cascade Base** - WindSurf's free tier model
   - Llama 3.1 70B based
   - Local execution capability
   - Baseline for comparison

8. **SWE-1** - Original WindSurf model
   - Claude 3.5-level performance
   - Established patterns
   - Good historical comparison

## Execution Strategy

### Phase 1: Parallel Query (Models 1-3)
Send the prompt simultaneously to SWE-1.5, Claude 4 Sonnet, and GPT-5.2. These are the primary workhorses and their limitations are most critical.

### Phase 2: Deep Dive (Models 4-6)
Query Claude 4 Opus, Gemini 3 Pro, and DeepSeek for specialized capabilities and edge cases.

### Phase 3: Baseline (Models 7-8)
Query Cascade Base and SWE-1 to understand free tier limitations and establish baselines.

## Expected Discoveries

Based on preliminary research, anticipate these limitation categories:

### Context Window Reality
- Documented: 200K tokens (Claude), 32K tokens (GPT), 200 lines (Windsurf community reports)
- Reality: Effective context may be smaller due to system prompts and tool context
- Compression: Models may summarize or drop older context without warning

### Memory & Drift
- AI Drift: Models lose track of guidelines over long sessions
- Recency Bias: Newer instructions weighted more heavily
- Context Interference: New prompts may contradict previous instructions

### Code Generation Limits
- Output Truncation: Large generations may stop mid-file
- Multi-File: Complex multi-file edits may require manual coordination
- Token Limits: Output often capped at 4K tokens even with larger context windows

### Performance Variations
- Speed vs Quality: SWE-1.5 at 950 tok/s vs Claude's deeper reasoning
- Credit Costs: Different models consume different credit amounts
- Rate Limiting: Free tiers have strict limits

## Analysis Framework

After collecting responses, analyze for:

1. **Common Limitations** - Issues all models share
2. **Model-Specific Strengths** - Unique advantages per model
3. **Optimization Patterns** - Best practices that emerge
4. **Failure Mode Matrix** - What fails on which models
5. **Selection Criteria** - When to use which model

## Documentation

Compile findings into:
- `T4CT1CS/intel/WINDSURF_MODEL_LIMITATIONS.md` - Comprehensive analysis
- `T4CT1CS/intel/MODEL_SELECTION_GUIDE.md` - Decision matrix
- `T4CT1CS/speech/2026-02-18TXX-00-00-MODEL-INTELLIGENCE.md` - Executive summary

## Key Questions to Answer

1. Which model is best for large-scale refactoring?
2. Which model handles multi-file agentic workflows best?
3. What is the practical context limit for each model?
4. How should we structure prompts for maximum effectiveness?
5. What are the failure patterns we need to design around?
6. Which models should be primary vs fallback?
7. How do we optimize credit usage across models?

## Success Criteria

- [ ] All 8 models queried
- [ ] Limitations documented per model
- [ ] Comparative analysis completed
- [ ] Selection criteria established
- [ ] Optimization strategies identified
- [ ] Failure modes catalogued
