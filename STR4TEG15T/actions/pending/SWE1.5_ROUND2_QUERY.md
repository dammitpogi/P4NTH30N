# SWE-1.5 Discovery - Round 2: Edge Cases & Stress Testing

## Prompt to Send to SWE-1.5 (WindSurf)

```
SWE-1.5 Discovery - Round 2: Edge Cases, Stress Testing & Failure Modes

Based on Round 1 findings (128K context, 8K output, 50-60 turn retention), we need to understand your breaking points and failure modes for P4NTHE0N production planning.

## 1. EXACT CONTEXT LIMITS
- What happens when you hit exactly 128,000 tokens?
- Do you fail gracefully or truncate silently?
- What is the last 10% of context used for (system prompts, tool context)?
- How much usable context remains after system overhead?
- What is the exact token count where you begin losing the oldest messages?

## 2. LONG SESSION BEHAVIOR
- What happens beyond 60 turns? Do you crash, degrade, or reset?
- Can you maintain coherence across 100+ turns with explicit context refresh?
- What is the longest successful session you have observed?
- How do you behave when given a "context summary" mid-session?
- Do you recognize when you have lost important context?

## 3. COMPLEX REFACTORING STRESS TEST
- What happens when asked to refactor 20+ files simultaneously?
- Do you maintain consistency across all files or lose track?
- What is the maximum complexity of cross-file dependencies you can handle?
- How do you handle circular dependencies during refactoring?
- What causes you to give up on large refactoring tasks?

## 4. CODE GENERATION EDGE CASES
- What happens when you cannot complete a method within output limits?
- Do you signal truncation or just stop mid-line?
- How do you handle generation of very long switch statements or enums?
- What is the longest single method you can generate completely?
- How do you handle nested class hierarchies (5+ levels deep)?

## 5. TOOL USE FAILURE MODES
- What happens when 3+ tool calls fail simultaneously?
- Do you retry automatically, ask for help, or abort?
- What is the maximum tool chain depth you can execute?
- How do you handle tool results that exceed your context window?
- What causes you to enter infinite tool call loops?

## 6. ERROR RECOVERY PATTERNS
- When you make a mistake, can you self-correct?
- What error patterns do you repeat consistently?
- How should users prompt you to recover from errors?
- Do you learn from corrections within a session?
- What errors require human intervention vs automatic retry?

## 7. C# SPECIFIC EDGE CASES
- How do you handle files with 10,000+ lines?
- What happens with deeply nested generics (Func<Func<Func<T>>>...)?
- Can you work with complex LINQ expressions (10+ chained methods)?
- How do you handle code with heavy preprocessor directives?
- What causes you to misunderstand C# async/await patterns?

## 8. PERFORMANCE UNDER STRESS
- How does response time change at 90% vs 50% context usage?
- What is the slowest response you have generated?
- Do you have different quality levels under load?
- What causes you to timeout or hang?
- How do you prioritize when overwhelmed with requests?

## 9. COMPARATIVE BEHAVIOR
- What tasks cause you to fail where Claude 4 succeeds?
- What tasks do you handle better than GPT-5.2?
- When should users definitely NOT choose you?
- What is your "sweet spot" task complexity?
- What tasks require breaking into sub-tasks for you?

## 10. PRODUCTION READINESS
- What monitoring would you recommend for your usage?
- What early warning signs indicate approaching limits?
- How should users design fallback strategies for your failures?
- What is your reliability percentage for complex tasks?
- What guarantees can you provide for production use?

## RESPONSE FORMAT
Provide specific examples, exact numbers, and observed behaviors. Include "I don't know" where applicable rather than guessing.

This intelligence determines whether SWE-1.5 is production-ready for P4NTHE0N.
```

---

## Alternative: Quick Stress Test Prompt

If you prefer a shorter discovery:

```
SWE-1.5 Stress Test - Quick Discovery

Based on your 128K context and 50-60 turn limits:

1. What exact error occurs at context limit? (crash/truncate/degrade)
2. Maximum files you can refactor reliably? (tested number)
3. Longest code generation before truncation? (lines observed)
4. Tool failure recovery - automatic or manual?
5. Slowest response time observed? (seconds)
6. What task types consistently fail?
7. When should users choose Claude over you?
8. Production reliability percentage estimate?

Provide observed behaviors, not theoretical limits.
```

---

## Discovery Goals for Round 2

### Critical Questions to Answer

| Question | Why It Matters |
|----------|---------------|
| Exact failure mode at 128K | Determines buffer requirements |
| Behavior beyond 60 turns | Impacts long-running workflows |
| 20+ file refactor capability | Affects P4NTHE0N codebase management |
| Truncation signaling | Prevents silent data loss |
| Tool failure recovery | Impacts agentic workflow reliability |
| Self-correction ability | Determines error handling needs |
| C# edge case handling | Validates language proficiency |
| Performance degradation | Informs timeout configurations |
| Comparative weaknesses | Guides model selection |
| Production reliability | Go/no-go decision factor |

### Expected Outcomes

**Green Light Scenarios:**
- Graceful degradation at limits
- Clear error signaling
- Successful 20+ file coordination
- Automatic recovery from tool failures
- Self-correction capability

**Red Light Scenarios:**
- Silent truncation
- Session crashes beyond 60 turns
- Inconsistent multi-file edits
- Infinite loops on tool failures
- No error recovery

---

## Post-Discovery Actions (After All Rounds Complete)

Only after Round 2 responses are received:

1. **Compile findings** into comprehensive assessment
2. **Make go/no-go decision** for SWE-1.5 production use
3. **If GO:** Create decisions for workflow optimization
4. **If NO-GO:** Research alternative models
5. **Document** production guidelines based on actual limits

---

*Send this prompt to SWE-1.5 and capture the response. This completes the discovery phase before any decisions are created.*
