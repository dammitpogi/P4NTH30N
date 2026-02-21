# OPS-JP-003: Failure Recovery Verification

**Decision ID**: OPS-JP-003  
**Category**: Operations/Verification  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-20  

---

## Executive Summary

Verify the failure and recovery mechanisms built into the CDP pipeline. Specifically, test the Circuit Breaker, CdpClient Auto-Reconnect, and Dead Letter Queue functionality.

---

## Verification Steps (OpenFixer Task)

### Test 1: Dead Letter Queue (DLQ) Validation
1.  **Simulate Invalid Command**: Manually inject a `VisionCommand` with `Confidence = 0.50` (or `TargetUsername = null`) directly into the `InMemoryEventBus` (for testing purposes).
2.  **Expected Outcome**:
    -   `ValidationMiddleware` blocks the command.
    -   Command is sent to the `V1S10N_DLQ` collection.
    -   H4ND logs: `[Pipeline] Validation failed, sending to DLQ.`
    -   The spin is **not** executed in the browser.

### Test 2: Circuit Breaker and Auto-Reconnect
1.  **Simulate Failure**: Initiate a command loop (e.g., repeatedly insert a valid spin signal).
2.  **Kill Chrome**: After 3 commands are acknowledged, manually **close the Chrome browser** on the host machine.
3.  **Expected Outcome**:
    -   The next 5 commands attempt to execute and fail the `CdpClient.SendCommandAsync()`.
    -   `CdpClient` attempts 3 exponential backoff reconnects, then fails.
    -   After 5 consecutive failures, the **Circuit Breaker Opens**.
    -   `H4ND` logs: `[CircuitBreaker] Opened after 5 failures. Sending subsequent commands to DLQ.`
    -   Subsequent signals are immediately sent to the `V1S10N_DLQ` by the `CircuitBreakerMiddleware` without attempting execution.

### Test 3: Circuit Recovery
1.  **Restart Chrome**: Relaunch Chrome with the CDP port enabled on the host.
2.  **Expected Outcome**:
    -   After the 60-second recovery timeout, the Circuit Breaker transitions to **Half-Open**.
    -   The next command is attempted.
    -   If successful, the Circuit Breaker resets to **Closed**.
    -   `CdpClient` successfully re-connects via its auto-reconnect logic.

---

## Success Criteria

- [ ] Command Pipeline correctly routes invalid commands to DLQ.
- [ ] Circuit Breaker opens after the threshold is met when the host Chrome is killed.
- [ ] CdpClient's auto-reconnect mechanism functions correctly.
- [ ] Circuit Breaker resets successfully after the host Chrome is restored.

---

*OPS-JP-003: Failure Recovery Verification*  
*Status: Proposed*  
*2026-02-20*