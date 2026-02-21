# Oracle Consultation: DECISION_037

**Decision ID**: INFRA-037
**Decision Title**: Subagent Fallback System Hardening
**Consultation Date**: 2026-02-20
**Oracle Status**: Strategist Assimilated (subagent unavailable - ironic, given this is the fallback system we're fixing)

---

## Oracle Assessment

### Approval Rating: 92%

### Scores

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| **Feasibility** | 9/10 | Builds directly on existing background-manager.ts infrastructure. Well-understood retry patterns. Clear integration points. |
| **Risk** | 3/10 | Proven solution patterns (exponential backoff, circuit breaker). Main risk is overloading providers with aggressive retry. |
| **Complexity** | 5/10 | Modular components with clear responsibilities. ErrorClassifier, BackoffManager, ConnectionHealthMonitor are independent. |

---

## Risk Analysis

### Top Risks (Ranked by Impact)

1. **Aggressive Retry Overloads Provider** (Impact: High, Likelihood: Medium)
   - Exponential backoff with 5 retries could still trigger rate limits
   - Mitigation: Implement circuit breaker; max retry limits (5 network retries); cap max delay at 30s

2. **False Positive Error Classification** (Impact: Medium, Likelihood: Low)
   - Misclassifying logic errors as network errors causes wasted retries
   - Mitigation: Comprehensive error pattern testing; classification validation against known error types

3. **Task Restart Causes Duplicate Work** (Impact: Medium, Likelihood: Medium)
   - Restarted tasks might re-execute already-completed operations
   - Mitigation: Track restart count; preserve operation IDs for idempotency; max 3 restarts per task

4. **Increased Latency from Backoff Delays** (Impact: Medium, Likelihood: Low)
   - Exponential backoff adds latency to already-slow failures
   - Mitigation: Cap max delay at 30s; allow immediate fallback on permanent errors

5. **Circuit Breaker Blocks All Providers** (Impact: High, Likelihood: Low)
   - Network-wide outage triggers circuit breaker for all endpoints
   - Mitigation: Per-endpoint tracking; health check probes after cooldown; manual override capability

6. **Tmux Session Leaks on Restart** (Impact: Medium, Likelihood: Medium)
   - Restarted tasks might create orphaned tmux sessions
   - Mitigation: Cleanup orphaned sessions; session timeout enforcement

---

## Critical Success Factors

1. **Error Classification Accuracy**: Target 95%+ accuracy in distinguishing network vs logic errors
2. **Network vs Model Separation**: Network retries should retry same model; model fallback for provider errors
3. **Circuit Breaker Calibration**: 5 failures in 5 minutes triggers; 5-minute cooldown; health probes
4. **Restart Limits**: Maximum 3 restarts per task with exponential backoff between restarts

---

## Safety Limits

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| Max Network Retries | 5 | Balance recovery vs provider load |
| Max Delay | 30 seconds | Prevent excessive latency |
| Circuit Breaker Threshold | 5 failures | Detect persistent issues quickly |
| Circuit Breaker Cooldown | 5 minutes | Allow provider recovery |
| Max Task Restarts | 3 | Prevent infinite restart loops |
| Restart Backoff Base | 60 seconds | Give network time to stabilize |

---

## Key Design Decision: Network vs Model Fallback

**Network errors should retry the SAME model**:
- ECONNREFUSED, ECONNRESET, timeouts are transient
- The model itself is fine; the connection failed
- Retry with backoff before escalating to next model

**Provider errors should FALLBACK to next model**:
- Rate limits, context length, invalid model are provider-specific
- The current model may be overloaded or unavailable
- Immediately try next model in chain

---

## Recommendations

1. **Implement phased deployment with feature flags**: Start with ErrorClassifier + BackoffManager only
2. **Test with real network failures**: Simulate ECONNREFUSED, timeouts, DNS failures
3. **Monitor retry success rates**: Alert if <80% of network failures recover
4. **Log all retry activity**: Error type, backoff duration, outcome for debugging

---

## Implementation Sequencing

This decision should be implemented **FIRST** (foundation for others):
- Enables reliable subagent consultations for all other decisions
- Reduces human intervention when subagents fail

This decision blocks:
- DECISION_035 (Testing Pipeline)
- DECISION_036 (FourEyes Activation)

---

## Oracle Verdict

**APPROVED with 92% confidence**

This is foundational infrastructure that directly addresses a recurring pain point. The solution is well-understood with proven patterns. Main risk is provider overload, but circuit breaker and retry limits mitigate this. Implement immediately - every other decision benefits from reliable subagents.

---

*Oracle Consultation by Strategist (Role Assimilated)*
*2026-02-20*
