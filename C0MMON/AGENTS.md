# C0MMON Project Structure

## Responsibility

C0MMON provides shared infrastructure, domain logic, and cross-cutting concerns for the P4NTH30N ecosystem. This project contains reusable components that enable automation, analytics, and monitoring across all agents.

## When Working in C0MMON

- **Maintain SOLID principles**: Single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion
- **Follow DDD patterns**: Entities are in root namespace, interfaces define contracts, infrastructure implements persistence
- **Use explicit types**: Avoid `var`, use predefined types (`int` not `Int32`)
- **Enable nullable reference types**: Always check for null on reference types
- **Prefer primary constructors** and file-scoped namespaces
- **Validation first**: Use `IsValid(IStoreErrors?)` pattern, log errors to ERR0R collection, never auto-repair

## Code Style

- **Line endings**: CRLF (Windows)
- **Indentation**: Tabs (width 4)
- **Line length**: Maximum 170 characters
- **Braces**: Same line (K&R style)
- **Naming**: PascalCase for public members, _camelCase for private fields

## Key Patterns

- **Repository Pattern**: IRepo<Entity> interfaces with MongoDB implementations
- **Unit of Work**: MongoUnitOfWork for atomic operations
- **Validation**: Entities implement IsValid with optional error logging
- **Error Handling**: Always log line numbers for debugging using StackTrace

## MongoDB Collections

- **EV3NT**: Event data (signals, game events)
- **CR3D3N7IAL**: User credentials and settings
- **ERR0R**: Validation errors and processing failures
- **H0U53**: House/location organization data

## Integration Points

- Used by H4ND (automation agent)
- Used by H0UND (analytics agent)
- Shared infrastructure for all P4NTH30N agents
- Provides domain entities, repositories, and services

## Important Notes

- Credentials currently stored in plain text (automation priority)
- Future hardening planned: encryption, credential vault, access controls
- Never delete codemap.md files or .slim/cartography.json
- Run Cartography update after structural changes: `python3 ~/.config/opencode/skills/cartography/scripts/cartographer.py update --root ./`
