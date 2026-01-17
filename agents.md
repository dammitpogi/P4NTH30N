# AGENTS: P4NTH30N Engineering Conventions

This document defines the conventions and structures we want normalized across the codebase.

## 1) Architecture & Structure
- **Keep behavior with the data it acts on.** Prefer methods on domain objects (`CredentialRecord`, `JackpotRecord`, `SignalRecord`) for lifecycle actions (`Save`, `Lock`, `Unlock`, `Acknowledge`, `Delete`), instead of scattering free functions.
- **Define one “owner” class per workflow.** When a workflow spans multiple steps (e.g., reading jackpots and updating records), centralize the orchestration in a single class or service, and keep helper methods inside that class.
- **Separate orchestration from low-level automation.**
  - Orchestrators (`H4ND`, `HUN7ER`) should remain high level.
  - UI automation logic belongs in `C0MMON/Credentials/*` and should expose clear, testable public methods.

## 2) Data Modeling
- **Credential-first.** The primary key for iteration is the credential/account, not the game. New code should favor `CredentialRecord`, `JackpotRecord`, and `SignalRecord` (`*_New` collections).
- **Do not introduce new dependencies on `Game` unless unavoidable.** If you must touch legacy code, include a note on how it will be removed during migration.
- **Always update timestamps and toggles together.** Any lock/unlock or reset flow should update the relevant `Dates` + `Toggles` fields together to keep queueing logic consistent.

## 3) Code Style
- **C# conventions:** prefer explicit names, avoid overly long methods (>150 lines), and keep logic blocks small and focused.
- **No try/catch around imports.**
- **Comment intent, not mechanics.** Comments should explain why a decision exists or what a guard condition prevents.

## 4) Experiment Discipline (per project principle)
When we change logic or prediction rules:
1. **Form a falsifiable hypothesis** (what we believe will happen).
2. **Define success/failure criteria** (what data confirms or rejects the hypothesis).
3. **Run the smallest possible experiment** (ideally against MongoDB data first).
4. **Record findings** in the README or a dedicated experiment log: what you tried, why, what data showed.
5. **Normalize wins** into clean, maintainable code once the signal is resilient.

## 5) Suggested Normalized Patterns
- **Entity lifecycle methods:**
  - `Save`, `Lock`, `Unlock`, `Acknowledge`, `Delete` live on the entity.
  - Any update should happen on a complete object snapshot, then saved.
- **Signal flow:**
  - Generate signals in analytics (HUN7ER), consume and acknowledge in automation (H4ND).
  - Signal priority escalations should be explicit and logged.
- **Jackpot updates:**
  - Use a single function (per credential) to update jackpot values, DPD history, and reset detection.
  - Keep pop-detection logic consistent across both legacy and new flows.

## 6) Open Questions / Alternatives
- If we want more separation than “methods on objects,” we can introduce **domain services** (e.g., `JackpotUpdater`, `SignalPlanner`) while still keeping persistence on the entity. This can make orchestration easier to test without splitting logic into static helpers.
