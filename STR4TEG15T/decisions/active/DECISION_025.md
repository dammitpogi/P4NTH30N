# DECISION_025: Atypicality-Based Anomaly Detection for Jackpot Patterns

**Decision ID**: DECISION_025
**Category**: Analytics
**Status**: Implemented
**Priority**: High
**Date**: 2026-02-20
**Oracle Approval**: 98%
**Designer Approval**: Approved

---

## Executive Summary

Implement parameter-free anomaly detection using atypicality theory to identify unusual jackpot patterns, game malfunctions, and data corruption. Uses compression-based atypicality scoring on sliding windows of jackpot values.

**Current Problem**:
- No anomaly detection exists in the system
- Unusual patterns go unnoticed until they cause prediction failures
- Data corruption and game malfunctions are only discovered after damage is done

**Proposed Solution**:
- Compression-based atypicality scoring on sliding windows
- No training data required, works immediately
- Anomalies logged to ERR0R collection for review

---

## Research Source

ArXiv 1709.03189 - Data Discovery and Anomaly Detection Using Atypicality

Key insight: Atypical data can be encoded with fewer bits using its own code rather than the typical data code. This provides a principled, parameter-free approach.

---

## Specification

### Requirements

1. **ANOMALY-001**: Sliding window of last 50 jackpot values
   - **Priority**: Must
   - **Acceptance Criteria**: Window updates on each new reading

2. **ANOMALY-002**: Compression-based scoring using GZipStream
   - **Priority**: Must
   - **Acceptance Criteria**: Score calculated in under 5ms

3. **ANOMALY-003**: Threshold alerting to ERR0R collection
   - **Priority**: Must
   - **Acceptance Criteria**: Anomalies appear in ERR0R within 1 cycle

### Technical Details

- Use System.IO.Compression for GZip/Deflate
- Sliding window via Queue of double
- Atypicality ratio: compressed size divided by expected size
- Fallback: standard deviation greater than 3 from mean

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-025-1 | Create AtypicalityScore.cs | WindFixer | Pending | 10 |
| ACT-025-2 | Create AnomalyDetector.cs | WindFixer | Pending | 10 |
| ACT-025-3 | Integrate with H0UND main loop | WindFixer | Pending | 8 |
| ACT-025-4 | Add threshold config | WindFixer | Pending | 6 |

---

## Files

- C0MMON/Support/AtypicalityScore.cs (new)
- H0UND/Services/AnomalyDetector.cs (new)
- C0MMON/Entities/AnomalyEvent.cs (new)

---

## Dependencies

- **Blocks**: None
- **Blocked By**: None
- **Related**: DECISION_026, DECISION_028

---

## Designer Strategy

### Phase 1: Core Implementation
1. Create AtypicalityScore.cs - compression ratio calculation
2. Create AnomalyDetector.cs - wire into jackpot stream
3. Implement sliding window buffer using Queue
4. Calculate compression ratio

### Phase 2: Integration
1. Integrate with H0UND main loop after each DPD calculation
2. Add threshold config in appsettings.json
3. Log anomalies to ERR0R collection

### Validation
Run against 1000+ historical jackpot sequences to validate detection rate.

---

## Consultation Log

### Oracle Consultation
- **Date**: 2026-02-20
- **Approval**: 98%
- **Feasibility**: 10/10
- **Risk**: 2/10
- **Complexity**: 2/10
- **Key Findings**: Minimal risk, non-intrusive, parameter-free

### Designer Consultation
- **Date**: 2026-02-20
- **Approval**: Approved
- **Key Findings**: Sequential implementation recommended, statistical fallback included

---

*Decision DECISION_025 - Atypicality-Based Anomaly Detection - 2026-02-20*