# Gemini Context: P4NTH30N Platform

This document provides a comprehensive overview of the P4NTH30N project, its architecture, and development conventions to guide future interactions.

## Project Overview

P4NTH30N is a sophisticated, multi-agent automation platform written in C#/.NET. Its primary purpose is to interact with online casino game portals, specifically **FireKirin** and **OrionStars**.

The system is designed to:
1.  **Discover Jackpots:** Automatically retrieve jackpot and player balance information.
2.  **Generate Signals:** Analyze jackpot growth rates (termed "DPD" - Dollars Per Day) to forecast when a jackpot is likely to hit.
3.  **Automate Gameplay:** Consume the generated signals to perform automated spins on specific games.

The platform's architecture is event-driven, with two primary worker agents communicating asynchronously via a shared **MongoDB** database:

*   **`H0UND` (Analytics + Polling):** Polls credentials for jackpot/balance telemetry, builds forecasting models (DPD), and emits `SIGN4L` records to trigger the automation agent.
*   **`H4ND` (The Hands):** The automation agent. It listens for `SIGN4L` records from the database. When a signal is received, it uses a combination of **Selenium** (for login/navigation) and direct **HTTP/WebSocket** communication to interact with the game, read data, and execute spins.

The entire system is comprised of multiple projects within a single .NET solution, with `C0MMON` acting as a shared library for entities, database access, and core utilities.

## Building and Running

### Building the Solution

The project is a standard .NET solution. To build all projects, run the following command from the root directory:

```shell
dotnet build P4NTH30N.slnx
```

### Running the Platform

The P4NTH30N platform requires at least two agents to be running concurrently. You will need to open two separate terminals.

**Terminal 1: Run the `H0UND` (Polling + Analytics Agent)**
```shell
dotnet run --project ./H0UND/H0UND.csproj
```

**Terminal 2: Run the `H4ND` (Automation Agent)**
```shell
dotnet run --project ./H4ND/H4ND.csproj
```

*   **`H0UND` Mode:** The `H4ND` agent can be run in a manual mode that ignores signals by passing the `H0UND` argument: `dotnet run --project ./H4ND/H4ND.csproj H0UND`

### Verification Steps

Before operating the platform, verify it’s properly configured:

```bash
# 1. Verify build
dotnet build P4NTH30N.slnx --no-restore
# Check: No errors or warnings (except nullable warnings if enabled)

# 2. Verify formatting
dotnet csharpier . --check
# Check: Exit code 0 means formatted correctly

# 3. Run tests
dotnet test UNI7T35T/UNI7T35T.csproj
# Check: All tests pass (exit code 0)

# 4. Verify dependencies
dotnet restore P4NTH30N.slnx
# Check: All packages restore successfully

# 5. Runtime verification
dotnet run --project ./H0UND/H0UND.csproj -- --dry-run
dotnet run --project ./H4ND/H4ND.csproj -- --dry-run
# Check: Agents start without errors and initialize properly
```

### Testing

The project includes a dedicated test suite in `UNI7T35T/`. Run tests with:

```bash
# Run all tests
dotnet test UNI7T35T/UNI7T35T.csproj

# Run tests with coverage reporting
dotnet test UNI7T35T/UNI7T35T.csproj --collect:"XPlat Code Coverage"

# Run a specific test class
 dotnet test UNI7T35T/UNI7T35T.csproj --filter "FullyQualifiedName~TestClassName"

# Watch mode for TDD (auto-re-run on file changes)
dotnet watch test --project ./UNI7T35T/UNI7T35T.csproj
```

## Development Conventions

*   **Project Naming:** Projects follow a unique `L33T`-speak naming convention (e.g., `C0MMON`, `H4ND`, `H0UND`, `C0RR3CT`).
*   **Shared Kernel Architecture:** The `C0MMON` project serves as a shared kernel, containing all cross-cutting concerns:
    *   **Entities:** Located in `C0MMON/Entities`, these classes map directly to MongoDB collections (e.g., `Credential`, `Game`, `Signal`).
    *   **Database Logic:** `C0MMON/Database.cs` contains the static `Database` class for all MongoDB interactions.
    *   **Game Logic:** Game-specific functionality is encapsulated in static helper classes within `C0MMON/Games/` (e.g., `FireKirin.cs`, `OrionStars.cs`).
*   **Data-Driven Logic:** The agents are stateless and operate based on data retrieved from MongoDB. This is a core architectural principle.
*   **Tier Suppression (Spin* Caps):** Credentials include per-tier Spin settings (`SpinGrand/Major/Minor/Mini`) that gate whether a tier is eligible for forecasting/signals. If a tier threshold exceeds sanity caps (Mini > 30, Minor > 134, Major > 630, Grand > 1800), that tier is automatically disabled by setting the corresponding `Spin* = false` during credential persistence. Data collection + DPD continue.
*   **Technology Mix:** The platform uses a clever mix of technologies. Selenium is used only for the initial UI interaction (login/navigation), while the more critical jackpot data is retrieved via more reliable, direct API calls (HTTP/WebSockets), as seen in `FireKirin.cs`.
*   **In-Progress Migration:** The presence of "New\*" entities (e.g., `Credential New.cs`) and copied game logic files (`FireKirin New.cs`) indicates an ongoing refactoring effort to move from a game-centric data model to a credential-centric one. This is an important consideration for any future changes.
*   **Configuration:** The system relies on a reachable MongoDB instance. Default connection settings come from environment variables: `P4NTH30N_MONGODB_URI` and `P4NTH30N_MONGODB_DB`. H0UND analytics reads can be switched with `H0UND_ANALYTICS_STORE=EF|MONGO` (default: `EF`).
