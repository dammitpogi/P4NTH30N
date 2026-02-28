# WindSurf Model Query - Quick Reference Card

## 🚀 Start Here: Copy-Paste Prompts

### For Immediate Use (Copy This)

```
I am conducting a comprehensive analysis of AI model limitations for the P4NTHE0N platform, a multi-process C# automation system. 

Please provide detailed intelligence on:

1. CONTEXT WINDOW: What is your exact context limit? When do you degrade?
2. MEMORY: How do you handle long sessions? When do you forget?
3. CODE GENERATION: Max reliable output size? Multi-file capabilities?
4. REASONING: What tasks do you excel at? What causes errors?
5. TOOL USE: Tool call limits? Multi-tool workflow patterns?
6. PERFORMANCE: Response times? Credit costs? Resource usage?
7. ERRORS: Common failure modes? Recovery strategies?
8. OPTIMIZATION: Best prompt patterns? Task decomposition?
9. STRENGTHS: What do you do better than other models?
10. LIMITATIONS: What should users avoid? Known issues?

Be specific with numbers and technical details. This intelligence will optimize our development workflows.
```

---

## 📊 Models to Query (In Order)

### Tier 1: Query First (Parallel)
| Model | Why | Priority |
|-------|-----|----------|
| **SWE-1.5** | WindSurf's best, 950 tok/s | 🔴 Critical |
| **Claude 4 Sonnet** | 200K context, balanced | 🔴 Critical |
| **GPT-5.2** | Broad capabilities | 🔴 Critical |

### Tier 2: Query Second
| Model | Why | Priority |
|-------|-----|----------|
| **Claude 4 Opus** | Deep reasoning | 🟡 High |
| **Gemini 3 Pro** | Different architecture | 🟡 High |
| **DeepSeek-V3** | Cost-effective alt | 🟡 High |

### Tier 3: Query Last
| Model | Why | Priority |
|-------|-----|----------|
| **Cascade Base** | Free tier baseline | 🟢 Medium |
| **SWE-1** | Historical comparison | 🟢 Medium |

---

## 📋 Response Tracking

As you get responses, fill in:

### Quick Capture Template
```
Model: [NAME]
Date: [DATE]
Context Limit: [TOKENS/LINES]
Memory: [SESSION LENGTH]
Code Gen: [MAX SIZE]
Best For: [TASK TYPE]
Avoid: [TASK TYPE]
Key Finding: [ONE SENTENCE]
```

### File to Update
`T4CT1CS/intel/WINDSURF_MODEL_TRACKING.md`

---

## 🎯 What to Look For

### Red Flags (Critical Issues)
- [ ] Context window < 100 lines for code
- [ ] No multi-file edit capability
- [ ] Frequent truncation without warning
- [ ] High credit cost + low reliability
- [ ] No tool use or limited tool chain

### Green Flags (Ideal Characteristics)
- [ ] Clear context limit signaling
- [ ] Graceful degradation
- [ ] Good error messages
- [ ] Efficient credit usage
- [ ] Strong C# / .NET understanding

### Yellow Flags (Manageable Limitations)
- [ ] Requires task decomposition
- [ ] Needs periodic context refresh
- [ ] Slower on very large files
- [ ] Credit cost but high quality

---

## 📁 Files Created for You

| File | Purpose | Location |
|------|---------|----------|
| **Main Prompt** | Comprehensive 10-point query | `T4CT1CS/actions/pending/WINDSURF_MODEL_LIMITATIONS_PROMPT.md` |
| **Tracking Spreadsheet** | Response matrix & comparisons | `T4CT1CS/intel/WINDSURF_MODEL_TRACKING.md` |
| **Prompt Variants** | 6 specialized query formats | `T4CT1CS/actions/pending/WINDSURF_PROMPT_VARIANTS.md` |
| **Preliminary Research** | Known limitations from web | `T4CT1CS/intel/WINDSURF_LIMITATIONS_PRELIMINARY.md` |
| **This Quick Ref** | Copy-paste ready guide | `T4CT1CS/actions/pending/WINDSURF_QUICK_REFERENCE.md` |

---

## ⚡ Quick Start Checklist

- [ ] Copy the prompt above
- [ ] Open WindSurf Cascade
- [ ] Select SWE-1.5 model
- [ ] Paste prompt
- [ ] Capture response in tracking doc
- [ ] Repeat for Claude 4 Sonnet
- [ ] Repeat for GPT-5.2
- [ ] Fill in comparison matrix
- [ ] Make selection decision

---

## 💡 Pro Tips

1. **Query in parallel** - Open multiple WindSurf windows with different models
2. **Use same prompt** - Ensures comparable responses
3. **Capture immediately** - Don't rely on memory, fill tracking doc as you go
4. **Test claims** - If a model claims capability, verify with a test task
5. **Note surprises** - Document unexpected limitations or strengths

---

## 🎬 Next Actions After Queries

1. Compile responses into `WINDSURF_MODEL_TRACKING.md`
2. Create selection matrix for P4NTHE0N tasks
3. Update `AGENTS.md` with model guidance
4. Design workflows around limitations
5. Present findings to team

---

*Ready to start? Copy the prompt above and query your first model.*
