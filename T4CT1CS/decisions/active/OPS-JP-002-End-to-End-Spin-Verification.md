# OPS-JP-02: End-to-End Spin Verification

**Decision ID**: OPS-JP-002  
**Category**: Operations/Verification  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-20  

---

## Executive Summary

Perform a comprehensive end-to-end test of the entire CDP-based jackpot execution pipeline, from the generation of a simulated H0UND signal to the successful execution of the CDP spin by H4ND, and the logging of the result. This verifies the complete integration of TECH-H4ND-001, TECH-FE-015, TECH-JP-001, TECH-JP-002, and OPS-JP-001.

---

## Verification Steps (OpenFixer Task)

### Phase 1: Pre-Flight Check
1.  **Host Setup**: Run `scripts/vm/Start-Chrome-CDP.ps1` on the host.
2.  **VM Setup**: Launch H4ND in the VM.
3.  **Health Check**: Confirm H4ND logs `CdpHealthCheck.CheckHealthAsync()` result as **Healthy**.

### Phase 2: Signal Generation and Execution
1.  **H0UND Simulation**: Manually inject a test signal into the `SIGN4L` MongoDB collection using a tool like MongoDB Compass or mongosh.
    -   Signal content must target a specific `Credential` with a `Priority` > 0.90 (e.g., Grand Jackpot).
2.  **Pipeline Flow**: Monitor H4ND console output:
    -   [EventBus] Command published (Signal mapped to VisionCommand)
    -   [Pipeline] START Spin command for User@Game
    -   [Validation] Passed
    -   [Idempotency] Passed
    -   [CircuitBreaker] Closed
    -   [CdpClient] Sending Input.dispatchMouseEvent to spin button coordinates
3.  **Visual Confirmation**: Visually confirm the Chrome browser window (on the host) executes the spin click.

### Phase 3: Post-Spin Logging
1.  **Acknowledge**: Verify the signal is acknowledged in the `SIGN4L` collection.
2.  **Metrics**: Query the `SpinHealthEndpoint` (port 9280) and confirm the `SpinMetrics` recorded one successful spin with latency < 5s and `SuccessRate` = 100%.
3.  **Balance**: Confirm the credential's balance was updated in the `CR3D3N7IAL` collection (using existing WebSocket logic).

---

## Success Criteria

- [ ] H4ND starts successfully after passing CDP health check.
- [ ] Simulated signal executes the spin in the host browser via CDP.
- [ ] Spin is logged as successful in `SpinMetrics`.
- [ ] Total latency from signal insertion to spin completion is **< 5 seconds**.

---

*OPS-JP-002: End-to-End Spin Verification*  
*Status: Proposed*  
*2026-02-20*