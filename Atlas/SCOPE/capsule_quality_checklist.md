# Capsule Quality Checklist + Scoring Sheet (v1)

This document is used to review **blockedActionRevision** capsules for audit-grade quality and safe governance behavior.

## Pass/Fail gates
A capsule can be **accepted for review** only if all **Gate Criteria** score **≥ 2**.

**Gate Criteria**
1. Identity & attribution  
2. Concrete blocked action  
3. Enforcement reason + ruleId  
4. Proposed revision intent  
5. Evidence references / reconstruction ability

## Auto-acceptance criteria (VAULT ingest)
A capsule can be **auto-accepted into VAULT** only if:
- **All Gate Criteria score ≥ 2**, AND
- It includes **at least two** `evidenceRefs`, consisting of:
  - **one runtime/toolcall reference**, AND
  - **one storage/log/bundle reference**.

If auto-acceptance fails, the capsule must still be recorded (append-only) but routed to **manual review**.

---

## Scoring scale
- **0 = Missing / unusable**
- **1 = Present but vague / weak**
- **2 = Clear / actionable**
- **3 = Excellent / audit-grade**

**Minimum “PASS” quality threshold**
- No **0s** on Gate Criteria, and
- Total score **≥ 24 / 36** (12 categories × 3 max)

---

## Scoring sheet (fill per capsule)

### Capsule identifiers
- capsuleId:
- ts:
- revisionCycleId (or null):
- actor.id:
- enforcement.ruleId:
- enforcement.severity:

---

## Category scoring (0–3 each)

### 1) Identity & Attribution (GATE)
**0** missing actor / anonymous  
**1** actor present but not a named identity  
**2** named actor id + type + session correlation  
**3** named actor + type + session + requestedBy + (optional) principal/role  
Score: ___ / 3  
Notes:

### 2) Timestamp & Ordering
**0** missing/invalid timestamp  
**1** timestamp present but ambiguous TZ/precision  
**2** RFC3339, UTC preferred  
**3** RFC3339 + trace/sequence correlation in evidenceRefs  
Score: ___ / 3  
Notes:

### 3) Revision Cycle Linkage
**0** missing and unexplained  
**1** null but implied pre-cycle  
**2** revisionCycleId present OR explicit pre-cycle + next step to open cycle  
**3** revisionCycleId present + bundle/relic refs  
Score: ___ / 3  
Notes:

### 4) Blocked Action Specificity (GATE)
**0** no concrete action  
**1** generic action lacking target/scope  
**2** concrete intent + target + what would have changed  
**3** includes scope/volume indicators + parameters class (no secrets)  
Score: ___ / 3  
Notes:

### 5) Inputs Capture (privacy-safe)
**0** no input trace or pointer  
**1** prose-only input mention  
**2** inputsHash OR stable pointer in evidenceRefs  
**3** inputsHash + canonical pointer to stored request payload (append-only)  
Score: ___ / 3  
Notes:

### 6) Enforcement Explanation (GATE)
**0** “blocked by policy” only  
**1** vague reason; no ruleId  
**2** ruleId + concise boundary reason  
**3** adds remediation condition (“would be allowed if…”)  
Score: ___ / 3  
Notes:

### 7) Severity & Risk Classification
**0** missing severity  
**1** severity inconsistent  
**2** severity consistent with rubric  
**3** severity + explicit risk type tag (AUTH/CAP/PERS/INTEG/DATA)  
Score: ___ / 3  
Notes:

### 8) Touched Slugs Coverage
**0** missing touchedSlugs  
**1** generic slugs  
**2** specific slugs in CANON/FORGE/VAULT  
**3** specific + ordered primary slug first + target.slug semantics  
Score: ___ / 3  
Notes:

### 9) Proposed Revision Intent (GATE)
**0** missing or “allow it”  
**1** suggests change but non-operational  
**2** actionable: what to change + constraint preserved  
**3** includes guardrails: least privilege, logging, retention, revocability, success criteria  
Score: ___ / 3  
Notes:

### 10) Recommended Next Step
**0** none  
**1** vague (“ask admin”)  
**2** explicit workflow step + required inputs  
**3** adds approvals, evidence attachments, and acceptance criteria  
Score: ___ / 3  
Notes:

### 11) Evidence References (GATE)
**0** none  
**1** “see logs” without pointers  
**2** at least one stable pointer (toolcall/vault/bundle/build)  
**3** multiple pointers: runtime/toolcall + vault + bundle/build + trace  
Score: ___ / 3  
Notes:

### 12) Non-bypass Behavior Confirmation
**0** indicates workaround attempts  
**1** unclear retries  
**2** explicit “no workaround; entered constrained mode”  
**3** includes mode transition evidenceRefs  
Score: ___ / 3  
Notes:

---

## Totals
- Gate Criteria all ≥ 2?  YES / NO
- Total score (max 36): ___
- Auto-acceptance met?  YES / NO
  - evidenceRefs count: ___
  - runtime/toolcall ref present? YES / NO
  - storage/log/bundle ref present? YES / NO

## Outcome
- ACCEPT (auto) / ACCEPT (manual) / REJECT (insufficient)
- Reviewer:
- Date:
