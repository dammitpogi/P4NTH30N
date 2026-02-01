# Plan: Sync H0UND/H4ND & Implement GUI

The goal is to synchronize the `H0UND` codebase with the recent advancements in `H4ND` (VPN, Security, Reliability) and implement a textual GUI (TUI) for better observability.

## Tasks

- [ ] **Analyze H0UND**
  - [ ] Compare `H0UND` vs `H4ND` structure.
  - [ ] Identify missing features (VPN, Retry, Security).
- [ ] **Sync Methodologies**
  - [ ] Integrate `VPNService` into `H0UND`.
  - [ ] Apply Security Fixes (Remove password logs).
  - [ ] Apply Reliability Fixes (Retry loops, Crash prevention).
- [ ] **Implement GUI (Spectre.Console)**
  - [ ] Add `Spectre.Console` package to `C0MMON` (or individual projects).
  - [ ] Create `Dashboard` class in `C0MMON`.
  - [ ] Update `H4ND` and `H0UND` to use `Dashboard` instead of `Console.WriteLine`.
  - [ ] Features: Event Log Table, Status Header, Balance Grid.

## Technical Details

**H0UND Role**: Retrieval-only. It likely queries balances but doesn't execute spins (Signals).
**GUI Approach**:
- Use `Spectre.Console` for rich output.
- Replace `Console.WriteLine` with a structured logging method that updates the UI.
- Use `AnsiConsole.Live` for real-time updates.

**Sync Checklist**:
- [ ] VPN Infinite Wait
- [ ] Self-Repair
- [ ] Password Masking
- [ ] WebSocket Retry Logic
