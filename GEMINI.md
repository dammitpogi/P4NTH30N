# Gemini Context: P4NTH30N Platform

This document provides a comprehensive overview of the P4NTH30N project, its architecture, and development conventions to guide future interactions.

## Project Overview

P4NTH30N is a sophisticated, multi-agent automation platform written in C#/.NET. Its primary purpose is to interact with online casino game portals, specifically **FireKirin** and **OrionStars**.

The system is designed to:
1.  **Discover Jackpots:** Automatically retrieve jackpot and player balance information.
2.  **Generate Signals:** Analyze jackpot growth rates (termed "DPD" - Dollars Per Day) to forecast when a jackpot is likely to hit.
3.  **Automate Gameplay:** Consume the generated signals to perform automated spins on specific games.

The platform's architecture is event-driven, with two primary worker agents communicating asynchronously via a shared **MongoDB** database:

*   **`HUN7ER` (The Brain):** The analytics agent. It continuously processes game data from the database, builds forecasting models, and emits `SIGN4L` records to trigger the automation agent.
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

**Terminal 1: Run the `HUN7ER` (Analytics Agent)**
```shell
dotnet run --project ./HUN7ER/HUN7ER.csproj
```

**Terminal 2: Run the `H4ND` (Automation Agent)**
```shell
dotnet run --project ./H4ND/H4ND.csproj
```

*   **`H0UND` Mode:** The `H4ND` agent can be run in a manual mode that ignores signals by passing the `H0UND` argument: `dotnet run --project ./H4ND/H4ND.csproj H0UND`

### Testing

The project does not currently contain a dedicated unit or integration test suite. Testing appears to be done through direct execution of the agents. A future improvement would be to create formal test projects for the business logic within the `C0MMON` library.

## Development Conventions

*   **Project Naming:** Projects follow a unique `L33T`-speak naming convention (e.g., `C0MMON`, `H4ND`, `HUN7ER`, `C0RR3CT`).
*   **Shared Kernel Architecture:** The `C0MMON` project serves as a shared kernel, containing all cross-cutting concerns:
    *   **Entities:** Located in `C0MMON/Entities`, these classes map directly to MongoDB collections (e.g., `Credential`, `Game`, `Signal`).
    *   **Database Logic:** `C0MMON/Database.cs` contains the static `Database` class for all MongoDB interactions.
    *   **Game Logic:** Game-specific functionality is encapsulated in static helper classes within `C0MMON/Games/` (e.g., `FireKirin.cs`, `OrionStars.cs`).
*   **Data-Driven Logic:** The agents are stateless and operate based on data retrieved from MongoDB. This is a core architectural principle.
*   **Technology Mix:** The platform uses a clever mix of technologies. Selenium is used only for the initial UI interaction (login/navigation), while the more critical jackpot data is retrieved via more reliable, direct API calls (HTTP/WebSockets), as seen in `FireKirin.cs`.
*   **In-Progress Migration:** The presence of "New\*" entities (e.g., `Credential New.cs`) and copied game logic files (`FireKirin New.cs`) indicates an ongoing refactoring effort to move from a game-centric data model to a credential-centric one. This is an important consideration for any future changes.
*   **Configuration:** The system relies on a reachable MongoDB instance. Connection strings and other configurations are likely hardcoded or stored in files not explicitly detailed here.
