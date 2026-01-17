# P4NTH30N

## Overview
P4NTH30N is a two-process automation + analytics system that watches slot jackpots for individual player credentials, decides when a jackpot is approaching, and triggers automated spins when signals fire. The system is written in C# and backed by MongoDB. It is currently in transition from the older **Game**-centric data model to a **Credential**-centric model (one account at a time) so that iterations run directly over credentials instead of games. 【F:H4ND/H4ND.cs†L26-L191】【F:C0MMON/Entities/Game.cs†L1-L169】【F:C0MMON/Entities/CredentialRecord.cs†L1-L108】

### Programs
- **H4ND** (automation runner):
  - Launches a ChromeDriver session, logs into a credential, reads jackpot and balance values from the game’s shared frame, and updates MongoDB records.
  - Responds to **Signal** records (priority-based) to spin when a jackpot is approaching.
  - Handles FireKirin and OrionStars flows, including login, slot selection, spin, and logout.
  - Uses the **CredentialRecord** model to iterate credential-by-credential instead of iterating `Game` records. 【F:H4ND/H4ND.cs†L18-L191】【F:C0MMON/Entities/CredentialRecord.cs†L1-L108】
- **HUN7ER** (analytics + signaling loop):
  - Continuously computes DPD (dollars-per-day) and jackpot timing predictions from historical jackpot growth.
  - Creates/updates **Jackpot** predictions and emits **Signal** records when a jackpot is close enough to justify spinning.
  - Currently operates on the legacy **Credential** model and **Jackpot** records (the older collections). 【F:HUN7ER/HUN7ER.cs†L8-L285】【F:C0MMON/Entities/Credential.cs†L1-L121】【F:C0MMON/Entities/Jackpot.cs†L1-L121】

## Architecture Map

### Shared Library (C0MMON)
C0MMON provides shared domain models, database access, UI automation helpers, and per-game slot flows.

- **Database**
  - MongoDB connector used by all entities (debug + release connection strings). 【F:C0MMON/Database.cs†L1-L20】
- **Entities (legacy)**
  - `Game`, `Credential`, `Jackpot`, `Signal` power the original pipeline, which grouped work by game. 【F:C0MMON/Entities/Game.cs†L1-L169】【F:C0MMON/Entities/Credential.cs†L1-L121】【F:C0MMON/Entities/Jackpot.cs†L1-L121】【F:C0MMON/Entities/Signal.cs†L1-L139】
- **Entities (credential-first)**
  - `CredentialRecord`, `JackpotRecord`, `SignalRecord` are newer credential-first counterparts.
  - These are used by H4ND today and are intended to power the next iteration of the pipeline. 【F:C0MMON/Entities/CredentialRecord.cs†L1-L147】【F:C0MMON/Entities/JackpotRecord.cs†L1-L105】【F:C0MMON/Entities/SignalRecord.cs†L1-L145】
- **Automation Helpers**
  - `Actions`, `Screen`, `Mouse`, and `Keyboard` provide low-level control.
  - `FireKirinFlow`, `FortunePiggyFlow`, `Gold777Flow`, `OrionStars` implement game-specific login/spin flows. 【F:C0MMON/Actions/Launch.cs†L1-L24】【F:C0MMON/Screen.cs†L1-L92】【F:C0MMON/Mouse.cs†L1-L55】【F:C0MMON/Keyboard.cs†L1-L43】【F:C0MMON/Credentials/FireKirinFlow.cs†L1-L104】

### Data Model + Collections
| Model | Collection | Purpose | Used by |
| --- | --- | --- | --- |
| `Credential` | `CRED3N7IAL` | Legacy account-level data (DPD, thresholds, settings). | HUN7ER | 【F:C0MMON/Entities/Credential.cs†L1-L121】 |
| `CredentialRecord` | `CRED3N7IAL_New` | Credential-first replacement for `Game` iteration. | H4ND, HUN7ERv2 | 【F:C0MMON/Entities/CredentialRecord.cs†L1-L108】 |
| `Game` | `G4ME` | Legacy game-level iteration object; slated for removal. | HUN7ER (indirect), older flows | 【F:C0MMON/Entities/Game.cs†L1-L169】 |
| `Jackpot` | `J4CKP0T` | Legacy jackpot predictions for `Game`. | HUN7ER | 【F:C0MMON/Entities/Jackpot.cs†L1-L121】 |
| `JackpotRecord` | `J4CKP0T_New` | Credential-level jackpot tracking + DPD history. | H4ND | 【F:C0MMON/Entities/JackpotRecord.cs†L1-L105】 |
| `Signal` / `SignalRecord` | `SIGN4L` | Spin signal queue (priority-driven). | H4ND + HUN7ER | 【F:C0MMON/Entities/Signal.cs†L1-L139】【F:C0MMON/Entities/SignalRecord.cs†L1-L145】 |

