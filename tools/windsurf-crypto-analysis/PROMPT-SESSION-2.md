# WindSurf Session 2 Prompt

## PROMPT TO PASTE INTO WINDSURF:

```
Following up on our crypto analysis from the previous session.

I've created the analysis toolkit and am ready to execute. Before I run the tests, I need your guidance on optimization:

**Priority 1: Known Plaintext Injection**

You recommended this test phrase:
"THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG 12345"

Questions:
1. Should I use multiple 16-byte aligned phrases to maximize ECB detection probability? Like:
   - "AAAAAAAAAAAAAAAA" (16 bytes, all same character)
   - "BBBBBBBBBBBBBBBB" (16 bytes, different character)
   - "ABCDEFGHIJKLMNOP" (16 bytes, sequential)

2. How many test conversations should I create minimum to get statistically significant results?

3. After I copy the .pb files and run analysis, what specific output should I look for to confirm ECB vs rule it out?

**Priority 2: Memory Analysis (if ECB fails)**

4. When creating a memory dump with Process Hacker, should I:
   - Dump while typing in Cascade panel (active state)?
   - Dump immediately after sending a message?
   - Dump after closing the conversation but before closing WindSurf?

5. What are the most likely memory regions to contain unencrypted conversation data?
   - Process heap?
   - Stack of specific threads?
   - Shared memory sections?

**Goal**: I want to execute both tests efficiently. Give me the optimal sequence and what success looks like for each.
```

---

## WHY THIS PROMPT IS BETTER:

1. **References previous context** - WindSurf should remember the crypto analysis
2. **Specific questions** - Not open-ended, asks for concrete guidance
3. **Shows preparation** - You've created the toolkit, ready to execute
4. **Optimization focus** - Asks how to do it best, not just how to do it
5. **Clear success criteria** - Asks what output to look for

---

## ALTERNATIVE PROMPT (If WindSurf doesn't remember):

```
I'm analyzing WindSurf's conversation encryption (.pb files) using a "Rosetta Stone" approach.

**Context**: WindSurf uses AES encryption with per-UUID keys (7.95-7.98 bits/byte entropy). Breaking it directly is infeasible. I'm using side-channel analysis.

**My Toolkit**:
- Known plaintext injection to detect ECB mode
- Memory dump analysis to extract pre-encryption data
- Key derivation pattern analysis

**Current Phase**: Preparing to execute tests

**Questions**:

1. For ECB detection, should I use multiple 16-byte aligned test phrases ("AAAAAAAAAAAAAAAA", "BBBBBBBBBBBBBBBB") or single long phrase?

2. What's the minimum number of test conversations for statistical significance?

3. For memory dumps, optimal timing: during typing, after send, or before close?

4. Most likely memory regions: heap, stack, or shared sections?

5. If ECB detected, how do I derive the AES key from plaintext-ciphertext pairs?

I have the tools ready. Guide me through optimal execution.
```

---

## EXPECTED WINDSURF RESPONSE:

WindSurf should provide:
1. Specific test phrase recommendations
2. Optimal number of conversations (probably 3-5)
3. Clear ECB detection criteria (duplicate 16-byte blocks)
4. Memory dump timing guidance
5. Memory region priorities
6. Next steps based on results

This will set you up perfectly for Session 3 where you execute the tests and report results.
