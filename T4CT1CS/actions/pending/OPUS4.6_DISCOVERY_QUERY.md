# Opus 4.6 Discovery Query - Code Development Focus

## Prompt to Send to Opus 4.6 (WindSurf)

```
Opus 4.6 Discovery: Code Development Capabilities & Cost Efficiency

We are evaluating Opus 4.6 for production C# development on the P4NTH30N platform (10 projects, 122 decisions). SWE-1.5 has been designated for non-code tasks. We need to understand when Opus 4.6 is worth the cost premium.

## 1. CONTEXT WINDOW & CODEBASE SCALE
- What is your exact context window size?
- How many C# files can you effectively analyze simultaneously?
- What is the largest solution (projects/files) you can work with?
- How do you handle solutions with 50+ projects like P4NTH30N?
- What is your practical limit for cross-project refactoring?

## 2. CODE GENERATION QUALITY
- How does your code quality compare to SWE-1.5?
- What is the maximum reliable code generation size?
- Do you produce more maintainable code than SWE-1.5?
- How do you handle complex generic constraints?
- What C# features do you excel at (async/await, LINQ, patterns)?

## 3. REFACTORING CAPABILITIES
- How many files can you refactor reliably in one session?
- Do you maintain consistency better than SWE-1.5 across files?
- How do you handle breaking changes across projects?
- What is your strategy for large-scale architectural changes?
- Can you perform complex rename operations across 20+ files?

## 4. ARCHITECTURAL DECISIONS
- How do you approach system design decisions?
- Can you analyze trade-offs between architectural patterns?
- How do you handle greenfield vs brownfield development?
- What is your capability for API design and contract definition?
- How do you evaluate technical debt and propose solutions?

## 5. DEBUGGING & PROBLEM SOLVING
- How do you approach complex bug investigation?
- Can you trace issues across multiple projects?
- What is your strategy for race condition analysis?
- How do you handle performance optimization tasks?
- Can you analyze memory leaks and resource issues?

## 6. TESTING & QUALITY ASSURANCE
- How do you approach test generation?
- Can you create integration tests across project boundaries?
- What is your capability for edge case identification?
- How do you handle test coverage analysis?
- Can you generate meaningful test data?

## 7. COST EFFICIENCY ANALYSIS
- What tasks justify your cost premium over SWE-1.5?
- When is it more cost-effective to use SWE-1.5 instead?
- What is your efficiency for different task types (generation vs analysis)?
- How can users minimize costs while using you effectively?
- What task sizes provide best value per credit?

## 8. COMPARATIVE ADVANTAGES
- What do you do significantly better than SWE-1.5?
- What tasks require your capabilities vs SWE-1.5?
- When is the cost difference worth the quality improvement?
- What is your unique value proposition for C# development?
- What tasks should always use you regardless of cost?

## 9. FAILURE MODES & LIMITATIONS
- What causes you to fail where SWE-1.5 succeeds?
- What are your known blind spots in C# development?
- How do you handle tasks beyond your capabilities?
- What early warning signs indicate you are struggling?
- When should users escalate to human developers?

## 10. PRODUCTION WORKFLOW RECOMMENDATIONS
- How should we structure workflows to maximize your value?
- What is the optimal task size for cost efficiency?
- How should we partition work between you and SWE-1.5?
- What monitoring should we implement for your usage?
- What fallback strategies should we design?

## RESPONSE FORMAT
Provide specific comparisons to SWE-1.5 where applicable. Include concrete numbers, observed behaviors, and cost-benefit analysis. Focus on when Opus 4.6 is worth the premium vs when SWE-1.5 is sufficient.

This intelligence determines our Opus 4.6 usage strategy for P4NTH30N development.
```

---

## SWE-1.5 Summary for Comparison

From Round 1 & 2 discoveries:

| Capability | SWE-1.5 Finding | Opus 4.6 Question |
|------------|----------------|-------------------|
| Context | 115,200 usable | How much larger? |
| Multi-file | 5-8 reliable, 12-15 max | Better consistency? |
| Code quality | Good for tactical | Superior architecture? |
| Refactoring | 12-15 files before loss | 20+ file capability? |
| Cost | Free | Worth premium when? |
| Reliability | 85-90% medium, 60-70% high | Higher reliability? |

---

## Expected Discoveries

### Cost Justification Scenarios
- Complex architectural decisions
- Large-scale refactoring (>15 files)
- Greenfield system design
- Complex debugging scenarios
- API contract design

### SWE-1.5 Sufficiency Scenarios
- Single-file changes
- Simple refactoring (<10 files)
- Code analysis and review
- Test generation
- Documentation

---

## Post-Discovery Decision Framework

After Opus 4.6 response, determine:

**Opus 4.6 Required:**
- [ ] Tasks where quality justifies cost
- [ ] Capabilities SWE-1.5 cannot provide
- [ ] Failure modes requiring Opus

**SWE-1.5 Sufficient:**
- [ ] Tasks where SWE-1.5 performs adequately
- [ ] Cost savings opportunities
- [ ] Workflow partitioning strategy

**Hybrid Strategy:**
- SWE-1.5 for: Initial analysis, simple changes, tool coordination
- Opus 4.6 for: Architecture, complex refactoring, debugging

---

*Send this prompt to Opus 4.6 to complete the model discovery phase.*