## Runtime Flow

### H4ND (automation runner)
1. Launch ChromeDriver and navigate to a game URL based on the credential’s game. 【F:H4ND/H4ND.cs†L26-L96】
2. Choose the next credential to process:
   - If a signal exists, load the matching credential by username.
   - Otherwise, pull the next unlocked credential by least-recently-updated timestamp. 【F:H4ND/H4ND.cs†L40-L61】【F:C0MMON/Entities/CredentialRecord.cs†L33-L52】
3. Lock the credential (prevents another worker from reusing it) and handle login flows. 【F:H4ND/H4ND.cs†L67-L113】【F:C0MMON/Entities/CredentialRecord.cs†L62-L78】
4. Read jackpot values via `window.parent.*`, update credential balance/timestamps, and persist to MongoDB. 【F:H4ND/H4ND.cs†L118-L157】
5. Update per-credential jackpot history and pop-detection logic in `UpdateJackpot` (supports reset detection and signal cleanup). 【F:H4ND/H4ND.cs†L162-L219】
6. If a signal is active, run the spin flow for the corresponding game, log completion, and handle optional override signals. 【F:H4ND/H4ND.cs†L159-L191】
7. Unlock the credential and logout to prepare for the next iteration. 【F:H4ND/H4ND.cs†L193-L205】

### HUN7ER (analytics + signaling)
1. Load all credentials (legacy collection) and normalize property defaults. 【F:HUN7ER/HUN7ER.cs†L14-L20】【F:C0MMON/Entities/Credential.cs†L33-L44】
2. Update per-credential cashed-out state, unlock timed-out accounts, and maintain DPD history from jackpot deltas. 【F:HUN7ER/HUN7ER.cs†L22-L87】
3. For each enabled credential, generate jackpot predictions (grand/major/minor/mini) and compute estimated dates. 【F:HUN7ER/HUN7ER.cs†L89-L146】
4. Emit `Signal` records when predicted jackpots fall inside time/balance thresholds; upgrade priority if a higher signal arrives. 【F:HUN7ER/HUN7ER.cs†L147-L203】
5. Print an operational summary table with ETA, DPD, and potential bankroll recommendations. 【F:HUN7ER/HUN7ER.cs†L205-L284】

## Running the Programs
- H4ND:
  ```bash
  dotnet run --project H4ND/H4ND.csproj
  ```
- HUN7ER:
  ```bash
  dotnet run --project HUN7ER/HUN7ER.csproj
  ```

> Both programs expect MongoDB access (see `C0MMON/Database.cs`) and a UI automation environment for ChromeDriver + screen pixel reads. 【F:C0MMON/Database.cs†L1-L20】【F:C0MMON/Screen.cs†L1-L92】

## Migration Notes: Removing `Game`
The `Game` object is being phased out so the iteration loop can run directly over credentials:
- H4ND already operates on `CredentialRecord` and `JackpotRecord` (`*_New` collections).
- HUN7ER still uses the legacy `Credential`, `Jackpot`, and `Signal` flow.
- The next step is to port HUN7ER’s prediction + signaling to `CredentialRecord` + `JackpotRecord`, then retire `Game` and the legacy collections. 【F:H4ND/H4ND.cs†L40-L219】【F:HUN7ER/HUN7ER.cs†L14-L203】【F:C0MMON/Entities/CredentialRecord.cs†L1-L108】【F:C0MMON/Entities/JackpotRecord.cs†L1-L105】

## Where to Look Next
- `C0MMON/Entities/*` for data structures + DB schema.
- `C0MMON/Credentials/*` for game-specific automation flows.
- `H4ND/H4ND.cs` and `HUN7ER/HUN7ER.cs` for the runtime loops and orchestration. 【F:C0MMON/Entities/CredentialRecord.cs†L1-L108】【F:C0MMON/Credentials/FireKirinFlow.cs†L1-L104】【F:H4ND/H4ND.cs†L18-L219】【F:HUN7ER/HUN7ER.cs†L8-L285】
