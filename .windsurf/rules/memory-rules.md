# P4NTH30N Memory Rules

## Auto-Generated Memories

Cascade should automatically remember:

1. **Project Structure**: P4NTH30N is a multi-agent C# platform with H0UND, H4ND, C0MMON, W4TCHD0G, PROF3T
2. **Build System**: `dotnet build P4NTH30N.slnx`, target framework `net10.0-windows7.0`
3. **Formatting**: CSharpier (`dotnet csharpier .`), tabs width 4, K&R braces, max 170 chars
4. **Testing**: `dotnet test UNI7T35T/UNI7T35T.csproj`
5. **Database**: MongoDB with collections CRED3N7IAL, G4ME, SIGN4L, J4CKP0T, N3XT, M47URITY, EV3NT, ERR0R, H0U53
6. **Code Style**: No `var`, PascalCase public, _camelCase private, file-scoped namespaces
7. **Error Pattern**: Always log line numbers via StackTrace, include context in exception messages

## Context Priorities

When working in this repo, prioritize context from:
1. `AGENTS.md` files in each project directory
2. `codemap.md` files for structural understanding
3. `.editorconfig` for formatting rules
4. Existing interfaces in `C0MMON/Interfaces/` for contracts

## Behavior Customization

- **Concise execution**: No preamble, brief delegation notices
- **Honest pushback**: Flag problematic approaches
- **Build verification**: Always verify builds compile after changes
- **Validation pattern**: Use `IsValid(IStoreErrors?)` for entity validation
- **No auto-repair**: Log to ERR0R collection, don't auto-fix data
