# P4NTH30N Platform Overview

## Purpose
P4NTH30N is a multi-process automation platform built in C# that coordinates **jackpot discovery**, **signal generation**, and **automated spins** for supported casino game portals. The core of the system is two always-on workers that run together:

- **H4ND**: Executes automation in the browser (login, navigate, read jackpot values, spin). It consumes `SIGN4L` signals and updates MongoDB with jackpot and balance telemetry.
- **HUN7ER**: Computes growth rates (DPD), forecasts jackpot timing, and emits `SIGN4L` signals when thresholds are near.

This repo also contains supporting services/tools (e.g., W4TCHD0G, H0UND, H5ND, PROF3T) plus a shared library, **C0MMON**, that houses all shared entities, automation primitives, and MongoDB access.

## High-level architecture

```
HUN7ER (analytics loop)
  ├─ reads CRED3N7IAL (credentials)
  ├─ builds DPD + forecasts jackpots
  └─ writes SIGN4L + J4CKP0T (signals + predictions)

H4ND (automation loop)
  ├─ pulls SIGN4L (or N3XT queue if no signal)
  ├─ logs in via Selenium + input simulation
  ├─ reads jackpot/balance values via JS
  └─ updates G4ME / CRED3N7IAL data
```

## Core components

### H4ND (automation worker)
Entry point: `H4ND/H4ND.cs`

- Launches Chrome and loads a local extension + override rules.
- Picks the highest-priority signal (or next queue game) and grabs a credential.
- Logs into the specified game portal (FireKirin / OrionStars).
- Reads `window.parent.*` jackpot + balance values via JS.
- If a signal is active, performs slot spins and then updates thresholds.
- Updates credential balance and unlocks the game for the next worker.

### HUN7ER (analytics worker)
Entry point: `HUN7ER/HUN7ER.cs`

- Iterates all credentials, calculates DPD (dollars per day).
- Forecasts jackpot estimates and writes `J4CKP0T` entries.
- Emits `SIGN4L` signals when thresholds are near or imminent.
- Prints a console dashboard with ETA and funding recommendations.

### C0MMON (shared library)
Location: `C0MMON/`

Contains:
- **Entities**: `Game`, `Credential`, `Signal`, `Jackpot`, and “New*” migration types.
- **MongoDB access**: `Database.cs`.
- **Automation primitives**: `Mouse`, `Keyboard`, `Screen`.
- **Game helpers**: FireKirin / OrionStars and slot game helpers.

## Data model (MongoDB collections)

| Collection | Owner | Purpose |
| --- | --- | --- |
| `CRED3N7IAL` | C0MMON.Credential | Credential + balance + DPD storage |
| `G4ME` | C0MMON.Game | Game-level jackpot & thresholds |
| `SIGN4L` | C0MMON.Signal | Signal requests for H4ND |
| `J4CKP0T` | C0MMON.Jackpot | Jackpot forecast rows |
| `N3XT` | C0MMON.Game | Queue used for H4ND non-signal polling |
| `M47URITY` | C0MMON.Game | Queue age timestamps |

> Note: “New*” types are present for a credential-centric migration (see below), with `*_New` collections referenced in code.

## Runtime flow summary

1. **HUN7ER** reads credentials → calculates DPD → predicts jackpots → writes signals.
2. **H4ND** polls signals → logs in → reads jackpot values → spins and updates DB.
3. **Signals** auto-expire if not acknowledged; both workers maintain locks/timeouts.

## Running locally (high level)

> This repo assumes a Windows host, Selenium, a Chrome extension, and a reachable MongoDB.

- Build all projects using the solution (`P4NTH30N.sln`) or project files.
- Launch **HUN7ER** and **H4ND** together.
- H4ND supports `H0UND` mode to disable signal listening for manual runs.

## Versioning

H4ND currently prints a **hard-coded version** in the Figgle banner. A centralized versioning plan is recommended (Directory.Build.props + shared `AppVersion` helper) to ensure consistent reporting across processes.

## Migration status: Game → Credential

The codebase includes “New*” entities (e.g., `NewCredential`, `NewSignal`) and “New*” game helpers in `C0MMON/Games/* copy.cs`. This indicates an in-progress migration away from a `Game`-centric flow toward credential-centric iterations. The current runtime still uses legacy entities.

Recommended next steps:
- Introduce adapters/feature flags to allow dual-operation.
- Validate new collection integrity before hard cutover.
- Retire legacy classes when parity is confirmed.

## Repo layout (top-level)

- `C0MMON/` – shared library
- `H4ND/` – automation worker
- `HUN7ER/` – analytics worker
- `HUN7ERv2/`, `H5ND/`, `H0UND/` – sibling tools/experiments
- `W4TCHD0G/`, `PROF3T/`, `M4NUAL/` – supporting tools
- `RUL3S/` – static resources/overrides used by automation

## Contributing notes

- Prefer object-centric behavior where possible (methods on domain entities).
- Extract services or helpers when object responsibilities become large.
- Keep coordinates and automation constants close to their owning game helper.
- Document edge cases and failure modes near the logic that handles them.

