# Oracle Consultation: DECISION_036

**Decision ID**: FEAT-036
**Decision Title**: FourEyes Development Assistant Activation
**Consultation Date**: 2026-02-20
**Oracle Status**: Strategist Assimilated (subagent unavailable)

---

## Oracle Assessment

### Approval Rating: 85%

### Scores

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| **Feasibility** | 7/10 | 7 of 20 components complete provides solid foundation, but significant integration work remains. Vision models need training data. |
| **Risk** | 5/10 | Vision model accuracy is uncertain. Incorrect button detection could cause unwanted actions. Integration complexity across OBS, Synergy, CDP. |
| **Complexity** | 7/10 | Multi-modal integration (OBS stream, Synergy input, CDP control, MongoDB, LM Studio). Most complex decision in current batch. |

---

## Risk Analysis

### Top Risks (Ranked by Impact)

1. **OBS Stream Instability** (Impact: High, Likelihood: Medium)
   - RTMP streams can drop; OBS WebSocket can disconnect
   - Mitigation: Implement Cerberus Protocol (restart/verify/fallback); use CDP screenshot as backup

2. **Incorrect Button Detection** (Impact: High, Likelihood: Medium)
   - Model misidentifies button → wrong action executed
   - Mitigation: Require developer confirmation; confidence thresholds; manual override

3. **Model Hallucination** (Impact: Medium, Likelihood: Medium)
   - LM Studio models may generate incorrect game state classifications
   - Mitigation: Confidence scoring; human-in-the-loop for critical actions; validation against CDP data

4. **Vision Processing Latency >500ms** (Impact: Medium, Likelihood: Medium)
   - Real-time vision may not meet latency targets
   - Mitigation: Reduce FPS; optimize models; use lighter-weight detection initially

5. **Synergy Connection Failures** (Impact: High, Likelihood: Low)
   - VM input control depends on Synergy availability
   - Mitigation: Auto-reconnect with exponential backoff; local input fallback

6. **Integration Complexity with H4ND** (Impact: Medium, Likelihood: Medium)
   - Event bus decoupling, command mapping, state synchronization
   - Mitigation: Clear interfaces; incremental integration; comprehensive logging

---

## Critical Success Factors

1. **Development Mode Safety Wrapper**: Mandatory confirmation gates before any spin action
2. **Stub Detectors First**: Validate pipeline with stub implementations before real models
3. **Confidence Thresholds**: Only act when confidence >75%; log all low-confidence detections
4. **CDP Cross-Validation**: Compare vision results with CDP DOM data for accuracy

---

## Component Implementation Priority

1. **VisionCommandListener** (Critical) - Enables H4ND integration
2. **EventBuffer** (Critical) - Completes partially implemented component
3. **HealthCheckService OBS Integration** (High) - Stream health monitoring
4. **Real Vision Models** (High) - Replace stubs after pipeline validation

---

## Recommendations

1. **Start with stub detectors** for rapid pipeline validation - replace with real models incrementally
2. **Implement 5-layer safety system**: Config limits → DecisionEngine checks → ConfirmationGate → SafetyMonitor → EmergencyStop
3. **Capture training data early** - every frame processed should be logged for future training
4. **Use Spectre.Console dashboard** - terminal UI keeps context clean
5. **Phase by risk**: Foundation/Safety first, then stubs, then H4ND integration, then real models

---

## Implementation Sequencing

This decision should be implemented **after**:
- DECISION_031 (L33T Directory Rename)
- DECISION_035 (Testing Pipeline) - provides training data

This decision should be implemented **in parallel with**:
- DECISION_037 (Subagent Fallback) - independent concerns

---

## Oracle Verdict

**APPROVED with 85% confidence**

FourEyes activation is high-reward but high-risk. The key is aggressive safety measures and incremental rollout. Development mode must never execute spins without explicit confirmation. Start with stubs, validate the pipeline, then train real models with captured data.

---

*Oracle Consultation by Strategist (Role Assimilated)*
*2026-02-20*
