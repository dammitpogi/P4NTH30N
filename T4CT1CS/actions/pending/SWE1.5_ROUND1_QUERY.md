# SWE-1.5 Discovery Query - Round 1

## Prompt to Send to WindSurf (SWE-1.5 Model)

```
SWE-1.5 Model Discovery - Round 1: Core Capabilities & Limitations

I am evaluating SWE-1.5 for the P4NTH30N platform, a production C# automation system with 122 tracked decisions. This is the first of multiple discovery rounds.

Please provide specific, technical answers to these questions:

## 1. CONTEXT WINDOW SPECIFICATIONS
- What is your exact input context window size in tokens?
- What is your maximum output token limit per response?
- At what context threshold do you begin compressing or dropping earlier content?
- How do you handle conversations that approach your context limit?
- What is the practical context limit for C# code (lines, files, or tokens)?

## 2. MEMORY & STATE MANAGEMENT
- How many conversation turns before you begin losing earlier context?
- Do you summarize or compress older messages automatically?
- What causes you to "forget" instructions from earlier in the conversation?
- How should users structure long sessions to maintain context?
- Do you have different behavior in Flow mode vs standard chat?

## 3. CODE GENERATION LIMITS
- What is the maximum size of code you can generate reliably in one response?
- Do you truncate output without warning? What are the signs?
- How do you handle multi-file code generation requests?
- What is the largest C# class or method you can generate completely?
- Do you have different limits for different programming languages?

## 4. MULTI-FILE EDIT CAPABILITIES
- Can you edit multiple files in a single turn?
- What is the maximum number of files you can modify in one session?
- How do you handle cross-file dependencies during edits?
- Do you maintain consistency across multiple file changes?
- What is your strategy for large refactoring tasks across many files?

## 5. TOOL USE & AGENTIC BEHAVIOR
- How many tool calls can you make in a single turn?
- Do you support parallel tool execution or only sequential?
- What happens when a tool call fails? Do you retry, abort, or ask?
- How do you handle long-running tool operations?
- What is the maximum complexity of agentic workflow you can execute?

## 6. PERFORMANCE CHARACTERISTICS
- What is your typical response time for different task types?
- How does context size affect your generation speed?
- Do you have different performance modes (speed vs quality)?
- What tasks cause you to slow down significantly?
- How do you prioritize when given multiple instructions?

## 7. ERROR PATTERNS & FAILURE MODES
- What are your most common failure modes?
- How do you signal when you've reached a limitation?
- What errors should users watch for specifically?
- How can users recover from your limitations?
- Do you have known bugs or issues with specific task types?

## 8. C# / .NET SPECIFIC CAPABILITIES
- How well do you handle large C# solutions (50+ projects)?
- What is your understanding of modern C# features (records, pattern matching, nullable reference types)?
- Can you work with .NET 10 and C# 13 features?
- How do you handle complex generic constraints and type inference?
- What is your capability with async/await patterns and threading?

## 9. OPTIMIZATION STRATEGIES
- What prompt structure maximizes your effectiveness?
- How should large tasks be broken down for best results?
- What context should be provided upfront vs discovered incrementally?
- How should users format code requests for optimal generation?
- What patterns help you maintain accuracy across long sessions?

## 10. COMPARATIVE POSITIONING
- What tasks do you do better than Claude 4 Sonnet?
- What tasks do you do better than GPT-5.2?
- When should users choose SWE-1.5 over other models?
- When should users choose a different model over you?
- What is your unique value proposition?

## RESPONSE FORMAT
Provide numbered answers with specific numbers, technical details, and concrete examples. Avoid general statements. If you don't know exact specs, state your observed behavior.

This intelligence will directly impact P4NTH30N development workflow design.
```

---

## Expected Response Capture

After receiving the response, extract and document:

### Critical Numbers to Capture
| Metric | SWE-1.5 Response | Impact on P4NTH30N |
|--------|-----------------|-------------------|
| Context Window (tokens) | | |
| Output Limit (tokens) | | |
| Practical Code Limit (lines) | | |
| Max Files Per Session | | |
| Tool Calls Per Turn | | |
| Response Time (avg) | | |
| Session Length (turns) | | |

### Red Flags to Watch For
- [ ] Context window < 50 lines for code
- [ ] No multi-file edit capability
- [ ] Silent truncation
- [ ] No tool use support
- [ ] Poor C# understanding

### Green Flags to Confirm
- [ ] Clear context limit signaling
- [ ] Multi-file edit support
- [ ] Good C# / .NET knowledge
- [ ] Agentic workflow capability
- [ ] Graceful degradation

---

## Post-Query Actions

1. **Capture response** in `T4CT1CS/intel/SWE1.5_DISCOVERY_ROUND1.md`
2. **Extract key numbers** into tracking spreadsheet
3. **Identify limitations** requiring decisions
4. **Design Round 2** prompts based on gaps
5. **Create decisions** for workflow adaptations

---

## Decision Triggers

Based on response, create decisions for:

**If context window is small (< 100 lines):**
- Decision: Task decomposition strategy
- Decision: Context refresh protocols
- Decision: File size limits

**If multi-file edits are limited:**
- Decision: Single-file workflow patterns
- Decision: Manual coordination procedures
- Decision: Batch edit strategies

**If C# capabilities are weak:**
- Decision: Code review requirements
- Decision: Additional validation steps
- Decision: Fallback to other models

**If tool use is limited:**
- Decision: Tool call batching
- Decision: Manual tool execution
- Decision: Hybrid human-AI workflows

---

*Send this prompt to SWE-1.5 now. Capture the response and return for Round 2 design.*
